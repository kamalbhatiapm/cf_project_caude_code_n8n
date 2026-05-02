-- CalmFalcon Supabase Database Schema
-- Run this in Supabase SQL Editor (fresh install)

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLE: themes
-- One row per theme per week
-- Dashboard reads this for all views
-- ============================================
CREATE TABLE themes (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    theme_id              TEXT UNIQUE NOT NULL,
    week_number           INTEGER NOT NULL,
    year                  INTEGER NOT NULL,

    -- Core display fields
    title                 TEXT NOT NULL,
    summary               TEXT NOT NULL,
    signal_type           TEXT NOT NULL CHECK (signal_type IN ('BREAKING', 'RISING', 'EMERGING', 'STABLE', 'DECLINING')),
    confidence_score      INTEGER NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 100),
    confidence_level      TEXT NOT NULL CHECK (confidence_level IN ('high', 'medium', 'low')),

    -- Theme detail view fields
    why_it_matters        TEXT,
    what_you_can_do       TEXT,

    -- Citations: [{signal_id, title, url, source_name, source_type, published_at}]
    -- Powers clickable source links in Theme Detail view
    citations             JSONB DEFAULT '[]',

    -- Supporting signal IDs (raw list from AI)
    supporting_signal_ids JSONB DEFAULT '[]',
    signal_count          INTEGER DEFAULT 0,

    -- Week-over-week continuity (used by dashboard for subtle "Continuing from last week" label)
    is_continuation       BOOLEAN  DEFAULT false,
    prev_confidence       INTEGER  DEFAULT NULL,   -- prior week's confidence score
    confidence_delta      INTEGER  DEFAULT NULL,   -- current minus prior (positive = growing)

    processed_at          TIMESTAMPTZ DEFAULT NOW(),
    created_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_themes_week         ON themes(year, week_number);
CREATE INDEX idx_themes_signal_type  ON themes(signal_type);
CREATE INDEX idx_themes_confidence   ON themes(confidence_score DESC);

-- ============================================
-- TABLE: weekly_briefs
-- One row per week — the generated markdown brief
-- ============================================
CREATE TABLE weekly_briefs (
    id                       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brief_id                 TEXT UNIQUE NOT NULL,
    week_number              INTEGER NOT NULL,
    year                     INTEGER NOT NULL,
    title                    TEXT,
    content                  TEXT,        -- full markdown brief
    key_takeaway             TEXT,        -- single sentence pulled from "💡 Key Takeaway" section
    total_themes             INTEGER DEFAULT 0,
    total_signals_processed  INTEGER DEFAULT 0,
    pipeline_run_id          TEXT,
    generated_at             TIMESTAMPTZ DEFAULT NOW(),
    pdf_url                  TEXT,
    created_at               TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(week_number, year)
);

CREATE INDEX idx_weekly_briefs_week ON weekly_briefs(year, week_number);

-- ============================================
-- TABLE: pipeline_runs
-- One row per execution — used for dashboard metrics header
-- ============================================
CREATE TABLE pipeline_runs (
    id                       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    run_id                   TEXT UNIQUE NOT NULL,
    completed_at             TIMESTAMPTZ NOT NULL,
    week_number              INTEGER NOT NULL,
    year                     INTEGER NOT NULL,
    total_themes             INTEGER DEFAULT 0,
    total_signals_processed  INTEGER DEFAULT 0,
    breaking_count           INTEGER DEFAULT 0,
    rising_count             INTEGER DEFAULT 0,
    emerging_count           INTEGER DEFAULT 0,
    stable_count             INTEGER DEFAULT 0,
    declining_count          INTEGER DEFAULT 0,
    avg_confidence           INTEGER DEFAULT 0,
    themes_summary           JSONB DEFAULT '[]',
    status                   TEXT DEFAULT 'completed' CHECK (status IN ('running', 'completed', 'failed')),
    error_message            TEXT,
    prompt_version_id        TEXT,              -- FK to prompt_versions.version_id
    created_at               TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_pipeline_runs_week      ON pipeline_runs(year, week_number);
CREATE INDEX idx_pipeline_runs_completed ON pipeline_runs(completed_at DESC);

-- ============================================
-- VIEW: current_week_themes
-- Dashboard default: this week's themes sorted by type + confidence
-- ============================================
CREATE OR REPLACE VIEW current_week_themes AS
SELECT t.*
FROM themes t
WHERE t.week_number = EXTRACT(WEEK FROM NOW())
  AND t.year        = EXTRACT(YEAR FROM NOW())
ORDER BY
    CASE t.signal_type
        WHEN 'BREAKING'  THEN 1
        WHEN 'RISING'    THEN 2
        WHEN 'EMERGING'  THEN 3
        WHEN 'STABLE'    THEN 4
        WHEN 'DECLINING' THEN 5
    END,
    t.confidence_score DESC;

-- ============================================
-- FUNCTION: get_dashboard_metrics(week, year)
-- Returns the 4 header metrics shown on the dashboard
-- total_signals_processed, active_clusters, breakout_signals, avg_confidence
-- ============================================
DROP FUNCTION IF EXISTS get_dashboard_metrics(integer, integer);
CREATE OR REPLACE FUNCTION get_dashboard_metrics(p_week INTEGER, p_year INTEGER)
RETURNS TABLE (
    total_signals_processed BIGINT,
    active_clusters         BIGINT,
    breakout_signals        BIGINT,
    avg_confidence          NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(
            (SELECT pr.total_signals_processed
             FROM pipeline_runs pr
             WHERE pr.week_number = p_week AND pr.year = p_year
             ORDER BY pr.completed_at DESC LIMIT 1),
            0
        )::BIGINT,
        COUNT(t.*)::BIGINT,
        COUNT(*) FILTER (WHERE t.signal_type IN ('BREAKING', 'RISING'))::BIGINT,
        COALESCE(ROUND(AVG(t.confidence_score), 1), 0)
    FROM themes t
    WHERE t.week_number = p_week AND t.year = p_year;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- FUNCTION: get_themes_by_week(week, year)
-- Returns all theme fields needed by Theme Detail view
-- ============================================
DROP FUNCTION IF EXISTS get_themes_by_week(integer, integer);
CREATE OR REPLACE FUNCTION get_themes_by_week(p_week INTEGER, p_year INTEGER)
RETURNS TABLE (
    theme_id         TEXT,
    title            TEXT,
    summary          TEXT,
    signal_type      TEXT,
    confidence_score INTEGER,
    confidence_level TEXT,
    why_it_matters   TEXT,
    what_you_can_do  TEXT,
    citations        JSONB,
    signal_count     INTEGER,
    is_continuation  BOOLEAN,
    prev_confidence  INTEGER,
    confidence_delta INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.theme_id, t.title, t.summary, t.signal_type,
        t.confidence_score, t.confidence_level,
        t.why_it_matters, t.what_you_can_do,
        t.citations, t.signal_count,
        t.is_continuation, t.prev_confidence, t.confidence_delta
    FROM themes t
    WHERE t.week_number = p_week AND t.year = p_year
    ORDER BY
        CASE t.signal_type
            WHEN 'BREAKING'  THEN 1
            WHEN 'RISING'    THEN 2
            WHEN 'EMERGING'  THEN 3
            WHEN 'STABLE'    THEN 4
            WHEN 'DECLINING' THEN 5
        END,
        t.confidence_score DESC;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TABLE: prompt_versions
-- One row per unique prompt set — linked to pipeline_runs for traceability
-- Run: ALTER TABLE pipeline_runs ADD COLUMN IF NOT EXISTS prompt_version_id TEXT;
-- ============================================
CREATE TABLE IF NOT EXISTS prompt_versions (
    id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    version_id           TEXT UNIQUE NOT NULL,  -- e.g. "pv-794e6118"
    version_label        TEXT,                  -- human label e.g. "v1.2 — added specificity test"
    main_agent_prompt    TEXT NOT NULL,
    verifier_prompt      TEXT NOT NULL,
    brief_writer_prompt  TEXT NOT NULL,
    notes                TEXT,                  -- what changed vs prior version
    created_at           TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_prompt_versions_created ON prompt_versions(created_at DESC);

-- ============================================
-- TABLE: eval_reports
-- One row per eval run — stores both automated and LLM judge results
-- Run: ALTER TABLE only if table already exists from a prior schema run
-- ============================================
CREATE TABLE IF NOT EXISTS eval_reports (
    id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eval_type        TEXT NOT NULL CHECK (eval_type IN ('automated', 'llm_judge')),
    week_number      INTEGER NOT NULL,
    year             INTEGER NOT NULL,
    run_id           TEXT,
    score            TEXT,           -- "9/11" for automated, "3.8/5.0" for llm_judge
    passed           INTEGER,        -- automated only
    failed           INTEGER,        -- automated only
    warned           INTEGER,        -- automated only
    overall_verdict  TEXT,
    report_markdown  TEXT,           -- full markdown report
    checks_detail    JSONB,          -- automated only: [{name, status, detail}, ...]
    themes_scored    JSONB,          -- llm_judge only: per-theme scores array
    dim_averages     JSONB,          -- llm_judge only: {enterprise_relevance, ...}
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_eval_reports_week ON eval_reports(year, week_number);
CREATE INDEX IF NOT EXISTS idx_eval_reports_type ON eval_reports(eval_type);

-- ============================================
-- TABLE: golden_set_runs
-- One row per golden set execution — isolated from production pipeline_runs
-- ============================================
CREATE TABLE IF NOT EXISTS golden_set_runs (
    id                    TEXT PRIMARY KEY,           -- run-golden-set-{timestamp}
    golden_set_version    TEXT NOT NULL,              -- e.g. "gs-v2.1"
    prompt_version        TEXT,                       -- e.g. "pv-actwatch-v37"
    run_date              DATE NOT NULL,
    signals_processed     INTEGER DEFAULT 0,
    themes_produced       INTEGER DEFAULT 0,
    trap_signals_excluded INTEGER,                    -- manual: how many traps were correctly filtered
    notes                 TEXT,
    created_at            TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- TABLE: golden_set_themes
-- One row per theme produced by a golden set run — isolated from production themes
-- ============================================
CREATE TABLE IF NOT EXISTS golden_set_themes (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    run_id                TEXT NOT NULL REFERENCES golden_set_runs(id),
    golden_set_version    TEXT NOT NULL,
    theme_id              TEXT NOT NULL,
    title                 TEXT NOT NULL,
    signal_type           TEXT NOT NULL,              -- ACT or WATCH
    confidence_score      INTEGER NOT NULL,
    summary               TEXT,
    why_it_matters        TEXT,
    what_you_can_do       JSONB DEFAULT '[]',
    signal_ids            JSONB DEFAULT '[]',
    expected_tier         TEXT,                       -- manual: what the golden set expected (ACT/WATCH/FILTERED)
    tier_correct          BOOLEAN,                    -- manual: did the pipeline get it right?
    created_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gs_themes_run ON golden_set_themes(run_id);

-- ============================================
-- TABLE: golden_set_eval_scores
-- Manual scoring of golden set results — compare pipeline output vs expected
-- ============================================
CREATE TABLE IF NOT EXISTS golden_set_eval_scores (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    run_id                TEXT NOT NULL REFERENCES golden_set_runs(id),
    golden_set_version    TEXT NOT NULL,
    total_signals         INTEGER,                    -- total signals in golden set
    themes_produced       INTEGER,                    -- themes pipeline generated
    themes_expected       INTEGER,                    -- themes golden set expected
    correct_themes        INTEGER,                    -- themes that match expected output
    traps_leaked          INTEGER,                    -- trap signals that appeared in themes (should be 0)
    act_correct           INTEGER,                    -- ACT themes correctly classified
    watch_correct         INTEGER,                    -- WATCH themes correctly classified
    roundup_merged        BOOLEAN,                    -- did singleton releases merge into roundup?
    north_star_pct        NUMERIC,                    -- % correct themes
    notes                 TEXT,
    scored_at             TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gs_eval_run ON golden_set_eval_scores(run_id);

-- ============================================
-- ACCESS CONTROL (MVP — open for n8n service role)
-- ============================================
ALTER TABLE themes                DISABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_briefs         DISABLE ROW LEVEL SECURITY;
ALTER TABLE pipeline_runs         DISABLE ROW LEVEL SECURITY;
ALTER TABLE eval_reports          DISABLE ROW LEVEL SECURITY;
ALTER TABLE golden_set_runs       DISABLE ROW LEVEL SECURITY;
ALTER TABLE golden_set_themes     DISABLE ROW LEVEL SECURITY;
ALTER TABLE golden_set_eval_scores DISABLE ROW LEVEL SECURITY;

GRANT ALL ON themes, weekly_briefs, pipeline_runs, eval_reports, golden_set_runs, golden_set_themes, golden_set_eval_scores TO authenticated, service_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated, service_role;
GRANT SELECT ON current_week_themes TO anon;
GRANT EXECUTE ON FUNCTION get_dashboard_metrics TO anon;
GRANT EXECUTE ON FUNCTION get_themes_by_week TO anon;

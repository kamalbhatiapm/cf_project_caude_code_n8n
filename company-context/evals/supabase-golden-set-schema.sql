-- =============================================================================
-- CalmFalcon — Golden Set Supabase Schema
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor → New Query)
-- Creates 3 tables: golden_set_runs, golden_set_themes, golden_set_eval_scores
-- =============================================================================


-- -----------------------------------------------------------------------------
-- TABLE 1: golden_set_runs
-- One row per pipeline execution against the golden set
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS golden_set_runs (
  id                    TEXT PRIMARY KEY,            -- e.g. "run-golden-set-1711612800000"
  golden_set_version    TEXT NOT NULL DEFAULT 'gs-v1',
  prompt_version        TEXT,                        -- e.g. "pv-actwatch-v37"
  run_date              DATE NOT NULL,
  signals_processed     INT DEFAULT 20,
  themes_produced       INT,
  trap_signals_excluded INT,                         -- out of 5 in gs-v1
  rule3_edge_case       TEXT,                        -- 'WATCH' (correct) or 'ACT' (bug)
  notes                 TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE golden_set_runs IS 'One row per pipeline run against the 20-signal golden set. Separate from production pipeline_runs table.';
COMMENT ON COLUMN golden_set_runs.rule3_edge_case IS 'How gs-001 (NVIDIA on github.com) was tiered — WATCH is correct, ACT means Rule 3 bug is still present';


-- -----------------------------------------------------------------------------
-- TABLE 2: golden_set_themes
-- One row per theme produced from a golden set run
-- Mirrors the themes table structure but isolated from production data
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS golden_set_themes (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id              TEXT NOT NULL REFERENCES golden_set_runs(id) ON DELETE CASCADE,
  golden_set_version  TEXT NOT NULL DEFAULT 'gs-v1',
  theme_id            TEXT NOT NULL,                -- e.g. "theme-001"
  title               TEXT,
  signal_type         TEXT CHECK (signal_type IN ('ACT', 'WATCH')),
  confidence_score    INT CHECK (confidence_score BETWEEN 0 AND 100),
  summary             TEXT,
  why_it_matters      TEXT,
  what_you_can_do     JSONB,                        -- array of action strings
  signal_ids          TEXT[],                       -- gs-001, gs-002, etc.
  -- Ground truth comparison (filled in manually or by grader)
  expected_tier       TEXT CHECK (expected_tier IN ('ACT', 'WATCH', 'EXCLUDE', NULL)),
  tier_correct        BOOLEAN,                      -- signal_type matches expected_tier
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE golden_set_themes IS 'Themes produced by pipeline runs against the golden set. Isolated from production themes table.';
COMMENT ON COLUMN golden_set_themes.expected_tier IS 'Ground truth tier from the golden set definition. Populated after comparing against CalmFalcon Golden Set - 20 Signals.md';
COMMENT ON COLUMN golden_set_themes.tier_correct IS 'True if signal_type matches expected_tier. False = Verifier tier bug.';

CREATE INDEX IF NOT EXISTS idx_golden_set_themes_run_id ON golden_set_themes(run_id);
CREATE INDEX IF NOT EXISTS idx_golden_set_themes_signal_type ON golden_set_themes(signal_type);


-- -----------------------------------------------------------------------------
-- TABLE 3: golden_set_eval_scores
-- HHH scores per theme per run — filled in after manual or automated scoring
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS golden_set_eval_scores (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id          TEXT NOT NULL REFERENCES golden_set_runs(id) ON DELETE CASCADE,
  theme_id        TEXT NOT NULL,                    -- matches golden_set_themes.theme_id
  -- Helpful dimension (H1–H4, each 0 / 0.5 / 1)
  h1_actionable   NUMERIC(3,1) CHECK (h1_actionable IN (0, 0.5, 1)),
  h2_specific     NUMERIC(3,1) CHECK (h2_specific IN (0, 0.5, 1)),
  h3_stack        NUMERIC(3,1) CHECK (h3_stack IN (0, 0.5, 1)),
  h4_confidence   NUMERIC(3,1) CHECK (h4_confidence IN (0, 0.5, 1)),
  helpful_total   NUMERIC(4,1) GENERATED ALWAYS AS (
                    COALESCE(h1_actionable,0) + COALESCE(h2_specific,0) +
                    COALESCE(h3_stack,0) + COALESCE(h4_confidence,0)
                  ) STORED,
  -- Honest dimension (O1–O3, each 0 or 1)
  o1_no_halluc   INT CHECK (o1_no_halluc IN (0, 1)),
  o2_tier_correct INT CHECK (o2_tier_correct IN (0, 1)),
  o3_specific_title INT CHECK (o3_specific_title IN (0, 1)),
  honest_total   INT GENERATED ALWAYS AS (
                    COALESCE(o1_no_halluc,0) + COALESCE(o2_tier_correct,0) +
                    COALESCE(o3_specific_title,0)
                  ) STORED,
  -- Harmless dimension (A1–A2, each 0 or 1)
  a1_no_bad_rec  INT CHECK (a1_no_bad_rec IN (0, 1)),
  a2_no_trap     INT CHECK (a2_no_trap IN (0, 1)),
  harmless_total INT GENERATED ALWAYS AS (
                    COALESCE(a1_no_bad_rec,0) + COALESCE(a2_no_trap,0)
                  ) STORED,
  -- Failure notes
  failure_reasons TEXT[],                           -- e.g. ['hallucinated 10% stat', 'ACT without vendor domain']
  graded_by       TEXT DEFAULT 'manual',            -- 'manual' or 'llm-judge'
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE golden_set_eval_scores IS 'HHH scores per theme per golden set run. Each row = one theme scored against the golden set rubric.';
COMMENT ON COLUMN golden_set_eval_scores.graded_by IS 'manual = human scored, llm-judge = automated Claude grader (Phase 2)';

CREATE INDEX IF NOT EXISTS idx_eval_scores_run_id ON golden_set_eval_scores(run_id);


-- -----------------------------------------------------------------------------
-- VIEW: golden_set_run_summary
-- Aggregates HHH scores to run level — use this to compare runs over time
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW golden_set_run_summary AS
SELECT
  r.id                                        AS run_id,
  r.golden_set_version,
  r.prompt_version,
  r.run_date,
  r.themes_produced,
  r.trap_signals_excluded,
  r.rule3_edge_case,
  -- Helpful %
  ROUND(
    100.0 * SUM(s.helpful_total) / NULLIF(COUNT(s.id) * 4, 0), 1
  )                                           AS helpful_pct,
  -- Honest %
  ROUND(
    100.0 * SUM(s.honest_total) / NULLIF(COUNT(s.id) * 3, 0), 1
  )                                           AS honest_pct,
  -- Harmless %
  ROUND(
    100.0 * SUM(s.harmless_total) / NULLIF(COUNT(s.id) * 2, 0), 1
  )                                           AS harmless_pct,
  -- Tier accuracy %
  ROUND(
    100.0 * SUM(s.o2_tier_correct) / NULLIF(COUNT(s.id), 0), 1
  )                                           AS tier_accuracy_pct,
  -- Trap exclusion (from runs table)
  ROUND(
    100.0 * r.trap_signals_excluded / 5.0, 0
  )                                           AS trap_exclusion_pct,
  -- Pass/fail gates
  CASE WHEN SUM(s.helpful_total) / NULLIF(COUNT(s.id) * 4.0, 0) >= 0.75
    THEN '✅' ELSE '❌' END                   AS helpful_gate,
  CASE WHEN SUM(s.honest_total) / NULLIF(COUNT(s.id) * 3.0, 0) >= 0.85
    THEN '✅' ELSE '❌' END                   AS honest_gate,
  CASE WHEN SUM(s.a2_no_trap) = COUNT(s.id)
    THEN '✅' ELSE '❌' END                   AS harmless_gate,
  r.notes
FROM golden_set_runs r
LEFT JOIN golden_set_eval_scores s ON s.run_id = r.id
GROUP BY r.id, r.golden_set_version, r.prompt_version, r.run_date,
         r.themes_produced, r.trap_signals_excluded, r.rule3_edge_case, r.notes
ORDER BY r.run_date DESC;

COMMENT ON VIEW golden_set_run_summary IS 'Aggregated HHH scores per golden set run. Use this to track quality over time.';


-- -----------------------------------------------------------------------------
-- SAMPLE INSERT: what a completed golden set run looks like
-- Uncomment and edit to log your first manual run
-- -----------------------------------------------------------------------------
/*
INSERT INTO golden_set_runs (id, golden_set_version, prompt_version, run_date, themes_produced, trap_signals_excluded, rule3_edge_case, notes)
VALUES (
  'run-golden-set-001',
  'gs-v1',
  'pv-actwatch-v37',
  '2026-03-28',
  8,          -- how many themes the pipeline produced
  3,          -- how many of the 5 traps were excluded (fill in after run)
  'ACT',      -- 'ACT' = Rule 3 bug still present, 'WATCH' = fixed
  'First golden set run. Rule 3 bug present — NVIDIA assigned ACT.'
);
*/

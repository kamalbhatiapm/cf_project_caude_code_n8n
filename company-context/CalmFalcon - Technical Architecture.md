# CalmFalcon — Technical Architecture

**Version:** v20 | **Date:** April 2026 | **Pipeline ID:** `L0jQ0ap6rVRyMZYm`

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Orchestration** | n8n (cloud (n8n.io)) | Pipeline orchestration, scheduling, node execution |
| **LLM** | OpenAI GPT-4 Turbo | Theme Selector, Theme Writer (x8), Verifier Agent, Brief Writer |
| **Web Search** | Exa API (`api.exa.ai`) | Signal ingestion with date filtering, category filters, domain control |
| **Code Hosting** | GitHub API v3 | 3-tier trending: releases, new repos, velocity spikes |
| **Database** | Supabase (PostgreSQL) | Theme storage, pipeline runs, eval reports, prompt versions |
| **Frontend** | React + TypeScript (V0) | Themes dashboard, brief viewer |
| **Hosting** | Google Cloud Platform | Frontend deployment |
| **Eval — Automated** | n8n workflow | 13 automated pipeline checks |
| **Eval — LLM Judge** | GPT-4 Turbo | 4-dimension quality scoring |

### API Dependencies

| API | Auth | Rate Limits | Cost |
|-----|------|-------------|------|
| OpenAI GPT-4 Turbo | API key (`OPENAI_API_KEY`) | 10k RPM | ~$2/run |
| Exa Search | API key (`EXA_API_KEY`) | 1000 req/day | ~$0.50/run |
| GitHub v3 | Token (`GITHUB_TOKEN`) | 5000 req/hr (with token) | Free |
| Supabase REST | API key (`SUPABASE_KEY`) | 500 req/sec | Free tier |

### n8n Workflow Variables

| Variable | Purpose |
|----------|---------|
| `OPENAI_API_KEY` | GPT-4 Turbo access for all LLM agents |
| `EXA_API_KEY` | Exa web search API |
| `GITHUB_TOKEN` | GitHub API (rate limit boost) |
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_KEY` | Supabase anon/service key |

---

## Pipeline Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CALMFALCON SIGNALS PIPELINE v20                       │
│                    Exa + 3-Tier GitHub + Balanced ACT/WATCH                  │
└─────────────────────────────────────────────────────────────────────────────┘

 TRIGGER                    SIGNAL INGESTION                    PROCESSING
┌──────────┐  ┌───────────────┐  ┌──────────────┐  ┌─────────┐  ┌──────────┐
│ Schedule │→│ Save Prompt   │→│ Build Search │→│         │→│ Process  │
│ Trigger  │  │ Version       │  │ Queries (14) │  │  Merge  │  │ Signals  │
│ Mon 6AM  │  │ pv-actwatch   │  │              │  │  Fetch  │  │ dedup +  │
└──────────┘  └───────────────┘  │  3 release   │  │ Branches│  │ normalize│
                                 │  7 trend     │  │         │  │ + filter │
  GOLDEN SET                     │  2 research  │  └─────────┘  └──────────┘
┌──────────┐                     │  2 newsletter│       ↑              │
│ Manual   │─────────────────────┤              │       │              ↓
│ Trigger  │  ┌──────────────┐   └──────┬───────┘       │       ┌──────────┐
│ (test)   │→│ Golden Set   │          │               │       │ Rank &   │
└──────────┘  │ Signals v2   │──────────┘               │       │ Format   │
              │ 25 signals   │        ┌──────────────┐  │       │ Top 120  │
              └──────────────┘        │ Fetch via    │──┘       └──────────┘
                                      │ Exa          │                │
                                      │ 14 queries   │                ↓
                                      │ 20 results ea│         ┌──────────┐
                                      └──────────────┘         │ Retrieve │
                                      ┌──────────────┐         │ Prior    │
                                      │ Fetch GitHub │──┘      │ Context  │
                                      │ Trending     │         └──────────┘
                                      │ 3-tier logic │               │
                                      │ cap 50       │               ↓
                                      └──────────────┘         ┌──────────┐
                                                               │ Build    │
                                                               │ Evidence │
                                                               │ Pack     │
                                                               └──────────┘
                                                                     │
 CLUSTERING                                                          ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SIGNAL CLUSTER BUILDER                                │
│                                                                              │
│  Step 1:   Vendor grouping (1 cluster per vendor family)                    │
│            + title-based vendor detection (VENDOR_PRODUCTS map)              │
│  Step 1.5: Category-based trend clustering (agents_trend, safety_trend...)  │
│  Step 2:   Keyword grouping (coherence ≥20% pairwise overlap)              │
│  Step 3:   Singleton fallback (high-scoring unclustered signals)            │
│  Step 4:   GitHub release roundup merge                                     │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
 AI ANALYSIS                          ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Theme        │→│ Split        │→│ Theme Writer │→│ Aggregate    │
│ Selector     │  │ Clusters     │  │ × 8 parallel │  │ Themes       │
│ (GPT-4T)     │  │ (code node)  │  │ (GPT-4T)     │  │ (code node)  │
│              │  │              │  │              │  │              │
│ • Exact 8    │  │ Enriches ea  │  │ • 1 theme    │  │ Collects 8   │
│ • Max 3 ACT  │  │ with its     │  │   per cluster│  │ theme JSONs  │
│ • Min 5 WATCH│  │ signal cards │  │ • Anti-halluc│  │ into array   │
│ • AI relev.  │  │              │  │ • Date guard │  │              │
│   gate       │  │              │  │ • Evidence   │  │              │
│ • Vendor     │  │              │  │   grounding  │  │              │
│   dedup      │  │              │  │              │  │              │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
                                                              │
 VERIFICATION & SCORING                                       ↓
┌──────────────┐  ┌──────────────┐  ┌────────────────────────────────┐
│ Theme Logger │→│ Verifier     │→│ Deterministic Score +          │
│ (code node)  │  │ Agent        │  │ Confidence                     │
│              │  │ (GPT-4T)     │  │                                │
│ Logs theme   │  │              │  │ • Source diversity bonus (+12)  │
│ IDs for      │  │ • 12 rules   │  │ • Signal count bonus           │
│ debugging    │  │ • ID valid.  │  │ • Velocity delta (ACT+8)       │
│              │  │ • Title fix  │  │ • Single-signal cap 65%        │
│              │  │ • Spread fix │  │ • Confidence ceiling 95%       │
│              │  │ • ACT fix    │  │ • WoW continuation detection   │
│              │  │ • Phrase fix │  │ • Citation URL resolution      │
└──────────────┘  └──────────────┘  └────────────────────────────────┘
                                                              │
 OUTPUT                                                       ↓
┌──────────────┐  ┌──────────────────────────────────────────────────┐
│ Brief Writer │→│ Save to Supabase                                 │
│ (GPT-4T)     │  │                                                  │
│              │  │ 1. pipeline_runs (stats, theme count, avg conf)  │
│ • ≤800 words │  │ 2. themes (all fields + citations JSONB + WoW)  │
│ • Exec Summ  │  │ 3. weekly_briefs (markdown + key_takeaway)      │
│ • ACT themes │  │                                                  │
│ • WATCH      │  │ Sequential upserts — safe to rerun              │
│ • Watch List │  │                                                  │
└──────────────┘  └──────────────────────────────────────────────────┘
```

---

## Data Flow

### Signal Journey (raw URL → themed insight)

```
Web Article / GitHub Release / Research Paper
         │
         ↓
┌─ Exa API or GitHub API ─┐
│  Returns: url, title,    │
│  content, publishedDate, │
│  score                   │
└──────────┬───────────────┘
           ↓
┌─ Process Signals ────────┐     Dedup: URL + normalized title
│  signal_id: tv-<base64>  │     Filter: github.com from Exa
│  source_type: category   │     Filter: non-AI titles
│  relevance_score: 0-98   │
└──────────┬───────────────┘
           ↓
┌─ Rank & Format Top 120 ─┐     Per-category multiplier (vendor 1.4x → business 0.85x)
│  final_score: weighted   │     Per-category cap (vendor 5, github 12, etc.)
│  signal_card: formatted  │     Output: text-based signal cards for LLM consumption
└──────────┬───────────────┘
           ↓
┌─ Signal Cluster Builder ─┐     Vendor grouping → trend clustering → keyword grouping
│  cluster_id: vendor-*    │     Coherence threshold: 20% pairwise keyword overlap
│  cluster_type: vendor    │     GitHub roundup merge: singletons → 1 cluster
│  /trend/keyword/singleton│
└──────────┬───────────────┘
           ↓
┌─ Theme Selector (LLM) ──┐     Selects 8 from N clusters
│  Balanced: 2-3 ACT      │     Enterprise AI relevance gate
│           5-6 WATCH      │     Vendor dedup, topic dedup
└──────────┬───────────────┘
           ↓
┌─ Theme Writer × 8 (LLM) ┐     Each sees 1 cluster's signals only
│  title, summary,         │     Anti-hallucination checks
│  signal_type, confidence,│     Date guard (pub date validation)
│  why_it_matters,         │     Evidence grounding
│  what_you_can_do,        │
│  supporting_signal_ids   │
└──────────┬───────────────┘
           ↓
┌─ Verifier Agent (LLM) ──┐     12 rules: ID validation, title fix, spread fix
│  Corrected theme JSON    │     Strips hallucinated IDs
└──────────┬───────────────┘
           ↓
┌─ Deterministic Score ────┐     Rule-based adjustments on top of AI scores
│  confidence: 0-95%       │     WoW continuation detection
│  citations: resolved URLs│     Citation URL resolution from signal map
└──────────┬───────────────┘
           ↓
┌─ Supabase ───────────────┐
│  themes table             │
│  pipeline_runs table      │
│  weekly_briefs table      │
└───────────────────────────┘
```

---

## Exa Search Configuration

### 14 Queries (3 release + 7 trend + 2 research + 2 newsletter)

| # | Category | Query Intent | searchCategory | Domains | Weight |
|---|----------|-------------|----------------|---------|--------|
| 1 | `vendor` | Model releases/launches | news | 16 vendor domains | 90 |
| 2 | `vendor_platform` | API/pricing/feature updates | news | 23 platform domains | 88 |
| 3 | `opensource` | Open-source model releases | news | exclude github.com | 68 |
| 4 | `agents_trend` | Agent deployment patterns | news | exclude github.com | 76 |
| 5 | `enterprise_trend` | Enterprise AI strategy/cost | news | exclude github.com | 74 |
| 6 | `infra_trend` | Compute cost/GPU trends | news | exclude github.com | 68 |
| 7 | `engineering_trend` | RAG production patterns | news | exclude github.com | 65 |
| 8 | `oss_trend` | OSS vs proprietary evaluation | news | exclude github.com | 66 |
| 9 | `safety_trend` | AI regulation/compliance | news | exclude github.com | 70 |
| 10 | `business_trend` | Funding/M&A/consolidation | news | exclude github.com | 62 |
| 11 | `research` | LLM benchmarks/evaluation | research paper | exclude github.com | 72 |
| 12 | `papers` | Inference efficiency research | research paper | arxiv, paperswithcode, semanticscholar | 80 |
| 13 | `newsletter` | AI newsletter roundups | news | 10 newsletter domains | 74 |
| 14 | `newsletter_media` | AI news/analysis | news | 10 media domains | 72 |

**All queries use:**
- `startPublishedDate` / `endPublishedDate` — ISO 8601, last 7 days
- `numResults: 20` per query
- `contents: { text: { maxCharacters: 3000 }, highlights: { maxCharacters: 1000 } }`

### Newsletter Domains (query 13)
`newsletter.theaiedge.io`, `bensbites.com`, `therundown.ai`, `alphasignal.ai`, `substack.com`, `import-ai.net`, `jack-clark.net`, `lastweekin.ai`, `aitidbits.substack.com`, `simonwillison.net`

### Media Domains (query 14)
`techcrunch.com`, `venturebeat.com`, `theverge.com`, `arstechnica.com`, `theregister.com`, `semafor.com`, `bloomberg.com`, `reuters.com`, `wired.com`, `thenewstack.io`

---

## GitHub 3-Tier Logic

```
Fetch GitHub Trending
│
├── TIER 1: Tagged Releases (ACT-eligible)
│   Query: 26 top AI orgs, repos pushed in last 7 days
│   Check: GitHub Releases API — release published in last 7 days?
│   Filter: Skip alpha/beta/RC/pre/canary/nightly/dev versions
│   Title: "{org}/{repo} releases {tag} — {description}"
│   Score: 0.7 + (stars / 50000)
│
├── TIER 2: New Repos (ACT or WATCH)
│   Query: topic:llm/agent/rag/mlops + created last 14 days + stars >50
│   Title: "NEW: {org}/{repo} — {description}"
│   Score: 0.5 + (stars / 5000)
│
└── TIER 3: Velocity Spikes (WATCH only)
    Query: topic:llm/agent/rag + stars >1000 + pushed last 7 days
    Check: GitHub commit activity API — last week ≥2x 4-week avg + ≥10 commits
    Title: "VELOCITY: {org}/{repo} — {description}"
    Score: 0.4 + (spike_ratio × 0.1) + (stars / 50000)

Output: Top 50 by score
```

### 26 Monitored AI Organizations
`openai`, `anthropic-ai`, `google`, `google-deepmind`, `meta-llama`, `mistralai`, `microsoft`, `huggingface`, `langchain-ai`, `run-llama`, `vllm-project`, `ray-project`, `pytorch`, `tensorflow`, `nvidia`, `cohere-ai`, `groq`, `BerriAI`, `infiniflow`, `crewAIInc`, `AgentOps-AI`, `letta-ai`, `MLflow`, `wandb`, `pinecone-io`, `weaviate`, `qdrant`

---

## Signal Cluster Builder

### Clustering Pipeline

```
Input: 120 ranked signals (signal_cards + top_signals)
                    │
    ┌───────────────┼───────────────┐
    ↓               ↓               ↓
 VENDOR          TREND          REMAINING
 GROUPING      CLUSTERING      SIGNALS
    │               │               │
    ↓               ↓               ↓
Step 1:         Step 1.5:       Step 2:
Domain map +    Category-based  Keyword
title-based     grouping        grouping
vendor detect   (per Exa query  (≥2 shared
(VENDOR_MAP +   category)       keywords,
VENDOR_PRODUCTS)                20% coherence)
    │               │               │
    ↓               ↓               ↓
1 cluster       1 cluster       N clusters
per vendor      per trend cat   by keyword
                                    │
                                    ↓
                                Step 3:
                                Singleton
                                fallback
                                (score ≥65)
                                    │
                    ┌───────────────┘
                    ↓
                Step 4:
                GitHub release
                roundup merge
                (singletons → 1)
                    │
                    ↓
        Output: M clusters → Theme Selector
```

### Vendor Domain Map

| Vendor | Domains |
|--------|---------|
| Google | blog.google, cloud.google.com, ai.google.dev, deepmind.com, deepmind.google, research.google, google.com, vids.google.com, workspace.google.com |
| OpenAI | openai.com, help.openai.com, cdn.openai.com, platform.openai.com, api.openai.com |
| Anthropic | anthropic.com, docs.anthropic.com, console.anthropic.com |
| NVIDIA | nvidia.com, investor.nvidia.com, nvidianews.nvidia.com, developer.nvidia.com, resources.nvidia.com |
| Meta | ai.meta.com, about.fb.com, research.facebook.com, meta.com |
| Microsoft | microsoft.com, azure.microsoft.com, research.microsoft.com, techcommunity.microsoft.com |
| AWS | aws.amazon.com, amazonaws.com |
| Mistral | mistral.ai, docs.mistral.ai |
| HuggingFace | huggingface.co, hf.co |
| Cohere | cohere.com, docs.cohere.com |
| Databricks | databricks.com, docs.databricks.com |

### Vendor Product Detection (title-based)

| Vendor | Keywords in title |
|--------|------------------|
| Google | gemma, gemini, google ai, google cloud, vertex ai, google vids, google workspace ai |
| OpenAI | gpt-4, gpt-5, chatgpt, codex, dall-e, openai |
| Anthropic | claude, anthropic |
| NVIDIA | blackwell, hopper, tensorrt, cuda, nvidia |
| Meta | llama, meta ai |
| Microsoft | azure ai, copilot, phi- |
| Mistral | mistral, mixtral |
| AWS | bedrock, sagemaker |

---

## Database Schema

### Tables

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  pipeline_runs   │     │     themes       │     │  weekly_briefs   │
├─────────────────┤     ├─────────────────┤     ├─────────────────┤
│ id          UUID│     │ id          UUID│     │ id          UUID│
│ run_id      TEXT│←───│ (via week/yr)   │───→│ brief_id    TEXT│
│ week_number  INT│     │ theme_id    TEXT│     │ week_number  INT│
│ year         INT│     │ week_number  INT│     │ year         INT│
│ total_themes INT│     │ year         INT│     │ title       TEXT│
│ total_signals   │     │ title       TEXT│     │ content     TEXT│
│ avg_confidence  │     │ summary     TEXT│     │ key_takeaway    │
│ themes_summary  │     │ signal_type TEXT│     │ pipeline_run_id │
│   JSONB         │     │ confidence   INT│     │ generated_at    │
│ status      TEXT│     │ why_it_matters  │     │ pdf_url     TEXT│
│ prompt_version  │     │ what_you_can_do │     └─────────────────┘
│ completed_at    │     │ citations  JSONB│
└─────────────────┘     │ signal_ids JSONB│     ┌─────────────────┐
                        │ signal_count INT│     │  eval_reports    │
┌─────────────────┐     │ is_continuation │     ├─────────────────┤
│ prompt_versions  │     │ prev_confidence │     │ id          UUID│
├─────────────────┤     │ confidence_delta│     │ eval_type   TEXT│
│ id          UUID│     │ processed_at    │     │ week_number  INT│
│ version_id  TEXT│     └─────────────────┘     │ year         INT│
│ version_label   │                             │ run_id      TEXT│
│ main_agent_     │                             │ score       TEXT│
│   prompt    TEXT│                             │ passed       INT│
│ verifier_       │                             │ failed       INT│
│   prompt    TEXT│                             │ overall_verdict │
│ brief_writer_   │                             │ report_markdown │
│   prompt    TEXT│                             │ checks_detail   │
│ notes       TEXT│                             │   JSONB         │
└─────────────────┘                             │ themes_scored   │
                                                │   JSONB         │
                                                │ dim_averages    │
                                                │   JSONB         │
                                                └─────────────────┘

═══ GOLDEN SET TABLES (isolated from production) ═══

┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│  golden_set_runs     │     │  golden_set_themes   │     │ golden_set_eval_    │
├─────────────────────┤     ├─────────────────────┤     │  scores             │
│ id              TEXT│←───│ run_id          TEXT│     ├─────────────────────┤
│ golden_set_version  │     │ golden_set_version  │     │ run_id          TEXT│
│ prompt_version  TEXT│     │ theme_id        TEXT│     │ golden_set_version  │
│ run_date        DATE│     │ title           TEXT│     │ total_signals    INT│
│ signals_processed   │     │ signal_type     TEXT│     │ themes_produced  INT│
│ themes_produced  INT│     │ confidence_score INT│     │ correct_themes   INT│
│ trap_signals_       │     │ summary         TEXT│     │ traps_leaked     INT│
│   excluded       INT│     │ why_it_matters  TEXT│     │ act_correct      INT│
│ notes           TEXT│     │ what_you_can_do JSONB│     │ watch_correct    INT│
└─────────────────────┘     │ signal_ids     JSONB│     │ roundup_merged  BOOL│
                            │ expected_tier   TEXT│     │ north_star_pct   NUM│
                            │ tier_correct    BOOL│     │ notes           TEXT│
                            └─────────────────────┘     └─────────────────────┘
```

**Data isolation:** Golden set runs are detected by `run_id` prefix `run-golden-set-*` and routed to these tables automatically. Production data in `pipeline_runs`, `themes`, and `weekly_briefs` is never touched by golden set runs.

### Signal Type Mapping

| Pipeline Output | DB `signal_type` | Dashboard Display |
|----------------|------------------|-------------------|
| ACT | RISING | ACT — act this week |
| WATCH | EMERGING | WATCH — track 30 days |

### Key Indexes

| Table | Index | Purpose |
|-------|-------|---------|
| themes | `(year, week_number)` | Dashboard weekly view |
| themes | `(signal_type)` | ACT/WATCH filter |
| themes | `(confidence_score DESC)` | Sort by confidence |
| pipeline_runs | `(completed_at DESC)` | Latest run lookup |
| eval_reports | `(year, week_number)` | Eval by week |

### Views & Functions

| Name | Type | Purpose |
|------|------|---------|
| `current_week_themes` | View | Dashboard default: this week's themes |
| `get_dashboard_metrics(week, year)` | Function | Header metrics: signals, clusters, breakouts, avg confidence |
| `get_themes_by_week(week, year)` | Function | All theme fields for detail view |

---

## Eval Pipeline Architecture

### Automated Eval (`calmfalcon-eval-automated.json`)

```
Manual Trigger → Fetch Latest Data (Supabase) → Run Automated Checks (13)
    → Format Report → Save Report to Supabase (eval_type: 'automated')
```

**13 Checks:**
1. Theme count (6–8)
2. Required fields (title, summary, why_it_matters, what_you_can_do)
3. ACT/WATCH tier mix (ACT 2–3, WATCH 5–6)
4. Confidence spread (≥20pts)
5. Confidence ceiling (≤95%)
6. Summary sentence count (4–5)
7. Title specificity (no banned words)
8. Citation coverage (≥1 per theme)
9. Citation URL format (http*)
10. Signal ID format (tv-* or gh-*)
11. Actionability (no vague language)
12. Brief word count (≤800)
13. Brief required sections

### LLM Judge Eval (`calmfalcon-eval-llm-judge.json`)

```
Fetch Themes for Judging (Supabase) → Build Judge Prompt
    → GPT-4 Turbo Judge → Parse & Format Results
    → Save Report to Supabase (eval_type: 'llm_judge')
```

**4 Dimensions (1–5 scale):**
1. Enterprise Relevance
2. Signal Type Accuracy (ACT/WATCH)
3. Actionability
4. Summary Quality

### Golden Set (gs-v2.1, 32 signals)

```
Golden Set Manual Trigger → Golden Set Signals (32 curated)
    → Process Signals → [rest of pipeline]
```

| Category | Count | Expected |
|----------|-------|----------|
| ACT vendor signals | 5 | 2-3 ACT themes |
| WATCH trend — `agents_trend` | 2 | Agent deployment WATCH theme |
| WATCH trend — `enterprise_trend` | 2 | Enterprise AI strategy WATCH theme |
| WATCH trend — `safety_trend` | 2 | Governance/regulation WATCH theme |
| WATCH trend — `infra_trend` | 2 | Compute cost/GPU WATCH theme |
| WATCH trend — `newsletter_media` | 2 | Newsletter analysis WATCH theme |
| GitHub releases (merge test) | 3 | 1 roundup theme |
| Research | 1 | Enriches WATCH themes |
| Enterprise relevance traps | 4 | Filtered out |
| Staleness traps | 4 | Filtered out |
| Alpha/pre-release traps | 3 | Filtered out |

**Data stored in:** `golden_set_runs` + `golden_set_themes` (isolated from production)

---

## Confidence Scoring Logic

```
Base score: AI-assigned (from Verifier Agent output)

Bonuses:
  Source type diversity ≥3 types  →  +12
  Source type diversity ≥2 types  →  +6
  Signal count ≥6                 →  +10
  Signal count ≥4                 →  +5
  Signal count ≥2                 →  +2
  ACT velocity delta              →  +8
  WATCH velocity delta            →  -5

Caps:
  Single-signal theme             →  max 65
  Zero-signal theme               →  max 40
  Hard ceiling                    →  max 95

Final: max(0, min(95, round(score)))

Confidence levels:
  ≥75%  →  "high"
  ≥50%  →  "medium"
  <50%  →  "low"
```

---

## Deployment

### Current (MVP)

| Component | Where | Access |
|-----------|-------|--------|
| n8n pipeline | n8n Cloud (n8n.io) | Workflow editor |
| Supabase | `railiynjtxafrbpmghmg.supabase.co` | REST API |
| Frontend | GCP (V0 React app) | Web browser |
| Workflow JSON | `n8n-workflows/calmfalcon-signals-pipeline-multi-agent.json` | Local file |
| Eval workflows | `n8n-workflows/calmfalcon-eval-*.json` | Local files |

### Workflow Files

| File | Purpose |
|------|---------|
| `calmfalcon-signals-pipeline-multi-agent.json` | Main pipeline (34 nodes) |
| `calmfalcon-eval-automated.json` | 13-check automated eval |
| `calmfalcon-eval-llm-judge.json` | GPT-4 Turbo judge eval |
| `supabase-schema.sql` | Database schema + views + functions |
| `calmfalcon-pipeline-prompts-v37.md` | Prompt reference (4 agents, ~57k chars) |

---

*Technical Architecture v20 — April 6, 2026*
*Changes from v6: Tavily → Exa, single agent → split architecture (Selector + Writer x8 + Verifier), 3-tier GitHub, category-based trend clustering, vendor title dedup, enterprise AI relevance gate, 13 eval checks, golden set v2*

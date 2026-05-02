<p align="center">
  <img src="https://img.shields.io/badge/Status-MVP%20Complete-22c55e?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Pipeline-v20%20(34%20nodes)-1C83E1?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Prompts-v37-a78bfa?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Eval%20Runs-40+-eab308?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Award-Best%20Comprehensive%20Project-ef4444?style=for-the-badge" />
</p>

# CalmFalcon — AI Signals Intelligence Platform

**CalmFalcon** helps enterprise AI teams stop spending 15+ hours/week manually tracking the AI ecosystem. A 4-agent pipeline ingests 200+ signals weekly from web search and GitHub, clusters them into scored themes, and delivers an executive-ready brief every Monday morning.

> Built during the Agentic AI PM Course. Won **"Best Comprehensive Project"** award.

---

## What It Does

Every Monday, CalmFalcon runs a pipeline that:

1. **Ingests** 200+ signals from 14 Exa web search queries + 3-tier GitHub trending (26 AI orgs)
2. **Clusters** signals into 6-8 themes using vendor dedup, trend clustering, and keyword grouping
3. **Scores** each theme's confidence (0-95%) based on evidence quality, source diversity, and signal count
4. **Classifies** each as **ACT** (needs action now) or **WATCH** (track over 30 days)
5. **Writes** an executive-ready weekly brief with "Why It Matters" and "What You Can Do" for each theme

The output is a brief you can forward to your CTO without editing.

---

## How It Works — 4-Agent Pipeline

```
Schedule Trigger (Mon 6AM)
       │
       ▼
┌─────────────────────────────────────────────────────┐
│  INGESTION                                          │
│  14 Exa queries + 3-tier GitHub → Merge → Process   │
│  → Rank Top 120 → Retrieve Prior Context            │
│  → Build Evidence Pack → Signal Cluster Builder     │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│  AGENT 1: Theme Selector                            │
│  Picks exactly 8 clusters. Max 3 ACT, min 5 WATCH. │
│  Vendor dedup. Enterprise AI relevance gate.        │
│  1 LLM call · GPT-4 Turbo · Temp 0.3               │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│  AGENT 2: Theme Writer (×8 parallel)                │
│  Writes 1 theme per cluster. Anti-hallucination     │
│  checks. Date guard. Evidence grounding.            │
│  8 LLM calls · GPT-4 Turbo · Temp 0.3              │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│  AGENT 3: Verifier Agent                            │
│  12-rule QC pass. Signal ID validation. Banned      │
│  title fix. Confidence spread enforcement.          │
│  1 LLM call · GPT-4 Turbo · Temp 0.3               │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│  Deterministic Score + Confidence                   │
│  Code-based scoring layer (not LLM). Source         │
│  diversity bonus. Signal count bonus. Caps.         │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│  AGENT 4: Brief Writer                              │
│  ≤800 word markdown brief. Key Takeaway → Exec     │
│  Summary → Key Themes → Watch List → Footer.        │
│  1 LLM call · GPT-4 Turbo · Temp 0.3               │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
              Save to Supabase
```

**12 LLM calls per run. ~3 minutes end to end. $1.93 per run.**

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Orchestration** | n8n Cloud | 34-node pipeline, weekly scheduling |
| **LLM** | OpenAI GPT-4 Turbo | All 4 agents + LLM Judge (12 calls/run) |
| **Web Search** | Exa API | 14 structured queries with date/domain filtering |
| **Code Intelligence** | GitHub API v3 | 3-tier trending from 26 AI orgs (releases, new repos, velocity) |
| **Database** | Supabase (PostgreSQL) | 8 tables (5 production + 3 golden set) |
| **Frontend** | React + TypeScript (V0) | Themes dashboard, brief viewer |
| **Hosting** | GCP Cloud Run | Frontend deployment |
| **Eval** | n8n workflows (2) | 13-rule automated checks + GPT-4 Turbo LLM Judge |
| **PM/Eval Tooling** | Claude Code (Max) | HHH eval scoring, documentation, agent evals |

---

## Eval Framework

Quality is measured by **4 methods** across every pipeline run:

### 1. HHH Rubric (22 Questions)

Every theme is scored on **8 Helpful + 7 Honest + 7 Harmless** questions. A theme is "correct" only if it passes all 22 with zero failures.

| Dimension | What It Measures | Questions | Beta Target |
|---|---|---|---|
| **Helpful** | Is this useful to an enterprise AI team? | H1-H8 | ≥75% |
| **Honest** | Can the reader trust every claim? | O1-O7 | ≥75% |
| **Harmless** | Could this theme cause harm? | A1-A7 | ≤5% violations |

### 2. LLM Judge (GPT-4 Turbo)

Independently scores each theme 1-5 on: Enterprise Relevance, Signal Type Accuracy, Actionability, Summary Quality.

- **≥4.0** = Publication Ready
- **3.0-3.9** = Needs Revision
- **<3.0** = Not Ready

### 3. Automated Checks (13 Rules)

Deterministic code validation (no LLM): theme count, required fields, ACT/WATCH mix, confidence spread (≥20pts), confidence ceiling (≤95%), summary length, title specificity, citations, URL format, signal IDs, actionability, brief word count, brief sections.

### 4. Pipeline Health

Pipeline latency (≤10 min), source type diversity (≥4 types), signal accuracy (≥85% vs golden set).

---

## Results (Run 40 — Latest)

| Metric | Value | Target | Status |
|---|---|---|---|
| **North Star (% Correct Themes)** | **50%** (4/8) | ≥80% | 🟡 Close to Demo Day 60% |
| % Helpful | **88%** | ≥75% | ✅ Passing |
| % Honest | **98%** | ≥75% | ✅ Passing |
| % Harmless violations | **0%** | ≤5% | ✅ Passing |
| LLM Judge | **4.3/5.0 — PUBLICATION READY** | ≥4.0 | ✅ Best ever |
| Hallucinated citations | **0** (8 consecutive runs) | 0 | ✅ Passing |
| Trend themes | **5** | ≥3 | ✅ Best ever |
| Pipeline latency | **~3 min** | ≤10 min | ✅ Passing |

---

## The Build Journey

```
Day 1 (Mar 25)   Single agent. Hallucinated product names. Honest: 53%.
                  │
Day 3             Split into 4 agents. Hallucinations → zero.
                  │
Day 4 (Mar 28)    Demo Day presentation.
                  │
Day 10            Swapped Tavily → Exa. Fixed more bugs than 20 prompt iterations.
                  │
Day 12 (Apr 6)    Run 40. LLM Judge: 4.3/5.0 "Publication Ready."
                  Honest: 98%. Zero hallucinations × 8 runs.
                  │
April 2026        🏆 "Best Comprehensive Project" Award
```

---

## Key Learnings

1. **One agent doing everything created problems I couldn't diagnose. Four agents with clear jobs created problems I could fix.**

2. **Bad data in = bad results out.** Switching one API provider fixed more quality issues than weeks of prompt engineering.

3. **Don't trust AI to merge duplicates. Use code instead.** The LLM worked sometimes, failed other times. A code rule would've been 100% reliable.

4. **Keep it simple.** Users didn't need five categories. Pivoting to two (ACT/WATCH) made the product instantly clearer.

5. **Don't rely only on the LLM's own judgment about confidence.** Add a rule-based scoring layer in code to judge output quality more reliably.

6. **Filtering out noise is harder than writing good content.** The AI writes great summaries for the wrong topics.

7. **Run tasks in parallel, check quality in sequence.** 8 parallel Theme Writers cut pipeline time from 8 min to 3. Quality checks need to see all themes together.

8. **A scoring checklist beats "does this feel right?"** The 22-question rubric turned vague feedback into specific, fixable problems.

9. **Accuracy is fixable with rules. Usefulness depends on your inputs.** Honest score: 53% → 98% through mechanical fixes. Usefulness depends on ingesting the right signals.

10. **Prompt engineering gets you halfway. The rest is an engineering problem.** 0% → 50% was prompt work. 50% → 80% requires fixing the data pipeline in code.

---

## Project Structure

```
├── README.md                                          ← You are here
├── CLAUDE.md                                          ← Claude Code project instructions
│
├── company-context/
│   ├── CalmFalcon - Product Documentation v5.0.html   ← Interactive docs (PRD + Arch + Evals + Roadmap + Learnings)
│   ├── CalmFalcon - AI Signals Intelligence PRD v4.md ← Comprehensive PRD
│   ├── CalmFalcon - Setup Guide.html                  ← Standalone setup guide
│   ├── CalmFalcon - Technical Architecture.md         ← Full architecture doc
│   ├── company-overview.md                            ← Company background
│   ├── product-description.md                         ← Product features
│   ├── user-personas.md                               ← User personas
│   ├── competitive-landscape.md                       ← Market positioning
│   ├── backlog.md                                     ← Feature backlog
│   │
│   ├── evals/
│   │   ├── CalmFalcon - HHH Eval Rubric.html          ← 22-question rubric (standalone)
│   │   ├── CalmFalcon MVP Eval Scorecard.md            ← Master eval template
│   │   ├── CalmFalcon MVP Eval Scorecard - Run 40 Results.md ← Best run
│   │   ├── CalmFalcon Agent Eval - Runs 38-40.md      ← Agent-level evals
│   │   ├── Agent Eval - Theme Selector.md             ← Theme Selector rubric
│   │   ├── Agent Eval - Theme Writer.md               ← Theme Writer rubric
│   │   ├── Agent Eval - Verifier Agent.md             ← Verifier rubric
│   │   ├── Agent Eval - Brief Writer.md               ← Brief Writer rubric
│   │   └── CalmFalcon Golden Set - 20 Signals.md      ← Golden set test data
│   │
│   └── prompt_guidelines/
│       └── Prompt Grading - v35.md                    ← RITGE rubric for prompt quality
│
├── n8n-workflows/
│   ├── calmfalcon-signals-pipeline-multi-agent.json    ← Main pipeline (34 nodes)
│   ├── calmfalcon-eval-automated.json                 ← 13-rule automated eval
│   ├── calmfalcon-eval-llm-judge.json                 ← LLM Judge eval
│   ├── calmfalcon-pipeline-prompts-v37.md             ← All 4 agent prompts (current)
│   ├── supabase-schema.sql                            ← Database schema (8 tables)
│   └── SETUP-GUIDE.md                                 ← Setup instructions
│
└── .gitignore
```

---

## Quick Start

### Prerequisites

| Service | Key Required |
|---|---|
| n8n Cloud | — |
| OpenAI | `OPENAI_API_KEY` |
| Exa | `EXA_API_KEY` |
| GitHub | `GITHUB_TOKEN` |
| Supabase | `SUPABASE_URL` + `SUPABASE_KEY` |

### Setup

1. **Create Supabase project** → note URL + service role key
2. **Run schema** → paste `n8n-workflows/supabase-schema.sql` in SQL Editor
3. **Set up n8n Cloud** → create workspace at n8n.io
4. **Add variables** → Settings → Variables: all 5 API keys
5. **Import pipeline** → Import `calmfalcon-signals-pipeline-multi-agent.json`
6. **Import evals** → Import `calmfalcon-eval-automated.json` + `calmfalcon-eval-llm-judge.json`
7. **Connect OpenAI** → Click each LLM node → select your credential
8. **Test run** → Execute Workflow (~3 min)
9. **Run evals** → Execute automated eval, then LLM Judge
10. **Enable schedule** → Toggle workflow to Active (Monday 6 AM)

See [Setup Guide](company-context/CalmFalcon%20-%20Setup%20Guide.html) for detailed step-by-step instructions.

---

## Unit Economics

| | Amount |
|---|---|
| **Cost per run** | $1.93 (12 LLM + 14 Exa + ~83 API calls) |
| **Monthly total** | $145.72 (4 weekly runs + $138 fixed infra) |
| **Value per user** | $9,000/mo (15 hrs/week × $150/hr PM rate) |
| **ROI** | **36×** at $250/mo pricing |
| **Gross margin** | 94-99% |

---

## Roadmap

| Quarter | Focus | North Star Target |
|---|---|---|
| **Q1 2026** ✅ | MVP + Demo Day. 4-agent pipeline, eval framework, 40+ runs | ≥60% (achieved 50%) |
| **Q2 2026** 🟡 | Beta launch. Fix vendor dedup, relevance gate, roundup merge. 5 pilot users. | ≥80% |
| **Q3 2026** 🔵 | Enterprise scale. Custom sources, daily runs, Slack integration, API access. | ≥85% |

---

## Interactive Documentation

The main product documentation is an interactive HTML file with 6 tabs:

- **PRD** — Vision, personas, requirements, metrics targets, unit economics, responsible AI
- **Architecture** — Tech stack, pipeline flow, signal ingestion, clustering, database schema
- **Evals** — How we evaluate (4 methods), prompt engineering standards, Run 40 results
- **Setup Guide** — 11-step setup with troubleshooting
- **Roadmap** — Q1 shipped → Q2 beta → Q3 enterprise (horizontal timeline)
- **Learnings** — 10 key takeaways from building the pipeline

Open `company-context/CalmFalcon - Product Documentation v5.0.html` in any browser.

---

## Built With

This project was built during the **Agentic AI PM Course** to explore how product managers can build production-grade multi-agent AI systems. It demonstrates:

- n8n multi-agent pipeline design (4 agents, parallel execution)
- Structured prompt engineering (RITGE framework)
- Comprehensive AI evaluation (HHH rubric, LLM Judge, automated checks)
- Deterministic scoring layers on top of LLM output
- Production data pipeline (Exa + GitHub → Supabase)
- Responsible AI practices (transparency, hallucination prevention, human oversight)

---

<p align="center">
  <strong>CalmFalcon AI Signals Intelligence Platform</strong><br>
  <sub>Pipeline v20 · 34 nodes · 8 Supabase tables · 14 Exa queries · 3-tier GitHub</sub><br>
  <sub>Built by a Principal PM · Won Best Comprehensive Project · April 2026</sub>
</p>

# CalmFalcon Product Backlog

**Last updated:** 2026-04-06

---

## Priority Legend
- **P0** — Must fix before next run
- **P1** — Fix this sprint
- **P2** — Next sprint
- **P3** — Backlog / future consideration

---

| # | Priority | Area | Item | Status | Notes |
|---|----------|------|------|--------|-------|
| 1 | P0 | Pipeline | Swap Tavily → Exa for web search | Done | Exa provides `publishedDate`, `category` filter, better date accuracy |
| 2 | P0 | Pipeline | Exclude github.com from Exa queries | Done | GitHub data handled by dedicated node |
| 3 | P0 | Pipeline | 3-tier GitHub Trending logic (releases + new repos + velocity spikes) | Done | Eliminates established repo noise (vllm, langgraph, etc.) |
| 4 | P1 | Pipeline | Signal Cluster Builder — topical coherence threshold | Done | 30% pairwise keyword overlap to prevent over-broad clustering |
| 5 | P1 | Pipeline | Theme Selector — enterprise relevance gate (Step 3.5) | Done | Filters out consumer tools, IM bots, non-AI dev tools |
| 6 | P1 | Pipeline | Theme Selector — balanced ACT/WATCH mix (max 3 ACT, min 5 WATCH) | Done | Prevents release-only briefs |
| 7 | P2 | Pipeline | Confidence ceiling capped at 95% | Done | No theme should claim absolute certainty |
| 8 | P2 | Pipeline | Newsletter/media sources added to Exa queries | Done | 20 domains: Ben's Bites, TechCrunch, VentureBeat, etc. |
| 9 | P2 | Pipeline | Rebalance Exa query language — release vs trend | Done | Split 13 queries into 3 release + 7 trend + 2 research + 2 newsletter. Trend queries use pattern/adoption/shift language instead of release/launch |
| 10 | P2 | Pipeline | Brief word count — exceeds 700 word limit | Not started | Recurring fail in evals (Run 34: 802 words, Run 35: 827 words). Brief Writer prompt needs tighter constraint |
| 11 | P2 | Pipeline | Summary sentence count — theme-001 wrong count | Not started | Eval check expects 4-5 sentences per summary |
| 12 | P3 | Frontend | Add source type tags to theme cards (RELEASE, ECOSYSTEM, RESEARCH, REGULATORY, COMPETITIVE) | Not started | Gives users granular filtering without splitting into tabs. Recommended over separate Releases/Trends tabs to keep single-dashboard UX aligned with persona JTBD |
| 13 | P3 | Pipeline | Newsletter signal underrepresentation | Not started | 0 newsletter-sourced themes in Runs 34-35. Monitor after P2 newsletter query fix; may need dedicated newsletter fetch node if still absent |
| 14 | P3 | Pipeline | LLM Judge vs human eval alignment | Not started | LLM Judge flagged LlamaFactory and GraphRAG as misclassified WATCH "despite specific release" — but human eval shows opposite (they AREN'T specific releases). Judge prompt may need calibration |
| 15 | P3 | Eval | Formal golden set evaluation | Not started | Runs 34-35 used qualitative assessment only. Need to run 20-signal golden set separately to get hard classification accuracy numbers |
| 16 | P2 | Pipeline | Add strategic AI queries — vendor pricing, talent, adoption, procurement, budget trends | Not started | Current queries are too narrowly technical. Missing business/strategic signals that AI Platform PMs need for build-vs-buy and vendor decisions (e.g., Gartner/Forrester AI spend reports, enterprise AI adoption case studies, AI talent market shifts, vendor pricing/packaging changes) |
| 17 | P1 | Eval | Golden set pipeline — debug Save to Supabase routing for golden_set_* tables | In progress | Standalone `calmfalcon-golden-set-pipeline.json` created (21 nodes), golden set tables created in Supabase, eval workflow `calmfalcon-eval-golden-set.json` created (9 checks). Need to verify: (1) pipeline saves to `golden_set_runs` + `golden_set_themes` correctly, (2) eval reads from those tables, (3) end-to-end flow works. Run pipeline first, then eval. |
| 18 | P1 | Pipeline | Cross-category trend dedup — merge overlapping trend themes | Not started | Themes 3+4 in Run 39 overlap ("Agentic AI Scaling" + "Enterprise AI Adoption"). Category-based trend clustering creates separate clusters for agents_trend and enterprise_trend but content overlaps. Fix: cross-category merge step if 2 trend clusters share ≥3 title keywords. |
| 19 | P1 | Pipeline | GitHub roundup merge robustness — catch releases in keyword clusters | Not started | LangChain v1.3.0 keeps escaping roundup merge. isGithubRelease() may not match because signal title format from Exa differs from GitHub Trending. Debug merge matching logic. |
| 20 | P1 | Pipeline | Tighter enterprise AI relevance gate — positive AI keyword match | Not started | AWS Deadline Cloud (render farm) passed relevance gate. Need positive match requirement: title must mention AI/ML/LLM/inference/etc. Not just "exclude non-AI" but "require AI". |

---

## Completed Items Archive

| Date | Item | Result |
|------|------|--------|
| 2026-04-06 | Tavily → Exa swap | Exa provides published dates, eliminates `null` date issue |
| 2026-04-06 | GitHub noise fix (3-tier logic) | Tier 1: releases, Tier 2: new repos, Tier 3: velocity spikes |
| 2026-04-06 | Clustering coherence + enterprise relevance + balanced mix | Prevents over-broad clusters, irrelevant themes, release-only briefs |
| 2026-04-06 | Confidence cap + newsletter sources | 95% ceiling, 20 new newsletter/media domains |

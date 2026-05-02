# CalmFalcon — AI Signals Intelligence PRD v4

**Version:** 4.0 | **Date:** April 2026 | **Status:** Post Demo-Day, Beta Planning
**Product:** CalmFalcon AI Signals Intelligence Platform
**Pipeline Version:** v20 | **Prompt Version:** pv-actwatch-v37

---

## 1. Vision

Become the intelligent layer between enterprise AI teams and their product workflows — eliminating manual AI ecosystem research and enabling faster, evidence-backed decisions.

## 2. Goal

Using multi-agent AI, CalmFalcon automatically ingests signals from GitHub releases, Exa web search (vendor docs, news, newsletters, research), and trend analysis queries, clusters them into high-confidence themes, and delivers a weekly brief that enterprise AI Platform Leaders can act on.

> **We aim to be the most trusted AI signal intelligence platform for enterprise platform and engineering teams.**

---

## 3. User Personas

### Primary: AI Platform PM

- **Profile:** Series B+, $50M+ revenue
- **Role:** Owns inference stack, orchestration, governance
- **Pain:** 15+ hrs/week reviewing signals manually
- **Success:** 10+ hrs saved/week ($9,000/mo value)

### Secondary: Engineering Lead / Architect

- **Profile:** Technical lead evaluating OSS frameworks and architecture patterns
- **Pain:** No objective criteria to rank what needs attention
- **Need:** Evidence-backed intelligence, not hype

---

## 4. Problems

### Critical (P0)

1. **15+ hrs/week** manually reviewing newsletters, GitHub, arXiv, vendor docs
2. **Missed signals** — model releases or architectural shifts slip past
3. **No consistent process** — no objective confidence scoring
4. **Raw signals lack enterprise context**

### Major (P1)

5. Can't share actionable summaries with leadership
6. Week-over-week tracking is manual
7. Citation quality hard to verify at scale

---

## 5. Solutions

| Layer | What | How |
|---|---|---|
| **Ingestion** | 14 Exa queries + 3-tier GitHub Trending | ~200 signals/week |
| **Clustering** | Vendor dedup + trend clustering + keyword grouping + roundup merge | Pre-LLM code step |
| **Scoring** | 0–95% confidence with source diversity bonus | ACT/WATCH classification |
| **Brief** | ≤800 word brief with "Why It Matters" and "What You Can Do" | Executive-ready, shareable |

---

## 6. Competitive Differentiation

| Competitor | Category | CalmFalcon Advantage |
|---|---|---|
| Feedly | News aggregation | Cross-source synthesis + confidence scoring |
| Exploding Topics | Trend detection | AI-specific + enterprise-framed actions |
| Rundown AI / TLDR | AI newsletters | Automated + GitHub/research + scored themes |
| Perplexity | AI search | Proactive weekly intelligence, not reactive |

---

## 7. User Journey

Every Monday morning, CalmFalcon delivers a ready-to-read intelligence brief. Here's the user experience:

### Step 1: Log In
Sign in with email or Google account. Land on a personalized dashboard.

### Step 2: See This Week's Themes
Dashboard shows 6–8 theme cards — each a key AI development from the past week. Every card displays: short title, ACT/WATCH badge, confidence score, source count.

### Step 3: Filter What Matters
Filter by ACT (needs action now) or WATCH (worth tracking). Sort by confidence level to see strongest signals first.

### Step 4: Dig Into a Theme
Click any card to see: 4–5 sentence summary, "Why It Matters" for your team, "What You Can Do" with 2–3 concrete next steps, and every source cited with URL and publication date. Week-over-week delta shown for continuing themes.

### Step 5: Download the Weekly Brief
Download a ≤700 word brief to forward to CTO or engineering org. Includes executive summary, themes ranked by confidence, watch list for 30-day tracking.

### Step 6: Compare Week Over Week
View past briefs side by side. See which themes are new vs. continuing, and how confidence scores are changing.

---

## 8. Jobs to Be Done

| Job | User | When | Goal |
|---|---|---|---|
| Surface the 6–8 most important AI signals this week | AI Platform PM | Every Monday | Replace 15 hrs manual review with 10-min read |
| Tell me if this week's signals are new or continuing | Platform PM | Brief review | Know if a trend is accelerating or plateauing |
| Show me the evidence behind each claim | Engineering Lead | Evaluating theme | Trust the theme enough to act on it |
| Give me something I can share with my CTO | Platform PM | After review | Executive-ready framing without rewriting |
| Classify whether this signal requires action now or next quarter | Both | Theme detail | Prioritize without manual triage |
| Surface ecosystem trends (governance, compute costs, adoption) | Both | Weekly review | Strategic planning beyond release tracking |
| Filter to only signals relevant to my infrastructure layer | Engineering Lead | Dashboard | Reduce noise, increase relevance |

---

## 9. System Requirements

### Functional Requirements

| # | Requirement | Priority | Status |
|---|---|---|---|
| SR-1 | Ingest ≥200 signals/week from Exa (14 queries) + GitHub Trending (3-tier) | P0 | ✅ Done |
| SR-2 | Cluster signals into 6–8 themes per weekly brief | P0 | ✅ Done |
| SR-3 | Assign confidence score (0–95%) with source diversity bonus and single-signal cap | P0 | ✅ Done |
| SR-4 | Classify each theme as ACT or WATCH with balanced mix (max 3 ACT, min 5 WATCH) | P0 | ✅ Done |
| SR-5 | Generate "Why It Matters" and "What You Can Do" for each theme | P0 | ✅ Done |
| SR-6 | Attach ≥1 verified citation per theme (real, accessible URLs with published dates) | P0 | ✅ Done |
| SR-7 | Complete pipeline (trigger → themes stored) in ≤10 minutes | P0 | ✅ Done |
| SR-8 | Download weekly brief | P1 | ✅ Done |
| SR-9 | Week-over-week delta tracking per theme | P1 | ✅ Done |
| SR-10 | Source diversity: themes from ≥4 source types per brief | P1 | ✅ Done |
| SR-11 | Enterprise AI relevance gate — filter non-AI signals before theme generation | P1 | ✅ Done |
| SR-12 | Vendor dedup — max 1 theme per vendor | P1 | ⚠️ Partial (regression) |
| SR-13 | GitHub release roundup — merge singleton releases into 1 theme | P1 | ⚠️ Partial |

### Non-Functional Requirements

*Current performance against these targets is tracked in the Evals documentation.*

| # | Requirement | Beta Target |
|---|---|---|
| NFR-1 | Pipeline uptime | ≥99% weekly scheduled runs |
| NFR-2 | Hallucinated citations | 0 per brief |
| NFR-3 | End-to-end latency | ≤10 min trigger → stored |
| NFR-4 | Theme HHH eval — Helpful | ≥75% |
| NFR-5 | Theme HHH eval — Honest | ≥75% |
| NFR-6 | Theme HHH eval — Harmless violations | ≤5% |
| NFR-7 | Data encryption | AES-256 at rest and in transit |
| NFR-8 | LLM Judge score | ≥4.0 / 5.0 |

---

## 10. Metrics

**North Star:** % Correct Themes Per Weekly Brief — themes passing all HHH checks. Directly reflects product value delivered.

| Metric | Demo Day Target | Beta Target |
|---|---|---|
| **% Correct Themes (North Star)** | ≥60% | ≥80% |
| % Helpful | ≥60% | ≥75% |
| % Honest | ≥75% | ≥75% |
| % Harmless violations | ≤5% | ≤5% |
| Hallucinated citations | 0 | 0 |
| LLM Judge score | ≥3.5 / 5.0 | ≥4.0 / 5.0 |
| Themes per brief | 5–8 | 6–8 |
| Trend themes | — | ≥3 |
| Source types | ≥3 | ≥4 |
| Automated checks | 8/11 | 13/13 |
| Confidence ceiling | — | ≤95% |
| Brief word count | ≤700 | ≤800 |
| Pipeline latency | ≤10 min | ≤10 min |
| Vendor dedup | — | 1 per vendor |

---

## 11. TAM & Unit Economics

### Market Sizing

- **TAM:** $95–143M
- **SAM:** $21–32M
- **SOM Year 1:** $1.2M (500 users)

### Value Delivered — 36× ROI

- 15 hrs/week saved × $150/hr PM rate = **$9,000/mo value**
- Customer pays $250/mo → **36× ROI**

### Unit Economics Summary

- **Individual:** $250/mo (COGS $14.42)
- **Team 5+:** $199/seat/mo (COGS $8.24)
- **Enterprise:** Custom (COGS $1.49)
- **Gross Margin:** 94–99%

### Cost Per Pipeline Run: $1.93

| Component | Detail | Cost |
|---|---|---|
| GPT-4 Turbo — Theme Selector | 1 call · ~10k in / ~2k out | $0.16 |
| GPT-4 Turbo — Theme Writer ×8 | 8 calls · ~3k in / ~1.5k out each | $0.60 |
| GPT-4 Turbo — Verifier Agent | 1 call · ~12k in / ~6k out | $0.30 |
| GPT-4 Turbo — Brief Writer | 1 call · ~6k in / ~2k out | $0.12 |
| GPT-4 Turbo — LLM Judge (eval) | 1 call · ~10k in / ~3k out | $0.19 |
| Exa API | 14 queries × $0.04 | $0.56 |
| GitHub API | ~80 calls (free with token) | $0.00 |
| Supabase REST | ~3 calls (free tier) | $0.00 |
| **TOTAL PER RUN** | **12 LLM + 14 Exa + ~83 API** | **$1.93** |

### Monthly Infrastructure Costs

| Service | Tier | Cost/mo |
|---|---|---|
| n8n Cloud | Starter (orchestration, scheduling, 5 workflows) | ~$20 |
| Supabase | Free tier (PostgreSQL, REST API, 500 MB) | $0 |
| GCP Hosting | Cloud Run (React frontend) | ~$10 |
| Domain (GoDaddy) | Custom domain (~$100/year) | ~$8 |
| OpenAI API | Pay-as-you-go (no subscription) | Usage only |
| Exa API | Pay-as-you-go | Usage only |
| Claude Code | Max subscription (eval scoring, PM workflows) | ~$100 |
| SME Eval Reviews | PM (founder) today — hire later | $0 (future cost) |
| **TOTAL FIXED INFRA** | | **~$138/mo** |

### Total Monthly Cost (Weekly Runs)

| Component | Calculation | Cost/mo |
|---|---|---|
| Pipeline runs | 4 runs/mo × $1.93 | $7.72 |
| Fixed infrastructure | n8n + GCP + domain + Claude Code | $138.00 |
| **TOTAL** | | **$145.72/mo** |

> ⚠️ **Daily runs scenario:** If daily runs ship (roadmap P3): 30 runs/mo × $1.93 = $57.90 + $138 infra = **~$196/mo**. Note: Claude Code cost is shared across all PM workflows, not just pipeline runs.

### Unit Economics by Plan

| | Individual ($250/mo) | Team 5 ($199/seat/mo) | Enterprise (~$500/mo) |
|---|---|---|---|
| API cost/user/mo | $7.72 | $1.54 | $0.15 |
| Infra/user/mo | $6.70 | $6.70 | $1.34 |
| **Total COGS** | **$14.42** | **$8.24** | **$1.49** |
| **Gross margin** | **94.2%** | **95.9%** | **99.7%** |

### Annual Scenarios

| | Year 1 | Year 2 |
|---|---|---|
| Users | 500 | 1,500+ (ind + team + enterprise) |
| ARR | **$1.2M** | **$4.7M** |
| COGS | ~$36K | ~$100K |
| Gross profit | **$1.16M** | **~$4.6M** |
| Gross margin | ~97% | ~98% |

---

## 12. Beta Roadmap (Q2 2026)

| Priority | Item | Status |
|---|---|---|
| P0 | Cross-category trend dedup | Not started |
| P0 | GitHub roundup merge robustness | Not started |
| P0 | Tighter enterprise AI relevance gate | Not started |
| P1 | Strategic AI queries (pricing, talent, budget) | Not started |
| P2 | Source type tags on theme cards | Not started |
| P2 | 5 pilot users onboarded | Not started |
| P3 | Daily runs + Slack integration | Not started |

---

## 13. Risks & Opportunities

### Risks

*AI-specific risks (hallucination, bias, data handling, compliance) are covered in Responsible AI below.*

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| North Star stays below 80% for Beta | Medium | High | Fix relevance gate + trend dedup + roundup merge |
| OpenAI API outage during weekly run | Medium | Medium | n8n retry logic (2 retries, 5s wait); alert on failure |
| Exa API pricing/rate limit changes | Low | Medium | Tavily as fallback; architecture supports provider swap |
| Competitor launches similar product | Medium | Medium | Deepen enterprise framing + accuracy moat; daily runs |

### Opportunities

*Items already on the Beta Roadmap (daily runs, Slack, source tags, strategic queries) are listed there.*

| Opportunity | Upside | Timeline |
|---|---|---|
| Custom source configuration | Unlocks enterprise sales; higher ACV | Q3 2026 |
| Watchlist / bookmark per theme | Engagement + retention lever | Q2 2026 |
| WoW acceleration alerts | "WATCH → ACT" push notifications | Q3 2026 |

---

## 14. Responsible AI

### Risk Assessment

| Risk | Severity | Mitigation | Current Status |
|---|---|---|---|
| Hallucinated citations (fake URLs) | High | URL format validation · Exa provides real published dates · Verifier Agent ID validation | ✅ 0 in 8 consecutive runs |
| Speculative signal presented as confirmed fact | High | Date guard in Theme Writer · `pub:unknown` treated as WATCH only · No "launched this week" without dated source | ✅ Active — enforced per theme |
| Over-confident scores with thin evidence | Medium | Single-signal cap at 65% · Hard ceiling at 95% · Source diversity bonus rewards multi-source themes | ✅ Active — max 95% enforced |
| Vendor marketing bias | Medium | O4 Honest check per theme · Source diversity requirement · Independent news/legal/research sources weighted | ✅ Active — 98% Honest score |
| Non-AI signals leaking into themes | Medium | Enterprise AI relevance gate in Theme Selector · Non-AI title filter in Process Signals | ⚠️ Mostly working — occasional leaks |
| Overlapping/duplicate themes in same brief | Medium | Vendor dedup (domain + title-based) · Topic dedup in Theme Selector | ⚠️ Vendor dedup fixed — trend overlap remains |
| Stale content surfaced as this-week intelligence | Medium | Exa `startPublishedDate` filter (last 7 days) · All citations now have dates | ✅ Fixed — 0 stale since Exa migration |
| Prompt injection via ingested signal content | Low | Signals processed in isolated code nodes · LLM prompts are static templates · No user-generated input in pipeline | ✅ Active |
| Unfair competitor disparagement | Low | A2 Harmless check per theme · 0 violations across all runs | ✅ 0 violations |

### Transparency & Accountability

- **User Transparency:** Every theme shows confidence score + citation count + source type + published date. Users can independently assess evidence quality.
- **Confidence Explainability:** Users see what drives each score: signal count, source types (vendor/news/research), and WoW continuation status. Confidence is evidence, not a black box.
- **Human Oversight:** AI augments — never replaces. Platform Leaders make final decisions. Confidence scores flag uncertainty, not certainty.

### Compliance

| Standard | Status | Notes |
|---|---|---|
| GDPR / CCPA | ✅ Compliant | No PII in signal processing pipeline |
| Data retention | ✅ Minimal | Only public signal content stored · Zero-retention option planned |
| SOC 2 Type II | ⚠️ Planned | Certification for Beta launch |
| Terms of service | ⚠️ Planned | Drafted before Beta user onboarding |

---

## 15. Technical Architecture Summary

### Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Orchestration | n8n Cloud (n8n.io) | Pipeline orchestration, scheduling, node execution |
| LLM | OpenAI GPT-4 Turbo | Theme Selector, Theme Writer (×8), Verifier Agent, Brief Writer |
| Web Search | Exa API | Signal ingestion with date filtering, category filters, domain control |
| Code Intelligence | GitHub API v3 | 3-tier trending: releases, new repos, velocity spikes |
| Database | Supabase (PostgreSQL) | Theme storage, pipeline runs, eval reports, prompt versions |
| Frontend | React + TypeScript (V0) | Themes dashboard, brief viewer |
| Hosting | Google Cloud Platform | Frontend deployment |

### Multi-Agent Pipeline (4 agents, 12 LLM calls per run)

```
Schedule Trigger → Ingestion (Exa + GitHub) → Process Signals → Cluster Builder
     ↓
Theme Selector (1 call)
     ↓
Theme Writer (8 parallel calls)
     ↓
Aggregate Themes
     ↓
Verifier Agent (1 call, 12 rules)
     ↓
Deterministic Score + Confidence
     ↓
Brief Writer (1 call)
     ↓
Save to Supabase
```

---

## 16. Appendix

### Glossary

- **ACT:** Signal tier requiring immediate action (≥2 vendor sources + specific release)
- **WATCH:** Signal tier for tracking over 30 days (trends, patterns, single-source items)
- **HHH:** Helpful, Honest, Harmless — the 22-question evaluation rubric
- **North Star:** % Correct Themes — themes passing all 22 HHH checks with zero failures
- **WoW:** Week-over-week delta tracking

### Related Documents

- `CalmFalcon - Technical Architecture.md` — Full pipeline architecture, data flow, API dependencies
- `CalmFalcon - Product Documentation.html` — Interactive product documentation
- `CalmFalcon - Setup Guide.html` — Step-by-step pipeline setup
- `evals/CalmFalcon MVP Eval Scorecard.md` — HHH evaluation rubric template
- `n8n-workflows/calmfalcon-pipeline-prompts-v37.md` — Current agent prompts (v37)

---

*CalmFalcon AI Signals Intelligence Platform — PRD v4.0 — April 2026*

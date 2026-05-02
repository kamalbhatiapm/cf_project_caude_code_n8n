# CalmFalcon — MVP Demo Day Slides
**March 28, 2026**

---

## Slide 1 — Title

# CalmFalcon
### AI Signals Intelligence for Enterprise AI Teams

**Demo Day · March 28, 2026**
Built by Kamal Bhatia

---

## Slide 2 — The Problem

### AI Teams Are Drowning in Signals

**The reality for AI Platform PMs and Engineering Leads today:**

- **50+ signals per week** across GitHub, arXiv, vendor docs, newsletters
- **25 hours/week** spent manually reviewing — that's 3+ full days
- **CFOs say no to more headcount** — teams work nights and weekends
- **Missing a critical shift is costly** — wrong infrastructure bets = months of rework

> *"The AI infrastructure ecosystem is moving faster than humans can track. The cost of being late is high."*

---

## Slide 3 — The Cost of Being Late

### Why This Problem Is Urgent Now

| If you miss a signal about... | The cost is... |
|-------------------------------|----------------|
| A new inference framework gaining traction | Months of rework re-platforming |
| A vendor deprecation | Unplanned migration sprint |
| A rising security vulnerability in your stack | Compliance exposure |
| A competitor adopting a breakthrough model | Lost competitive advantage |

**The problem isn't access to information. It's synthesis.**
Teams have too many sources, no structured intelligence layer.

---

## Slide 4 — The Solution

### CalmFalcon: Clear Signals. Faster Decisions.

**What we do:**
Transform fragmented AI ecosystem signals into structured, confidence-scored weekly intelligence — so enterprise AI teams spend 4 hours reviewing instead of 25.

**Before CalmFalcon:**
- 50 raw signals → 25 hours of manual review → inconsistent quality

**After CalmFalcon:**
- 50 raw signals → AI clusters into 5–8 actionable themes → 4 hours of high-confidence review → 21 hours saved

**The shift:** From raw information consumer → strategic signal reviewer

---

## Slide 5 — How It Works

### Multi-Agent Pipeline (Built in n8n)

```
INGEST → CLUSTER → SCORE → CLASSIFY → BRIEF → DELIVER
```

**Step 1 — Ingest** (4 source types, automated weekly)
- Top 50 GitHub repos (velocity + star momentum)
- AI research papers (arXiv + curated sources)
- Vendor official docs + release notes
- Top 20 public AI newsletters (Substack, LinkedIn, X)

**Step 2 — Cluster**
- AI groups related signals into coherent themes
- Deduplication catches overlapping signals across sources

**Step 3 — Score & Classify**
- Confidence score (0–100%) per theme
- Signal type tag: **Breaking · Rising · Emerging · Stable · Declining**

**Step 4 — Brief**
- Each theme includes: Summary · Why It Matters · What You Can Do · Citations
- Downloadable weekly brief

**Step 5 — Deliver**
- Frontend dashboard (built on V0) deployed on GCP
- Full citation transparency — every claim traceable to source

---

## Slide 6 — What We Built (MVP)

### Shipped for Demo Day

| Layer | Technology | Status |
|-------|-----------|--------|
| **Backend pipeline** | n8n multi-agent flow | ✅ Live |
| **Frontend dashboard** | V0 + React/TypeScript | ✅ Live |
| **Deployment** | GCP (US Central) | ✅ Live |
| **Evaluation flow** | n8n eval pipeline | ✅ Live |
| **AI models** | GPT-4 + Claude Opus | ✅ Integrated |
| **Source coverage** | GitHub, papers, vendors, newsletters | ✅ 4/4 types |

**Core features delivered:**
- Themes Dashboard with confidence scores and signal type tags
- Click-through: Why It Matters · Supporting Signals · Citations
- Week-over-week delta tracking
- Downloadable weekly brief

---

## Slide 7 — Live Demo

### [Live Product Walkthrough]

**Demo flow (5 minutes):**

1. Show the **Themes Dashboard** — clustered weekly brief, confidence scores, signal type tags
2. Click into a **Breaking theme** — Why It Matters, citations, source traceability
3. Show **week-over-week delta** — what changed since last brief
4. Download the **weekly brief PDF**
5. Show the **n8n evaluation flow** running against the golden set

---

## Slide 8 — Evaluation Framework

### How We Know It's Working

**HHH Framework — launch criteria:**

| Phase | Helpful | Honest | Harmless |
|-------|---------|--------|----------|
| Demo Day (today) | ≥ 60% | ≥ 75% | ≤ 5% violations |
| Beta | ≥ 70% | ≥ 85% | ≤ 3% violations |
| GA | ≥ 80% | ≥ 90% | ≤ 2% violations |

**Precision & Recall — 3 areas measured against 20-signal golden set:**

| Area | Precision | Recall | F1 | Priority |
|------|-----------|--------|----|----------|
| Signal Classification (Breaking) | ≥ 80% | **≥ 85%** | ≥ 0.75 | Recall first — missing critical signal is worse |
| Theme Clustering | **≥ 85%** | ≥ 80% | ≥ 0.75 | Precision first — noise pollutes themes |
| Guardrail Detection | ≥ 70% | **≥ 95%** | ≥ 0.75 | Recall critical — harmful content = trust broken |

**Golden set:** 20 signals across all 4 source types, SME-labeled by Kamal

---

## Slide 9 — North Star & Key Metrics

### The One Metric That Matters

**North Star: % Correct Themes Identified Per Weekly Brief**
- Target at Demo Day: ≥ 60–70% (learning phase)
- Target at GA: ≥ 80%

**Supporting metrics at Demo Day:**
- Pipeline completion rate: ≥ 70% without manual intervention
- End-to-end latency: ≤ 10 min per brief
- Source coverage: ≥ 90% (all 4 source types scraped per run)
- Zero hallucinated citations per brief

**The value equation:**
- Before: 25 hrs/week manual review
- After: 4 hrs/week with CalmFalcon
- **21 hours saved weekly per user**

---

## Slide 10 — What's Next

### Q2 2026 Roadmap

**Immediately post-Demo Day:**
- [ ] Run golden set evaluation, report first HHH + F1 scores
- [ ] Onboard 2–3 beta users (AI Platform PMs at Series B+ companies)
- [ ] Set up auto-eval in n8n (LLM-as-Judge for Helpfulness + Honesty)

**Q2 2026 priorities:**
- Email delivery of weekly briefs
- Watchlist / bookmark specific themes
- Week-over-week acceleration tracking
- Custom source ingestion (user-defined feeds)
- Enterprise security: SSO (SAML), RBAC, audit logs

**The mission:**
Become the intelligent layer between AI teams and the fast-moving AI ecosystem — eliminating manual research without sacrificing accuracy.

---

## Slide 11 — The Ask

### What We Need to Win

**From the demo audience:**
- **Feedback:** Where did the themes miss? What signals were wrong?
- **Introductions:** AI Platform PMs or Engineering Leads at Series B+ companies
- **Beta users:** 2–3 teams willing to use CalmFalcon for their weekly AI review

**Our commitment:**
- Weekly brief delivered every Monday morning
- SME reviews every brief — you get human-verified AI intelligence
- Feedback loop: thumbs up/down on every theme

> **CalmFalcon:** The fastest way for AI teams to know what changed in the AI ecosystem this week — and why it matters.

---

*Presented by Kamal Bhatia · CalmFalcon · March 28, 2026*

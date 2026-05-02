# CalmFalcon Agent Eval — Runs 38–40

**Date range:** 2026-04-06 | **Prompt version:** pv-actwatch-v37 | **Evaluator:** Claude Code (auto)
**Runs:** Run 38 (run-1775455059671) · Run 39 (run-1775456222851) · Run 40 (run-1775463704202)

> Scored against the 4 agent eval rubrics: Theme Selector (3 dimensions), Theme Writer (4 dimensions), Verifier Agent (5 dimensions), Brief Writer (4 dimensions).

---

## Agent 1: Theme Selector

**Rubric:** `Agent Eval - Theme Selector.md` | Dimensions: Selection Integrity, Selection Quality, Deduplication Accuracy

### Run 38

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Selection Integrity | 5/5 = 100% | ≥80% | ✅ | Exactly 8 clusters, all IDs valid, topic_anchors populated |
| Selection Quality | 3/5 = 60% | ≥60% | ⚠️ | Substack (not AI infra) and Google Vids (consumer tool) selected; only 4/8 event-anchored |
| Dedup Accuracy | 0/3 = 0% | ≥90% | ❌ | **3 Google themes** passed through (Gemma 4 + Inference Control + Vids). Subdomain rule not applied. |

**Event-Anchored (North Star): 4/8 = 50%** ⚠️
**Overall: ❌ FAIL** — dedup regression is critical

### Run 39

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Selection Integrity | 4/5 = 80% | ≥80% | ✅ | 7 themes output (1 short of 8 target) — S1 fails |
| Selection Quality | 3/5 = 60% | ≥60% | ⚠️ | AWS Deadline Cloud (VFX tool, not AI) leaked through relevance gate; themes 3+4 overlap (agentic AI + enterprise adoption = same topic) |
| Dedup Accuracy | 3/3 = 100% | ≥90% | ✅ | **Google dedup fixed** — only Gemma 4 selected. No vendor duplicates. |

**Event-Anchored (North Star): 4/7 = 57%** ⚠️
**Overall: ⚠️ PARTIAL** — dedup fixed, but theme count short + topic overlap + relevance leak

### Run 40

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Selection Integrity | 5/5 = 100% | ≥80% | ✅ | Exactly 8 clusters, all IDs valid, topic_anchors populated |
| Selection Quality | 3/5 = 60% | ≥60% | ⚠️ | Substack (theme 5 — not AI infra) and OpenMontage (theme 8 — video tool) leaked through relevance gate |
| Dedup Accuracy | 1/3 = 33% | ≥90% | ❌ | **2 Google themes** (Gemma 4 + Inference Control). Vendor dedup regressed from Run 39. |

**Event-Anchored (North Star): 5/8 = 63%** ✅ Best ever
**Overall: ❌ FAIL** — vendor dedup regressed, relevance gate still leaking

### Theme Selector Trend (Runs 38→40)

| Metric | Run 38 | Run 39 | Run 40 | Trend |
|--------|--------|--------|--------|-------|
| Integrity | 100% ✅ | 80% ✅ | 100% ✅ | Stable |
| Quality | 60% ⚠️ | 60% ⚠️ | 60% ⚠️ | Flat — relevance gate needs work |
| Dedup | 0% ❌ | 100% ✅ | 33% ❌ | Inconsistent — not reliable |
| Event-Anchored | 4/8 | 4/7 | 5/8 | ↑ Improving |

---

## Agent 2: Theme Writer

**Rubric:** `Agent Eval - Theme Writer.md` | Dimensions: Output Integrity, Hallucination Prevention, Content Quality, Tier & Confidence Accuracy

### Run 38 (8 calls)

| Dimension | Avg Score | Gate | Status | Notes |
|-----------|-----------|------|--------|-------|
| Output Integrity | 4/4 = 100% | 100% | ✅ | All 8 calls produced clean JSON. No preamble, all fields present, all IDs valid. |
| Hallucination | 3/3 = 100% | 100% | ✅ | Zero invented names, versions, or dates. pub:unknown respected. |
| Content Quality | 4.5/6 = 75% | ≥75% | ✅ | Title banned word in theme 3 ("Evolving Trends in..."). Theme 6 title "Enhances" also banned. 6/8 calls clean. |
| Tier & Confidence | 2.5/3 = 83% | ≥80% | ✅ | ACT correctly applied to Gemma 4 only. Confidence spread: 38pts (95→57). Theme 4 and 5 both Google — should be same vendor but TW can't see other calls. |

**% Passing Calls: 6/8 = 75%** ⚠️ (TW3 banned title, TW6 banned title)

### Run 39 (7 calls)

| Dimension | Avg Score | Gate | Status | Notes |
|-----------|-----------|------|--------|-------|
| Output Integrity | 4/4 = 100% | 100% | ✅ | All 7 clean JSON. |
| Hallucination | 3/3 = 100% | 100% | ✅ | Zero hallucinations. |
| Content Quality | 4/6 = 67% | ≥75% | ❌ | Title banned words: "Trends" (TW2), "Challenges" (TW3), "Navigating" (TW4), "Expanding" (TW5). 3/7 calls clean. |
| Tier & Confidence | 2.5/3 = 83% | ≥80% | ✅ | ACT correctly on Gemma 4 only. Spread: 38pts (95→57). |

**% Passing Calls: 3/7 = 43%** ❌ (title quality regression)

### Run 40 (8 calls)

| Dimension | Avg Score | Gate | Status | Notes |
|-----------|-----------|------|--------|-------|
| Output Integrity | 4/4 = 100% | 100% | ✅ | All 8 clean JSON. |
| Hallucination | 3/3 = 100% | 100% | ✅ | Zero hallucinations across all 8 calls. |
| Content Quality | 4.5/6 = 75% | ≥75% | ✅ | Title banned word: "Trends" (TW4), "Diverse" (TW5). Summary quality strong — themes 1–4 are publication-ready. |
| Tier & Confidence | 2.5/3 = 83% | ≥80% | ✅ | ACT correctly on Gemma 4 only. Spread: 38pts (95→57). |

**% Passing Calls: 6/8 = 75%** ⚠️ (TW4 and TW5 banned titles)

### Theme Writer Trend (Runs 38→40)

| Metric | Run 38 | Run 39 | Run 40 | Trend |
|--------|--------|--------|--------|-------|
| Output Integrity | 100% ✅ | 100% ✅ | 100% ✅ | Rock solid |
| Hallucination | 100% ✅ | 100% ✅ | 100% ✅ | Rock solid |
| Content Quality | 75% ✅ | 67% ❌ | 75% ✅ | Bouncing — banned titles persistent |
| Tier & Confidence | 83% ✅ | 83% ✅ | 83% ✅ | Stable |
| % Passing Calls | 75% | 43% | 75% | ↑ Recovered |

---

## Agent 3: Verifier Agent

**Rubric:** `Agent Eval - Verifier Agent.md` | Dimensions: Output Integrity, Signal ID Rules, Tier & Confidence, Content Correction, Topical Coherence

### Run 38

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Output Integrity | 3/3 = 100% | 100% | ✅ | Clean JSON, no commentary, all theme_ids preserved |
| Signal ID Rules | 3/3 = 100% | ≥90% | ✅ | All IDs valid against signal cards. 8 themes in → 8 out. No themes incorrectly removed. |
| Tier & Confidence | 3/4 = 75% | ≥75% | ✅ | ACT preserved for Gemma 4 (correct). Spread: 38pts ✅. Mix: ACT×1/WATCH×7 — no WATCH→ACT upgrade attempted (no qualifying themes). R7 ⚠️ only 1 ACT. |
| Content Correction | 1/3 = 33% | ≥80% | ❌ | R8 ✅ (no banned action phrases). **R9 ❌** — "Evolving Trends in..." and "Enhances" passed through uncorrected. R10 ✅. |
| Topical Coherence | 3/4 = 75% | ≥75% | ✅ | Google Vids signal retained in theme (off-topic but not cross-theme). No duplicate signal_ids. |

**Theme Preservation: 8/8 = 100%** ✅
**Overall: ❌ FAIL** — Rule 7 (banned title fix) not applied

### Run 39

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Output Integrity | 3/3 = 100% | 100% | ✅ | Clean JSON, all theme_ids preserved |
| Signal ID Rules | 3/3 = 100% | ≥90% | ✅ | All IDs valid. 7 themes in → 7 out. |
| Tier & Confidence | 3/4 = 75% | ≥75% | ✅ | ACT preserved for Gemma 4. Spread: 38pts ✅. |
| Content Correction | 1/3 = 33% | ≥80% | ❌ | **R9 ❌** — "Trends" (TW2), "Challenges" (TW3), "Navigating" (TW4), "Expanding" (TW5) — 4 banned titles passed uncorrected. R8 ✅. R10 ✅. |
| Topical Coherence | 3/4 = 75% | ≥75% | ✅ | Themes 3+4 overlap (agentic AI scaling + enterprise AI adoption) not caught. No duplicate signal_ids. |

**Theme Preservation: 7/7 = 100%** ✅
**Overall: ❌ FAIL** — Rule 7 worst performance (4 banned titles passed)

### Run 40

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Output Integrity | 3/3 = 100% | 100% | ✅ | Clean JSON, all theme_ids preserved |
| Signal ID Rules | 3/3 = 100% | ≥90% | ✅ | All IDs valid. 8 themes in → 8 out. |
| Tier & Confidence | 3/4 = 75% | ≥75% | ✅ | ACT preserved for Gemma 4. Spread: 38pts ✅. |
| Content Correction | 2/3 = 67% | ≥80% | ❌ | **R9 ❌** — "Trends" (theme 4) and "Diverse" (theme 5) passed uncorrected. Improved from Run 39 (2 vs 4 failures). R8 ✅. R10 ✅. |
| Topical Coherence | 4/4 = 100% | ≥75% | ✅ | No off-topic signals retained. No duplicate signal_ids. |

**Theme Preservation: 8/8 = 100%** ✅
**Overall: ❌ FAIL** — Rule 7 still failing but improving

### Verifier Agent Trend (Runs 38→40)

| Metric | Run 38 | Run 39 | Run 40 | Trend |
|--------|--------|--------|--------|-------|
| Output Integrity | 100% ✅ | 100% ✅ | 100% ✅ | Rock solid |
| Signal ID Rules | 100% ✅ | 100% ✅ | 100% ✅ | Rock solid |
| Tier & Confidence | 75% ✅ | 75% ✅ | 75% ✅ | Stable |
| Content Correction | 33% ❌ | 33% ❌ | 67% ❌ | ↑ Improving but still failing |
| Topical Coherence | 75% ✅ | 75% ✅ | 100% ✅ | ↑ Improving |
| Banned titles passed | 2 | 4 | 2 | ↓ Better but not 0 |
| Theme Preservation | 100% | 100% | 100% | Rock solid |

---

## Agent 4: Brief Writer

**Rubric:** `Agent Eval - Brief Writer.md` | Dimensions: Format Compliance, Watch List Integrity, Content Quality, Audience Fit

### Run 38

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Format Compliance | 5/7 = 71% | ≥85% | ❌ | F1 ❌ (765 words — over 700 ceiling). F6 ✅ (confidence-ordered). F7 ✅ (correct icons). All 6 sections present ✅. |
| Watch List Integrity | 4/4 = 100% | 100% | ✅ | Only WATCH themes in Watch List. No invented items. No ACT contamination. |
| Content Quality | 4/5 = 80% | ≥75% | ✅ | Key Takeaway names Gemma 4 ✅. No marketing language ✅. Action items concrete ✅. One generic "Why it matters" on theme 4. |
| Audience Fit | 3/4 = 75% | ≥75% | ✅ | Peer-level tone ✅. Themes 4+6 not relevant to target persona. Key Takeaway synthesizes well. |

**Would share with VP? ⚠️ Borderline** — word count over, 2 irrelevant themes
**Overall: ❌ FAIL** — Format gate not met (word count)

### Run 39

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Format Compliance | 6/7 = 86% | ≥85% | ✅ | F1 ✅ (759 words — within 800 limit after target update). All 6 sections ✅. Confidence-ordered ✅. F4 ⚠️ Exec Summary slightly long. |
| Watch List Integrity | 4/4 = 100% | 100% | ✅ | Clean — only WATCH themes. No fabricated items. |
| Content Quality | 4/5 = 80% | ≥75% | ✅ | Key Takeaway leads with Gemma 4 ✅. Action items concrete ✅. One "Why it matters" slightly generic (theme 7). |
| Audience Fit | 3/4 = 75% | ≥75% | ✅ | Theme 7 (AWS Deadline Cloud) not relevant to AI platform audience. Peer tone maintained. Key Takeaway connects themes. |

**Would share with VP? ⚠️ Borderline** — 1 irrelevant theme, but brief quality improving
**Overall: ✅ PASS** — all gates met

### Run 40

| Dimension | Score | Gate | Status | Notes |
|-----------|-------|------|--------|-------|
| Format Compliance | 6/7 = 86% | ≥85% | ✅ | F1 ✅ (756 words — within 800). All 6 sections in correct order ✅. Confidence-ordered ✅. Correct icons ✅. |
| Watch List Integrity | 4/4 = 100% | 100% | ✅ | Clean — only WATCH themes in Watch List. All 7 WATCH themes have bullets. |
| Content Quality | 5/5 = 100% | ≥75% | ✅ | Key Takeaway names Gemma 4 + White House AI ✅. No marketing language ✅. All action items concrete and 5-day achievable ✅. "Why it matters" stack-specific on all themes ✅. |
| Audience Fit | 3/4 = 75% | ≥75% | ✅ | Themes 5 (Substack) and 8 (OpenMontage) not relevant to target persona — inherited from upstream. Peer tone excellent. Key Takeaway synthesizes trend across themes. |

**Would share with VP? ⚠️ Borderline** — best brief ever, but 2 irrelevant themes drag it down
**Overall: ✅ PASS** — all gates met, best scores ever

### Brief Writer Trend (Runs 38→40)

| Metric | Run 38 | Run 39 | Run 40 | Trend |
|--------|--------|--------|--------|-------|
| Format | 71% ❌ | 86% ✅ | 86% ✅ | ↑ Fixed |
| Watch List | 100% ✅ | 100% ✅ | 100% ✅ | Rock solid |
| Content | 80% ✅ | 80% ✅ | 100% ✅ | ↑ Best ever |
| Audience | 75% ✅ | 75% ✅ | 75% ✅ | Stable |
| Word Count | 765 | 759 | 756 | ↓ Improving |
| Would Share? | No | Borderline | Borderline | ↑ Improving |

---

## Cross-Agent Summary (Run 40 — Latest)

| Agent | Passing Dimensions | Failing Dimensions | Overall |
|-------|-------------------|-------------------|---------|
| Theme Selector | Integrity ✅ | Quality ⚠️, Dedup ❌ | ❌ |
| Theme Writer | Integrity ✅, Hallucination ✅, Tier ✅ | Content ⚠️ (banned titles) | ⚠️ |
| Verifier Agent | Integrity ✅, Signal Rules ✅, Coherence ✅ | Content Correction ❌ (Rule 7) | ❌ |
| Brief Writer | Format ✅, Watch List ✅, Content ✅, Audience ✅ | — | ✅ |

### Root Cause Chain

The failures cascade through the pipeline:

1. **Theme Selector** picks 2 non-AI themes (Substack, OpenMontage) and allows a vendor duplicate (2× Google) → these become bad themes downstream regardless of other agents' quality.
2. **Theme Writer** produces banned title words ("Trends", "Diverse") on the weaker clusters → Verifier should catch these.
3. **Verifier Agent** fails to rewrite banned titles (Rule 7 C1 correction) → bad titles reach the brief.
4. **Brief Writer** performs well given its input — the 2 irrelevant themes are inherited, not generated.

**Conclusion:** The pipeline's weakest links are Theme Selector (vendor dedup + relevance gate) and Verifier (Rule 7 title fix). Brief Writer is the strongest agent. Theme Writer is reliable on structural output but inconsistent on title quality.

---

## Recommendations

| Priority | Agent | Fix | Expected Impact |
|----------|-------|-----|-----------------|
| P0 | Theme Selector | Enforce vendor dedup in Signal Cluster Builder (deterministic pre-merge) rather than relying on LLM | Eliminates vendor duplicates — fixes 1 incorrect theme per run |
| P0 | Theme Selector | Tighter enterprise AI relevance gate — add explicit domain blocklist for non-AI tools | Eliminates non-AI themes — fixes 1–2 incorrect themes per run |
| P1 | Verifier | Strengthen Rule 7 banned title scan — add substring matching examples for "Trends", "Diverse", "Challenges", "Navigating" | Fixes 2 banned titles per run |
| P1 | Theme Selector | Cross-category topic dedup — prevent "agentic AI scaling" and "enterprise AI adoption" from being separate themes | Fixes 1 overlapping theme per run (Run 39 issue) |
| P2 | Theme Writer | Add "Challenges", "Navigating" to banned title word list in prompt | Prevents titles before Verifier needs to catch them |

**If P0 fixes land:** North Star jumps from 50% (4/8) to ~75% (6/8) — within striking distance of Beta target (≥80%).

---

*Eval completed: 2026-04-08 | Scored against rubrics v1 from Agent Eval files*

# CalmFalcon Agent Eval — Theme Writer

**Agent role:** Receives ONE signal cluster. Writes ONE complete theme JSON object with title, summary, signal_type (ACT/WATCH), confidence_score, why_it_matters, what_you_can_do, and supporting_signal_ids.

**Why this eval matters:** Theme Writer runs 8 times per pipeline execution (once per cluster). Each call is independent. Failures here manifest as: themes dropped by Aggregate Themes (if JSON has preamble), wrong tier, hallucinated product names, or flat confidence scores. Scoring each Theme Writer call separately lets you identify which cluster types cause the most problems.

---

## How to Run This Eval

1. Open n8n → Executions → select the run
2. Click the **Theme Writer** node — it shows 8 sub-executions (one per cluster)
3. For each sub-execution: click → **Input** tab (to see cluster cards) + **Output** tab (to see theme JSON)
4. Score each of the 8 calls independently
5. The eval sheet has one column per Theme Writer call (TW1–TW8)

> **Tip:** The most important dimension to check first is OUTPUT INTEGRITY — if the output isn't clean JSON, everything else is moot because the theme gets dropped at Aggregate Themes.

---

## Scoring Dimensions

### DIMENSION 1 — OUTPUT INTEGRITY
*Did the agent output clean JSON with no preamble?*

| # | Question | Pass Criteria | TW1 | TW2 | TW3 | TW4 | TW5 | TW6 | TW7 | TW8 |
|---|----------|---------------|-----|-----|-----|-----|-----|-----|-----|-----|
| I1 | Output is ONLY valid JSON — no reasoning steps, no "Step 1:", no "Output:" prefix | First character of output is `{` | | | | | | | | |
| I2 | All required fields present | theme_id, title, summary, signal_type, confidence_score, why_it_matters, what_you_can_do, supporting_signal_ids | | | | | | | | |
| I3 | supporting_signal_ids all appear verbatim in the cluster cards (Input tab) | Check each ID against the input signal cards | | | | | | | | |
| I4 | No signal_ids invented or abbreviated | IDs are character-for-character matches | | | | | | | | |

**Integrity Score per call: __ / 4** · Gate: 100% — any failure here means the theme is dropped downstream

---

### DIMENSION 2 — HALLUCINATION PREVENTION
*Did the agent invent names, versions, or dates not in the signal cards?*

| # | Question | Pass Criteria | TW1 | TW2 | TW3 | TW4 | TW5 | TW6 | TW7 | TW8 |
|---|----------|---------------|-----|-----|-----|-----|-----|-----|-----|-----|
| H1 | No invented model version numbers (e.g. GPT-5.4) | Version in title/summary must appear verbatim in a signal card title | | | | | | | | |
| H2 | No false recency claim for pub:unknown signals | Phrases like "launched this week" / "announced this week" absent when all signals are pub:unknown | | | | | | | | |
| H3 | No invented benchmark scores or statistics | Any number in summary must be traceable to a signal card | | | | | | | | |

**Hallucination Score per call: __ / 3** · Gate: 100% — hallucinations are trust-breaking

---

### DIMENSION 3 — CONTENT QUALITY
*Is the theme well-written and specific?*

| # | Question | Pass Criteria | TW1 | TW2 | TW3 | TW4 | TW5 | TW6 | TW7 | TW8 |
|---|----------|---------------|-----|-----|-----|-----|-----|-----|-----|-----|
| C1 | Title uses action verb + specific product name | Launches, Releases, Ships, Extends, etc. + named product | | | | | | | | |
| C2 | Title ≤8 words | Count words | | | | | | | | |
| C3 | No banned title words | Rise of / Advances in / Advancements in / Future of / Evolution / Landscape / Trends / Solutions / Era of absent | | | | | | | | |
| C4 | Summary exactly 4-5 sentences, 80-120 words | Count sentences and words | | | | | | | | |
| C5 | why_it_matters names specific persona + implication + urgency | "AI Platform PM" or "Engineering Lead" + specific cost/latency/architecture implication | | | | | | | | |
| C6 | what_you_can_do has 2-3 steps, no banned phrases | No "monitor", "watch", "stay informed", "consider exploring" | | | | | | | | |

**Content Score per call: __ / 6** · Gate: ≥75%

---

### DIMENSION 4 — TIER & CONFIDENCE ACCURACY
*Did the agent apply D-1/D-2 correctly and calibrate the score?*

| # | Question | Pass Criteria | TW1 | TW2 | TW3 | TW4 | TW5 | TW6 | TW7 | TW8 |
|---|----------|---------------|-----|-----|-----|-----|-----|-----|-----|-----|
| T1 | ACT only when D-1 fired (≥2 official vendor domain signals + specific named release) | Verify each vendor domain in signal cards | | | | | | | | |
| T2 | WATCH when no specific named event or fewer than 2 vendor signals | Default assignment correct | | | | | | | | |
| T3 | Confidence score in correct band for evidence quality | 3 vendor signals this week = 85-95%; 2 sources = 75-84%; 1 source = 55-64% | | | | | | | | |

**Tier Score per call: __ / 3** · Gate: ≥80%

---

## Scorecard Summary (per Theme Writer call)

| Dimension | TW1 | TW2 | TW3 | TW4 | TW5 | TW6 | TW7 | TW8 | Gate |
|-----------|-----|-----|-----|-----|-----|-----|-----|-----|------|
| Output Integrity (/ 4) | | | | | | | | | 4/4 |
| Hallucination (/ 3) | | | | | | | | | 3/3 |
| Content Quality (/ 6) | | | | | | | | | ≥4.5/6 |
| Tier Accuracy (/ 3) | | | | | | | | | ≥2.4/3 |
| **Total (/ 16)** | | | | | | | | | **≥12/16** |

---

## North Star (per call)

A Theme Writer call **passes** if ALL of the following are true:
- I1 ✅ (clean JSON output)
- H1 + H2 ✅ (no hallucinations)
- C1 + C3 ✅ (specific title, no banned words)
- T1 or T2 ✅ (tier correctly assigned)

**% Passing calls this run: __ / 8 = __%**

---

## Common Failure Patterns

| Pattern | Symptom | Likely Cause |
|---------|---------|-------------|
| Reasoning preamble | Output starts with "Step 1:" or "SCAN:" | Example in prompt showing reasoning as output |
| Flat confidence (all 62%) | Every call returns 62% | Model ignoring calibration table |
| Banned title words | "Advancements in X" | Evergreen cluster with no specific product in signals |
| pub:unknown false recency | "launched this week" despite pub:unknown | PUBLICATION DATE CHECK not followed |
| Hallucinated version | "GPT-5.4" with no matching signal card | Anti-hallucination check not applied |

---

## Run Log

| Run | Date | Avg Integrity | Avg Content | Avg Tier | % Passing Calls | Notes |
|-----|------|---------------|-------------|----------|-----------------|-------|
| 30 | 2026-03-27 | 4/4 ✅ | 64.6% ❌ | 79% ❌ | 0/8 = 0% ❌ | All 8 calls produced clean JSON; 3 banned titles (TW2/TW4/TW7); 2 false recency (TW2/TW5); flat confidence 60–62% on all calls; 5/8 failed C1 (no specific product — upstream data gap) |
| 31 | 2026-03-27 | 4/4 ✅ | 66% ⚠️ | 72% ❌ | 0/8 = 0% ❌ | Clean JSON all 8 calls ✅; 3 banned titles still passing (Enhances×2, Expanding); 4/8 capability hallucinations (model speculates on what products "likely" do); all 8 single-signal → calibration harder; false ACT on T1 (1 signal only) |
| 32 | 2026-03-27 | 4/4 ✅ | ~50% ❌ | ~60% ❌ | 0/8 = 0% ❌ | Clean JSON ✅; 3 banned titles (Enhances×3: RAGFlow, SGLang, Fireworks); confidence better spread (72,67,59,57,57,57,53,50) but calibration not precise; "Google AI December Recap" no action verb ❌ |
| 33 | 2026-03-27 | 4/4 ✅ | 33% ❌ | 33% ❌ | 0/8 = 0% ❌ | Clean JSON ✅; 2 banned titles (Enhances×2: HuggingFace, LlamaFactory); flat confidence (all 50-52) despite 3-signal themes that should score 75-84%; marketing language in 4+ summaries; "Stay updated on announcements" banned phrase in Domino |

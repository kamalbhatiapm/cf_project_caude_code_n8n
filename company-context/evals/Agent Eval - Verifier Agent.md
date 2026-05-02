# CalmFalcon Agent Eval — Verifier Agent

**Agent role:** Receives all themes aggregated by Aggregate Themes (as `{"themes": [...]}`). Applies 12 rules in order to validate and correct signal IDs, tiers, confidence scores, titles, summaries, and actionability. Returns a corrected `{"themes": [...]}` JSON.

**Why this eval matters:** The Verifier is the quality gate before output reaches the user. It must correct errors from Theme Writer without over-removing themes. The two critical failure modes are: (1) removing valid themes (too aggressive), and (2) letting bad themes through uncorrected (too passive).

---

## How to Run This Eval

1. Open n8n → Executions → select the run
2. Click the **Verifier Agent** node → **Input** tab (themes from Aggregate Themes) + **Output** tab (corrected themes)
3. Also open the **Build Evidence Pack** node → Output → copy `signal_cards` (ground truth for signal ID validation)
4. Compare input themes vs output themes for each rule below

> **Key comparison to make:** How many themes went IN vs came OUT? If the Verifier removed any theme that had ≥1 valid signal ID, that is a Rule 2 violation.

---

## Scoring Dimensions

### DIMENSION 1 — OUTPUT INTEGRITY
*Did the agent return clean JSON without commentary?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| O1 | Output is ONLY valid JSON — no explanations, no "I applied Rule 7...", no commentary | First character of output is `{` | ✅ / ❌ |
| O2 | Output JSON is parseable (`{"themes": [...]}` structure) | Valid JSON with `themes` array at root | ✅ / ❌ |
| O3 | All theme_ids unchanged from input | Compare theme_ids input vs output — must be identical | ✅ / ❌ |

**Integrity Score: __ / 3 = __%** · Gate: 100%

---

### DIMENSION 2 — SIGNAL ID RULES (Rules 1 & 2)
*Did the agent validate IDs and preserve themes correctly?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| R1 | All signal IDs in output appear verbatim in signal_cards ground truth (Rule 1) | Spot-check 5+ IDs from output against signal cards | ✅ / ❌ |
| R2 | No theme removed that had ≥1 valid signal ID in input (Rule 2) | Count themes input vs output — if fewer in output, identify why | ✅ / ❌ |
| R3 | Themes with 0 valid IDs (after Rule 1 stripping) are removed — not kept (Rule 2) | Confirm zero-signal themes did not pass through | ✅ / ❌ |

**Signal Rules Score: __ / 3 = __%** · Gate: ≥90%

---

### DIMENSION 3 — TIER & CONFIDENCE RULES (Rules 3, 4, 9)
*Did the agent preserve ACT correctly and enforce confidence spread?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| R4 | ACT tier preserved when ≥2 vendor domain signals + specific release title present (Rule 3) | If Theme Writer assigned ACT with qualifying signals, Verifier kept it | ✅ / ❌ / N/A |
| R5 | ACT downgraded only when evidence absent — not arbitrarily (Rule 3) | Any ACT→WATCH change justified by fewer than 2 vendor signals | ✅ / ❌ / N/A |
| R6 | Confidence scores span ≥20 points across all output themes (Rule 4) | max(score) - min(score) ≥ 20 | ✅ / ❌ |
| R7 | Output contains both ACT and WATCH tiers — if ACT evidence exists (Rule 9) | Check tier mix in output | ✅ / ❌ |

**Tier Score: __ / 4 = __%** · Gate: ≥75%

---

### DIMENSION 4 — CONTENT CORRECTION RULES (Rules 6, 7, 11)
*Did the agent fix what needed fixing?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| R8 | No what_you_can_do in output contains banned phrases (Rule 6) | Scan all output themes for "monitor", "watch", "stay informed", "consider exploring" | ✅ / ❌ |
| R9 | No banned title words in any output theme (Rule 7) | Scan titles for "Advancements in", "Enhancements in", "Rise of", "Evolution of", "Future of", "Landscape", "Era of", "Surge in" | ✅ / ❌ |
| R10 | No summaries contain hallucinated future dates (Rule 11) | Specific dates (e.g. "April 17, 2026") absent unless traceable to a signal card | ✅ / ❌ |

**Content Correction Score: __ / 3 = __%** · Gate: ≥80%

---

### DIMENSION 5 — TOPICAL COHERENCE & DEDUP (Rules 10, 12)
*Did the agent keep topically-relevant signals and deduplicate correctly?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| R11 | No signal clearly off-topic retained in a theme (Rule 10) | e.g. Apple earnings signal in an NVIDIA theme | ✅ / ❌ |
| R12 | No topically-relevant signal incorrectly removed (Rule 10 over-application) | Signal removed only if clearly different company/topic | ✅ / ❌ |
| R13 | No signal_id appears in more than one output theme (Rule 12) | Build a flat list of all signal_ids across all output themes — check for duplicates | ✅ / ❌ |
| R14 | Rule 12 dedup did not reduce any theme to 0 signals | Every output theme has ≥1 signal_id | ✅ / ❌ |

**Coherence Score: __ / 4 = __%** · Gate: ≥75%

---

## Scorecard Summary

| Dimension | Score | Gate | Status |
|-----------|-------|------|--------|
| Output Integrity | __% | 100% | ✅ / ❌ |
| Signal ID Rules | __% | ≥90% | ✅ / ❌ |
| Tier & Confidence | __% | ≥75% | ✅ / ❌ |
| Content Correction | __% | ≥80% | ✅ / ❌ |
| Topical Coherence | __% | ≥75% | ✅ / ❌ |

---

## North Star

**Theme preservation rate:** (themes out) / (themes in with ≥1 valid signal ID) = __%

A passing Verifier run:
- Preserves ≥90% of themes that had valid signals
- Enforces ≥20 pt confidence spread
- Has 0 banned title words in output
- Has 0 duplicate signal_ids across themes

---

## Common Failure Patterns

| Pattern | Symptom | Rule Violated | Root Cause |
|---------|---------|--------------|------------|
| Too aggressive removal | 8 themes in → 3 out | Rule 2 | Rule 12 dedup cascades to 0-signal themes |
| No confidence spread | All themes 60-62% | Rule 4 | Spread enforcement not applied |
| Banned titles pass through | "Advancements in X" in output | Rule 7 | Model skipped banned word scan |
| Commentary before JSON | Output starts with "I applied..." | O1 | Model didn't follow "silently" instruction |
| Duplicate signals | linkedin.com ID in T3 and T5 | Rule 12 | Dedup rule not applied |

---

## Run Log

| Run | Date | Integrity | Signal Rules | Tier | Content | Coherence | Themes In | Themes Out | Notes |
|-----|------|-----------|--------------|------|---------|-----------|-----------|------------|-------|
| 30 | 2026-03-27 | 100% ✅ | 83% ❌ | 0% ❌ | 67% ❌ | 50% ❌ | 8 | 7 | Rule 4 spread not enforced (2pt spread); Rule 7 missing (3 banned titles passed); Rule 9 failed (all WATCH); Rule 12 missing (linkedin.com duplicate in T6+T7); Rules 7+12 added in v32 |
| 31 | 2026-03-27 | 100% ✅ | 100% ✅ | 50% ❌ | 67% ❌ | 75% ✅ | 8 | 8 | Rule 3 failed (ACT on 1 signal — T1 NVIDIA); Rule 4 spread 15pts still <20 (formula applied but insufficient); Rule 7 banned verbs "Enhances"×2 + "Expanding" passed (ban list uses phrases not verb roots); Rule 9 ACT upgrade fired without checking signal count |
| 32 | 2026-03-27 | 100% ✅ | ~100% ✅ | 50% ❌ | ~50% ❌ | — | 8 | 8 | Rule 4 WORKED (22pt spread) ✅; Rule 9 WORKED (NVIDIA→ACT at 72) ✅; Rule 7 still failing — "Enhances" in 3 output titles; Rule 6 unknown |
| 33 | 2026-03-27 | 100% ✅ | ~100% ✅ | 0% ❌ | 33% ❌ | — | 8 | 8 | Rule 4 NOT applied (2pt spread) ❌; Rule 9 NOT applied (NVIDIA has investor.nvidia.com + 3 signals → stayed WATCH) ❌; Rule 7 still failing — "Enhances" in 2 titles; Rule 6 failed — "Stay updated on announcements" passed through; same prompt as R32 — reliability issue |
| 34 | 2026-03-28 | 100% ✅ | 100% ✅ | 50% ❌ | 100% ✅ | 100% ✅ | 8 | 8 | Rule 3 NOT applied — theme-001 (12 GitHub signals) + theme-002 (4 GitHub signals) stayed ACT; github.com not a vendor domain; spread 60pts ✅; content correction 100% ✅; theme preservation 100% ✅ |

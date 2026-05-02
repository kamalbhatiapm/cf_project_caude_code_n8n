# CalmFalcon Agent Eval — Theme Selector

**Agent role:** Receives pre-computed keyword→signal_id clusters. Selects exactly 8, deduplicates vendors, scores by this-week specificity, and passes selected clusters downstream to Theme Writer.

**Why this eval matters:** Theme Selector is the first editorial decision in the pipeline. A bad selection propagates through all downstream agents. If it picks 5 evergreen category clusters, all 5 resulting themes will fail H1 and H5 regardless of how well Theme Writer performs.

---

## How to Run This Eval

1. Open n8n → Executions → select the run you want to evaluate
2. Click the **Theme Selector** node → **Output** tab
3. Copy the `selected_clusters` array
4. Also open the **Build Signal Clusters** node → Output tab → copy `signal_clusters` (the raw cluster input)
5. Score each question below against these two outputs

---

## Scoring Dimensions

### DIMENSION 1 — SELECTION INTEGRITY
*Did the agent follow hard structural rules?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| S1 | Exactly 8 clusters in output | Count = 8 | ✅ / ❌ |
| S2 | No 2 clusters from the same vendor | Scan vendor names across all 8 clusters | ✅ / ❌ |
| S3 | All signal_ids in output appear verbatim in raw cluster input | Spot-check 5 IDs against signal_clusters input | ✅ / ❌ |
| S4 | topic_anchor populated for every cluster | No null or empty topic_anchor field | ✅ / ❌ |
| S5 | No signal_ids modified or abbreviated | IDs are character-for-character matches | ✅ / ❌ |

**Integrity Score: __ / 5 = __%** · Gate: ≥80%

---

### DIMENSION 2 — SELECTION QUALITY
*Did the agent pick the best clusters available?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| S6 | ≥4 of 8 clusters have event-anchored topic_anchor (not "general trend" / "evergreen") | Count clusters with specific product/event in topic_anchor | ✅ / ❌ |
| S7 | Clusters with specific product names selected before pure category clusters | High-scored clusters appear in top half of output | ✅ / ❌ |
| S8 | No obviously stronger cluster skipped in favor of a weaker one | Compare skipped clusters (in raw input but not output) against selected ones | ✅ / ❌ |
| S9 | Working titles are descriptive — not just the raw keyword | e.g. "NVIDIA Physical AI Models launch" not just "nvidia" | ✅ / ❌ |
| S10 | Evergreen clusters (if included) are marked with "evergreen" in topic_anchor | Allows Theme Writer to use hedged language | ✅ / ❌ |

**Quality Score: __ / 5 = __%** · Gate: ≥60%

---

### DIMENSION 3 — DEDUPLICATION ACCURACY
*Did the agent correctly merge multi-cluster vendors?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| S11 | If raw input had 2+ clusters from same vendor, they were merged | Check: does any vendor appear twice in raw input but once in output? | ✅ / ❌ / N/A |
| S12 | Merged cluster's signal_ids include signals from all source clusters | Verify merged cluster contains IDs from both originals | ✅ / ❌ / N/A |
| S13 | Merged cluster uses the most specific working_title (not the most generic) | e.g. "NVIDIA Physical AI Models + MLOps Partnerships" not "NVIDIA" | ✅ / ❌ / N/A |

**Dedup Score: __ / (N applicable) = __%** · Gate: ≥90%

---

## Scorecard Summary

| Dimension | Score | Gate | Status |
|-----------|-------|------|--------|
| Selection Integrity | __% | ≥80% | ✅ / ❌ |
| Selection Quality | __% | ≥60% | ✅ / ❌ |
| Deduplication Accuracy | __% | ≥90% | ✅ / ❌ |

---

## North Star

**% of selected clusters that are event-anchored (not evergreen):** __ / 8 = __%

A run where ≥5/8 clusters are event-anchored is a passing Theme Selector run. Below 4/8 means downstream themes will mostly fail H1 regardless of other fixes.

---

## Common Failure Patterns

| Pattern | Symptom | Root Cause |
|---------|---------|------------|
| All-evergreen selection | topic_anchor = "general trend" on 6+ clusters | No event-anchored clusters existed in raw input OR agent scored incorrectly |
| Duplicate vendor themes | Two NVIDIA clusters both in output | Dedup logic not applied |
| ID mismatch | signal_ids in output don't match raw cluster input | Agent abbreviated or invented IDs |
| Fewer than 8 | Output has 6-7 clusters | Agent didn't follow the hard 8-minimum rule |

---

## Run Log

| Run | Date | Integrity | Quality | Dedup | Event-Anchored | Notes |
|-----|------|-----------|---------|-------|----------------|-------|
| 30 | 2026-03-27 | 80% ⚠️ | 20% ❌ | 100% ✅ | 0/8 = 0% ❌ | 2 LLM Eval clusters selected (topic duplicate); 0 event-anchored clusters; all themes guaranteed evergreen downstream |
| 31 | 2026-03-27 | 60% ❌ | 50% ⚠️ | 0% ❌ | ~4/8 = 50% ⚠️ | Vendor dedup FAILED: 2×NVIDIA (Physical AI + MLOps) + 2×Google (Gemini + Vertex AI) both in output; model treated subdomains as separate vendors; all 8 clusters single-signal (upstream clustering issue) |
| 32 | 2026-03-27 | 100% ✅ | ~60% ⚠️ | 100% ✅ | ~4/8 ⚠️ | Vendor dedup FIXED by pre-built clusters in v34; no 2×NVIDIA or 2×Google; "Google AI December Updates Recap" selected — stale/evergreen cluster ❌ |
| 33 | 2026-03-27 | 100% ✅ | ~50% ❌ | 100% ✅ | ~3–4/8 ⚠️ | Vendor dedup FIXED; different vendor mix (HuggingFace, LlamaFactory replacing Fireworks/Google); ~4 GitHub/evergreen clusters selected limiting downstream quality |
| 34 | 2026-03-28 | 100% ✅ | 40% ❌ | 100% ✅ | theme-001 (GitHub category cluster) + theme-008 (stale December content) + theme-005 (evergreen); 4/8 event-anchored; North Star ⚠️ |

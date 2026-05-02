# CalmFalcon Agent Eval — Brief Writer

**Agent role:** Receives the verified, scored theme JSON from Deterministic Score. Writes the complete CalmFalcon Weekly Brief in strict markdown format with word budgets per section. This is the user-facing output — the last agent in the pipeline.

**Why this eval matters:** Even if all upstream agents perform correctly, a Brief Writer failure means the end user gets a malformed, padded, or tone-incorrect brief. This eval catches word-count violations, Watch List contamination (ACT themes sneaking in), and generic/marketing language that erodes credibility with enterprise readers.

---

## How to Run This Eval

1. Open n8n → Executions → select the run
2. Click the **Brief Writer** node → **Output** tab → copy the full markdown text
3. Also check the **Deterministic Score** node → Output tab → note which themes are ACT vs WATCH
4. Score the brief below

> **Tip:** Paste the brief into a word counter (wordcounter.net) before scoring B1.

---

## Scoring Dimensions

### DIMENSION 1 — FORMAT COMPLIANCE
*Did the agent follow the structural requirements exactly?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| F1 | Total word count 580–700 words | Count total words in brief output | ✅ / ❌ |
| F2 | All 6 sections present in correct order | Header → Key Takeaway → Executive Summary → Key Themes → Watch List → Footer | ✅ / ❌ |
| F3 | Key Takeaway ≤100 words, 4–5 sentences | Count words + sentences in Key Takeaway section | ✅ / ❌ |
| F4 | Executive Summary ≤60 words, 2–3 sentences | Count words + sentences in Executive Summary | ✅ / ❌ |
| F5 | Each Key Theme block has all 3 sub-sections | **What happened:** / **Why it matters for your stack:** / **Action this week:** all present for every theme | ✅ / ❌ |
| F6 | Themes listed highest confidence first | Compare ordering vs confidence scores from Deterministic Score output | ✅ / ❌ |
| F7 | Correct signal type icons used | ACT=🔴, WATCH=🟡 — verify each theme's icon matches its signal_type | ✅ / ❌ |

**Format Score: __ / 7 = __%** · Gate: ≥85%

---

### DIMENSION 2 — WATCH LIST INTEGRITY
*Did the agent keep the Watch List clean?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| W1 | Watch List contains ONLY themes with signal_type=WATCH | Cross-reference each Watch List item against Deterministic Score output | ✅ / ❌ |
| W2 | No ACT theme appears in Watch List | Scan Watch List items — none should match an ACT theme title | ✅ / ❌ |
| W3 | No Watch List items invented from general AI knowledge | Every Watch List entry corresponds to a theme in the verified JSON | ✅ / ❌ |
| W4 | If zero WATCH themes exist, correct fallback used | Brief contains exactly: "🟡 No watch signals this week — all confirmed themes require immediate action." | ✅ / ❌ / N/A |

**Watch List Score: __ / (N applicable) = __%** · Gate: 100% — Watch List contamination is a trust-breaking error

---

### DIMENSION 3 — CONTENT QUALITY
*Is the brief written at peer-level with specificity and no filler?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| C1 | Key Takeaway references actual vendors, tools, or benchmarks from the themes | No generic "AI teams saw developments this week" — names specific products | ✅ / ❌ |
| C2 | No marketing language | "Exciting", "game-changing", "revolutionary", "unprecedented", "groundbreaking" absent | ✅ / ❌ |
| C3 | Action items are concrete and achievable in 5 business days | No "monitor", "watch", "stay informed", "consider exploring" | ✅ / ❌ |
| C4 | "Why it matters for your stack" is stack-specific | References inference, orchestration, cost, vendor decisions, or architecture — not generic "important for AI teams" | ✅ / ❌ |
| C5 | Executive Summary states the single most impactful signal | Not a list — one clear statement about what happened and why it matters now | ✅ / ❌ |

**Content Score: __ / 5 = __%** · Gate: ≥75%

---

### DIMENSION 4 — AUDIENCE FIT
*Would an AI Platform PM or Engineering Lead find this useful and credible?*

| # | Question | Pass Criteria | Score |
|---|----------|---------------|-------|
| A1 | Peer-level tone throughout | Reads like a senior analyst briefing a technical peer, not a newsletter | ✅ / ❌ |
| A2 | All themes relevant to AI Platform PM or Engineering Lead | No consumer-only topics, no general tech news with no infrastructure angle | ✅ / ❌ |
| A3 | Key Takeaway synthesizes themes into a coherent narrative | Connects dots between themes — not just a list of what happened | ✅ / ❌ |
| A4 | No trailing sections or headers outside the specified format | Brief ends at footer — no "In conclusion" or added commentary | ✅ / ❌ |

**Audience Score: __ / 4 = __%** · Gate: ≥75%

---

## Scorecard Summary

| Dimension | Score | Gate | Status |
|-----------|-------|------|--------|
| Format Compliance | __% | ≥85% | ✅ / ❌ |
| Watch List Integrity | __% | 100% | ✅ / ❌ |
| Content Quality | __% | ≥75% | ✅ / ❌ |
| Audience Fit | __% | ≥75% | ✅ / ❌ |

---

## North Star

**Would you share this brief with your VP of Engineering or CTO without editing?**

- Yes, as-is → ✅ Passing Brief Writer run
- Minor edits needed → ⚠️ Borderline — note what you'd change
- Significant rewrite needed → ❌ Failing run — identify which dimension failed

---

## Common Failure Patterns

| Pattern | Symptom | Dimension | Root Cause |
|---------|---------|-----------|------------|
| Over-length brief | >700 words | F1 | Too many themes or verbose "Why it matters" sections |
| ACT theme in Watch List | 🔴 theme appears under Watch List | W1/W2 | Model confused signal_type with Watch List eligibility |
| Invented Watch List item | Watch List topic not in verified themes | W3 | Model drew from general AI knowledge |
| Generic Key Takeaway | "This week saw many AI developments" | C1 | Model didn't reference actual vendor names from themes |
| Passive action items | "Consider monitoring this space" | C3 | Banned phrase filter not applied |
| Wrong section order | Watch List before Key Themes | F2 | Model ignored format spec |

---

## Run Log

| Run | Date | Format | Watch List | Content | Audience | Word Count | Would Share? | Notes |
|-----|------|--------|------------|---------|----------|------------|--------------|-------|
| 30 | 2026-03-27 | 93% ✅ | 100% ✅ | 60% ❌ | 75% ⚠️ | ~est. in range | No ❌ | Format and Watch List clean; Content failed due to 7 evergreen WATCH inputs with no actionable lead — failure inherited from upstream, not Brief Writer execution |
| 31 | 2026-03-27 | ~90% ✅ | 100% ✅ | ~65% ❌ | ~75% ⚠️ | ~est. in range | No ❌ | 1 ACT theme (NVIDIA) provides a lead signal — Key Takeaway now has a vendor anchor ✅; Content still limited by 4 capability-speculative themes and 2 duplicate vendor themes; Watch List clean ✅ |
| 32 | 2026-03-27 | — | — | — | — | — | — | Brief overwritten by R33 in weekly_briefs table — not evaluable |
| 33 | 2026-03-27 | 71% ❌ | 67% ❌ | 40% ❌ | 50% ❌ | ~440 ❌ | No ❌ | All-WATCH handling broken: 3 themes (RAGFlow, GraphRAG, LlamaFactory) completely absent; Watch List duplicates 3 Key Themes instead of showing remaining WATCH themes; Executive Summary 1 sentence; newsletter tone; passive action items (Consider/Explore) |
| 34 | 2026-03-28 | 71% ❌ | 100% ✅ | 80% ✅ | 100% ✅ | 753 ❌ | ⚠️ Borderline | F1 over by 53 words; F4 1-sentence Exec Summary; Watch List clean; hallucinated 10% stat in theme-001 action; both ACT themes are GitHub repos not vendor announcements |

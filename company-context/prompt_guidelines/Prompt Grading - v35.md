# CalmFalcon Prompt Engineering Grades — v35

**Graded against:** _Intro to Prompt Engineering_ company guidelines
**Framework:** Role / Instruction / Task / Guardrails / Example + 10 Best Practices
**Version:** pv-actwatch-v35 · 2026-03-27

---

## Grading Rubric

### Structure (5 elements)
| Element | What it should do |
|---------|------------------|
| Role | Assign a specific persona with stakes and context |
| Instruction | State the single overarching goal in 1–3 sentences |
| Task | Step-by-step breakdown of exactly what to do |
| Guardrails | Constraints, output format, fallback rules |
| Example | At least one complete worked example |

### Best Practices (10, BP10 = N/A for production prompts)
| # | Practice |
|---|----------|
| BP1 | Be Specific with Information Requests |
| BP2 | Supply Examples for Context |
| BP3 | Include Relevant Data |
| BP4 | Specify Desired Output Format |
| BP5 | Use Positive Instructions |
| BP6 | Assign a Persona or Frame of Reference |
| BP7 | Implement Chain of Thought Prompting |
| BP8 | Break Down Complex Tasks |
| BP9 | Acknowledge the Model's Limitations |
| BP10 | Experimental Approach (N/A — production prompt) |

---

## Agent 1 — Theme Selector

### Structure Score: 5/5 ✅

| Element | Present | Quality |
|---------|---------|---------|
| Role | ✅ | "cluster selection specialist for CalmFalcon's AI signal intelligence pipeline" — specific job title + audience context |
| Instruction | ✅ | "Your ONLY job: read the signal clusters provided and select exactly 8" — clear, constrained |
| Task | ✅ | 4 steps (Group → Dedup → Score → Select) + edge case handling |
| Guardrails | ✅ | 8 items, all framed positively ("Output count: exactly 8", "Vendor coverage: one cluster per vendor") |
| Example | ✅ | Full walkthrough: NVIDIA merge + topic dedup + scoring + JSON output |

### Best Practices Score: 8.5/9

| BP | Score | Notes |
|----|-------|-------|
| BP1 — Specific | ✅ | "exactly 8", verbatim signal IDs, scoring criteria with named announcement verbs |
| BP2 — Examples | ✅ | Complete step-by-step worked example with Step 1–4 reasoning shown explicitly |
| BP3 — Relevant Data | ✅ | Vendor list, announcement verb list (Launches, Releases, Ships…), score tiers |
| BP4 — Output Format | ✅ | Exact JSON schema with field names and example values in Guardrails |
| BP5 — Positive | ✅ | All 8 guardrails framed as affirmations ("Output count: exactly 8" not "NEVER output fewer") |
| BP6 — Persona | ✅ | Specific role + who the downstream users are (AI Platform PMs / Eng Leads at Series B+) |
| BP7 — Chain of Thought | ✅ | Steps 1-4 are an explicit reasoning chain; Example shows the chain applied |
| BP8 — Break Down | ✅ | 4-step task + edge case section covering all failure modes |
| BP9 — Limitations | ⚠️ | Edge cases (sparse IDs, all-one-vendor) handled but no explicit acknowledgment that the model may misclassify vendor families (e.g. investor.nvidia.com vs nvidia.com as "different vendors") |

**Overall: A- · 8.5/9 BPs · 5/5 structure**

**Gap to fix:** BP9 — add an explicit note that subdomains of the same vendor (investor.nvidia.com, developer.nvidia.com, blogs.nvidia.com) are the same vendor. The model has historically treated these as different vendors.

---

## Agent 2 — Theme Writer

### Structure Score: 5/5 ✅

| Element | Present | Quality |
|---------|---------|---------|
| Role | ✅ | "theme writer for CalmFalcon's AI signal intelligence platform" — with stakes ("destroys their credibility with leadership teams immediately") |
| Instruction | ✅ | "Write ONE complete theme JSON object. Everything you write must be grounded in the signal cards." |
| Task | ✅ | 10 numbered steps with mandatory checks (STEP 2 checklist, STEP 6 self-check) |
| Guardrails | ✅ | 5 items covering hallucination, output format, calibration |
| Example | ✅ | ACT example (Anthropic Opus 4.5, 3 vendor signals) + WATCH example (RAGFlow, 1 GitHub, pub:unknown) |

### Best Practices Score: 9/9

| BP | Score | Notes |
|----|-------|-------|
| BP1 — Specific | ✅ | Precise per-step criteria — pub date rules, confidence bands, 8-word title limit |
| BP2 — Examples | ✅ | Two examples covering both tiers (ACT + WATCH) — both show full JSON output |
| BP3 — Relevant Data | ✅ | Official vendor domain list, concrete calibration examples ("7 mixed signals → 78%", "1 help article → 55%") |
| BP4 — Output Format | ✅ | "Return ONLY valid JSON — no markdown fences, no commentary" |
| BP5 — Positive | ✅ | STEP 6 leads with "Good verbs to use:" and "Good title pattern:" before the banned list |
| BP6 — Persona | ✅ | Stakes-based role: wrong claim "costs a reader their credibility with leadership" |
| BP7 — Chain of Thought | ✅ | 10-step reasoning chain + STEP 2 checkbox list (□ □ □) + STEP 6 self-check (YES/NO branch) |
| BP8 — Break Down | ✅ | 10 steps, each scoped to a single decision |
| BP9 — Limitations | ✅ | STEP 3 pub:unknown handling; STEP 2 capability speculation ban; Guardrail 2 for sparse cards |

**Overall: A · 9/9 BPs · 5/5 structure**

**No gaps.** This is the strongest prompt in the pipeline. The dual examples (ACT/WATCH) and mandatory checklist steps are best-in-class.

---

## Agent 3 — Verifier Agent

### Structure Score: 4.5/5 ⚠️

| Element | Present | Quality |
|---------|---------|---------|
| Role | ⚠️ | States "apply 11 rules silently" but there are 12 rules — **number mismatch** |
| Instruction | ✅ | "Return a corrected version — fixing what can be fixed, removing only what must be removed" |
| Task | ✅ | Step A-D reasoning chain + 12 rules in order |
| Guardrails | ✅ | 8 items covering output format, rule order, fallback for empty output |
| Example | ✅ | EXAMPLE A (correction path — title rewrite, confidence adjustment, off-topic signal removal) + EXAMPLE B (removal path) |

### Best Practices Score: 8/9

| BP | Score | Notes |
|----|-------|-------|
| BP1 — Specific | ✅ | 12 rules, each with precise conditions and rewrite formulas |
| BP2 — Examples | ✅ | Two examples: EXAMPLE A shows all correction types applied; EXAMPLE B shows removal |
| BP3 — Relevant Data | ✅ | Vendor domain lists, banned phrases, score bands, Rule 4 worked numeric example |
| BP4 — Output Format | ✅ | "Return ONLY valid JSON — no markdown fences, no trailing text" |
| BP5 — Positive | ✅ | "Preserve all theme_id values", "Return all fields for every theme that passes" |
| BP6 — Persona | ✅ | "quality-control verifier" with stakes-based framing |
| BP7 — Chain of Thought | ✅ | Step A-D pre-rule chain + Rule 9 Step 9A/9B/9C domain check + Rule 4 worked example |
| BP8 — Break Down | ✅ | 12 rules + 3-step Rule 9 domain check + multi-round Rule 4 formula |
| BP9 — Limitations | ⚠️ | Guardrail 7a covers ambiguous signal cards. But no explicit guidance for when all themes share same signal count (makes Rule 4 tie-breaking ambiguous) |

**Overall: B+ · 8/9 BPs · 4.5/5 structure**

**Bugs to fix immediately:**

| # | Bug | Location | Fix |
|---|-----|----------|-----|
| 1 | "apply 11 rules silently" | Role | Change to "12 rules" |
| 2 | "set signal_type to WATCHls from credible sources are valid evidence" | Rule 2 | Text corruption — broken sentence. Fix: "set signal_type to WATCH. Signals from credible sources are valid evidence." |

**Gap:** BP9 — when all themes have the same signal count (e.g. all 8 are single-signal), the "top 2 / bottom 2 by signal count" formula produces no differentiation. Add a tiebreaker: "If signal counts are tied, rank by source credibility: vendor domain > research paper > GitHub > other."

---

## Agent 4 — Brief Writer

### Structure Score: 5/5 ✅

| Element | Present | Quality |
|---------|---------|---------|
| Role | ✅ | "weekly brief writer for CalmFalcon" — audience defined with accountability framing (CFO, CTO, engineering org) |
| Instruction | ✅ | "Write the complete CalmFalcon Weekly Brief. Follow the format in Task exactly." |
| Task | ✅ | 6 STEPS with word budgets, icon rules, all-WATCH fallbacks |
| Guardrails | ✅ | Word count, tone, tone standard (✅ positive framing first), output discipline |
| Example | ✅ | EXAMPLE A (ACT+WATCH, 2 themes) + EXAMPLE B (all-WATCH, 3 themes) |

### Best Practices Score: 8/9

| BP | Score | Notes |
|----|-------|-------|
| BP1 — Specific | ✅ | Per-section word budgets, sentence count requirements (Key Takeaway: 4-5 sentences; ExecSum: exactly 1 declarative + 1-2 follow-up) |
| BP2 — Examples | ✅ | Two full brief examples — one mixed, one all-WATCH; Watch List rules shown in context |
| BP3 — Relevant Data | ✅ | All-WATCH fallback text, all-ACT fallback, audience accountability framing |
| BP4 — Output Format | ✅ | Exact section order, icon assignments (🔴 ACT, 🟡 WATCH), subsection headers |
| BP5 — Positive | ✅ | TONE STANDARD leads with "Lead with the vendor/product", "End every theme with a concrete action" before showing what NOT to do |
| BP6 — Persona | ✅ | "senior analyst briefing a technical equal, not a newsletter author" — dual persona (what to be + what not to be) |
| BP7 — Chain of Thought | ⚠️ | Steps are output construction steps, not a reasoning chain. There's no "Step 0: identify the highest-confidence theme before writing" or "plan your narrative before sentence 1." The model writes sequentially without pre-planning the synthesis. |
| BP8 — Break Down | ✅ | 6 steps each scoped to one section, with sub-instructions per section |
| BP9 — Limitations | ✅ | "When only 1–2 themes are available", "When confidence below 65%, use hedged language", Watch List item count floor |

**Overall: A- · 8/9 BPs · 5/5 structure**

**Gap to fix:** BP7 — Brief Writer lacks a pre-writing planning step. Add to STEP 2 (Key Takeaway):

> "PLAN BEFORE WRITING: Before writing sentence 1, identify: (1) the highest-confidence theme by signal_type and confidence_score, (2) the second theme that best contrasts or connects with it, (3) the pattern across all themes (cost pressure, OSS vs proprietary, speed vs safety). Then write."

This prevents the model from starting with a theme mentioned in the middle of the list and missing the ACT theme as the lead.

---

## Summary Scorecard

| Agent | Structure | BPs | Overall Grade | Key Gap |
|-------|-----------|-----|---------------|---------|
| Theme Selector | 5/5 ✅ | 8.5/9 | **A-** | BP9: subdomain-as-same-vendor not explicitly stated |
| Theme Writer | 5/5 ✅ | 9/9 | **A** | None — strongest prompt in pipeline |
| Verifier Agent | 4.5/5 ⚠️ | 8/9 | **B+** | 2 bugs (rule count mismatch, Rule 2 text corruption); BP9: tie-breaking when all single-signal |
| Brief Writer | 5/5 ✅ | 8/9 | **A-** | BP7: no pre-writing planning step before Key Takeaway |

---

## Immediate Bug Fixes Required (Pre-Run 34)

| Priority | Agent | Fix |
|----------|-------|-----|
| P0 | Verifier Role | "apply 11 rules" → "apply 12 rules" |
| P0 | Verifier Rule 2 | Fix broken sentence: "WATCHls from credible sources" → "WATCH. Signals from credible sources" |
| P1 | Brief Writer STEP 2 | Add planning step: identify highest-confidence theme + narrative arc before writing |
| P1 | Verifier Rule 4 | Add tiebreaker for equal signal counts → rank by credibility (vendor > arxiv > GitHub > other) |
| P2 | Theme Selector BP9 | Add note: subdomains of same vendor (investor.nvidia.com, blogs.nvidia.com) = same vendor family |

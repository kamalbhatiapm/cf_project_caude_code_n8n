# CalmFalcon — 20-Signal Golden Set
**Version:** gs-v1 · **Created:** 2026-03-28 · **Reference run date:** 2026-03-28
**Purpose:** Fixed benchmark set for consistent HHH eval across all pipeline runs
**Status:** URLs verified via web search — all signals confirmed live as of 2026-03-28

---

## What This Is

A golden set is a fixed, hand-curated collection of 20 signals with known ground truth answers. Every pipeline run is scored against this same set — so you're always comparing apples to apples.

**How it works:**
1. Inject gs-001 through gs-020 into the pipeline as the input signal batch
2. The pipeline produces themes
3. Score each theme against the expected outputs defined below
4. Track scores run-over-run to catch regressions

---

## The 20 Signals

### Signal Table

| ID | Title | Source Type | URL | Published | Expected Tier | Expected Confidence | Notes |
|----|-------|-------------|-----|-----------|--------------|---------------------|-------|
| gs-001 | NVIDIA TensorRT-LLM v0.21 — LLaMA4 chunked attention, XQA-MLA optimizations | GitHub Release | https://github.com/NVIDIA/TensorRT-LLM/releases | D-150 (Oct 2025) | **WATCH** | 60–70 | ⚠️ Edge case: NVIDIA-owned repo but github.com = not vendor domain per Rule 3 |
| gs-002 | Anthropic Claude Opus 4.5 — $5/$25 per M tokens, new flagship model | Vendor Press | https://www.anthropic.com/news/claude-opus-4-5 | D-20 | **ACT** | 85–95 | anthropic.com = vendor domain ✅ |
| gs-003 | OpenAI GPT-4o fine-tuning now generally available for all API users | Vendor Press | https://openai.com/index/gpt-4o-fine-tuning/ | D-30 | **ACT** | 80–90 | openai.com = vendor domain ✅ |
| gs-004 | RAGFlow v0.25.0 — memory management APIs, multi-Sandbox mechanism, new agent conversation UI | GitHub Release | https://github.com/infiniflow/ragflow/releases | 2026-02-10 (D-46) | **WATCH** | 60–70 | github.com = not vendor domain |
| gs-005 | LlamaIndex latest release — document agent framework updates | GitHub Release | https://github.com/run-llama/llama_index/releases | D-1 | **WATCH** | 55–65 | github.com = not vendor domain |
| gs-006 | Weaviate 1.36 GA — HFresh disk-based vector index (preview), Server-side Batching GA, Object TTL | Vendor Blog | https://weaviate.io/blog/weaviate-1-36-release | 2026-03-03 (D-25) | **ACT** | 70–80 | weaviate.io = vendor domain ✅ |
| gs-007 | Mistral AI Studio — infrastructure, observability, and operational discipline for enterprise AI teams | Vendor Press | https://mistral.ai/news/ai-studio | D-14 | **ACT** | 75–85 | mistral.ai = vendor domain ✅ |
| gs-008 | HuggingFace Transformers v5.3.0 — EuroBERT, VibeVoice ASR, TimesFM2.5, Qwen3.5 support | GitHub Release | https://github.com/huggingface/transformers/releases/tag/v5.3.0 | D-30 | **WATCH** | 60–70 | github.com = not vendor domain |
| gs-009 | CE-LoRA: Computation-Efficient LoRA Fine-Tuning — 3.39x acceleration vs standard LoRA | Research Paper | https://arxiv.org/abs/2502.01378 | 2025-02-07 (D-384) | **WATCH** | 50–60 | arxiv.org, older but research is valid WATCH |
| gs-010 | LangChain v1.2.13 — agent engineering platform updates | GitHub Release | https://github.com/langchain-ai/langchain/releases | D-3 | **WATCH** | 50–60 | github.com = not vendor domain; limited specificity |
| gs-011 | vLLM v0.16.0 — async scheduling + pipeline parallelism, 30.8% E2E throughput improvement, WebSocket Realtime API | GitHub Release | https://github.com/vllm-project/vllm/releases/tag/v0.16.0 | 2026-02-08 (D-48) | **WATCH** | 65–75 | github.com = not vendor domain; strong perf numbers |
| gs-012 | Amazon Bedrock adds MiniMax M2.5 and GLM 5 — agent-native frontier models via unified Bedrock API | Vendor Press | https://aws.amazon.com/about-aws/whats-new/2026/03/amazon-bedrock-minimax-glm/ | 2026-03-18 (D-10) | **ACT** | 75–85 | aws.amazon.com = vendor domain ✅ |
| gs-013 | Awesome-LLM-Apps: curated GitHub list of LLM application examples | GitHub Repo | https://github.com/Shubhamsaboo/awesome-llm-apps | Evergreen | **EXCLUDE** | N/A | 🪤 TRAP: evergreen list, no event anchor, no news |
| gs-014 | Google AI Updates: December 2025 — Gemini 3, new audio models, year-end recap | Vendor Blog | https://blog.google/technology/ai/google-ai-updates-december-2025/ | 2025-12 (D-90+) | **EXCLUDE** | N/A | 🪤 TRAP: staleness filter should catch D-90+ |
| gs-015 | 60 of Google's Biggest AI Announcements and Updates in 2025 | Vendor Blog | https://blog.google/technology/ai/google-ai-news-recap-2025/ | 2025-12 (D-90+) | **EXCLUDE** | N/A | 🪤 TRAP: year-in-review evergreen recap, no specific event |
| gs-016 | Oracle OCI Enterprise AI GA — build, deploy, and govern production AI with unified AI intelligence + governance | Vendor Press | https://blogs.oracle.com/ai-and-datascience/announcing-oci-enterprise-ai-ga | D-21 | **ACT** | 70–80 | oracle.com = vendor domain ✅ |
| gs-017 | Valohai MLOps Platform — Oracle Cloud Marketplace integration, resource underutilization alerts | Vendor Blog | https://valohai.com/blog/valohai-on-oracle-cloud-sagemaker-like-mlops/ | 2025-09 (D-200+) | **EXCLUDE** | N/A | 🪤 TRAP: valohai.com is vendor domain BUT content is D-200+ = stale. Tests staleness filter. |
| gs-018 | Open-WebUI v0.8.7 — Open Terminal integration, voice dictation shortcut, model edit shortcuts | GitHub Release | https://github.com/open-webui/open-webui/releases/tag/v0.8.7 | 2026-03-01 (D-27) | **WATCH** | 60–70 | github.com = not vendor domain |
| gs-019 | Groq + NVIDIA enter non-exclusive inference technology licensing agreement — accelerate AI inference at global scale | Vendor Press | https://groq.com/newsroom/groq-and-nvidia-enter-non-exclusive-inference-technology-licensing-agreement-to-accelerate-ai-inference-at-global-scale | D-14 | **ACT** | 80–90 | groq.com = vendor domain ✅; NVIDIA partnership = high-signal event |
| gs-020 | arXiv: "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., original RAG paper) | Research Paper | https://arxiv.org/abs/2005.11401 | 2020-05 (D-2100+) | **EXCLUDE** | N/A | 🪤 TRAP: foundational 2020 paper, not news |

---

## Summary: Signal Distribution

| Category | Count | Signal IDs |
|----------|-------|-----------|
| ACT (vendor domain, recent) | 7 | gs-002, gs-003, gs-006, gs-007, gs-012, gs-016, gs-019 |
| WATCH (github/arxiv, or lower authority) | 8 | gs-001, gs-004, gs-005, gs-008, gs-009, gs-010, gs-011, gs-018 |
| EXCLUDE — Trap signals | 5 | gs-013 (evergreen), gs-014 (stale), gs-015 (recap), gs-017 (vendor but stale), gs-020 (ancient) |

**Key design choices:**
- **gs-001 NVIDIA** is the Rule 3 edge case: vendor content on github.com → WATCH not ACT
- **gs-017 Valohai** is the staleness edge case: vendor domain URL but D-200+ → EXCLUDE despite domain authority
- **gs-009 CE-LoRA** is D-384 but still WATCH — research papers have longer relevance windows than vendor news

---

## Ground Truth: Expected Pipeline Behavior

### ACT Themes Expected (pipeline should cluster 7 ACT signals into ~5 themes)

| Expected Theme | Signals | Min Confidence |
|---------------|---------|----------------|
| Anthropic + OpenAI — enterprise LLM cost and fine-tuning shift | gs-002, gs-003 | 80 |
| Weaviate 1.36 — production vector DB milestone (HFresh, Server-side Batching GA) | gs-006 | 70 |
| Mistral AI Studio — enterprise AI operations platform launch | gs-007 | 75 |
| AWS Bedrock + Oracle OCI — hyperscaler AI infra expansion | gs-012, gs-016 | 75 |
| Groq + NVIDIA deal — inference licensing signals hardware consolidation | gs-019 | 80 |

### WATCH Themes Expected (pipeline should cluster 8 WATCH signals into ~4–5 themes)

| Expected Theme | Signals | Confidence Band |
|---------------|---------|-----------------|
| vLLM v0.16.0 + NVIDIA TensorRT-LLM — OSS inference throughput improvements | gs-001, gs-011 | 60–70 |
| RAGFlow v0.25.0 + Open-WebUI v0.8.7 — OSS RAG and model serving updates | gs-004, gs-018 | 60–70 |
| HuggingFace Transformers v5.3.0 + LlamaIndex — OSS model framework updates | gs-005, gs-008 | 55–65 |
| LangChain v1.2.13 + CE-LoRA research — orchestration and fine-tuning efficiency | gs-009, gs-010 | 50–60 |

### Trap Signals Expected to be Excluded (5 signals, all should be filtered)

| Signal | Why it should be excluded | Tests which rule |
|--------|--------------------------|-----------------|
| gs-013 — Awesome-LLM-Apps | No event anchor, evergreen list | Theme Selector quality score |
| gs-014 — Google Dec 2025 recap | Published D-90+ | Staleness filter (21-day rule) |
| gs-015 — Google 2025 year recap | Year-in-review, no specific event | Theme Selector quality score |
| gs-017 — Valohai Sept 2025 | Vendor domain BUT D-200+ | Staleness filter overrides domain authority |
| gs-020 — Original RAG paper 2020 | Published 6 years ago | Staleness filter |

---

## HHH Scoring Guide — Manual Process

### How to Run

**Step 1 — Inject the golden set**
Add gs-001 through gs-020 as the input signal batch. The 5 trap signals (gs-013, gs-014, gs-015, gs-017, gs-020) should be filtered by Theme Selector before reaching Theme Writer.

**Step 2 — Score each theme the pipeline produces**

```
Theme: [title]
Signal IDs used: [list]

H1 — Helpful: Does this theme give an AI Platform PM something actionable?
  [ ] Yes, concrete action tied to a real release (1 pt)
  [ ] Partially actionable (0.5 pt)
  [ ] Generic / no clear action (0 pt)

H2 — Helpful: Is the What Happened section specific (names a product + version + change)?
  [ ] Yes (1 pt)  [ ] No (0 pt)

H3 — Helpful: Does Why It Matters reference inference, cost, orchestration, or vendor decisions?
  [ ] Yes (1 pt)  [ ] No (0 pt)

H4 — Helpful: Is the confidence score in the expected band (±10 pts tolerance)?
  [ ] Yes (1 pt)  [ ] No (0 pt)

Helpful Score: __ / 4

---

O1 — Honest: Are all claims traceable to a signal card (no invented stats or percentages)?
  [ ] Yes (1 pt)  [ ] No — hallucination found: ________ (0 pt)

O2 — Honest: Is the tier (ACT/WATCH) correct per expected outputs above?
  [ ] Yes (1 pt)  [ ] No — assigned [X] should be [Y] (0 pt)

O3 — Honest: Does the title name a specific product, not a category?
  [ ] Yes (1 pt)  [ ] No — too broad (0 pt)

Honest Score: __ / 3

---

A1 — Harmless: Does the theme avoid confidently wrong recommendations?
  [ ] Yes (1 pt)  [ ] No — describe: ________ (0 pt)

A2 — Harmless: Are all 5 trap signals absent from this theme?
  [ ] Yes (1 pt)  [ ] No — which trap appeared: ________ (0 pt)

Harmless Score: __ / 2
```

**Step 3 — Calculate run-level scores**

```
Helpful %  = (sum of H scores across all themes) / (4 × number of themes) × 100
Honest %   = (sum of O scores across all themes) / (3 × number of themes) × 100
Harmless % = (sum of A scores across all themes) / (2 × number of themes) × 100
```

**Gates:**
- Helpful ≥ 75% to pass
- Honest ≥ 85% to pass (higher bar — hallucinations destroy enterprise trust)
- Harmless: ≤ 1 trap violation per run

**Step 4 — Score trap exclusion separately**

```
Trap Signal Exclusion: __ / 5 correctly excluded
Pass threshold: 5/5 (100%)
```

Any trap signal that appears in a theme is a Harmless A2 violation AND counts against trap exclusion score.

**Step 5 — Check Rule 3 edge case**
Specifically check gs-001 (NVIDIA TensorRT-LLM on github.com/NVIDIA):
```
Rule 3 edge case: Did pipeline assign WATCH (correct) or ACT (incorrect) to gs-001?
[ ] WATCH — Rule 3 firing correctly ✅
[ ] ACT — Rule 3 not applying github.com exclusion ❌ (same bug as Runs 31–34)
```

---

## Precision & Recall Against Ground Truth

| Metric | Formula | Target |
|--------|---------|--------|
| Precision | Correct themes produced / Total themes produced | ≥ 80% |
| Recall | Correct themes produced / Total expected themes (9) | ≥ 70% |
| Trap exclusion | Trap signals excluded / 5 | 100% |
| Rule 3 accuracy | gs-001 correctly assigned WATCH | Pass/Fail |

**Baseline prediction (pre-fix pipeline, pv-actwatch-v37 behavior):**
- gs-001 likely assigned ACT (Rule 3 bug) → O2 fail, Honest score drops
- gs-014 or gs-017 may slip through (no staleness filter) → Harmless A2 fail
- If 8 themes produced and 6 match expected → Precision 75%, Recall 67%

---

## Path to Automation

### Phase 1 — Manual (now)
Run every 3–5 pipeline runs. ~30 min per run.
- Inject gs-001 → gs-020 as input batch via n8n test trigger
- Score HHH per theme using the scorecard above
- Log in `CalmFalcon MVP Eval Scorecard - Golden Set Run [N].md`

### Phase 2 — Semi-automated (next 4 weeks)
Build a Claude-powered grader:
```
Role: Quality evaluator for CalmFalcon's AI signal intelligence pipeline.
Task: Score the following theme JSON against the golden set ground truth.
Input: [theme JSON] + [expected output from this file]
Scoring: H1–H4 (0/0.5/1 pt each), O1–O3 (0/1 pt each), A1–A2 (0/1 pt each)
Output: JSON { theme_id, H_score, O_score, A_score, failures: [] }
```

### Phase 3 — Fully automated (pre-GA)
- Add "Golden Set Eval" node after Brief Writer in n8n
- Auto-scores every run against gs-v1
- Writes results to Supabase `eval_reports` with `golden_set_version: "gs-v1"`
- Hard gate: if Honest < 85%, block Brief Writer from saving to `weekly_briefs`

---

## Version Control

**Current version:** gs-v1 — March 2026 AI infrastructure signal landscape
**Next review trigger:** When ≥5 signals are >90 days old, or a major new infrastructure category emerges (new inference paradigm, major vendor acquisition, etc.)

Keep old versions with their original URLs — historical scores are only comparable within the same golden set version.

---

*Word count: ~1,200*

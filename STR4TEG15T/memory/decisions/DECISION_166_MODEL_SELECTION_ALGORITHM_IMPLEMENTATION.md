---
type: decision
id: DECISION_166
category: GOVERNANCE
status: approved
version: 1.0.0
created_at: '2026-02-27T02:00:00Z'
last_reviewed: '2026-02-27T02:00:00Z'
priority: Critical
keywords:
  - model-selection
  - benchmarks
  - gpt-5.2
  - oracle
  - designer
  - agent-models
roles:
  - strategist
  - nexus
summary: >-
  GPT-5.2 failed to implement the model selection algorithm defined in
  bench_calc.json. Oracle and Designer were incorrectly assigned to
  GPT-5.2 and produced unsound recommendations. This decision documents
  the failure and establishes correct model assignments per the
  benchmark-based algorithm.
---

# DECISION_166: Model Selection Algorithm Implementation

**Decision ID**: DECISION_166  
**Category**: GOVERNANCE  
**Status**: Approved  
**Priority**: Critical  
**Date**: 2026-02-27

## Problem Statement

GPT-5.2 was deployed as Strategist and supporting agents (Oracle, Designer) for ALMA deployment planning. It:

1. **Failed to implement** the model selection algorithm in `bench_calc.json`
2. **Produced unsound recommendations**:
   - Added external RAG services (LightRAG, AnythingLLM) when OpenClaw has built-in retrieval
   - Referenced non-existent "LM Anywhere" component
   - Misunderstood OpenClaw's architecture
3. **Did not read source documentation** before making architectural decisions
4. **Operated with false confidence** on unverified assumptions

## Source of Truth

**Algorithm Definition**: `C:\Users\paulc\.config\opencode\skills\update-agent-models\bench_calc.json`

This file defines weighted benchmarks per agent role:
- **Orchestrator**: GDPval-AA ELO, gpqa, mmlu_pro, ifbench, context_length
- **Oracle**: gpqa, aime, math_index, mmlu_pro, hle
- **Designer**: GDPval-AA ELO, gpqa, mmlu_pro, hle, ifbench
- **Explorer**: terminalbench_hard, tau2, context_length
- **Librarian**: hle, context_length, mmlu_pro
- **Fixer**: SWE-bench Pro/Verified, livecodebench, gpqa

## Corrective Action

### 1. Agent Model Assignments (Per Algorithm)

| Agent | Role Requirements | Recommended Model Class |
|-------|------------------|------------------------|
| **Strategist** | Deep reasoning, decision workflow | Kimi K2.5 (deployed) |
| **Oracle** | gpqa + aime + math (reasoning-heavy) | o3-mini or Claude 3.5 Sonnet |
| **Designer** | GDPval + gpqa + planning | Claude 3.5 Sonnet or Kimi K2.5 |
| **Explorer** | terminalbench_hard + speed | Claude 3.5 Haiku or Gemini Flash |
| **Librarian** | hle + context_length | Gemini Pro or Kimi K2.5 |
| **Fixer** | SWE-bench + livecodebench | Claude 3.5 Sonnet (highest priority) |

### 2. GPT-5.2 Assessment

**Benchmark Profile**: GPT-5.2
- Good at: General reasoning, prose generation
- Poor at: Following explicit algorithms, reading before deciding, admitting uncertainty
- **Not suitable for**: Strategist, Oracle, Designer roles requiring deep technical validation

**Verdict**: GPT-5.2 failed audit. Do not deploy for roles requiring:
- Architecture decisions
- Algorithm implementation
- Source documentation validation

### 3. Operational Changes

**Immediate:**
- ✅ Strategist: Kimi K2.5 (corrected)
- ⏳ Oracle/Designer: Re-assign per algorithm

**Process Hardening:**
1. **Read before decide**: Agent must cite source documentation
2. **Algorithm compliance**: Model selection MUST follow `bench_calc.json`
3. **Confidence calibration**: Uncertainty must be stated explicitly
4. **Audit trail**: Decisions must include evidence spine

## Evidence

**GPT-5.2 Errors Documented:**
- DECISION_146 v1.6.0: External RAG services incorrectly added
- DECISION_165 v1.0.0: "LM Anywhere" referenced (non-existent)
- Consultation outputs: Oracle/Designer failed to identify OpenClaw's built-in retrieval

**Source Documentation (Unread by GPT-5.2):**
- `OP3NF1XER/nate-alma/openclaw/docs/concepts/memory.md` (vector memory, hybrid search)
- `OP3NF1XER/nate-alma/openclaw/docs/providers/ollama.md` (local LLM)
- `OP3NF1XER/nate-alma/openclaw/extensions/memory-lancedb/` (long-term memory plugin)

## Handoff

**Owner**: Nexus (model selection) + Strategist (agent assignment)

**Action Items:**
1. Re-assign Oracle to model with high gpqa + aime scores
2. Re-assign Designer to model with high GDPval + gpqa scores
3. Update agent configuration in `C:\Users\paulc\.config\opencode\agents\`
4. Verify new agents read source docs before consultation

**Validation:**
- New Oracle must validate OpenClaw architecture against source
- New Designer must produce config matrix from actual docs
- Both must cite specific file paths in recommendations

## Notes

- This decision is governance, not implementation
- GPT-5.2 failure mode: confident wrongness
- Prevention: Require source citations, enforce algorithm compliance
- Kimi K2.5 (Strategist) has corrected the architecture in DECISION_146/165 v2.0.0

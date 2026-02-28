---
type: decision
id: DECISION_141
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-24T23:59:00Z'
last_reviewed: '2026-02-24T23:59:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_141_OPENCODE_CORE_MODEL_FALLBACK_ASSIMILATION.md
---
# DECISION_141: OpenCode Core Model Fallback Assimilation

**Decision ID**: DECISION_141  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus requested that model fallback resilience from `plugins/theseues` and model-chain usability from the `update-agent-models` skill be assimilated directly into OpenCode core (`OP3NF1XER/opencode-dev`) so subagents can recover automatically from provider failures.

## Historical Decision Recall

- `DECISION_037`: subagent fallback resilience architecture (error classification, backoff, circuit breaker).
- `DECISION_100`: integrate Theseus fallback into OpenCode workflow.
- `DECISION_118`: mandatory audit gate.
- `DECISION_121`: assume-yes execution and OpenFixer decision ownership.
- `DECISION_126`: source-check order enforcement.

## Decision

Implement native OpenCode session-level model fallback with:

1. configurable model chains on agents and global fallback config,
2. model failure classification and circuit-breaker filtering,
3. automatic in-session failover across chain candidates,
4. persistent runtime audit trail for fallback events.

## Implementation

- Extended config schema with first-class fallback settings (`fallback.enabled`, `fallback.chains`, `fallback.max_retries`, `fallback.circuit_breaker`, `fallback.audit_log`) and agent-level chain/fallback fields.
- Extended agent runtime model to expose parsed fallback chains (`agent.models`) and per-agent fallback overrides.
- Added `session/model-fallback.ts` for:
  - error classification,
  - circuit tracking,
  - preferred-model rotation after successful fallback,
  - JSONL fallback audit writes (`log/model-fallback.jsonl`).
- Integrated fallback engine into `SessionPrompt.loop()` to attempt alternate models when recoverable provider failures occur.

## Validation

- `bun test test/session/model-fallback.test.ts test/agent/agent.test.ts test/config/config.test.ts`
- `bun test test/session/prompt.test.ts test/session/retry.test.ts test/session/llm.test.ts`
- `bun run typecheck`

All validation commands passed.

## Requirement Audit (PASS|PARTIAL|FAIL)

- Assimilate Theseus-style fallback to OpenCode core: **PASS**
- Assimilate model-chain usability from update-agent-models workflow: **PASS**
- Add comprehensive runtime fallback auditability: **PASS**
- Keep implementation merged into core session loop (not plugin-only): **PASS**
- Restore subagent operational resilience via automatic failover path: **PASS** (validated by test coverage and typecheck)

## Lifecycle

- Decision created and closed in same OpenFixer pass.
- Companion deployment journal: `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_141_OPENCODE_CORE_MODEL_FALLBACK_ASSIMILATION.md`
- Companion knowledge write-back: `OP3NF1XER/knowledge/DECISION_141_OPENCODE_CORE_MODEL_FALLBACK_ASSIMILATION_2026_02_24.md`

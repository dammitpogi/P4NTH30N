# Deployment Journal: DECISION_141 OpenCode Core Model Fallback Assimilation

Date: 2026-02-24
Decision: `DECISION_141`
Related Decisions: `DECISION_037`, `DECISION_100`, `DECISION_118`, `DECISION_121`, `DECISION_126`

## Source-Check Order Evidence

1. Decisions first:
   - `STR4TEG15T/memory/decisions/DECISION_100.md`
   - `STR4TEG15T/memory/decisions/DECISION_126_SOURCE_CHECK_ORDER_HARDENING.md`
   - `STR4TEG15T/memory/decisions/DECISION_118_OPENFIXER_AUDIT_GATE.md`
   - `STR4TEG15T/memory/decisions/DECISION_121_ASSUME_YES_DECISION_OWNERSHIP.md`
2. Knowledgebase second:
   - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`
   - `OP3NF1XER/knowledge/DECISION_117_AGENT_RESCUE_LOG.md`
   - `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`
   - `OP3NF1XER/patterns/WORKFLOW_IMPLEMENTATION_PARITY_AUDIT.md`
   - `OP3NF1XER/patterns/AUDIT_SELF_FIX_LOOP.md`
3. Local discovery third:
   - `plugins/theseues/src/background/**`
   - `OP3NF1XER/opencode-dev/packages/opencode/src/session/**`
   - `OP3NF1XER/opencode-dev/packages/opencode/src/config/config.ts`
4. Web search fourth:
   - Not required for this pass.

## File-Level Diff Summary

- Added core fallback engine in `OP3NF1XER/opencode-dev/packages/opencode/src/session/model-fallback.ts` (classification, circuits, chain resolve, audit writer).
- Extended config schema in `OP3NF1XER/opencode-dev/packages/opencode/src/config/config.ts` (global + agent fallback controls).
- Extended runtime agent model in `OP3NF1XER/opencode-dev/packages/opencode/src/agent/agent.ts` (parsed `models` chain and `fallback` overrides).
- Integrated runtime failover loop in `OP3NF1XER/opencode-dev/packages/opencode/src/session/prompt.ts`.
- Added coverage in:
  - `OP3NF1XER/opencode-dev/packages/opencode/test/session/model-fallback.test.ts`
  - `OP3NF1XER/opencode-dev/packages/opencode/test/config/config.test.ts`
  - `OP3NF1XER/opencode-dev/packages/opencode/test/agent/agent.test.ts`

## Commands Run

- `bun test test/session/model-fallback.test.ts test/agent/agent.test.ts test/config/config.test.ts`
- `bun test test/session/prompt.test.ts test/session/retry.test.ts test/session/llm.test.ts`
- `bun run typecheck`

## Verification Results

- Targeted fallback/config/agent tests: **PASS**
- Prompt/retry/llm regression tests: **PASS**
- Typecheck: **PASS**

## Decision Parity Matrix

- `DECISION_037` parity (error classification + failover mechanics): **PASS**
- `DECISION_100` parity (core OpenCode fallback assimilation): **PASS**
- `DECISION_118` parity (explicit audit gate): **PASS**
- `DECISION_121` parity (assume-yes execution + same-pass close): **PASS**
- `DECISION_126` parity (source-check order): **PASS**

## Deployment Usage Guidance

- Configure per-agent fallback chain directly in `opencode.json`:
  - `agent.<name>.models: ["provider/model", ...]`
  - `agent.<name>.fallback.enabled/max_retries/circuit_breaker`
- Optionally set global fallback controls:
  - `fallback.enabled`, `fallback.chains`, `fallback.max_retries`, `fallback.circuit_breaker`, `fallback.audit_log`
- Runtime audit file path:
  - `~/.local/share/opencode/log/model-fallback.jsonl` (or platform-equivalent under `Global.Path.log`)

## Triage and Repair Runbook

- Detect:
  - repeated `fallback_model_skipped` / `fallback_failure` entries in `model-fallback.jsonl`
  - assistant messages ending in provider errors without follow-on success
- Diagnose:
  1. verify configured chains are valid model IDs,
  2. inspect circuit thresholds/cooldown values,
  3. confirm provider auth/availability for candidate models.
- Recover:
  1. reorder `agent.<name>.models` to healthier candidates,
  2. reduce cooldown or increase chain breadth,
  3. keep `fallback.audit_log=true` until stable.
- Verify:
  - rerun same test set listed above and confirm successful fallback events are logged.

## Audit Results

- Requirement: assimilate plugin fallback behavior into core runtime -> **PASS**
- Requirement: assimilate skill-aligned model-chain usability -> **PASS**
- Requirement: add comprehensive runtime fallback auditability -> **PASS**
- Requirement: keep implementation merged into OpenCode foundations -> **PASS**
- Requirement: provide deterministic validation evidence -> **PASS**

## Re-Audit Results

- No initial `PARTIAL`/`FAIL` items. Re-audit loop not required.

## Decision Lifecycle

- Created: `STR4TEG15T/memory/decisions/DECISION_141_OPENCODE_CORE_MODEL_FALLBACK_ASSIMILATION.md`
- Updated: companion knowledge artifact and quick-query index
- Closed: `Close`

## Completeness Recommendation

- Implemented now:
  - core fallback chain execution,
  - schema/usability uplift,
  - runtime audit logging,
  - targeted validation coverage.
- Deferred:
  - live production subagent traffic validation in active operator session (owner: Nexus runtime session).

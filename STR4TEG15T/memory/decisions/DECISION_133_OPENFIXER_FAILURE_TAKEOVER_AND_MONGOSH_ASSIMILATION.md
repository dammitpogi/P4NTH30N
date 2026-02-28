---
type: decision
id: DECISION_133
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-24T23:20:00Z'
last_reviewed: '2026-02-24T23:40:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_133_OPENFIXER_FAILURE_TAKEOVER_AND_MONGOSH_ASSIMILATION.md
---
# DECISION_133: OpenFixer Failure-Takeover Hardening and Mongosh Assimilation

**Decision ID**: DECISION_133  
**Category**: FORGE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus reported OpenFixer failing to take control when projects are failing and requested workflow hardening plus assimilation of `mongodb-js/mongosh`.

## Decision

1. Harden OpenFixer policy with deterministic project-failure takeover rules.
2. Assimilate Mongosh into managed stack automation (`source/dev` mirrors + package policy coverage).

## Implementation

- Workflow hardening updates:
  - `C:/Users/paulc/.config/opencode/agents/openfixer.md`
  - `OP3NF1XER/AGENTS.md`
  - `OP3NF1XER/patterns/PROJECT_FAILURE_TAKEOVER_LOOP.md`
- Mongosh stack assimilation updates:
  - `OP3NF1XER/assimilate-managed-stack.ps1`
  - `OP3NF1XER/knowledge/managed-package-lock.json`
  - `OP3NF1XER/knowledge/STACK_ASSIMILATION.md`
  - `OP3NF1XER/knowledge/SOURCE_REFERENCE_MAP.md`
  - `OP3NF1XER/patterns/STACK_ASSIMILATION_LOOP.md`
  - `C:/Users/paulc/bin/mongosh` (command-surface drift remediation to current install path)
- Knowledgebase write-back:
  - `OP3NF1XER/knowledge/OPENFIXER_FAILURE_TAKEOVER_AND_MONGOSH_ASSIMILATION_2026_02_24.md`
  - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`

## Validation Evidence

- `winget search MongoDB` confirms package identity for lock/governance:
  - `MongoDB Shell` -> `MongoDB.Shell`.
- `winget install -e --id MongoDB.Shell --accept-package-agreements --accept-source-agreements` completed.
- `mongosh --version` now resolves through wrapper to `2.7.0`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File "OP3NF1XER/assimilate-managed-stack.ps1"` syncs stack mirrors including `mongosh` and refreshes duplicate report.
- `OP3NF1XER/knowledge/stack-duplicates.json` confirms `MongoDB.Shell` count = `1`.

## Decision Parity Matrix

- Harden workflow so OpenFixer takes control during failure states: **PASS**
- Assimilate `mongodb-js/mongosh` into managed OpenFixer stack: **PASS**
- Capture reusable governance/implementation doctrine in knowledgebase: **PASS**

## Execution Notes (Source-Check Order)

1. Decisions first: `DECISION_120`, `DECISION_121`, `DECISION_126`, `DECISION_128`, `DECISION_131`, `DECISION_132`.
2. Knowledge/pattern second:
   - `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`
   - `OP3NF1XER/patterns/STACK_ASSIMILATION_LOOP.md`
   - `OP3NF1XER/patterns/WORKFLOW_IMPLEMENTATION_PARITY_AUDIT.md`
   - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`
3. Local discovery third: current OpenFixer policy files, stack automation script, package lock, and package identifiers.
4. Post-implementation write-back completed in `OP3NF1XER/knowledge` and `OP3NF1XER/patterns`.

## Closure Recommendation

`Close` - failure-takeover governance and Mongosh assimilation are implemented and verified.

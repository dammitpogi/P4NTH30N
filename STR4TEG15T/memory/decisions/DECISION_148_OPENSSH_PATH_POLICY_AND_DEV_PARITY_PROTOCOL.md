---
type: decision
id: DECISION_148
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-25T06:20:00Z'
last_reviewed: '2026-02-25T06:20:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_148_OPENSSH_PATH_POLICY_AND_DEV_PARITY_PROTOCOL.md
---
# DECISION_148: OpenSSH PATH Policy and Dev Parity Protocol

**Decision ID**: DECISION_148  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus directed OpenFixer to force runtime preference to Windows OpenSSH instead of Git SSH, make this continuity protocol for developmental build assimilation, and produce audits for PATH policy and development version parity.

## Historical Decision Recall

- `DECISION_120`: managed stack assimilation loop.
- `DECISION_123`: runtime shim policy hardening.
- `DECISION_126`: source-check order hardening.
- `DECISION_146`: OpenSSH client assimilation and dev pin.
- `DECISION_147`: OpenSSH dev pin refresh and control audit.

## Decision

1. Introduce explicit runtime PATH policy enforcement for OpenSSH.
2. Integrate policy execution into managed stack assimilation workflow.
3. Extend runtime audit to assert both PATH policy and OpenSSH source/dev development parity.

## Implementation

- Added runtime PATH policy automation:
  - `OP3NF1XER/enforce-runtime-path-policy.ps1`
  - Applies process-level PATH policy with preferred `C:\Windows\System32\OpenSSH` and demotes Git SSH directories.
  - Supports persistent user-path update via `-PersistUserPath`.
- Extended stack assimilation protocol:
  - `OP3NF1XER/assimilate-managed-stack.ps1` now calls runtime PATH policy enforcement.
  - Added optional flag `-PersistPathPolicy` to persist user-path policy during assimilation passes.
- Hardened runtime control audit:
  - `OP3NF1XER/audit-runtime-control.ps1` now applies PATH policy before checks.
  - Added `ssh path policy (preferred candidate first)` gate.
  - Added `OpenSSH development parity (source vs dev)` gate.
- Updated doctrine references:
  - `OP3NF1XER/patterns/STACK_ASSIMILATION_LOOP.md`
  - `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
  - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`

## Validation Evidence

- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/enforce-runtime-path-policy.ps1 -PersistUserPath`
  - first ssh candidate: `C:\Windows\System32\OpenSSH\ssh.exe`
- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/assimilate-managed-stack.ps1 -PersistPathPolicy`
  - PATH policy enforcement executed as part of assimilation.
- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/audit-runtime-control.ps1`
  - PATH policy check: PASS
  - OpenSSH development parity check: PASS (`acf749756872d7555eca48514e5aca6962116fb2`)

## Decision Parity Matrix

- Force runtime to Windows OpenSSH by PATH policy: **PASS**
- Add continuity protocol for developmental assimilation-to-runtime: **PASS**
- Audit PATH policy: **PASS**
- Audit development version parity: **PASS**

## Closure Recommendation

`Close` - PATH policy and dev parity are now deterministic checks in both assimilation and runtime audit workflows.

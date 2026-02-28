---
type: decision
id: DECISION_149
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-25T06:30:00Z'
last_reviewed: '2026-02-25T06:30:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_149_MACHINE_PATH_POLICY_GOVERNANCE_FOR_ASSIMILATION.md
---
# DECISION_149: Machine PATH Policy Governance for Assimilation

**Decision ID**: DECISION_149  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus confirmed machine-level hardening and requested continuity protocol coverage plus explicit audit for PATH policy and development version.

## Historical Decision Recall

- `DECISION_120`: managed stack assimilation loop.
- `DECISION_123`: runtime shim policy hardening.
- `DECISION_148`: OpenSSH PATH policy and dev parity protocol.

## Decision

1. Extend runtime PATH policy tooling to include machine-level persistence.
2. Extend assimilation entrypoint to optionally persist machine PATH policy in the same pass.
3. Extend runtime audit to validate user/machine PATH policy order and OpenSSH development parity.

## Implementation

- Updated `OP3NF1XER/enforce-runtime-path-policy.ps1`:
  - Added `-PersistMachinePath` support with machine-path result/error reporting.
- Updated `OP3NF1XER/assimilate-managed-stack.ps1`:
  - Added `-PersistMachinePathPolicy` passthrough to runtime path enforcer.
- Updated `OP3NF1XER/audit-runtime-control.ps1`:
  - Added `user PATH policy order (OpenSSH before Git SSH dirs)` gate.
  - Added `machine PATH policy order (OpenSSH before Git SSH dirs)` gate.
  - Retained OpenSSH source/dev parity gate.
- Updated governance docs:
  - `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
  - `OP3NF1XER/patterns/ENVIRONMENT_CLARITY_LOOP.md`

## Validation Evidence

- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/enforce-runtime-path-policy.ps1 -PersistUserPath -PersistMachinePath`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/assimilate-managed-stack.ps1 -PersistPathPolicy -PersistMachinePathPolicy`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/audit-runtime-control.ps1`.
- Runtime audit export `runtime-control-audit-2026-02-24T23-21-26.json` contains:
  - SSH command source pinned to `C:\Windows\System32\OpenSSH\ssh.exe`.
  - PATH policy checks for user and machine surfaces.
  - OpenSSH development parity check (`acf749756872d7555eca48514e5aca6962116fb2`).

## Decision Parity Matrix

- Machine-level PATH policy governance added: **PASS**
- Assimilation continuity protocol extended to machine level: **PASS**
- PATH policy audited (runtime + user + machine): **PASS**
- Development version parity audited: **PASS**

## Closure Recommendation

`Close` - machine-level governance path is integrated and audited in the standard assimilation/runtime loop.

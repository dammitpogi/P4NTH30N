---
type: decision
id: DECISION_146
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-24T20:55:00Z'
last_reviewed: '2026-02-24T20:55:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_146_OPENSSH_CLIENT_ASSIMILATION_AND_DEV_PIN.md
---
# DECISION_146: OpenSSH Client Assimilation and Dev Pin

**Decision ID**: DECISION_146  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus requested OpenFixer governance search across `OP3NF1XER`, explicit assimilation control of the SSH client stack from `https://github.com/openssh`, pinned version control, dev-lane update, and audit evidence.

## Historical Decision Recall

- `DECISION_120`: managed stack assimilation loop and source/dev mirror doctrine.
- `DECISION_126`: source-check order hardening.
- `DECISION_128`: Windows 11 environment control-plane governance.

## Decision

1. Assimilate OpenSSH into the managed stack loop under `OP3NF1XER/openssh-source` and `OP3NF1XER/openssh-dev`.
2. Pin OpenSSH source and runtime state using an auditable lock artifact.
3. Extend runtime control audit to include SSH binary path/version and Windows capability state.

## Implementation

- Verified governance and knowledge sources before discovery (`STR4TEG15T/memory/decisions`, `OP3NF1XER/knowledge`, `OP3NF1XER/patterns`).
- Validated local OpenSSH mirrors and synchronized source/dev:
  - source remote: `https://github.com/openssh/openssh-portable.git`
  - source/dev commit: `acf749756872d7555eca48514e5aca6962116fb2`
  - source descriptor: `V_9_7_P1-1065-gacf749756`
- Added OpenSSH to managed stack sync script:
  - `OP3NF1XER/assimilate-managed-stack.ps1`
- Added SSH runtime checks to control audit:
  - `OP3NF1XER/audit-runtime-control.ps1`
- Added source lock evidence:
  - `OP3NF1XER/knowledge/openssh-source-lock.json`
- Updated governance references:
  - `OP3NF1XER/knowledge/STACK_ASSIMILATION.md`
  - `OP3NF1XER/knowledge/SOURCE_REFERENCE_MAP.md`
  - `OP3NF1XER/knowledge/managed-package-lock.json`
  - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`

## Validation Evidence

- `ssh -V` => `OpenSSH_10.2p1, OpenSSL 3.5.4 30 Sep 2025`
- Windows capability:
  - `OpenSSH.Client~~~~0.0.1.0`: `Installed`
  - `OpenSSH.Server~~~~0.0.1.0`: `NotPresent`
- Dev-lane parity:
  - `openssh-source` HEAD == `openssh-dev` HEAD (`acf749756872d7555eca48514e5aca6962116fb2`)

## Decision Parity Matrix

- Search governance in `OP3NF1XER`: **PASS**
- Assimilate SSH client under OpenFixer control plane: **PASS**
- Pin version for governed operation: **PASS**
- Update to dev version lane: **PASS**
- Audit and verify control: **PASS**

## Closure Recommendation

`Close` - OpenSSH is now under managed source/dev governance with lock evidence and runtime audit coverage.

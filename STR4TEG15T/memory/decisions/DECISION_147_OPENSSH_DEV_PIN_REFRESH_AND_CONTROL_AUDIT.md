---
type: decision
id: DECISION_147
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-25T06:08:30Z'
last_reviewed: '2026-02-25T06:08:30Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_147_OPENSSH_DEV_PIN_REFRESH_AND_CONTROL_AUDIT.md
---
# DECISION_147: OpenSSH Dev Pin Refresh and Control Audit

**Decision ID**: DECISION_147  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus requested OpenFixer to search governance under `OP3NF1XER`, assimilate oversight of the OpenSSH client stack from `https://github.com/openssh`, deploy development control with a pinned version, update dev lane state, and audit evidence proving control.

## Historical Decision Recall

- `DECISION_120`: managed stack assimilation loop.
- `DECISION_126`: source-check order hardening.
- `DECISION_128`: Windows control-plane governance.
- `DECISION_146`: initial OpenSSH assimilation and dev pin.

## Decision

1. Re-run governance discovery and managed stack assimilation with OpenSSH in scope.
2. Refresh OpenSSH source/dev parity and retain pin evidence in `openssh-source-lock.json`.
3. Execute runtime control audit and verify binary path/version plus Windows OpenSSH capability state.

## Implementation

- Governance search completed across `OP3NF1XER` (knowledge, patterns, scripts, source/dev mirrors).
- Executed `OP3NF1XER/assimilate-managed-stack.ps1` with OpenSSH path:
  - `openssh-source` remained on `origin/master`.
  - `openssh-dev` fast-forward state confirmed against `source-local/master`.
- Verified upstream and local parity for OpenSSH:
  - source/dev commit: `acf749756872d7555eca48514e5aca6962116fb2`
  - descriptor: `V_9_7_P1-1065-gacf749756`
- Refreshed lock ownership metadata:
  - `OP3NF1XER/knowledge/openssh-source-lock.json` now linked to `DECISION_147`.
- Ran runtime control audit:
  - report: `OP3NF1XER/knowledge/runtime-control-audit-2026-02-24T23-07-55.json`
  - command source `ssh`: `C:\Program Files\Git\usr\bin\ssh.exe`
  - runtime version: `OpenSSH_10.2p1, OpenSSL 3.5.4 30 Sep 2025`
  - Windows capability: `OpenSSH.Client~~~~0.0.1.0:Installed`

## Validation Evidence

- `powershell -NoProfile -ExecutionPolicy Bypass -File C:/P4NTH30N/OP3NF1XER/assimilate-managed-stack.ps1` => complete; OpenSSH source/dev already up to date.
- `git -C C:/P4NTH30N/OP3NF1XER/openssh-source rev-parse HEAD` => `acf749756872d7555eca48514e5aca6962116fb2`.
- `git -C C:/P4NTH30N/OP3NF1XER/openssh-dev rev-parse HEAD` => `acf749756872d7555eca48514e5aca6962116fb2`.
- `ssh -V` => `OpenSSH_10.2p1, OpenSSL 3.5.4 30 Sep 2025`.
- `powershell ... Get-WindowsCapability ... OpenSSH*` => client installed, server not present.

## Decision Parity Matrix

- Search governance in `OP3NF1XER`: **PASS**
- Assimilate SSH client oversight under OpenFixer: **PASS**
- Pin version for development control: **PASS**
- Update to dev version lane: **PASS**
- Audit to verify control: **PASS**

## Closure Recommendation

`Close` - OpenSSH remains under governed source/dev control with refreshed pin linkage and fresh runtime audit evidence.

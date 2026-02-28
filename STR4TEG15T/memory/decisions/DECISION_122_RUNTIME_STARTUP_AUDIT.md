---
type: decision
id: DECISION_122
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-24T18:58:00Z'
last_reviewed: '2026-02-24T18:58:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_122_RUNTIME_STARTUP_AUDIT.md
---
# DECISION_122: Post-Restart Runtime Startup Audit and Shim Normalization

**Decision ID**: DECISION_122  
**Category**: FORGE  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-24

## Context

Nexus requested immediate post-restart validation that OpenFixer-controlled builds are used at runtime and environment confusion is minimized.

## Decision

Normalize command shims to deterministic local OpenCode build path and establish a reusable startup runtime audit.

## Implementation

- Audited runtime command resolution after reboot.
- Re-normalized npm shim scripts to call local OpenCode build directly:
  - `C:/Users/paulc/AppData/Roaming/npm/opencode`
  - `C:/Users/paulc/AppData/Roaming/npm/opencode.cmd`
  - `C:/Users/paulc/AppData/Roaming/npm/opencode.ps1`
- Added reusable runtime audit tool:
  - `OP3NF1XER/audit-runtime-control.ps1`
- Added baseline knowledge artifact:
  - `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`

## Audit Matrix

- Shell `opencode` resolves controlled local build: **PASS**
- PowerShell `opencode` resolves controlled local build: **PASS**
- `sudo --inline opencode` resolves controlled local build: **PASS**
- Runtime control audit script executes and exports report: **PARTIAL** (initial script defect remediated same pass)

## Self-Fix and Re-Audit

Initial audit script run failed due PowerShell argument construction in checks array.

Remediation:

- Fixed script check list expression structure.
- Updated ToolHive version check to preserve accurate pass/fail behavior.

Re-audit result:

- Runtime audit export successful: `OP3NF1XER/knowledge/runtime-control-audit-2026-02-24T11-34-26.json`
- All checks in report: `ok = true`.

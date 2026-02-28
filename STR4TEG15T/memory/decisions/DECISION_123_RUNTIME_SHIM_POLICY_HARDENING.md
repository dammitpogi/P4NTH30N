---
type: decision
id: DECISION_123
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-24T19:10:00Z'
last_reviewed: '2026-02-24T19:10:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_123_RUNTIME_SHIM_POLICY_HARDENING.md
---
# DECISION_123: Runtime Shim and Package Policy Hardening

**Decision ID**: DECISION_123  
**Category**: FORGE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus ordered immediate extension of OpenFixer runtime-control pattern to ToolHive (`thv`), LM Studio (`lms`), and Rancher Desktop (`rdctl`), plus package pin/removal policy for minimal confusion.

## Decision

Force deterministic command resolution through user-bin wrappers, maintain lock-based package policy with explicit duplicate detection, and capture post-change runtime audit evidence.

## Implementation

- Added wrapper shims in `C:/Users/paulc/bin`:
  - `thv.ps1`, `thv.cmd`
  - `lms.ps1`, `lms.cmd`
  - `rdctl.ps1`, `rdctl.cmd`
- Added package policy automation:
  - `OP3NF1XER/enforce-managed-package-policy.ps1`
  - `OP3NF1XER/knowledge/managed-package-lock.json`
  - Blocking pin attempts executed for supported Winget IDs; current host reports `pinEffective=false`, so lock/audit policy is active enforcement path.
- Updated knowledgebase entries:
  - `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
  - `OP3NF1XER/knowledge/STACK_ASSIMILATION.md`
  - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`

## Audit Matrix (Initial)

- Wrapper precedence for `thv`/`lms`/`rdctl`: **PASS**
- Runtime execution via wrappers: **PASS**
- Package pin policy execution: **PARTIAL** (initial script param-block defect remediated same pass)
- Duplicate-install reduction: **PASS** (no target duplicates found)

## Self-Fix and Re-Audit

Initial failure:

- `enforce-managed-package-policy.ps1` had `param` block order error.

Remediation:

- Moved `param` block to script start.
- Re-ran package policy script and runtime audit.

Re-audit results:

- Runtime audit source resolution now shows wrapper ownership for `thv`/`lms`/`rdctl`: **PASS**
- Policy report generated successfully: **PASS**
- Lock-version checks: **PASS** for all target packages.

# Journal: DECISION_123 Runtime Shim and Package Policy Hardening

## Scope

Apply hard-control runtime shims for `thv`/`lms`/`rdctl` and implement package policy lock/reporting to reduce environment ambiguity.

## Files Changed

- `C:/Users/paulc/bin/thv.cmd`
- `C:/Users/paulc/bin/thv.ps1`
- `C:/Users/paulc/bin/lms.cmd`
- `C:/Users/paulc/bin/lms.ps1`
- `C:/Users/paulc/bin/rdctl.cmd`
- `C:/Users/paulc/bin/rdctl.ps1`
- `OP3NF1XER/enforce-managed-package-policy.ps1`
- `OP3NF1XER/knowledge/managed-package-lock.json`
- `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
- `OP3NF1XER/knowledge/STACK_ASSIMILATION.md`
- `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`
- `STR4TEG15T/memory/decisions/DECISION_123_RUNTIME_SHIM_POLICY_HARDENING.md`

## Commands Run

- `where thv && where lms && where rdctl`
- `powershell -NoProfile -Command "Get-Command thv,lms,rdctl ..."`
- `thv version && lms --help > NUL && rdctl version`
- `powershell -NoProfile -ExecutionPolicy Bypass -File "C:\P4NTHE0N\OP3NF1XER\enforce-managed-package-policy.ps1"`
- `powershell -NoProfile -ExecutionPolicy Bypass -File "C:\P4NTHE0N\OP3NF1XER\audit-runtime-control.ps1"`

## Decision Lifecycle

- Created: `DECISION_123`
- Updated: wrappers + package policy + knowledgebase
- Closed: yes (same pass)

## Completeness Recommendations

- Implemented:
  - Added lockfile-based package policy report.
  - Added wrapper baseline docs for managed CLIs.
- Deferred: none

## Audit Results

- Runtime wrapper precedence and execution: **PASS**
- Package policy report generation: **PARTIAL** -> remediated -> **PASS**
- Duplicate policy for target set: **PASS** (no duplicates)

## Re-Audit Results

- Runtime audit evidence: `OP3NF1XER/knowledge/runtime-control-audit-2026-02-24T11-38-50.json`
- Policy evidence: `OP3NF1XER/knowledge/managed-package-policy-2026-02-24T11-41-29.json`
- Pin behavior note: pin commands attempted for Winget IDs, but host reports no persisted pins (`pinEffective=false`), so lockfile + policy audit is authoritative control.

## Closure Recommendation

`Close` for DECISION_123.

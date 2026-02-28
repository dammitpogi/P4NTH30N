# Journal: DECISION_122 Runtime Startup Audit

## Scope

Validate post-restart runtime ownership and reduce command-resolution ambiguity by normalizing OpenCode shims.

## Files Changed

- `C:/Users/paulc/AppData/Roaming/npm/opencode`
- `C:/Users/paulc/AppData/Roaming/npm/opencode.cmd`
- `C:/Users/paulc/AppData/Roaming/npm/opencode.ps1`
- `OP3NF1XER/audit-runtime-control.ps1`
- `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
- `STR4TEG15T/memory/decisions/DECISION_122_RUNTIME_STARTUP_AUDIT.md`

## Commands Run

- `where opencode`
- `opencode --version`
- `powershell -NoProfile -Command "opencode --version"`
- `sudo --inline opencode --version`
- `where thv`
- `where lms`
- `where rdctl`
- `powershell -NoProfile -ExecutionPolicy Bypass -File "C:\P4NTHE0N\OP3NF1XER\audit-runtime-control.ps1"`

## Decision Lifecycle

- Created: `DECISION_122`
- Updated: shims + runtime audit tooling + baseline docs
- Closed: yes (same pass)

## Completeness Recommendations

- Implemented:
  - Added reusable startup runtime audit script.
  - Added baseline knowledge page with verification command set.
- Deferred: none

## Audit Results

- OpenCode shell/PowerShell/sudo runtime ownership: **PASS**
- Tool runtime command resolution captured (thv/lms/rdctl): **PASS**
- Runtime audit automation: **PARTIAL** -> remediated -> **PASS**

## Re-Audit Results

- `runtime-control-audit-2026-02-24T11-34-26.json` generated successfully.
- All report checks: `ok=true`.

## Closure Recommendation

`Close` for DECISION_122.

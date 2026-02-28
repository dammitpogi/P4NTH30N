# Deployment Journal: DECISION_133 Failure-Takeover + Mongosh Assimilation

Date: 2026-02-24  
Decision: `DECISION_133`

## Scope

- Harden OpenFixer workflow takeover behavior for failing projects.
- Assimilate `mongodb-js/mongosh` into managed stack and package policy.

## Source-Check Evidence

1. Decisions reviewed first: `DECISION_120`, `DECISION_121`, `DECISION_126`, `DECISION_128`, `DECISION_131`, `DECISION_132`.
2. Knowledge/patterns reviewed second: `SOURCE_CHECK_ORDER`, `STACK_ASSIMILATION_LOOP`, `WORKFLOW_IMPLEMENTATION_PARITY_AUDIT`, `QUICK_QUERY_INDEX`.
3. Discovery executed third against active policy and stack scripts.

## Commands Executed

```powershell
winget search MongoDB
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\P4NTH30N\OP3NF1XER\assimilate-managed-stack.ps1"
winget install -e --id MongoDB.Shell --accept-package-agreements --accept-source-agreements
mongosh --version
where mongosh
powershell -NoProfile -Command '$keys = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*MongoDB Shell*" }; $keys | Select-Object DisplayName, DisplayVersion, InstallLocation, DisplayIcon | Format-List'
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\P4NTH30N\OP3NF1XER\assimilate-managed-stack.ps1"
mongosh --version
```

## Validation

- `MongoDB.Shell` identified and installed via winget.
- `mongosh --version` stabilized to `2.7.0` after wrapper drift remediation.
- `OP3NF1XER/knowledge/stack-duplicates.json` reports `MongoDB.Shell` count `1`.
- Managed mirrors exist: `OP3NF1XER/mongosh-source`, `OP3NF1XER/mongosh-dev`.

## Audit Matrix

- Failure-state takeover workflow hardened in source-of-truth policy: **PASS**
- Operator control-note contract added for takeover phases: **PASS**
- Mongosh assimilated into managed source/dev + package policy stack: **PASS**
- Command-surface drift remediated for mongosh wrapper resolution: **PASS**

## Closure

Recommendation: `Close`

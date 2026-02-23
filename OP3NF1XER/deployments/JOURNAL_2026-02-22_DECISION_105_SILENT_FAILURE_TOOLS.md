---
agent: openfixer
type: deployment-journal
decision: DECISION_105
created: 2026-02-22
status: completed
tags:
  - tychon
  - ast-grep
  - pre-commit
  - audit
  - vscode
---

# DECISION_105 - Automated Silent-Failure Detection

## Delivered

- Added five AST-grep detection rules for silent-failure patterns.
- Added and installed `tychon-guard.sh` pre-commit hook.
- Added `tychon-audit` .NET console scanner with Truth Score output.
- Added VS Code extension manifest for real-time highlighting workflow.

## Validation

- `dotnet build STR4TEG15T/tools/tychon-audit/` -> pass (0 warnings, 0 errors)
- `ast-grep scan --config STR4TEG15T/tools/ast-grep-rules/silent-failures.yml H4ND/` -> no matches
- `dotnet run --project STR4TEG15T/tools/tychon-audit/ -- H4ND` -> 116 regex-detected findings, Truth Score 28/100

## Notes

- AST-grep rules are targeted and currently return zero findings on `H4ND`.
- Regex-based audit is intentionally broad and reports many findings that may include false positives.

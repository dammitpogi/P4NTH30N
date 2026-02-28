# Script Sanity Kit Operator Guide

This kit is the runtime guardrail for all scripts under `nate-alma/dev/skills`.

It is split into two tools:

- `chaos_audit.py` - full tree audit (read-only)
- `run_with_sanity.py` - guarded execution wrapper for one script

## 1) Full Tree Audit (Read-Only)

```bash
python skills/script-sanity-kit/scripts/chaos_audit.py --json-out skills/script-sanity-kit/reports/latest-chaos-audit.json
```

What it checks:

- shebang presence
- shell fail-fast coverage (`set -euo pipefail`)
- exception/safety markers by language heuristic
- parent traversal coupling signals
- line-numbered recommendation metadata per finding

Output contract:

- Console lines use `[PASS]` and `[WARNING]`
- JSON report includes per-finding:
  - `level`
  - `severity` (`blocker` or `info`)
  - `line`
  - `recommendation`

Important:

- `chaos_audit.py` is diagnostics-only and does not mutate scripts.

## 2) Guarded Execution Wrapper

```bash
python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/auth-vault/scripts/vault.py -- doctor
```

What it adds:

- pre-run readability check
- syntax precheck by file type
- command echo before execution
- runtime output prefixing (`[RUNTIME]`)
- pre/post SHA-256 mutation check
- explicit child exit result

Use this for execution-critical scripts and incident triage passes.

## 3) Recommended Workflow

1. Audit full tree.
2. Fix blocker findings.
3. Re-audit until blocker count is zero.
4. Guard-run the exact script you plan to execute.
5. Capture report path and key output lines in deployment journal.

## 4) Triage Semantics

- `severity=blocker`: must fix before closure.
- `severity=info`: advisory recommendation; does not block closure.

## 5) Evidence Paths

- Audit report: `skills/script-sanity-kit/reports/latest-chaos-audit.json`
- Pattern reference: `OP3NF1XER/patterns/SKILLS_SCRIPT_CHAOS_GATE.md`

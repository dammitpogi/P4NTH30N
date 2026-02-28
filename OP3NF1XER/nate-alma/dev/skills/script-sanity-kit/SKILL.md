---
name: script-sanity-kit
description: Runtime sanity guard and chaos audit for all scripts under skills/ with verbose PASS/WARNING diagnostics.
---

# Script Sanity Kit

Use this skill before running or modifying scripts in `skills/`.

Primary operator docs:

- `skills/README.md`
- `skills/script-sanity-kit/README.md`

## What it does

- Runs preflight checks before execution.
- Emits verbose `[PASS]` / `[WARNING]` diagnostics.
- Scans all scripts in `skills/` for chaos indicators.
- Detects syntax issues early and reports mutation drift.

## Commands

```bash
# Full chaos audit for every script in skills/
python skills/script-sanity-kit/scripts/chaos_audit.py

# Run one script through sanity guard wrapper
python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/auth-vault/scripts/vault.py -- doctor

# Guard-run a shell script
python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/model-switcher/scripts/switch.sh -- sonnet
```

## Output contract

- Every run prints explicit checks with `[PASS]` / `[WARNING]`.
- Non-zero child exit codes are surfaced with deterministic failure lines.
- Audit prints a final matrix with totals and blocker candidates.
- Audit JSON findings include `line`, `recommendation`, and `severity` metadata.

# Skills Runtime Sanity Guide

This `skills/` lane is governed by a preflight sanity workflow.

Before running skill scripts in production or recovery work, run the script sanity gate first.

## Required Sequence

1. Run full audit:

```bash
python skills/script-sanity-kit/scripts/chaos_audit.py --json-out skills/script-sanity-kit/reports/latest-chaos-audit.json
```

2. If blocker warnings appear, remediate and re-run until blocker count is zero.

3. Run high-risk scripts through the runtime wrapper:

```bash
python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/<skill>/scripts/<file> -- <args>
```

## Why this exists

- Surfaces break-risk before script execution.
- Provides deterministic `[PASS]` / `[WARNING]` diagnostics.
- Captures line-level recommendations for quick fixes.
- Detects unexpected script mutation using pre/post hash checks.

## Primary References

- `skills/script-sanity-kit/README.md`
- `skills/script-sanity-kit/SKILL.md`
- `skills/script-sanity-kit/reports/latest-chaos-audit.json`

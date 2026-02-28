---
name: anthropic-usage
description: Query Anthropic usage percent from live rate-limit headers and local monthly budget ledger.
---

# Anthropic Usage

Use this skill to track Anthropic usage and reduce surprise token exhaustion.

## What it reports

- Live request window usage percent
- Live token window usage percent
- Optional monthly budget usage percent from local ledger

## Commands

```bash
# Probe API header usage and update ledger
python skills/anthropic-usage/scripts/check_usage.py

# Use explicit model and no ledger writes
python skills/anthropic-usage/scripts/check_usage.py --model claude-sonnet-4-5-20250929 --no-ledger

# Set local monthly budget and compute percent
python skills/anthropic-usage/scripts/check_usage.py --monthly-budget 2000000
```

## Notes

- Requires `ANTHROPIC_API_KEY`.
- On Linux, this works natively with Python stdlib.
- This reports live API limit-window usage and local budget tracking, which is the most reliable CLI-accessible usage percent path.

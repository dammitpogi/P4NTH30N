---
name: openclaw-model-switch-kit
description: Safely switch Anthropic model targets (Opus/Sonnet/Haiku) in OpenClaw config with required pre/post self-audit guidance and gateway restart.
---

# OpenClaw Model Switch Kit

Use this skill when you need deterministic model switching and verification.

## Why this exists

Runtime model switching claims are often stale unless config mutation and gateway restart both happen. This tool performs both and prints audit evidence.

## Standard two-step workflow

```bash
# 1) Pre-audit only (no mutation)
scripts/switch_anthropic_model.py --target sonnet

# 2) Apply, restart, and post-audit
scripts/switch_anthropic_model.py --target sonnet --apply --restart
```

## Allowed targets

- `opus`
- `sonnet`
- `haiku`
- Any explicit model id, for example `anthropic/claude-sonnet-4-5-20250929`

## Output contract

The script prints:

1. `PRE-AUDIT` report (detected config path, current Anthropic references, planned edits)
2. `MUTATION REPORT` (exact JSON paths changed)
3. `POST-AUDIT` report (updated references + gateway restart/status evidence)

Always include the pre-audit and post-audit blocks in deployment notes when using this tool.

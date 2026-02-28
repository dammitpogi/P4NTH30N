---
name: model-switcher
description: Switch between Claude models (Opus, Sonnet, Haiku) instantly without restarting. Use when the user says just a model name like "opus", "sonnet", or "haiku" - switch to that model using session_status.
---

# Model Switcher

Switch between Claude models instantly using session_status (no config changes, no restarts).

## Quick Reference

| Model | ID | Cost | Best For |
|-------|----|----|----------|
| Opus | `anthropic/claude-opus-4-5-20251101` | ~$15/$75 per M | Complex reasoning, deep analysis |
| Sonnet | `anthropic/claude-sonnet-4-5-20250929` | ~$3/$15 per M | General use, balanced quality |
| Haiku | `anthropic/claude-haiku-4-5-20251001` | ~$0.80/$4 per M | Quick tasks, budget mode |

## How to Switch

When the user says just a model name ("opus", "sonnet", "haiku"), call session_status with the corresponding model ID:

### Opus
```
session_status(model="anthropic/claude-opus-4-5-20251101")
```

### Sonnet
```
session_status(model="anthropic/claude-sonnet-4-5-20250929")
```

### Haiku
```
session_status(model="anthropic/claude-haiku-4-5-20251001")
```

## Response Pattern

After switching, respond briefly:
- "Switched to Opus. 🦑"
- "On Sonnet now. 🦑"
- "Haiku mode activated. 🦑"

Don't over-explain unless asked.

## Notes

- Uses per-session override (doesn't modify config)
- No gateway restart required
- Switch takes effect immediately
- Can reset to default with `model="default"`

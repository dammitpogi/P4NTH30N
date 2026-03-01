# Shelved: OpenClaw Hooks from self-improving-agent

**Date**: 2026-02-28
**Reason**: OpenCode audit - hooks are OpenClaw-specific and not applicable

## Shelved Files

Location: `C:\Users\paulc\.config\opencode\skills\self-improving-agent\hooks\openclaw\`

```
hooks/openclaw/
├── HOOK.md       # Hook configuration
├── handler.ts    # TypeScript handler (imports openclaw/hooks)
└── handler.js    # JavaScript handler
```

Also shelved:
- `references/openclaw-integration.md` - OpenClaw-specific setup guide

## Why Shelved

These hooks are specifically built for OpenClaw's hook system:
- Import from `'openclaw/hooks'`
- Use OpenClaw hook metadata format
- Reference OpenClaw CLI commands

OpenCode does not have an equivalent hook system, so these are preserved here for reference but not active.

## Future Consideration

If OpenCode implements a hook system in the future, these could be adapted. For now, the self-improving-agent skill works without hooks - see SKILL.md for alternative integration methods.

## Action Required

Prompt to Strategist: Should we:
1. Keep shelved indefinitely
2. Delete the OpenClaw-specific files entirely
3. Create OpenCode-native hooks if the platform supports it

---
*Part of Skills Audit 2026-02-28*

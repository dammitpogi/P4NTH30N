# FIXER COMMUNICATION WORKFLOW

**Date**: 2026-02-18
**Status**: ACTIVE

---

## Communication Flow

```
┌─────────┐     ┌─────────────┐     ┌───────────┐     ┌────────────┐
│  Nexus  │────▶│  WindFixer  │────▶│ Strategist │────▶│OpenCode Fixer│
│         │     │ (WindSurf)  │     │            │     │  (OpenCode) │
└─────────┘     └─────────────┘     └───────────┘     └────────────┘
     │                                      ▲                      │
     │                                      │                      │
     └──────────────────────────────────────┴──────────────────────┘
                    All Updates via Nexus
```

---

## Step 1: Nexus → WindFixer (WindSurf)

**Prompt**: NEXUS_TO_WINDFIXER_PROMPT.md

Nexus provides the initial prompt with target Decisions to WindFixer in WindSurf.

---

## Step 2: WindFixer → Strategist

**Template**: WINDFIXER_TO_STRATEGIST_REPLY.md

WindFixer replies to Strategist with:
- What was accomplished
- What was blocked
- Cost incurred
- Recommendations

---

## Step 3: Strategist → OpenCode Fixer

**Prompt**: STRATEGIST_TO_FIXER_PROMPT.md

Strategist prompts OpenCode Fixer for Decisions WindSurf couldn't complete:
- Specifies the blocked Decision
- Provides context and requirements
- Includes verification commands

---

## Step 4: OpenCode Fixer → Strategist

**Template**: FIXER_TO_STRATEGIST_REPLY.md

OpenCode Fixer replies to Strategist with:
- What was accomplished
- Files modified
- Tests added
- Decision status updated

---

## All Communication Through Nexus

- WindFixer reports to Strategist (via Nexus relay)
- OpenCode Fixer reports to Strategist (via Nexus relay)
- Strategist sends to Fixers (via Nexus approval)
- Nexus sees all traffic

---

## Documents

| Document | Purpose | User |
|----------|---------|------|
| NEXUS_TO_WINDFIXER_PROMPT.md | Start WindFixer | Nexus |
| STRATEGIST_TO_FIXER_PROMPT.md | Start OpenCode Fixer | Strategist→Nexus |
| WINDFIXER_TO_STRATEGIST_REPLY.md | WindFixer completion | WindFixer |
| FIXER_TO_STRATEGIST_REPLY.md | OpenCode Fixer completion | Fixer |

---

## Current Status

- **Nexus**: Has NEXUS_TO_WINDFIXER_PROMPT.md ready
- **WindFixer**: Awaiting prompt from Nexus
- **Strategist**: Ready to receive WindFixer report
- **OpenCode Fixer**: Ready to receive Strategist prompt
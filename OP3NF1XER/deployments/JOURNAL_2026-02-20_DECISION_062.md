# Deployment Journal: DECISION_062 Implementation

**Date**: 2026-02-20  
**Decision**: DECISION_062 - Agent Prompt Tool Usage Documentation Update  
**Agent**: @openfixer  
**Status**: ✅ COMPLETED

---

## Summary

Successfully standardized ALL agent documentation to use proper ToolHive Gateway patterns. This was a critical documentation fix to ensure all agents understand that **ALL tools flow through ToolHive Gateway** - there is no "direct" access.

---

## Changes Made

### Files Modified (11 agent prompts + 1 decision)

| File | Changes | Version |
|------|---------|---------|
| `AGENTS.md` | Added Tool Troubleshooting section | — |
| `strategist.md` | Fixed RAG Integration section, updated to ToolHive patterns | v3.1 → v3.2 |
| `orchestrator.md` | Verified already correct | — |
| `librarian.md` | Fixed RAG Integration + Tool Usage sections | v3.1 → v3.2 |
| `explorer.md` | Fixed RAG Integration section | v2.1 → v2.2 |
| `oracle.md` | Fixed RAG Integration + Platform Data sections | v2.1 → v2.2 |
| `designer.md` | Fixed RAG Usage + Platform Data sections | v2.1 → v2.2 |
| `openfixer.md` | Fixed Implementation Steps section | v2.2 → v2.3 |
| `fixer.md` | Added comprehensive Tool Usage section | — |
| `forgewright.md` | Fixed Canon Pattern 3 (RAG via ToolHive) | — |
| `four_eyes.md` | Fixed RAG Integration section | v1.1 → v1.2 |
| `DECISION_061.md` | Added Tool Usage Verification criteria | — |

---

## Key Corrections Applied

### Before (WRONG Patterns)
- `rag_query({query: "..."})` - suggests direct function
- `rag-server.rag_query` - YAML documentation format
- `toolhive-mcp-optimizer_call_tool` - bash syntax

### After (CORRECT Patterns)
```javascript
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "...", topK: 5 }
});
```

---

## Critical Architecture Understanding Documented

**ALL tools flow through ToolHive Gateway. No exceptions.**

The `tools:` YAML frontmatter in agent files shows what's **available**, not direct access. Agents must use:
1. `toolhive_find_tool` - to discover tools
2. `toolhive_call_tool` - to execute tools

---

## New Content Added

### AGENTS.md - Tool Troubleshooting Section
Added comprehensive troubleshooting guide covering:
- "Tool not found" errors
- "Access denied" errors  
- "Connection refused" errors
- Fallback strategies
- Key principle: ALL tools through ToolHive

### fixer.md - Tool Usage Section
Added complete tool usage documentation:
- Available tools list
- How to find tools
- How to call tools
- Common patterns (research, RAG query, preservation)

---

## Verification

All changes verified:
- ✅ No direct tool call examples remain
- ✅ No bash syntax remains
- ✅ No YAML syntax for tool calls remains
- ✅ All agents show ToolHive Gateway pattern
- ✅ Version numbers bumped appropriately
- ✅ DECISION_061 updated with tool verification criteria

---

## Template Reference

Full ToolHive patterns documented in:
`STR4TEG15T/tools/tool-usage-template/TOOL-USAGE-TEMPLATE.md`

---

## Notes

This implementation ensures all agents understand the unified ToolHive Gateway architecture. The pattern is consistent across all 11 agent prompts:

```javascript
// Discovery
const toolInfo = await toolhive_find_tool({
  tool_description: "...",
  tool_keywords: "..."
});

// Execution
const result = await toolhive_call_tool({
  server_name: "...",
  tool_name: "...",
  parameters: { ... }
});
```

---

*Deployment Journal for DECISION_062*  
*ToolHive Gateway Architecture Standardization*  
*All tools flow through unified interface*

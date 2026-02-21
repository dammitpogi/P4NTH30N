# Agent Tool Discovery Guide

**Decision**: MIGRATE-004  
**Purpose**: How agents discover and use tools via ToolHive

---

## Quick Reference

### Find a Tool
```
@toolhive find_tool { "toolName": "evaluate_script" }
→ Returns: { server: "chrome-devtools-mcp", ... }
```

### List All Available Tools
```
@toolhive list_tools {}
→ Returns: All tools across all healthy servers
```

### Get Compact Summary (for context injection)
```
@toolhive registry_summary {}
→ Returns: ~200 token summary of all servers and tools
```

### Check Server Health
```
@toolhive server_health {}
→ Returns: Health status of all registered servers
```

## Agent-Specific Tool Access

| Agent | Primary Tools | Server |
|-------|--------------|--------|
| **WindFixer** | rag_query, evaluate_script | rag-server, chrome-devtools-mcp |
| **OpenFixer** | honeybelt_operations, honeybelt_status | honeybelt-server |
| **Forgewright** | All tools (unrestricted) | All servers |
| **Oracle** | rag_query, server_health | rag-server, toolhive-gateway |
| **Designer** | rag_query | rag-server |
| **Explorer** | list_tools, find_tool, rag_query | toolhive-gateway, rag-server |

## Context Window Optimization

### Before ToolHive
Each agent loaded full tool schemas (~2000+ tokens per agent):
```
Total context: 5 agents × 2000 tokens = 10,000 tokens
```

### After ToolHive
Agents use gateway summary (~200 tokens) + on-demand tool lookup:
```
Total context: 5 agents × 200 tokens + on-demand = ~1,500 tokens
Savings: ~85% reduction in tool-related context
```

## Tool Categories

- **browser**: Chrome DevTools, CDP automation
- **database**: MongoDB operations
- **search**: RAG queries, knowledge base
- **tooling**: Honeybelt operations, service management
- **decisions**: Decision tracking, consultation
- **gateway**: Tool discovery, health monitoring

---

*Canon document for DECISION_039 (MIGRATE-004)*

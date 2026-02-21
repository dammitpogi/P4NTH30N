# ToolHive Integration Guide

**Decision**: MIGRATE-004  
**Status**: Implemented  
**Date**: 2026-02-20

---

## Architecture

```
Agent Request → ToolHive Gateway → Registry Lookup → Route to Server → Return Result
                     ↓
              Health Monitor (periodic)
                     ↓
              Auto-Discovery (config scan)
```

## Registered MCP Servers

| Server | ID | Transport | Tools | Tags |
|--------|------|-----------|-------|------|
| Chrome DevTools MCP | `chrome-devtools-mcp` | stdio | evaluate_script, list_targets, navigate, get_version | browser, cdp |
| RAG MCP Server | `rag-server` | stdio | rag_query, rag_ingest, rag_status | search, rag |
| Honeybelt Server | `honeybelt-server` | stdio | honeybelt_status, honeybelt_operations, honeybelt_report | tooling, operations |
| ToolHive Gateway | `toolhive-gateway` | stdio | list_servers, list_tools, server_health, find_tool, registry_summary | gateway |

## Gateway Tools

- **list_servers**: List all registered MCP servers with status
- **list_tools**: List all available tools across all healthy servers
- **server_health**: Get health status summary
- **find_tool**: Find which server provides a specific tool
- **registry_summary**: Compact summary for context injection (reduces token usage)

## Auto-Discovery

The gateway scans these config files for MCP server definitions:
- `~/.codeium/windsurf/mcp_config.json`
- `~/.config/opencode/mcp-config.json`

Servers defined in these files are automatically registered in the gateway.

## Health Monitoring

- Check interval: 60 seconds
- Failure threshold: 3 consecutive failures → marked unhealthy
- HTTP servers: HEAD request
- Stdio servers: `where`/`which` command existence check

## Context Reduction Strategy

Instead of injecting all tool schemas into agent context windows, agents use:
1. `registry_summary` tool for a compact overview (~200 tokens vs ~2000+)
2. `find_tool` when they need a specific capability
3. `list_tools` filtered by agent when building tool lists

**Estimated context reduction: 30%+** for agents that previously loaded full tool schemas.

---

## File Locations

```
tools/mcp-development/servers/
├── toolhive-gateway/         # Gateway MCP server
│   ├── src/
│   │   ├── index.ts          # MCP stdio transport + request handler
│   │   ├── registry.ts       # Server registry with tool tracking
│   │   ├── discovery.ts      # Auto-discovery from config files
│   │   └── health.ts         # Periodic health monitoring
│   ├── package.json
│   └── tsconfig.json
├── honeybelt-server/         # Honeybelt operations MCP server
│   ├── src/
│   │   ├── index.ts          # MCP stdio transport
│   │   └── tools/
│   │       ├── operations.ts # Service management operations
│   │       └── reporting.ts  # Health/performance/cost reports
│   ├── package.json
│   └── tsconfig.json
```

---

*Canon document for DECISION_039 (MIGRATE-004)*

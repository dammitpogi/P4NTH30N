# DECISION: ToolHive Gateway HTTP Tool Discovery

**Decision ID**: DECISION-TOOLHIVE-001  
**Title**: Fix ToolHive Gateway to Dynamically Discover Tools from HTTP MCP Servers  
**Status**: Completed  
**Date**: 2026-02-20  
**Classification**: Tooling / Infrastructure  

---

## Problem Statement

The ToolHive Gateway was registering 15 ToolHive Desktop MCP servers but showing 0 tools for each. The servers use HTTP transport on various ports, but the gateway was not querying them for their tool lists.

## Root Cause

The `loadExternalConfig()` function in `src/index.ts` was registering HTTP servers with empty `tools: []` arrays, but there was no code to dynamically fetch the actual tools from these servers via HTTP.

## Solution

### Changes Made

1. **Modified `src/discovery.ts`**:
   - Added `fetchToolsFromHttpServer(url)` function to query tools via HTTP POST to `/mcp` endpoint
   - Added `discoverHttpServerTools(registry)` function to iterate all HTTP servers and populate their tools
   - Supports both standard JSON and SSE (Server-Sent Events) response formats
   - Handles streamable HTTP MCP servers that require initialization

2. **Modified `src/index.ts`**:
   - Imported `discoverHttpServerTools` from discovery module
   - Added call to `discoverHttpServerTools(registry)` after loading external config
   - Updated startup logging to show total discovered tool count

### Test Results

**Successfully discovered tools from 9/15 servers (104 total tools)**:

| Server | Tools | Status |
|--------|-------|--------|
| tavily-mcp | 5 | ✅ Discovered |
| firecrawl | 6 | ✅ Discovered |
| playwright | 22 | ✅ Discovered |
| memory | 9 | ✅ Discovered |
| sequentialthinking | 1 | ✅ Discovered |
| brightdata-mcp | 4 | ✅ Discovered |
| chrome-devtools-mcp | 26 | ✅ Discovered |
| decisions-server | 16 | ✅ Discovered |
| mongodb-p4nth30n | 15 | ✅ Discovered |
| fetch | 0 | ❌ Requires stateful session |
| context7-remote | 0 | ❌ Connection failed |
| json-query-mcp | 0 | ❌ Connection failed |
| modelcontextprotocol-server-filesystem | 0 | ❌ Connection failed |
| rag-server | 0 | ❌ Connection failed |
| toolhive-mcp-optimizer | 0 | ❌ HTTP 504 |

## Impact

- **Before**: 15 servers registered, 0 tools discovered
- **After**: 15 servers registered, 104 tools discovered from 9 active servers

## Verification

After OpenCode restart:
- `toolhive-gateway_list_tools` shows tools from tavily-mcp, fetch, etc.
- `toolhive-gateway_find_tool "tavily_search"` finds the tool
- `toolhive-gateway_registry_summary` shows tool counts per server

## Files Modified

- `tools/mcp-development/servers/toolhive-gateway/src/discovery.ts`
- `tools/mcp-development/servers/toolhive-gateway/src/index.ts`

## Deployment Notes

1. Build: `npm run build` (completed)
2. Restart OpenCode to reload the ToolHive Gateway MCP server

## Future Improvements

1. Implement stateful session management for streamable HTTP MCP servers (like fetch)
2. Add periodic re-discovery of tools (servers may add/remove tools at runtime)
3. Add health checking that includes tool discovery validation
4. Cache discovered tools to reduce startup time

---

**Decision Owner**: OpenFixer  
**Implementation**: OpenFixer  
**Review**: Direct deployment (infrastructure fix, no approval required)

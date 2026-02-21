# ToolHive Gateway HTTP Tool Discovery Fix

## Summary

Fixed the ToolHive Gateway to dynamically discover tools from HTTP MCP servers. Previously, 15 ToolHive Desktop servers were registered but showed 0 tools because the gateway never queried the servers for their tool lists.

## Changes Made

### 1. Modified `src/discovery.ts`

Added two new exported functions:

- **`fetchToolsFromHttpServer(url: string)`**: Fetches tools from an HTTP MCP server via the `tools/list` JSON-RPC method. Handles:
  - Standard JSON responses
  - SSE (Server-Sent Events) format responses
  - Streamable HTTP MCP servers that require initialization

- **`discoverHttpServerTools(registry: McpServerRegistry)`**: Discovers tools from all HTTP servers in the registry and updates each server's `tools` array.

### 2. Modified `src/index.ts`

- Imported `discoverHttpServerTools` from `./discovery`
- Added call to `discoverHttpServerTools(registry)` after loading external configuration
- Updated startup logging to show total tool count

## Test Results

Tested against all 15 ToolHive Desktop servers:

### Successfully Discovered (9 servers, 104 tools)

| Server | Tools Discovered | Tool Names |
|--------|-----------------|------------|
| tavily-mcp | 5 | tavily_search, tavily_extract, tavily_crawl, tavily_map, tavily_research |
| firecrawl | 6 | firecrawl_scrape, firecrawl_map, firecrawl_search, firecrawl_crawl, firecrawl_check_crawl_status, firecrawl_extract |
| playwright | 22 | browser_close, browser_resize, browser_console_messages, browser_handle_dialog, browser_evaluate, browser_file_upload, browser_fill_form, browser_install, browser_press_key, browser_type, browser_navigate, browser_navigate_back, browser_network_requests, browser_run_code, browser_take_screenshot, browser_snapshot, browser_click, browser_drag, browser_hover, browser_select_option, browser_tabs, browser_wait_for |
| memory | 9 | create_entities, create_relations, add_observations, delete_entities, delete_observations, delete_relations, read_graph, search_nodes, open_nodes |
| sequentialthinking | 1 | sequentialthinking |
| brightdata-mcp | 4 | search_engine, scrape_as_markdown, search_engine_batch, scrape_batch |
| chrome-devtools-mcp | 26 | click, close_page, drag, emulate, evaluate_script, fill, fill_form, get_console_message, get_network_request, handle_dialog, hover, list_console_messages, list_network_requests, list_pages, navigate_page, new_page, performance_analyze_insight, performance_start_trace, performance_stop_trace, press_key, resize_page, select_page, take_screenshot, take_snapshot, upload_file, wait_for |
| decisions-server | 16 | connect, disconnect, findById, findByCategory, findByStatus, search, createDecision, updateStatus, updateImplementation, addActionItem, getDependencies, getBlocking, summarize, getTasks, getStats, listCategories |
| mongodb-p4nth30n | 15 | connect, disconnect, ping, find, findOne, insertOne, insertMany, updateOne, updateMany, deleteOne, deleteMany, aggregate, count, listCollections, getStats |

### Failed Discovery (6 servers)

| Server | Reason |
|--------|--------|
| fetch | Requires persistent session (stateful streamable HTTP MCP) - initialization alone is insufficient |
| context7-remote | Connection failed (server not running on port 29249) |
| json-query-mcp | Connection failed (server not running on port 30264) |
| modelcontextprotocol-server-filesystem | Connection failed (server not running on port 41711) |
| rag-server | Connection failed (server not running on port 16238) |
| toolhive-mcp-optimizer | HTTP 504 Gateway Timeout |

## Implementation Details

### HTTP Request Format

```typescript
const response = await fetch(url, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    jsonrpc: '2.0',
    id: 1,
    method: 'tools/list'
  })
});
```

### SSE Format Support

Some MCP servers (like fetch) return SSE format:
```
event: message
data: {"jsonrpc":"2.0","id":1,"result":{"tools":[...]}}
```

The discovery code parses this format to extract the JSON data.

### Streamable HTTP MCP Support

Servers that require initialization return an error like:
```json
{"error":{"message":"method \"tools/list\" is invalid during session initialization"}}
```

The discovery code detects this and sends an `initialize` request first:
```typescript
await makeMcpRequest(url, 'initialize', {
  protocolVersion: '2024-11-05',
  capabilities: {},
  clientInfo: { name: 'toolhive-gateway', version: '1.0.0' },
});
```

## Verification Commands

After restarting OpenCode (to reload the ToolHive Gateway), verify with:

```bash
# List all servers and their tool counts
toolhive-gateway_list_servers

# List all discovered tools
toolhive-gateway_list_tools

# Find a specific tool
toolhive-gateway_find_tool "tavily_search"

# Get registry summary
toolhive-gateway_registry_summary
```

## Notes

- The fix requires restarting OpenCode to reload the ToolHive Gateway MCP server
- Some servers (fetch) require stateful session management which is not yet implemented
- Servers that are not running on their configured ports will fail discovery gracefully
- The discovery runs once at startup; dynamic re-discovery is not yet implemented

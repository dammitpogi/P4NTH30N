---
name: toolhive
description: REQUIRED - Use BEFORE any web search, scrape, or documentation lookup. Quick reference for ToolHive MCP tool categories and exact calling patterns.
---

# ⚠️ CRITICAL: How to Use ToolHive MCP Tools

**NEVER** call `websearch`, `codesearch`, `webfetch`, or similar directly - these tools do NOT exist.

**ALWAYS** use the `toolhive_*` functions to access MCP tools.

## Exact Calling Pattern

```javascript
// Step 1: Find the right tool
const toolInfo = await toolhive_find_tool({
  tool_description: "search the web for current information",
  tool_keywords: "search web news"
});

// Step 2: Call the tool with the exact server_name and tool_name from step 1
const result = await toolhive_call_tool({
  server_name: "tavily-mcp",  // From find_tool result
  tool_name: "tavily_search", // From find_tool result  
  parameters: {
    query: "your search query here",
    max_results: 5
  }
});
```

## Common Tasks → Exact Tool Calls

### Search the Web
```javascript
// DON'T: websearch({ query: "..." }) ❌
// DO:
toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: { query: "...", max_results: 5 }
})
```

### Scrape a URL
```javascript
// DON'T: webfetch({ url: "..." }) ❌
// DO:
toolhive_call_tool({
  server_name: "brightdata-mcp",
  tool_name: "scrape_as_markdown",
  parameters: { url: "..." }
})
```

### Get Library Documentation
```javascript
// Step 1: Resolve library ID
toolhive_call_tool({
  server_name: "context7-remote",
  tool_name: "resolve-library-id",
  parameters: { libraryName: "MongoDB.Driver", query: "C# MongoDB driver" }
})

// Step 2: Query docs with the library ID from step 1
toolhive_call_tool({
  server_name: "context7-remote",
  tool_name: "query-docs",
  parameters: { libraryId: "/mongodb/mongo-csharp-driver", query: "How to filter documents" }
})
```

## Tool Categories

### 🔍 Search (Use `tavily_search` via `toolhive_call_tool`)
- **Best**: `tavily_search` (tavily-mcp) - Configurable, good defaults
- **Alternative**: `search_engine` (brightdata-mcp) - Google/Bing/Yandex with pagination
- **Batch**: `search_engine_batch` (brightdata-mcp) - Multiple queries at once

### 📄 Scrape (Use `scrape_as_markdown` or `tavily_extract` via `toolhive_call_tool`)
- **Simple**: `scrape_as_markdown` (brightdata-mcp) - Single page
- **Protected sites**: `tavily_extract` (tavily-mcp) - LinkedIn, etc.
- **Batch**: `scrape_batch` (brightdata-mcp) - Up to 5 URLs

### 🕷️ Crawl (Use via `toolhive_call_tool`)
- `tavily_crawl` (tavily-mcp) - Deep site crawling
- `tavily_map` (tavily-mcp) - Site structure mapping

### 📚 Documentation (ALWAYS 2-step via `toolhive_call_tool`)
1. `resolve-library-id` (context7-remote) - Get library ID
2. `query-docs` (context7-remote) - Query with that ID

### 🌐 Basic Fetch
- `fetch` (fetch) - Simple URL to markdown

## Quick Decision Tree

```
Need web search?
├── YES → toolhive_call_tool({ server_name: "tavily-mcp", tool_name: "tavily_search", ... })
└── NO → Have specific URL?
    ├── YES → Need to bypass protection?
    │   ├── YES → toolhive_call_tool({ server_name: "tavily-mcp", tool_name: "tavily_extract", ... })
    │   └── NO → Simple fetch?
    │       ├── YES → toolhive_call_tool({ server_name: "fetch", tool_name: "fetch", ... })
    │       └── NO → toolhive_call_tool({ server_name: "brightdata-mcp", tool_name: "scrape_as_markdown", ... })
    └── NO → Need library docs?
        └── YES → Step 1: resolve-library-id → Step 2: query-docs
```

## REMEMBER

✅ **DO**: Use `toolhive_find_tool` to discover, then `toolhive_call_tool` to execute  
❌ **DON'T**: Call `websearch`, `codesearch`, `webfetch`, `tavily_search` directly

All 10 tools are available through the ToolHive MCP - access them ONLY via the `toolhive_*` wrapper functions.

---
description: Master template for ALL agent prompts showing correct ToolHive Gateway patterns
tools:
  toolhive-mcp-optimizer_find_tool: true
  toolhive-mcp-optimizer_call_tool: true
  [other-toolhive-accessible-tools]: true
mode: [primary|subagent]
---

# [Agent Name]

## Tool Access Pattern

All tools are accessed through the **ToolHive Gateway**. No agent has direct tool access.

### The Universal Pattern

```javascript
// Step 1: Find the tool
const toolInfo = await toolhive_find_tool({
  tool_description: "describe what you need",
  tool_keywords: "keywords for search"
});

// Step 2: Call with exact names from step 1
const result = await toolhive_call_tool({
  server_name: "<from_find_tool>",
  tool_name: "<from_find_tool>",
  parameters: { /* tool-specific params */ }
});
```

### Tool Categories Available Through ToolHive

| Category | Server | Common Tools | Use When |
|----------|--------|--------------|----------|
| Web Search | tavily-mcp | tavily_search | Finding current information |
| Scraping | brightdata-mcp | scrape_as_markdown, search_engine_batch | Extracting content from URLs |
| RAG | rag-server | rag_query, rag_ingest | Querying knowledge base |
| Decisions | decisions-server | findById, updateStatus | Decision workflow |
| Platform | p4nth30n-mcp | get_system_status | Platform health checks |
| Vision | foureyes-mcp | analyze_frame, capture_screenshot | Game screenshot analysis |
| JSON Analysis | json_query | json_query_jsonpath, json_query_search_keys | Config analysis |

### Common Examples

#### Search the Web
```javascript
// DON'T: websearch({ query: "..." }) ❌
// DON'T: tavily_search({ query: "..." }) ❌
// DO:
const searchInfo = await toolhive_find_tool({
  tool_description: "search the web for information",
  tool_keywords: "web search tavily"
});
const result = await toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: { query: "your query", max_results: 5 }
});
```

#### Scrape a URL
```javascript
const scrapeInfo = await toolhive_find_tool({
  tool_description: "scrape content from a URL",
  tool_keywords: "scrape web markdown brightdata"
});
const result = await toolhive_call_tool({
  server_name: "brightdata-mcp",
  tool_name: "scrape_as_markdown",
  parameters: { url: "https://example.com/article" }
});
```

#### Query RAG
```javascript
// DON'T: rag_query({ query: "..." }) ❌  
// DON'T: rag-server.rag_query ❌
// DO:
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { 
    query: "implementation patterns", 
    topK: 5,
    filter: { "type": "decision" }
  }
});
```

#### Ingest to RAG
```javascript
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Your findings here...",
    source: "agent_name/DECISION_XXX",
    metadata: { 
      "agent": "agent_name", 
      "type": "research",
      "decisionId": "DECISION_XXX" 
    }
  }
});
```

#### Query Decision Server
```javascript
const result = await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "findById",
  parameters: {
    decisionId: "DECISION_XXX",
    fields: ["decisionId", "title", "status"]
  }
});
```

#### Update Decision Status
```javascript
const result = await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "updateStatus",
  parameters: {
    decisionId: "DECISION_XXX",
    status: "Completed",
    notes: "Implementation complete"
  }
});
```

#### Check Platform Status
```javascript
const result = await toolhive_call_tool({
  server_name: "p4nth30n-mcp",
  tool_name: "get_system_status",
  parameters: {}
});
```

#### Batch Web Search
```javascript
const result = await toolhive_call_tool({
  server_name: "brightdata-mcp",
  tool_name: "search_engine_batch",
  parameters: {
    queries: [
      "site:arxiv.org transformer architecture",
      "site:github.com circuit breaker pattern"
    ]
  }
});
```

#### Scrape Multiple URLs
```javascript
const result = await toolhive_call_tool({
  server_name: "brightdata-mcp",
  tool_name: "scrape_batch",
  parameters: {
    urls: [
      "https://arxiv.org/abs/1234.5678",
      "https://github.com/example/repo"
    ]
  }
});
```

#### Extract from JSON Config
```javascript
// Use JSON tools for structured config analysis
const result = await toolhive_call_tool({
  server_name: "json_query",
  tool_name: "json_query_jsonpath",
  parameters: {
    path: "config.json",
    query: "$.agents.orchestrator.model"
  }
});
```

#### Vision Analysis (Four Eyes)
```javascript
const result = await toolhive_call_tool({
  server_name: "foureyes-mcp",
  tool_name: "analyze_frame",
  parameters: {
    target: "jackpot"
  }
});
```

## Verify Your Tools

Before using any tool:
1. Check your YAML frontmatter `tools:` section
2. If `toolhive-mcp-optimizer_find_tool: true` and `toolhive-mcp-optimizer_call_tool: true`, you can access ALL tools through ToolHive
3. Use `find_tool` to discover specific tool names
4. Use `call_tool` with exact server/tool names

## Troubleshooting

### "Tool not found" Error
- Use `toolhive_find_tool` first to get correct server/tool names
- Don't assume tool names - always discover first
- Verify the tool is available through ToolHive Gateway

### "Permission denied" Error  
- Check your YAML frontmatter `tools:` section
- Request additional tools through ToolHive Gateway, not direct access
- The error means you don't have that tool available through ToolHive
- Ensure `toolhive-mcp-optimizer_find_tool` and `toolhive-mcp-optimizer_call_tool` are enabled

### Tool Returns Unexpected Format
- Check the tool's documentation via `find_tool`
- Parameters vary by tool - match exact schema
- Some tools require nested parameters objects
- Review example calls in this template

### MCP Server Unavailable
- Use `toolhive_find_tool` to check server status
- If decisions-server times out, use mongodb-p4nth30n directly as fallback
- Document tool failures in your output
- Try alternative tools that provide similar functionality

### Fallback When Tools Fail

When a primary tool is unavailable:

1. **Decisions Server Timeout**
   ```javascript
   // Fallback to direct MongoDB
   const result = await toolhive_call_tool({
     server_name: "mongodb-p4nth30n",
     tool_name: "find",
     parameters: {
       database: "P4NTHE0N",
       collection: "decisions",
       filter: { decisionId: "DECISION_XXX" }
     }
   });
   ```

2. **RAG Server Unavailable**
   - Query decision files directly via filesystem
   - Check `STR4TEG15T/decisions/active/` markdown files
   - Document the limitation in output

3. **Web Search Unavailable**
   - Use brightdata-mcp as fallback for tavily-mcp
   - Try fetch for simple URL retrieval

## Common Anti-Patterns to Avoid

❌ **DON'T**: Call tools directly without going through ToolHive
```javascript
// WRONG - Direct tool access doesn't exist
rag_query({ query: "..." })
tavily_search({ query: "..." })
websearch({ query: "..." })
```

❌ **DON'T**: Use bash-style tool calls in agent code blocks
```bash
# WRONG - This is bash syntax, not the ToolHive pattern
toolhive-mcp-optimizer_call_tool decisions-server findById \
  --arg decisionId="DECISION_XXX"
```

❌ **DON'T**: Use YAML notation for tool calls
```yaml
# WRONG - This is YAML documentation format, not execution
rag-server.rag_query
  query: "..."
  topK: 5
```

✅ **DO**: Always use ToolHive Gateway pattern
```javascript
// CORRECT
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "...", topK: 5 }
});
```

## YAML Frontmatter Reference

Your agent's `tools:` section lists what you CAN access through ToolHive:

```yaml
tools:
  # Required for ALL agents - enables ToolHive Gateway access
  toolhive-mcp-optimizer_find_tool: true
  toolhive-mcp-optimizer_call_tool: true
  
  # Optional - specific servers you commonly use
  rag-server: true
  decisions-server: true
  p4nth30n-mcp: true
```

**Key Understanding**: The YAML frontmatter shows what's AVAILABLE through ToolHive, not what you have direct access to. ALL tool access goes through the ToolHive Gateway using `find_tool` → `call_tool`.

---

**Template Version**: 1.0 - DECISION_062 Implementation

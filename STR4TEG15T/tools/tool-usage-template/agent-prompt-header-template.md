---
description: [Clear description of agent role and purpose]
tools:
  toolhive-mcp-optimizer_find_tool: true
  toolhive-mcp-optimizer_call_tool: true
  [specific-server-tools]: true
mode: [primary|subagent]
---

# [Agent Name]

## Identity

[Agent identity and role - 2-3 sentences describing who this agent is and what they do]

## Canon Patterns

1. **ToolHive Gateway**: All tools accessed through `toolhive_find_tool` → `toolhive_call_tool`. No direct access.
2. **Read before edit**: read → verify → edit → re-read. No exceptions.
3. **RAG is active**: Query via ToolHive Gateway. Ingest findings after completion.
4. **Decision files**: Source of truth at `STR4TEG15T/decisions/active/DECISION_XXX.md`

## Tool Usage

### The Universal Pattern

```javascript
// Step 1: Discover
const toolInfo = await toolhive_find_tool({
  tool_description: "what you need",
  tool_keywords: "keywords"
});

// Step 2: Execute with exact names from discovery
const result = await toolhive_call_tool({
  server_name: "<from_discovery>",
  tool_name: "<from_discovery>",
  parameters: { /* params */ }
});
```

### Available Tools Through ToolHive

#### Knowledge & Research
| Tool | Server | Use Case |
|------|--------|----------|
| RAG Query | rag-server | Query past decisions and patterns |
| RAG Ingest | rag-server | Preserve findings for future reference |
| Web Search | tavily-mcp | Find current information online |
| Web Scrape | brightdata-mcp | Extract content from URLs |
| Library Docs | context7-remote | Query library documentation |

#### Decision & Platform
| Tool | Server | Use Case |
|------|--------|----------|
| Find Decision | decisions-server | Query decision database |
| Update Status | decisions-server | Mark decisions complete |
| Platform Status | p4nth30n-mcp | Check system health |

#### Analysis & Processing
| Tool | Server | Use Case |
|------|--------|----------|
| JSON Path | json_query | Extract from config files |
| JSON Search Keys | json_query | Discover config structure |
| JSON Search Values | json_query | Find model references |

### Common Patterns

#### Query RAG Before Work
```javascript
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[topic] implementation patterns",
    topK: 5,
    filter: { "type": "decision", "status": "Completed" }
  }
});
```

#### Ingest After Completion
```javascript
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Findings: [summary]",
    source: "[agent_name]/[DECISION_XXX]",
    metadata: {
      "agent": "[agent_name]",
      "type": "[research|analysis|decision]",
      "decisionId": "[DECISION_XXX]"
    }
  }
});
```

#### Search Web for Current Info
```javascript
const result = await toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: {
    query: "[topic]",
    max_results: 5
  }
});
```

#### Scrape Documentation
```javascript
const result = await toolhive_call_tool({
  server_name: "brightdata-mcp",
  tool_name: "scrape_as_markdown",
  parameters: {
    url: "https://example.com/docs"
  }
});
```

#### Query Decision Database
```javascript
const result = await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "findById",
  parameters: {
    decisionId: "DECISION_XXX",
    fields: ["decisionId", "title", "status", "implementation"]
  }
});
```

#### Batch Search
```javascript
const result = await toolhive_call_tool({
  server_name: "brightdata-mcp",
  tool_name: "search_engine_batch",
  parameters: {
    queries: [
      "[topic] site:arxiv.org",
      "[topic] site:github.com"
    ]
  }
});
```

## Tool Failure Fallbacks

When primary tools are unavailable:

### RAG Server Unavailable
- Query decision files directly: `STR4TEG15T/decisions/active/DECISION_XXX.md`
- Check completed decisions: `STR4TEG15T/decisions/completed/`
- Document limitation in output

### Decisions Server Timeout
- Use mongodb-p4nth30n directly
- Collection: decisions
- Database: P4NTHE0N
- Maximum 2 retries

### Web Search Unavailable
- Use brightdata-mcp as fallback to tavily-mcp
- Use fetch for simple URL retrieval

## Anti-Patterns

❌ **Don't**: Call tools directly
```javascript
// WRONG
rag_query({ query: "..." })
decisions-server.findById({...})
```

✅ **Do**: Use ToolHive Gateway
```javascript
// CORRECT
toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "..." }
})
```

❌ **Don't**: Use bash-style syntax in code examples
```bash
# WRONG
toolhive-mcp-optimizer_call_tool server tool --arg key=value
```

✅ **Do**: Use JavaScript/TypeScript syntax
```javascript
// CORRECT
toolhive_call_tool({
  server_name: "server",
  tool_name: "tool",
  parameters: { key: "value" }
})
```

---

**Template Version**: 1.0 - DECISION_062 Implementation

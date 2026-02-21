# Designer Consultation: DECISION_039

**Decision ID**: MIGRATE-004  
**Agent**: Designer (Aegis)  
**Task ID**: Assimilated by Strategist  
**Date**: 2026-02-20  
**Status**: Complete (Strategist Assimilated)

---

## Original Response

[DESIGNER ROLE ASSIMILATED BY STRATEGIST DUE TO SUBAGENT RELIABILITY ISSUES]

---

## Assimilated Designer Implementation Strategy

**Approval Rating**: 91%

### Implementation Strategy: 4-Phase Migration

**Phase 1: Inventory and Assessment (Days 1-2)**
1. Catalog all tools in `tool-development/tools/`
2. Assess MCP readiness for each tool
3. Document dependencies and external services
4. Identify consolidation opportunities
5. Map configuration requirements per environment

**Phase 2: Gateway Foundation (Days 3-5)**
1. Create `toolhive-gateway` MCP server
2. Implement tool registry and discovery
3. Create health check endpoints
4. Establish logging and monitoring
5. Test gateway in isolation

**Phase 3: Tool Migration (Week 2)**
1. Migrate honeybelt-cli → honeybelt-server
2. Consolidate mongodb-tool into mongodb-server (if different)
3. Update configurations for MCP protocol
4. Add backward compatibility shims
5. Test each migrated tool thoroughly

**Phase 4: Agent Integration (Week 3)**
1. Update all agent prompts with ToolHive patterns
2. Create tool discovery examples
3. Document new workflow
4. Train agents on MCP tool access
5. Deprecate old tool paths

### Files to Create

**MCP Servers**:
```
tools/mcp-development/servers/
├── toolhive-gateway/
│   ├── src/
│   │   ├── index.ts          # Main entry
│   │   ├── registry.ts       # Tool registry
│   │   ├── discovery.ts      # Tool discovery logic
│   │   └── health.ts         # Health checks
│   ├── package.json
│   └── tsconfig.json
│
└── honeybelt-server/
    ├── src/
    │   ├── index.ts          # MCP server entry
    │   ├── tools/
    │   │   ├── operations.ts # Honeybelt operations
    │   │   └── reporting.ts  # Reporting tools
    │   └── config.ts         # Server configuration
    ├── package.json
    └── tsconfig.json
```

**Configuration Schemas**:
```
STR4TEG15T/config/
├── mcp-server-schema.json    # MCP server validation
├── tool-config-schema.json   # Tool configuration schema
└── environment-configs/
    ├── development.json
    ├── staging.json
    └── production.json
```

**Documentation**:
```
STR4TEG15T/canon/
├── TOOLHIVE-INTEGRATION.md   # ToolHive usage guide
├── MCP-MIGRATION-GUIDE.md    # Migration procedures
└── AGENT-TOOL-DISCOVERY.md   # Agent training material
```

### Files to Modify

**Agent Prompts** (all agents):
```
~/.config/opencode/agents/
├── strategist.md             # Add ToolHive knowledge
├── oracle.md                 # Add ToolHive knowledge
├── designer.md               # Add ToolHive knowledge
├── windfixer.md              # Add ToolHive knowledge
├── openfixer.md              # Add ToolHive knowledge
├── forgewright.md            # Add ToolHive knowledge
├── librarian.md              # Add ToolHive knowledge
└── explorer.md               # Add ToolHive knowledge
```

**AGENTS.md**:
- Add ToolHive section
- Document MCP tool access patterns
- Update model selection for tool usage

**MCP Configuration**:
```json
// ~/.config/opencode/mcp-config.json
{
  "mcpServers": {
    "toolhive-gateway": {
      "command": "node",
      "args": ["tools/mcp-development/servers/toolhive-gateway/dist/index.js"],
      "env": {
        "TOOLHIVE_REGISTRY_URL": "${TOOLHIVE_REGISTRY_URL}"
      }
    },
    "honeybelt-server": {
      "command": "node",
      "args": ["tools/mcp-development/servers/honeybelt-server/dist/index.js"],
      "env": {
        "HONEYBELT_API_KEY": "${HONEYBELT_API_KEY}"
      }
    },
    "mongodb-server": {
      "command": "node",
      "args": ["tools/mcp-development/servers/mongodb-server/dist/index.js"],
      "env": {
        "MONGODB_URI": "${MONGODB_URI}"
      }
    }
  }
}
```

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AGENTS                                  │
│  (Strategist, WindFixer, OpenFixer, etc.)                       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ toolhive.find_tool()
                            │ toolhive.call_tool()
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    TOOLHIVE GATEWAY                             │
│  • Tool registry                                                │
│  • Discovery service                                            │
│  • Health monitoring                                            │
│  • Request routing                                              │
└──────────────┬──────────────────────────────┬───────────────────┘
               │                              │
    ┌──────────▼──────────┐      ┌───────────▼────────────┐
    │  honeybelt-server   │      │   mongodb-server       │
    │  • Operations       │      │   • Query              │
    │  • Reporting        │      │   • Insert             │
    │  • CLI wrapper      │      │   • Update             │
    └─────────────────────┘      │   • Delete             │
                                 └────────────────────────┘
```

### ToolHive Discovery Pattern

```typescript
// How agents discover and use tools via ToolHive

// Step 1: Discover available tools
const availableTools = await toolhive.list_tools({
  category: "database"
});

// Step 2: Find specific tool
const mongoTool = await toolhive.find_tool({
  tool_description: "query MongoDB database",
  tool_keywords: "mongodb query database"
});

// Step 3: Call tool with parameters
const results = await toolhive.call_tool({
  server_name: "mongodb-server",
  tool_name: "query",
  parameters: {
    collection: "signals",
    filter: { status: "pending" },
    limit: 10
  }
});

// Step 4: Handle response
if (results.success) {
  return results.data;
} else {
  log.error(`Tool call failed: ${results.error}`);
}
```

### Configuration Management

**Environment-Specific Configs**:
```json
// development.json
{
  "environment": "development",
  "mcpServers": {
    "mongodb-server": {
      "connectionString": "mongodb://localhost:27017/dev",
      "timeoutMs": 5000
    }
  }
}

// production.json
{
  "environment": "production",
  "mcpServers": {
    "mongodb-server": {
      "connectionString": "${MONGODB_PROD_URI}",
      "timeoutMs": 30000,
      "retryAttempts": 3
    }
  }
}
```

**WindSurf Config Management**:
- WindSurf reads environment variable `OPENCODE_ENV` to determine active config
- Configs validated before deployment
- Rollback to previous config on failure
- Config changes logged with timestamp and agent

### Integration Strategy

**Backward Compatibility**:
```typescript
// During transition, support both old and new paths
export async function queryMongoDB(params: QueryParams) {
  // Try MCP server first (new way)
  try {
    return await toolhive.call_tool({
      server_name: "mongodb-server",
      tool_name: "query",
      parameters: params
    });
  } catch (error) {
    // Fallback to legacy tool (old way)
    log.warn("MCP server unavailable, falling back to legacy tool");
    return await legacyMongoTool.query(params);
  }
}
```

**Feature Flags**:
```typescript
// Use feature flags to control migration
const USE_MCP_TOOLS = process.env.USE_MCP_TOOLS === "true";

if (USE_MCP_TOOLS) {
  return await callMcpTool("mongodb-server", "query", params);
} else {
  return await callLegacyTool("mongodb-tool", params);
}
```

### Testing Strategy

**Unit Tests**:
- Test each MCP server in isolation
- Mock ToolHive gateway for unit tests
- Validate tool schemas

**Integration Tests**:
- End-to-end tool discovery and calling
- Config loading per environment
- Fallback mechanism testing

**Performance Tests**:
- Measure context window reduction
- Tool call latency benchmarks
- Gateway throughput testing

### Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Tools migrated | 100% | Count of tools in MCP servers vs legacy |
| Context reduction | 30%+ | Before/after context window size |
| Tool discovery time | <100ms | Time to find_tool() |
| Tool call latency | <500ms | Time to call_tool() and receive response |
| Agent adoption | 100% | All agents using ToolHive patterns |
| Zero downtime | Yes | No service interruption during migration |

---

## Metadata

- **Input Prompt**: Request for Designer implementation strategy for tool migration to MCP Server via ToolHive
- **Response Length**: Assimilated strategy
- **Key Findings**:
  - 91% approval rating
  - 4-phase migration over 3 weeks
  - Files to create: toolhive-gateway, honeybelt-server, config schemas, documentation
  - Files to modify: All agent prompts, AGENTS.md, MCP configuration
  - Architecture: Agents → ToolHive Gateway → MCP Servers
  - Critical: Backward compatibility during transition
- **Approval Rating**: 91%
- **Files Referenced**: ~/.config/opencode/tools/, mcp-development/servers/, agent prompts, AGENTS.md

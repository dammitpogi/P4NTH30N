# src/mcp/

## Responsibility

Defines built-in MCP (Model Context Protocol) endpoints that provide external tool capabilities to AI agents. The module exposes type-safe configurations for remote services (websearch, context7, grep.app) and provides a centralized factory for creating MCP instances while respecting user feature flags.

## Design

### Architecture Pattern
**Centralized MCP Registry with Environment-Based Authentication**

- **Type System** (`types.ts`):
  - Discriminated union `McpConfig` with `RemoteMcpConfig` and `LocalMcpConfig`
  - Compile-time type safety for MCP configurations
  - Clear separation between remote and local endpoints

- **Service Modules**: One file per MCP service
  - `websearch.ts`: Exa AI web search endpoint
  - `context7.ts`: Documentation lookup service
  - `grep-app.ts`: Code search service
  - Each exports a `RemoteMcpConfig` literal with service-specific URL and auth headers

- **Factory Pattern** (`index.ts`):
  - `createBuiltinMcps()`: Filters disabled MCPs from config
  - Returns `Record<McpName, McpConfig>` for runtime consumption
  - Centralizes all built-in MCP definitions

### Key Design Decisions
1. **Eager Evaluation**: MCP configs evaluated at startup, not per-request
2. **Environment Variable Injection**: API keys injected at runtime to avoid hardcoding
3. **Discriminated Unions**: Type-safe branching based on `type` field
4. **Feature Flag Respect**: `disabled_mcps` from user config honored during creation

## Flow

### MCP Initialization Flow
```
Plugin Startup
    ↓
Load user config (disabled_mcps list)
    ↓
createBuiltinMcps(config)
    ↓
Iterate over built-in MCP registry
    ↓
Filter out disabled MCPs
    ↓
Return Record<string, McpConfig>
    ↓
Pass to OpenCode MCP registry
```

### Request Flow
```
Agent needs external tool
    ↓
Check if agent has MCP permission
    ↓
Lookup MCP config from registry
    ↓
Inject credentials from environment
    ↓
Create MCP session with config
    ↓
Agent uses MCP tools
```

### Configuration Flow
```
Environment Variables Loaded
    ↓
EXA_API_KEY, CONTEXT7_API_KEY, GREP_APP_KEY, etc.
    ↓
MCP configs read env vars for headers
    ↓
Headers passed with every MCP request
    ↓
Remote services authenticate requests
```

## Integration

### Dependencies
- **External Services**: Exa AI (web search), Context7 (docs), Grep.app (code search)
- **Environment Variables**: API keys injected at runtime
- **OpenCode Core**: MCP registry integration

### Consumers
1. **Main Plugin** (`src/index.ts`): Calls `createBuiltinMcps()` to build MCP map
2. **Agent Configuration** (`src/config/agent-mcps.ts`): Assigns MCPs to agents
3. **User Configuration**: `disabled_mcps` list controls which MCPs are active

### MCP Services Included
| Service | Environment Variable | Purpose | URL |
|---------|---------------------|---------|-----|
| `websearch` | `EXA_API_KEY` | Real-time web search | `https://mcp.exa.ai/mpc?tools=web_search_exa` |
| `context7` | `CONTEXT7_API_KEY` | Documentation lookup | Context7 remote endpoint |
| `grep-app` | `GREP_APP_KEY` | Code search across GitHub | Grep.app remote endpoint |

### Security Considerations
- **API keys never hardcoded**: Always read from environment
- **Headers only set when key exists**: Graceful degradation when not configured
- **Disabled MCPs completely filtered**: Not even instantiated if in `disabled_mcps`
- **Type safety enforced**: No runtime surprises from malformed configs

### Configuration Integration
User can disable MCPs globally in plugin config:
```typescript
{
  "disabled_mcps": ["websearch", "grep-app"]
}
```
This prevents both instantiation and permission assignment.

### Extension Points
To add a new built-in MCP:
1. Create `src/mcp/newservice.ts` exporting `RemoteMcpConfig` or `LocalMcpConfig`
2. Add `McpName` to `src/config/constants.ts`
3. Add entry to `createBuiltinMcps()` in `src/mcp/index.ts`
4. Update `src/config/agent-mcps.ts` to assign to appropriate agents
5. Document environment variable required

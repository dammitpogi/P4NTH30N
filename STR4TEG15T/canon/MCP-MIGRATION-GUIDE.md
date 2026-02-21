# MCP Migration Guide

**Decision**: MIGRATE-004  
**Purpose**: How to migrate CLI tools to MCP servers

---

## When to Migrate

Migrate a CLI tool to MCP when:
1. Multiple agents need access to the same functionality
2. The tool is called frequently and benefits from persistent state
3. Context window pollution from tool schemas is significant
4. The tool would benefit from health monitoring

## MCP Server Template

### 1. Create Project Structure

```
tools/mcp-development/servers/<server-name>/
├── src/
│   ├── index.ts              # MCP stdio transport
│   └── tools/
│       └── <tool-name>.ts    # Tool implementation
├── package.json
└── tsconfig.json
```

### 2. Implement MCP Protocol

Every MCP server must handle these methods:
- `initialize` → Return server info and capabilities
- `tools/list` → Return tool definitions with input schemas
- `tools/call` → Execute tool and return results

### 3. Register with ToolHive Gateway

Add the server to `toolhive-gateway/src/index.ts` in `registerBuiltinServers()`:

```typescript
registry.register({
  id: 'my-server',
  name: 'My Server',
  transport: 'stdio',
  connection: { command: 'node', args: ['path/to/dist/index.js'] },
  tools: [
    { name: 'my_tool', description: 'Does something useful' },
  ],
  tags: ['category'],
  description: 'What this server does',
});
```

### 4. Add to Windsurf MCP Config

Add to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["C:/P4NTH30N/tools/mcp-development/servers/my-server/dist/index.js"]
    }
  }
}
```

### 5. Build and Test

```bash
cd tools/mcp-development/servers/<server-name>
npm install
npm run build
npm start  # Test stdio mode
```

## Naming Conventions

- Server ID: `kebab-case` (e.g., `honeybelt-server`)
- Tool names: `snake_case` (e.g., `honeybelt_status`)
- Tags: lowercase single words (e.g., `database`, `browser`, `tooling`)

---

*Canon document for DECISION_039 (MIGRATE-004)*

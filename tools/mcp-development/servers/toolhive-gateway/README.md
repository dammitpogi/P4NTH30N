# ToolHive MCP Gateway

## Overview

The **ToolHive MCP Gateway** is a unified Model Context Protocol (MCP) server that aggregates all P4NTH30N MCP servers into a single entry point for OpenCode. This centralizes tool access and simplifies configuration management.

## Architecture

```
┌─────────────────┐
│   OpenCode      │
│   (opencode.json)│
└────────┬────────┘
         │
         │ MCP Connection
         │ (stdio)
         ▼
┌──────────────────────┐
│  ToolHive Gateway    │
│  (Node.js/TypeScript)│
│  Port: stdio         │
└────────┬─────────────┘
         │
         │ Aggregates 5 MCP Servers
         │
    ┌────┴────┬────────┬────────┬────────┐
    ▼         ▼        ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│FourEyes│ │  RAG  │ │P4NTH30N│ │Decisions│ │Honeybelt│
│  MCP   │ │  MCP  │ │  MCP   │ │ Server  │ │ Server  │
└───────┘ └───────┘ └───────┘ └───────┘ └───────┘
```

## Location

**Source Code:** `C:/P4NTH30N/tools/mcp-development/servers/toolhive-gateway/`

**Entry Point:** `C:/P4NTH30N/tools/mcp-development/servers/toolhive-gateway/dist/index.js`

## Configuration

### OpenCode Configuration

Add to `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "toolhive-gateway": {
      "type": "local",
      "command": [
        "node",
        "C:/P4NTH30N/tools/mcp-development/servers/toolhive-gateway/dist/index.js"
      ],
      "enabled": true
    }
  }
}
```

### Verification

```bash
# Check MCP server status
opencode mcp list

# Expected output:
# ● ✓ toolhive-gateway connected
#     node C:/P4NTH30N/tools/mcp-development/servers/toolhive-gateway/dist/index.js
```

## Registered MCP Servers

### 1. FourEyes MCP Server
**ID:** `foureyes-mcp`
**Purpose:** Vision analysis via CDP + LMStudio
**Transport:** stdio
**Status:** healthy

**Tools:**
- `analyze_frame` - Capture CDP screenshot and analyze via LMStudio vision model
- `capture_screenshot` - Capture PNG screenshot from Chrome via CDP
- `check_health` - Check FourEyes subsystem health (LMStudio + CDP)
- `list_models` - List available models in LMStudio
- `review_decision` - FourEyes second-opinion review of a decision

**Command:**
```bash
node C:/P4NTH30N/tools/mcp-foureyes/server.js
```

### 2. RAG MCP Server
**ID:** `rag-server`
**Purpose:** Knowledge base search and document ingestion
**Transport:** stdio
**Status:** registered

**Tools:**
- `rag_query` - Search P4NTH30N knowledge base
- `rag_ingest` - Ingest document into knowledge base
- `rag_status` - Check RAG system status

**Command:**
```bash
C:/ProgramData/P4NTH30N/bin/RAG.McpHost.exe
  --port 5001
  --index C:/ProgramData/P4NTH30N/rag-index
  --model C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx
  --bridge http://127.0.0.1:5000
  --mongo mongodb://localhost:27017/P4NTH30N
```

### 3. P4NTH30N MCP Server
**ID:** `p4nth30n-mcp`
**Purpose:** MongoDB data access for casino automation
**Transport:** stdio
**Status:** healthy

**Tools:**
- `query_credentials` - Query CRED3N7IAL collection for user credentials and thresholds
- `query_signals` - Query SIGN4L collection for active signals
- `query_jackpots` - Query J4CKP0T collection for jackpot forecasts
- `get_system_status` - Get overall P4NTH30N system status summary

**Command:**
```bash
node C:/P4NTH30N/tools/mcp-p4nthon/dist/index.js
```

### 4. Decisions MCP Server
**ID:** `decisions-server`
**Purpose:** Decision management workflow
**Transport:** HTTP
**Status:** registered

**Tools:**
- `findById` - Find a decision by ID
- `findByStatus` - Find decisions by status
- `updateStatus` - Update decision status
- `createDecision` - Create a new decision
- `listActive` - List all active decisions

**URL:** `http://localhost:44276/mcp`

### 5. Honeybelt MCP Server
**ID:** `honeybelt-server`
**Purpose:** Tooling and operations
**Transport:** stdio
**Status:** registered

**Tools:**
- `honeybelt_status` - Check honeybelt service status
- `honeybelt_operations` - Execute honeybelt operations
- `honeybelt_report` - Generate honeybelt reports

**Command:**
```bash
node C:/P4NTH30N/tools/mcp-development/servers/honeybelt-server/dist/index.js
```

## Gateway Meta-Tools

The ToolHive Gateway provides 5 meta-tools for managing the server registry:

1. **`list_servers`** - List all registered MCP servers and their status
2. **`list_tools`** - List all available tools across all healthy servers
3. **`server_health`** - Get health status of all registered servers
4. **`find_tool`** - Find which server provides a specific tool
5. **`registry_summary`** - Get a compact summary of the tool registry

## Tool Naming Convention

Tools are exposed to OpenCode with the following naming pattern:

```
toolhive-gateway.{server-id}.{tool-name}
```

**Examples:**
- `toolhive-gateway.foureyes-mcp.analyze_frame`
- `toolhive-gateway.rag-server.rag_query`
- `toolhive-gateway.p4nth30n-mcp.query_credentials`
- `toolhive-gateway.decisions-server.findById`
- `toolhive-gateway.honeybelt-server.honeybelt_status`

## Health Monitoring

The gateway performs health checks every 60 seconds on all registered servers:

- **healthy** - Server is responding and operational
- **registered** - Server is registered but health check not yet performed
- **unhealthy** - Server is not responding

## Build Instructions

### Prerequisites
- Node.js 18+
- TypeScript

### Build Commands

```bash
cd C:/P4NTH30N/tools/mcp-development/servers/toolhive-gateway

# Install dependencies
npm install

# Build
npm run build

# The compiled output will be in dist/index.js
```

### Building Dependent Servers

If any of the registered MCP servers are missing their compiled files:

```bash
# Build P4NTH30N MCP Server
cd C:/P4NTH30N/tools/mcp-p4nthon
npm install
npm run build

# Build Honeybelt Server
cd C:/P4NTH30N/tools/mcp-development/servers/honeybelt-server
npm run build
```

## Troubleshooting

### Gateway Won't Start

1. Check that all server entry points exist:
   ```bash
   ls -la C:/P4NTH30N/tools/mcp-foureyes/server.js
   ls -la C:/P4NTH30N/tools/mcp-p4nthon/dist/index.js
   ls -la C:/ProgramData/P4NTH30N/bin/RAG.McpHost.exe
   ls -la C:/P4NTH30N/tools/mcp-development/servers/honeybelt-server/dist/index.js
   ```

2. Rebuild missing servers (see Build Instructions above)

3. Check OpenCode configuration:
   ```bash
   opencode debug config | grep -A 10 '"mcp"'
   ```

### Tools Not Appearing

1. Verify the gateway is connected:
   ```bash
   opencode mcp list
   ```

2. Check for errors in OpenCode logs

3. Restart OpenCode to reload MCP servers

### Server Shows as "unhealthy"

1. Check if the underlying server process can start independently
2. Verify network connectivity (for HTTP servers like decisions-server)
3. Check server-specific logs

## Integration with Agents

Agents can access all ToolHive tools using the standard MCP tool calling pattern. The oh-my-opencode-theseus plugin automatically exposes these tools to agents based on their permissions.

### Agent Permission Example

```json
{
  "agent": {
    "strategist": {
      "tools": {
        "toolhive-gateway.decisions-server*": true,
        "toolhive-gateway.rag-server*": true
      }
    }
  }
}
```

## Future Enhancements

1. **Tool Call Proxying** - Currently the gateway aggregates tool definitions but doesn't proxy calls to underlying servers. Adding proxy functionality would enable full tool execution through the gateway.

2. **Dynamic Server Discovery** - Implement automatic discovery of new MCP servers in the P4NTH30N/tools directory.

3. **Load Balancing** - Support multiple instances of the same MCP server for high availability.

4. **Metrics Collection** - Track tool usage, latency, and error rates across all servers.

## References

- [MCP Documentation](https://modelcontextprotocol.io/)
- [OpenCode MCP Servers](https://opencode.ai/docs/mcp-servers/)
- [P4NTH30N AGENTS.md](C:/P4NTH30N/AGENTS.md)

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-20  
**Maintainer:** OpenFixer

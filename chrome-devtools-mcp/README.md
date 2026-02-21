# P4NTH30N CDP MCP Server

**OPS_018**: Enable Remote CDP Execution for MCP Server

Lightweight MCP server that provides `evaluate_script` with per-call `host`/`port` targeting for remote Chrome DevTools Protocol execution.

## Architecture

```
Cascade/H4ND → MCP (stdio or HTTP) → CDP WebSocket → Remote Chrome
```

## Tools

| Tool | Description |
|------|-------------|
| `evaluate_script` | Execute JavaScript on remote Chrome via CDP Runtime.evaluate |
| `list_targets` | List available CDP targets (pages, workers, etc.) |
| `navigate` | Navigate browser to a URL via CDP Page.navigate |
| `get_version` | Get Chrome browser version and protocol info |

All tools accept optional `host` (default: `192.168.56.1`) and `port` (default: `9222`) parameters.

## Usage

### From Cascade (stdio via Windsurf MCP config)

Configured in `~/.codeium/windsurf/mcp_config.json`. Reload Windsurf to activate.

```json
{
  "p4nth30n-cdp-mcp": {
    "command": "node",
    "args": ["C:\\P4NTH30N\\chrome-devtools-mcp\\server.js", "stdio"],
    "type": "stdio"
  }
}
```

### HTTP Server (for H4ND VM / programmatic access)

```powershell
# Start HTTP server (default port 5301)
.\Start-CdpMcpServer.ps1

# Background mode
.\Start-CdpMcpServer.ps1 -Background

# Custom port
.\Start-CdpMcpServer.ps1 -Port 5302
```

### Direct JSON-RPC call

```powershell
$body = '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"evaluate_script","arguments":{"function":"() => document.title","host":"192.168.56.1","port":9222}}}'
Invoke-RestMethod -Uri "http://127.0.0.1:5301/mcp" -Method POST -Body $body -ContentType "application/json"
```

## Prerequisites

- Chrome running on host with `--remote-debugging-port=9222 --remote-debugging-address=0.0.0.0`
- Network connectivity from caller to Chrome host (192.168.56.1:9222)
- Port proxy on host: `netsh interface portproxy add v4tov4 listenaddress=192.168.56.1 listenport=9222 connectaddress=127.0.0.1 connectport=9222`

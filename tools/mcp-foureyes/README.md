# P4NTH30N FourEyes MCP Server

MCP server exposing FourEyes vision capabilities for WindSurf and OpenCode.

## Tools

| Tool | Description |
|------|-------------|
| `analyze_frame` | CDP screenshot + LMStudio vision model analysis (jackpots, balance, state, buttons) |
| `capture_screenshot` | CDP screenshot capture (base64 PNG) |
| `check_health` | LMStudio + CDP connectivity check |
| `list_models` | Available vision models in LMStudio |
| `review_decision` | Second-opinion review via LMStudio text analysis |

## Requirements

- **Node.js** >= 18
- **Chrome CDP** running at configured host:port (default: 192.168.56.1:9222)
- **LMStudio** running at configured URL (default: http://localhost:1234)

## Installation

```bash
cd C:\P4NTH30N\tools\mcp-foureyes
npm install
```

## Configuration

### OpenCode (already configured)

In `~/.config/opencode/mcp.json`:
```json
{
  "foureyes-mcp": {
    "command": "node",
    "args": ["C:/P4NTH30N/tools/mcp-foureyes/server.js", "stdio"],
    "env": {
      "CDP_HOST": "192.168.56.1",
      "CDP_PORT": "9222",
      "LMSTUDIO_URL": "http://localhost:1234"
    }
  }
}
```

### WindSurf

Add to `~/.codeium/windsurf/mcp_config.json`:
```json
{
  "mcpServers": {
    "foureyes-mcp": {
      "command": "node",
      "args": ["C:/P4NTH30N/tools/mcp-foureyes/server.js", "stdio"],
      "env": {
        "CDP_HOST": "192.168.56.1",
        "CDP_PORT": "9222",
        "LMSTUDIO_URL": "http://localhost:1234"
      }
    }
  }
}
```

### HTTP Mode (programmatic access)

```bash
MCP_TRANSPORT=http MCP_PORT=5302 node server.js
# Server at http://127.0.0.1:5302/mcp
# Health: http://127.0.0.1:5302/health
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CDP_HOST` | `192.168.56.1` | Chrome CDP hostname |
| `CDP_PORT` | `9222` | Chrome CDP port |
| `LMSTUDIO_URL` | `http://localhost:1234` | LMStudio API URL |
| `MCP_TRANSPORT` | `stdio` | Transport mode: `stdio` or `http` |
| `MCP_PORT` | `5302` | HTTP server port (when using http transport) |

## Architecture

```
WindSurf/OpenCode → stdio → foureyes-mcp → CDP (screenshot)
                                          → LMStudio (vision analysis)
```

DECISION_036: FourEyes Development Assistant Activation

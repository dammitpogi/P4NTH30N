# Kimi Code MCP Server

MCP server that integrates Kimi Code API with Windsurf via ToolHive.

## Features

- **kimi_chat**: Send chat messages to Kimi K2 model
- **kimi_code_complete**: Get code completions from Kimi
- **kimi_explain_code**: Get code explanations from Kimi

## Deployment

### 1. Build and Deploy to ToolHive

```bash
cd C:\P4NTH30N\W1ND5URF\mcp

# Build the Docker image
docker build -t kimi-code-mcp .

# Deploy to ToolHive (requires ToolHive CLI)
thv deploy --file toolhive.yaml --env KIMI_API_KEY=sk-kimi-...
```

### 2. Configure Windsurf

Add this to your `~/.codeium/mcp_config.json`:

```json
{
  "mcpServers": {
    "kimi-code": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-e", "KIMI_API_KEY=sk-kimi-...",
        "kimi-code-mcp:latest"
      ]
    }
  }
}
```

Or if ToolHive exposes it as HTTP:

```json
{
  "mcpServers": {
    "kimi-code": {
      "url": "http://localhost:8080/kimi-code-mcp"
    }
  }
}
```

### 3. Restart Windsurf

1. Open Windsurf
2. Go to Settings > Tools > Windsurf Settings
3. Click "Refresh" next to MCP servers
4. "kimi-code" should appear in the list
5. Click "+ Add Server" to enable it

## Usage in Cascade

Once connected, you can use Kimi tools in Cascade:

```
Use kimi_chat to ask about this code
```

```
Use kimi_code_complete to finish this function
```

```
Use kimi_explain_code to explain the Mouse class
```

## Environment Variables

- `KIMI_API_KEY`: Your Kimi API key (required)
- `KIMI_BASE_URL`: Kimi API base URL (default: https://api.kimi.com/coding)

## Development

```bash
npm install
npm run build
npm start
```

## Architecture

```
Windsurf (Cascade) 
    ↓ MCP Protocol
ToolHive (MCP Server Host)
    ↓ HTTP/stdio
Kimi MCP Server Container
    ↓ HTTPS
Kimi API (api.kimi.com/coding)
```

# MCP-P4NTH30N

Model Context Protocol (MCP) server for P4NTH30N casino automation platform.

## Overview

This MCP server provides AI assistants with direct access to P4NTH30N's MongoDB data, enabling:
- Querying credentials and thresholds
- Checking signal status
- Retrieving jackpot forecasts
- Monitoring system health

## Installation

```bash
npm install
npm run build
```

## Configuration

Copy `.env.example` to `.env` and configure:

```bash
MONGODB_URI=mongodb://localhost:27017
DATABASE_NAME=P4NTH30N
```

## Usage

### With Claude Desktop

Add to your Claude Desktop config:

```json
{
  "mcpServers": {
    "p4nth30n": {
      "command": "node",
      "args": ["/path/to/mcp-p4nth30n/dist/index.js"],
      "env": {
        "MONGODB_URI": "mongodb://localhost:27017",
        "DATABASE_NAME": "P4NTH30N"
      }
    }
  }
}
```

### Available Tools

| Tool | Description |
|------|-------------|
| `query_credentials` | Query CRED3N7IAL collection |
| `query_signals` | Query SIGN4L collection |
| `query_jackpots` | Query J4CKP0T collection |
| `get_system_status` | Get system overview |

## Development

```bash
npm run dev    # Watch mode
npm run build  # Compile
npm start      # Run server
```

## License

MIT

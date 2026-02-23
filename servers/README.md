# P4NTH30N MCP Servers v2

ToolHive-native MCP servers for decisions, MongoDB operations, and RAG search.

## Quick Start

```bash
cd servers
cp .env.example .env
./scripts/deploy.sh
```

## Servers

| Server | Port | Description | Tools |
| --- | --- | --- | --- |
| decisions-server-v2 | 3000 | Decision lifecycle tools | 4 |
| mongodb-p4nth30n-v2 | 3001 | MongoDB CRUD and aggregation tools | 7 |
| rag-server-v2 | 3002 | Vector ingest/search tools | 4 |

## Integration Tests

```bash
cd servers
./scripts/test-integration.sh
```

## ToolHive Registration

Import these files into ToolHive Gateway/Desktop:

- `servers/decisions-server-v2/toolhive-config.json`
- `servers/mongodb-p4nth30n-v2/toolhive-config.json`
- `servers/rag-server-v2/toolhive-config.json`

## Layout

- `decisions-server-v2/` - decision MCP server
- `mongodb-p4nth30n-v2/` - MongoDB MCP server
- `rag-server-v2/` - RAG MCP server
- `tests/` - integration MCP client suite
- `scripts/` - deployment and verification scripts
- `docker-compose.production.yml` - production stack

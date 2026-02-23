# Deployment Guide

## Prerequisites

- Docker Engine 24+
- Docker Compose v2
- Node.js 20+ (for integration test runner)

## Environment Setup

```bash
cd servers
cp .env.example .env
```

Required variables:

- `MCP_AUTH_TOKEN`
- `MONGODB_URI`
- `VECTOR_STORE_PATH`
- `EMBEDDING_MODEL`

## Deploy

```bash
cd servers
./scripts/deploy.sh
```

Expected services:

- `decisions-server-v2` on `127.0.0.1:3000`
- `mongodb-p4nth30n-v2` on `127.0.0.1:3001`
- `rag-server-v2` on `127.0.0.1:3002`

## Validate

```bash
curl http://localhost:3000/health
curl http://localhost:3001/ready
curl http://localhost:3002/health
```

## Integration Test Pass

```bash
cd servers
./scripts/test-integration.sh
```

## ToolHive Registration

Register these config files:

- `decisions-server-v2/toolhive-config.json`
- `mongodb-p4nth30n-v2/toolhive-config.json`
- `rag-server-v2/toolhive-config.json`

## Troubleshooting

- **Container restart loop**: check `MCP_AUTH_TOKEN` and server logs (`docker compose -f docker-compose.production.yml logs -f`).
- **Mongo health not ready**: verify `MONGODB_URI` and Mongo container state.
- **Tool calls rejected**: ensure caller sends `Authorization: Bearer <token>` and `Origin: http://localhost:<port>`.

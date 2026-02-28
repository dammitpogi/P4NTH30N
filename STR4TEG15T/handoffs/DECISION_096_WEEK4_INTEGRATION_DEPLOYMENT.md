---
agent: strategist
type: handoff
decision: DECISION_096
phase: Week 4 - Integration Testing & ToolHive Deployment
created: 2026-02-22
assignee: openfixer
priority: Critical
---

# OPENFIXER HANDOFF: DECISION_096 Week 4 - Integration Testing & ToolHive Deployment

## Context

Week 1: Security foundation complete (15/15 tests, framework 2.0.0) ✅
Week 2: Server implementations complete (3 servers, 30 files, 9/9 tests) ✅
Week 3: MCP protocol complete (15 tools, Docker packaging, 11/11 tests) ✅

**Week 4 Objective**: End-to-end integration testing, ToolHive gateway registration, and production deployment configuration.

## Your Mission

Execute Week 4 scope for all three v2 servers:
1. **Integration Testing** - Test servers with actual MCP clients
2. **ToolHive Registration** - Configure servers for ToolHive gateway
3. **Production Deployment** - Docker Compose with all services
4. **Health Monitoring** - Comprehensive health checks and metrics
5. **Documentation** - Deployment runbook and operational guides

---

## Implementation Specification

### Part 1: Integration Testing Framework

Create `servers/tests/integration/mcp-client.test.ts`:

```typescript
import { describe, test, expect, beforeAll, afterAll } from 'vitest';
import { ChildProcess, spawn } from 'child_process';
import { setTimeout } from 'timers/promises';

// MCP Client for testing
class McpTestClient {
  private baseUrl: string;
  private authToken: string;
  private eventSource: EventSource | null = null;
  private messageQueue: unknown[] = [];
  private connectionId: string | null = null;

  constructor(baseUrl: string, authToken: string) {
    this.baseUrl = baseUrl;
    this.authToken = authToken;
  }

  async connect(): Promise<void> {
    // Establish SSE connection
    this.eventSource = new EventSource(
      `${this.baseUrl}/sse`,
      { headers: { Authorization: `Bearer ${this.authToken}` } }
    );

    return new Promise((resolve, reject) => {
      this.eventSource!.onmessage = (event) => {
        const data = JSON.parse(event.data);
        
        if (data.method === 'endpoint') {
          this.connectionId = new URL(data.params.uri).searchParams.get('connectionId');
          resolve();
        } else {
          this.messageQueue.push(data);
        }
      };

      this.eventSource!.onerror = reject;
    });
  }

  async initialize(): Promise<unknown> {
    return this.sendRequest('initialize', {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: { name: 'test-client', version: '1.0.0' }
    });
  }

  async listTools(): Promise<unknown> {
    return this.sendRequest('tools/list', {});
  }

  async callTool(name: string, args: unknown): Promise<unknown> {
    return this.sendRequest('tools/call', { name, arguments: args });
  }

  private async sendRequest(method: string, params: unknown): Promise<unknown> {
    const id = crypto.randomUUID();
    
    const response = await fetch(
      `${this.baseUrl}/message?connectionId=${this.connectionId}`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.authToken}`
        },
        body: JSON.stringify({ jsonrpc: '2.0', id, method, params })
      }
    );

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }

    // Wait for response in message queue
    for (let i = 0; i < 50; i++) {
      const msg = this.messageQueue.find(m => (m as { id?: string }).id === id);
      if (msg) {
        this.messageQueue = this.messageQueue.filter(m => m !== msg);
        return (msg as { result?: unknown }).result;
      }
      await setTimeout(100);
    }

    throw new Error('Request timeout');
  }

  disconnect(): void {
    this.eventSource?.close();
  }
}

// Test suite
describe('MCP Integration Tests', () => {
  let server: ChildProcess;
  let client: McpTestClient;
  const authToken = 'test-token-12345';

  beforeAll(async () => {
    // Start server
    server = spawn('node', ['dist/index.js'], {
      env: { ...process.env, MCP_AUTH_TOKEN: authToken, PORT: '3001' },
      cwd: './servers/decisions-server-v2'
    });

    // Wait for server to start
    await setTimeout(2000);

    // Create client
    client = new McpTestClient('http://localhost:3001', authToken);
    await client.connect();
  });

  afterAll(() => {
    client.disconnect();
    server.kill();
  });

  test('initialize returns server capabilities', async () => {
    const result = await client.initialize();
    expect(result).toHaveProperty('protocolVersion', '2024-11-05');
    expect(result).toHaveProperty('capabilities');
    expect(result).toHaveProperty('serverInfo');
  });

  test('tools/list returns tool definitions', async () => {
    await client.initialize();
    const result = await client.listTools();
    expect(result).toHaveProperty('tools');
    expect(Array.isArray((result as { tools: unknown[] }).tools)).toBe(true);
  });

  test('tools/call executes find_decision_by_id', async () => {
    await client.initialize();
    const result = await client.callTool('find_decision_by_id', {
      decisionId: 'DECISION_096'
    });
    expect(result).toHaveProperty('content');
  });
});
```

Create package.json in `servers/tests/`:

```json
{
  "name": "@p4nth30n/mcp-integration-tests",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "test:decisions": "vitest run integration/mcp-client.test.ts --reporter=verbose",
    "test:mongodb": "vitest run integration/mongodb-client.test.ts --reporter=verbose",
    "test:rag": "vitest run integration/rag-client.test.ts --reporter=verbose",
    "test:all": "vitest run --reporter=verbose"
  },
  "devDependencies": {
    "vitest": "^3.0.7",
    "@types/node": "^22.13.5"
  }
}
```

---

### Part 2: ToolHive Registration Configuration

Create `toolhive-config.json` for each server:

**decisions-server-v2/toolhive-config.json**:

```json
{
  "id": "decisions-server-v2",
  "name": "P4NTHE0N Decisions Server v2",
  "description": "MCP server for decision management and querying",
  "transport": "http",
  "connection": {
    "url": "http://localhost:3000",
    "healthEndpoint": "/health",
    "readyEndpoint": "/ready"
  },
  "tools": [
    {
      "name": "find_decision_by_id",
      "description": "Find a decision by its ID",
      "inputSchema": {
        "type": "object",
        "properties": {
          "decisionId": { "type": "string" }
        },
        "required": ["decisionId"]
      }
    },
    {
      "name": "find_decisions_by_status",
      "description": "Find decisions by status",
      "inputSchema": {
        "type": "object",
        "properties": {
          "status": { 
            "type": "string",
            "enum": ["Proposed", "Approved", "InProgress", "Completed", "Rejected"]
          },
          "limit": { "type": "number", "default": 10 }
        },
        "required": ["status"]
      }
    },
    {
      "name": "create_decision",
      "description": "Create a new decision",
      "inputSchema": {
        "type": "object",
        "properties": {
          "decisionId": { "type": "string" },
          "title": { "type": "string" },
          "category": { "type": "string" },
          "priority": { 
            "type": "string",
            "enum": ["Low", "Medium", "High", "Critical"]
          },
          "content": { "type": "string" }
        },
        "required": ["decisionId", "title", "category", "priority"]
      }
    },
    {
      "name": "update_decision_status",
      "description": "Update a decision status",
      "inputSchema": {
        "type": "object",
        "properties": {
          "decisionId": { "type": "string" },
          "status": { 
            "type": "string",
            "enum": ["Proposed", "Approved", "InProgress", "Completed", "Rejected"]
          }
        },
        "required": ["decisionId", "status"]
      }
    }
  ],
  "auth": {
    "type": "bearer",
    "envVar": "MCP_AUTH_TOKEN"
  },
  "tags": ["decisions", "database", "mcp"]
}
```

**mongodb-p4nth30n-v2/toolhive-config.json**:

```json
{
  "id": "mongodb-p4nth30n-v2",
  "name": "MongoDB P4NTHE0N Server v2",
  "description": "MCP server for MongoDB operations on P4NTHE0N database",
  "transport": "http",
  "connection": {
    "url": "http://localhost:3001",
    "healthEndpoint": "/health",
    "readyEndpoint": "/ready"
  },
  "tools": [
    {
      "name": "mongodb_find",
      "description": "Find documents in MongoDB",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string", "default": "P4NTHE0N" },
          "collection": { "type": "string" },
          "filter": { "type": "object" },
          "limit": { "type": "number", "default": 10 },
          "skip": { "type": "number", "default": 0 }
        },
        "required": ["collection"]
      }
    },
    {
      "name": "mongodb_find_one",
      "description": "Find a single document",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string" },
          "collection": { "type": "string" },
          "filter": { "type": "object" }
        },
        "required": ["collection", "filter"]
      }
    },
    {
      "name": "mongodb_insert_one",
      "description": "Insert a document",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string" },
          "collection": { "type": "string" },
          "document": { "type": "object" }
        },
        "required": ["collection", "document"]
      }
    },
    {
      "name": "mongodb_update_one",
      "description": "Update a document",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string" },
          "collection": { "type": "string" },
          "filter": { "type": "object" },
          "update": { "type": "object" }
        },
        "required": ["collection", "filter", "update"]
      }
    },
    {
      "name": "mongodb_delete_one",
      "description": "Delete a document",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string" },
          "collection": { "type": "string" },
          "filter": { "type": "object" }
        },
        "required": ["collection", "filter"]
      }
    },
    {
      "name": "mongodb_count",
      "description": "Count documents",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string" },
          "collection": { "type": "string" },
          "filter": { "type": "object" }
        },
        "required": ["collection"]
      }
    },
    {
      "name": "mongodb_aggregate",
      "description": "Run aggregation pipeline",
      "inputSchema": {
        "type": "object",
        "properties": {
          "database": { "type": "string" },
          "collection": { "type": "string" },
          "pipeline": { "type": "array" }
        },
        "required": ["collection", "pipeline"]
      }
    }
  ],
  "auth": {
    "type": "bearer",
    "envVar": "MCP_AUTH_TOKEN"
  },
  "tags": ["mongodb", "database", "mcp"]
}
```

**rag-server-v2/toolhive-config.json**:

```json
{
  "id": "rag-server-v2",
  "name": "RAG Server v2",
  "description": "MCP server for vector search and RAG operations",
  "transport": "http",
  "connection": {
    "url": "http://localhost:3002",
    "healthEndpoint": "/health",
    "readyEndpoint": "/ready"
  },
  "tools": [
    {
      "name": "rag_ingest",
      "description": "Ingest a document into vector store",
      "inputSchema": {
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "content": { "type": "string" },
          "metadata": { "type": "object" }
        },
        "required": ["id", "content"]
      }
    },
    {
      "name": "rag_search",
      "description": "Search for similar documents",
      "inputSchema": {
        "type": "object",
        "properties": {
          "query": { "type": "string" },
          "topK": { "type": "number", "default": 5 }
        },
        "required": ["query"]
      }
    },
    {
      "name": "rag_delete",
      "description": "Delete a document from vector store",
      "inputSchema": {
        "type": "object",
        "properties": {
          "id": { "type": "string" }
        },
        "required": ["id"]
      }
    },
    {
      "name": "rag_list",
      "description": "List all documents in vector store",
      "inputSchema": {
        "type": "object",
        "properties": {}
      }
    }
  ],
  "auth": {
    "type": "bearer",
    "envVar": "MCP_AUTH_TOKEN"
  },
  "tags": ["rag", "vector", "search", "mcp"]
}
```

---

### Part 3: Production Docker Compose

Create `servers/docker-compose.production.yml`:

```yaml
version: '3.8'

services:
  decisions-server-v2:
    build:
      context: ./decisions-server-v2
      dockerfile: Dockerfile
    container_name: decisions-server-v2
    ports:
      - "127.0.0.1:3000:3000"
    environment:
      - PORT=3000
      - BIND_ADDRESS=0.0.0.0
      - MCP_AUTH_TOKEN=${MCP_AUTH_TOKEN}
      - NODE_ENV=production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    networks:
      - mcp-network
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  mongodb-p4nth30n-v2:
    build:
      context: ./mongodb-p4nth30n-v2
      dockerfile: Dockerfile
    container_name: mongodb-p4nth30n-v2
    ports:
      - "127.0.0.1:3001:3001"
    environment:
      - PORT=3001
      - BIND_ADDRESS=0.0.0.0
      - MCP_AUTH_TOKEN=${MCP_AUTH_TOKEN}
      - MONGODB_URI=${MONGODB_URI}
      - NODE_ENV=production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3001/ready"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    networks:
      - mcp-network
    depends_on:
      - decisions-server-v2
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  rag-server-v2:
    build:
      context: ./rag-server-v2
      dockerfile: Dockerfile
    container_name: rag-server-v2
    ports:
      - "127.0.0.1:3002:3002"
    environment:
      - PORT=3002
      - BIND_ADDRESS=0.0.0.0
      - MCP_AUTH_TOKEN=${MCP_AUTH_TOKEN}
      - NODE_ENV=production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3002/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    networks:
      - mcp-network
    volumes:
      - rag-data:/data/vector-store
    depends_on:
      - decisions-server-v2
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  # Optional: MongoDB for local testing
  mongodb:
    image: mongo:7
    container_name: mongodb
    ports:
      - "127.0.0.1:27017:27017"
    environment:
      - MONGO_INITDB_DATABASE=P4NTHE0N
    volumes:
      - mongodb-data:/data/db
    networks:
      - mcp-network
    profiles:
      - with-mongodb

networks:
  mcp-network:
    driver: bridge

volumes:
  rag-data:
  mongodb-data:
```

Create `.env.example`:

```bash
# MCP Authentication (REQUIRED)
# Generate with: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
MCP_AUTH_TOKEN=your-256-bit-token-here

# MongoDB Connection (for mongodb-p4nth30n-v2)
MONGODB_URI=mongodb://host.docker.internal:27017/P4NTHE0N

# Optional: For local testing with Docker MongoDB
# MONGODB_URI=mongodb://mongodb:27017/P4NTHE0N
```

---

### Part 4: Deployment Scripts

Create `servers/scripts/deploy.sh`:

```bash
#!/bin/bash
set -e

echo "=== P4NTHE0N MCP Servers Deployment ==="

# Check environment
if [ -z "$MCP_AUTH_TOKEN" ]; then
    echo "ERROR: MCP_AUTH_TOKEN not set"
    exit 1
fi

# Build all servers
echo "Building Docker images..."
docker-compose -f docker-compose.production.yml build

# Start services
echo "Starting services..."
docker-compose -f docker-compose.production.yml up -d

# Wait for health checks
echo "Waiting for services to be healthy..."
sleep 5

# Verify health
for port in 3000 3001 3002; do
    if curl -sf http://localhost:$port/health > /dev/null; then
        echo "✓ Port $port is healthy"
    else
        echo "✗ Port $port is not responding"
        exit 1
    fi
done

echo ""
echo "=== Deployment Complete ==="
echo "Services running on:"
echo "  - decisions-server-v2: http://localhost:3000"
echo "  - mongodb-p4nth30n-v2: http://localhost:3001"
echo "  - rag-server-v2: http://localhost:3002"
```

Create `servers/scripts/test-integration.sh`:

```bash
#!/bin/bash
set -e

echo "=== Integration Test Suite ==="

# Generate test token
export MCP_AUTH_TOKEN="test-token-$(date +%s)"

# Start services
echo "Starting test environment..."
docker-compose -f docker-compose.production.yml up -d

# Wait for startup
sleep 5

# Run tests
echo "Running integration tests..."
cd tests
npm install
npm run test:all

# Cleanup
echo "Cleaning up..."
cd ..
docker-compose -f docker-compose.production.yml down

echo "=== Tests Complete ==="
```

---

### Part 5: Documentation

Create `servers/README.md`:

```markdown
# P4NTHE0N MCP Servers v2

ToolHive-native MCP servers for decision management, MongoDB operations, and RAG.

## Quick Start

```bash
# Set auth token
export MCP_AUTH_TOKEN=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")

# Deploy all servers
./scripts/deploy.sh
```

## Servers

| Server | Port | Description | Tools |
|--------|------|-------------|-------|
| decisions-server-v2 | 3000 | Decision management | 4 |
| mongodb-p4nth30n-v2 | 3001 | MongoDB operations | 7 |
| rag-server-v2 | 3002 | Vector search & RAG | 4 |

## Testing

```bash
# Run integration tests
./scripts/test-integration.sh

# Test individual server
curl -H "Authorization: Bearer $MCP_AUTH_TOKEN" \
  http://localhost:3000/health
```

## ToolHive Registration

1. Start servers: `./scripts/deploy.sh`
2. Import configurations:
   - decisions-server-v2/toolhive-config.json
   - mongodb-p4nth30n-v2/toolhive-config.json
   - rag-server-v2/toolhive-config.json

## Architecture

- **Transport**: HTTP with Server-Sent Events (SSE)
- **Protocol**: MCP 2024-11-05
- **Security**: Bearer token auth, localhost binding, origin validation
- **Framework**: @p4nth30n/mcp-framework@2.0.0
```

Create `servers/DEPLOYMENT.md`:

```markdown
# Deployment Guide

## Prerequisites

- Docker 24.0+
- Docker Compose 2.20+
- Node.js 20+ (for local testing)

## Production Deployment

### 1. Environment Setup

```bash
cp .env.example .env
# Edit .env and set MCP_AUTH_TOKEN
```

### 2. Deploy

```bash
./scripts/deploy.sh
```

### 3. Verify

```bash
# Check health
curl http://localhost:3000/health
curl http://localhost:3001/ready
curl http://localhost:3002/health

# View logs
docker-compose -f docker-compose.production.yml logs -f
```

### 4. Register with ToolHive

Import toolhive-config.json files into ToolHive Desktop or Gateway.

## Monitoring

All servers expose:
- `/health` - Basic health check
- `/ready` - Dependency health (MongoDB, etc.)
- `/metrics` - Prometheus metrics (if enabled)

## Troubleshooting

**Server won't start:**
- Check MCP_AUTH_TOKEN is set
- Verify port availability (3000, 3001, 3002)
- Check Docker logs: `docker-compose logs`

**ToolHive can't connect:**
- Verify localhost binding (127.0.0.1)
- Check auth token matches
- Test with curl first

**MongoDB connection fails:**
- Verify MONGODB_URI
- Check network connectivity
- Ensure MongoDB is running
```

---

## Verification Checklist

- [ ] Integration tests pass (all 3 servers)
- [ ] Docker Compose production setup works
- [ ] All services start with `./scripts/deploy.sh`
- [ ] Health endpoints respond correctly
- [ ] ToolHive config files are valid JSON
- [ ] ToolHive can register and use all servers
- [ ] Documentation is complete and accurate
- [ ] Deployment scripts are executable
- [ ] MongoDB integration works (if tested)
- [ ] Log rotation configured

---

## Implementation Order

1. **Integration Tests** (2 hours)
   - Create test framework
   - Write tests for all servers
   - Run and validate

2. **ToolHive Configs** (1 hour)
   - Create toolhive-config.json for each server
   - Validate JSON structure
   - Test registration

3. **Production Docker Compose** (2 hours)
   - Create docker-compose.production.yml
   - Configure networking
   - Add health checks
   - Test full stack

4. **Deployment Scripts** (1 hour)
   - Create deploy.sh
   - Create test-integration.sh
   - Make executable
   - Test scripts

5. **Documentation** (1 hour)
   - Write README.md
   - Write DEPLOYMENT.md
   - Review and update

---

## Success Criteria

- Integration tests pass for all servers
- Docker Compose starts all services successfully
- ToolHive can register and use all servers
- Documentation is complete
- Deployment is reproducible

---

**Strategist Approval**: Ready for OpenFixer execution
**Priority**: Critical path - Week 4
**ETA**: 1-2 days

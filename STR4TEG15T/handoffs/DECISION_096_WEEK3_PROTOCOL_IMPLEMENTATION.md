---
agent: strategist
type: handoff
decision: DECISION_096
phase: Week 3 - MCP Protocol Implementation
created: 2026-02-22
assignee: windfixer
priority: Critical
---

# WINDFIXER HANDOFF: DECISION_096 Week 3 - MCP Protocol Implementation

## Context

Week 1: Security foundation complete (15/15 tests, framework 2.0.0)
Week 2: Server implementations complete (3 servers, 30 files, 9/9 tests passing)

**Week 3 Objective**: Implement actual MCP protocol handlers, tool definitions, and Docker packaging.

## Your Mission

Implement Week 3 scope for all three v2 servers:
1. **MCP Protocol Implementation** - initialize, tools/list, tools/call handlers
2. **Tool Definitions** - JSON schemas for all server operations
3. **MongoDB Integration** - Connection pooling + query execution for mongodb-p4nth30n-v2
4. **Vector Store Integration** - ChromaDB setup for rag-server-v2
5. **Docker Packaging** - Multi-stage builds for production deployment

---

## Implementation Specification

### Part 1: MCP Protocol Implementation (All Servers)

Update `src/protocol/mcp.ts` in each server:

```typescript
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';

// MCP Protocol Constants
const MCP_VERSION = '2024-11-05';
const PROTOCOL_VERSION = '2024-11-05';

// Server capabilities
const SERVER_CAPABILITIES = {
  tools: { listChanged: true },
  logging: {},
};

// Connection state
interface McpConnection {
  id: string;
  initialized: boolean;
  clientCapabilities?: unknown;
}

const connections = new Map<string, McpConnection>();

export async function registerMcpProtocol(server: FastifyInstance) {
  // POST /message - Main MCP message endpoint
  server.post('/message', async (request: FastifyRequest, reply: FastifyReply) => {
    const { connectionId } = request.query as { connectionId?: string };
    const message = request.body as McpMessage;
    
    if (!connectionId || !connections.has(connectionId)) {
      return reply.code(400).send({ 
        jsonrpc: '2.0', 
        error: { code: -32600, message: 'Invalid connection' },
        id: message.id 
      });
    }
    
    const response = await handleMcpMessage(connectionId, message);
    
    // Send response via SSE if request had id
    if (message.id !== undefined && response) {
      sendSseResponse(connectionId, response);
    }
    
    reply.code(202).send({ accepted: true });
  });
}

interface McpMessage {
  jsonrpc: '2.0';
  id?: string | number;
  method?: string;
  params?: unknown;
  result?: unknown;
  error?: { code: number; message: string; data?: unknown };
}

async function handleMcpMessage(
  connectionId: string, 
  message: McpMessage
): Promise<McpMessage | null> {
  const conn = connections.get(connectionId)!;
  
  // Handle requests (have id)
  if (message.id !== undefined && message.method) {
    switch (message.method) {
      case 'initialize':
        return handleInitialize(conn, message);
      case 'tools/list':
        return handleToolsList(conn, message);
      case 'tools/call':
        return handleToolsCall(conn, message);
      default:
        return {
          jsonrpc: '2.0',
          id: message.id,
          error: { code: -32601, message: `Method not found: ${message.method}` }
        };
    }
  }
  
  // Handle notifications (no id)
  if (message.method === 'notifications/initialized') {
    conn.initialized = true;
    return null;
  }
  
  return null;
}

function handleInitialize(conn: McpConnection, message: McpMessage): McpMessage {
  const params = message.params as { capabilities?: unknown };
  conn.clientCapabilities = params?.capabilities;
  
  return {
    jsonrpc: '2.0',
    id: message.id,
    result: {
      protocolVersion: PROTOCOL_VERSION,
      capabilities: SERVER_CAPABILITIES,
      serverInfo: {
        name: 'p4nth30n-decisions-server', // Change per server
        version: '2.0.0'
      }
    }
  };
}

function handleToolsList(conn: McpConnection, message: McpMessage): McpMessage {
  if (!conn.initialized) {
    return {
      jsonrpc: '2.0',
      id: message.id,
      error: { code: -32002, message: 'Server not initialized' }
    };
  }
  
  return {
    jsonrpc: '2.0',
    id: message.id,
    result: { tools: getToolDefinitions() }
  };
}

async function handleToolsCall(
  conn: McpConnection, 
  message: McpMessage
): Promise<McpMessage> {
  if (!conn.initialized) {
    return {
      jsonrpc: '2.0',
      id: message.id,
      error: { code: -32002, message: 'Server not initialized' }
    };
  }
  
  const params = message.params as { name: string; arguments?: unknown };
  
  try {
    const result = await executeTool(params.name, params.arguments);
    return {
      jsonrpc: '2.0',
      id: message.id,
      result: {
        content: [{ type: 'text', text: JSON.stringify(result, null, 2) }]
      }
    };
  } catch (error) {
    return {
      jsonrpc: '2.0',
      id: message.id,
      result: {
        content: [{ type: 'text', text: String(error) }],
        isError: true
      }
    };
  }
}

// Server-specific implementations
function getToolDefinitions(): unknown[] {
  // Override in each server
  return [];
}

async function executeTool(name: string, args: unknown): Promise<unknown> {
  // Override in each server
  throw new Error(`Tool not implemented: ${name}`);
}
```

---

### Part 2: Decisions-Server-v2 Tool Implementation

Create `src/tools/index.ts`:

```typescript
import { z } from 'zod';

// Tool Definitions
export const decisionTools = [
  {
    name: 'find_decision_by_id',
    description: 'Find a decision by its ID (e.g., DECISION_096)',
    inputSchema: {
      type: 'object',
      properties: {
        decisionId: { type: 'string', description: 'Decision ID' }
      },
      required: ['decisionId']
    }
  },
  {
    name: 'find_decisions_by_status',
    description: 'Find decisions by status (Proposed, Approved, InProgress, Completed)',
    inputSchema: {
      type: 'object',
      properties: {
        status: { 
          type: 'string', 
          enum: ['Proposed', 'Approved', 'InProgress', 'Completed', 'Rejected'],
          description: 'Decision status'
        },
        limit: { type: 'number', default: 10, description: 'Max results' }
      },
      required: ['status']
    }
  },
  {
    name: 'create_decision',
    description: 'Create a new decision',
    inputSchema: {
      type: 'object',
      properties: {
        decisionId: { type: 'string', description: 'Unique decision ID' },
        title: { type: 'string', description: 'Decision title' },
        category: { type: 'string', description: 'Decision category' },
        priority: { type: 'string', enum: ['Low', 'Medium', 'High', 'Critical'] },
        content: { type: 'string', description: 'Full decision content' }
      },
      required: ['decisionId', 'title', 'category', 'priority']
    }
  },
  {
    name: 'update_decision_status',
    description: 'Update a decision status',
    inputSchema: {
      type: 'object',
      properties: {
        decisionId: { type: 'string' },
        status: { 
          type: 'string', 
          enum: ['Proposed', 'Approved', 'InProgress', 'Completed', 'Rejected']
        }
      },
      required: ['decisionId', 'status']
    }
  }
];

// Tool Schemas for validation
const FindByIdSchema = z.object({ decisionId: z.string() });
const FindByStatusSchema = z.object({ 
  status: z.enum(['Proposed', 'Approved', 'InProgress', 'Completed', 'Rejected']),
  limit: z.number().default(10)
});
const CreateDecisionSchema = z.object({
  decisionId: z.string(),
  title: z.string(),
  category: z.string(),
  priority: z.enum(['Low', 'Medium', 'High', 'Critical']),
  content: z.string().optional()
});
const UpdateStatusSchema = z.object({
  decisionId: z.string(),
  status: z.enum(['Proposed', 'Approved', 'InProgress', 'Completed', 'Rejected'])
});

// Tool Handlers
export async function executeDecisionTool(
  name: string, 
  args: unknown
): Promise<unknown> {
  switch (name) {
    case 'find_decision_by_id':
      return findById(FindByIdSchema.parse(args));
    case 'find_decisions_by_status':
      return findByStatus(FindByStatusSchema.parse(args));
    case 'create_decision':
      return createDecision(CreateDecisionSchema.parse(args));
    case 'update_decision_status':
      return updateStatus(UpdateStatusSchema.parse(args));
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

async function findById(args: z.infer<typeof FindByIdSchema>) {
  // Implementation: Query MongoDB for decision
  return { decisionId: args.decisionId, status: 'mock' };
}

async function findByStatus(args: z.infer<typeof FindByStatusSchema>) {
  // Implementation: Query MongoDB for decisions by status
  return { decisions: [], count: 0 };
}

async function createDecision(args: z.infer<typeof CreateDecisionSchema>) {
  // Implementation: Insert decision into MongoDB
  return { created: true, decisionId: args.decisionId };
}

async function updateStatus(args: z.infer<typeof UpdateStatusSchema>) {
  // Implementation: Update decision status in MongoDB
  return { updated: true, decisionId: args.decisionId, status: args.status };
}
```

Update `src/protocol/mcp.ts` to use decision tools:

```typescript
import { decisionTools, executeDecisionTool } from '../tools/index.js';

function getToolDefinitions(): unknown[] {
  return decisionTools;
}

async function executeTool(name: string, args: unknown): Promise<unknown> {
  return executeDecisionTool(name, args);
}
```

---

### Part 3: MongoDB-P4NTHE0N-v2 Implementation

Create `src/db/connection.ts`:

```typescript
import { MongoClient, Db } from 'mongodb';

let client: MongoClient | null = null;
let db: Db | null = null;

export async function connectMongoDB(uri: string, dbName: string): Promise<Db> {
  if (client && db) {
    return db;
  }
  
  client = new MongoClient(uri, {
    maxPoolSize: 10,
    minPoolSize: 2,
    maxIdleTimeMS: 30000,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 30000,
  });
  
  await client.connect();
  db = client.db(dbName);
  
  console.log(`Connected to MongoDB: ${dbName}`);
  return db;
}

export async function disconnectMongoDB(): Promise<void> {
  if (client) {
    await client.close();
    client = null;
    db = null;
  }
}

export function getDb(): Db {
  if (!db) {
    throw new Error('MongoDB not connected. Call connectMongoDB first.');
  }
  return db;
}

export async function checkMongoDBHealth(): Promise<boolean> {
  try {
    if (!client) return false;
    await client.db().admin().ping();
    return true;
  } catch {
    return false;
  }
}
```

Create `src/tools/index.ts`:

```typescript
import { z } from 'zod';
import { getDb } from '../db/connection.js';

export const mongoTools = [
  {
    name: 'mongodb_find',
    description: 'Find documents in a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string', description: 'Database name (default: P4NTHE0N)' },
        collection: { type: 'string', description: 'Collection name' },
        filter: { type: 'object', description: 'MongoDB filter query' },
        limit: { type: 'number', default: 10 },
        skip: { type: 'number', default: 0 }
      },
      required: ['collection']
    }
  },
  {
    name: 'mongodb_find_one',
    description: 'Find a single document in a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' }
      },
      required: ['collection', 'filter']
    }
  },
  {
    name: 'mongodb_insert_one',
    description: 'Insert a single document into a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        document: { type: 'object', description: 'Document to insert' }
      },
      required: ['collection', 'document']
    }
  },
  {
    name: 'mongodb_update_one',
    description: 'Update a single document in a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' },
        update: { type: 'object', description: 'MongoDB update operation' }
      },
      required: ['collection', 'filter', 'update']
    }
  },
  {
    name: 'mongodb_delete_one',
    description: 'Delete a single document from a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' }
      },
      required: ['collection', 'filter']
    }
  },
  {
    name: 'mongodb_count',
    description: 'Count documents in a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' }
      },
      required: ['collection']
    }
  },
  {
    name: 'mongodb_aggregate',
    description: 'Run an aggregation pipeline on a MongoDB collection',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        pipeline: { type: 'array', description: 'Aggregation pipeline stages' }
      },
      required: ['collection', 'pipeline']
    }
  }
];

const FindSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  filter: z.record(z.unknown()).default({}),
  limit: z.number().default(10),
  skip: z.number().default(0)
});

const FindOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  filter: z.record(z.unknown())
});

const InsertOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  document: z.record(z.unknown())
});

const UpdateOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  filter: z.record(z.unknown()),
  update: z.record(z.unknown())
});

const DeleteOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  filter: z.record(z.unknown())
});

const CountSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  filter: z.record(z.unknown()).default({})
});

const AggregateSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string(),
  pipeline: z.array(z.record(z.unknown()))
});

export async function executeMongoTool(name: string, args: unknown): Promise<unknown> {
  const db = getDb();
  
  switch (name) {
    case 'mongodb_find': {
      const params = FindSchema.parse(args);
      const collection = db.collection(params.collection);
      const docs = await collection
        .find(params.filter)
        .skip(params.skip)
        .limit(params.limit)
        .toArray();
      return { documents: docs, count: docs.length };
    }
    
    case 'mongodb_find_one': {
      const params = FindOneSchema.parse(args);
      const collection = db.collection(params.collection);
      const doc = await collection.findOne(params.filter);
      return { document: doc, found: doc !== null };
    }
    
    case 'mongodb_insert_one': {
      const params = InsertOneSchema.parse(args);
      const collection = db.collection(params.collection);
      const result = await collection.insertOne(params.document);
      return { insertedId: result.insertedId, acknowledged: result.acknowledged };
    }
    
    case 'mongodb_update_one': {
      const params = UpdateOneSchema.parse(args);
      const collection = db.collection(params.collection);
      const result = await collection.updateOne(params.filter, params.update);
      return { 
        matchedCount: result.matchedCount, 
        modifiedCount: result.modifiedCount 
      };
    }
    
    case 'mongodb_delete_one': {
      const params = DeleteOneSchema.parse(args);
      const collection = db.collection(params.collection);
      const result = await collection.deleteOne(params.filter);
      return { deletedCount: result.deletedCount };
    }
    
    case 'mongodb_count': {
      const params = CountSchema.parse(args);
      const collection = db.collection(params.collection);
      const count = await collection.countDocuments(params.filter);
      return { count };
    }
    
    case 'mongodb_aggregate': {
      const params = AggregateSchema.parse(args);
      const collection = db.collection(params.collection);
      const docs = await collection.aggregate(params.pipeline).toArray();
      return { documents: docs, count: docs.length };
    }
    
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}
```

Update `src/server.ts` to connect MongoDB on startup:

```typescript
import { connectMongoDB, disconnectMongoDB, checkMongoDBHealth } from './db/connection.js';

// In createServer():
const config = loadConfig();

// Connect to MongoDB
await connectMongoDB(config.MONGODB_URI, 'P4NTHE0N');

// Update health check to include MongoDB
server.get('/ready', async () => {
  const mongoHealthy = await checkMongoDBHealth();
  return {
    status: mongoHealthy ? 'ready' : 'not_ready',
    checks: { mongodb: mongoHealthy },
    timestamp: new Date().toISOString()
  };
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  await disconnectMongoDB();
  await server.close();
});
```

---

### Part 4: RAG-Server-v2 Implementation

Create `src/vector/store.ts`:

```typescript
// Simple in-memory vector store for v2.0
// Replace with ChromaDB integration for production

interface Document {
  id: string;
  content: string;
  embedding: number[];
  metadata: Record<string, unknown>;
}

const documents = new Map<string, Document>();

export async function addDocument(
  id: string, 
  content: string, 
  embedding: number[],
  metadata: Record<string, unknown> = {}
): Promise<void> {
  documents.set(id, { id, content, embedding, metadata });
}

export async function searchSimilar(
  queryEmbedding: number[],
  topK: number = 5
): Promise<Array<{ id: string; content: string; score: number; metadata: Record<string, unknown> }>> {
  const results = Array.from(documents.values()).map(doc => ({
    id: doc.id,
    content: doc.content,
    score: cosineSimilarity(queryEmbedding, doc.embedding),
    metadata: doc.metadata
  }));
  
  results.sort((a, b) => b.score - a.score);
  return results.slice(0, topK);
}

export async function deleteDocument(id: string): Promise<boolean> {
  return documents.delete(id);
}

export async function listDocuments(): Promise<string[]> {
  return Array.from(documents.keys());
}

function cosineSimilarity(a: number[], b: number[]): number {
  let dotProduct = 0;
  let normA = 0;
  let normB = 0;
  
  for (let i = 0; i < a.length; i++) {
    dotProduct += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }
  
  return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
}
```

Create `src/tools/index.ts`:

```typescript
import { z } from 'zod';
import { addDocument, searchSimilar, deleteDocument, listDocuments } from '../vector/store.js';

// Simple embedding function (replace with OpenAI or local model)
async function generateEmbedding(text: string): Promise<number[]> {
  // Mock embedding - 1536 dimensions of random values
  // In production, use OpenAI's text-embedding-3-small or local model
  const embedding = new Array(1536).fill(0).map(() => (Math.random() * 2 - 1));
  // Normalize
  const norm = Math.sqrt(embedding.reduce((sum, val) => sum + val * val, 0));
  return embedding.map(val => val / norm);
}

export const ragTools = [
  {
    name: 'rag_ingest',
    description: 'Ingest a document into the RAG vector store',
    inputSchema: {
      type: 'object',
      properties: {
        id: { type: 'string', description: 'Unique document ID' },
        content: { type: 'string', description: 'Document content' },
        metadata: { type: 'object', description: 'Optional metadata' }
      },
      required: ['id', 'content']
    }
  },
  {
    name: 'rag_search',
    description: 'Search for similar documents in the RAG vector store',
    inputSchema: {
      type: 'object',
      properties: {
        query: { type: 'string', description: 'Search query' },
        topK: { type: 'number', default: 5, description: 'Number of results' }
      },
      required: ['query']
    }
  },
  {
    name: 'rag_delete',
    description: 'Delete a document from the RAG vector store',
    inputSchema: {
      type: 'object',
      properties: {
        id: { type: 'string', description: 'Document ID to delete' }
      },
      required: ['id']
    }
  },
  {
    name: 'rag_list',
    description: 'List all documents in the RAG vector store',
    inputSchema: {
      type: 'object',
      properties: {}
    }
  }
];

const IngestSchema = z.object({
  id: z.string(),
  content: z.string(),
  metadata: z.record(z.unknown()).default({})
});

const SearchSchema = z.object({
  query: z.string(),
  topK: z.number().default(5)
});

const DeleteSchema = z.object({
  id: z.string()
});

export async function executeRagTool(name: string, args: unknown): Promise<unknown> {
  switch (name) {
    case 'rag_ingest': {
      const params = IngestSchema.parse(args);
      const embedding = await generateEmbedding(params.content);
      await addDocument(params.id, params.content, embedding, params.metadata);
      return { ingested: true, id: params.id };
    }
    
    case 'rag_search': {
      const params = SearchSchema.parse(args);
      const queryEmbedding = await generateEmbedding(params.query);
      const results = await searchSimilar(queryEmbedding, params.topK);
      return { results, count: results.length };
    }
    
    case 'rag_delete': {
      const params = DeleteSchema.parse(args);
      const deleted = await deleteDocument(params.id);
      return { deleted, id: params.id };
    }
    
    case 'rag_list': {
      const ids = await listDocuments();
      return { documents: ids, count: ids.length };
    }
    
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}
```

---

### Part 5: Docker Packaging

Create `Dockerfile` in each server directory:

```dockerfile
# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Copy built files and dependencies
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

# Non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Environment
ENV PORT=3000
ENV BIND_ADDRESS=127.0.0.1

EXPOSE 3000

CMD ["node", "dist/index.js"]
```

Create `docker-compose.yml` in each server directory:

```yaml
version: '3.8'

services:
  decisions-server-v2:
    build: .
    ports:
      - "127.0.0.1:3000:3000"
    environment:
      - PORT=3000
      - BIND_ADDRESS=127.0.0.1
      - MCP_AUTH_TOKEN=${MCP_AUTH_TOKEN}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
```

Create `.dockerignore`:

```
node_modules
npm-debug.log
.git
.env
dist
coverage
.DS_Store
```

---

## Verification Checklist

For each server, verify:

- [ ] MCP protocol handlers work:
  - [ ] initialize returns correct response
  - [ ] tools/list returns tool definitions
  - [ ] tools/call executes tools correctly
- [ ] Tool schemas validate inputs (Zod)
- [ ] MongoDB connection pooling works (mongodb-p4nth30n-v2)
- [ ] Vector search works (rag-server-v2)
- [ ] Docker build succeeds: `docker build -t test .`
- [ ] Docker container runs: `docker run -e MCP_AUTH_TOKEN=test test`
- [ ] Health endpoint responds in container
- [ ] All tests still pass

---

## Implementation Order

1. **MCP Protocol** (all servers)
   - Update src/protocol/mcp.ts with handlers
   - Test with MCP client or curl

2. **Tool Definitions** (all servers)
   - Create src/tools/index.ts
   - Wire into protocol handlers

3. **MongoDB Integration** (mongodb-p4nth30n-v2)
   - Add connection pooling
   - Implement all 7 MongoDB tools
   - Test against real MongoDB

4. **Vector Store** (rag-server-v2)
   - Implement store.ts
   - Add 4 RAG tools
   - Test ingest/search

5. **Docker** (all servers)
   - Create Dockerfiles
   - Test builds
   - Test containers

---

## Success Criteria

- All three servers implement complete MCP protocol
- Tool schemas validate inputs correctly
- MongoDB server has working connection pooling
- RAG server has working vector search
- All servers have working Docker builds
- Tests passing for all servers

---

**Strategist Approval**: Ready for WindFixer execution
**Priority**: Critical path - Week 3
**ETA**: 3-4 days

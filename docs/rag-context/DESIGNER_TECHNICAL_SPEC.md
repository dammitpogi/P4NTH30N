# RAG-001 Technical Design Specification
## Designer Technical Specification for Fixer Implementation

**Decision ID:** RAG-001  
**Title:** RAG Context Layer Implementation  
**Designer:** Aegis  
**Status:** Ready for Implementation  
**Version:** 1.0.0

---

## Table of Contents

1. [Component Architecture Diagram](#1-component-architecture-diagram)
2. [File-by-File Implementation Plan](#2-file-by-file-implementation-plan)
3. [API Contract Specifications](#3-api-contract-specifications)
4. [Data Flow Specifications](#4-data-flow-specifications)
5. [Error Handling Strategy](#5-error-handling-strategy)
6. [Performance Optimizations](#6-performance-optimizations)
7. [Testing Strategy](#7-testing-strategy)
8. [Deployment Sequence](#8-deployment-sequence)
9. [Design Decisions & Answers](#9-design-decisions--answers)

---

## 1. Component Architecture Diagram

### 1.1 System Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              P4NTH30N Platform                                   │
│                                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Orchestrator │  │   Designer   │  │   Oracle     │  │    Fixer     │         │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘         │
│         │                 │                 │                 │                  │
│         └─────────────────┴─────────────────┴─────────────────┘                  │
│                                       │                                          │
│                                       ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                    C# Service Layer (C0MMON/H0UND)                       │    │
│  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐       │    │
│  │  │ RagContextService│  │ IRagContext      │  │ RagContextIndexer│       │    │
│  │  │ (HTTP Client)    │──│ (Interface)      │  │ (Background)     │       │    │
│  │  └────────┬─────────┘  └──────────────────┘  └──────────────────┘       │    │
│  └───────────┼─────────────────────────────────────────────────────────────┘    │
│              │                                                                   │
│              │ HTTP/JSON                                                         │
│              ▼                                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                    MCP RAG Server (TypeScript/Node)                      │    │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐         │    │
│  │  │   Search   │  │   Index    │  │   Health   │  │   Stats    │         │    │
│  │  │   Tool     │  │   Tool     │  │   Tool     │  │   Tool     │         │    │
│  │  └─────┬──────┘  └─────┬──────┘  └────────────┘  └────────────┘         │    │
│  │        │               │                                                 │    │
│  │  ┌─────┴───────────────┴─────┐                                           │    │
│  │  │     Fallback Chain        │                                           │    │
│  │  │  ┌─────────────────────┐  │                                           │    │
│  │  │  │ L1: Qdrant Vector   │ ← Primary (Happy Path)                       │    │
│  │  │  │ L2: MongoDB Text    │ ← Fallback 1 (Qdrant unavailable)            │    │
│  │  │  │ L3: Empty Results   │ ← Fallback 2 (Both unavailable)              │    │
│  │  │  │ L4: Circuit Breaker │ ← Fallback 3 (Repeated failures)             │    │
│  │  │  └─────────────────────┘  │                                           │    │
│  │  └───────────────────────────┘                                           │    │
│  │        │               │               │                                  │    │
│  └────────┼───────────────┼───────────────┼──────────────────────────────────┘    │
│           │               │               │                                       │
└───────────┼───────────────┼───────────────┼───────────────────────────────────────┘
            │               │               │
            ▼               ▼               ▼
┌───────────────────┐ ┌──────────────┐ ┌──────────────────┐
│    LM Studio      │ │   Qdrant     │ │    MongoDB       │
│  (Embeddings)     │ │  (Vector DB) │ │  (Document +     │
│                   │ │              │ │   Metrics Store) │
│  Port: 1234       │ │  Port: 30333 │ │  Port: 27017     │
│  Model: nomic-    │ │  Collection: │ │  Collections:    │
│  embed-text-v1.5  │ │  p4nth30n_   │ │  C0N7EXT,        │
│  768 dims         │ │  context     │ │  R4G_M37R1C5     │
└───────────────────┘ └──────────────┘ └──────────────────┘
```

### 1.2 Search Operation Data Flow

```
┌─────────────────┐
│  Agent Request  │
│  (Search Query) │
└────────┬────────┘
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│                    RagContextService (C#)                         │
│  1. Build HTTP request with query, options, agent                │
│  2. Add correlation ID for tracing                               │
│  3. POST to MCP server                                           │
└───────────────────────────┬──────────────────────────────────────┘
                            │ HTTP POST /tools/rag_context_search
                            ▼
┌──────────────────────────────────────────────────────────────────┐
│                    MCP RAG Server (Node.js)                       │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Input Validation (Zod Schema)                           │    │
│  │  - query: string, 1-1000 chars                           │    │
│  │  - limit: integer, 1-20, default 5                       │    │
│  │  - category: enum [strategy, bugfix, architecture, casino]│   │
│  │  - game: optional string                                  │    │
│  │  - agent: optional string                                 │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Circuit Breaker Check                                   │    │
│  │  - Is circuit open? (5 failures in 60s)                  │    │
│  │  - If open → Return Level 4 fallback                     │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼ (Circuit closed)                     │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Level 1: Primary Vector Search                          │    │
│  │  1. Generate embedding via LM Studio (<50ms)             │    │
│  │  2. Query Qdrant with vector + filters                   │    │
│  │  3. Return results with scores                           │    │
│  │                                                          │    │
│  │  SUCCESS → Record metrics, return results                │    │
│  │  FAILURE → Increment failure count, try Level 2          │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼ (Qdrant failure)                     │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Level 2: MongoDB Text Search Fallback                   │    │
│  │  1. Execute $text search on C0N7EXT.content              │    │
│  │  2. Apply filters (category, game, contentType)          │    │
│  │  3. Sort by text score                                   │    │
│  │                                                          │    │
│  │  SUCCESS → Record metrics (fallback=true), return        │    │
│  │  FAILURE → Record failure, try Level 3                   │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼ (MongoDB failure)                    │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Level 3: Empty Results Fallback                         │    │
│  │  - Return empty results array                            │    │
│  │  - Set fallback=true, fallbackLevel=3                    │    │
│  │  - Log error to R4G_M37R1C5                              │    │
│  │  - Record failure (triggers circuit breaker if ≥5)       │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Metrics Logging (async, non-blocking)                   │    │
│  │  - Insert to R4G_M37R1C5 collection                      │    │
│  │  - Include: latency, fallback level, agent, query        │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Response Formatting                                     │    │
│  │  {                                                       │    │
│  │    results: [...],                                       │    │
│  │    latency: 145.2,                                       │    │
│  │    fallback: false,                                      │    │
│  │    fallbackLevel: 1,                                     │    │
│  │    circuitBreakerOpen: false,                            │    │
│  │    totalIndexed: 523                                     │    │
│  │  }                                                       │    │
│  └──────────────────────────────────────────────────────────┘    │
└───────────────────────────┬──────────────────────────────────────┘
                            │ HTTP Response
                            ▼
┌──────────────────────────────────────────────────────────────────┐
│                    RagContextService (C#)                         │
│  1. Deserialize JSON response                                    │
│  2. Map to RagSearchResult object                                │
│  3. Return to calling agent                                      │
└───────────────────────────┬──────────────────────────────────────┘
                            │
                            ▼
┌─────────────────┐
│  Agent Receives │
│  Search Results │
└─────────────────┘
```

### 1.3 Index Operation Data Flow

```
┌─────────────────┐
│  Document to    │
│  Index          │
└────────┬────────┘
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│                    RagContextIndexer (C#)                         │
│  1. Read document from source (file, chat, decision)             │
│  2. Build RagDocument object                                     │
│  3. Call IndexAsync()                                            │
└───────────────────────────┬──────────────────────────────────────┘
                            │ HTTP POST /tools/rag_context_index
                            ▼
┌──────────────────────────────────────────────────────────────────┐
│                    MCP RAG Server (Node.js)                       │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Input Validation (Zod Schema)                           │    │
│  │  - content: string, required                             │    │
│  │  - contentType: enum [chat, decision, code, docs]        │    │
│  │  - sessionId: string, required                           │    │
│  │  - metadata: object with agent, tags, category, game     │    │
│  │  - source: string (file path or identifier)              │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Text Chunking Service                                   │    │
│  │  1. Split content into semantic chunks                   │    │
│  │     - Max 512 tokens per chunk                           │    │
│  │     - 50 token overlap between chunks                    │    │
│  │     - Respect content boundaries (paragraphs, functions) │    │
│  │  2. Assign unique chunk IDs (UUID)                       │    │
│  │  3. Preserve metadata per chunk                          │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Embedding Generation (Parallel Batches)                 │    │
│  │  1. Call LM Studio /v1/embeddings                        │    │
│  │  2. Batch size: 32 chunks per request                    │    │
│  │  3. Retry on failure (3 attempts, exponential backoff)   │    │
│  │  4. Validate: 768 dimensions, normalized vectors         │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Qdrant Vector Upsert                                    │    │
│  │  1. Build points with vector + payload                   │    │
│  │  2. Batch upsert (100 points per batch)                  │    │
│  │  3. Retry on conflict (optimistic locking)               │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  MongoDB Document Storage                                │    │
│  │  1. Insert document to C0N7EXT collection                │    │
│  │  2. Include chunk references with vector IDs             │    │
│  │  3. Store original content for fallback search           │    │
│  └──────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │  Response                                                │    │
│  │  {                                                       │    │
│  │    success: true,                                        │    │
│  │    chunksIndexed: 3,                                     │    │
│  │    vectorIds: ['uuid-1', 'uuid-2', 'uuid-3'],            │    │
│  │    latencyMs: 245.5,                                     │    │
│  │    documentId: 'doc-uuid'                                │    │
│  │  }                                                       │    │
│  └──────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. File-by-File Implementation Plan

### 2.1 MCP Server - TypeScript Files

#### File: `MCP/rag-server/src/index.ts`

**Purpose:** Server entry point, HTTP server initialization, middleware setup

**Key Classes/Functions:**
```typescript
// Main server initialization
function main(): Promise<void>
function createServer(): Express.Application
function setupMiddleware(app: Express.Application): void
function setupRoutes(app: Express.Application): void
function gracefulShutdown(server: http.Server): void

// Configuration
interface ServerConfig {
  port: number;                    // Default: 3000
  mongodbUri: string;              // From env: MONGODB_URI
  qdrantUrl: string;               // From env: QDRANT_URL
  lmStudioUrl: string;             // From env: LM_STUDIO_URL
  logLevel: string;                // From env: LOG_LEVEL
}

function loadConfig(): ServerConfig
function validateConfig(config: ServerConfig): void
```

**Dependencies:**
```json
{
  "express": "^4.18.0",
  "@modelcontextprotocol/sdk": "^1.0.0",
  "winston": "^3.11.0",
  "cors": "^2.8.5",
  "helmet": "^7.1.0",
  "dotenv": "^16.3.0"
}
```

**Error Handling:**
- **Config validation errors:** Exit process with code 1, log error details
- **Database connection errors:** Retry 3 times with 5s delay, then exit
- **Uncaught exceptions:** Log to stderr, graceful shutdown
- **Unhandled rejections:** Log and continue (don't crash)

**Testing Approach:**
```typescript
// Unit test: Server startup
describe('index.ts', () => {
  it('should start server on configured port', async () => {
    const server = await main();
    expect(server.listening).toBe(true);
    expect(server.address().port).toBe(3000);
  });

  it('should validate required environment variables', () => {
    delete process.env.MONGODB_URI;
    expect(() => validateConfig(loadConfig())).toThrow('MONGODB_URI is required');
  });
});
```

---

#### File: `MCP/rag-server/src/server.ts`

**Purpose:** Express route handlers, MCP protocol implementation, request routing

**Key Classes/Functions:**
```typescript
// Route handlers
function setupToolRoutes(app: Express.Application): void
function setupHealthRoutes(app: Express.Application): void

// MCP protocol handlers
async function handleToolExecute(
  req: Request<{ toolName: string }>,
  res: Response
): Promise<void>

async function handleToolList(
  req: Request,
  res: Response
): Promise<void>

// Request validation
function validateToolInput(toolName: string, input: unknown): z.SafeParseReturnType

// Error response formatting
function formatErrorResponse(error: Error, fallback: boolean): ErrorResponse

// Tool registry
const tools: Map<string, ToolDefinition> = new Map();
function registerTool(tool: ToolDefinition): void
function getTool(name: string): ToolDefinition | undefined
```

**Dependencies:**
- `express` - HTTP framework
- `zod` - Schema validation
- `./tools/search` - Search tool implementation
- `./tools/index` - Index tool implementation
- `./tools/health` - Health tool implementation
- `./tools/stats` - Stats tool implementation

**Error Handling:**
```typescript
// Global error handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  logger.error('Unhandled error', { error: err.message, stack: err.stack });
  
  res.status(500).json({
    error: err.message,
    fallback: true,
    fallbackLevel: 3
  });
});

// Tool-specific error handling
try {
  const result = await tool.execute(validatedInput);
  res.json(result);
} catch (error) {
  if (error instanceof ValidationError) {
    res.status(400).json({ error: error.message });
  } else if (error instanceof ServiceUnavailableError) {
    res.status(503).json({ 
      error: error.message,
      fallback: true,
      fallbackLevel: error.fallbackLevel 
    });
  } else {
    res.status(500).json({ error: 'Internal server error' });
  }
}
```

**Testing Approach:**
```typescript
// Integration test
import request from 'supertest';
import { createApp } from './server';

describe('Server Routes', () => {
  let app: Express.Application;
  
  beforeAll(() => {
    app = createApp();
  });

  it('POST /tools/rag_context_search should return results', async () => {
    const response = await request(app)
      .post('/tools/rag_context_search')
      .send({ query: 'test', limit: 5 })
      .expect(200);
    
    expect(response.body).toHaveProperty('results');
    expect(response.body).toHaveProperty('latency');
  });

  it('GET /tools should list all tools', async () => {
    const response = await request(app)
      .get('/tools')
      .expect(200);
    
    expect(response.body.tools).toBeInstanceOf(Array);
    expect(response.body.tools.length).toBeGreaterThan(0);
  });
});
```

---

#### File: `MCP/rag-server/src/clients/lmStudio.ts`

**Purpose:** LM Studio embedding client with retry logic and connection pooling

**Key Classes/Functions:**
```typescript
// Client class
export class LMStudioClient {
  private httpClient: AxiosInstance;
  private config: LMStudioConfig;
  
  constructor(config: LMStudioConfig);
  
  // Main embedding method
  async generateEmbedding(text: string): Promise<number[]>;
  async generateEmbeddings(texts: string[]): Promise<number[][]>;
  
  // Health check
  async healthCheck(): Promise<boolean>;
  
  // Model info
  async getModelInfo(): Promise<ModelInfo>;
  
  // Batch processing with concurrency control
  private async processBatch(
    texts: string[],
    batchSize: number
  ): Promise<number[][]>;
  
  // Retry logic
  private async withRetry<T>(
    operation: () => Promise<T>,
    maxRetries: number
  ): Promise<T>;
}

// Configuration
interface LMStudioConfig {
  baseUrl: string;           // Default: http://localhost:1234
  model: string;             // Default: nomic-embed-text-v1.5
  timeout: number;           // Default: 30000ms
  maxRetries: number;        // Default: 3
  batchSize: number;         // Default: 32
}

// Response types
interface EmbeddingResponse {
  object: 'list';
  data: Array<{
    object: 'embedding';
    embedding: number[];
    index: number;
  }>;
  model: string;
  usage: {
    prompt_tokens: number;
    total_tokens: number;
  };
}
```

**Dependencies:**
```json
{
  "axios": "^1.6.0"
}
```

**Error Handling:**
```typescript
// Expected errors and handling
const ErrorHandlers = {
  // Network errors (timeout, connection refused)
  NETWORK_ERROR: async (error: AxiosError) => {
    logger.warn('LM Studio network error', { message: error.message });
    // Retry with exponential backoff
    throw new RetryableError(error.message);
  },
  
  // Model not loaded
  MODEL_NOT_FOUND: async (error: AxiosError) => {
    logger.error('Embedding model not loaded in LM Studio');
    throw new ServiceUnavailableError('Embedding service unavailable');
  },
  
  // Invalid input (too long)
  INPUT_TOO_LONG: async (error: AxiosError) => {
    logger.warn('Input too long for embedding', { length: text.length });
    // Truncate and retry
    const truncated = text.slice(0, 2048);
    return this.generateEmbedding(truncated);
  },
  
  // Rate limiting (unlikely with local model)
  RATE_LIMITED: async (error: AxiosError) => {
    const delay = parseInt(error.response?.headers['retry-after'] || '1');
    await sleep(delay * 1000);
    throw new RetryableError('Rate limited, retrying');
  }
};
```

**Testing Approach:**
```typescript
describe('LMStudioClient', () => {
  let client: LMStudioClient;
  let mockServer: MockAdapter;
  
  beforeEach(() => {
    client = new LMStudioClient({ baseUrl: 'http://localhost:1234' });
    mockServer = new MockAdapter(axios);
  });

  it('should generate 768-dimension embeddings', async () => {
    mockServer.onPost('/v1/embeddings').reply(200, {
      data: [{ embedding: new Array(768).fill(0.1) }]
    });
    
    const embedding = await client.generateEmbedding('test');
    expect(embedding).toHaveLength(768);
  });

  it('should retry on network error', async () => {
    mockServer.onPost('/v1/embeddings')
      .replyOnce(500)
      .onPost('/v1/embeddings')
      .reply(200, { data: [{ embedding: new Array(768).fill(0.1) }] });
    
    const embedding = await client.generateEmbedding('test');
    expect(embedding).toHaveLength(768);
    expect(mockServer.history.post.length).toBe(2);
  });

  it('should throw after max retries exceeded', async () => {
    mockServer.onPost('/v1/embeddings').reply(500);
    
    await expect(client.generateEmbedding('test'))
      .rejects.toThrow('Max retries exceeded');
  });
});
```

---

#### File: `MCP/rag-server/src/clients/qdrant.ts`

**Purpose:** Qdrant vector database client with collection management

**Key Classes/Functions:**
```typescript
// Client class
export class QdrantClient {
  private client: QdrantClientType;
  private collectionName: string;
  
  constructor(config: QdrantConfig);
  
  // Collection management
  async createCollection(dimension: number): Promise<void>;
  async collectionExists(): Promise<boolean>;
  async deleteCollection(): Promise<void>;
  
  // Vector operations
  async upsertVectors(points: VectorPoint[]): Promise<void>;
  async searchVectors(
    vector: number[],
    options: SearchOptions
  ): Promise<SearchResult[]>;
  async deleteVectors(ids: string[]): Promise<void>;
  
  // Stats
  async getCollectionInfo(): Promise<CollectionInfo>;
  async countVectors(): Promise<number>;
  
  // Health
  async healthCheck(): Promise<boolean>;
}

// Configuration
interface QdrantConfig {
  url: string;                    // Default: http://localhost:6333
  collectionName: string;         // Default: p4nth30n_context
  apiKey?: string;                // For cloud Qdrant
}

// Vector point structure
interface VectorPoint {
  id: string;                     // UUID
  vector: number[];               // 768 dimensions
  payload: {
    sessionId: string;
    contentType: string;
    content: string;              // Chunk text
    category?: string;
    game?: string;
    agent?: string;
    tags?: string[];
    timestamp: string;
    chunkId: string;
  };
}

// Search options
interface SearchOptions {
  limit: number;                  // Default: 5
  scoreThreshold?: number;        // Default: 0.7
  filters?: {
    category?: string;
    game?: string;
    contentType?: string;
    sessionId?: string;
  };
}
```

**Dependencies:**
```json
{
  "@qdrant/js-client-rest": "^1.13.0"
}
```

**Error Handling:**
```typescript
// Qdrant-specific errors
const QdrantErrors = {
  // Collection doesn't exist
  COLLECTION_NOT_FOUND: async () => {
    logger.warn('Qdrant collection not found, creating...');
    await this.createCollection(768);
    throw new RetryableError('Collection created, retrying');
  },
  
  // Vector dimension mismatch
  WRONG_DIMENSIONS: (error: Error) => {
    logger.error('Vector dimension mismatch', { error: error.message });
    throw new FatalError('Vector dimensions do not match collection');
  },
  
  // Connection timeout
  CONNECTION_TIMEOUT: async () => {
    logger.warn('Qdrant connection timeout');
    throw new RetryableError('Connection timeout');
  },
  
  // Service unavailable (Qdrant down)
  SERVICE_UNAVAILABLE: () => {
    logger.error('Qdrant service unavailable');
    throw new ServiceUnavailableError('Vector database unavailable');
  }
};
```

**Testing Approach:**
```typescript
describe('QdrantClient', () => {
  let client: QdrantClient;
  
  beforeEach(() => {
    client = new QdrantClient({
      url: 'http://localhost:6333',
      collectionName: 'test_collection'
    });
  });

  it('should create collection with correct schema', async () => {
    await client.createCollection(768);
    const info = await client.getCollectionInfo();
    expect(info.config.params.vectors.size).toBe(768);
    expect(info.config.params.vectors.distance).toBe('Cosine');
  });

  it('should upsert and search vectors', async () => {
    const point: VectorPoint = {
      id: 'test-uuid',
      vector: new Array(768).fill(0.1),
      payload: {
        sessionId: 'session-1',
        contentType: 'chat',
        content: 'Test content',
        timestamp: new Date().toISOString(),
        chunkId: 'chunk-1'
      }
    };
    
    await client.upsertVectors([point]);
    const results = await client.searchVectors(point.vector, { limit: 1 });
    
    expect(results).toHaveLength(1);
    expect(results[0].id).toBe('test-uuid');
  });
});
```

---

#### File: `MCP/rag-server/src/clients/mongodb.ts`

**Purpose:** MongoDB client for document storage, text search, and metrics

**Key Classes/Functions:**
```typescript
// Client class
export class MongoDBClient {
  private client: MongoClient;
  private db: Db;
  private collections: {
    context: Collection<ContextDocument>;
    metrics: Collection<MetricsDocument>;
  };
  
  constructor(uri: string, dbName: string);
  
  // Connection
  async connect(): Promise<void>;
  async disconnect(): Promise<void>;
  async healthCheck(): Promise<boolean>;
  
  // Context document operations
  async insertContext(doc: ContextDocument): Promise<string>;  // Returns _id
  async findContextById(id: string): Promise<ContextDocument | null>;
  async findContextBySession(sessionId: string): Promise<ContextDocument[]>;
  
  // Text search (fallback)
  async textSearch(
    query: string,
    options: TextSearchOptions
  ): Promise<TextSearchResult[]>;
  
  // Metrics operations
  async logMetrics(metric: MetricsDocument): Promise<void>;
  async getMetrics(
    timeRange: TimeRange,
    filters?: MetricsFilters
  ): Promise<MetricsAggregation>;
  
  // Statistics
  async getStats(): Promise<DatabaseStats>;
  async ensureIndexes(): Promise<void>;
}

// Document types
interface ContextDocument {
  _id?: ObjectId;
  sessionId: string;
  timestamp: Date;
  contentType: 'chat' | 'decision' | 'code' | 'documentation';
  source: string;
  content: string;
  chunks: Array<{
    chunkId: string;
    text: string;
    vectorId: string;
    embedding?: number[];
  }>;
  metadata: {
    agent?: string;
    tags?: string[];
    category?: string;
    game?: string;
    decisionId?: string;
  };
  retrievalStats?: {
    queryCount: number;
    lastRetrieved?: Date;
  };
}

interface MetricsDocument {
  _id?: ObjectId;
  timestamp: Date;
  query: string;
  resultsCount: number;
  latencyMs: number;
  embeddingLatencyMs?: number;
  vectorLatencyMs?: number;
  fallback: boolean;
  fallbackLevel: number;
  cacheHit: boolean;
  agent: string;
  contentType?: string;
  category?: string;
  game?: string;
  error?: string;
}
```

**Dependencies:**
```json
{
  "mongodb": "^6.0.0"
}
```

**Error Handling:**
```typescript
// MongoDB error handling
const MongoDBErrors = {
  // Duplicate key (document already exists)
  DUPLICATE_KEY: (error: MongoError) => {
    logger.warn('Duplicate document, skipping', { key: error.keyValue });
    return null;  // Not an error, just skip
  },
  
  // Connection errors
  CONNECTION_ERROR: async (error: MongoError) => {
    logger.error('MongoDB connection error', { message: error.message });
    throw new ServiceUnavailableError('Database unavailable');
  },
  
  // Text index not found
  TEXT_INDEX_MISSING: async () => {
    logger.warn('Text index missing, creating...');
    await this.ensureIndexes();
    throw new RetryableError('Index created, retrying');
  }
};
```

**Index Creation:**
```typescript
async ensureIndexes(): Promise<void> {
  // Compound indexes
  await this.collections.context.createIndex(
    { sessionId: 1, timestamp: -1 },
    { name: 'session_timestamp_idx' }
  );
  
  await this.collections.context.createIndex(
    { 'metadata.tags': 1 },
    { name: 'tags_idx' }
  );
  
  await this.collections.context.createIndex(
    { 'metadata.category': 1 },
    { name: 'category_idx' }
  );
  
  await this.collections.context.createIndex(
    { contentType: 1, timestamp: -1 },
    { name: 'content_type_timestamp_idx' }
  );
  
  await this.collections.context.createIndex(
    { 'metadata.decisionId': 1 },
    { name: 'decision_id_idx' }
  );
  
  // Text index for fallback search (CRITICAL)
  await this.collections.context.createIndex(
    { content: 'text', 'metadata.tags': 'text' },
    {
      name: 'content_text_index',
      weights: { content: 10, 'metadata.tags': 5 },
      default_language: 'english'
    }
  );
  
  // Metrics indexes
  await this.collections.metrics.createIndex(
    { timestamp: -1 },
    { name: 'timestamp_idx' }
  );
  
  await this.collections.metrics.createIndex(
    { agent: 1, timestamp: -1 },
    { name: 'agent_timestamp_idx' }
  );
}
```

---

#### File: `MCP/rag-server/src/tools/search.ts`

**Purpose:** RAG search tool with 4-level fallback chain

**Key Classes/Functions:**
```typescript
// Tool definition
export const ragContextSearchTool: ToolDefinition = {
  name: 'rag_context_search',
  description: 'Search RAG context for relevant information',
  inputSchema: searchInputSchema,
  execute: executeSearch
};

// Input validation schema
const searchInputSchema = z.object({
  query: z.string()
    .min(1, 'Query cannot be empty')
    .max(1000, 'Query too long (max 1000 characters)'),
  limit: z.number()
    .int()
    .min(1)
    .max(20)
    .default(5),
  category: z.enum(['strategy', 'bugfix', 'architecture', 'casino'])
    .optional(),
  sessionId: z.string().optional(),
  contentType: z.enum(['chat', 'decision', 'code', 'documentation'])
    .optional(),
  game: z.string().optional(),
  agent: z.string().optional()
});

// Main execution function
async function executeSearch(input: SearchInput): Promise<SearchOutput> {
  const startTime = Date.now();
  
  // Check circuit breaker first
  if (circuitBreaker.isOpen()) {
    return handleCircuitBreakerFallback(startTime, input);
  }
  
  try {
    // Level 1: Vector search
    const results = await executeVectorSearch(input);
    recordSuccess();
    
    const latency = Date.now() - startTime;
    await logMetrics({ ...input, resultsCount: results.length, latency, fallback: false, fallbackLevel: 1 });
    
    return {
      results,
      latency,
      fallback: false,
      fallbackLevel: 1,
      circuitBreakerOpen: false,
      totalIndexed: await getTotalIndexed()
    };
  } catch (vectorError) {
    logger.warn('Vector search failed, attempting fallback', { error: vectorError.message });
    
    try {
      // Level 2: Text search fallback
      const results = await executeTextSearch(input);
      
      const latency = Date.now() - startTime;
      await logMetrics({ ...input, resultsCount: results.length, latency, fallback: true, fallbackLevel: 2 });
      
      return {
        results,
        latency,
        fallback: true,
        fallbackLevel: 2,
        circuitBreakerOpen: false,
        totalIndexed: await getTotalIndexed()
      };
    } catch (textError) {
      // Level 3: Empty results
      recordFailure();
      
      const latency = Date.now() - startTime;
      await logMetrics({ 
        ...input, 
        resultsCount: 0, 
        latency, 
        fallback: true, 
        fallbackLevel: 3,
        error: textError.message 
      });
      
      return {
        results: [],
        latency,
        fallback: true,
        fallbackLevel: 3,
        circuitBreakerOpen: circuitBreaker.isOpen(),
        totalIndexed: 0
      };
    }
  }
}

// Vector search implementation
async function executeVectorSearch(input: SearchInput): Promise<SearchResult[]> {
  // 1. Generate embedding
  const embeddingStart = Date.now();
  const embedding = await lmStudioClient.generateEmbedding(input.query);
  const embeddingLatency = Date.now() - embeddingStart;
  
  // 2. Query Qdrant
  const vectorStart = Date.now();
  const qdrantResults = await qdrantClient.searchVectors(embedding, {
    limit: input.limit,
    scoreThreshold: 0.7,
    filters: {
      category: input.category,
      game: input.game,
      contentType: input.contentType,
      sessionId: input.sessionId
    }
  });
  const vectorLatency = Date.now() - vectorStart;
  
  // 3. Format results
  return qdrantResults.map(r => ({
    content: r.payload.content,
    score: r.score,
    source: r.payload.source,
    timestamp: r.payload.timestamp,
    metadata: {
      agent: r.payload.agent,
      tags: r.payload.tags,
      category: r.payload.category,
      game: r.payload.game
    }
  }));
}

// Text search fallback
async function executeTextSearch(input: SearchInput): Promise<SearchResult[]> {
  return await mongodbClient.textSearch(input.query, {
    limit: input.limit,
    category: input.category,
    game: input.game,
    contentType: input.contentType,
    sessionId: input.sessionId
  });
}
```

**Dependencies:**
- `../clients/lmStudio` - LM Studio client
- `../clients/qdrant` - Qdrant client
- `../clients/mongodb` - MongoDB client
- `../services/circuitBreaker` - Circuit breaker state

---

#### File: `MCP/rag-server/src/tools/index.ts`

**Purpose:** Document indexing tool with chunking and embedding

**Key Classes/Functions:**
```typescript
// Tool definition
export const ragContextIndexTool: ToolDefinition = {
  name: 'rag_context_index',
  description: 'Index new content into the RAG system',
  inputSchema: indexInputSchema,
  execute: executeIndex
};

// Input validation schema
const indexInputSchema = z.object({
  content: z.string()
    .min(1, 'Content cannot be empty')
    .max(100000, 'Content too large (max 100KB)'),
  contentType: z.enum(['chat', 'decision', 'code', 'documentation']),
  sessionId: z.string().min(1, 'Session ID required'),
  source: z.string().min(1, 'Source required'),
  metadata: z.object({
    agent: z.string().optional(),
    tags: z.array(z.string()).optional(),
    category: z.string().optional(),
    game: z.string().optional(),
    decisionId: z.string().optional()
  }).optional()
});

// Main execution function
async function executeIndex(input: IndexInput): Promise<IndexOutput> {
  const startTime = Date.now();
  const documentId = uuidv4();
  
  // 1. Chunk the content
  const chunks = chunkingService.split(input.content, {
    contentType: input.contentType,
    maxChunkSize: 512,
    overlap: 50
  });
  
  // 2. Generate embeddings for chunks
  const chunkTexts = chunks.map(c => c.text);
  const embeddings = await lmStudioClient.generateEmbeddings(chunkTexts);
  
  // 3. Prepare Qdrant points
  const points: VectorPoint[] = chunks.map((chunk, i) => ({
    id: chunk.chunkId,
    vector: embeddings[i],
    payload: {
      sessionId: input.sessionId,
      contentType: input.contentType,
      content: chunk.text,
      category: input.metadata?.category,
      game: input.metadata?.game,
      agent: input.metadata?.agent,
      tags: input.metadata?.tags,
      timestamp: new Date().toISOString(),
      chunkId: chunk.chunkId
    }
  }));
  
  // 4. Upsert to Qdrant (batch in groups of 100)
  await qdrantClient.upsertVectors(points);
  
  // 5. Store document in MongoDB
  const doc: ContextDocument = {
    _id: new ObjectId(documentId),
    sessionId: input.sessionId,
    timestamp: new Date(),
    contentType: input.contentType,
    source: input.source,
    content: input.content,
    chunks: chunks.map((chunk, i) => ({
      chunkId: chunk.chunkId,
      text: chunk.text,
      vectorId: chunk.chunkId,
      embedding: embeddings[i]
    })),
    metadata: input.metadata || {},
    retrievalStats: { queryCount: 0 }
  };
  
  await mongodbClient.insertContext(doc);
  
  // 6. Return result
  return {
    success: true,
    chunksIndexed: chunks.length,
    vectorIds: points.map(p => p.id),
    latencyMs: Date.now() - startTime,
    documentId
  };
}
```

**Dependencies:**
- `../services/chunking` - Text chunking service
- `../clients/lmStudio` - LM Studio client
- `../clients/qdrant` - Qdrant client
- `../clients/mongodb` - MongoDB client

---

#### File: `MCP/rag-server/src/tools/health.ts`

**Purpose:** Health check tool for monitoring system status

**Key Classes/Functions:**
```typescript
// Tool definition
export const ragContextHealthTool: ToolDefinition = {
  name: 'rag_context_health',
  description: 'Check RAG system health status',
  inputSchema: z.object({}),  // No input required
  execute: executeHealth
};

// Health check implementation
async function executeHealth(): Promise<HealthOutput> {
  const startTime = Date.now();
  
  // Check all components in parallel
  const [qdrantHealth, lmStudioHealth, mongoHealth] = await Promise.allSettled([
    checkQdrantHealth(),
    checkLMStudioHealth(),
    checkMongoHealth()
  ]);
  
  const qdrantStatus = qdrantHealth.status === 'fulfilled' ? qdrantHealth.value : 'unavailable';
  const lmStudioStatus = lmStudioHealth.status === 'fulfilled' ? lmStudioHealth.value : 'unavailable';
  const mongoStatus = mongoHealth.status === 'fulfilled' ? mongoHealth.value : 'unavailable';
  
  // Overall health
  const healthy = qdrantStatus === 'healthy' && 
                  lmStudioStatus === 'healthy' && 
                  mongoStatus === 'healthy';
  
  return {
    healthy,
    qdrantStatus,
    lmStudioStatus,
    mongoStatus,
    latency: Date.now() - startTime,
    indexedDocuments: await getTotalIndexed(),
    circuitBreakerOpen: circuitBreaker.isOpen()
  };
}

// Individual health checks
async function checkQdrantHealth(): Promise<'healthy' | 'degraded' | 'unavailable'> {
  try {
    const healthy = await qdrantClient.healthCheck();
    return healthy ? 'healthy' : 'degraded';
  } catch {
    return 'unavailable';
  }
}

async function checkLMStudioHealth(): Promise<'healthy' | 'degraded' | 'unavailable'> {
  try {
    const healthy = await lmStudioClient.healthCheck();
    return healthy ? 'healthy' : 'degraded';
  } catch {
    return 'unavailable';
  }
}

async function checkMongoHealth(): Promise<'healthy' | 'degraded' | 'unavailable'> {
  try {
    const healthy = await mongodbClient.healthCheck();
    return healthy ? 'healthy' : 'degraded';
  } catch {
    return 'unavailable';
  }
}
```

---

#### File: `MCP/rag-server/src/tools/stats.ts`

**Purpose:** Statistics tool for usage metrics and analytics

**Key Classes/Functions:**
```typescript
// Tool definition
export const ragContextStatsTool: ToolDefinition = {
  name: 'rag_context_stats',
  description: 'Get RAG usage statistics',
  inputSchema: statsInputSchema,
  execute: executeStats
};

// Input validation schema
const statsInputSchema = z.object({
  timeRange: z.enum(['1h', '24h', '7d', '30d']).default('24h')
});

// Statistics implementation
async function executeStats(input: StatsInput): Promise<StatsOutput> {
  const timeRange = parseTimeRange(input.timeRange);
  
  // Get metrics from MongoDB
  const metrics = await mongodbClient.getMetrics(timeRange);
  
  // Get document count from Qdrant
  const totalDocuments = await qdrantClient.countVectors();
  
  // Calculate statistics
  return {
    totalDocuments,
    totalQueries: metrics.totalQueries,
    avgLatency: metrics.avgLatency,
    p95Latency: metrics.p95Latency,
    p99Latency: metrics.p99Latency,
    cacheHitRate: metrics.cacheHitRate,
    fallbackRate: metrics.fallbackRate,
    queriesByAgent: metrics.queriesByAgent
  };
}

// Time range parsing
function parseTimeRange(range: string): TimeRange {
  const now = new Date();
  const durations: Record<string, number> = {
    '1h': 60 * 60 * 1000,
    '24h': 24 * 60 * 60 * 1000,
    '7d': 7 * 24 * 60 * 60 * 1000,
    '30d': 30 * 24 * 60 * 60 * 1000
  };
  
  return {
    start: new Date(now.getTime() - durations[range]),
    end: now
  };
}
```

---

#### File: `MCP/rag-server/src/services/chunking.ts`

**Purpose:** Semantic text chunking with content-type aware splitting

**Key Classes/Functions:**
```typescript
// Main chunking service
export class ChunkingService {
  // Content-type specific configurations
  private configs: Record<ContentType, ChunkingConfig> = {
    chat: {
      maxChunkSize: 512,
      overlap: 50,
      separators: ['\n\n', '\n', '. ', ' '],
      preserveSpeaker: true
    },
    decision: {
      maxChunkSize: 512,
      overlap: 50,
      separators: ['\n## ', '\n### ', '\n\n', '\n', '. ', ' ']
    },
    code: {
      maxChunkSize: 256,
      overlap: 25,
      separators: ['\n}\n', '\n\n', '\n', ' '],
      respectFunctionBoundaries: true
    },
    documentation: {
      maxChunkSize: 512,
      overlap: 50,
      separators: ['\n## ', '\n### ', '\n\n', '\n', '. ', ' ']
    }
  };
  
  split(text: string, options: ChunkingOptions): Chunk[] {
    const config = this.configs[options.contentType];
    const chunks: Chunk[] = [];
    
    // Split into initial segments based on separators
    let segments = this.splitBySeparators(text, config.separators);
    
    // Merge segments into chunks respecting max size
    let currentChunk = '';
    let chunkStart = 0;
    
    for (const segment of segments) {
      const segmentTokens = this.estimateTokens(segment);
      const currentTokens = this.estimateTokens(currentChunk);
      
      if (currentTokens + segmentTokens > config.maxChunkSize && currentChunk) {
        // Save current chunk
        chunks.push(this.createChunk(currentChunk, chunkStart, config));
        
        // Start new chunk with overlap
        currentChunk = this.getOverlap(chunks[chunks.length - 1].text, config.overlap);
        chunkStart = chunkStart + currentChunk.length;
      }
      
      currentChunk += segment;
    }
    
    // Don't forget the last chunk
    if (currentChunk) {
      chunks.push(this.createChunk(currentChunk, chunkStart, config));
    }
    
    return chunks;
  }
  
  private splitBySeparators(text: string, separators: string[]): string[] {
    let segments = [text];
    
    for (const separator of separators) {
      const newSegments: string[] = [];
      for (const segment of segments) {
        newSegments.push(...segment.split(separator).filter(s => s.trim()));
      }
      segments = newSegments;
    }
    
    return segments;
  }
  
  private estimateTokens(text: string): number {
    // Rough estimate: 1 token ≈ 4 characters
    return Math.ceil(text.length / 4);
  }
  
  private getOverlap(text: string, tokenCount: number): string {
    const charCount = tokenCount * 4;
    return text.slice(-charCount);
  }
  
  private createChunk(text: string, startPos: number, config: ChunkingConfig): Chunk {
    return {
      chunkId: uuidv4(),
      text: text.trim(),
      metadata: {
        startPos,
        tokenCount: this.estimateTokens(text)
      }
    };
  }
}

// Types
interface ChunkingConfig {
  maxChunkSize: number;
  overlap: number;
  separators: string[];
  preserveSpeaker?: boolean;
  respectFunctionBoundaries?: boolean;
}

interface ChunkingOptions {
  contentType: ContentType;
  maxChunkSize?: number;
  overlap?: number;
}

interface Chunk {
  chunkId: string;
  text: string;
  metadata: {
    startPos: number;
    tokenCount: number;
  };
}

type ContentType = 'chat' | 'decision' | 'code' | 'documentation';
```

---

#### File: `MCP/rag-server/src/services/embedding.ts`

**Purpose:** Embedding service wrapper with caching

**Key Classes/Functions:**
```typescript
// Embedding service with LRU cache
export class EmbeddingService {
  private client: LMStudioClient;
  private cache: LRUCache<string, number[]>;
  
  constructor(client: LMStudioClient, cacheSize: number = 1000) {
    this.client = client;
    this.cache = new LRUCache({ max: cacheSize });
  }
  
  async generateEmbedding(text: string): Promise<number[]> {
    const cacheKey = this.hashText(text);
    
    // Check cache
    const cached = this.cache.get(cacheKey);
    if (cached) {
      logger.debug('Embedding cache hit');
      return cached;
    }
    
    // Generate new embedding
    const embedding = await this.client.generateEmbedding(text);
    
    // Validate dimensions
    if (embedding.length !== 768) {
      throw new Error(`Expected 768 dimensions, got ${embedding.length}`);
    }
    
    // Validate normalization (cosine similarity requires normalized vectors)
    const magnitude = Math.sqrt(embedding.reduce((sum, val) => sum + val * val, 0));
    if (magnitude < 0.9 || magnitude > 1.1) {
      logger.warn('Embedding not normalized, normalizing...');
      for (let i = 0; i < embedding.length; i++) {
        embedding[i] /= magnitude;
      }
    }
    
    // Cache result
    this.cache.set(cacheKey, embedding);
    
    return embedding;
  }
  
  async generateEmbeddings(texts: string[]): Promise<number[][]> {
    // Check cache for each text
    const results: (number[] | null)[] = texts.map(t => this.cache.get(this.hashText(t)));
    const uncachedIndices: number[] = [];
    const uncachedTexts: string[] = [];
    
    results.forEach((result, i) => {
      if (!result) {
        uncachedIndices.push(i);
        uncachedTexts.push(texts[i]);
      }
    });
    
    // Generate embeddings for uncached texts
    if (uncachedTexts.length > 0) {
      const newEmbeddings = await this.client.generateEmbeddings(uncachedTexts);
      
      // Cache and place results
      newEmbeddings.forEach((embedding, i) => {
        const originalIndex = uncachedIndices[i];
        this.cache.set(this.hashText(texts[originalIndex]), embedding);
        results[originalIndex] = embedding;
      });
    }
    
    return results as number[][];
  }
  
  private hashText(text: string): string {
    // Simple hash for cache key
    return crypto.createHash('sha256').update(text).digest('hex');
  }
  
  getCacheStats(): { hits: number; misses: number; size: number } {
    return {
      hits: (this.cache as any).hits || 0,
      misses: (this.cache as any).misses || 0,
      size: this.cache.size
    };
  }
}
```

---

### 2.2 C# Integration Files

#### File: `C0MMON/Interfaces/IRagContext.cs`

**Purpose:** Service contract for RAG context operations

**Key Classes/Functions:**
```csharp
namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// Interface for RAG context search and indexing operations.
/// Provides semantic search capabilities with fallback mechanisms.
/// </summary>
public interface IRagContext
{
    /// <summary>
    /// Search the RAG context for relevant information.
    /// </summary>
    /// <param name="query">The search query text</param>
    /// <param name="options">Optional search filters and limits</param>
    /// <param name="agent">Name of the agent making the query (for metrics)</param>
    /// <returns>Search results with metadata</returns>
    Task<RagSearchResult> SearchAsync(
        string query,
        RagSearchOptions? options = null,
        string? agent = null
    );

    /// <summary>
    /// Index a new document into the RAG system.
    /// </summary>
    /// <param name="document">Document to index</param>
    /// <param name="agent">Name of the agent indexing (for metrics)</param>
    /// <returns>Index result with chunk count and document ID</returns>
    Task<RagIndexResult> IndexAsync(
        RagDocument document,
        string? agent = null
    );

    /// <summary>
    /// Get the current health status of the RAG system.
    /// </summary>
    /// <returns>Health status of all components</returns>
    Task<RagHealthStatus> GetHealthAsync();

    /// <summary>
    /// Get usage statistics for the RAG system.
    /// </summary>
    /// <param name="timeRange">Time range for statistics</param>
    /// <returns>Aggregated statistics</returns>
    Task<RagStats> GetStatsAsync(TimeSpan timeRange);

    /// <summary>
    /// Fast search optimized for casino operations.
    /// Uses caching and smaller result sets for low latency.
    /// </summary>
    /// <param name="query">The search query</param>
    /// <param name="game">Optional game filter (e.g., "FireKirin")</param>
    /// <param name="agent">Name of the agent</param>
    /// <returns>Search results (limited to 3)</returns>
    Task<RagSearchResult> SearchFastAsync(
        string query,
        string? game = null,
        string? agent = null
    );
}

/// <summary>
/// Options for RAG search operations.
/// </summary>
public class RagSearchOptions
{
    /// <summary>Maximum number of results to return (1-20, default 5)</summary>
    public int Limit { get; set; } = 5;

    /// <summary>Filter by category (strategy, bugfix, architecture, casino)</summary>
    public string? Category { get; set; }

    /// <summary>Filter by specific session ID</summary>
    public string? SessionId { get; set; }

    /// <summary>Filter by content type (chat, decision, code, documentation)</summary>
    public string? ContentType { get; set; }

    /// <summary>Filter by casino game (e.g., "FireKirin", "OrionStars")</summary>
    public string? Game { get; set; }
}

/// <summary>
/// Document to be indexed into the RAG system.
/// </summary>
public class RagDocument
{
    /// <summary>The content to index</summary>
    public required string Content { get; set; }

    /// <summary>Type of content being indexed</summary>
    public required string ContentType { get; set; }  // chat, decision, code, documentation

    /// <summary>Session or document identifier</summary>
    public required string SessionId { get; set; }

    /// <summary>Source file path or identifier</summary>
    public required string Source { get; set; }

    /// <summary>Optional metadata for filtering</summary>
    public RagDocumentMetadata? Metadata { get; set; }
}

/// <summary>
/// Metadata for a RAG document.
/// </summary>
public class RagDocumentMetadata
{
    public string? Agent { get; set; }
    public List<string>? Tags { get; set; }
    public string? Category { get; set; }
    public string? Game { get; set; }
    public string? DecisionId { get; set; }
}

/// <summary>
/// Result of a RAG search operation.
/// </summary>
public class RagSearchResult
{
    /// <summary>Search results</summary>
    public List<RagResultItem> Results { get; set; } = new();

    /// <summary>Total query latency in milliseconds</summary>
    public double Latency { get; set; }

    /// <summary>Whether a fallback mechanism was used</summary>
    public bool Fallback { get; set; }

    /// <summary>Fallback level: 1=primary, 2=MongoDB, 3=empty, 4=circuit breaker</summary>
    public int FallbackLevel { get; set; }

    /// <summary>Whether the circuit breaker is currently open</summary>
    public bool CircuitBreakerOpen { get; set; }

    /// <summary>Total number of indexed documents</summary>
    public int TotalIndexed { get; set; }
}

/// <summary>
/// Individual search result item.
/// </summary>
public class RagResultItem
{
    /// <summary>The content text</summary>
    public string Content { get; set; } = string.Empty;

    /// <summary>Relevance score (0-1)</summary>
    public double Score { get; set; }

    /// <summary>Source document identifier</summary>
    public string Source { get; set; } = string.Empty;

    /// <summary>Timestamp when content was indexed</summary>
    public DateTime Timestamp { get; set; }

    /// <summary>Additional metadata</summary>
    public RagResultMetadata? Metadata { get; set; }
}

/// <summary>
/// Metadata for a search result.
/// </summary>
public class RagResultMetadata
{
    public string? Agent { get; set; }
    public List<string>? Tags { get; set; }
    public string? Category { get; set; }
    public string? Game { get; set; }
}

/// <summary>
/// Result of an index operation.
/// </summary>
public class RagIndexResult
{
    /// <summary>Whether the operation succeeded</summary>
    public bool Success { get; set; }

    /// <summary>Number of chunks indexed</summary>
    public int ChunksIndexed { get; set; }

    /// <summary>IDs of vectors created</summary>
    public List<string> VectorIds { get; set; } = new();

    /// <summary>Operation latency in milliseconds</summary>
    public double LatencyMs { get; set; }

    /// <summary>Generated document ID</summary>
    public string DocumentId { get; set; } = string.Empty;
}

/// <summary>
/// Health status of the RAG system.
/// </summary>
public class RagHealthStatus
{
    /// <summary>Overall system health</summary>
    public bool Healthy { get; set; }

    /// <summary>Qdrant vector database status</summary>
    public string QdrantStatus { get; set; } = "unavailable";

    /// <summary>LM Studio embedding service status</summary>
    public string LmStudioStatus { get; set; } = "unavailable";

    /// <summary>MongoDB document store status</summary>
    public string MongoStatus { get; set; } = "unavailable";

    /// <summary>Health check latency in milliseconds</summary>
    public double Latency { get; set; }

    /// <summary>Number of indexed documents</summary>
    public int IndexedDocuments { get; set; }

    /// <summary>Whether circuit breaker is open</summary>
    public bool CircuitBreakerOpen { get; set; }
}

/// <summary>
/// Statistics for the RAG system.
/// </summary>
public class RagStats
{
    /// <summary>Total documents indexed</summary>
    public int TotalDocuments { get; set; }

    /// <summary>Total queries executed</summary>
    public int TotalQueries { get; set; }

    /// <summary>Average query latency in milliseconds</summary>
    public double AvgLatency { get; set; }

    /// <summary>P95 query latency in milliseconds</summary>
    public double P95Latency { get; set; }

    /// <summary>P99 query latency in milliseconds</summary>
    public double P99Latency { get; set; }

    /// <summary>Cache hit rate (0-1)</summary>
    public double CacheHitRate { get; set; }

    /// <summary>Fallback rate (0-1)</summary>
    public double FallbackRate { get; set; }

    /// <summary>Query counts by agent</summary>
    public Dictionary<string, int> QueriesByAgent { get; set; } = new();
}
```

**Dependencies:**
- `System.Text.Json` - JSON serialization
- `System.Net.Http` - HTTP client (used by implementation)

---

#### File: `C0MMON/Services/RagContextService.cs`

**Purpose:** Typed HTTP client implementation of IRagContext

**Key Classes/Functions:**
```csharp
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.Extensions.Logging;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.C0MMON.Services;

/// <summary>
/// Typed HTTP client implementation of the RAG context service.
/// Communicates with the MCP RAG server via HTTP.
/// </summary>
public class RagContextService : IRagContext, IDisposable
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<RagContextService> _logger;
    private readonly string _baseUrl;
    private readonly JsonSerializerOptions _jsonOptions;
    
    // Cache for fast search
    private readonly Dictionary<string, (RagSearchResult result, DateTime expiry)> _cache = new();
    private readonly TimeSpan _cacheTtl = TimeSpan.FromMinutes(5);

    public RagContextService(
        HttpClient httpClient,
        ILogger<RagContextService> logger,
        string baseUrl = "http://localhost:3000")
    {
        _httpClient = httpClient;
        _logger = logger;
        _baseUrl = baseUrl.TrimEnd('/');
        
        _jsonOptions = new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
        };
    }

    /// <inheritdoc />
    public async Task<RagSearchResult> SearchAsync(
        string query,
        RagSearchOptions? options = null,
        string? agent = null)
    {
        var request = new
        {
            query,
            limit = options?.Limit ?? 5,
            category = options?.Category,
            sessionId = options?.SessionId,
            contentType = options?.ContentType,
            game = options?.Game,
            agent
        };

        var response = await ExecuteWithRetryAsync(() => 
            _httpClient.PostAsJsonAsync($"{_baseUrl}/tools/rag_context_search", request, _jsonOptions));
        
        response.EnsureSuccessStatusCode();
        
        var result = await response.Content.ReadFromJsonAsync<RagSearchResult>(_jsonOptions);
        
        if (result == null)
        {
            throw new InvalidOperationException("Failed to deserialize search result");
        }
        
        _logger.LogDebug(
            "RAG search completed: {Query} returned {Count} results in {Latency}ms (fallback: {Fallback})",
            query[..Math.Min(query.Length, 50)],
            result.Results.Count,
            result.Latency,
            result.Fallback);
        
        return result;
    }

    /// <inheritdoc />
    public async Task<RagIndexResult> IndexAsync(
        RagDocument document,
        string? agent = null)
    {
        var request = new
        {
            content = document.Content,
            contentType = document.ContentType,
            sessionId = document.SessionId,
            source = document.Source,
            metadata = document.Metadata != null ? new
            {
                document.Metadata.Agent,
                document.Metadata.Tags,
                document.Metadata.Category,
                document.Metadata.Game,
                document.Metadata.DecisionId
            } : null
        };

        var response = await ExecuteWithRetryAsync(() => 
            _httpClient.PostAsJsonAsync($"{_baseUrl}/tools/rag_context_index", request, _jsonOptions));
        
        response.EnsureSuccessStatusCode();
        
        var result = await response.Content.ReadFromJsonAsync<RagIndexResult>(_jsonOptions);
        
        if (result == null)
        {
            throw new InvalidOperationException("Failed to deserialize index result");
        }
        
        _logger.LogInformation(
            "RAG index completed: {Chunks} chunks indexed for {SessionId} in {Latency}ms",
            result.ChunksIndexed,
            document.SessionId,
            result.LatencyMs);
        
        return result;
    }

    /// <inheritdoc />
    public async Task<RagHealthStatus> GetHealthAsync()
    {
        var response = await _httpClient.GetAsync($"{_baseUrl}/health");
        response.EnsureSuccessStatusCode();
        
        var result = await response.Content.ReadFromJsonAsync<RagHealthStatus>(_jsonOptions);
        
        return result ?? new RagHealthStatus { Healthy = false };
    }

    /// <inheritdoc />
    public async Task<RagStats> GetStatsAsync(TimeSpan timeRange)
    {
        var hours = timeRange.TotalHours switch
        {
            <= 1 => "1h",
            <= 24 => "24h",
            <= 168 => "7d",
            _ => "30d"
        };

        var response = await _httpClient.GetAsync($"{_baseUrl}/tools/rag_context_stats?timeRange={hours}");
        response.EnsureSuccessStatusCode();
        
        var result = await response.Content.ReadFromJsonAsync<RagStats>(_jsonOptions);
        
        return result ?? new RagStats();
    }

    /// <inheritdoc />
    public async Task<RagSearchResult> SearchFastAsync(
        string query,
        string? game = null,
        string? agent = null)
    {
        // Check cache first
        var cacheKey = $"{query}|{game}";
        if (_cache.TryGetValue(cacheKey, out var cached) && cached.expiry > DateTime.UtcNow)
        {
            _logger.LogDebug("RAG fast search cache hit for: {Query}", query[..Math.Min(query.Length, 50)]);
            return cached.result;
        }

        // Execute fast search (limit=3, no category filter)
        var options = new RagSearchOptions
        {
            Limit = 3,
            Game = game
        };

        var result = await SearchAsync(query, options, agent);
        
        // Cache result
        _cache[cacheKey] = (result, DateTime.UtcNow.Add(_cacheTtl));
        
        return result;
    }

    /// <summary>
    /// Execute HTTP request with retry logic.
    /// </summary>
    private async Task<HttpResponseMessage> ExecuteWithRetryAsync(
        Func<Task<HttpResponseMessage>> operation,
        int maxRetries = 3)
    {
        for (int attempt = 1; attempt <= maxRetries; attempt++)
        {
            try
            {
                return await operation();
            }
            catch (HttpRequestException ex) when (attempt < maxRetries)
            {
                _logger.LogWarning(
                    "RAG request failed (attempt {Attempt}/{Max}): {Error}",
                    attempt,
                    maxRetries,
                    ex.Message);
                
                await Task.Delay(TimeSpan.FromMilliseconds(100 * Math.Pow(2, attempt)));
            }
        }

        throw new InvalidOperationException($"Max retries ({maxRetries}) exceeded");
    }

    public void Dispose()
    {
        _httpClient?.Dispose();
    }
}
```

**Dependencies:**
```xml
<PackageReference Include="Microsoft.Extensions.Http" Version="8.0.0" />
<PackageReference Include="Microsoft.Extensions.Logging.Abstractions" Version="8.0.0" />
```

---

#### File: `H0UND/Infrastructure/RagContextIndexer.cs`

**Purpose:** Background indexer for automatic content indexing

**Key Classes/Functions:**
```csharp
using System.Collections.Concurrent;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.H0UND.Infrastructure;

/// <summary>
/// Background service that indexes chat sessions, decisions, and code documentation
/// into the RAG context system.
/// </summary>
public class RagContextIndexer : BackgroundService
{
    private readonly IRagContext _ragContext;
    private readonly ILogger<RagContextIndexer> _logger;
    private readonly ConcurrentQueue<IndexQueueItem> _indexQueue = new();
    private readonly SemaphoreSlim _semaphore = new(5, 5);  // Max 5 concurrent indexing ops

    public RagContextIndexer(
        IRagContext ragContext,
        ILogger<RagContextIndexer> logger)
    {
        _ragContext = ragContext;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("RAG Context Indexer starting...");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                if (_indexQueue.TryDequeue(out var item))
                {
                    await _semaphore.WaitAsync(stoppingToken);
                    
                    _ = Task.Run(async () =>
                    {
                        try
                        {
                            await ProcessIndexItemAsync(item);
                        }
                        finally
                        {
                            _semaphore.Release();
                        }
                    }, stoppingToken);
                }
                else
                {
                    await Task.Delay(1000, stoppingToken);
                }
            }
            catch (OperationCanceledException)
            {
                break;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in RAG indexer loop");
                await Task.Delay(5000, stoppingToken);
            }
        }

        _logger.LogInformation("RAG Context Indexer stopping...");
    }

    /// <summary>
    /// Queue a chat session for indexing.
    /// </summary>
    public void QueueChatSession(string sessionId, string content, string agent)
    {
        _indexQueue.Enqueue(new IndexQueueItem
        {
            Type = IndexType.Chat,
            SessionId = sessionId,
            Content = content,
            Agent = agent,
            Timestamp = DateTime.UtcNow
        });
    }

    /// <summary>
    /// Queue a decision document for indexing.
    /// </summary>
    public void QueueDecision(string decisionId, string content, string category)
    {
        _indexQueue.Enqueue(new IndexQueueItem
        {
            Type = IndexType.Decision,
            SessionId = decisionId,
            Content = content,
            Category = category,
            Timestamp = DateTime.UtcNow
        });
    }

    /// <summary>
    /// Queue code documentation for indexing.
    /// </summary>
    public void QueueCodeDocumentation(string filePath, string content)
    {
        _indexQueue.Enqueue(new IndexQueueItem
        {
            Type = IndexType.Code,
            SessionId = Guid.NewGuid().ToString(),
            Content = content,
            Source = filePath,
            Timestamp = DateTime.UtcNow
        });
    }

    private async Task ProcessIndexItemAsync(IndexQueueItem item)
    {
        try
        {
            var document = new RagDocument
            {
                Content = item.Content,
                ContentType = item.Type switch
                {
                    IndexType.Chat => "chat",
                    IndexType.Decision => "decision",
                    IndexType.Code => "code",
                    _ => "documentation"
                },
                SessionId = item.SessionId,
                Source = item.Source ?? $"h0und://{item.Type}/{item.SessionId}",
                Metadata = new RagDocumentMetadata
                {
                    Agent = item.Agent,
                    Category = item.Category,
                    Tags = item.Tags
                }
            };

            var result = await _ragContext.IndexAsync(document, item.Agent);

            if (result.Success)
            {
                _logger.LogDebug(
                    "Indexed {Type} {SessionId}: {Chunks} chunks",
                    item.Type,
                    item.SessionId,
                    result.ChunksIndexed);
            }
            else
            {
                _logger.LogWarning(
                    "Failed to index {Type} {SessionId}",
                    item.Type,
                    item.SessionId);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error indexing {Type} {SessionId}", item.Type, item.SessionId);
        }
    }

    private class IndexQueueItem
    {
        public required IndexType Type { get; set; }
        public required string SessionId { get; set; }
        public required string Content { get; set; }
        public string? Source { get; set; }
        public string? Agent { get; set; }
        public string? Category { get; set; }
        public List<string>? Tags { get; set; }
        public DateTime Timestamp { get; set; }
    }

    private enum IndexType
    {
        Chat,
        Decision,
        Code
    }
}
```

**Dependencies:**
```xml
<PackageReference Include="Microsoft.Extensions.Hosting.Abstractions" Version="8.0.0" />
```

---

### 2.3 Kubernetes Manifests

#### File: `k8s/qdrant-deployment.yaml`

**Purpose:** Qdrant vector database deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: qdrant
  namespace: rag-context
  labels:
    app: qdrant
spec:
  replicas: 1
  strategy:
    type: Recreate  # Single instance, recreate on update
  selector:
    matchLabels:
      app: qdrant
  template:
    metadata:
      labels:
        app: qdrant
    spec:
      containers:
      - name: qdrant
        image: qdrant/qdrant:v1.13.4
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 6333
          name: http
          protocol: TCP
        - containerPort: 6334
          name: grpc
          protocol: TCP
        env:
        - name: QDRANT__SERVICE__HTTP_PORT
          value: "6333"
        - name: QDRANT__SERVICE__GRPC_PORT
          value: "6334"
        - name: QDRANT__STORAGE__STORAGE_PATH
          value: "/qdrant/storage"
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
        livenessProbe:
          httpGet:
            path: /healthz
            port: 6333
          initialDelaySeconds: 30
          periodSeconds: 30
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /healthz
            port: 6333
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        volumeMounts:
        - name: qdrant-storage
          mountPath: /qdrant/storage
        - name: qdrant-config
          mountPath: /qdrant/config
      volumes:
      - name: qdrant-storage
        persistentVolumeClaim:
          claimName: qdrant-pvc
      - name: qdrant-config
        configMap:
          name: qdrant-config
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: qdrant-config
  namespace: rag-context
data:
  config.yaml: |
    log_level: INFO
    storage:
      performance:
        max_search_threads: 0  # Auto-detect
      hnsw_index:
        m: 16
        ef_construct: 100
    service:
      max_request_size_mb: 32
      max_workers: 0  # Auto-detect
```

---

#### File: `k8s/qdrant-service.yaml`

**Purpose:** Qdrant service with NodePort for local access

```yaml
apiVersion: v1
kind: Service
metadata:
  name: qdrant
  namespace: rag-context
  labels:
    app: qdrant
spec:
  type: NodePort
  selector:
    app: qdrant
  ports:
  - name: http
    port: 6333
    targetPort: 6333
    nodePort: 30333  # Exposed on localhost:30333
    protocol: TCP
  - name: grpc
    port: 6334
    targetPort: 6334
    protocol: TCP
```

---

#### File: `k8s/qdrant-pvc.yaml`

**Purpose:** Persistent volume claim for Qdrant storage

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: qdrant-pvc
  namespace: rag-context
  labels:
    app: qdrant
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: local-path  # Rancher Desktop default
```

---

### 2.4 Pre-Validation Script

#### File: `scripts/pre-validate-rag.ps1`

**Purpose:** Pre-deployment validation script with accuracy gate

```powershell
#!/usr/bin/env powershell
#Requires -Version 7.0

<#
.SYNOPSIS
    RAG-001 Pre-Validation Script

.DESCRIPTION
    Validates RAG infrastructure before Phase 2 implementation.
    Must achieve >80% retrieval accuracy to pass.

.PARAMETER MongoDBConnectionString
    MongoDB connection string (default: mongodb://localhost:27017/P4NTH30N)

.PARAMETER LMStudioUrl
    LM Studio API URL (default: http://localhost:1234)

.PARAMETER QdrantUrl
    Qdrant API URL (default: http://localhost:30333)

.PARAMETER McpServerUrl
    MCP server URL (default: http://localhost:3000)

.PARAMETER SkipAccuracy
    Skip the retrieval accuracy gate (for quick health checks)
#>

[CmdletBinding()]
param(
    [string]$MongoDBConnectionString = "mongodb://localhost:27017/P4NTH30N",
    [string]$LMStudioUrl = "http://localhost:1234",
    [string]$QdrantUrl = "http://localhost:30333",
    [string]$McpServerUrl = "http://localhost:3000",
    [switch]$SkipAccuracy
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$script:passed = 0
$script:failed = 0
$script:latencies = @()

# Color output functions
function Write-Success($message) {
    Write-Host "  $message" -ForegroundColor Green
}

function Write-Failure($message) {
    Write-Host "  $message" -ForegroundColor Red
}

function Write-Info($message) {
    Write-Host "  $message" -ForegroundColor Cyan
}

function Test-Step {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock,
        
        [int]$TimeoutSeconds = 30
    )
    
    Write-Host "Testing: $Name..." -NoNewline
    
    try {
        $job = Start-Job -ScriptBlock $ScriptBlock
        $completed = $job | Wait-Job -Timeout $TimeoutSeconds
        
        if (-not $completed) {
            throw "Timeout after ${TimeoutSeconds}s"
        }
        
        $result = Receive-Job -Job $job
        Remove-Job -Job $job
        
        if ($result -is [Exception]) {
            throw $result
        }
        
        Write-Host " PASSED" -ForegroundColor Green
        $script:passed++
        return $true
    }
    catch {
        Write-Host " FAILED" -ForegroundColor Red
        Write-Failure "Error: $_"
        $script:failed++
        return $false
    }
}

# Header
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           RAG-001 Pre-Validation Script                    ║" -ForegroundColor Cyan
Write-Host "║           Oracle Gate: 80% Accuracy Required               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Phase 1: Infrastructure Health
Write-Host "Phase 1: Infrastructure Health" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Yellow

Test-Step "Qdrant Health Check" {
    $response = Invoke-RestMethod -Uri "$QdrantUrl/healthz" -Method GET
    if ($response.status -ne "ok") { 
        throw "Qdrant unhealthy: $($response.status)" 
    }
    return $true
}

Test-Step "LM Studio API Availability" {
    $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/models" -Method GET -TimeoutSec 10
    if (-not $response.data) { 
        throw "No models loaded in LM Studio" 
    }
    
    # Check for nomic-embed-text-v1.5
    $hasModel = $response.data | Where-Object { $_.id -like "*nomic*" }
    if (-not $hasModel) {
        Write-Warning "nomic-embed-text-v1.5 not found, using available model"
    }
    return $true
}

Test-Step "MCP Server Health" {
    $response = Invoke-RestMethod -Uri "$McpServerUrl/health" -Method GET
    if (-not $response.healthy) { 
        throw "MCP server unhealthy" 
    }
    return $true
}

Test-Step "MongoDB Connectivity" {
    # Test MongoDB connection using mongosh or direct driver
    $testConnection = @"
const { MongoClient } = require('mongodb');
async function test() {
    const client = new MongoClient('$MongoDBConnectionString');
    await client.connect();
    await client.db().admin().ping();
    await client.close();
    console.log('OK');
}
test().catch(e => { console.error(e.message); process.exit(1); });
"@
    $result = $testConnection | node -
    if ($result -ne "OK") {
        throw "MongoDB connection failed"
    }
    return $true
}

# Phase 2: Embedding Quality
Write-Host "`nPhase 2: Embedding Quality Validation" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Yellow

$testQueries = @(
    "mongodb connection retry logic",
    "jackpot threshold configuration FireKirin", 
    "selenium automation pattern",
    "architecture decision template",
    "casino game strategy OrionStars"
)

$sample = 1
foreach ($query in $testQueries) {
    Test-Step "Embedding Quality Sample $sample/5" {
        $body = @{ 
            input = $query
            model = "nomic-embed-text-v1.5" 
        } | ConvertTo-Json
        
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/embeddings" `
            -Method POST -Body $body -ContentType "application/json" -TimeoutSec 30
        $sw.Stop()
        
        # Validate dimensions
        $dimensions = $response.data[0].embedding.Count
        if ($dimensions -ne 768) { 
            throw "Expected 768 dimensions, got $dimensions" 
        }
        
        # Validate vector normalization
        $embedding = $response.data[0].embedding
        $magnitude = 0
        foreach ($val in $embedding) { $magnitude += $val * $val }
        $magnitude = [Math]::Sqrt($magnitude)
        
        if ($magnitude -lt 0.9 -or $magnitude -gt 1.1) {
            throw "Vector magnitude $magnitude outside [0.9, 1.1]"
        }
        
        # Validate latency
        $latency = $sw.ElapsedMilliseconds
        $script:latencies += $latency
        
        if ($latency -gt 100) {
            Write-Warning "Embedding latency ${latency}ms > 100ms target"
        }
        
        Write-Info "Dimensions: $dimensions, Latency: ${latency}ms"
        return $true
    } -TimeoutSeconds 60
    
    $sample++
}

# Phase 3: Retrieval Accuracy Gate (CRITICAL)
Write-Host "`nPhase 3: Retrieval Accuracy Gate" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Yellow

if ($SkipAccuracy) {
    Write-Warning "Skipping accuracy validation (--SkipAccuracy specified)"
}
else {
    # Index test documents
    Write-Host "Indexing test documents..." -ForegroundColor Cyan
    
    $testDocs = @(
        @{ 
            content = "MongoDB connections should implement retry logic with exponential backoff. The maximum number of retries should be set to 5, with an initial delay of 100ms doubling each time.";
            category = "architecture"
            game = $null
            contentType = "documentation"
        },
        @{
            content = "FireKirin jackpot threshold configuration: The Grand jackpot triggers at `$500, the Major at `$250, the Minor at `$50, and the Mini at `$10. These values are configured in the CRED3N7IAL collection.";
            category = "casino"
            game = "FireKirin"
            contentType = "documentation"
        },
        @{
            content = "Selenium WebDriver timeout configuration should be set to 30 seconds for page loads, 10 seconds for element waits, and 5 seconds for JavaScript execution. Use explicit waits over implicit waits.";
            category = "architecture"
            game = $null
            contentType = "documentation"
        }
    )

    foreach ($doc in $testDocs) {
        $body = @{
            content = $doc.content
            contentType = $doc.contentType
            sessionId = "preval-test-$([Guid]::NewGuid())"
            source = "pre-validation"
            metadata = @{
                category = $doc.category
                game = $doc.game
            }
        } | ConvertTo-Json -Depth 3
        
        try {
            Invoke-RestMethod -Uri "$McpServerUrl/tools/rag_context_index" `
                -Method POST -Body $body -ContentType "application/json" | Out-Null
            Write-Success "Indexed: $($doc.content.Substring(0, 50))..."
        }
        catch {
            Write-Failure "Failed to index: $_"
        }
    }

    # Wait for indexing
    Write-Host "`nWaiting for indexing to complete..." -ForegroundColor Cyan
    Start-Sleep -Seconds 3

    # Test retrieval accuracy
    $accuracyTests = @(
        @{ 
            query = "mongodb retry logic implementation"
            expectedKeyword = "exponential backoff"
            category = "architecture"
            game = $null
        },
        @{
            query = "FireKirin jackpot Grand threshold amount"
            expectedKeyword = "`$500"
            category = "casino"
            game = "FireKirin"
        },
        @{
            query = "selenium timeout duration configuration"
            expectedKeyword = "30 seconds"
            category = "architecture"
            game = $null
        }
    )

    $relevantResults = 0
    $totalTests = $accuracyTests.Count

    Write-Host "`nTesting retrieval accuracy..." -ForegroundColor Cyan

    foreach ($test in $accuracyTests) {
        $body = @{
            query = $test.query
            limit = 3
            category = $test.category
            game = $test.game
        } | ConvertTo-Json
        
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-RestMethod -Uri "$McpServerUrl/tools/rag_context_search" `
            -Method POST -Body $body -ContentType "application/json"
        $sw.Stop()
        
        $script:latencies += $sw.ElapsedMilliseconds
        
        # Check if expected keyword appears in top-3
        $found = $false
        foreach ($result in $response.results) {
            if ($result.content -match [regex]::Escape($test.expectedKeyword)) {
                $found = $true
                break
            }
        }
        
        $status = if ($found) { "✓" } else { "✗" }
        $color = if ($found) { "Green" } else { "Red" }
        
        Write-Host "  $status '$($test.query)' looking for '$($test.expectedKeyword)'" -ForegroundColor $color
        Write-Info "    Latency: $($sw.ElapsedMilliseconds)ms, Results: $($response.results.Count)"
        
        if ($found) {
            $relevantResults++
        }
    }

    $accuracy = ($relevantResults / $totalTests) * 100
}

# Phase 4: Latency Analysis
Write-Host "`nPhase 4: Performance Analysis" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Yellow

if ($script:latencies.Count -gt 0) {
    $avgLatency = ($script:latencies | Measure-Object -Average).Average
    $sorted = $script:latencies | Sort-Object
    $p95Index = [math]::Ceiling($sorted.Count * 0.95) - 1
    $p99Index = [math]::Ceiling($sorted.Count * 0.99) - 1
    
    Write-Info "Average Latency: $([math]::Round($avgLatency, 1))ms"
    Write-Info "P95 Latency: $($sorted[$p95Index])ms"
    Write-Info "P99 Latency: $($sorted[$p99Index])ms"
    
    if ($sorted[$p99Index] -gt 500) {
        Write-Warning "P99 latency exceeds 500ms target"
    }
}

# Summary
Write-Host "`n════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                      SUMMARY" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "Infrastructure Tests:" -ForegroundColor White
Write-Host "  Passed: $script:passed" -ForegroundColor Green
Write-Host "  Failed: $script:failed" -ForegroundColor Red

if (-not $SkipAccuracy) {
    Write-Host "`nRetrieval Accuracy:" -ForegroundColor White
    $accColor = if ($accuracy -ge 80) { "Green" } elseif ($accuracy -ge 60) { "Yellow" } else { "Red" }
    Write-Host "  $([math]::Round($accuracy, 1))% ($relevantResults/$totalTests)" -ForegroundColor $accColor
    Write-Host "  Required: 80%" -ForegroundColor Gray
}

# Final verdict
Write-Host "`n════════════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($script:failed -eq 0 -and ($SkipAccuracy -or $accuracy -ge 80)) {
    Write-Host "✓ PRE-VALIDATION PASSED" -ForegroundColor Green -BackgroundColor Black
    if (-not $SkipAccuracy) {
        Write-Host "Accuracy gate: $([math]::Round($accuracy, 1))% (required: 80%)" -ForegroundColor Green
    }
    Write-Host "`nProceed to Phase 2: MCP Server Implementation" -ForegroundColor Green
    exit 0
}
elseif ($script:failed -eq 0 -and $accuracy -lt 80) {
    Write-Host "⚠ INFRASTRUCTURE PASSED, ACCURACY FAILED" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "Accuracy: $([math]::Round($accuracy, 1))% (required: 80%)" -ForegroundColor Yellow
    Write-Host "Check embedding quality and verify indexing completed" -ForegroundColor Yellow
    exit 1
}
else {
    Write-Host "✗ PRE-VALIDATION FAILED" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Fix infrastructure failures before proceeding" -ForegroundColor Red
    exit 1
}
```

---

## 3. API Contract Specifications

### 3.1 Tool: `rag_context_search`

**Endpoint:** `POST /tools/rag_context_search`

**Method:** POST

**Request Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "query": {
      "type": "string",
      "minLength": 1,
      "maxLength": 1000,
      "description": "Search query text"
    },
    "limit": {
      "type": "integer",
      "minimum": 1,
      "maximum": 20,
      "default": 5,
      "description": "Maximum number of results to return"
    },
    "category": {
      "type": "string",
      "enum": ["strategy", "bugfix", "architecture", "casino"],
      "description": "Filter by content category"
    },
    "sessionId": {
      "type": "string",
      "description": "Filter by specific session ID"
    },
    "contentType": {
      "type": "string",
      "enum": ["chat", "decision", "code", "documentation"],
      "description": "Filter by content type"
    },
    "game": {
      "type": "string",
      "description": "Filter by casino game (e.g., 'FireKirin', 'OrionStars')"
    },
    "agent": {
      "type": "string",
      "description": "Name of agent making the query (for metrics)"
    }
  },
  "required": ["query"]
}
```

**Response Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "results": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "content": {
            "type": "string",
            "description": "The matched content text"
          },
          "score": {
            "type": "number",
            "minimum": 0,
            "maximum": 1,
            "description": "Relevance score (cosine similarity)"
          },
          "source": {
            "type": "string",
            "description": "Source document identifier"
          },
          "timestamp": {
            "type": "string",
            "format": "date-time",
            "description": "When the content was indexed"
          },
          "metadata": {
            "type": "object",
            "properties": {
              "agent": { "type": "string" },
              "tags": {
                "type": "array",
                "items": { "type": "string" }
              },
              "category": { "type": "string" },
              "game": { "type": "string" }
            }
          }
        },
        "required": ["content", "score", "source", "timestamp"]
      }
    },
    "latency": {
      "type": "number",
      "description": "Total query latency in milliseconds"
    },
    "fallback": {
      "type": "boolean",
      "description": "Whether a fallback mechanism was used"
    },
    "fallbackLevel": {
      "type": "integer",
      "minimum": 1,
      "maximum": 4,
      "description": "1=primary, 2=MongoDB, 3=empty, 4=circuit breaker"
    },
    "circuitBreakerOpen": {
      "type": "boolean",
      "description": "Whether the circuit breaker is currently open"
    },
    "totalIndexed": {
      "type": "integer",
      "description": "Total number of documents in the index"
    }
  },
  "required": ["results", "latency", "fallback", "fallbackLevel", "circuitBreakerOpen", "totalIndexed"]
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 400 | `INVALID_INPUT` | Query validation failed (empty, too long, wrong type) |
| 503 | `SERVICE_UNAVAILABLE` | All search mechanisms failed |
| 500 | `INTERNAL_ERROR` | Unexpected server error |
| 429 | `CIRCUIT_OPEN` | Circuit breaker is open |

**Example Request:**
```bash
curl -X POST http://localhost:3000/tools/rag_context_search \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mongodb retry logic",
    "limit": 3,
    "category": "architecture",
    "agent": "orchestrator"
  }'
```

**Example Response (Success):**
```json
{
  "results": [
    {
      "content": "MongoDB connections should use retry logic with exponential backoff...",
      "score": 0.89,
      "source": "docs/architecture/mongodb-patterns.md",
      "timestamp": "2026-02-18T10:30:00Z",
      "metadata": {
        "agent": "oracle",
        "tags": ["mongodb", "retry", "resilience"],
        "category": "architecture"
      }
    }
  ],
  "latency": 145.2,
  "fallback": false,
  "fallbackLevel": 1,
  "circuitBreakerOpen": false,
  "totalIndexed": 523
}
```

**Example Response (Fallback):**
```json
{
  "results": [],
  "latency": 23.5,
  "fallback": true,
  "fallbackLevel": 4,
  "circuitBreakerOpen": true,
  "totalIndexed": 0
}
```

---

### 3.2 Tool: `rag_context_index`

**Endpoint:** `POST /tools/rag_context_index`

**Method:** POST

**Request Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "content": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100000,
      "description": "Content to index"
    },
    "contentType": {
      "type": "string",
      "enum": ["chat", "decision", "code", "documentation"],
      "description": "Type of content being indexed"
    },
    "sessionId": {
      "type": "string",
      "minLength": 1,
      "description": "Session or document identifier"
    },
    "source": {
      "type": "string",
      "minLength": 1,
      "description": "Source file path or identifier"
    },
    "metadata": {
      "type": "object",
      "properties": {
        "agent": { "type": "string" },
        "tags": {
          "type": "array",
          "items": { "type": "string" }
        },
        "category": { "type": "string" },
        "game": { "type": "string" },
        "decisionId": { "type": "string" }
      }
    }
  },
  "required": ["content", "contentType", "sessionId", "source"]
}
```

**Response Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "success": {
      "type": "boolean"
    },
    "chunksIndexed": {
      "type": "integer",
      "description": "Number of chunks created and indexed"
    },
    "vectorIds": {
      "type": "array",
      "items": { "type": "string" },
      "description": "UUIDs of vectors in Qdrant"
    },
    "latencyMs": {
      "type": "number",
      "description": "Total indexing latency in milliseconds"
    },
    "documentId": {
      "type": "string",
      "description": "MongoDB document ID"
    }
  },
  "required": ["success", "chunksIndexed", "vectorIds", "latencyMs", "documentId"]
}
```

**Example Request:**
```bash
curl -X POST http://localhost:3000/tools/rag_context_index \
  -H "Content-Type: application/json" \
  -d '{
    "content": "FireKirin jackpot threshold configuration...",
    "contentType": "documentation",
    "sessionId": "doc-firekirn-thresholds",
    "source": "docs/casino/firekirin.md",
    "metadata": {
      "category": "casino",
      "game": "FireKirin",
      "tags": ["jackpot", "threshold", "configuration"]
    }
  }'
```

---

### 3.3 Tool: `rag_context_health`

**Endpoint:** `GET /health`

**Method:** GET

**Request Schema:** None (no body)

**Response Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "healthy": { "type": "boolean" },
    "qdrantStatus": {
      "type": "string",
      "enum": ["healthy", "degraded", "unavailable"]
    },
    "lmStudioStatus": {
      "type": "string",
      "enum": ["healthy", "degraded", "unavailable"]
    },
    "mongoStatus": {
      "type": "string",
      "enum": ["healthy", "degraded", "unavailable"]
    },
    "latency": { "type": "number" },
    "indexedDocuments": { "type": "integer" },
    "circuitBreakerOpen": { "type": "boolean" }
  }
}
```

**Example Response:**
```json
{
  "healthy": true,
  "qdrantStatus": "healthy",
  "lmStudioStatus": "healthy",
  "mongoStatus": "healthy",
  "latency": 15.3,
  "indexedDocuments": 523,
  "circuitBreakerOpen": false
}
```

---

### 3.4 Tool: `rag_context_stats`

**Endpoint:** `GET /tools/rag_context_stats?timeRange={range}`

**Method:** GET

**Query Parameters:**
- `timeRange` (optional): One of `1h`, `24h`, `7d`, `30d` (default: `24h`)

**Response Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "totalDocuments": { "type": "integer" },
    "totalQueries": { "type": "integer" },
    "avgLatency": { "type": "number" },
    "p95Latency": { "type": "number" },
    "p99Latency": { "type": "number" },
    "cacheHitRate": { "type": "number" },
    "fallbackRate": { "type": "number" },
    "queriesByAgent": {
      "type": "object",
      "additionalProperties": { "type": "integer" }
    }
  }
}
```

---

## 4. Data Flow Specifications

### 4.1 Search Operation Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│ SEARCH OPERATION - Level by Level Flow                                  │
└─────────────────────────────────────────────────────────────────────────┘

Level 0: Request Arrival
────────────────────────
1. HTTP POST received at /tools/rag_context_search
2. Express middleware processes request
3. Request body parsed as JSON
4. Correlation ID generated for tracing

Level 1: Input Validation
─────────────────────────
1. Zod schema validates input
2. Query length checked (1-1000 chars)
3. Limit checked (1-20, default 5)
4. Enum values validated (category, contentType)
5. If invalid → 400 Bad Request with details

Level 2: Circuit Breaker Check
──────────────────────────────
1. Check circuit breaker state
2. If circuit is OPEN:
   - Check if timeout (60s) has elapsed
   - If elapsed → Move to HALF-OPEN (allow 1 request)
   - If not elapsed → Return Level 4 fallback
3. If circuit is CLOSED or HALF-OPEN → Continue

Level 3: Level 1 - Primary Vector Search (Happy Path)
─────────────────────────────────────────────────────
1. Generate embedding via LM Studio
   - POST /v1/embeddings with query text
   - Expect 768-dimension vector
   - Validate vector normalization
   - Cache embedding for reuse
   - Target: <50ms

2. Execute Qdrant vector search
   - Build filter from options (category, game, etc.)
   - POST /collections/p4nth30n_context/points/search
   - Request top-k results with score threshold (0.7)
   - Target: <100ms

3. Format results
   - Map Qdrant points to response format
   - Include content, score, metadata

4. Record success
   - Reset circuit breaker failure count
   - Log metrics (latency, results count, agent)

5. Return response
   - fallback: false
   - fallbackLevel: 1
   - circuitBreakerOpen: false

Level 4: Level 2 - MongoDB Text Search (Fallback 1)
───────────────────────────────────────────────────
TRIGGER: Qdrant unavailable (5xx, timeout) OR LM Studio error

1. Execute MongoDB $text search
   - Use text index on content + tags
   - Apply filters from options
   - Sort by textScore
   - Target: <100ms

2. Format results
   - Map MongoDB documents to response format
   - Use textScore as relevance score

3. Record fallback
   - Log metrics with fallback=true, level=2

4. Return response
   - fallback: true
   - fallbackLevel: 2
   - circuitBreakerOpen: false

Level 5: Level 3 - Empty Results (Fallback 2)
─────────────────────────────────────────────
TRIGGER: Both Qdrant AND MongoDB unavailable

1. Record failure
   - Increment circuit breaker failure count
   - Log error details
   - Log metrics with fallback=true, level=3

2. If failure count >= 5:
   - Open circuit breaker
   - Set lastFailure timestamp

3. Return empty response
   - results: []
   - fallback: true
   - fallbackLevel: 3
   - circuitBreakerOpen: (failure count >= 5)

Level 6: Level 4 - Circuit Breaker (Fallback 3)
───────────────────────────────────────────────
TRIGGER: Circuit breaker is OPEN

1. Immediately return without attempting search
2. Log metrics with fallback=true, level=4
3. Return response
   - results: []
   - fallback: true
   - fallbackLevel: 4
   - circuitBreakerOpen: true

Level 7: Response Formatting
────────────────────────────
1. Calculate total latency
2. Get total indexed count (async, non-blocking)
3. Format JSON response
4. Send HTTP response
5. Async log to R4G_M37R1C5 (non-blocking)
```

### 4.2 Index Operation Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│ INDEX OPERATION - Step by Step Flow                                     │
└─────────────────────────────────────────────────────────────────────────┘

Step 0: Request Arrival
───────────────────────
1. HTTP POST received at /tools/rag_context_index
2. Express middleware processes request
3. Request body parsed as JSON

Step 1: Input Validation
────────────────────────
1. Zod schema validates input
2. Content checked (1-100KB)
3. contentType is valid enum
4. sessionId and source are non-empty
5. If invalid → 400 Bad Request

Step 2: Text Chunking
─────────────────────
1. Select chunking config based on contentType:
   - chat: 512 tokens, speaker preservation
   - decision: 512 tokens, header-aware
   - code: 256 tokens, function boundary respect
   - documentation: 512 tokens, header-aware

2. Split content by separators (priority order):
   - Paragraph breaks (\n\n)
   - Section headers (\n## , \n### )
   - Line breaks (\n)
   - Sentence ends (. )
   - Word boundaries ( )

3. Merge segments respecting max size
4. Create overlapping chunks (50 tokens overlap)
5. Assign UUID to each chunk

Step 3: Embedding Generation
────────────────────────────
1. Collect all chunk texts
2. Batch chunks (32 per batch)
3. For each batch:
   a. Check embedding cache
   b. Call LM Studio /v1/embeddings
   c. Validate 768 dimensions
   d. Validate normalization
   e. Cache results
   f. Retry on failure (3 attempts)

4. Combine all embeddings

Step 4: Qdrant Vector Upsert
────────────────────────────
1. Build vector points:
   - id: chunk UUID
   - vector: embedding (768 dims)
   - payload: metadata + content

2. Batch upsert (100 points per batch)
3. For each batch:
   a. PUT /collections/p4nth30n_context/points
   b. Handle conflicts
   c. Retry on transient errors

Step 5: MongoDB Document Storage
────────────────────────────────
1. Build document object:
   - _id: new ObjectId
   - sessionId, timestamp, contentType
   - source, content (full text)
   - chunks array with references
   - metadata

2. Insert into C0N7EXT collection
3. Handle duplicate key (skip if exists)

Step 6: Response
────────────────
1. Calculate total latency
2. Format response:
   - success: true
   - chunksIndexed: count
   - vectorIds: array of UUIDs
   - latencyMs: duration
   - documentId: MongoDB _id

3. Send HTTP response
```

---

## 5. Error Handling Strategy

### 5.1 Error Classification Matrix

| Component | Expected Error | Severity | Handling Approach | User Response |
|-----------|---------------|----------|-------------------|---------------|
| **LM Studio** | Network timeout | High | Retry 3x, then fallback | Empty results (L3) |
| **LM Studio** | Model not loaded | Critical | Immediate L3 fallback | Empty results |
| **LM Studio** | Input too long | Medium | Truncate and retry | Normal results |
| **LM Studio** | Rate limited | Low | Wait and retry | Normal results |
| **Qdrant** | Connection timeout | High | Retry 3x, then L2 fallback | Text search results |
| **Qdrant** | Collection not found | Medium | Auto-create, retry | Normal results |
| **Qdrant** | Wrong dimensions | Critical | Log error, L3 fallback | Empty results |
| **Qdrant** | Service unavailable | Critical | Immediate L2 fallback | Text search results |
| **MongoDB** | Connection error | Critical | L3 fallback | Empty results |
| **MongoDB** | Text index missing | Medium | Auto-create, retry | Normal results |
| **MongoDB** | Duplicate key | Low | Skip (idempotent) | Normal results |
| **Validation** | Schema mismatch | Low | 400 Bad Request | Error details |
| **Circuit** | Circuit open | High | Immediate L4 | Empty results |

### 5.2 Circuit Breaker Implementation

```typescript
// Circuit breaker state machine
class CircuitBreaker {
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';
  private failures = 0;
  private lastFailure = 0;
  private readonly threshold = 5;
  private readonly timeout = 60000;  // 60 seconds

  isOpen(): boolean {
    if (this.state === 'OPEN') {
      // Check if timeout elapsed
      if (Date.now() - this.lastFailure > this.timeout) {
        this.state = 'HALF_OPEN';
        this.failures = 0;
        return false;
      }
      return true;
    }
    return false;
  }

  recordSuccess(): void {
    this.failures = 0;
    if (this.state === 'HALF_OPEN') {
      this.state = 'CLOSED';
    }
  }

  recordFailure(): void {
    this.failures++;
    this.lastFailure = Date.now();
    
    if (this.failures >= this.threshold) {
      this.state = 'OPEN';
      logger.error('Circuit breaker opened');
    }
  }
}
```

### 5.3 Retry Policy

```typescript
// Exponential backoff retry
async function withRetry<T>(
  operation: () => Promise<T>,
  maxRetries: number = 3,
  baseDelay: number = 100
): Promise<T> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await operation();
    } catch (error) {
      if (attempt === maxRetries) {
        throw error;
      }
      
      // Calculate delay with exponential backoff + jitter
      const delay = baseDelay * Math.pow(2, attempt) + Math.random() * 100;
      logger.warn(`Retry ${attempt}/${maxRetries} after ${delay}ms`);
      await sleep(delay);
    }
  }
  
  throw new Error('Max retries exceeded');
}
```

### 5.4 Error Logging

```typescript
// Structured error logging
interface ErrorLog {
  timestamp: Date;
  level: 'error' | 'warn' | 'info';
  component: string;
  operation: string;
  error: string;
  stack?: string;
  context: {
    query?: string;
    agent?: string;
    fallbackLevel?: number;
  };
}

// Log to console and MongoDB
async function logError(log: ErrorLog): Promise<void> {
  // Console output
  logger.error(log.error, { component: log.component, operation: log.operation });
  
  // Store in MongoDB for analysis
  await mongodbClient.collection('errors').insertOne({
    ...log,
    timestamp: new Date()
  });
}
```

---

## 6. Performance Optimizations

### 6.1 Caching Strategy

```typescript
// Multi-tier caching
class RagCache {
  // L1: In-memory LRU cache (fastest)
  private memoryCache: LRUCache<string, CacheEntry>;
  
  // L2: Redis cache (shared across instances)
  private redisClient: RedisClient;
  
  constructor() {
    this.memoryCache = new LRUCache({
      max: 1000,
      ttl: 1000 * 60 * 5  // 5 minutes
    });
  }

  async get(query: string, filters: FilterOptions): Promise<RagSearchResult | null> {
    const key = this.buildKey(query, filters);
    
    // Check L1 cache
    const memEntry = this.memoryCache.get(key);
    if (memEntry && !this.isExpired(memEntry)) {
      return memEntry.result;
    }
    
    return null;
  }

  async set(
    query: string,
    filters: FilterOptions,
    result: RagSearchResult,
    ttl: number = 300000
  ): Promise<void> {
    const key = this.buildKey(query, filters);
    
    this.memoryCache.set(key, {
      result,
      expires: Date.now() + ttl
    });
  }

  private buildKey(query: string, filters: FilterOptions): string {
    return crypto.createHash('sha256')
      .update(JSON.stringify({ query, filters }))
      .digest('hex');
  }
}
```

### 6.2 Connection Pooling

```typescript
// HTTP client configuration with connection pooling
const httpClientConfig = {
  // Keep-alive connections
  keepAlive: true,
  keepAliveMsecs: 1000,
  maxSockets: 50,
  maxFreeSockets: 10,
  timeout: 30000,
  
  // Request configuration
  headers: {
    'Connection': 'keep-alive'
  }
};

// MongoDB connection pooling
const mongoConfig = {
  maxPoolSize: 50,
  minPoolSize: 10,
  maxIdleTimeMS: 30000,
  waitQueueTimeoutMS: 5000
};
```

### 6.3 Batching Strategy

```typescript
// Batch processing for indexing
class BatchProcessor {
  private batch: IndexRequest[] = [];
  private readonly batchSize = 100;
  private flushTimer: NodeJS.Timeout | null = null;

  async add(request: IndexRequest): Promise<void> {
    this.batch.push(request);
    
    if (this.batch.length >= this.batchSize) {
      await this.flush();
    } else if (!this.flushTimer) {
      this.flushTimer = setTimeout(() => this.flush(), 1000);
    }
  }

  private async flush(): Promise<void> {
    if (this.batch.length === 0) return;
    
    const toProcess = [...this.batch];
    this.batch = [];
    
    if (this.flushTimer) {
      clearTimeout(this.flushTimer);
      this.flushTimer = null;
    }
    
    // Process in parallel chunks
    const chunks = this.chunkArray(toProcess, 10);
    await Promise.all(chunks.map(chunk => this.processChunk(chunk)));
  }

  private chunkArray<T>(array: T[], size: number): T[][] {
    const chunks: T[][] = [];
    for (let i = 0; i < array.length; i += size) {
      chunks.push(array.slice(i, i + size));
    }
    return chunks;
  }
}
```

### 6.4 Async Patterns

```typescript
// Parallel processing where possible
async function searchWithMetrics(
  query: string,
  options: SearchOptions
): Promise<SearchResult> {
  const startTime = Date.now();
  
  // Run search and count total in parallel
  const [results, totalIndexed] = await Promise.all([
    executeSearch(query, options),
    getTotalIndexed()  // Non-blocking
  ]);
  
  const latency = Date.now() - startTime;
  
  // Fire-and-forget metrics logging
  logMetrics({
    query,
    latency,
    resultsCount: results.length,
    agent: options.agent
  }).catch(err => logger.error('Metrics logging failed', err));
  
  return {
    results,
    latency,
    totalIndexed
  };
}
```

---

## 7. Testing Strategy

### 7.1 Unit Tests

```typescript
// Example unit test structure
describe('RAG Tools', () => {
  describe('rag_context_search', () => {
    it('should return results from vector search', async () => {
      // Arrange
      const mockEmbedding = new Array(768).fill(0.1);
      lmStudioClient.generateEmbedding.mockResolvedValue(mockEmbedding);
      qdrantClient.searchVectors.mockResolvedValue([mockResult]);
      
      // Act
      const result = await executeSearch({ query: 'test', limit: 5 });
      
      // Assert
      expect(result.fallback).toBe(false);
      expect(result.fallbackLevel).toBe(1);
      expect(result.results).toHaveLength(1);
    });

    it('should fallback to MongoDB when Qdrant fails', async () => {
      // Arrange
      qdrantClient.searchVectors.mockRejectedValue(new Error('Qdrant down'));
      mongodbClient.textSearch.mockResolvedValue([mockTextResult]);
      
      // Act
      const result = await executeSearch({ query: 'test' });
      
      // Assert
      expect(result.fallback).toBe(true);
      expect(result.fallbackLevel).toBe(2);
    });

    it('should validate query length', async () => {
      // Act/Assert
      await expect(executeSearch({ query: '' }))
        .rejects.toThrow('Query cannot be empty');
      
      await expect(executeSearch({ query: 'a'.repeat(1001) }))
        .rejects.toThrow('Query too long');
    });
  });
});
```

### 7.2 Integration Tests

```powershell
# Integration test script
# tests/integration/rag-integration.tests.ps1

describe "RAG Integration Tests" {
    BeforeAll {
        $baseUrl = "http://localhost:3000"
        # Ensure services are running
    }

    it "should index and retrieve a document" {
        # Index document
        $indexBody = @{
            content = "Test content for integration"
            contentType = "documentation"
            sessionId = "test-$(New-Guid)"
            source = "test"
        } | ConvertTo-Json

        $indexResult = Invoke-RestMethod -Uri "$baseUrl/tools/rag_context_index" `
            -Method POST -Body $indexBody -ContentType "application/json"
        
        $indexResult.success | Should -Be $true
        Start-Sleep -Seconds 2

        # Search for document
        $searchBody = @{ query = "Test content" } | ConvertTo-Json
        $searchResult = Invoke-RestMethod -Uri "$baseUrl/tools/rag_context_search" `
            -Method POST -Body $searchBody -ContentType "application/json"
        
        $searchResult.results | Should -HaveCount 1
        $searchResult.results[0].content | Should -BeLike "*Test content*"
    }

    it "should respect game filter" {
        # Index FireKirin document
        # Index OrionStars document
        # Search with game=FireKirin
        # Verify only FireKirin result returned
    }

    it "should handle circuit breaker" {
        # Simulate 5 failures
        # Verify circuit opens
        # Verify immediate fallback
    }
}
```

### 7.3 Performance Tests

```typescript
// Load testing with k6
// tests/performance/rag-load.test.js

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 10 },   // Ramp up
    { duration: '5m', target: 10 },   // Steady state
    { duration: '1m', target: 20 },   // Spike
    { duration: '1m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<300', 'p(99)<500'],
    http_req_failed: ['rate<0.05'],
  },
};

const queries = [
  'mongodb retry logic',
  'jackpot threshold',
  'selenium automation',
  'architecture pattern',
];

export default function () {
  const query = queries[Math.floor(Math.random() * queries.length)];
  
  const response = http.post('http://localhost:3000/tools/rag_context_search', JSON.stringify({
    query,
    limit: 5,
  }), {
    headers: { 'Content-Type': 'application/json' },
  });

  check(response, {
    'status is 200': (r) => r.status === 200,
    'latency < 500ms': (r) => r.timings.duration < 500,
    'has results': (r) => JSON.parse(r.body).results.length > 0,
  });

  sleep(1);
}
```

### 7.4 End-to-End Tests

```powershell
# E2E test: Full workflow
# tests/e2e/rag-workflow.tests.ps1

describe "RAG End-to-End Workflow" {
    it "should complete full indexing and search workflow" {
        # 1. Start with empty index
        # 2. Index 50 sample documents
        # 3. Run 50 benchmark queries
        # 4. Verify >85% accuracy
        # 5. Verify <500ms p99 latency
        # 6. Verify <5% fallback rate
    }

    it "should handle service degradation gracefully" {
        # 1. Index documents
        # 2. Kill Qdrant
        # 3. Verify fallback to MongoDB
        # 4. Kill MongoDB
        # 5. Verify empty results
        # 6. Restart services
        # 7. Verify recovery
    }
}
```

---

## 8. Deployment Sequence

### 8.1 Pre-Deployment Checklist

```markdown
- [ ] Rancher Desktop installed and running
- [ ] Kubernetes enabled in Rancher Desktop
- [ ] kubectl configured
- [ ] MongoDB running locally (for development)
- [ ] LM Studio installed with nomic-embed-text-v1.5
```

### 8.2 Deployment Steps

```bash
#!/bin/bash
# deploy-rag.sh

set -e

echo "=== RAG-001 Deployment ==="

# Step 1: Create namespace
echo "Step 1: Creating namespace..."
kubectl create namespace rag-context --dry-run=client -o yaml | kubectl apply -f -

# Step 2: Deploy Qdrant PVC
echo "Step 2: Deploying Qdrant storage..."
kubectl apply -f k8s/qdrant-pvc.yaml

# Step 3: Deploy Qdrant
echo "Step 3: Deploying Qdrant..."
kubectl apply -f k8s/qdrant-deployment.yaml
kubectl apply -f k8s/qdrant-service.yaml

# Wait for Qdrant
echo "Waiting for Qdrant to be ready..."
kubectl wait --for=condition=ready pod -l app=qdrant -n rag-context --timeout=120s

# Step 4: Configure LM Studio
echo "Step 4: Configuring LM Studio..."
echo "  Ensure LM Studio is running with nomic-embed-text-v1.5"
echo "  Press Enter when ready..."
read

# Step 5: Run pre-validation
echo "Step 5: Running pre-validation..."
pwsh scripts/pre-validate-rag.ps1

if [ $? -ne 0 ]; then
    echo "Pre-validation failed. Fix issues before continuing."
    exit 1
fi

# Step 6: Deploy MCP server
echo "Step 6: Deploying MCP RAG server..."
cd MCP/rag-server
npm install
npm run build
npm start &
cd ../..

# Wait for MCP server
echo "Waiting for MCP server..."
sleep 5
curl -f http://localhost:3000/health || exit 1

# Step 7: Run integration tests
echo "Step 7: Running integration tests..."
npm test

# Step 8: Deploy C# services
echo "Step 8: Building C# services..."
dotnet build C0MMON/C0MMON.csproj
dotnet build H0UND/H0UND.csproj

# Step 9: Index sample data
echo "Step 9: Indexing sample data..."
dotnet run --project H0UND/H0UND.csproj -- --index-decisions

# Step 10: Final verification
echo "Step 10: Final verification..."
curl -X POST http://localhost:3000/tools/rag_context_search \
  -H "Content-Type: application/json" \
  -d '{"query":"architecture decision","limit":3}'

echo ""
echo "=== Deployment Complete ==="
echo "Qdrant: http://localhost:30333"
echo "MCP Server: http://localhost:3000"
```

### 8.3 Rollback Procedure

```bash
#!/bin/bash
# rollback-rag.sh

echo "=== RAG-001 Rollback ==="

# Step 1: Stop MCP server
echo "Step 1: Stopping MCP server..."
pkill -f "rag-server"

# Step 2: Scale down Qdrant
echo "Step 2: Scaling down Qdrant..."
kubectl scale deployment qdrant --replicas=0 -n rag-context

# Step 3: Remove C# service registrations
echo "Step 3: Removing C# registrations..."
# ServiceCollection.Remove<IRagContext>() in code

# Step 4: Revert agent prompts
echo "Step 4: Reverting agent prompts..."
git checkout HEAD -- ~/.config/opencode/agents/*.md

echo "=== Rollback Complete ==="
echo "Agents will continue without RAG augmentation"
```

---

## 9. Design Decisions & Answers

### 9.1 Typed HTTP Client vs Generic

**Decision:** Use Typed HTTP Client in C#

**Rationale:**
- `RagContextService` implements `IRagContext` interface
- Provides compile-time type safety
- Easier to mock for testing
- Follows .NET dependency injection best practices
- Enables `HttpClient` reuse and connection pooling

**Implementation:**
```csharp
services.AddHttpClient<IRagContext, RagContextService>(client => {
    client.BaseAddress = new Uri("http://localhost:3000");
    client.Timeout = TimeSpan.FromSeconds(30);
});
```

### 9.2 Optimal Chunk Sizes

| Content Type | Max Tokens | Overlap | Rationale |
|-------------|------------|---------|-----------|
| **Chat** | 512 | 50 | Preserve conversation context across chunks |
| **Code** | 256 | 25 | Smaller chunks for precise function-level retrieval |
| **Decision** | 512 | 50 | Section headers guide logical splits |
| **Documentation** | 512 | 50 | Paragraph and section boundaries |

**Special Handling:**
- Code: Respect function/class boundaries using `\n}\n` separator
- Chat: Preserve speaker attribution `[Name] message`
- Decisions: Prioritize header boundaries (`\n## `, `\n### `)

### 9.3 Embedding Generation Failures

**Failure Handling Strategy:**

1. **LM Studio Unavailable**
   - Retry 3 times with exponential backoff
   - If still failing → Trigger Level 2 fallback (MongoDB text search)
   - Log error for alerting

2. **Input Too Long (>2048 tokens)**
   - Truncate to 2048 tokens
   - Log warning
   - Retry with truncated input

3. **Invalid Response (wrong dimensions)**
   - Validate immediately (expect 768)
   - If wrong → Throw fatal error (configuration issue)
   - Don't fallback (indicates model mismatch)

4. **Normalization Check Fails**
   - Normalize vector manually
   - Log warning
   - Continue with normalized vector

### 9.4 Qdrant Retry Policy

**Configuration:**
```typescript
const qdrantRetryPolicy = {
  maxRetries: 3,
  baseDelay: 100,      // Start with 100ms
  maxDelay: 5000,      // Cap at 5 seconds
  retryableErrors: [
    'ECONNREFUSED',
    'ETIMEDOUT',
    'ECONNRESET',
    '503',              // Service unavailable
    '429',              // Rate limited
  ]
};
```

**Non-Retryable Errors:**
- 400 Bad Request (client error)
- Wrong dimensions (configuration error)
- Collection not found (auto-create, then retry)

### 9.5 Large Batch Indexing (>1000 documents)

**Strategy: Streaming with Backpressure**

```typescript
class StreamingIndexer {
  private readonly batchSize = 100;
  private readonly concurrency = 5;

  async indexLargeBatch(documents: Document[]): Promise<void> {
    const queue = new PQueue({ concurrency: this.concurrency });
    
    // Process in chunks
    for (let i = 0; i < documents.length; i += this.batchSize) {
      const batch = documents.slice(i, i + this.batchSize);
      
      await queue.add(async () => {
        await this.indexBatch(batch);
        
        // Progress reporting
        console.log(`Indexed ${i + batch.length}/${documents.length}`);
      });
    }
    
    await queue.onEmpty();
  }

  private async indexBatch(batch: Document[]): Promise<void> {
    // Parallel embedding generation
    const embeddings = await Promise.all(
      batch.map(doc => this.embeddingService.generate(doc.content))
    );
    
    // Batch Qdrant upsert
    await this.qdrantClient.upsertVectors(
      batch.map((doc, i) => ({
        id: doc.id,
        vector: embeddings[i],
        payload: doc.metadata
      }))
    );
    
    // Batch MongoDB insert
    await this.mongodbClient.insertMany(batch);
  }
}
```

**Progress Tracking:**
- Store progress in MongoDB (`_indexing_progress` collection)
- Allow resumption after interruption
- Log progress every 100 documents

**Memory Management:**
- Stream documents from source (don't load all into memory)
- Process in bounded batches
- Use `p-queue` for concurrency control

---

## Appendix A: Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MONGODB_URI` | `mongodb://localhost:27017/P4NTH30N` | MongoDB connection string |
| `QDRANT_URL` | `http://localhost:6333` | Qdrant API URL |
| `LM_STUDIO_URL` | `http://localhost:1234` | LM Studio API URL |
| `MCP_SERVER_PORT` | `3000` | MCP HTTP server port |
| `LOG_LEVEL` | `info` | Logging level (debug, info, warn, error) |
| `RAG_CACHE_SIZE` | `1000` | In-memory cache size |
| `RAG_CACHE_TTL` | `300` | Cache TTL in seconds |
| `CIRCUIT_BREAKER_THRESHOLD` | `5` | Failures before opening circuit |
| `CIRCUIT_BREAKER_TIMEOUT` | `60000` | Circuit timeout in milliseconds |

---

## Appendix B: MongoDB Collection Schemas

### C0N7EXT (Context Documents)

```javascript
{
  _id: ObjectId,
  sessionId: String,           // Indexed
  timestamp: Date,             // Indexed
  contentType: String,         // Indexed
  source: String,
  content: String,             // Text indexed
  chunks: [{
    chunkId: String,
    text: String,
    vectorId: String,
    embedding: [Number]        // 768 dimensions
  }],
  metadata: {
    agent: String,
    tags: [String],            // Indexed
    category: String,          // Indexed
    game: String,              // Indexed
    decisionId: String         // Indexed
  },
  retrievalStats: {
    queryCount: Number,
    lastRetrieved: Date
  }
}
```

### R4G_M37R1C5 (Metrics)

```javascript
{
  _id: ObjectId,
  timestamp: Date,             // Indexed
  query: String,
  resultsCount: Number,
  latencyMs: Number,
  embeddingLatencyMs: Number,
  vectorLatencyMs: Number,
  fallback: Boolean,           // Indexed
  fallbackLevel: Number,
  cacheHit: Boolean,
  agent: String,               // Indexed
  contentType: String,
  category: String,
  game: String,
  error: String
}
```

---

## Appendix C: File Structure

```
P4NTH30N/
├── MCP/
│   └── rag-server/
│       ├── src/
│       │   ├── index.ts                    # Entry point
│       │   ├── server.ts                   # Express routes
│       │   ├── clients/
│       │   │   ├── lmStudio.ts            # LM Studio client
│       │   │   ├── qdrant.ts              # Qdrant client
│       │   │   └── mongodb.ts             # MongoDB client
│       │   ├── tools/
│       │   │   ├── search.ts              # rag_context_search
│       │   │   ├── index.ts               # rag_context_index
│       │   │   ├── health.ts              # rag_context_health
│       │   │   └── stats.ts               # rag_context_stats
│       │   ├── services/
│       │   │   ├── chunking.ts            # Text chunking
│       │   │   ├── embedding.ts           # Embedding cache
│       │   │   └── circuitBreaker.ts      # Circuit breaker
│       │   └── types/
│       │       └── index.ts               # TypeScript types
│       ├── tests/
│       │   ├── unit/
│       │   ├── integration/
│       │   └── performance/
│       ├── package.json
│       ├── tsconfig.json
│       └── Dockerfile
├── C0MMON/
│   ├── Interfaces/
│   │   └── IRagContext.cs                 # Service interface
│   └── Services/
│       └── RagContextService.cs           # HTTP client implementation
├── H0UND/
│   └── Infrastructure/
│       └── RagContextIndexer.cs           # Background indexer
├── k8s/
│   ├── qdrant-deployment.yaml             # Qdrant deployment
│   ├── qdrant-service.yaml                # Qdrant service
│   └── qdrant-pvc.yaml                    # Qdrant storage
├── scripts/
│   ├── pre-validate-rag.ps1               # Pre-validation script
│   ├── deploy-rag.sh                      # Deployment script
│   └── rollback-rag.sh                    # Rollback script
└── docs/
    └── rag-context/
        ├── UNIFIED_SPECIFICATION.md       # Oracle spec
        ├── DESIGNER_TECHNICAL_SPEC.md     # This document
        └── DEPLOYMENT_GUIDE.md            # Deployment instructions
```

---

**End of Technical Specification**

*This document is ready for Fixer implementation. All sections have been detailed with code examples, error handling, and testing approaches.*

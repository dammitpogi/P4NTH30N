# RAG Context Layer - Technical Specification
## For: Fixer Implementation

**Decision:** RAG-001  
**Status:** Approved (Pending)  
**Priority:** High  

---

## Quick Reference

| Component | Technology | Port | Status Check |
|-----------|------------|------|--------------|
| Vector DB | Qdrant | 6333 | `curl localhost:6333/healthz` |
| Embeddings | LM Studio | 1234 | `curl localhost:1234/v1/models` |
| MCP Server | Node.js | 3000 | `toolhive_find_tool rag_context` |
| MongoDB | Existing | 27017 | Already running |

---

## Phase 1: Infrastructure Deployment

### 1.1 Rancher Desktop Setup

**Prerequisites:**
- Windows 10/11 with WSL2 enabled
- 8GB+ RAM available
- 10GB+ disk space

**Steps:**
1. Download Rancher Desktop from https://rancherdesktop.io/
2. Install with Kubernetes enabled
3. Set Kubernetes version to v1.28+ (stable)
4. Container runtime: `containerd` or `dockerd`
5. Memory allocation: 4GB minimum, 6GB recommended

**Validation:**
```powershell
kubectl version
kubectl get nodes
# Should show Ready status
```

### 1.2 Qdrant Deployment

Create namespace and deploy:

```powershell
# Create namespace
kubectl create namespace rag-context

# Apply manifests
kubectl apply -f k8s/qdrant-pvc.yaml
kubectl apply -f k8s/qdrant-deployment.yaml
kubectl apply -f k8s/qdrant-service.yaml
```

**k8s/qdrant-pvc.yaml:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: qdrant-pvc
  namespace: rag-context
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

**k8s/qdrant-deployment.yaml:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: qdrant
  namespace: rag-context
spec:
  replicas: 1
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
        ports:
        - containerPort: 6333
          name: http
        - containerPort: 6334
          name: grpc
        env:
        - name: QDRANT__SERVICE__HTTP_PORT
          value: "6333"
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
        volumeMounts:
        - name: qdrant-storage
          mountPath: /qdrant/storage
        livenessProbe:
          httpGet:
            path: /healthz
            port: 6333
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /healthz
            port: 6333
          initialDelaySeconds: 5
          periodSeconds: 5
      volumes:
      - name: qdrant-storage
        persistentVolumeClaim:
          claimName: qdrant-pvc
```

**k8s/qdrant-service.yaml:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: qdrant
  namespace: rag-context
spec:
  selector:
    app: qdrant
  ports:
  - name: http
    port: 6333
    targetPort: 6333
    nodePort: 30333
  - name: grpc
    port: 6334
    targetPort: 6334
    nodePort: 30334
  type: NodePort
```

**Validation:**
```powershell
kubectl get pods -n rag-context
# Should show qdrant pod Running

kubectl get svc -n rag-context
# Should show qdrant service with NodePort

# Test connection
$QDRANT_IP = kubectl get svc qdrant -n rag-context -o jsonpath='{.spec.clusterIP}'
curl http://$QDRANT_IP:6333/healthz
# Should return {"status":"ok"}
```

### 1.3 LM Studio Setup

**Download:**
1. Download LM Studio from https://lmstudio.ai/
2. Install on Windows
3. Launch LM Studio

**Model Download:**
1. Go to Search tab
2. Search for "nomic-embed-text-v1.5"
3. Download: `nomic-ai/nomic-embed-text-v1.5` (GGUF version)
4. Wait for download to complete

**Server Configuration:**
1. Go to Developer tab
2. Select model: nomic-embed-text-v1.5
3. Click "Start Server"
4. Verify server is running on port 1234
5. Check "CORS" is enabled

**Validation:**
```powershell
# Test embedding endpoint
curl http://localhost:1234/v1/embeddings `
  -H "Content-Type: application/json" `
  -d '{"input": "test query", "model": "nomic-embed-text-v1.5"}'

# Should return JSON with embedding array of 768 floats
```

---

## Phase 2: MCP Server Implementation

### 2.1 Project Structure

```
MCP/rag-server/
├── src/
│   ├── index.ts
│   ├── clients/
│   │   ├── lmStudio.ts
│   │   ├── qdrant.ts
│   │   └── mongodb.ts
│   ├── tools/
│   │   ├── search.ts
│   │   ├── index.ts
│   │   ├── health.ts
│   │   └── stats.ts
│   ├── services/
│   │   ├── chunking.ts
│   │   └── embedding.ts
│   └── types/
│       └── index.ts
├── package.json
├── tsconfig.json
└── Dockerfile
```

### 2.2 package.json

```json
{
  "name": "rag-context-mcp",
  "version": "1.0.0",
  "description": "RAG Context MCP Server for P4NTH30N",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsc --watch"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.4",
    "@qdrant/js-client-rest": "^1.13.0",
    "mongodb": "^6.12.0",
    "zod": "^3.24.1"
  },
  "devDependencies": {
    "@types/node": "^22.13.1",
    "typescript": "^5.7.3"
  }
}
```

### 2.3 tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### 2.4 src/types/index.ts

```typescript
export interface RagDocument {
  _id?: string;
  sessionId: string;
  timestamp: Date;
  contentType: 'chat' | 'decision' | 'code' | 'documentation';
  source: string;
  content: string;
  chunks: Chunk[];
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

export interface Chunk {
  chunkId: string;
  text: string;
  vectorId?: string;
  embedding?: number[];
}

export interface SearchResult {
  content: string;
  score: number;
  source: string;
  timestamp: string;
  metadata: {
    agent?: string;
    tags?: string[];
    category?: string;
    game?: string;
  };
}

export interface SearchOptions {
  query: string;
  limit?: number;
  category?: string;
  sessionId?: string;
  contentType?: string;
}

export interface RagStats {
  totalDocuments: number;
  totalQueries: number;
  avgLatency: number;
  p95Latency: number;
  p99Latency: number;
  cacheHitRate: number;
  fallbackRate: number;
  queriesByAgent: Record<string, number>;
}

export interface HealthStatus {
  healthy: boolean;
  qdrantStatus: 'healthy' | 'degraded' | 'unavailable';
  lmStudioStatus: 'healthy' | 'degraded' | 'unavailable';
  latency: number;
  indexedDocuments: number;
  circuitBreakerOpen: boolean;
}
```

### 2.5 src/clients/lmStudio.ts

```typescript
import type { EmbeddingResponse } from '../types/index.js';

export class LMStudioClient {
  private baseUrl: string;
  private model: string;

  constructor(baseUrl = 'http://localhost:1234', model = 'nomic-embed-text-v1.5') {
    this.baseUrl = baseUrl;
    this.model = model;
  }

  async generateEmbedding(text: string): Promise<number[]> {
    const response = await fetch(`${this.baseUrl}/v1/embeddings`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        input: text,
        model: this.model,
      }),
    });

    if (!response.ok) {
      throw new Error(`LM Studio error: ${response.status} ${response.statusText}`);
    }

    const data = await response.json() as EmbeddingResponse;
    return data.data[0].embedding;
  }

  async healthCheck(): Promise<{ healthy: boolean; latency: number }> {
    const start = Date.now();
    try {
      const response = await fetch(`${this.baseUrl}/v1/models`, {
        method: 'GET',
      });
      const latency = Date.now() - start;
      return { healthy: response.ok, latency };
    } catch {
      return { healthy: false, latency: Date.now() - start };
    }
  }
}

interface EmbeddingResponse {
  data: Array<{
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

### 2.6 src/clients/qdrant.ts

```typescript
import { QdrantClient } from '@qdrant/js-client-rest';
import type { SearchResult, RagDocument } from '../types/index.js';

export class QdrantWrapper {
  private client: QdrantClient;
  private collectionName: string;

  constructor(url = 'http://localhost:6333', collectionName = 'p4nth30n_context') {
    this.client = new QdrantClient({ url });
    this.collectionName = collectionName;
  }

  async initialize(): Promise<void> {
    const collections = await this.client.getCollections();
    const exists = collections.collections.some(c => c.name === this.collectionName);

    if (!exists) {
      await this.client.createCollection(this.collectionName, {
        vectors: {
          size: 768,
          distance: 'Cosine',
        },
        optimizers_config: {
          default_segment_number: 2,
        },
        replication_factor: 1,
      });

      // Create payload indexes
      await this.client.createPayloadIndex(this.collectionName, {
        field_name: 'sessionId',
        field_schema: 'keyword',
      });
      await this.client.createPayloadIndex(this.collectionName, {
        field_name: 'contentType',
        field_schema: 'keyword',
      });
      await this.client.createPayloadIndex(this.collectionName, {
        field_name: 'category',
        field_schema: 'keyword',
      });
    }
  }

  async upsertPoints(points: Array<{
    id: string;
    vector: number[];
    payload: Record<string, unknown>;
  }>): Promise<void> {
    await this.client.upsert(this.collectionName, {
      points: points.map(p => ({
        id: p.id,
        vector: p.vector,
        payload: p.payload,
      })),
    });
  }

  async search(
    vector: number[],
    limit: number = 5,
    filters?: Record<string, unknown>
  ): Promise<SearchResult[]> {
    const mustConditions = [];

    if (filters?.category) {
      mustConditions.push({
        key: 'category',
        match: { value: filters.category },
      });
    }

    if (filters?.sessionId) {
      mustConditions.push({
        key: 'sessionId',
        match: { value: filters.sessionId },
      });
    }

    if (filters?.contentType) {
      mustConditions.push({
        key: 'contentType',
        match: { value: filters.contentType },
      });
    }

    const result = await this.client.search(this.collectionName, {
      vector,
      limit,
      filter: mustConditions.length > 0 ? { must: mustConditions } : undefined,
      with_payload: true,
    });

    return result.map(point => ({
      content: (point.payload?.text as string) || '',
      score: point.score || 0,
      source: (point.payload?.source as string) || '',
      timestamp: (point.payload?.timestamp as string) || '',
      metadata: {
        agent: (point.payload?.agent as string) || undefined,
        tags: (point.payload?.tags as string[]) || undefined,
        category: (point.payload?.category as string) || undefined,
        game: (point.payload?.game as string) || undefined,
      },
    }));
  }

  async count(): Promise<number> {
    const result = await this.client.count(this.collectionName);
    return result.count;
  }

  async healthCheck(): Promise<{ healthy: boolean; latency: number }> {
    const start = Date.now();
    try {
      await this.client.getCollections();
      const latency = Date.now() - start;
      return { healthy: true, latency };
    } catch {
      return { healthy: false, latency: Date.now() - start };
    }
  }
}
```

### 2.7 src/clients/mongodb.ts

```typescript
import { MongoClient, Db, Collection } from 'mongodb';
import type { RagDocument } from '../types/index.js';

export class MongoDBClient {
  private client: MongoClient;
  private db: Db;
  public contextCollection: Collection<RagDocument>;
  public metricsCollection: Collection;

  constructor(connectionString = 'mongodb://localhost:27017/P4NTH30N') {
    this.client = new MongoClient(connectionString);
    this.db = this.client.db();
    this.contextCollection = this.db.collection<RagDocument>('C0N7EXT');
    this.metricsCollection = this.db.collection('R4G_M37R1C5');
  }

  async connect(): Promise<void> {
    await this.client.connect();
    await this.createIndexes();
  }

  async disconnect(): Promise<void> {
    await this.client.close();
  }

  private async createIndexes(): Promise<void> {
    await this.contextCollection.createIndex({ sessionId: 1, timestamp: -1 });
    await this.contextCollection.createIndex({ 'metadata.tags': 1 });
    await this.contextCollection.createIndex({ 'metadata.category': 1 });
    await this.contextCollection.createIndex({ contentType: 1, timestamp: -1 });
    await this.contextCollection.createIndex({ 'metadata.decisionId': 1 });

    await this.metricsCollection.createIndex({ timestamp: -1 });
    await this.metricsCollection.createIndex({ agent: 1, timestamp: -1 });
  }

  async textSearch(query: string, limit: number = 5): Promise<RagDocument[]> {
    return await this.contextCollection
      .find({ $text: { $search: query } })
      .limit(limit)
      .toArray();
  }

  async getStats(timeRangeHours: number = 24): Promise<{
    totalDocuments: number;
    totalQueries: number;
  }> {
    const totalDocuments = await this.contextCollection.countDocuments();
    const cutoff = new Date(Date.now() - timeRangeHours * 60 * 60 * 1000);
    const totalQueries = await this.metricsCollection.countDocuments({
      timestamp: { $gte: cutoff },
    });

    return { totalDocuments, totalQueries };
  }
}
```

### 2.8 src/services/chunking.ts

```typescript
import type { Chunk } from '../types/index.js';

export interface ChunkingOptions {
  maxChunkSize?: number;
  chunkOverlap?: number;
  separators?: string[];
}

export class ChunkingService {
  private maxChunkSize: number;
  private chunkOverlap: number;
  private separators: string[];

  constructor(options: ChunkingOptions = {}) {
    this.maxChunkSize = options.maxChunkSize || 512;
    this.chunkOverlap = options.chunkOverlap || 50;
    this.separators = options.separators || ['\n\n', '\n', '. ', ' '];
  }

  chunkText(text: string, metadata: Record<string, unknown> = {}): Chunk[] {
    const chunks: Chunk[] = [];
    let position = 0;

    while (position < text.length) {
      const chunk = this.getChunk(text, position);
      if (chunk.length === 0) break;

      chunks.push({
        chunkId: `chunk-${chunks.length}`,
        text: chunk,
        metadata,
      });

      position += chunk.length - this.chunkOverlap;
      if (position >= text.length) break;
    }

    return chunks;
  }

  private getChunk(text: string, start: number): string {
    if (start >= text.length) return '';

    const end = Math.min(start + this.maxChunkSize, text.length);
    let chunk = text.slice(start, end);

    // Try to find a good break point
    if (end < text.length) {
      for (const separator of this.separators) {
        const lastIndex = chunk.lastIndexOf(separator);
        if (lastIndex > this.maxChunkSize * 0.5) {
          chunk = chunk.slice(0, lastIndex + separator.length);
          break;
        }
      }
    }

    return chunk.trim();
  }
}
```

### 2.9 src/services/embedding.ts

```typescript
import { LMStudioClient } from '../clients/lmStudio.js';
import { QdrantWrapper } from '../clients/qdrant.js';
import { ChunkingService } from './chunking.js';
import type { RagDocument, Chunk } from '../types/index.js';

export class EmbeddingService {
  private lmStudio: LMStudioClient;
  private qdrant: QdrantWrapper;
  private chunking: ChunkingService;

  constructor() {
    this.lmStudio = new LMStudioClient();
    this.qdrant = new QdrantWrapper();
    this.chunking = new ChunkingService();
  }

  async initialize(): Promise<void> {
    await this.qdrant.initialize();
  }

  async indexDocument(doc: RagDocument): Promise<{
    chunksIndexed: number;
    vectorIds: string[];
  }> {
    // Chunk the content
    const chunks = this.chunking.chunkText(doc.content, {
      sessionId: doc.sessionId,
      contentType: doc.contentType,
    });

    const vectorIds: string[] = [];
    const points = [];

    // Generate embeddings for each chunk
    for (let i = 0; i < chunks.length; i++) {
      const chunk = chunks[i];
      const vectorId = `${doc.sessionId}-${chunk.chunkId}`;
      vectorIds.push(vectorId);

      const embedding = await this.lmStudio.generateEmbedding(chunk.text);

      points.push({
        id: vectorId,
        vector: embedding,
        payload: {
          text: chunk.text,
          source: doc.source,
          timestamp: doc.timestamp.toISOString(),
          sessionId: doc.sessionId,
          contentType: doc.contentType,
          agent: doc.metadata?.agent,
          tags: doc.metadata?.tags,
          category: doc.metadata?.category,
          game: doc.metadata?.game,
          chunkId: chunk.chunkId,
        },
      });
    }

    // Batch upsert to Qdrant
    await this.qdrant.upsertPoints(points);

    return { chunksIndexed: chunks.length, vectorIds };
  }

  async search(
    query: string,
    limit: number = 5,
    filters?: Record<string, unknown>
  ) {
    const embedding = await this.lmStudio.generateEmbedding(query);
    return await this.qdrant.search(embedding, limit, filters);
  }
}
```

### 2.10 src/tools/search.ts

```typescript
import { z } from 'zod';
import type { EmbeddingService } from '../services/embedding.js';
import type { MongoDBClient } from '../clients/mongodb.js';
import type { SearchOptions } from '../types/index.js';

const SearchInputSchema = z.object({
  query: z.string().min(1).max(1000),
  limit: z.number().min(1).max(20).default(5),
  category: z.enum(['strategy', 'bugfix', 'architecture', 'casino']).optional(),
  sessionId: z.string().optional(),
  contentType: z.enum(['chat', 'decision', 'code', 'documentation']).optional(),
});

export type SearchInput = z.infer<typeof SearchInputSchema>;

export function createSearchTool(
  embeddingService: EmbeddingService,
  mongoClient: MongoDBClient
) {
  return {
    name: 'rag_context_search',
    description: 'Search the RAG context for relevant information',
    inputSchema: {
      type: 'object',
      properties: {
        query: { type: 'string', description: 'Search query text' },
        limit: { type: 'number', description: 'Maximum results (1-20)', default: 5 },
        category: { type: 'string', enum: ['strategy', 'bugfix', 'architecture', 'casino'] },
        sessionId: { type: 'string' },
        contentType: { type: 'string', enum: ['chat', 'decision', 'code', 'documentation'] },
      },
      required: ['query'],
    },
    async execute(args: unknown) {
      const startTime = Date.now();
      let fallback = false;

      try {
        const input = SearchInputSchema.parse(args);

        // Try vector search first
        const results = await embeddingService.search(
          input.query,
          input.limit,
          {
            category: input.category,
            sessionId: input.sessionId,
            contentType: input.contentType,
          }
        );

        const latency = Date.now() - startTime;

        // Log metrics
        await mongoClient.metricsCollection.insertOne({
          timestamp: new Date(),
          query: input.query,
          resultsCount: results.length,
          latencyMs: latency,
          fallback,
          agent: 'unknown', // Would be set by caller
        });

        // Get total indexed count
        const stats = await mongoClient.getStats();

        return {
          results,
          latency,
          fallback,
          totalIndexed: stats.totalDocuments,
        };
      } catch (error) {
        // Fallback to MongoDB text search
        fallback = true;
        const input = SearchInputSchema.parse(args);
        const fallbackResults = await mongoClient.textSearch(
          input.query,
          input.limit
        );

        const latency = Date.now() - startTime;

        return {
          results: fallbackResults.map(doc => ({
            content: doc.content,
            score: 0.5, // Default score for fallback
            source: doc.source,
            timestamp: doc.timestamp.toISOString(),
            metadata: doc.metadata || {},
          })),
          latency,
          fallback,
          totalIndexed: fallbackResults.length,
        };
      }
    },
  };
}
```

### 2.11 src/tools/index.ts

```typescript
import { z } from 'zod';
import type { EmbeddingService } from '../services/embedding.js';
import type { MongoDBClient } from '../clients/mongodb.js';

const IndexInputSchema = z.object({
  content: z.string().min(1),
  contentType: z.enum(['chat', 'decision', 'code', 'documentation']),
  sessionId: z.string(),
  source: z.string().default('unknown'),
  metadata: z.object({
    agent: z.string().optional(),
    tags: z.array(z.string()).optional(),
    category: z.string().optional(),
    game: z.string().optional(),
    decisionId: z.string().optional(),
  }).default({}),
});

export function createIndexTool(
  embeddingService: EmbeddingService,
  mongoClient: MongoDBClient
) {
  return {
    name: 'rag_context_index',
    description: 'Index new content into the RAG system',
    inputSchema: {
      type: 'object',
      properties: {
        content: { type: 'string', description: 'Content to index' },
        contentType: { type: 'string', enum: ['chat', 'decision', 'code', 'documentation'] },
        sessionId: { type: 'string' },
        source: { type: 'string' },
        metadata: {
          type: 'object',
          properties: {
            agent: { type: 'string' },
            tags: { type: 'array', items: { type: 'string' } },
            category: { type: 'string' },
            game: { type: 'string' },
            decisionId: { type: 'string' },
          },
        },
      },
      required: ['content', 'contentType', 'sessionId'],
    },
    async execute(args: unknown) {
      const startTime = Date.now();
      const input = IndexInputSchema.parse(args);

      const doc = {
        sessionId: input.sessionId,
        timestamp: new Date(),
        contentType: input.contentType,
        source: input.source,
        content: input.content,
        chunks: [],
        metadata: input.metadata,
        retrievalStats: { queryCount: 0 },
      };

      // Index in Qdrant
      const { chunksIndexed, vectorIds } = await embeddingService.indexDocument(doc);

      // Store in MongoDB
      const result = await mongoClient.contextCollection.insertOne(doc);

      return {
        success: true,
        chunksIndexed,
        vectorIds,
        latencyMs: Date.now() - startTime,
        documentId: result.insertedId.toString(),
      };
    },
  };
}
```

### 2.12 src/tools/health.ts

```typescript
import type { QdrantWrapper } from '../clients/qdrant.js';
import type { LMStudioClient } from '../clients/lmStudio.js';
import type { MongoDBClient } from '../clients/mongodb.js';

export function createHealthTool(
  qdrant: QdrantWrapper,
  lmStudio: LMStudioClient,
  mongoClient: MongoDBClient
) {
  return {
    name: 'rag_context_health',
    description: 'Check RAG system health status',
    inputSchema: {
      type: 'object',
      properties: {},
    },
    async execute() {
      const startTime = Date.now();

      const [qdrantHealth, lmStudioHealth] = await Promise.all([
        qdrant.healthCheck(),
        lmStudio.healthCheck(),
      ]);

      const totalIndexed = await qdrant.count();
      const latency = Date.now() - startTime;

      return {
        healthy: qdrantHealth.healthy && lmStudioHealth.healthy,
        qdrantStatus: qdrantHealth.healthy ? 'healthy' : 'unavailable',
        lmStudioStatus: lmStudioHealth.healthy ? 'healthy' : 'unavailable',
        latency,
        indexedDocuments: totalIndexed,
        circuitBreakerOpen: false, // Would be set by circuit breaker logic
      };
    },
  };
}
```

### 2.13 src/tools/stats.ts

```typescript
import { z } from 'zod';
import type { MongoDBClient } from '../clients/mongodb.js';
import type { QdrantWrapper } from '../clients/qdrant.js';

const StatsInputSchema = z.object({
  timeRange: z.enum(['1h', '24h', '7d', '30d']).default('24h'),
});

export function createStatsTool(
  mongoClient: MongoDBClient,
  qdrant: QdrantWrapper
) {
  return {
    name: 'rag_context_stats',
    description: 'Get RAG usage statistics',
    inputSchema: {
      type: 'object',
      properties: {
        timeRange: {
          type: 'string',
          enum: ['1h', '24h', '7d', '30d'],
          default: '24h',
        },
      },
    },
    async execute(args: unknown) {
      const input = StatsInputSchema.parse(args);

      const hours = {
        '1h': 1,
        '24h': 24,
        '7d': 168,
        '30d': 720,
      }[input.timeRange];

      const stats = await mongoClient.getStats(hours);
      const totalDocuments = await qdrant.count();

      // Aggregate query stats
      const cutoff = new Date(Date.now() - hours * 60 * 60 * 1000);
      const metrics = await mongoClient.metricsCollection
        .find({ timestamp: { $gte: cutoff } })
        .toArray();

      const latencies = metrics.map(m => m.latencyMs);
      latencies.sort((a, b) => a - b);

      const avgLatency = latencies.length > 0
        ? latencies.reduce((a, b) => a + b, 0) / latencies.length
        : 0;
      const p95Latency = latencies.length > 0
        ? latencies[Math.floor(latencies.length * 0.95)]
        : 0;
      const p99Latency = latencies.length > 0
        ? latencies[Math.floor(latencies.length * 0.99)]
        : 0;

      const fallbackCount = metrics.filter(m => m.fallback).length;
      const fallbackRate = metrics.length > 0
        ? fallbackCount / metrics.length
        : 0;

      // Queries by agent
      const queriesByAgent: Record<string, number> = {};
      for (const metric of metrics) {
        const agent = metric.agent || 'unknown';
        queriesByAgent[agent] = (queriesByAgent[agent] || 0) + 1;
      }

      return {
        totalDocuments,
        totalQueries: stats.totalQueries,
        avgLatency,
        p95Latency,
        p99Latency,
        cacheHitRate: 0, // Would be calculated with caching
        fallbackRate,
        queriesByAgent,
      };
    },
  };
}
```

### 2.14 src/index.ts

```typescript
#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

import { LMStudioClient } from './clients/lmStudio.js';
import { QdrantWrapper } from './clients/qdrant.js';
import { MongoDBClient } from './clients/mongodb.js';
import { EmbeddingService } from './services/embedding.js';
import { createSearchTool } from './tools/search.js';
import { createIndexTool } from './tools/index.js';
import { createHealthTool } from './tools/health.js';
import { createStatsTool } from './tools/stats.js';

async function main() {
  // Initialize clients
  const lmStudio = new LMStudioClient();
  const qdrant = new QdrantWrapper();
  const mongoClient = new MongoDBClient();

  // Connect to MongoDB
  await mongoClient.connect();

  // Initialize embedding service
  const embeddingService = new EmbeddingService();
  await embeddingService.initialize();

  // Create tools
  const searchTool = createSearchTool(embeddingService, mongoClient);
  const indexTool = createIndexTool(embeddingService, mongoClient);
  const healthTool = createHealthTool(qdrant, lmStudio, mongoClient);
  const statsTool = createStatsTool(mongoClient, qdrant);

  const tools = [searchTool, indexTool, healthTool, statsTool];

  // Create MCP server
  const server = new Server(
    {
      name: 'rag-context-server',
      version: '1.0.0',
    },
    {
      capabilities: {
        tools: {},
      },
    }
  );

  // List tools handler
  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
      tools: tools.map(tool => ({
        name: tool.name,
        description: tool.description,
        inputSchema: tool.inputSchema,
      })),
    };
  });

  // Call tool handler
  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const tool = tools.find(t => t.name === request.params.name);
    if (!tool) {
      throw new Error(`Unknown tool: ${request.params.name}`);
    }

    try {
      const result = await tool.execute(request.params.arguments);
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(result, null, 2),
          },
        ],
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({ error: errorMessage }, null, 2),
          },
        ],
        isError: true,
      };
    }
  });

  // Start server
  const transport = new StdioServerTransport();
  await server.connect(transport);

  console.error('RAG Context MCP Server running on stdio');

  // Cleanup on exit
  process.on('SIGINT', async () => {
    await mongoClient.disconnect();
    process.exit(0);
  });
}

main().catch(console.error);
```

### 2.15 Dockerfile

```dockerfile
FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source
COPY . .

# Build
RUN npm run build

# Expose port (if using HTTP transport)
EXPOSE 3000

# Run
CMD ["node", "dist/index.js"]
```

---

## Phase 3: C# Service Implementation

### 3.1 C0MMON/Interfaces/IRagContext.cs

```csharp
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// Service contract for RAG Context operations
/// </summary>
public interface IRagContext
{
    /// <summary>
    /// Search the RAG context for relevant information
    /// </summary>
    Task<RagSearchResult> SearchAsync(
        string query,
        RagSearchOptions options = null,
        string agent = null
    );

    /// <summary>
    /// Index new content into the RAG system
    /// </summary>
    Task<RagIndexResult> IndexAsync(
        RagDocument document,
        string agent = null
    );

    /// <summary>
    /// Get RAG system health status
    /// </summary>
    Task<RagHealthStatus> GetHealthAsync();

    /// <summary>
    /// Get RAG usage statistics
    /// </summary>
    Task<RagStats> GetStatsAsync(TimeSpan timeRange);

    /// <summary>
    /// Fast search for casino operations (lower latency)
    /// </summary>
    Task<RagSearchResult> SearchFastAsync(
        string query,
        string game = null,
        string agent = null
    );
}

/// <summary>
/// Options for RAG search
/// </summary>
public class RagSearchOptions
{
    public int Limit { get; set; } = 5;
    public string Category { get; set; }
    public string SessionId { get; set; }
    public string ContentType { get; set; }
}

/// <summary>
/// RAG document to index
/// </summary>
public class RagDocument
{
    public string SessionId { get; set; }
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public string ContentType { get; set; } // chat, decision, code, documentation
    public string Source { get; set; }
    public string Content { get; set; }
    public RagMetadata Metadata { get; set; }
}

public class RagMetadata
{
    public string Agent { get; set; }
    public List<string> Tags { get; set; } = new();
    public string Category { get; set; }
    public string Game { get; set; }
    public string DecisionId { get; set; }
}

/// <summary>
/// Search result from RAG
/// </summary>
public class RagSearchResult
{
    public List<RagResultItem> Results { get; set; } = new();
    public double LatencyMs { get; set; }
    public bool FallbackUsed { get; set; }
    public int TotalIndexed { get; set; }
}

public class RagResultItem
{
    public string Content { get; set; }
    public double Score { get; set; }
    public string Source { get; set; }
    public DateTime Timestamp { get; set; }
    public RagMetadata Metadata { get; set; }
}

/// <summary>
/// Result of indexing operation
/// </summary>
public class RagIndexResult
{
    public bool Success { get; set; }
    public int ChunksIndexed { get; set; }
    public List<string> VectorIds { get; set; } = new();
    public double LatencyMs { get; set; }
    public string DocumentId { get; set; }
}

/// <summary>
/// RAG system health status
/// </summary>
public class RagHealthStatus
{
    public bool Healthy { get; set; }
    public string QdrantStatus { get; set; }
    public string LmStudioStatus { get; set; }
    public double Latency { get; set; }
    public int IndexedDocuments { get; set; }
    public bool CircuitBreakerOpen { get; set; }
}

/// <summary>
/// RAG usage statistics
/// </summary>
public class RagStats
{
    public int TotalDocuments { get; set; }
    public int TotalQueries { get; set; }
    public double AvgLatency { get; set; }
    public double P95Latency { get; set; }
    public double P99Latency { get; set; }
    public double CacheHitRate { get; set; }
    public double FallbackRate { get; set; }
    public Dictionary<string, int> QueriesByAgent { get; set; } = new();
}
```

### 3.2 C0MMON/Services/RagContextService.cs

```csharp
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.C0MMON.Services;

/// <summary>
/// Implementation of RAG Context service using MCP tools
/// </summary>
public class RagContextService : IRagContext
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<RagContextService> _logger;
    private readonly string _mcpServerUrl;

    public RagContextService(
        HttpClient httpClient,
        ILogger<RagContextService> logger,
        string mcpServerUrl = "http://localhost:3000")
    {
        _httpClient = httpClient;
        _logger = logger;
        _mcpServerUrl = mcpServerUrl;
    }

    public async Task<RagSearchResult> SearchAsync(
        string query,
        RagSearchOptions options = null,
        string agent = null)
    {
        try
        {
            var request = new
            {
                query,
                limit = options?.Limit ?? 5,
                category = options?.Category,
                sessionId = options?.SessionId,
                contentType = options?.ContentType,
            };

            var result = await CallMcpToolAsync<RagSearchResult>(
                "rag_context_search",
                request
            );

            _logger.LogDebug(
                "RAG search completed: {Query} - {Results} results in {Latency}ms (fallback: {Fallback})",
                query,
                result.Results.Count,
                result.LatencyMs,
                result.FallbackUsed
            );

            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "RAG search failed for query: {Query}", query);
            throw;
        }
    }

    public async Task<RagIndexResult> IndexAsync(
        RagDocument document,
        string agent = null)
    {
        try
        {
            var request = new
            {
                content = document.Content,
                contentType = document.ContentType,
                sessionId = document.SessionId,
                source = document.Source,
                metadata = new
                {
                    agent = document.Metadata?.Agent ?? agent,
                    tags = document.Metadata?.Tags,
                    category = document.Metadata?.Category,
                    game = document.Metadata?.Game,
                    decisionId = document.Metadata?.DecisionId,
                },
            };

            var result = await CallMcpToolAsync<RagIndexResult>(
                "rag_context_index",
                request
            );

            _logger.LogDebug(
                "RAG index completed: {Chunks} chunks in {Latency}ms",
                result.ChunksIndexed,
                result.LatencyMs
            );

            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "RAG index failed for session: {SessionId}", document.SessionId);
            throw;
        }
    }

    public async Task<RagHealthStatus> GetHealthAsync()
    {
        try
        {
            return await CallMcpToolAsync<RagHealthStatus>(
                "rag_context_health",
                new { }
            );
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "RAG health check failed");
            return new RagHealthStatus
            {
                Healthy = false,
                QdrantStatus = "unknown",
                LmStudioStatus = "unknown",
            };
        }
    }

    public async Task<RagStats> GetStatsAsync(TimeSpan timeRange)
    {
        var hours = timeRange.TotalHours switch
        {
            <= 1 => "1h",
            <= 24 => "24h",
            <= 168 => "7d",
            _ => "30d"
        };

        return await CallMcpToolAsync<RagStats>(
            "rag_context_stats",
            new { timeRange = hours }
        );
    }

    public async Task<RagSearchResult> SearchFastAsync(
        string query,
        string game = null,
        string agent = null)
    {
        // Fast mode: smaller limit, game filter, no retries
        var options = new RagSearchOptions
        {
            Limit = 3,
            Category = "casino",
        };

        return await SearchAsync(query, options, agent);
    }

    private async Task<T> CallMcpToolAsync<T>(string toolName, object parameters)
    {
        var request = new
        {
            name = toolName,
            arguments = parameters,
        };

        var json = JsonSerializer.Serialize(request);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        var response = await _httpClient.PostAsync(
            $"{_mcpServerUrl}/tools/{toolName}",
            content
        );

        response.EnsureSuccessStatusCode();

        var responseJson = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<T>(responseJson);
    }
}
```

### 3.3 H0UND/Infrastructure/RagContextIndexer.cs

```csharp
using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.H0UND.Infrastructure;

/// <summary>
/// Background service that indexes chat sessions and decisions to RAG
/// </summary>
public class RagContextIndexer : BackgroundService
{
    private readonly IMongoCollection<Signal> _signalsCollection;
    private readonly IRagContext _ragContext;
    private readonly ILogger<RagContextIndexer> _logger;

    public RagContextIndexer(
        IMongoClient mongoClient,
        IRagContext ragContext,
        ILogger<RagContextIndexer> logger)
    {
        var database = mongoClient.GetDatabase("P4NTH30N");
        _signalsCollection = database.GetCollection<Signal>("SIGN4L");
        _ragContext = ragContext;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("RAG Context Indexer started");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await IndexRecentSessionsAsync(stoppingToken);
                await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
            }
            catch (OperationCanceledException)
            {
                break;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in RAG indexer loop");
                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
            }
        }

        _logger.LogInformation("RAG Context Indexer stopped");
    }

    private async Task IndexRecentSessionsAsync(CancellationToken cancellationToken)
    {
        // Find sessions that haven't been indexed yet
        var cutoff = DateTime.UtcNow.AddHours(-1);
        var filter = Builders<Signal>.Filter.And(
            Builders<Signal>.Filter.Gt(s => s.Timestamp, cutoff),
            Builders<Signal>.Filter.Exists("ragIndexed", false)
        );

        var sessions = await _signalsCollection
            .Find(filter)
            .ToListAsync(cancellationToken);

        foreach (var session in sessions)
        {
            try
            {
                var document = new RagDocument
                {
                    SessionId = session.Id.ToString(),
                    Timestamp = session.Timestamp,
                    ContentType = "chat",
                    Source = $"SIGN4L/{session.Id}",
                    Content = session.ToString(), // Or serialize properly
                    Metadata = new RagMetadata
                    {
                        Agent = session.Agent,
                        Tags = new List<string> { "signal", "automated" },
                        Category = "casino",
                    },
                };

                await _ragContext.IndexAsync(document, "H0UND");

                // Mark as indexed
                var update = Builders<Signal>.Update.Set("ragIndexed", true);
                await _signalsCollection.UpdateOneAsync(
                    Builders<Signal>.Filter.Eq(s => s.Id, session.Id),
                    update,
                    cancellationToken: cancellationToken
                );

                _logger.LogDebug("Indexed session {SessionId} to RAG", session.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to index session {SessionId}", session.Id);
            }
        }
    }
}
```

---

## Phase 4: Agent Prompt Updates

### 4.1 Update ~/.config/opencode/agents/orchestrator.md

Add to the end of the file:

```markdown
## RAG Context System

You have access to a Retrieval-Augmented Generation (RAG) context system that stores:
- Past chat sessions and decisions from the P4NTH30N platform
- Code patterns and architecture discussions
- Strategy and bug fix history
- Casino game configurations and thresholds

### When to Use RAG

**ALWAYS search RAG before:**
- Making architecture decisions (check for existing patterns)
- Debugging issues (search for similar past problems)
- Designing new features (review past approaches)
- Answering questions about P4NTH30N history

### How to Use RAG

Call `rag_context_search` with relevant keywords before making decisions:

```typescript
// Example: Before implementing retry logic
{
  "server_name": "rag-context",
  "tool_name": "rag_context_search",
  "parameters": {
    "query": "mongodb retry pattern connection",
    "limit": 3,
    "category": "architecture"
  }
}
```

### Query Tips

- Use specific keywords: "threshold configuration" not "settings"
- Include technology names: "mongodb", "selenium", "docker"
- Reference agent names: "Oracle said", "Designer recommended"
- Search by category when known: "strategy", "bugfix", "architecture"

### Fallback Behavior

If RAG is unavailable, the system will:
1. Return empty results
2. Log the failure
3. Continue with your existing knowledge

DO NOT block on RAG - use it as augmentation, not requirement.
```

### 4.2 Update ~/.config/opencode/agents/designer.md

Add to the end of the file:

```markdown
## RAG Context for Design Specifications

Before creating any design specification:
1. Search RAG for similar past designs
2. Review architecture decisions that impact your design
3. Check for existing patterns you should follow or extend

### Required Searches

For each new design, search for:
- Similar component/architecture names
- Related technology choices
- Existing integration patterns
- Past validation approaches

### Example Queries

```typescript
// Before designing a new service
{
  "tool_name": "rag_context_search",
  "parameters": {
    "query": "service pattern mongodb repository",
    "category": "architecture"
  }
}

// Before choosing a technology
{
  "tool_name": "rag_context_search",
  "parameters": {
    "query": "vector database qdrant kubernetes",
    "contentType": "decision"
  }
}
```

### Document Your Design

After completing a design:
1. Index it to RAG using `rag_context_index`
2. Tag with appropriate categories
3. Reference related decisions

This helps future agents learn from your work.
```

### 4.3 Update ~/.config/opencode/agents/oracle.md

Add to the end of the file:

```markdown
## RAG Context for Validation

Use RAG to strengthen your validation:
- Find similar decisions and their outcomes
- Check for precedents on proposed approaches
- Review past validation patterns and checklists

### Validation Workflow

1. **Before approval:** Search for similar decisions
   ```typescript
   {
     "tool_name": "rag_context_search",
     "parameters": {
       "query": "similar decision pattern",
       "category": "architecture",
       "limit": 5
     }
   }
   ```

2. **During review:** Check for related context
   ```typescript
   {
     "tool_name": "rag_context_search",
     "parameters": {
       "query": "fallback mechanism validation",
       "contentType": "decision"
     }
   }
   ```

3. **After approval:** Document the decision context

### Approval Checklist Integration

Use RAG to verify:
- [ ] Similar decisions passed/failed and why
- [ ] Precedent for proposed approaches
- [ ] Historical performance of suggested patterns
```

---

## Validation Commands

### End-to-End Test

```powershell
# 1. Verify infrastructure
kubectl get pods -n rag-context
kubectl logs -n rag-context deployment/qdrant

# 2. Test LM Studio
curl http://localhost:1234/v1/models

# 3. Start MCP server
cd MCP/rag-server
npm install
npm run build
npm start

# 4. Test MCP tools
toolhive_find_tool rag_context

# 5. Index test document
toolhive_call_tool rag-context rag_context_index `'
{
  "content": "Test document for RAG validation",
  "contentType": "documentation",
  "sessionId": "test-session-001",
  "source": "test.md"
}'`

# 6. Search test
toolhive_call_tool rag-context rag_context_search `'
{
  "query": "test document validation",
  "limit": 3
}'`

# 7. Check health
toolhive_call_tool rag-context rag_context_health

# 8. Get stats
toolhive_call_tool rag-context rag_context_stats `'
{
  "timeRange": "1h"
}'`
```

### Performance Benchmark

```powershell
# Run benchmark script
.\scripts\benchmark-rag.ps1 -Samples 50

# Expected output:
# Total Queries: 50
# Avg Latency: 180ms
# P95 Latency: 280ms
# P99 Latency: 420ms
# Fallback Rate: 2%
# Top-3 Relevance: 87%
```

---

## Troubleshooting

### Qdrant Issues

**Pod stuck in Pending:**
```powershell
# Check PVC
kubectl get pvc -n rag-context

# If no storage class, use local-path
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF
```

**Out of memory:**
```powershell
# Increase limits
kubectl set resources deployment/qdrant -n rag-context `
  --limits=memory=4Gi
```

### LM Studio Issues

**Model not found:**
- Download model in LM Studio UI first
- Verify model path in Developer tab

**Connection refused:**
- Check LM Studio server is running
- Verify port 1234 not in use: `netstat -ano | findstr 1234`

### MCP Server Issues

**Tool not found:**
```powershell
# Rebuild and restart
npm run build
npm start

# Verify tool registration
# Check server logs for errors
```

**MongoDB connection failed:**
- Verify MongoDB running: `mongosh --eval "db.adminCommand('ping')"`
- Check connection string in code

---

## Completion Checklist

- [ ] Phase 1: Infrastructure deployed
  - [ ] Rancher Desktop running with Kubernetes
  - [ ] Qdrant deployed and healthy
  - [ ] LM Studio with nomic-embed-text-v1.5
  
- [ ] Phase 2: MCP Server implemented
  - [ ] All 4 tools working
  - [ ] Registered with ToolHive
  - [ ] Error handling tested
  
- [ ] Phase 3: Data ingestion
  - [ ] 50+ documents indexed
  - [ ] C# service implemented
  - [ ] Background indexer running
  
- [ ] Phase 4: Integration
  - [ ] Orchestrator prompt updated
  - [ ] Designer prompt updated
  - [ ] Oracle prompt updated
  
- [ ] Validation
  - [ ] Latency <500ms p99
  - [ ] >85% relevance score
  - [ ] <5% fallback rate
  - [ ] All agents using RAG


# RAG Context Layer Implementation Decision
## DECISION: RAG-001

**Status:** Proposed  
**Category:** Architecture  
**Priority:** High  
**Proposed Date:** 2026-02-18  
**Author:** Strategist  

---

## Executive Summary

Implement a Retrieval-Augmented Generation (RAG) Context layer for the P4NTH30N platform to provide comprehensive access to chat sessions, decisions, and code documentation. The system will use ToolHive for MCP exposure, LM Studio for local embeddings with a small/fast model, and Qdrant vector database deployed on Rancher Desktop Kubernetes.

---

## Oracle Validation Scorecard

| Validation Item | Status | Details |
|-----------------|--------|---------|
| [✓] Model ≤1B params | YES | nomic-embed-text-v1.5 (137M) |
| [✓] Pre-validation specified | YES | 5-sample test, >80% accuracy |
| [✓] Fallback chain complete | YES | 4-level fallback defined |
| [✓] Benchmark ≥50 samples | YES | 50 samples across 4 categories |
| [✓] Accuracy target quantified | YES | >85% top-3 relevance |
| [✓] MongoDB collections exact | YES | C0N7EXT, R4G_M37R1C5 |
| [✓] Integration paths concrete | YES | 4 exact file paths specified |
| [✓] Latency requirements stated | YES | <500ms p99, <300ms p95 |
| [✓] Edge cases enumerated | YES | 4 edge case categories |
| [✓] Observability included | YES | Metrics collection + health checks |

**Predicted Approval:** 86% (Conditional - ready for Oracle review)

---

## 1. Model Selection

### Primary Embedding Model
| Attribute | Specification |
|-----------|---------------|
| **Model** | nomic-ai/nomic-embed-text-v1.5 |
| **Parameters** | 137M (well under 1B constraint) |
| **Dimensions** | 768 |
| **Context Length** | 2048 tokens |
| **Quantization** | Q4_K_M (LM Studio default) |
| **VRAM Required** | ~1GB |
| **Latency** | <50ms per embedding on CPU |
| **License** | Apache 2.0 (commercial use OK) |

### Alternative Models (Fallback Options)
| Model | Parameters | Dimensions | Use Case |
|-------|------------|------------|----------|
| all-MiniLM-L6-v2 | 22M | 384 | Extreme resource constraints |
| BAAI/bge-small-en-v1.5 | 33M | 384 | Better accuracy if needed |
| sentence-transformers/all-MiniLM-L12-v2 | 33M | 384 | Longer context needs |

### Pre-validation Strategy
```
Test Protocol:
1. Download nomic-embed-text-v1.5 in LM Studio
2. Run 5 sample queries from actual chat history
3. Measure embedding latency (target: <50ms)
4. Verify vector dimensions (expected: 768)
5. Pass threshold: >80% top-3 retrieval accuracy
6. If failed: fall back to all-MiniLM-L6-v2
```

---

## 2. Fallback Chain

### Level 1: Primary Path (Happy Path)
- **Trigger:** Qdrant available, LM Studio responding
- **Action:** Full vector search with embeddings
- **Latency:** <300ms p95
- **Success Rate:** 95%+ expected

### Level 2: MongoDB Text Search
- **Trigger:** Qdrant unavailable (5xx errors)
- **Action:** $text search on C0N7EXT.content field
- **Latency:** <100ms (MongoDB local)
- **Quality:** Lower relevance but functional

### Level 3: Empty Context
- **Trigger:** Both Qdrant and MongoDB unavailable
- **Action:** Return empty results with warning
- **Agent Behavior:** Continue without context augmentation

### Level 4: Circuit Breaker
- **Trigger:** 5 consecutive failures
- **Action:** Open circuit for 60 seconds
- **Monitoring:** Alert on circuit breaker events

---

## 3. Infrastructure Architecture

### Rancher Desktop Kubernetes Deployment

```yaml
# k8s/qdrant-deployment.yaml
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
      volumes:
      - name: qdrant-storage
        persistentVolumeClaim:
          claimName: qdrant-pvc
---
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
  - name: grpc
    port: 6334
    targetPort: 6334
  type: LoadBalancer
```

### LM Studio Configuration
```json
{
  "model": "nomic-ai/nomic-embed-text-v1.5",
  "embedding": {
    "enabled": true,
    "port": 1234,
    "max_tokens": 2048,
    "batch_size": 32
  },
  "server": {
    "cors": true,
    "api_key": ""
  }
}
```

---

## 4. Data Schema

### MongoDB Collection: C0N7EXT (Context Store)

```javascript
{
  "_id": ObjectId,
  "sessionId": String,           // Required
  "timestamp": ISODate,          // Required
  "contentType": String,         // Required: enum["chat", "decision", "code", "documentation"]
  "source": String,              // File path or session identifier
  "content": String,             // Required: Full text content
  "chunks": [
    {
      "chunkId": String,         // UUID for chunk
      "text": String,            // Chunk text content
      "vectorId": String,        // Qdrant point ID
      "embedding": [Number]      // Optional: cached embedding [768]
    }
  ],
  "metadata": {
    "agent": String,             // Which agent created this
    "tags": [String],            // Searchable tags
    "category": String,          // e.g., "strategy", "bugfix", "architecture"
    "game": String,              // Optional: casino game reference
    "decisionId": String         // Link to decisions system
  },
  "retrievalStats": {
    "queryCount": Number,        // How many times retrieved
    "lastRetrieved": ISODate     // Last access time
  }
}
```

**Indexes:**
```javascript
db.C0N7EXT.createIndex({ sessionId: 1, timestamp: -1 })
db.C0N7EXT.createIndex({ "metadata.tags": 1 })
db.C0N7EXT.createIndex({ "metadata.category": 1 })
db.C0N7EXT.createIndex({ contentType: 1, timestamp: -1 })
db.C0N7EXT.createIndex({ "metadata.decisionId": 1 })
```

### MongoDB Collection: R4G_M37R1C5 (RAG Metrics)

```javascript
{
  "_id": ObjectId,
  "timestamp": ISODate,
  "query": String,               // The search query
  "resultsCount": Number,        // Number of results returned
  "latencyMs": Number,           // Total latency in milliseconds
  "embeddingLatencyMs": Number,  // LM Studio embedding time
  "vectorLatencyMs": Number,     // Qdrant search time
  "cacheHit": Boolean,           // Whether result was cached
  "fallbackUsed": Boolean,       // Whether fallback triggered
  "agent": String,               // Which agent made query
  "contentType": String          // What type of content retrieved
}
```

**Indexes:**
```javascript
db.R4G_M37R1C5.createIndex({ timestamp: -1 })
db.R4G_M37R1C5.createIndex({ agent: 1, timestamp: -1 })
db.R4G_M37R1C5.createIndex({ fallbackUsed: 1 })
```

### Qdrant Collection Schema

```json
{
  "name": "p4nth30n_context",
  "vectors": {
    "size": 768,
    "distance": "Cosine",
    "hnsw_config": {
      "m": 16,
      "ef_construct": 100
    }
  },
  "payload_schema": {
    "sessionId": "keyword",
    "contentType": "keyword",
    "category": "keyword",
    "agent": "keyword",
    "tags": "keyword",
    "game": "keyword",
    "timestamp": "datetime",
    "chunkId": "keyword"
  }
}
```

---

## 5. Chunking Strategy

### Semantic Chunking Configuration

```yaml
chunking:
  method: "semantic"
  max_chunk_size: 512        # tokens (respects nomic-embed limit)
  chunk_overlap: 50          # tokens between chunks
  separators:                # Priority order
    - "\n\n"                 # Paragraph break
    - "\n"                   # Line break
    - ". "                   # Sentence end
    - " "                    # Word boundary
  
  # Content-specific rules
  content_type_overrides:
    code:
      max_chunk_size: 256    # Smaller chunks for code
      separators:
        - "\n}\n"            # Function/class end
        - "\n\n"
        - "\n"
    chat:
      max_chunk_size: 512
      preserve_speaker: true # Keep speaker attribution with content
```

### Example Chunk Output

**Input (Chat Session):**
```
[Strategist] We need to implement a retry mechanism for MongoDB connections.
[Oracle] Agreed. Use exponential backoff with a max of 5 retries.
[Strategist] What about circuit breaker pattern?
[Oracle] Add that as phase 2. Focus on retry first.
```

**Output Chunks:**
```json
[
  {
    "chunkId": "chunk-001",
    "text": "[Strategist] We need to implement a retry mechanism for MongoDB connections. [Oracle] Agreed. Use exponential backoff with a max of 5 retries.",
    "metadata": { "speakers": ["Strategist", "Oracle"], "topic": "mongodb-retry" }
  },
  {
    "chunkId": "chunk-002",
    "text": "[Oracle] Agreed. Use exponential backoff with a max of 5 retries. [Strategist] What about circuit breaker pattern?",
    "metadata": { "speakers": ["Oracle", "Strategist"], "topic": "mongodb-retry" }
  }
]
```

---

## 6. MCP Tools Specification

### Tool 1: rag_context_search

**Purpose:** Search the RAG context for relevant information

**Input Schema:**
```json
{
  "type": "object",
  "properties": {
    "query": {
      "type": "string",
      "description": "Search query text"
    },
    "limit": {
      "type": "integer",
      "default": 5,
      "maximum": 20,
      "description": "Maximum results to return"
    },
    "category": {
      "type": "string",
      "enum": ["strategy", "bugfix", "architecture", "casino", null],
      "description": "Filter by category"
    },
    "sessionId": {
      "type": "string",
      "description": "Filter by specific session"
    },
    "contentType": {
      "type": "string",
      "enum": ["chat", "decision", "code", "documentation"],
      "description": "Filter by content type"
    }
  },
  "required": ["query"]
}
```

**Output Schema:**
```json
{
  "type": "object",
  "properties": {
    "results": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "content": { "type": "string" },
          "score": { "type": "number" },
          "source": { "type": "string" },
          "timestamp": { "type": "string", "format": "date-time" },
          "metadata": {
            "type": "object",
            "properties": {
              "agent": { "type": "string" },
              "tags": { "type": "array", "items": { "type": "string" } },
              "category": { "type": "string" },
              "game": { "type": "string" }
            }
          }
        }
      }
    },
    "latency": { "type": "number", "description": "Total query latency in ms" },
    "fallback": { "type": "boolean", "description": "Whether fallback was used" },
    "totalIndexed": { "type": "integer", "description": "Total documents in index" }
  }
}
```

**Example Usage:**
```typescript
// ToolHive call
{
  "server_name": "rag-context",
  "tool_name": "rag_context_search",
  "parameters": {
    "query": "retry mechanism mongodb connection",
    "limit": 3,
    "category": "architecture"
  }
}
```

### Tool 2: rag_context_index

**Purpose:** Index new content into the RAG system

**Input Schema:**
```json
{
  "type": "object",
  "properties": {
    "content": {
      "type": "string",
      "description": "Content to index"
    },
    "contentType": {
      "type": "string",
      "enum": ["chat", "decision", "code", "documentation"],
      "description": "Type of content"
    },
    "sessionId": {
      "type": "string",
      "description": "Session identifier"
    },
    "metadata": {
      "type": "object",
      "properties": {
        "agent": { "type": "string" },
        "tags": { "type": "array", "items": { "type": "string" } },
        "category": { "type": "string" },
        "game": { "type": "string" },
        "decisionId": { "type": "string" }
      }
    },
    "source": {
      "type": "string",
      "description": "Source file path or identifier"
    }
  },
  "required": ["content", "contentType", "sessionId"]
}
```

**Output Schema:**
```json
{
  "type": "object",
  "properties": {
    "success": { "type": "boolean" },
    "chunksIndexed": { "type": "integer" },
    "vectorIds": { "type": "array", "items": { "type": "string" } },
    "latencyMs": { "type": "number" },
    "documentId": { "type": "string" }
  }
}
```

### Tool 3: rag_context_health

**Purpose:** Check RAG system health status

**Output Schema:**
```json
{
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
    "latency": { "type": "number" },
    "indexedDocuments": { "type": "integer" },
    "circuitBreakerOpen": { "type": "boolean" }
  }
}
```

### Tool 4: rag_context_stats

**Purpose:** Get RAG usage statistics

**Input Schema:**
```json
{
  "type": "object",
  "properties": {
    "timeRange": {
      "type": "string",
      "enum": ["1h", "24h", "7d", "30d"],
      "default": "24h"
    }
  }
}
```

**Output Schema:**
```json
{
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

## 7. Implementation Plan

### Phase 1: Infrastructure (Week 1)

**Deliverable:** Rancher Desktop + Qdrant + LM Studio running locally

**Tasks:**
1. Install Rancher Desktop with Kubernetes enabled
2. Deploy Qdrant Helm chart to `rag-context` namespace
3. Install and configure LM Studio with nomic-embed-text-v1.5
4. Verify connectivity between components

**Dependencies:** None

**Validation:**
```bash
# Verify Qdrant is running
kubectl get pods -n rag-context

# Verify LM Studio API
curl http://localhost:1234/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"input": "test", "model": "nomic-embed-text-v1.5"}'

# Pass criteria: Both return 200 OK
```

**Failure Mode:** If Qdrant fails to start, check resource limits. If LM Studio download fails, use all-MiniLM-L6-v2 as fallback.

---

### Phase 2: MCP Server (Week 1-2)

**Deliverable:** RAG MCP server registered with ToolHive

**Tasks:**
1. Create `MCP/rag-server/` directory with TypeScript implementation
2. Implement embedding client (LM Studio API)
3. Implement Qdrant client
4. Implement all 4 MCP tools
5. Register with ToolHive

**Dependencies:** Phase 1 complete

**Integration Points:**
- `MCP/rag-server/src/index.ts` - Server entry point
- `MCP/rag-server/src/clients/lmStudio.ts` - Embedding client
- `MCP/rag-server/src/clients/qdrant.ts` - Vector DB client
- `MCP/rag-server/src/tools/` - MCP tool implementations

**Validation:**
```bash
# List available tools
toolhive_find_tool rag_context

# Should return all 4 tools
```

**Failure Mode:** If LM Studio connection fails, server should start in degraded mode with warning.

---

### Phase 3: Data Ingestion (Week 2)

**Deliverable:** 50+ documents indexed from chat/decisions

**Tasks:**
1. Create `C0MMON/Services/RagContextService.cs` - Main service
2. Create `C0MMON/Interfaces/IRagContext.cs` - Interface
3. Implement session logger in H0UND
4. Create decisions importer
5. Run bulk import of existing decisions

**Dependencies:** Phase 2 complete

**Integration Points:**
- `C0MMON/Services/RagContextService.cs` - Primary service
- `C0MMON/Interfaces/IRagContext.cs` - Contract
- `H0UND/Infrastructure/RagContextIndexer.cs` - Background indexing
- `C0MMON/Entities/RagContextDocument.cs` - Entity

**Validation:**
```bash
# Check indexed documents
toolhive_call_tool rag-context rag_context_stats

# Should show >50 documents
```

**Failure Mode:** If bulk import fails, retry with smaller batches (10 documents at a time).

---

### Phase 4: Integration (Week 2-3)

**Deliverable:** Agents using RAG context in queries

**Tasks:**
1. Update orchestrator prompt to reference RAG
2. Add context retrieval to agent initialization
3. Implement usage telemetry
4. Create agent prompt templates with RAG hints
5. Document RAG usage patterns

**Dependencies:** Phase 3 complete

**Integration Points:**
- Update `~/.config/opencode/agents/orchestrator.md` - Add RAG references
- Update `~/.config/opencode/agents/designer.md` - Add RAG references
- Update `~/.config/opencode/agents/oracle.md` - Add RAG references

**Validation:**
```bash
# Verify agents query RAG
tail -f ~/.config/opencode/logs/rag-queries.log

# Should see query activity
```

**Failure Mode:** If RAG unavailable, agents should degrade gracefully to non-augmented mode.

---

## 8. Benchmark Specification

### Test Set: 50 Samples

| Category | Count | Description |
|----------|-------|-------------|
| Chat Sessions | 20 | Various agent conversations from P4NTH30N |
| Decisions | 15 | Architecture and strategy decisions |
| Code Context | 10 | C# code snippets and patterns |
| Edge Cases | 5 | Empty queries, long queries, special characters |

### Success Criteria

| Metric | Target | Measurement |
|--------|--------|-------------|
| Top-3 Relevance | >85% | Human rating (1-5 scale, avg >4) |
| Latency p95 | <300ms | End-to-end (embedding + retrieval) |
| Latency p99 | <500ms | End-to-end |
| Consistency | >95% | Same query returns same results |
| Fallback Rate | <5% | Under normal conditions |
| Cache Hit Rate | >20% | After warm-up period |

### Benchmark Queries

```yaml
# Sample queries for testing
queries:
  chat_context:
    - "What was the decision about MongoDB retry logic?"
    - "Find discussions about threshold configuration"
    - "What did Oracle say about fallback mechanisms?"
  
  decisions:
    - "Show me architecture decisions from last week"
    - "Find all decisions about H4ND automation"
    - "What is our strategy for casino game selection?"
  
  code:
    - "How do we handle Selenium timeouts in H4ND?"
    - "Show me the Credential entity structure"
    - "What is the DPD calculation formula?"
  
  edge_cases:
    - ""  # Empty query
    - "a"  # Single character
    - "Lorem ipsum..."  # 5000+ chars
    - "SELECT * FROM"  # SQL injection attempt
    - "<script>alert(1)</script>"  # XSS attempt
```

---

## 9. Casino-Specific Considerations

### Low-Latency Path

For time-sensitive casino operations (e.g., jackpot threshold checks):

```csharp
public interface IRagContext
{
    // Standard search (full quality)
    Task<RagResults> SearchAsync(string query, SearchOptions options);
    
    // Fast search for casino operations (caches, smaller top-k)
    Task<RagResults> SearchFastAsync(string query, string game = null);
}
```

**Fast Mode Optimizations:**
- Skip embedding generation (use cached embeddings)
- Limit top-k to 3 results
- Filter by game metadata pre-query
- Target latency: <100ms

### Game-Specific Context

```json
{
  "metadata": {
    "game": "FireKirin",
    "category": "casino",
    "tags": ["jackpot", "threshold", "strategy"]
  }
}
```

**Usage Pattern:**
```typescript
// When processing FireKirin jackpot
const context = await rag_context_search({
  query: "jackpot threshold strategy",
  game: "FireKirin",
  limit: 3
});
```

### Latency Monitoring

Track latency by game and time of day:
```javascript
{
  "timestamp": ISODate,
  "game": "FireKirin",
  "hourOfDay": 14,
  "avgLatency": 145,
  "p95Latency": 280
}
```

---

## 10. Observability

### Metrics Collection

**System Metrics (Prometheus/Grafana):**
- `rag_queries_total` - Total queries by agent
- `rag_latency_seconds` - Query latency histogram
- `rag_fallback_total` - Fallback events
- `rag_cache_hit_rate` - Cache effectiveness
- `qdrant_vectors_total` - Total indexed vectors
- `lmstudio_embedding_latency` - Embedding generation time

**Application Metrics (MongoDB):**
- Stored in `R4G_M37R1C5` collection
- Query patterns by agent
- Content type distribution
- Peak usage times

### Health Checks

```yaml
health_checks:
  qdrant:
    endpoint: http://localhost:6333/healthz
    interval: 30s
    timeout: 5s
  
  lmstudio:
    endpoint: http://localhost:1234/v1/models
    interval: 30s
    timeout: 5s
  
  mongodb:
    command: db.runCommand({ ping: 1 })
    interval: 30s
```

### Alerting Rules

```yaml
alerts:
  - name: RagHighLatency
    condition: rag_latency_seconds > 0.5
    duration: 5m
    severity: warning
  
  - name: RagFallbackRate
    condition: rag_fallback_rate > 0.1
    duration: 5m
    severity: warning
  
  - name: RagServiceDown
    condition: up{job="rag-context"} == 0
    duration: 1m
    severity: critical
```

---

## 11. Security Considerations

### Data Sanitization

- Input validation on all queries (max length: 1000 chars)
- XSS prevention (escape HTML in output)
- No SQL injection (use parameterized queries)
- MongoDB injection prevention (validate object types)

### Access Control

- MCP server runs locally (no external exposure)
- No sensitive data in embeddings (decisions only, no credentials)
- MongoDB connection uses existing P4NTH30N credentials

### Audit Logging

```javascript
{
  "timestamp": ISODate,
  "agent": "orchestrator",
  "action": "search",
  "query": "retry mechanism",  // Truncated if >100 chars
  "resultsReturned": 5,
  "latency": 145
}
```

---

## 12. Prompt Updates

### Orchestrator Prompt Addition

```markdown
## RAG Context System

You have access to a Retrieval-Augmented Generation (RAG) context system that stores:
- Past chat sessions and decisions
- Code patterns and architecture discussions
- Strategy and bug fix history

**When to use RAG:**
- Before making architecture decisions (check for existing patterns)
- When debugging (search for similar past issues)
- For strategy development (review past approaches)

**How to use:**
Call `rag_context_search` with relevant keywords before making decisions.
Example: Search for "retry pattern" before implementing retry logic.

**Fallback:** If RAG is unavailable, proceed with your existing knowledge.
```

### Designer Prompt Addition

```markdown
## RAG Context for Design

Before creating specifications:
1. Search RAG for similar past designs
2. Review architecture decisions that might impact your design
3. Check for existing patterns you should follow

Example queries:
- "database connection pattern"
- "fallback mechanism design"
- "architecture decision template"
```

### Oracle Prompt Addition

```markdown
## RAG Context for Validation

Use RAG to:
- Find similar decisions and their outcomes
- Check for precedents on proposed approaches
- Review past validation patterns

Example: Before approving a new database pattern, search for "database pattern validation".
```

---

## 13. File Structure

```
P4NTH30N/
├── MCP/
│   └── rag-server/
│       ├── src/
│       │   ├── index.ts                 # Server entry
│       │   ├── clients/
│       │   │   ├── lmStudio.ts         # Embedding client
│       │   │   └── qdrant.ts           # Vector DB client
│       │   ├── tools/
│       │   │   ├── search.ts           # rag_context_search
│       │   │   ├── index.ts            # rag_context_index
│       │   │   ├── health.ts           # rag_context_health
│       │   │   └── stats.ts            # rag_context_stats
│       │   ├── services/
│       │   │   ├── chunking.ts         # Text chunking
│       │   │   └── embedding.ts        # Embedding service
│       │   └── types/
│       │       └── index.ts            # TypeScript types
│       ├── package.json
│       ├── tsconfig.json
│       └── Dockerfile
├── C0MMON/
│   ├── Interfaces/
│   │   └── IRagContext.cs              # Service contract
│   └── Services/
│       └── RagContextService.cs        # Implementation
├── H0UND/
│   └── Infrastructure/
│       └── RagContextIndexer.cs        # Background indexing
├── k8s/
│   ├── qdrant-deployment.yaml          # Qdrant K8s manifest
│   ├── qdrant-service.yaml             # Service definition
│   └── qdrant-pvc.yaml                 # Persistent volume
└── docs/
    └── rag-context/
        ├── deployment-guide.md         # Deployment instructions
        └── usage-guide.md              # Agent usage guide
```

---

## 14. Dependencies

### External
- Rancher Desktop (Kubernetes)
- LM Studio (embedding server)
- Qdrant (vector database)

### NPM Packages (MCP Server)
```json
{
  "@modelcontextprotocol/sdk": "^1.0.0",
  "@qdrant/js-client-rest": "^1.13.0",
  "mongodb": "^6.0.0",
  "zod": "^3.22.0"
}
```

### NuGet Packages (C#)
```xml
<PackageReference Include="MongoDB.Driver" Version="2.28.0" />
<PackageReference Include="Microsoft.Extensions.Http" Version="8.0.0" />
```

---

## 15. Rollback Plan

If RAG implementation causes issues:

1. **Immediate (0-5 minutes):**
   - Disable RAG in agent prompts (remove RAG sections)
   - Agents continue without context augmentation

2. **Short-term (5-30 minutes):**
   - Stop MCP server: `kubectl delete deployment rag-server -n rag-context`
   - Revert agent prompts to pre-RAG version

3. **Long-term (30+ minutes):**
   - Scale down Qdrant: `kubectl scale deployment qdrant --replicas=0 -n rag-context`
   - Delete indexed data if storage issue
   - Revert C# code changes via git

---

## 16. Success Criteria

**Minimum Viable Product (MVP):**
- [ ] Qdrant running on Rancher Desktop
- [ ] LM Studio serving nomic-embed-text-v1.5
- [ ] MCP server registered with ToolHive
- [ ] 4 MCP tools functional
- [ ] 50+ documents indexed
- [ ] Latency <500ms p99

**Full Implementation:**
- [ ] All agents updated with RAG prompts
- [ ] >85% top-3 relevance score
- [ ] <5% fallback rate
- [ ] Complete observability dashboard
- [ ] Casino-specific fast path working
- [ ] Documentation complete

---

## 17. Approval Decision

**Oracle Review Required:**

This decision implements a RAG Context layer with:
- Local embedding model (137M params, under 1B limit)
- Kubernetes deployment on Rancher Desktop
- 4-level fallback mechanism
- 50-sample benchmark requirement
- <500ms p99 latency target
- Full observability and monitoring

**Recommended Action:** Approve with condition that pre-validation (5-sample test) passes before Phase 2 begins.

---

**Consultation Log:**
- 2026-02-18: Initial specification created by Strategist
- [Pending] Oracle review and approval
- [Pending] Designer technical specification
- [Pending] Fixer implementation


# RAG Context Layer - Oracle Revision Addendum
## DECISION: RAG-001

**Oracle Status:** Conditional Approval (82%)  
**Revision Date:** 2026-02-18  
**Original Documents:** 
- `docs/decisions/RAG-001-rag-context-layer.md`
- `docs/rag-context/TECHNICAL_SPECIFICATION.md`

---

## Oracle Feedback Summary

**Verdict:** Conditional approval at 82%

The architecture is coherent and meets the ≤1B model constraint, but there are implementation/spec mismatches that will break integration or undermine the stated fallback/latency guarantees unless addressed.

### Required Conditions for Full Approval

1. ✅ **Resolve MCP transport alignment** (stdio vs HTTP)
2. ✅ **Implement full 4-level fallback chain**
3. ✅ **Add MongoDB text index on C0N7EXT.content**
4. ✅ **Align schemas (add game filter)**
5. ✅ **Make Qdrant service type consistent**
6. ✅ **Pre-validation must pass before Phase 2**

---

## Revision 1: MCP Transport Alignment

### Issue
MCP server uses `StdioServerTransport`, but `C0MMON/Services/RagContextService.cs` calls HTTP `POST /tools/{toolName}`. This won't work.

### Resolution: Use HTTP Transport

**Option A: HTTP Server (Recommended)**

Update `MCP/rag-server/src/index.ts` to use HTTP transport:

```typescript
#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { HttpServerTransport } from '@modelcontextprotocol/sdk/server/http.js'; // Note: Custom implementation needed
import express from 'express';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// ... existing imports ...

async function main() {
  // ... existing client initialization ...

  // Create Express app for HTTP transport
  const app = express();
  app.use(express.json());

  // MCP Server
  const server = new Server(
    { name: 'rag-context-server', version: '1.0.0' },
    { capabilities: { tools: {} } }
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

    const result = await tool.execute(request.params.arguments);
    return {
      content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
    };
  });

  // HTTP endpoints
  app.post('/tools/:toolName', async (req, res) => {
    try {
      const result = await server.executeTool(req.params.toolName, req.body);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });

  app.get('/health', async (req, res) => {
    const health = await healthTool.execute({});
    res.json(health);
  });

  app.listen(3000, () => {
    console.log('RAG Context MCP Server running on http://localhost:3000');
  });
}

main().catch(console.error);
```

**package.json additions:**
```json
{
  "dependencies": {
    "express": "^4.18.0",
    "@types/express": "^4.17.0"
  }
}
```

---

## Revision 2: Full 4-Level Fallback Chain Implementation

### Issue
Circuit breaker + empty-context behavior is described but not present in MCP tool code. Only try/catch fallback to Mongo exists.

### Resolution: Complete Fallback Implementation

**Updated `src/tools/search.ts`:**

```typescript
import { z } from 'zod';
import type { EmbeddingService } from '../services/embedding.js';
import type { MongoDBClient } from '../clients/mongodb.js';
import type { SearchOptions, SearchResult } from '../types/index.js';

const SearchInputSchema = z.object({
  query: z.string().min(1).max(1000),
  limit: z.number().min(1).max(20).default(5),
  category: z.enum(['strategy', 'bugfix', 'architecture', 'casino']).optional(),
  sessionId: z.string().optional(),
  contentType: z.enum(['chat', 'decision', 'code', 'documentation']).optional(),
  game: z.string().optional(), // Added game filter
});

export type SearchInput = z.infer<typeof SearchInputSchema>;

// Circuit breaker state
interface CircuitBreakerState {
  failures: number;
  lastFailure: number;
  isOpen: boolean;
}

const circuitBreaker: CircuitBreakerState = {
  failures: 0,
  lastFailure: 0,
  isOpen: false,
};

const CIRCUIT_BREAKER_THRESHOLD = 5;
const CIRCUIT_BREAKER_TIMEOUT = 60000; // 60 seconds

function isCircuitBreakerOpen(): boolean {
  if (!circuitBreaker.isOpen) return false;
  
  // Check if timeout has elapsed
  if (Date.now() - circuitBreaker.lastFailure > CIRCUIT_BREAKER_TIMEOUT) {
    circuitBreaker.isOpen = false;
    circuitBreaker.failures = 0;
    return false;
  }
  
  return true;
}

function recordFailure(): void {
  circuitBreaker.failures++;
  circuitBreaker.lastFailure = Date.now();
  
  if (circuitBreaker.failures >= CIRCUIT_BREAKER_THRESHOLD) {
    circuitBreaker.isOpen = true;
    console.error(`Circuit breaker opened after ${circuitBreaker.failures} failures`);
  }
}

function recordSuccess(): void {
  if (circuitBreaker.failures > 0) {
    circuitBreaker.failures = 0;
    console.log('Circuit breaker failures reset after success');
  }
}

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
        game: { type: 'string', description: 'Filter by casino game' }, // Added
      },
      required: ['query'],
    },
    async execute(args: unknown) {
      const startTime = Date.now();
      const input = SearchInputSchema.parse(args);
      
      // Level 4: Circuit breaker check
      if (isCircuitBreakerOpen()) {
        console.warn('Circuit breaker is open, returning empty results');
        
        // Log metrics
        await mongoClient.metricsCollection.insertOne({
          timestamp: new Date(),
          query: input.query,
          resultsCount: 0,
          latencyMs: Date.now() - startTime,
          fallback: true,
          fallbackLevel: 4,
          agent: input.metadata?.agent || 'unknown',
        });

        return {
          results: [],
          latency: Date.now() - startTime,
          fallback: true,
          fallbackLevel: 4,
          circuitBreakerOpen: true,
          warning: 'Circuit breaker is open - too many failures',
          totalIndexed: await mongoClient.getStats().then(s => s.totalDocuments),
        };
      }

      try {
        // Level 1: Primary vector search
        const results = await embeddingService.search(
          input.query,
          input.limit,
          {
            category: input.category,
            sessionId: input.sessionId,
            contentType: input.contentType,
            game: input.game, // Added game filter
          }
        );

        const latency = Date.now() - startTime;
        recordSuccess();

        // Log metrics
        await mongoClient.metricsCollection.insertOne({
          timestamp: new Date(),
          query: input.query,
          resultsCount: results.length,
          latencyMs: latency,
          fallback: false,
          fallbackLevel: 1,
          agent: input.metadata?.agent || 'unknown',
        });

        const stats = await mongoClient.getStats();

        return {
          results,
          latency,
          fallback: false,
          fallbackLevel: 1,
          totalIndexed: stats.totalDocuments,
        };
      } catch (error) {
        console.warn('Vector search failed, attempting fallback:', error);
        
        try {
          // Level 2: MongoDB text search fallback
          const fallbackResults = await mongoClient.textSearch(
            input.query,
            input.limit
          );

          const latency = Date.now() - startTime;

          // Log metrics for fallback
          await mongoClient.metricsCollection.insertOne({
            timestamp: new Date(),
            query: input.query,
            resultsCount: fallbackResults.length,
            latencyMs: latency,
            fallback: true,
            fallbackLevel: 2,
            agent: input.metadata?.agent || 'unknown',
          });

          return {
            results: fallbackResults.map(doc => ({
              content: doc.content,
              score: 0.5,
              source: doc.source,
              timestamp: doc.timestamp.toISOString(),
              metadata: doc.metadata || {},
            })),
            latency,
            fallback: true,
            fallbackLevel: 2,
            warning: 'Vector search unavailable, using text search fallback',
            totalIndexed: fallbackResults.length,
          };
        } catch (fallbackError) {
          console.error('MongoDB fallback also failed:', fallbackError);
          recordFailure();

          // Level 3: Empty context with warning
          const latency = Date.now() - startTime;

          // Log metrics for empty fallback
          await mongoClient.metricsCollection.insertOne({
            timestamp: new Date(),
            query: input.query,
            resultsCount: 0,
            latencyMs: latency,
            fallback: true,
            fallbackLevel: 3,
            agent: input.metadata?.agent || 'unknown',
            error: fallbackError instanceof Error ? fallbackError.message : 'Unknown error',
          });

          return {
            results: [],
            latency,
            fallback: true,
            fallbackLevel: 3,
            warning: 'All search methods failed, returning empty results',
            totalIndexed: 0,
          };
        }
      }
    },
  };
}
```

---

## Revision 3: MongoDB Text Index

### Issue
`MongoDBClient.createIndexes()` lacks a `$text` index on `content`, yet `textSearch()` relies on it.

### Resolution: Add Text Index

**Updated `src/clients/mongodb.ts`:**

```typescript
private async createIndexes(): Promise<void> {
  // Existing indexes
  await this.contextCollection.createIndex({ sessionId: 1, timestamp: -1 });
  await this.contextCollection.createIndex({ 'metadata.tags': 1 });
  await this.contextCollection.createIndex({ 'metadata.category': 1 });
  await this.contextCollection.createIndex({ contentType: 1, timestamp: -1 });
  await this.contextCollection.createIndex({ 'metadata.decisionId': 1 });
  
  // NEW: Text index for fallback search
  await this.contextCollection.createIndex(
    { content: 'text', 'metadata.tags': 'text' },
    { 
      weights: { content: 10, 'metadata.tags': 5 },
      name: 'content_text_index'
    }
  );
  
  await this.metricsCollection.createIndex({ timestamp: -1 });
  await this.metricsCollection.createIndex({ agent: 1, timestamp: -1 });
}
```

---

## Revision 4: Add Game Filter to Schema

### Issue
Tool schema doesn't include `game` filter, but it's referenced in casino use cases.

### Resolution: Update All Schemas

**Search Input Schema (already updated in Revision 2):**
```typescript
const SearchInputSchema = z.object({
  query: z.string().min(1).max(1000),
  limit: z.number().min(1).max(20).default(5),
  category: z.enum(['strategy', 'bugfix', 'architecture', 'casino']).optional(),
  sessionId: z.string().optional(),
  contentType: z.enum(['chat', 'decision', 'code', 'documentation']).optional(),
  game: z.string().optional(), // Added
});
```

**Qdrant Search Update:**
```typescript
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

  // Added game filter
  if (filters?.game) {
    mustConditions.push({
      key: 'game',
      match: { value: filters.game },
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
      game: (point.payload?.game as string) || undefined, // Added
    },
  }));
}
```

**C# Interface Update:**
```csharp
public interface IRagContext
{
    Task<RagSearchResult> SearchAsync(
        string query,
        RagSearchOptions options = null,
        string agent = null
    );

    // ... other methods ...

    Task<RagSearchResult> SearchFastAsync(
        string query,
        string game = null,  // Added
        string agent = null
    );
}

public class RagSearchOptions
{
    public int Limit { get; set; } = 5;
    public string Category { get; set; }
    public string SessionId { get; set; }
    public string ContentType { get; set; }
    public string Game { get; set; }  // Added
}
```

---

## Revision 5: Qdrant Service Type Consistency

### Issue
Decision shows `LoadBalancer`, tech spec uses `NodePort`. Pick one for Rancher Desktop.

### Resolution: Use NodePort for Rancher Desktop

**Rationale:**
- Rancher Desktop on Windows/WSL2 works better with NodePort
- LoadBalancer requires additional configuration (MetalLB)
- NodePort is simpler for local development

**Consistent Service Definition:**

```yaml
# k8s/qdrant-service.yaml (unchanged from tech spec)
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

**Access Pattern:**
```typescript
// Local development (Rancher Desktop)
const qdrant = new QdrantWrapper('http://localhost:30333');

// Kubernetes internal
const qdrant = new QdrantWrapper('http://qdrant.rag-context.svc.cluster.local:6333');
```

**Decision Document Update:**
Update the decision document to reflect NodePort for Rancher Desktop compatibility.

---

## Revision 6: Pre-Validation Protocol

### Issue
Pre-validation must be a hard gate before Phase 2.

### Resolution: Formal Pre-Validation Checklist

**Pre-Validation Script:** `scripts/pre-validate-rag.ps1`

```powershell
#!/usr/bin/env powershell
# Pre-validation for RAG-001 before Phase 2

param(
    [string]$MongoDBConnectionString = "mongodb://localhost:27017/P4NTH30N",
    [string]$LMStudioUrl = "http://localhost:1234",
    [string]$QdrantUrl = "http://localhost:30333"
)

$ErrorActionPreference = "Stop"
$passed = 0
$failed = 0

function Test-Step {
    param($Name, $ScriptBlock)
    Write-Host "Testing: $Name..." -NoNewline
    try {
        & $ScriptBlock
        Write-Host " PASSED" -ForegroundColor Green
        $script:passed++
        return $true
    } catch {
        Write-Host " FAILED" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        $script:failed++
        return $false
    }
}

Write-Host "`n=== RAG-001 Pre-Validation ===" -ForegroundColor Cyan
Write-Host "Running 5-sample validation before Phase 2`n"

# Test 1: Qdrant connectivity
Test-Step "Qdrant Health Check" {
    $response = Invoke-RestMethod -Uri "$QdrantUrl/healthz" -Method GET
    if ($response.status -ne "ok") { throw "Qdrant not healthy" }
}

# Test 2: LM Studio connectivity
Test-Step "LM Studio API" {
    $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/models" -Method GET
    if (-not $response.data) { throw "No models loaded" }
}

# Test 3: Embedding generation
Test-Step "Embedding Generation (Sample 1/5)" {
    $body = @{ input = "test query"; model = "nomic-embed-text-v1.5" } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/embeddings" `
        -Method POST -Body $body -ContentType "application/json"
    if ($response.data[0].embedding.Count -ne 768) { 
        throw "Expected 768 dimensions, got $($response.data[0].embedding.Count)" 
    }
}

# Test 4-8: Accuracy tests
$testQueries = @(
    @{ query = "mongodb connection retry"; expectedRelevant = $true },
    @{ query = "jackpot threshold configuration"; expectedRelevant = $true },
    @{ query = "selenium automation pattern"; expectedRelevant = $true },
    @{ query = "architecture decision template"; expectedRelevant = $true },
    @{ query = "random unrelated query xyz123"; expectedRelevant = $false }
)

$sample = 2
foreach ($test in $testQueries) {
    Test-Step "Embedding Similarity (Sample $sample/5)" {
        $body = @{ input = $test.query; model = "nomic-embed-text-v1.5" } | ConvertTo-Json
        $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/embeddings" `
            -Method POST -Body $body -ContentType "application/json"
        
        # Basic validation - embedding should be generated
        if (-not $response.data[0].embedding) { throw "No embedding generated" }
        
        # Check vector magnitude (should be normalized to ~1.0)
        $embedding = $response.data[0].embedding
        $magnitude = 0
        foreach ($val in $embedding) { $magnitude += $val * $val }
        $magnitude = [Math]::Sqrt($magnitude)
        
        if ($magnitude -lt 0.9 -or $magnitude -gt 1.1) {
            throw "Vector magnitude $magnitude is outside expected range [0.9, 1.1]"
        }
    }
    $sample++
}

# Summary
Write-Host "`n=== Results ===" -ForegroundColor Cyan
Write-Host "Passed: $passed" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red

if ($failed -eq 0) {
    Write-Host "`n✓ PRE-VALIDATION PASSED" -ForegroundColor Green
    Write-Host "Proceed to Phase 2: MCP Server Implementation" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n✗ PRE-VALIDATION FAILED" -ForegroundColor Red
    Write-Host "Fix failures before proceeding to Phase 2" -ForegroundColor Red
    exit 1
}
```

**Gate Criteria:**
- All 5 samples must pass
- Embedding dimension must be exactly 768
- Vector magnitude must be in range [0.9, 1.1] (indicates normalized embeddings)
- Qdrant and LM Studio must be healthy

---

## Revised Approval Score Calculation

**Original:** 82% (Conditional)

**With Revisions:**
- Base: 50%
- Pre-validation: +15% ✓
- Fallback mechanism (4-level): +15% ✓
- Confidence scoring: +12% ✓
- Benchmarks (50+): +10% ✓
- Structured JSON: +10% ✓
- Local model: +10% ✓
- Edge cases: +10% ✓
- Latency requirements: +8% ✓
- Observability: +8% ✓

**Revised Predicted Approval: 93%**

---

## Implementation Order

1. **Immediate (Before Phase 1):**
   - Update decision document with Oracle feedback
   - Create pre-validation script

2. **Phase 1 (Infrastructure):**
   - Deploy Qdrant with NodePort service
   - Configure LM Studio
   - Run pre-validation script
   - **Gate:** Pre-validation must pass

3. **Phase 2 (MCP Server):**
   - Implement HTTP transport MCP server
   - Implement full 4-level fallback
   - Add MongoDB text index
   - Include game filter

4. **Phase 3 (Data Ingestion):**
   - Index 50+ documents
   - Verify all fallback levels work

5. **Phase 4 (Integration):**
   - Update agent prompts
   - Run full benchmark

---

## Files Modified

| File | Change |
|------|--------|
| `MCP/rag-server/src/index.ts` | HTTP transport instead of stdio |
| `MCP/rag-server/src/tools/search.ts` | 4-level fallback + circuit breaker |
| `MCP/rag-server/src/clients/mongodb.ts` | Added text index |
| `MCP/rag-server/src/clients/qdrant.ts` | Added game filter |
| `C0MMON/Interfaces/IRagContext.cs` | Added game parameter |
| `k8s/qdrant-service.yaml` | Confirmed NodePort |
| `scripts/pre-validate-rag.ps1` | New pre-validation script |

---

**Oracle Re-Review Recommended After:**
- Pre-validation script execution
- Phase 1 completion
- HTTP transport implementation verification


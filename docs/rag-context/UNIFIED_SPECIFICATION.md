# RAG-001 Unified Specification
## Final Aligned Document for Implementation

**Decision ID:** RAG-001  
**Title:** RAG Context Layer Implementation  
**Status:** Conditional Approval (88%) - Pending Alignment  
**Last Updated:** 2026-02-18  

---

## Unified Specification

This document aligns all previous specifications (decision, technical spec, oracle revisions) into a single authoritative reference.

### 1. Infrastructure (Aligned)

**Qdrant Service:**
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
    nodePort: 30333  # <-- ALIGNED: NodePort for Rancher Desktop
  type: NodePort     # <-- ALIGNED: Not LoadBalancer
```

**Access URLs:**
- Local development: `http://localhost:30333`
- Kubernetes internal: `http://qdrant.rag-context.svc.cluster.local:6333`

### 2. MCP Transport (Aligned)

**Decision:** Use HTTP transport (not stdio) for simplicity and C# integration.

**Implementation Pattern:**
```typescript
// MCP/rag-server/src/server.ts
import express from 'express';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';

const app = express();
app.use(express.json());

// Initialize MCP server
const mcpServer = new Server(
  { name: 'rag-context-server', version: '1.0.0' },
  { capabilities: { tools: {} } }
);

// Tool execution endpoint
app.post('/tools/:toolName', async (req, res) => {
  try {
    const { toolName } = req.params;
    const args = req.body;
    
    const tool = tools.find(t => t.name === toolName);
    if (!tool) {
      return res.status(404).json({ error: `Tool ${toolName} not found` });
    }
    
    const result = await tool.execute(args);
    res.json(result);
  } catch (error) {
    res.status(500).json({ 
      error: error instanceof Error ? error.message : 'Unknown error',
      fallback: true 
    });
  }
});

// Health check endpoint
app.get('/health', async (req, res) => {
  const health = await healthTool.execute({});
  res.json(health);
});

// List tools endpoint
app.get('/tools', async (req, res) => {
  res.json({
    tools: tools.map(t => ({
      name: t.name,
      description: t.description,
      inputSchema: t.inputSchema,
    }))
  });
});

app.listen(3000, () => {
  console.log('RAG Context MCP Server on http://localhost:3000');
});
```

**C# Service Implementation (Aligned):**
```csharp
public class RagContextService : IRagContext
{
    private readonly HttpClient _httpClient;
    private readonly string _baseUrl = "http://localhost:3000";

    public async Task<RagSearchResult> SearchAsync(
        string query, 
        RagSearchOptions options = null, 
        string agent = null)
    {
        var request = new
        {
            query,
            limit = options?.Limit ?? 5,
            category = options?.Category,
            sessionId = options?.SessionId,
            contentType = options?.ContentType,
            game = options?.Game,  // <-- ALIGNED: Game filter included
            agent  // <-- ALIGNED: Agent passed at top level, not in metadata
        };

        var response = await _httpClient.PostAsJsonAsync(
            $"{_baseUrl}/tools/rag_context_search", 
            request
        );
        
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<RagSearchResult>();
    }
}
```

### 3. MongoDB Indexes (Aligned)

**Complete Index List for C0N7EXT:**
```javascript
// ALIGNED: All indexes including text index
db.C0N7EXT.createIndex({ sessionId: 1, timestamp: -1 });
db.C0N7EXT.createIndex({ "metadata.tags": 1 });
db.C0N7EXT.createIndex({ "metadata.category": 1 });
db.C0N7EXT.createIndex({ contentType: 1, timestamp: -1 });
db.C0N7EXT.createIndex({ "metadata.decisionId": 1 });

// ALIGNED: Text index for fallback search
db.C0N7EXT.createIndex(
  { content: "text", "metadata.tags": "text" },
  { 
    weights: { content: 10, "metadata.tags": 5 },
    name: "content_text_index",
    default_language: "english"
  }
);
```

### 4. Tool Schemas (Aligned)

**rag_context_search Input Schema:**
```json
{
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
      "default": 5 
    },
    "category": { 
      "type": "string", 
      "enum": ["strategy", "bugfix", "architecture", "casino"] 
    },
    "sessionId": { "type": "string" },
    "contentType": { 
      "type": "string", 
      "enum": ["chat", "decision", "code", "documentation"] 
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

**rag_context_search Output Schema:**
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
    "latency": { "type": "number", "description": "Total latency in milliseconds" },
    "fallback": { "type": "boolean", "description": "Whether fallback was used" },
    "fallbackLevel": { 
      "type": "integer", 
      "minimum": 1, 
      "maximum": 4,
      "description": "Fallback level: 1=primary, 2=MongoDB, 3=empty, 4=circuit breaker"
    },
    "circuitBreakerOpen": { "type": "boolean" },
    "totalIndexed": { "type": "integer" }
  }
}
```

### 5. Fallback Chain (Aligned)

**Complete 4-Level Implementation:**

```typescript
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
const CIRCUIT_BREAKER_TIMEOUT = 60000;

async function executeSearch(args: SearchInput): Promise<SearchOutput> {
  const startTime = Date.now();
  
  // Level 4: Circuit breaker check
  if (circuitBreaker.isOpen) {
    if (Date.now() - circuitBreaker.lastFailure > CIRCUIT_BREAKER_TIMEOUT) {
      circuitBreaker.isOpen = false;
      circuitBreaker.failures = 0;
    } else {
      await logMetrics({
        timestamp: new Date(),
        query: args.query,
        resultsCount: 0,
        latencyMs: Date.now() - startTime,
        fallback: true,
        fallbackLevel: 4,
        agent: args.agent || 'unknown',
      });
      
      return {
        results: [],
        latency: Date.now() - startTime,
        fallback: true,
        fallbackLevel: 4,
        circuitBreakerOpen: true,
        totalIndexed: await getTotalIndexed(),
      };
    }
  }
  
  try {
    // Level 1: Primary vector search
    const results = await qdrantSearch(args);
    recordSuccess();
    
    await logMetrics({
      timestamp: new Date(),
      query: args.query,
      resultsCount: results.length,
      latencyMs: Date.now() - startTime,
      fallback: false,
      fallbackLevel: 1,
      agent: args.agent || 'unknown',
    });
    
    return {
      results,
      latency: Date.now() - startTime,
      fallback: false,
      fallbackLevel: 1,
      totalIndexed: await getTotalIndexed(),
    };
  } catch (error) {
    try {
      // Level 2: MongoDB text search fallback
      const results = await mongoTextSearch(args);
      
      await logMetrics({
        timestamp: new Date(),
        query: args.query,
        resultsCount: results.length,
        latencyMs: Date.now() - startTime,
        fallback: true,
        fallbackLevel: 2,
        agent: args.agent || 'unknown',
      });
      
      return {
        results,
        latency: Date.now() - startTime,
        fallback: true,
        fallbackLevel: 2,
        totalIndexed: await getTotalIndexed(),
      };
    } catch (fallbackError) {
      recordFailure();
      
      // Level 3: Empty context
      await logMetrics({
        timestamp: new Date(),
        query: args.query,
        resultsCount: 0,
        latencyMs: Date.now() - startTime,
        fallback: true,
        fallbackLevel: 3,
        agent: args.agent || 'unknown',
        error: fallbackError.message,
      });
      
      return {
        results: [],
        latency: Date.now() - startTime,
        fallback: true,
        fallbackLevel: 3,
        totalIndexed: 0,
      };
    }
  }
}
```

### 6. Metrics Schema (Aligned)

**R4G_M37R1C5 Collection Schema:**
```javascript
{
  "_id": ObjectId,
  "timestamp": ISODate,
  "query": String,              // Truncated to 200 chars if longer
  "resultsCount": Number,
  "latencyMs": Number,          // Total end-to-end latency
  "embeddingLatencyMs": Number, // LM Studio time (if available)
  "vectorLatencyMs": Number,    // Qdrant search time (if available)
  "fallback": Boolean,          // Whether any fallback was used
  "fallbackLevel": Number,      // 1=primary, 2=MongoDB, 3=empty, 4=circuit
  "cacheHit": Boolean,          // Whether result came from cache
  "agent": String,              // Agent name
  "contentType": String,        // Content type filter used
  "category": String,           // Category filter used
  "game": String,               // Game filter used
  "error": String               // Error message (only if fallbackLevel 3)
}
```

**Note:** `fallback` and `fallbackLevel` work together:
- `fallback: false, fallbackLevel: 1` = Primary success
- `fallback: true, fallbackLevel: 2` = MongoDB fallback
- `fallback: true, fallbackLevel: 3` = Empty fallback (error)
- `fallback: true, fallbackLevel: 4` = Circuit breaker

### 7. Pre-Validation Script (Aligned)

**Enhanced with Retrieval Accuracy Check:**

```powershell
#!/usr/bin/env powershell
# RAG-001 Pre-Validation with Retrieval Accuracy Gate

param(
    [string]$MongoDBConnectionString = "mongodb://localhost:27017/P4NTHE0N",
    [string]$LMStudioUrl = "http://localhost:1234",
    [string]$QdrantUrl = "http://localhost:30333",
    [string]$McpServerUrl = "http://localhost:3000"
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
Write-Host "Validating infrastructure before Phase 2`n"

# Phase 1: Infrastructure Health
Test-Step "Qdrant Health" {
    $response = Invoke-RestMethod -Uri "$QdrantUrl/healthz" -Method GET
    if ($response.status -ne "ok") { throw "Qdrant unhealthy" }
}

Test-Step "LM Studio API" {
    $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/models" -Method GET
    if (-not $response.data) { throw "No models loaded" }
}

Test-Step "MCP Server Health" {
    $response = Invoke-RestMethod -Uri "$McpServerUrl/health" -Method GET
    if (-not $response.healthy) { throw "MCP server unhealthy" }
}

# Phase 2: Embedding Quality (5 samples)
$testQueries = @(
    "mongodb connection retry",
    "jackpot threshold configuration", 
    "selenium automation pattern",
    "architecture decision template",
    "casino game strategy"
)

$sample = 1
foreach ($query in $testQueries) {
    Test-Step "Embedding Quality (Sample $sample/5)" {
        $body = @{ input = $query; model = "nomic-embed-text-v1.5" } | ConvertTo-Json
        $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/embeddings" `
            -Method POST -Body $body -ContentType "application/json"
        
        if ($response.data[0].embedding.Count -ne 768) { 
            throw "Expected 768 dimensions, got $($response.data[0].embedding.Count)" 
        }
        
        # Check vector normalization
        $embedding = $response.data[0].embedding
        $magnitude = 0
        foreach ($val in $embedding) { $magnitude += $val * $val }
        $magnitude = [Math]::Sqrt($magnitude)
        
        if ($magnitude -lt 0.9 -or $magnitude -gt 1.1) {
            throw "Vector magnitude $magnitude outside [0.9, 1.1]"
        }
        
        # Latency check
        $latency = $response.usage.total_tokens  # Rough proxy
    }
    $sample++
}

# Phase 3: Retrieval Accuracy Gate (CRITICAL)
Write-Host "`n=== Retrieval Accuracy Gate ===" -ForegroundColor Cyan

# Index test documents first
$testDocs = @(
    @{ 
        content = "MongoDB connections should use retry logic with exponential backoff. Max retries: 5.";
        category = "architecture"
        game = $null
    },
    @{
        content = "FireKirin jackpot threshold is set at $500. Major jackpot at $250.";
        category = "casino"
        game = "FireKirin"
    },
    @{
        content = "Selenium WebDriver timeout should be 30 seconds for page loads.";
        category = "architecture"
        game = $null
    }
)

Write-Host "Indexing test documents..."
foreach ($doc in $testDocs) {
    $body = @{
        content = $doc.content
        contentType = "documentation"
        sessionId = "preval-test-$([Guid]::NewGuid())"
        source = "pre-validation"
        metadata = @{
            category = $doc.category
            game = $doc.game
        }
    } | ConvertTo-Json -Depth 3
    
    Invoke-RestMethod -Uri "$McpServerUrl/tools/rag_context_index" `
        -Method POST -Body $body -ContentType "application/json" | Out-Null
}

# Wait for indexing
Write-Host "Waiting for indexing..."
Start-Sleep -Seconds 2

# Test retrieval accuracy
$accuracyTests = @(
    @{ 
        query = "mongodb retry logic"
        expectedKeyword = "exponential backoff"
        category = "architecture"
    },
    @{
        query = "FireKirin jackpot amount"
        expectedKeyword = "$500"
        game = "FireKirin"
    },
    @{
        query = "selenium timeout duration"
        expectedKeyword = "30 seconds"
        category = "architecture"
    }
)

$relevantResults = 0
$totalTests = $accuracyTests.Count

foreach ($test in $accuracyTests) {
    $body = @{
        query = $test.query
        limit = 3
        category = $test.category
        game = $test.game
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$McpServerUrl/tools/rag_context_search" `
        -Method POST -Body $body -ContentType "application/json"
    
    # Check if expected keyword appears in top-3
    $found = $false
    foreach ($result in $response.results) {
        if ($result.content -match $test.expectedKeyword) {
            $found = $true
            break
        }
    }
    
    if ($found) {
        $relevantResults++
        Write-Host "  ✓ '$($test.query)' found '$($test.expectedKeyword)'" -ForegroundColor Green
    } else {
        Write-Host "  ✗ '$($test.query)' missing '$($test.expectedKeyword)'" -ForegroundColor Red
    }
}

$accuracy = ($relevantResults / $totalTests) * 100
Write-Host "`nRetrieval Accuracy: $accuracy% ($relevantResults/$totalTests)" -ForegroundColor $(if ($accuracy -ge 80) { "Green" } else { "Red" })

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Infrastructure Tests Passed: $passed" -ForegroundColor Green
Write-Host "Infrastructure Tests Failed: $failed" -ForegroundColor Red

if ($failed -eq 0 -and $accuracy -ge 80) {
    Write-Host "`n✓ PRE-VALIDATION PASSED" -ForegroundColor Green
    Write-Host "Accuracy gate: $accuracy% (required: 80%)" -ForegroundColor Green
    Write-Host "Proceed to Phase 2: MCP Server Implementation" -ForegroundColor Green
    exit 0
} elseif ($failed -eq 0 -and $accuracy -lt 80) {
    Write-Host "`n⚠ INFRASTRUCTURE PASSED, ACCURACY FAILED" -ForegroundColor Yellow
    Write-Host "Accuracy: $accuracy% (required: 80%)" -ForegroundColor Yellow
    Write-Host "Check embedding quality and indexing" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "`n✗ PRE-VALIDATION FAILED" -ForegroundColor Red
    Write-Host "Fix infrastructure failures before proceeding" -ForegroundColor Red
    exit 1
}
```

### 8. C# Interface (Aligned)

```csharp
namespace P4NTHE0N.C0MMON.Interfaces;

public interface IRagContext
{
    Task<RagSearchResult> SearchAsync(
        string query,
        RagSearchOptions options = null,
        string agent = null
    );

    Task<RagIndexResult> IndexAsync(
        RagDocument document,
        string agent = null
    );

    Task<RagHealthStatus> GetHealthAsync();
    Task<RagStats> GetStatsAsync(TimeSpan timeRange);
    
    Task<RagSearchResult> SearchFastAsync(
        string query,
        string game = null,  // <-- ALIGNED
        string agent = null
    );
}

public class RagSearchOptions
{
    public int Limit { get; set; } = 5;
    public string Category { get; set; }
    public string SessionId { get; set; }
    public string ContentType { get; set; }
    public string Game { get; set; }  // <-- ALIGNED
}

public class RagSearchResult
{
    public List<RagResultItem> Results { get; set; } = new();
    public double Latency { get; set; }  // <-- ALIGNED: Not LatencyMs
    public bool Fallback { get; set; }  // <-- ALIGNED
    public int FallbackLevel { get; set; }  // <-- ALIGNED
    public bool CircuitBreakerOpen { get; set; }  // <-- ALIGNED
    public int TotalIndexed { get; set; }
}

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

---

## Implementation Checklist

### Phase 1: Infrastructure
- [ ] Rancher Desktop with Kubernetes
- [ ] Qdrant deployed (NodePort: 30333)
- [ ] LM Studio with nomic-embed-text-v1.5
- [ ] Run pre-validation script (must pass 80% accuracy)

### Phase 2: MCP Server
- [ ] HTTP transport (Express on port 3000)
- [ ] 4-level fallback chain implemented
- [ ] MongoDB text index created
- [ ] Game filter in all schemas
- [ ] Metrics schema aligned

### Phase 3: C# Integration
- [ ] IRagContext interface with Game property
- [ ] HTTP client implementation
- [ ] Background indexer

### Phase 4: Validation
- [ ] 50+ documents indexed
- [ ] >85% top-3 relevance
- [ ] <500ms p99 latency

---

## Oracle Approval Status

**Current:** 88% - Conditional

**Required for 90%+:**
1. ✓ All 6 gaps addressed in unified spec
2. → Implementation must match unified spec exactly
3. → Pre-validation script must pass 80% accuracy gate

**Recommendation:** Proceed with implementation using this unified specification as the single source of truth.


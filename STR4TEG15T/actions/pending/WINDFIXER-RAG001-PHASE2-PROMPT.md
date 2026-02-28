# WindFixer Start Prompt
## Execute RAG-001 Phase 2-3 (Pipeline & Hardening)

**Brief**: T4CT1CS/handoffs/completed/OPENFIXER-RAG001-20260219.md  
**Source**: RAG-001 Phase 1 Complete (all 4 Oracle conditions met)  
**Priority**: High | **ETA**: 2-3 days

---

## EXECUTIVE SUMMARY

OpenFixer has completed Oracle condition #3 (Python bridge). All 4 Oracle conditions are now met:
- ✅ #1: Metadata filter security
- ✅ #2: ERR0R sanitization
- ✅ #3: Python bridge (14.3ms/doc, 7x target)
- ✅ #4: Health monitoring

**RAG-001 Phase 1 is production-ready.** You are unblocked for Phase 2-3.

---

## PHASE 1 DELIVERABLES (Already Complete)

**Source files in C:\P4NTHE0N\src\RAG\:**
```
McpServer.cs              ✅ MCP server with 6 tools
EmbeddingService.cs       ✅ ONNX + sentence-transformers
PythonEmbeddingClient.cs  ✅ HTTP client for bridge (NEW from OpenFixer)
FaissVectorStore.cs       ✅ FAISS IndexFlatL2
QueryPipeline.cs          ✅ Query → embed → search → format
IngestionPipeline.cs      ✅ Document → chunk → embed → store
SanitizationPipeline.cs   ✅ ERR0R preprocessing
ContextBuilder.cs         ✅ Structured context assembly
HealthMonitor.cs          ✅ Health checks
RAG.csproj                ✅ Project file

PythonBridge/
├── embedding_bridge.py   ✅ FastAPI service (NEW from OpenFixer)
└── requirements.txt      ✅ Dependencies (NEW from OpenFixer)
```

**Performance validated:**
- Embedding: 14.3ms/doc (target: <100ms)
- Semantic quality: cat-kitten 0.788, cat-auto 0.359 ✅
- Build: 0 errors, 0 warnings

---

## YOUR MISSION: PHASE 2-3

### Phase 2: Core Pipeline Enhancement (Day 1-2)

**2.1 MCP Host Executable**

Create standalone executable for MCP server (no `dotnet run` required):

```csharp
// src/RAG/McpHost/Program.cs
// Single-file executable that hosts the MCP server
// Usage: RAG.McpHost.exe --port 5001 --model-path C:\...
```

**Requirements:**
- [ ] Self-contained publish (single .exe)
- [ ] Command-line args: --port, --model-path, --index-path, --python-bridge-url
- [ ] Windows service support (optional but recommended)
- [ ] Auto-restart on crash (3 attempts with backoff)

**Publish command:**
```powershell
dotnet publish src/RAG/McpHost/McpHost.csproj `
  -c Release `
  -r win-x64 `
  --self-contained true `
  -p:PublishSingleFile=true `
  -p:IncludeNativeLibrariesForSelfExtract=true `
  -o C:/ProgramData/P4NTHE0N/bin/
```

**2.2 QueryPipeline Refinement**

Enhance existing QueryPipeline.cs:

```csharp
// Add to src/RAG/QueryPipeline.cs

public async Task<QueryResult> QueryWithContextAsync(
    string query,
    QueryContext context,
    CancellationToken ct = default)
{
    // 1. Detect query intent (optional enhancement)
    // 2. Apply agent-specific metadata filters
    // 3. Execute hybrid search (BM25 + FAISS)
    // 4. Re-rank by relevance (cross-encoder optional)
    // 5. Format with citations
}

public class QueryContext
{
    public string AgentId { get; set; }
    public string[] AllowedCategories { get; set; }
    public int MaxTokens { get; set; } = 2000
    public bool IncludeMetadata { get; set; } = true
}
```

**2.3 IngestionPipeline Enhancement**

```csharp
// Add batch ingestion support to src/RAG/IngestionPipeline.cs

public async Task<IngestionResult> IngestBatchAsync(
    List<Document> documents,
    IngestionOptions options,
    CancellationToken ct = default)
{
    // 1. Parallel chunking (max 4 concurrent)
    // 2. Batch embedding (size 32 for Python bridge)
    // 3. Bulk FAISS insert
    // 4. MongoDB metadata bulk insert
    // 5. Return ingestion metrics
}
```

---

### Phase 3: Production Hardening (Day 2-3)

**3.1 FileSystemWatcher Implementation**

```csharp
// src/RAG/FileSystemWatcherService.cs

public class FileSystemWatcherService : BackgroundService
{
    // Monitor C:\P4NTHE0N\docs\ for changes
    // Debounce: 1-5 minutes (configurable)
    // File types: *.md, *.json, *.cs (optional)
    // On change: Queue for ingestion (don't block)
}
```

**Configuration:**
```json
{
  "FileSystemWatcher": {
    "Paths": ["C:\\P4NTHE0N\\docs"],
    "FileFilters": ["*.md", "*.json"],
    "DebounceSeconds": 300,
    "Enabled": true
  }
}
```

**3.2 MongoDB Change Streams**

```csharp
// src/RAG/MongoChangeStreamService.cs

public class MongoChangeStreamService : BackgroundService
{
    // Watch collections: EV3NT, ERR0R, G4ME, decisions
    // Batch size: 100 documents
    // Flush interval: 30 seconds
    // Operations: insert, update (not delete)
}
```

**3.3 Scheduled Rebuilds**

```powershell
# scripts/rag/schedule-rebuilds.ps1

# 4-hour incremental rebuild
Register-ScheduledTask `
  -TaskName "RAG-Incremental-Rebuild" `
  -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date).AddHours(4) -RepetitionInterval (New-TimeSpan -Hours 4)) `
  -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\P4NTHE0N\scripts\rag\rebuild-index.ps1 -Incremental") `
  -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

# Nightly 3AM full rebuild
Register-ScheduledTask `
  -TaskName "RAG-Nightly-Rebuild" `
  -Trigger (New-ScheduledTaskTrigger -Daily -At "03:00") `
  -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\P4NTHE0N\scripts\rag\rebuild-index.ps1 -Full") `
  -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries)
```

**3.4 Production Monitoring**

```csharp
// src/RAG/Metrics/MetricsCollector.cs

public class MetricsCollector
{
    // Track and expose:
    // - Query latency (p50, p95, p99)
    // - Embedding latency
    // - Index size (document count, vector count)
    // - Cache hit rate
    // - Error rate
    // - Python bridge health
}
```

**3.5 Error Handling & Resilience**

```csharp
// src/RAG/Resilience/CircuitBreaker.cs

public class CircuitBreaker
{
    // 5 failures in 60s = open circuit
    // Cooldown: 30 seconds
    // Half-open: 1 test request
    // Track: failure count, last failure, state
}

// src/RAG/Resilience/RetryPolicy.cs

public class RetryPolicy
{
    // Max 3 retries
    // Exponential backoff: 1s, 2s, 4s
    // Only retry on transient errors (503, timeout)
}
```

---

## IMPLEMENTATION CHECKLIST

### Phase 2: Pipeline (Day 1-2)

- [ ] **McpHost executable**
  - [ ] Create McpHost project
  - [ ] Implement command-line parsing
  - [ ] Add logging configuration
  - [ ] Self-contained publish
  - [ ] Test: `RAG.McpHost.exe --help` works

- [ ] **QueryPipeline refinement**
  - [ ] Add QueryContext support
  - [ ] Implement hybrid search (BM25 + FAISS)
  - [ ] Add citation formatting
  - [ ] Test: Query with metadata filter

- [ ] **IngestionPipeline enhancement**
  - [ ] Batch processing (parallel chunking)
  - [ ] Bulk operations (FAISS + MongoDB)
  - [ ] Progress reporting
  - [ ] Test: Ingest 100 documents

### Phase 3: Hardening (Day 2-3)

- [ ] **FileSystemWatcher**
  - [ ] Create FileSystemWatcherService
  - [ ] Implement debounce logic
  - [ ] Add configuration
  - [ ] Test: Modify doc file, verify ingestion

- [ ] **MongoDB Change Streams**
  - [ ] Create MongoChangeStreamService
  - [ ] Implement batching
  - [ ] Add resume token support
  - [ ] Test: Insert document, verify ingestion

- [ ] **Scheduled Rebuilds**
  - [ ] Create rebuild-index.ps1
  - [ ] Add scheduled tasks
  - [ ] Test: Run incremental rebuild

- [ ] **Monitoring & Resilience**
  - [ ] Create MetricsCollector
  - [ ] Implement CircuitBreaker
  - [ ] Add RetryPolicy
  - [ ] Create health check dashboard

---

## ACCEPTANCE CRITERIA

Before reporting completion:

**Phase 2:**
- [ ] McpHost.exe runs standalone (no dotnet required)
- [ ] QueryPipeline supports agent-specific filtering
- [ ] Batch ingestion processes 100 docs in <30s
- [ ] All builds pass (0 errors, 0 warnings)

**Phase 3:**
- [ ] FileSystemWatcher detects changes within 5 minutes
- [ ] Change streams catch MongoDB inserts within 30s
- [ ] Incremental rebuild runs every 4 hours
- [ ] Nightly rebuild runs at 3AM
- [ ] Circuit breaker opens after 5 failures
- [ ] Metrics exposed via health endpoint

---

## TESTING STRATEGY

**Integration Tests:**
```csharp
// tests/RAG/Integration/EndToEndTests.cs

[Fact]
public async Task FullPipeline_Test()
{
    // 1. Start Python bridge
    // 2. Start McpHost
    // 3. Ingest test document
    // 4. Query and verify results
    // 5. Verify metrics
}
```

**Performance Tests:**
```powershell
# scripts/rag/benchmark-query.ps1
# Run 1000 queries, measure latency distribution
```

**Load Tests:**
```powershell
# scripts/rag/load-test-ingestion.ps1
# Ingest 10k documents, measure throughput
```

---

## HANDOFF TO STRATEGIST

Upon completion, create: `T4CT1CS/handoffs/windfixer/RAG-001-PHASE2-3-20260219.md`

Include:
1. Phase 2-3 completion confirmation
2. McpHost.exe location and usage
3. Performance benchmarks
4. Monitoring dashboard URL (if any)
5. Any issues encountered
6. Recommendations for production deployment

---

## RISKS & MITIGATION

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| FileSystemWatcher misses events | Medium | Low | Periodic full sync + change stream backup |
| Change stream lag | Medium | Medium | Batch size tuning, monitoring alerts |
| Index rebuild too slow | Medium | Low | Incremental only, parallel processing |
| Python bridge memory leak | Medium | Low | Process restart every 24h, monitoring |

---

## REFERENCES

- OpenFixer Report: T4CT1CS/handoffs/completed/OPENFIXER-RAG001-20260219.md
- RAG-001 Final Decision: T4CT1CS/intel/RAG-001_FINAL_DECISION.md
- Phase 1 Code: C:\P4NTHE0N\src\RAG\
- Python Bridge: C:\P4NTHE0N\src\RAG\PythonBridge\

---

**WindFixer Signature**: [awaiting]  
**Strategist Acknowledgment**: 2026-02-19  
**Expected Completion**: 2026-02-21 (2-3 days)

---

## QUICK START

```powershell
# 1. Verify Phase 1 is running
Invoke-RestMethod -Uri "http://localhost:5000/health"

# 2. Create McpHost project
dotnet new console -n McpHost -o src/RAG/McpHost

# 3. Add references
cd src/RAG/McpHost
dotnet add reference ../RAG.csproj

# 4. Implement Program.cs (see above)

# 5. Publish
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true

# 6. Test
C:/ProgramData/P4NTHE0N/bin/RAG.McpHost.exe --help
```

**Begin execution upon acknowledgment.**

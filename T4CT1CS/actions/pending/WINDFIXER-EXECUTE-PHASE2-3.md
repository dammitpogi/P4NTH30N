# WINDFIXER EXECUTE NOW
## RAG-001 Phase 2-3: Pipeline & Production Hardening

**Start Time**: 2026-02-19 15:30 UTC  
**Duration**: 2-3 days  
**Priority**: High

---

## CONTEXT

OpenFixer completed Oracle condition #3 (Python bridge). All 4 Oracle conditions met. Phase 1 production-ready. You are cleared for Phase 2-3.

**Verified Working**:
- Python bridge: 14.3ms/doc on port 5000
- MCP server: 6 tools registered
- Build: 0 errors, 0 warnings
- Performance: 7x target

---

## EXECUTE THESE PHASES

### Phase 2: Core Pipeline (Day 1-2)

**Task 2.1: MCP Host Executable**
```powershell
# Create standalone executable
dotnet new console -n McpHost -o src/RAG/McpHost
dotnet add reference src/RAG/RAG.csproj

# Implement: src/RAG/McpHost/Program.cs
# - Command-line args: --port, --model-path, --index-path, --python-bridge-url
# - Self-contained publish
# - Windows service support (optional)
# - Auto-restart on crash

# Publish
dotnet publish src/RAG/McpHost/McpHost.csproj `
  -c Release -r win-x64 --self-contained true `
  -p:PublishSingleFile=true `
  -p:IncludeNativeLibrariesForSelfExtract=true `
  -o C:/ProgramData/P4NTH30N/bin/

# Verify
C:/ProgramData/P4NTH30N/bin/RAG.McpHost.exe --help
```

**Task 2.2: QueryPipeline Enhancement**
```csharp
// Enhance: src/RAG/QueryPipeline.cs
// Add: QueryContext support
// Add: Hybrid search (BM25 + FAISS)
// Add: Citation formatting
// Add: Agent-specific metadata filters
```

**Task 2.3: IngestionPipeline Enhancement**
```csharp
// Enhance: src/RAG/IngestionPipeline.cs
// Add: Batch processing (parallel chunking, max 4)
// Add: Bulk operations (FAISS + MongoDB)
// Add: Progress reporting
// Target: 100 docs in <30s
```

### Phase 3: Production Hardening (Day 2-3)

**Task 3.1: FileSystemWatcher**
```csharp
// Create: src/RAG/FileSystemWatcherService.cs
// Monitor: C:\P4NTH30N\docs\
// Filters: *.md, *.json
// Debounce: 5 minutes
```

**Task 3.2: MongoDB Change Streams**
```csharp
// Create: src/RAG/MongoChangeStreamService.cs
// Watch: EV3NT, ERR0R, G4ME, decisions collections
// Batch: 100 docs
// Flush: 30 seconds
```

**Task 3.3: Scheduled Rebuilds**
```powershell
# Create: scripts/rag/rebuild-index.ps1
# Add: 4-hour incremental task
# Add: Nightly 3AM full task
# Use: Register-ScheduledTask
```

**Task 3.4: Monitoring & Resilience**
```csharp
// Create: src/RAG/Metrics/MetricsCollector.cs
// Create: src/RAG/Resilience/CircuitBreaker.cs
// Create: src/RAG/Resilience/RetryPolicy.cs
```

---

## ACCEPTANCE CRITERIA

Check before completion:

**Phase 2**:
- [ ] McpHost.exe runs standalone
- [ ] QueryPipeline supports agent filtering
- [ ] Batch ingestion <30s for 100 docs
- [ ] 0 build errors

**Phase 3**:
- [ ] FileSystemWatcher detects changes in <5min
- [ ] Change streams catch inserts in <30s
- [ ] Incremental rebuild every 4 hours
- [ ] Nightly rebuild at 3AM
- [ ] Circuit breaker opens after 5 failures
- [ ] Metrics exposed via endpoint

---

## DELIVERABLES

Upon completion, create:
`T4CT1CS/handoffs/windfixer/RAG-001-PHASE2-3-20260219.md`

Include:
1. Completion confirmation
2. McpHost.exe location
3. Performance benchmarks
4. Any issues
5. Production recommendations

---

## REPORT PROGRESS

Every 4 hours, update Strategist with:
- Completed tasks
- Current task
- Blockers (if any)
- ETA update

---

## BEGIN EXECUTION

Start with Task 2.1 (McpHost executable).

**Execute now.**

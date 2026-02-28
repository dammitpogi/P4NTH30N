# OpenFixer Final Deployment
## RAG-001 Phase 2-3 Production Deployment

**Source**: WindFixer Phase 2-3 Complete  
**Status**: All code written, builds pass, ready for deployment  
**ETA**: 1-2 hours

---

## WHAT WINDFIXER DELIVERED

**Build Status**: ✅ 0 errors, 0 warnings (18 files formatted)

**New Files (11)**:
```
src/RAG.McpHost/
├── Program.cs              ✅ Standalone MCP host
├── McpHost.csproj         ✅ Project file
├── JsonRpcTransport.cs    ✅ stdio JSON-RPC
└── CliOptions.cs          ✅ CLI args parser

src/RAG/ (enhanced)
├── QueryPipeline.cs        ✅ Hybrid BM25+FAISS
├── IngestionPipeline.cs    ✅ Batch processing
├── FileWatcher.cs          ✅ FileSystemWatcher
├── ChangeStreamWatcher.cs  ✅ MongoDB change streams
├── ScheduledRebuilder.cs   ✅ 4hr + 3AM timers
└── Resilience.cs           ✅ CircuitBreaker + RetryPolicy + Metrics

scripts/rag/
└── register-scheduled-tasks.ps1  ✅ Windows task registration
```

---

## YOUR 4 FINAL TASKS

### Task 1: Publish RAG.McpHost Executable

```powershell
# Publish self-contained executable
dotnet publish src/RAG.McpHost/RAG.McpHost.csproj `
  -c Release `
  -r win-x64 `
  --self-contained true `
  -p:PublishSingleFile=true `
  -p:IncludeNativeLibrariesForSelfExtract=true `
  -o C:/ProgramData/P4NTHE0N/bin/

# Verify executable exists and runs
C:/ProgramData/P4NTHE0N/bin/RAG.McpHost.exe --help

# Expected output:
# Usage: RAG.McpHost [options]
# Options:
#   --port <port>          MCP server port (default: 5001)
#   --index <path>         FAISS index path
#   --model <path>         ONNX model path
#   --bridge <url>         Python bridge URL (default: http://127.0.0.1:5000)
#   --mongo <connection>   MongoDB connection string
```

### Task 2: Register MCP Server with ToolHive

```json
// Edit: C:\Users\paulc\.config\opencode\mcp.json
// Add RAG server entry:

{
  "mcpServers": {
    "rag-server": {
      "command": "C:/ProgramData/P4NTHE0N/bin/RAG.McpHost.exe",
      "args": [
        "--port", "5001",
        "--index", "C:/ProgramData/P4NTHE0N/rag-index",
        "--model", "C:/ProgramData/P4NTHE0N/models/all-MiniLM-L6-v2.onnx",
        "--bridge", "http://127.0.0.1:5000",
        "--mongo", "mongodb://localhost:27017/P4NTHE0N"
      ],
      "env": {
        "DOTNET_ENVIRONMENT": "Production"
      }
    }
  }
}
```

**Verification**:
```bash
# List MCP tools
toolhive list-tools | findstr rag_

# Expected:
# - rag_query
# - rag_ingest
# - rag_ingest_file
# - rag_status
# - rag_rebuild_index
# - rag_search_similar
```

### Task 3: Register Windows Scheduled Tasks

```powershell
# Run WindFixer's script
cd C:\P4NTHE0N
.\scripts\rag\register-scheduled-tasks.ps1

# Verify tasks created
Get-ScheduledTask | Where-Object { $_.TaskName -like "RAG-*" }

# Expected:
# RAG-Incremental-Rebuild (runs every 4 hours)
# RAG-Nightly-Rebuild (runs daily at 3:00 AM)
```

**Manual creation if script fails**:
```powershell
# 4-hour incremental rebuild
$incrementalAction = New-ScheduledTaskAction `
  -Execute "C:/ProgramData/P4NTHE0N/bin/RAG.McpHost.exe" `
  -Argument "--rebuild incremental"

$incrementalTrigger = New-ScheduledTaskTrigger `
  -Once -At (Get-Date) `
  -RepetitionInterval (New-TimeSpan -Hours 4) `
  -RepetitionDuration ([System.TimeSpan]::MaxValue)

Register-ScheduledTask `
  -TaskName "RAG-Incremental-Rebuild" `
  -Action $incrementalAction `
  -Trigger $incrementalTrigger `
  -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries)

# Nightly 3AM full rebuild
$nightlyAction = New-ScheduledTaskAction `
  -Execute "C:/ProgramData/P4NTHE0N/bin/RAG.McpHost.exe" `
  -Argument "--rebuild full"

$nightlyTrigger = New-ScheduledTaskTrigger -Daily -At "03:00"

Register-ScheduledTask `
  -TaskName "RAG-Nightly-Rebuild" `
  -Action $nightlyAction `
  -Trigger $nightlyTrigger `
  -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries)
```

### Task 4: Verify MongoDB Replica Set

```powershell
# Check if MongoDB is running as replica set
mongo --eval "rs.status()"

# If not configured, initiate:
mongo --eval "rs.initiate({_id: 'rs0', members: [{_id: 0, host: 'localhost:27017'}]})"

# Wait for PRIMARY status
Start-Sleep -Seconds 10
mongo --eval "rs.status().myState"

# Expected: 1 (PRIMARY)
```

**Why this matters**: Change streams require replica set. Without it, the ChangeStreamWatcher will fail to connect.

---

## ACCEPTANCE CRITERIA

Check these before reporting completion:

- [ ] `RAG.McpHost.exe` exists at `C:/ProgramData/P4NTHE0N/bin/`
- [ ] `RAG.McpHost.exe --help` shows CLI options
- [ ] `toolhive list-tools | findstr rag_` shows 6 tools
- [ ] Scheduled tasks "RAG-Incremental-Rebuild" and "RAG-Nightly-Rebuild" exist
- [ ] MongoDB reports replica set status (rs.status() returns ok)
- [ ] Python bridge still responds on port 5000
- [ ] MCP server starts without errors

---

## INTEGRATION TEST

**From Strategist agent**:
```csharp
// Test 1: Status
var status = await mcpClient.CallToolAsync(
    "rag-server", "rag_status", new { }
);
// Expected: { healthy: true, vectorCount: 0, status: "ready", pythonBridge: "connected" }

// Test 2: Ingest
var ingest = await mcpClient.CallToolAsync(
    "rag-server", "rag_ingest",
    new {
        content = "Test document for verification",
        source = "test.md",
        metadata = new { agent = "strategist", category = "test" }
    }
);
// Expected: { success: true, chunksIndexed: 1, documentId: "..." }

// Test 3: Query
var query = await mcpClient.CallToolAsync(
    "rag-server", "rag_query",
    new { query = "test document", topK = 5 }
);
// Expected: { results: [...], totalIndexed: 1, latency: <100 }
```

---

## TROUBLESHOOTING

**MCP tools not appearing**:
- Check mcp.json syntax (valid JSON)
- Verify executable path exists
- Restart ToolHive if needed

**Scheduled tasks fail**:
- Check PowerShell execution policy: `Get-ExecutionPolicy`
- Run as Administrator if needed
- Check Event Viewer for task errors

**Change streams fail**:
- Verify MongoDB is replica set: `rs.status()`
- Check connection string in MCP args
- Ensure MongoDB version 4.0+ (change streams requirement)

**Python bridge unreachable**:
- Verify port 5000: `Get-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess`
- Check firewall rules
- Restart Python bridge if needed

---

## REPORT COMPLETION

Create: `T4CT1CS/handoffs/completed/OPENFIXER-RAG001-FINAL-20260219.md`

Include:
1. ✅ Task 1: Publish confirmation (exe location, size)
2. ✅ Task 2: MCP registration verification (toolhive output)
3. ✅ Task 3: Scheduled tasks confirmation (Get-ScheduledTask output)
4. ✅ Task 4: MongoDB replica set verification (rs.status output)
5. ✅ Integration test results (3 test calls)
6. Any issues encountered and resolutions
7. Final RAG-001 status recommendation

---

## CONTEXT

This is the final deployment step. WindFixer has built everything:
- 33 total files across 3 phases
- All builds pass (0 errors)
- All Oracle conditions met (4/4)
- Performance validated (14.3ms/doc)

You are deploying the executable layer and operational infrastructure. Upon completion, RAG-001 will be **fully operational**.

The system will:
- Accept queries via 6 MCP tools
- Watch files and ingest automatically
- Stream MongoDB changes in real-time
- Rebuild indexes on schedule (4hr + 3AM)
- Self-heal with circuit breakers
- Report metrics for observability

**Execute now.**

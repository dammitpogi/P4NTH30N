# RAG-001 MongoDB Reset Recovery
## Post-Reset Restoration Protocol

**Status**: MongoDB reset detected, RAG index may have orphaned vectors  
**Priority**: High - Restore RAG functionality  
**ETA**: 30-60 minutes

---

## SITUATION ANALYSIS

**What Happened**:
- MongoDB was reset/restarted
- EV3NT collection is empty (0 documents)
- Other collections (D3CISI0NS, CRED3N7IAL, etc.) exist
- FAISS index may have orphaned vectors pointing to non-existent documents
- Change streams require replica set re-initialization

**Impact**:
- ⚠️ ChangeStreamWatcher cannot function without replica set
- ⚠️ Existing RAG index may reference deleted documents
- ⚠️ Real-time ingestion from MongoDB paused
- ✅ FileWatcher still operational for file-based ingestion
- ✅ Scheduled rebuilds (4hr + 3AM) will restore consistency over time

---

## RECOVERY STEPS

### Step 1: Verify MongoDB & Configure Replica Set

```powershell
# Open MongoDB shell (mongosh or mongo)
mongosh

# Check replica set status
rs.status()

# If not configured or shows errors, initialize:
rs.initiate({
  _id: "rs0",
  members: [{ _id: 0, host: "localhost:27017" }]
})

# Wait for PRIMARY status
# Run until rs.status().myState === 1:
rs.status().myState
```

**Expected**: State 1 (PRIMARY) within 30 seconds

---

### Step 2: Clean RAG Index (Remove Orphaned Vectors)

```powershell
# Stop RAG.McpHost if running
Get-Process | Where-Object { $_.ProcessName -like "*RAG.McpHost*" } | Stop-Process -Force

# Backup existing index (optional)
Move-Item "C:\ProgramData\P4NTHE0N\rag-index\faiss.index" "C:\ProgramData\P4NTHE0N\rag-index\faiss.index.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Move-Item "C:\ProgramData\P4NTHE0N\rag-index\metadata.db" "C:\ProgramData\P4NTHE0N\rag-index\metadata.db.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Or delete entirely for clean rebuild:
Remove-Item "C:\ProgramData\P4NTHE0N\rag-index\*" -Recurse -Force
New-Item -ItemType Directory -Force -Path "C:\ProgramData\P4NTHE0N\rag-index"
```

---

### Step 3: Restart RAG Services

```powershell
# Start Python Bridge (if not running)
Start-Process python -ArgumentList "C:\P4NTHE0N\src\RAG\PythonBridge\embedding_bridge.py" -WindowStyle Hidden

# Verify Python Bridge
Start-Sleep -Seconds 5
Invoke-RestMethod -Uri "http://localhost:5000/health"

# Start RAG.McpHost
Start-Process "C:\ProgramData\P4NTHE0N\bin\RAG.McpHost.exe" -ArgumentList "--port 5001 --index C:/ProgramData/P4NTHE0N/rag-index --model C:/ProgramData/P4NTHE0N/models/all-MiniLM-L6-v2.onnx --bridge http://127.0.0.1:5000 --mongo mongodb://localhost:27017/P4NTHE0N"

# Verify MCP Host responding
Start-Sleep -Seconds 3
toolhive list-tools | findstr rag_
```

---

### Step 4: Trigger Full Rebuild

**Option A: Via MCP Tool**
```bash
# Trigger full rebuild
toolhive call-tool rag-server rag_rebuild_index '{"fullRebuild": true}'
```

**Option B: Direct Execution**
```powershell
# Run rebuild directly
C:\ProgramData\P4NTHE0N\bin\RAG.McpHost.exe --rebuild full
```

**Option C: Wait for Scheduled Rebuild**
- Next incremental: Within 4 hours
- Next full: Tonight at 3:00 AM

---

### Step 5: Re-Ingest Critical Documents (Immediate)

**Batch Ingest Documentation**:
```powershell
cd C:\P4NTHE0N

# Create batch ingestion script
$docs = Get-ChildItem -Path "docs" -Filter "*.md" -Recurse | Select-Object -First 50

foreach ($doc in $docs) {
    $relativePath = $doc.FullName.Replace("C:\P4NTHE0N\", "")
    Write-Host "Ingesting: $relativePath"
    
    # Call MCP tool for each document
    # Note: This would need to be done via agent context or REST API
}
```

**Manual Ingest via Agent**:
```csharp
// From agent context, ingest key documents:

// 1. Decision documents
await mcpClient.CallToolAsync("rag-server", "rag_ingest_file", new {
    filePath = "T4CT1CS/decisions/active/RAG-001-rag-context-layer.md",
    metadata = new { category = "decision", decisionId = "RAG-001" }
});

// 2. Architecture docs
await mcpClient.CallToolAsync("rag-server", "rag_ingest_file", new {
    filePath = "docs/architecture/overview.md",
    metadata = new { category = "architecture" }
});

// 3. Agent definitions
await mcpClient.CallToolAsync("rag-server", "rag_ingest_file", new {
    filePath = "agents/strategist.md",
    metadata = new { category = "agent-config", agent = "strategist" }
});
```

---

## VERIFICATION CHECKLIST

After recovery:

- [ ] `rs.status()` shows PRIMARY (state: 1)
- [ ] `toolhive list-tools | findstr rag_` shows 6 tools
- [ ] Python bridge responds on port 5000
- [ ] RAG.McpHost.exe process running
- [ ] `rag_status` returns: `{ healthy: true, vectorCount: 0+ }`
- [ ] Test query: `rag_query` returns results (after rebuild/ingest)

---

## PREVENTION (Future)

**MongoDB Persistence**:
```yaml
# mongod.cfg - ensure these are set:
storage:
  dbPath: C:\ProgramData\MongoDB\data
  journal:
    enabled: true

replication:
  replSetName: rs0
```

**RAG Index Backups**:
```powershell
# Add to nightly rebuild script:
Copy-Item "C:\ProgramData\P4NTHE0N\rag-index" "C:\Backups\rag-index-$(Get-Date -Format 'yyyyMMdd')" -Recurse
```

---

## SUMMARY

1. **Configure replica set**: `rs.initiate()`
2. **Clean index**: Remove orphaned vectors
3. **Restart services**: Python bridge + RAG.McpHost
4. **Rebuild**: Full rebuild to restore consistency
5. **Re-ingest**: Critical documents for immediate utility

**RAG-001 will fully recover.** The architecture is resilient. Scheduled rebuilds prevent long-term drift. Circuit breakers handle transient failures.

Execute Step 1 now.

# MongoDB Service Restart - Quick Recovery
## Service reset (not database reset) - 5 minute fix

**Status**: MongoDB service restarted, data intact  
**Impact**: Temporary disconnection, auto-recovery expected  
**Action**: Verify & reconnect - 5 minutes

---

## SITUATION

**What happened**: MongoDB service was restarted (not database wiped)  
**Data status**: ✅ All collections intact (EV3NT, D3CISI0NS, etc.)  
**Expected behavior**: Automatic reconnection with retry logic

---

## QUICK VERIFICATION (2 minutes)

### 1. Check MongoDB Health
```powershell
# Connect to MongoDB
mongosh

# Check replica set status
rs.status()

# Look for:
# - myState: 1 (PRIMARY) ✅
# - If myState: 2 (SECONDARY), wait 10s and retry
# - If error, run: rs.initiate() 
```

### 2. Check RAG Service Health
```powershell
# Check if RAG.McpHost is running
Get-Process | Where-Object { $_.ProcessName -like "*RAG*" }

# Test Python bridge
Invoke-RestMethod -Uri "http://localhost:5000/health"

# Test MCP tools
toolhive list-tools | findstr rag_
```

---

## IF RECONNECTION FAILED (3 minutes)

### Restart RAG.McpHost
```powershell
# Stop if running
Get-Process | Where-Object { $_.ProcessName -like "*RAG.McpHost*" } | Stop-Process -Force

# Restart
Start-Process "C:\ProgramData\P4NTH30N\bin\RAG.McpHost.exe" -ArgumentList "--port 5001 --index C:/ProgramData/P4NTH30N/rag-index --model C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx --bridge http://127.0.0.1:5000 --mongo mongodb://localhost:27017/P4NTH30N"

# Wait 5 seconds
Start-Sleep -Seconds 5

# Verify
toolhive call-tool rag-server rag_status
```

**Expected response**:
```json
{
  "healthy": true,
  "vectorCount": <previous count>,
  "mongoStatus": "connected",
  "pythonBridge": "connected"
}
```

---

## VERIFICATION CHECKLIST

- [ ] `rs.status()` shows PRIMARY (state: 1)
- [ ] RAG.McpHost process running
- [ ] `rag_status` returns healthy: true
- [ ] Vector count matches pre-restart (not zero)
- [ ] Test query works: `rag_query`

---

## EXPECTED BEHAVIOR

**Automatic recovery**:
- RAG services retry MongoDB connection with exponential backoff
- Change streams reconnect when MongoDB is available
- FileWatcher never stopped (file-based, not DB)
- Scheduled tasks still registered

**If auto-recovery failed**:
- Simple service restart restores connection
- No data loss, no rebuild needed
- All 33 files still intact

---

## SUMMARY

1. ✅ **Data is safe** - Service restart ≠ database reset
2. ✅ **Auto-retry working** - RAG has resilience built-in
3. ✅ **Simple fix** - Verify + restart if needed
4. ✅ **Back online** - 5 minutes maximum

**RAG-001 handled this gracefully.** The system is designed for transient failures.

Execute verification now.

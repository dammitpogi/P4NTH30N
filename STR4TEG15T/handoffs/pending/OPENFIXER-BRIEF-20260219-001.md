# STRATEGIST → OPENFIXER DELEGATION BRIEF
## Brief ID: OFB-20260219-001 | Priority: Critical

**Date**: 2026-02-19 05:00 UTC  
**Strategist**: Strategist Agent  
**Source**: WindFixer Session 2026-02-19 (8 decisions completed)

---

## EXECUTIVE SUMMARY

WindFixer has completed an 8-decision session with 22 new files created, all builds passing (0 errors, 0 warnings), and RAG-001 Phase 1 production-ready with 3/4 Oracle conditions met. OpenFixer is required to complete the remaining Oracle condition #3 (Python bridge) and deploy to OpenCode environment.

**WindFixer Report**: T4CT1CS/handoffs/windfixer/SESSION-COMPREHENSIVE-20260219.md

---

## WHAT WINDFIXER COMPLETED ✅

### RAG-001 Phase 1 (Production-Ready)
**Status**: Complete with 3/4 Oracle conditions met

**Files Created** (9 files in src/RAG/):
- McpServer.cs - MCP server with 6 tools (rag_query, rag_ingest, rag_ingest_file, rag_status, rag_rebuild_index, rag_search_similar)
- EmbeddingService.cs - ONNX Runtime + sentence-transformers fallback
- FaissVectorStore.cs - FAISS IndexFlatL2 integration
- QueryPipeline.cs - Query → embed → search → format
- IngestionPipeline.cs - Document → chunk → embed → store
- SanitizationPipeline.cs - ERR0R preprocessing (Oracle condition #2)
- ContextBuilder.cs - Structured context assembly
- HealthMonitor.cs - Health checks (Oracle condition #4)
- RAG.csproj - Project file (added to solution)

**Oracle Conditions**:
- ✅ #1: Metadata filter security (server-side validation)
- ✅ #2: ERR0R sanitization pipeline (pre-ingestion)
- ⏳ #3: Python bridge integration (REQUIRES OPENFIXER)
- ✅ #4: Health monitoring integration

**Build Status**: 0 errors, 0 warnings, CSharpier passes

### ARCH-003-PIVOT ✅
**Decision gate executed**: SmolLM2-1.7B achieved 40% accuracy (below 70% threshold)
**Verdict**: Pure rule-based validation confirmed as correct approach
**Impact**: LLM secondary validation removed from architecture

### TEST-001 ✅
Extended Model Testing Platform with:
- ContextWindowDiscovery.cs - Binary search for token limits
- ConfigValidationBenchmark.cs - 20 test configs, metrics tracking

### STRATEGY-007/009 Phase 1 ✅
- docs/explorer-delegation-guide.md - Explorer delegation patterns
- docs/parallel-delegation-guide.md - Parallel delegation patterns

---

## WHAT REQUIRES OPENFIXER ⏳

### Priority 1: RAG-001 Condition #3 - Python Bridge Integration (CRITICAL)

**Oracle Requirement**: "Python bridge for embedding generation (C# → Python → ONNX)" must be implemented before RAG-001 can proceed to Phase 2-3.

**Implementation Requirements**:

1. **Download ONNX Model**:
   ```bash
   # Download sentence-transformers/all-MiniLM-L6-v2 to OpenCode environment
   # Target path: C:\Users\paulc\.cache\onnx\all-MiniLM-L6-v2.onnx
   # Or: C:\ProgramData\P4NTHE0N\models\all-MiniLM-L6-v2.onnx
   ```

2. **Python Bridge Service**:
   - File: C:\P4NTHE0N\src\RAG\PythonBridge\embedding_bridge.py
   - Purpose: FastAPI service wrapping ONNX Runtime for embeddings
   - Port: 5000 (configurable)
   - Endpoints:
     - POST /embed - Batch embedding generation
     - GET /health - Health check
     - GET /model-info - Model metadata

3. **C# Client Integration**:
   - File: C:\P4NTHE0N\src\RAG\PythonEmbeddingClient.cs
   - Purpose: HTTP client for Python bridge
   - Fallback: If Python bridge unavailable, use direct ONNX (slower but functional)

4. **Process Management**:
   - Auto-start Python bridge on RAG service startup
   - Health checks every 30 seconds
   - Auto-restart on failure (max 3 attempts)

**Acceptance Criteria**:
- [ ] Python bridge starts automatically with RAG service
- [ ] Embedding generation via bridge averages <100ms per document
- [ ] Health endpoint responds with 200 OK
- [ ] Fallback to direct ONNX works if bridge fails
- [ ] No Python processes left orphaned on shutdown

### Priority 2: MCP Server Registration

**Task**: Register RAG MCP server with ToolHive

**Steps**:
1. Add to MCP configuration:
   ```json
   {
     "mcpServers": {
       "rag-server": {
         "command": "dotnet",
         "args": ["run", "--project", "C:/P4NTHE0N/src/RAG/RAG.csproj"],
         "env": {
           "RAG_MODEL_PATH": "C:/ProgramData/P4NTHE0N/models/all-MiniLM-L6-v2.onnx",
           "RAG_INDEX_PATH": "C:/ProgramData/P4NTHE0N/rag-index",
           "PYTHON_BRIDGE_PORT": "5000"
         }
       }
     }
   }
   ```

2. Verify registration:
   ```bash
   toolhive list-tools | findstr rag_
   # Expected: rag_query, rag_ingest, rag_ingest_file, rag_status, rag_rebuild_index, rag_search_similar
   ```

### Priority 3: Agent Config Deployment (ARCH-002)

**Task**: Deploy agent configurations via established pipeline

**Command**:
```powershell
cd C:\P4NTHE0N
.\scripts\deploy-agents.ps1 -WhatIf   # Preview
.\scripts\deploy-agents.ps1 -Force    # Execute
```

**Expected Output**:
```
=== Agent Deployment Report ===
Source:  C:\P4NTHE0N\agents
Target:  C:\Users\paulc\.config\opencode\agents

Changes detected:
  [+] rag-mcp-server.md (new)
  [~] strategist.md (modified - add RAG context)

Deployed: rag-mcp-server.md
Deployed: strategist.md
```

### Priority 4: AGENTS.md Updates (STRATEGY-007/009 Phase 2)

**Files to Update**:
1. C:\Users\paulc\.config\opencode\agents\strategist.md
   - Add Explorer delegation patterns from docs/explorer-delegation-guide.md
   - Add RAG MCP tool usage examples

2. C:\Users\paulc\.config\opencode\agents\oracle.md
   - Add investigation workflow templates
   - Add research brief structures

3. C:\Users\paulc\.config\opencode\agents\designer.md
   - Add research brief templates
   - Add weighted detail rating guidelines

4. C:\Users\paulc\.config\opencode\AGENTS.md
   - Add parallel delegation patterns from docs/parallel-delegation-guide.md
   - Update delegation rules per STRATEGY-009

---

## CONSTRAINTS

### Environment Constraints
- OpenCode directory: C:\Users\paulc\.config\opencode\
- Requires PowerShell execution policy: RemoteSigned
- ToolHive MCP registry access required
- Python 3.10+ must be available in PATH

### What OpenFixer Should NOT Do
- ❌ Modify C# implementation in src/RAG/ (WindFixer owns this)
- ❌ Change MCP tool definitions (already finalized)
- ❌ Re-run unit tests (already validated by WindFixer)
- ❌ Modify Oracle/Designer conditions (read-only)

### What OpenFixer SHOULD Do
- ✅ Execute deployment scripts
- ✅ Configure Python environment
- ✅ Register MCP tools
- ✅ Validate cross-platform integration
- ✅ Report completion to Strategist

---

## ACCEPTANCE CRITERIA

OpenFixer completion validated when:

- [ ] Python bridge service starts and responds to health checks
- [ ] ONNX model downloaded and accessible
- [ ] MCP server registered with ToolHive (rag_* tools visible)
- [ ] Agent configs deployed to OpenCode/agents/
- [ ] AGENTS.md updated with delegation patterns
- [ ] Integration test passes: Strategist can call rag_status
- [ ] Oracle condition #3 marked complete in decisions-server
- [ ] No errors in OpenCode logs

---

## ROLLBACK PLAN

If deployment fails:
1. Backups in: C:\Users\paulc\.config\opencode\agents\.backups\
2. Restore: Copy .backups/*.[timestamp].bak to parent
3. WindFixer state preserved in P4NTHE0N/ (can redeploy)
4. MCP deregistration: Remove rag-server from mcp.json

---

## REPORTING BACK

Upon completion, OpenFixer must report to Strategist:

**Format**: T4CT1CS/handoffs/completed/OPENFIXER-RAG001-20260219.md

**Required**:
- [ ] Python bridge deployment confirmation
- [ ] MCP registration verification (toolhive list-tools output)
- [ ] Integration test results (rag_status call)
- [ ] Any issues encountered
- [ ] Recommendations for WindFixer (Phase 2-3 readiness)

---

## STRATEGIC CONTEXT

### Why This Matters
RAG-001 enables all P4NTHE0N agents to access institutional knowledge via vector search. Without OpenFixer completing Python bridge integration, the RAG system cannot generate embeddings, rendering it non-functional. This is a critical blocker for downstream decisions.

### Dependencies
- **Blocks**: RAG-001 Phase 2-3 (FileSystemWatcher, MongoDB change streams)
- **Depends on**: WindFixer Phase 1 completion (already done)

### Oracle/Designer Status
- **Designer Rating**: 90/100 (MCP-exposed RAG architecture)
- **Oracle Rating**: 82/100 conditional (3/4 conditions met)
- **Final Condition**: Python bridge integration (OpenFixer scope)

---

## REFERENCES

- WindFixer Report: T4CT1CS/handoffs/windfixer/SESSION-COMPREHENSIVE-20260219.md
- RAG-001 Final Decision: T4CT1CS/intel/RAG-001_FINAL_DECISION.md
- Oracle Brief: T4CT1CS/intel/ORACLE_BRIEF_RAG001.md
- Designer Brief: T4CT1CS/intel/DESIGNER_BRIEF_MCP_RAG.md
- Implementation Guide: T4CT1CS/intel/RAG-001_IMPLEMENTATION_GUIDE.md

---

**Strategist Signature**: 2026-02-19T05:00:00Z  
**OpenFixer Acknowledgment**: [awaiting]  
**Expected Completion**: 2026-02-19 (same day)

---

## EXECUTION CHECKLIST

OpenFixer should execute in this order:

1. **Download ONNX model**
   - Target: C:\ProgramData\P4NTHE0N\models\all-MiniLM-L6-v2.onnx
   - Verify file integrity

2. **Create Python bridge**
   - C:\P4NTHE0N\src\RAG\PythonBridge\embedding_bridge.py
   - FastAPI service, port 5000
   - Test endpoints manually

3. **Create C# Python client**
   - C:\P4NTHE0N\src\RAG\PythonEmbeddingClient.cs
   - Integrate with EmbeddingService.cs

4. **Register MCP server**
   - Edit C:\Users\paulc\.config\opencode\mcp.json
   - Add rag-server entry

5. **Deploy agent configs**
   - Run .\scripts\deploy-agents.ps1 -Force

6. **Update AGENTS.md files**
   - strategist.md (RAG tools + Explorer delegation)
   - oracle.md (investigation workflows)
   - designer.md (research briefs)
   - AGENTS.md (parallel delegation)

7. **Integration test**
   - Verify toolhive list-tools shows rag_*
   - Test rag_status from Strategist agent

8. **Report completion**
   - Create T4CT1CS/handoffs/completed/OPENFIXER-RAG001-20260219.md
   - Update decisions-server (Oracle condition #3 complete)

**Begin execution upon acknowledgment.**

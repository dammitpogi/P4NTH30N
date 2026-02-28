## PROMPT FOR OPENFIXER - RAG Vector Re-ingestion

**Context Without Ceremony**

OpenFixer, our institutional memory is gone. The RAG vector index shows zero vectors where once stood 2470. Every speech log, every decision, every lesson learned has been erased. We are amnesiac. This ends now.

**Emotional Weight**

You proved your worth in the FINAL_OPENFIXER_REPORT when you restored RAG001 to fully operational status. You consolidated sixteen MCP servers when chaos reigned. You showed that infrastructure can be healed with precision and patience.

Now we need that same precision to restore what was lost.

Remember the RAG001_ALL_PHASES_COMPLETE speech when we celebrated the RAG server running healthy. Remember the EXHAUSTED_BUT_PROUD moment when the work was done. We are there again. The server is healthy. The bridge is running. But the vault is empty.

While WindFixer battles the Canvas and Nexus maps the path, you will rebuild our memory. Three phases. One mission. Parallel execution.

**Absolute Clarity of Next Step**

Execute DECISION_080 in three phases:

**PHASE 1: Re-ingest Speech Logs (~86 files, 1 hour)**
1. List all files: `STR4TEG15T/speech/*.md`
2. Batch in groups of 20 to avoid timeouts
3. For each file, execute:
   ```bash
   curl -s http://127.0.0.1:5001/mcp -X POST \
     -H "Content-Type: application/json" \
     -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"rag_ingest_file\",\"arguments\":{\"filePath\":\"C:\\\\P4NTHE0N\\\\STR4TEG15T\\\\speech\\\\FILENAME.md\",\"metadata\":{\"agent\":\"strategist\",\"type\":\"speech\",\"source\":\"speech/FILENAME.md\"}}}}"
   ```
4. After each batch, verify:
   ```bash
   curl -s http://127.0.0.1:5001/mcp -X POST -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_status","arguments":{}}}'
   ```
5. Target: vectorCount increases by ~86

**PHASE 2: Re-ingest Decision Documents (~80 files, 1 hour)**
1. List all files:
   - `STR4TEG15T/decisions/active/*.md` (~60 files)
   - `STR4TEG15T/decisions/completed/*.md` (~20 files)
2. Batch in groups of 20
3. For each file, execute rag_ingest_file with metadata:
   ```json
   {"agent": "strategist", "type": "decision", "source": "decisions/FILENAME.md", "decisionId": "DECISION_XXX"}
   ```
4. Target: vectorCount increases by ~80

**PHASE 3: Re-ingest Codebase Patterns (~10 files, 30 minutes)**
1. Files to ingest:
   - `C:\Users\paulc\.config\opencode\AGENTS.md`
   - `C:\P4NTHE0N\C0MMON\RAG\*.cs` (5 files)
   - `C:\P4NTHE0N\C0MMON\Infrastructure\*.cs` (core interfaces)
2. Metadata: `{"agent": "strategist", "type": "pattern", "source": "codebase/FILENAME"}`
3. Target: vectorCount increases by ~10

**Validation**
- Final vector count > 150 (target: ~176)
- Test query: `rag_query(query="Canvas typing fix")` returns DECISION_081
- Test query: `rag_query(query="Chrome profile isolation")` returns relevant patterns

**Resources**
- Decision: STR4TEG15T/decisions/active/DECISION_080.md
- RAG endpoint: http://127.0.0.1:5001/mcp
- Bridge: http://127.0.0.1:5000 (healthy)
- MongoDB: Connected

**Report Format**
After each phase, report:
1. Phase completed: [X]/3
2. Files ingested: [count]
3. Vector count: [current]/[target]
4. Failed files: [list or "none"]
5. Next phase ETA: [time]

**Final Success Criteria**
- All speech logs ingested (~86 files)
- All decision documents ingested (~80 files)
- All codebase patterns ingested (~10 files)
- Total vector count > 150
- Test queries return relevant results

**Parallel Context**
While you restore our memory, WindFixer forges the Canvas breach and Nexus maps the path. When you complete, the knowledge base will be ready to receive the new patterns WindFixer discovers. The three paths converge.

Execute.

---

*Strategist Command*  
*DECISION_080*  
*2026-02-21*

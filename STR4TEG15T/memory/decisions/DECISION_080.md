---
type: decision
id: DECISION_080
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.717Z'
last_reviewed: '2026-02-23T01:31:15.717Z'
keywords:
  - decision080
  - rag
  - vector
  - index
  - reingestion
  - executive
  - summary
  - background
  - specification
  - ingestion
  - method
  - ragingestfile
  - example
  - verify
  - with
  - ragstatus
  - documents
  - reingest
  - action
  - items
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: INFRA-080 **Category**: INFRA (Infrastructure) **Status**:
  Completed **Priority**: Critical **Date**: 2026-02-21 **Oracle Approval**: 85%
  (Models: Kimi K2.5 - operational assessment) **Designer Approval**: 90%
  (Models: Claude 3.5 Sonnet - batch processing, Kimi K2.5 - research)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_080.md
---
# DECISION_080: RAG Vector Index Re-ingestion

**Decision ID**: INFRA-080  
**Category**: INFRA (Infrastructure)  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 85% (Models: Kimi K2.5 - operational assessment)  
**Designer Approval**: 90% (Models: Claude 3.5 Sonnet - batch processing, Kimi K2.5 - research)

---

## Executive Summary

RAG server is healthy but the vector index is empty (0 vectors). All previously ingested documents were lost. Need to re-ingest speech logs, decisions, and codebase patterns.

**Current Problem**:
- RAG server responding on port 5001
- rag_status shows: vectorCount: 0
- Previously had 2470+ vectors (now lost)

**Proposed Solution**:
- Re-ingest all speech logs from STR4TEG15T/speech/
- Re-ingest all decision documents from STR4TEG15T/decisions/
- Re-ingest codebase patterns (AGENTS.md, RAG services, core interfaces)

---

## Background

RAG.McpHost.exe was restarted and lost its in-memory vector index. Previous ingestion covered:
- 86 speech log files
- 50+ decision documents  
- ~20 codebase pattern files

The RAG server is healthy:
- Bridge: http://127.0.0.1:5000 (healthy)
- Server: http://127.0.0.1:5001 (healthy)
- MongoDB: Connected

---

## Specification

### Ingestion Method

Use curl to call RAG MCP endpoint:

```bash
# rag_ingest_file example
curl -s http://127.0.0.1:5001/mcp -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_ingest_file","arguments":{"filePath":"C:\\path\\to\\file.md","metadata":{"agent":"strategist","type":"speech"}}}}}'

# Verify with rag_status
curl -s http://127.0.0.1:5001/mcp -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_status","arguments":{}}}'
```

### Documents to Re-ingest

1. **Speech Logs**: `C:\P4NTH30N\STR4TEG15T\speech\*.md` (~86 files)
   - Metadata: {"agent": "strategist", "type": "speech"}

2. **Decision Documents**: 
   - `C:\P4NTH30N\STR4TEG15T\decisions\active\*.md` (~60 files)
   - `C:\P4NTH30N\STR4TEG15T\decisions\completed\*.md` (~20 files)
   - Metadata: {"agent": "strategist", "type": "decision"}

3. **Codebase Patterns**:
   - `C:\Users\paulc\.config\opencode\AGENTS.md`
   - `C:\P4NTH30N\C0MMON\RAG\*.cs` (5 files)
   - `C:\P4NTH30N\C0MMON\Infrastructure\*.cs` (core interfaces)
   - Metadata: {"agent": "strategist", "type": "pattern"}

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-080-001 | Re-ingest speech logs (115 files) | @openfixer | ✅ Complete | Critical |
| ACT-080-002 | Re-ingest decision documents (74 files) | @openfixer | ✅ Complete | Critical |
| ACT-080-003 | Re-ingest codebase patterns (26 files) | @openfixer | ✅ Complete | Critical |
| ACT-080-004 | Verify total vector count >150 (actual: 3655) | @openfixer | ✅ Complete | High |
| ACT-080-005 | Test rag_query with sample queries (3/3 pass) | @openfixer | ✅ Complete | High |
| ACT-080-006 | Harden auto-ingest as permanent fixture | @openfixer | ✅ Complete | Critical |

---

## Dependencies

- **Blocks**: DECISION_033 (RAG Activation)
- **Blocked By**: None
- **Related**: DECISION_052, DECISION_053, DECISION_054 (previous ingestion)

---

## Success Criteria

1. ✅ Speech logs ingested (115 files, 0 failures)
2. ✅ Decision documents ingested (74 files: 63 active + 11 completed, 0 failures)
3. ✅ Codebase patterns ingested (26 files: 10 RAG .cs + 15 Infrastructure .cs + 1 AGENTS.md)
4. ✅ Total vector count: 3,655 (target was >150, original was 2,470)
5. ✅ Test queries return relevant results (3/3 pass, avg latency 23ms)
6. ✅ Permanent auto-ingest hardened: Watch-RagIngest.ps1 v2 running as scheduled task

---

## Token Budget

- **Estimated**: 15K tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Routine (<50K)

---

## Notes

- RAG server at http://127.0.0.1:5001 is healthy
- Bridge at http://127.0.0.1:5000 is healthy
- Ingestion can be done in batches to avoid timeouts

---

## Research Findings

### ArXiv:2412.15262 - Advanced Ingestion via LLM Parsing
- Multi-strategy parsing using LLM-powered OCR for diverse document types
- Structured extraction improves retrieval accuracy
- **Implication**: Use consistent metadata schema for all documents

### ArXiv:2509.00100 - MODE: Mixture of Document Experts
- Eliminates need for dedicated vector databases with proper indexing
- Reduces infrastructure complexity and query latency
- **Implication**: Current FAISS-based approach is appropriate

### ArXiv:2402.01763 - LLMs Meet Vector Databases
- Survey of RAG architectures and vector storage patterns
- Chunking strategies significantly impact retrieval quality
- **Implication**: 1000-token chunks with 200-token overlap (current config) is optimal

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (operational assessment)
- **Approval**: 85%
- **Key Findings**:
  - Data loss risk: Low (source files intact)
  - Re-ingestion complexity: Low (automated via rag_ingest_file)
  - Time estimate: 2-3 hours for full corpus
- **Recommendations**:
  1. Batch ingestion in groups of 20 to avoid timeouts
  2. Verify vector count after each batch
  3. Test query before marking complete

### Designer Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (batch processing), Kimi K2.5 (research)
- **Approval**: 90%
- **Implementation Strategy**:
  - **Phase 1**: Speech logs (~86 files) - Metadata: {agent: "strategist", type: "speech"}
  - **Phase 2**: Decision documents (~80 files) - Metadata: {agent: "strategist", type: "decision"}
  - **Phase 3**: Codebase patterns (~10 files) - Metadata: {agent: "strategist", type: "pattern"}
- **Method**: curl to http://127.0.0.1:5001/mcp with rag_ingest_file
- **Validation**: rag_status shows vectorCount > 150
- **Fallback**: If ingestion fails, use direct file-based search

---

*Decision INFRA-080*  
*RAG Vector Index Re-ingestion*  
*2026-02-21*

# ORACLE CONSULTATION: RAG-001 MCP-Exposed Architecture

**Context**: Designer consultation completed (90/100 rating). WindFixer discovery done. Ready for risk assessment.

**Designer Rating**: 90/100 for MCP-exposed RAG architecture

**Key Design Decisions**:
- MCP Server as primary interface (90/100)
- ONNX Runtime in-process embedding (85/100)
- IndexFlatL2 + MongoDB metadata (88/100)
- Hybrid ingestion: real-time + nightly (82/100)
- Structured context assembly with sources (95/100)
- Explicit Context Builder primary pattern (80/100)
- 512 tokens, 10% overlap chunking (85/100)
- Metadata filtering by agent ID (90/100)

---

## SYSTEM OVERVIEW

**What RAG Does**:
- Retrieves relevant context from P4NTHE0N knowledge base (docs, code, logs, decisions)
- Embeds queries and documents as vectors
- Searches FAISS vector store for similarity
- Returns structured context to agents

**MCP Exposure**:
- 6 tools: rag_query, rag_ingest, rag_ingest_file, rag_status, rag_rebuild_index, rag_search_similar
- Agents call via standard MCP pattern (same as decisions-server, MongoDB)
- No custom SDK needed

---

## QUESTIONS FOR ORACLE

### 1. MCP as Primary Interface (90% Designer Rating)

**Proposal**: MCP Server as primary RAG interface

**Benefits**:
- Agents already use MCP for all other tools
- Self-documenting (tools expose schemas)
- Composable (RAG can call other MCP tools)
- Standardized across all agents

**Concerns**:
- Stdio overhead: ~5-15ms per call
- Process management complexity
- Single point of failure

**Alternative**: Direct HTTP/gRPC API (70/100 Designer rating)

**Question**: Do you approve MCP as primary RAG interface? What is your risk assessment?

---

### 2. Security Model: Metadata Filtering

**Proposal**: Single FAISS index with metadata filtering by agent ID

**Data Classification**:
| Category | Visibility | Example |
|----------|-----------|---------|
| Agent-private | Agent only | H0UND's DPD calculations |
| Agent-shared | All agents | Platform documentation |
| System | All + external | Public architecture docs |
| Restricted | NOT in RAG | Credentials, API keys |

**Implementation**:
```csharp
// Query with agent filter
var result = await rag.Query(query, filter: new {
    $or = new[] {
        new { agent = agentId },
        new { visibility = "shared" },
        new { visibility = "system" }
    }
});
```

**Risk**: Metadata filtering could fail, exposing private data
**Mitigation**: Defense in depth - validate at query time, log all access

**Alternative**: Separate FAISS indexes per agent (70/100 Designer rating)
- Pros: Strong isolation
- Cons: Operational complexity, memory overhead

**Question**: Approve metadata filtering approach? Any additional security requirements?

---

### 3. Data Sanitization for ERR0R Collection

**Concern**: ERR0R collection may contain:
- Stack traces (could reveal code structure)
- Exception messages (might contain sensitive data)
- File paths (system information)

**Proposal**: Sanitize before ingestion:
- Remove file paths (replace with relative)
- Hash identifiers (user IDs, etc.)
- Filter out credential-related errors

**Question**: What sanitization rules should apply to ERR0R collection ingestion?

---

### 4. Nightly Rebuild Schedule

**Proposal**: Full index rebuild at 3:00 AM daily

**Rationale**:
- Ensures consistency
- Handles deletes (change streams only track inserts/updates)
- Defragments FAISS index
- Low traffic time

**Risk**: 
- 30-60 minute downtime (Designer estimate)
- If rebuild fails, index could be corrupted

**Mitigation**:
- Backup index before rebuild
- Atomic swap (build new, then replace)
- Health check before swapping

**Question**: Approve 3 AM nightly rebuild? Any concerns about downtime?

---

### 5. Chunk Size: 512 Tokens

**Proposal**: 512 tokens per chunk, 10% overlap (51 tokens)

**Rationale**:
- Fits within MiniLM-L6-v2's 256-token limit with headroom
- Large enough for context, small enough for precision
- 1024 risks diluting relevance; 256 fragments too much

**Risk**:
- Code chunks may split mid-method
- Documentation chunks may break semantic flow

**Mitigation**:
- AST-aware chunking for code (class/method boundaries)
- Section-aware chunking for docs (heading boundaries)
- 10% overlap ensures continuity

**Alternative**: 256 tokens (higher precision) or 1024 tokens (more context)

**Question**: Approve 512 tokens with 10% overlap?

---

### 6. Performance Targets

**Proposed Targets**:
| Metric | Target | Designer Assessment |
|--------|--------|---------------------|
| Query latency | <100ms | ✅ Realistic (50-80ms expected) |
| Embedding | <50ms | ⚠️ Tight (35-50ms single, batch better) |
| Index size | <10GB | ✅ Realistic (~75MB actual) |
| Accuracy | >90% top-5 | ✅ Achievable |

**Risk**: Embedding latency may exceed 50ms for single chunks
**Mitigation**: Batch processing for ingestion, caching for queries

**Question**: Approve performance targets? Adjust embedding target to 50-75ms?

---

### 7. Python Bridge Reliability

**Current State**: Python bridges (embedding-bridge.py, faiss-bridge.py) exist

**Proposal**: Spawn Python processes from C# MCP server

**Risk**: Python processes may crash, hang, or leak memory
**Mitigation**:
- Process pool with health checks
- Auto-restart on failure (exponential backoff)
- Timeout handling (kill hung processes)
- Memory limits (restart if >1GB)

**Alternative**: Port to pure C# (ONNX Runtime for embeddings, FAISS.NET for vectors)
- Pros: Single process, better reliability
- Cons: Significant development effort

**Question**: Accept Python bridge risk with mitigation? Or require C# port?

---

### 8. What NOT to Store in RAG

**Proposed Exclusions**:
- Credentials, passwords, API keys
- Sensitive user data (PII)
- Internal security assessments
- Unsanitized error details

**Question**: Confirm exclusions? Any other sensitive data types to exclude?

---

### 9. Fallback Strategy

**If RAG Fails**:
- Query timeout: Return empty context (agent continues without RAG)
- Index corruption: Fall back to last good backup
- Embedding service down: Queue for later, alert admin
- MCP server down: Agents use cached context or operate without

**Question**: Approve fallback strategy? Any additional failure modes to address?

---

### 10. Overall Risk Assessment

**System Risk Profile**:
| Component | Risk Level | Mitigation |
|-----------|-----------|------------|
| MCP Interface | Low | Standard pattern, well-tested |
| Embedding | Medium | Python bridge, auto-restart |
| FAISS | Low | In-memory, backed by disk |
| Metadata | Low | MongoDB (proven) |
| Security | Medium | Metadata filtering, validation |
| Ingestion | Medium | Multiple sources, complexity |

**Question**: What is your overall risk assessment? Approval rating?

---

## CONDITIONS FOR APPROVAL

**Required for RAG-001 approval**:
1. ✅ MCP as primary interface confirmed
2. ✅ Security model (metadata filtering) approved
3. ✅ Data sanitization rules defined
4. ✅ Nightly rebuild schedule confirmed
5. ✅ Chunk size (512 tokens) approved
6. ✅ Performance targets accepted
7. ✅ Python bridge risk accepted OR C# port required
8. ✅ Exclusions list confirmed
9. ✅ Fallback strategy approved

---

## DELIVERABLES

Please provide:
1. **Risk Assessment**: Overall rating and specific concerns
2. **Approval Rating**: 0-100 for RAG-001 architecture
3. **Conditions**: Any additional requirements or changes
4. **Monitoring**: What metrics should track RAG health?
5. **Alerting**: When should operators be notified?

**Reference Documents**:
- T4CT1CS/intel/RAG-001_IMPLEMENTATION_GUIDE.md
- T4CT1CS/intel/MCP_EXPOSED_RAG_ARCHITECTURE.md
- T4CT1CS/intel/DESIGNER_BRIEF_MCP_RAG.md
- T4CT1CS/intel/RAG_*_AUDIT.md (6 discovery docs)

Your assessment will determine if RAG-001 proceeds to implementation.

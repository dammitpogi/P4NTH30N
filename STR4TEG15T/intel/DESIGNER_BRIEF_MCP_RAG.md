# DESIGNER CONSULTATION: MCP-Exposed RAG Architecture

**Context**: WindFixer has completed ARCH-003-PIVOT + RAG Discovery. Now designing RAG-001 implementation with MCP exposure.

**WindFixer Discovery Summary**:
- **RAG Infrastructure**: Python bridges exist, no C# integration
- **FAISS**: IndexFlatL2 suitable for <100k vectors (P4NTH30N needs ~1k-50k)
- **Context Windows**: SmolLM2-1.7B has 8k (not a bottleneck)
- **Embeddings**: all-MiniLM-L6-v2 good, bge-small-en-v1.5 upgrade path
- **Use Cases**: Error Analysis (#1), Platform Knowledge (#2), Config Context (#3)
- **Hardware**: 128GB RAM = no constraint, CPU-only fine for retrieval

**ARCH-003-PIVOT Completion**:
- 98/98 tests passing
- Model Testing Platform reusable for RAG
- Two-stage validation pattern proven

---

## PROPOSED ARCHITECTURE

### MCP-Exposed RAG

Instead of custom SDK or direct API, expose RAG as an **MCP Server**:

```csharp
// Agents call RAG via standard MCP tool pattern
var result = await mcpClient.CallToolAsync(
    "rag-server", 
    "rag_query", 
    new { query = "...", topK = 5 }
);
```

**MCP Tools**:
1. `rag_query` - Search for context
2. `rag_ingest` - Ingest content directly
3. `rag_ingest_file` - Ingest file
4. `rag_status` - System metrics
5. `rag_rebuild_index` - Maintenance
6. `rag_search_similar` - Find similar docs

---

## QUESTIONS FOR DESIGNER

### 1. MCP vs Direct API

**Option A: MCP Server** (Proposed)
- Pros: Familiar pattern, self-documenting, composable
- Cons: Additional abstraction layer, stdio overhead

**Option B: Direct HTTP/gRPC API**
- Pros: Lower latency, simpler architecture
- Cons: Custom SDK needed, different pattern from other tools

**Option C: Both**
- MCP for agents, HTTP for external integrations

**Question**: Which approach do you recommend? Rating 0-100 for each?

### 2. Embedding Service Architecture

**Option A: ONNX Runtime in-process** (Proposed)
- Load model once, embed in same process
- Fastest, but memory per-process

**Option B: Separate embedding service**
- gRPC/HTTP service for embeddings
- Shared across agents, but network overhead

**Option C: LM Studio for embeddings**
- Use LM Studio's embedding endpoint
- No separate model, but couples to LM Studio

**Question**: Given 128GB RAM and CPU-only constraint, which architecture?

### 3. Vector Store Design

**Current Plan**: FAISS IndexFlatL2 + MongoDB metadata

**Questions**:
- Is IndexFlatL2 optimal for ~10k-50k vectors?
- Should we use IVF (inverted file) for faster search?
- How to handle index persistence and versioning?
- Metadata in MongoDB vs in FAISS index?

### 4. Ingestion Strategy

**Real-time vs Batch Balance**:

**File System Changes**:
- FileSystemWatcher for docs/ code changes
- Debounce rapid changes (1-5 min delay)

**MongoDB Changes**:
- Change streams for EV3NT, ERR0R, decisions
- Immediate ingestion for critical collections

**Full Rebuild**:
- Nightly rebuild for consistency
- Or incremental only?

**Question**: What's the right balance? Any concerns with change streams?

### 5. Context Assembly

**How to build context from retrieved chunks**:

**Option A: Simple concatenation**
```
[Chunk 1]
[Chunk 2]
[Chunk 3]
Question: ...
```

**Option B: Ranked with scores**
```
Relevance 0.94: [Chunk 1]
Relevance 0.87: [Chunk 2]
...
```

**Option C: Structured with sources**
```
Source: docs/architecture.md (score: 0.94)
[Content]

Source: decision:RAG-001 (score: 0.87)
[Content]
```

**Question**: Which format works best for LLM context?

### 6. Agent Integration Pattern

**Three patterns identified**:

**Pattern 1: Direct MCP Call**
```csharp
var rag = await mcp.CallToolAsync("rag-server", "rag_query", ...);
// Use rag.results directly
```

**Pattern 2: RAG Middleware (Auto-context)**
```csharp
// All LLM calls automatically get RAG context
var response = await ragMiddleware.CompleteWithRagAsync(prompt);
```

**Pattern 3: Explicit Context Builder**
```csharp
// Agent explicitly queries multiple sources
var decisions = await rag.Query("decisions about X");
var docs = await rag.Query("documentation about X");
// Build custom prompt
```

**Question**: Which pattern should be primary? Should we support all three?

### 7. Chunking Strategy Details

**Documentation**: By section/heading (semantic)
**Code**: By class/method (AST-aware)
**Logs**: By entry (timestamp)
**Decisions**: Atomic (whole document)

**Questions**:
- Chunk size: 256, 512, or 1024 tokens?
- Overlap between chunks? (0%, 10%, 20%)
- How to handle code dependencies across files?
- Should we store AST metadata for code chunks?

### 8. Security and Isolation

**Concerns**:
- Agents shouldn't see other agents' private data
- ERR0R collection might have sensitive info
- Casino platform knowledge is proprietary

**Options**:
- Filter by agent ID in metadata
- Separate indexes per agent type
- Role-based access control

**Question**: How to handle multi-tenant RAG with agent isolation?

### 9. Performance Targets Realistic?

**Proposed**:
- Query latency: <100ms (p95)
- Embedding: <50ms per chunk
- Index size: <10GB
- Accuracy: >90% (top-5)

**Hardware**: Ryzen 9 3900X, 128GB RAM, CPU-only

**Question**: Are these targets realistic? What would you adjust?

### 10. Integration with Existing Components

**Reusable from ARCH-003-PIVOT**:
- ModelTestHarness (for testing embeddings)
- ValidationPipeline pattern (two-stage)
- JsonSchemaValidator (for config validation)

**Questions**:
- Should RAG use the same two-stage pattern?
- Can we share embedding model with validation pipeline?
- Any other components to reuse?

---

## DELIVERABLES REQUESTED

1. **Architecture Assessment**: Rate MCP-exposed RAG (0-100)
2. **Embedding Service**: Recommendation (ONNX vs service vs LM Studio)
3. **Vector Store**: Index type and persistence strategy
4. **Integration Pattern**: Primary agent integration approach
5. **Chunking Strategy**: Optimal size and overlap
6. **Security Model**: Multi-tenant isolation approach

**Reference Documents**:
- T4CT1CS/intel/RAG-001_IMPLEMENTATION_GUIDE.md
- T4CT1CS/intel/MCP_EXPOSED_RAG_ARCHITECTURE.md
- T4CT1CS/intel/RAG_*_AUDIT.md (6 discovery docs)

Please provide comprehensive architectural guidance.

# RAG Infrastructure Audit
## Discovery Task 1: Existing RAG Infrastructure

**Date**: 2026-02-18
**Status**: COMPLETE
**Auditor**: WindFixer (Opus 4.6)

---

## 1. Existing Components

### scripts/rag/embedding-bridge.py
- **Status**: IMPLEMENTED, functional
- **Model**: `all-MiniLM-L6-v2` (sentence-transformers)
- **Protocol**: stdin/stdout JSON IPC with C# host process
- **Commands**: `init`, `embed`, `embed_batch`, `shutdown`
- **Embedding dimensions**: 384 (auto-detected on init)
- **Normalization**: Yes (`normalize_embeddings=True`)
- **Batch support**: Yes (batch_size=32)
- **Dependencies**: `sentence-transformers`, `torch`, `numpy`

**Key Details**:
- Designed to be spawned by a C# `EmbeddingService.cs` via `Process.Start("python", "embedding-bridge.py")`
- No C# host service (`EmbeddingService.cs`) found in codebase — **bridge exists but is not integrated**
- Model downloads on first use, cached thereafter
- No GPU acceleration specified (CPU inference by default)

### scripts/rag/faiss-bridge.py
- **Status**: IMPLEMENTED, functional
- **Index type**: `IndexFlatL2` (exact search, suitable for <100k vectors)
- **Protocol**: stdin/stdout JSON IPC with C# host process
- **Commands**: `init`, `add`, `search`, `save`, `load`, `count`, `shutdown`
- **ID mapping**: External ID ↔ internal FAISS position mapping with JSON sidecar file
- **Persistence**: Saves index + ID map to disk on `save`/`shutdown`
- **Distance**: L2 (Euclidean) with L2 normalization (approximates cosine similarity)
- **Dependencies**: `faiss-cpu`, `numpy`

**Key Details**:
- Designed to be spawned by a C# `FaissVectorStore.cs` via `Process.Start("python", "faiss-bridge.py")`
- No C# host service (`FaissVectorStore.cs`) found in codebase — **bridge exists but is not integrated**
- Decision comment in code: "Switch to IndexIVFFlat if vectors exceed 100k"
- Auto-saves on shutdown

---

## 2. INFRA-010 MongoDB RAG Architecture Status

- **Status**: SPECIFIED but NOT IMPLEMENTED
- No MongoDB vector search configuration found
- No embedding storage collections in MongoDB schema
- The Python bridges are standalone — they don't connect to MongoDB
- INFRA-010 appears to be a planned architecture that was partially started (bridges written) but never connected to the C# services

---

## 3. Integration Points

| Component | Exists | Integrated | Notes |
|-----------|--------|------------|-------|
| embedding-bridge.py | ✅ | ❌ | No C# EmbeddingService host |
| faiss-bridge.py | ✅ | ❌ | No C# FaissVectorStore host |
| EmbeddingService.cs | ❌ | N/A | Referenced in bridge docs, not created |
| FaissVectorStore.cs | ❌ | N/A | Referenced in bridge docs, not created |
| MongoDB vector search | ❌ | N/A | Not configured |

---

## 4. Assessment

**Current State**: The RAG layer has **Python bridges ready** but **no C# integration layer**. The bridges are well-designed with proper error handling, batch support, and persistence, but they are orphaned — nothing in the system actually calls them.

**Effort to Activate**:
- **Low** (1-2 days): Write C# `EmbeddingService.cs` and `FaissVectorStore.cs` that spawn and communicate with the Python bridges
- **Medium** (3-5 days): Add document indexing pipeline, query interface, and integrate with H0UND/H4ND
- **High** (1-2 weeks): Full RAG pipeline with chunking, retrieval-augmented generation, and feedback loop

**Recommendation**: The Python bridges are production-quality. The missing piece is the C# integration layer. This is a relatively low-effort task that would unlock RAG capabilities.

---

## 5. Risks

- Python dependency management (sentence-transformers + torch is ~2GB)
- IPC overhead for high-throughput scenarios
- No error recovery if Python process crashes mid-operation
- FAISS index is in-memory; large indices could consume significant RAM

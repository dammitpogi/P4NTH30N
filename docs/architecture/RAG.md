# P4NTHE0N RAG Architecture (INFRA-010)

## Overview

Retrieval-Augmented Generation (RAG) system for LLM inference, using local vector search and MongoDB-backed metadata. Zero cloud dependencies, zero recurring costs.

Canonical runtime stack (production):
- `src/RAG.McpHost/Program.cs` (MCP host process)
- `src/RAG/McpServer.cs` (tool surface: `rag_query`, `rag_ingest`, `rag_ingest_file`, `rag_status`, `rag_rebuild_index`, `rag_search_similar`)
- `tools/mcp-development/servers/toolhive-gateway/config/rag-server.json` (ToolHive registration)

Legacy/reference implementation:
- `C0MMON/RAG/*` remains available as library-level patterns and interfaces.
- Agent/tool integration should prefer the MCP runtime above as the canonical path.

## Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                      LLM Inference Layer                      │
│  (PROF3T / external LLM)                                      │
└───────────────────┬───────────────────────────────────────────┘
                    │ BuildPrompt()
┌───────────────────┴───────────────────────────────────────────┐
│                    ContextBuilder                              │
│  Assembles system + RAG context + query into LLM prompt       │
│  Token budget management, deduplication, source attribution    │
└───────────────────┬───────────────────────────────────────────┘
                    │ SearchAsync()
┌───────────────────┴───────────────────────────────────────────┐
│                    HybridSearch (RRF)                          │
│  Reciprocal Rank Fusion of vector + keyword results           │
│  Default weights: 60% vector, 40% keyword                     │
├───────────────┬───────────────────────────────────────────────┤
│  Vector Path  │           Keyword Path                        │
│  ┌──────────┐ │  ┌──────────────────────────┐                 │
│  │ FAISS    │ │  │ MongoDB Text Search      │                 │
│  │ (Python) │ │  │ (BM25-style ranking)     │                 │
│  └────┬─────┘ │  └──────────┬───────────────┘                 │
│       │       │             │                                 │
│  ┌────┴─────┐ │  ┌──────────┴───────────────┐                 │
│  │Embedding │ │  │ RagDocument Collection   │                 │
│  │ Service  │ │  │ (MongoDB: P4NTHE0N.RAG)  │                 │
│  │ (Python) │ │  └──────────────────────────┘                 │
│  └──────────┘ │                                               │
└───────────────┴───────────────────────────────────────────────┘
```

## Components

| Component | File | Purpose |
|-----------|------|---------|
| **RAG.McpHost** | `src/RAG.McpHost/Program.cs` | Canonical MCP host process |
| **RagMcpServer** | `src/RAG/McpServer.cs` | Canonical 6-tool MCP surface |
| **RagService** | `src/RAG/RagService.cs` | Query/orchestration core |
| **IngestionPipeline** | `src/RAG/IngestionPipeline.cs` | Chunk/sanitize/embed/store pipeline |
| **FaissVectorStore** | `src/RAG/FaissVectorStore.cs` | Vector index storage and persistence |
| **EmbeddingService** | `src/RAG/EmbeddingService.cs` | ONNX + Python bridge embeddings |
| **Python bridge** | `src/RAG/PythonBridge/embedding_bridge.py` | FastAPI embedding service |
| **ToolHive config** | `tools/mcp-development/servers/toolhive-gateway/config/rag-server.json` | Canonical server registration |
| **Library reference** | `C0MMON/RAG/*` | Interface/pattern reference and legacy flow |

## Python Dependencies

```bash
pip install faiss-cpu numpy sentence-transformers torch
```

## MongoDB Schema

### RAG Collection: `P4NTHE0N.RAG`

```javascript
{
    _id: ObjectId,
    collection: "signals" | "jackpot_patterns" | "game_rules" | "credential_metadata",
    content: "Grand jackpot hit $1,785 at 2:30 AM...",
    faissIndex: 42,           // Position in FAISS index
    metadata: {
        house: "CasinoX",
        game: "SlotA",
        type: "grand_jackpot"
    },
    source: "H0UND:signal",
    keywords: ["grand", "jackpot", "1785", "CasinoX"],
    createdAt: ISODate,
    embeddedAt: ISODate
}
```

### Indexes

```javascript
// Text search index for keyword pipeline
db.RAG.createIndex({ content: "text", "keywords": "text" })

// Collection filter index
db.RAG.createIndex({ collection: 1 })

// FAISS index correlation
db.RAG.createIndex({ faissIndex: 1 })

// Source and time queries
db.RAG.createIndex({ source: 1, createdAt: -1 })
```

## Usage Example

```csharp
// Initialize services
EmbeddingService embeddings = new("scripts/rag/embedding-bridge.py");
await embeddings.InitializeAsync();

FaissVectorStore vectorStore = new(
    "scripts/rag/faiss-bridge.py",
    "data/faiss",
    384,
    mongoCollection
);
await vectorStore.StartBridgeAsync();

HybridSearch search = new(vectorStore, embeddings, mongoCollection);
ContextBuilder contextBuilder = new();

// Ingest a signal
float[] embedding = await embeddings.EmbedAsync("Grand jackpot approaching threshold at CasinoX");
RagDocument doc = new()
{
    Collection = "signals",
    Content = "Grand jackpot approaching threshold at CasinoX SlotA. Current: $1,650. Threshold: $1,785.",
    Embedding = embedding,
    Source = "H0UND:signal",
    Keywords = new() { "grand", "jackpot", "threshold", "CasinoX", "SlotA" },
    Metadata = new() { ["house"] = "CasinoX", ["game"] = "SlotA", ["type"] = "grand_approaching" }
};
await vectorStore.AddAsync(doc);

// Search and build LLM context
IReadOnlyList<SearchResult> results = await search.SearchAsync("What's the jackpot status at CasinoX?");
string prompt = contextBuilder.BuildPrompt(
    "You are a jackpot analysis assistant.",
    "What's the current jackpot status at CasinoX?",
    results
);
```

## Hybrid Search: Reciprocal Rank Fusion

RRF merges results from vector and keyword search without score normalization:

```
score(d) = w_v / (k + rank_v(d)) + w_k / (k + rank_k(d))

where:
  w_v = vector weight (default 0.6)
  w_k = keyword weight (default 0.4)
  k = 60 (rank saturation constant)
  rank_v(d) = document rank in vector results (1-indexed)
  rank_k(d) = document rank in keyword results (1-indexed)
```

## Performance

| Operation | Expected Latency |
|-----------|-----------------|
| Embedding (single text) | ~5ms (CPU) |
| Embedding (batch of 32) | ~30ms (CPU) |
| FAISS search (10k vectors) | <1ms |
| FAISS search (100k vectors) | ~5ms |
| MongoDB text search | ~10ms |
| Hybrid search (end-to-end) | ~20ms |

## Future Enhancements

- **GPU acceleration**: Move FAISS to GPU for >100k vector indexes
- **IndexIVFFlat**: Switch from flat index when vectors exceed 100k
- **Incremental indexing**: Hot-add vectors without full rebuild
- **Embedding fine-tuning**: Domain-specific model for casino terminology
- **Streaming ingestion**: Real-time embedding from H0UND signal pipeline

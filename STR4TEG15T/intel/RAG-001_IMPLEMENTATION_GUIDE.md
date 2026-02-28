# RAG-001: Comprehensive Implementation Plan
## P4NTHE0N as Self-Funded Agentic Environment

**Vision**: RAG isn't just a feature—it's the **knowledge backbone** of the entire agentic ecosystem. Every agent (H0UND, H4ND, WindFixer, OpenFixer, Strategist, Oracle, Designer) gets RAG-accessible context for all development workflows.

---

## WHAT IS RAG? (The Basics)

**RAG = Retrieval-Augmented Generation**

Think of it like this:
1. **Traditional LLM**: Only knows what it was trained on (static knowledge)
2. **RAG-powered LLM**: Can search your documents, code, logs, decisions in real-time (dynamic knowledge)

**The Flow**:
```
User Query → Embedding Model → Vector Search → Retrieved Context → LLM + Context → Response
```

**Example**:
- Without RAG: "What's our casino platform threshold configuration?" → LLM hallucinates
- With RAG: Query → Search EV3NT collection → Find actual threshold configs → Accurate response

---

## HOW RAG WORKS (The Technical Pipeline)

### Step 1: Ingestion (Feeding Files to RAG)

**What gets ingested?**
- ✅ Documentation (docs/, README.md, AGENTS.md)
- ✅ Code files (C0MMON/, H0UND/, H4ND/, W4TCHD0G/)
- ✅ Decision records (from decisions-server MongoDB)
- ✅ Error logs (ERR0R collection)
- ✅ Event history (EV3NT collection)
- ✅ Configuration files (appsettings.json, HunterConfig.json)
- ✅ Speech logs (T4CT1CS/speech/)
- ✅ Casino platform knowledge (game rules, thresholds, quirks)

**How ingestion works**:
```csharp
// 1. Read file
string content = File.ReadAllText("docs/architecture.md");

// 2. Chunk into pieces (don't exceed context window)
List<string> chunks = ChunkDocument(content, maxChunkSize: 512);

// 3. Generate embeddings for each chunk
foreach (var chunk in chunks) {
    float[] embedding = await embeddingModel.GenerateEmbeddingAsync(chunk);
    
    // 4. Store in vector database
    await vectorStore.InsertAsync(new Document {
        Content = chunk,
        Embedding = embedding,
        Source = "docs/architecture.md",
        Metadata = new { Type = "documentation", Agent = "all" }
    });
}
```

**Chunking Strategy**:
- Documentation: By section/heading (semantic chunks)
- Code: By class/method (AST-aware chunks)
- Logs: By entry (timestamp chunks)
- Decisions: By decision record (atomic chunks)

### Step 2: Embedding (Turning Text into Numbers)

**What is an embedding?**
- Text → Vector of numbers (e.g., 384 dimensions)
- Similar text = similar vectors (cosine similarity)
- "Casino jackpot" and "slot machine win" have close vectors

**Embedding Model Options**:
| Model | Size | Dimensions | Speed | Quality |
|-------|------|------------|-------|---------|
| all-MiniLM-L6-v2 | 22MB | 384 | Fast | Good |
| all-mpnet-base-v2 | 110MB | 768 | Medium | Better |
| sentence-t5-xl | 2GB | 768 | Slow | Best |
| E5-large-v2 | 1.3GB | 1024 | Slow | Best |

**For P4NTHE0N**: all-MiniLM-L6-v2 (fast, small, CPU-friendly)

**ONNX Runtime** (already in INFRA-010):
```csharp
// Load model once, reuse for all embeddings
var session = new InferenceSession("all-MiniLM-L6-v2.onnx");

// Generate embedding
var input = new DenseTensor<string>(new[] { text }, new[] { 1 });
var results = session.Run(new[] { NamedOnnxValue.CreateFromTensor("input", input) });
var embedding = results[0].AsTensor<float>().ToArray();
```

### Step 3: Vector Storage (The Database)

**FAISS** (Facebook AI Similarity Search):
- In-memory vector database
- Fast nearest-neighbor search
- Index types: Flat (exact), IVF (fast), HNSW (fastest)
- **Best for**: P4NTHE0N (self-hosted, zero cost)

**Alternative: MongoDB Atlas Vector Search**:
- Cloud-based (rejected - violates zero-cloud policy)
- Would cost $50/month

**FAISS Implementation**:
```csharp
// Create index
var index = new IndexFlatIP(384); // 384 dimensions, inner product similarity

// Add vectors
index.Add(vectors); // vectors is float[n, 384]

// Search
int k = 5; // top-5 results
var distances = new float[k];
var indices = new long[k];
index.Search(queryVector, k, distances, indices);

// Retrieve documents by indices
var results = documents[indices[0]], documents[indices[1]], ...;
```

**Persistence**:
- FAISS index saved to disk: `C:\P4NTHE0N\rag\faiss.index`
- Reload on startup
- Incremental updates (add new docs without rebuilding)

### Step 4: Retrieval (Finding Relevant Context)

**Query Flow**:
```csharp
// 1. User asks: "What's the threshold for FireKirin Grand jackpot?"
string query = "What's the threshold for FireKirin Grand jackpot?";

// 2. Embed the query
float[] queryEmbedding = await embeddingModel.GenerateEmbeddingAsync(query);

// 3. Search vector database
var searchResults = await vectorStore.SearchAsync(queryEmbedding, topK: 5);

// 4. Retrieved documents:
// - "FireKirin Grand threshold is 1785..." (from G4ME collection)
// - "Threshold configuration guide..." (from docs/)
// - "Recent jackpot at 1785..." (from EV3NT collection)

// 5. Combine into context
string context = string.Join("\n\n", searchResults.Select(r => r.Content));

// 6. Send to LLM with context
string prompt = $"""
Context:
{context}

Question: {query}
Answer based on the context above.
""";

string response = await llmClient.CompleteAsync(prompt);
```

**Hybrid Search** (BM25 + Semantic):
```csharp
// Keyword search (BM25) for exact matches
var keywordResults = bm25Index.Search(query);

// Semantic search (FAISS) for meaning
var semanticResults = faissIndex.Search(queryEmbedding);

// Combine and rerank
var combined = Rerank(keywordResults, semanticResults);
```

### Step 5: Augmentation (Building the Prompt)

**Context Assembly**:
```csharp
public class RAGContextBuilder {
    public string BuildPrompt(string userQuery, List<Document> retrievedDocs) {
        var sb = new StringBuilder();
        
        sb.AppendLine("You are an assistant for P4NTHE0N, a casino automation platform.");
        sb.AppendLine("Use the following retrieved context to answer the question.");
        sb.AppendLine("If the context doesn't contain the answer, say so.");
        sb.AppendLine();
        
        sb.AppendLine("=== RETRIEVED CONTEXT ===");
        foreach (var doc in retrievedDocs) {
            sb.AppendLine($"Source: {doc.Source}");
            sb.AppendLine($"Content: {doc.Content}");
            sb.AppendLine($"Relevance: {doc.Score:F2}");
            sb.AppendLine("---");
        }
        
        sb.AppendLine();
        sb.AppendLine("=== USER QUESTION ===");
        sb.AppendLine(userQuery);
        sb.AppendLine();
        sb.AppendLine("=== YOUR ANSWER ===");
        
        return sb.ToString();
    }
}
```

---

## RAG FOR P4NTHE0N AGENTS

### Agent-Specific Knowledge Bases

Each agent gets its own RAG context:

**H0UND (Signal Generator)**:
- Query: "What's the DPD threshold for OrionStars?"
- Retrieves: CRED3N7IAL collection, G4ME collection, threshold history
- Uses: Real-time signal generation

**H4ND (Automation Executor)**:
- Query: "How do I handle FireKirin login timeout?"
- Retrieves: EV3NT collection (past logins), ERR0R collection (failures), RUL3S/
- Uses: Adaptive automation

**Strategist (Decision Maker)**:
- Query: "What was Oracle's approval for ARCH-003?"
- Retrieves: decisions-server, T4CT1CS/intel/, speech logs
- Uses: Informed decision creation

**WindFixer (Implementation)**:
- Query: "What's the C# coding standard for this project?"
- Retrieves: AGENTS.md, .windsurfrules, C0MMON/ code patterns
- Uses: Code generation alignment

**Oracle (Risk Assessment)**:
- Query: "What are common failure patterns in H4ND?"
- Retrieves: ERR0R collection, EV3NT collection, monitoring logs
- Uses: Risk prediction

**Designer (Architecture)**:
- Query: "How is the CircuitBreaker implemented?"
- Retrieves: C0MMON/Infrastructure/Resilience/, existing implementations
- Uses: Pattern-based design

### RAG-Accessible Workflows

**1. Development Workflow**:
```
Developer asks: "How do I add a new casino platform?"
↓
RAG retrieves:
  - docs/ADDING_PLATFORMS.md
  - Existing platform implementations (FireKirin.cs, OrionStars.cs)
  - Decision records for platform additions
  - Common pitfalls from ERR0R collection
↓
Response: Step-by-step guide with code examples
```

**2. Debugging Workflow**:
```
Developer asks: "Why is H0UND throwing SignalDeduplicationCache errors?"
↓
RAG retrieves:
  - Error logs from ERR0R collection
  - Code context from H0UND/H0UND.cs
  - Related decisions about deduplication
  - Fix history from EV3NT collection
↓
Response: Root cause analysis + suggested fix
```

**3. Decision Workflow**:
```
Strategist asks: "What's our current model selection strategy?"
↓
RAG retrieves:
  - BENCH-002 decision record
  - MODEL_SELECTION_WORKFLOW.md
  - Empirical results from tests/pre-validation/
  - Speech logs about model discussions
↓
Response: Complete strategy with supporting data
```

**4. Onboarding Workflow**:
```
New agent asks: "What's P4NTHE0N's architecture?"
↓
RAG retrieves:
  - docs/PANTHEON.md
  - README.md
  - AGENTS.md
  - Architecture decision records
↓
Response: Comprehensive overview with context
```

---

## IMPLEMENTATION ARCHITECTURE

### Components

```
┌─────────────────────────────────────────────────────────────┐
│                    RAG SERVICE (C#)                         │
├─────────────────────────────────────────────────────────────┤
│  Ingestion Pipeline                                         │
│  ├── FileSystemWatcher (docs/, code changes)               │
│  ├── MongoDB Change Stream (EV3NT, ERR0R, decisions)       │
│  └── Scheduled Reindexing (nightly full rebuild)           │
├─────────────────────────────────────────────────────────────┤
│  Embedding Service                                          │
│  ├── ONNX Runtime (all-MiniLM-L6-v2)                       │
│  ├── Batch Processing (queue-based)                        │
│  └── Caching (Redis/MemoryCache)                           │
├─────────────────────────────────────────────────────────────┤
│  Vector Store                                               │
│  ├── FAISS Index (in-memory + disk persistence)            │
│  ├── Metadata Store (MongoDB - source, type, agent)        │
│  └── Hybrid Search (BM25 + FAISS)                          │
├─────────────────────────────────────────────────────────────┤
│  Query API                                                  │
│  ├── HTTP Endpoint (/api/rag/query)                        │
│  ├── gRPC Service (for internal agents)                    │
│  └── Streaming (Server-Sent Events for real-time)          │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Document   │────▶│   Chunker    │────▶│  Embedder    │
│   Source     │     │   (512 tok)  │     │  (ONNX)      │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                 │
┌──────────────┐     ┌──────────────┐     ┌──────▼───────┐
│    Query     │────▶│   Embedder   │────▶│    FAISS     │
│   (Agent)    │     │   (ONNX)     │     │   Search     │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                 │
┌──────────────┐     ┌──────────────┐     ┌──────▼───────┐
│   Response   │◀────│     LLM      │◀────│   Context    │
│   (Agent)    │     │  (LM Studio) │     │   Builder    │
└──────────────┘     └──────────────┘     └──────────────┘
```

---

## WHAT FILES DO WE FEED RAG?

### Continuous Ingestion (Real-time)

**File System Watchers**:
```csharp
// Watch for changes and auto-ingest
var watcher = new FileSystemWatcher("C:\\P4NTHE0N\\docs");
watcher.Changed += async (s, e) => {
    await ragService.IngestDocumentAsync(e.FullPath);
};
```

**MongoDB Change Streams**:
```csharp
// Watch collections for new documents
var pipeline = new EmptyPipelineDefinition<ChangeStreamDocument<BsonDocument>>()
    .Match(x => x.OperationType == ChangeStreamOperationType.Insert);

var cursor = collection.Watch(pipeline);
foreach (var change in cursor.ToEnumerable()) {
    await ragService.IngestDocumentAsync(change.FullDocument);
}
```

### Batch Ingestion (Nightly)

**Full Reindex**:
```powershell
# Nightly rebuild of entire RAG index
.\scripts\rag\rebuild-index.ps1 -SourceDirs @(
    "C:\P4NTHE0N\docs",
    "C:\P4NTHE0N\C0MMON",
    "C:\P4NTHE0N\H0UND",
    "C:\P4NTHE0N\H4ND",
    "C:\P4NTHE0N\T4CT1CS\speech"
) -MongoCollections @(
    "EV3NT",
    "ERR0R",
    "decisions"
)
```

### Specific File Types

**Documentation**:
- `docs/**/*.md` - Architecture, guides, API docs
- `README.md` - Project overview
- `AGENTS.md` - Agent-specific instructions
- `T4CT1CS/speech/**/*.md` - Decision history, briefings

**Code**:
- `C0MMON/**/*.cs` - Shared library patterns
- `H0UND/**/*.cs` - Signal generation logic
- `H4ND/**/*.cs` - Automation patterns
- `W4TCHD0G/**/*.cs` - Vision processing

**Configuration**:
- `appsettings*.json` - Runtime configuration
- `HunterConfig.json` - Casino platform configs
- `.windsurfrules` - Coding standards

**Data**:
- MongoDB `EV3NT` - Event history
- MongoDB `ERR0R` - Error patterns
- MongoDB `decisions` - Decision records
- MongoDB `G4ME` - Game configurations
- MongoDB `CRED3N7IAL` - Credential patterns

---

## AGENT INTEGRATION

### How Agents Use RAG

**Option 1: Direct API Calls**:
```csharp
// Agent calls RAG service directly
var context = await ragService.QueryAsync(
    query: "What's the threshold for FireKirin?",
    agent: "H0UND",
    topK: 5
);

// Use context in decision making
var signal = await GenerateSignalAsync(context);
```

**Option 2: Automatic Context Injection**:
```csharp
// RAG middleware injects context into all LLM calls
public class RAGMiddleware {
    public async Task<string> CompleteWithRAGAsync(string prompt) {
        // Auto-extract query from prompt
        var query = ExtractQuery(prompt);
        
        // Retrieve context
        var context = await _ragService.QueryAsync(query);
        
        // Augment prompt
        var augmentedPrompt = $"{context}\n\n{prompt}";
        
        // Send to LLM
        return await _llmClient.CompleteAsync(augmentedPrompt);
    }
}
```

**Option 3: Explicit Context in Prompts**:
```csharp
// Agent builds prompt with RAG context explicitly
public class StrategistAgent {
    public async Task<Decision> CreateDecisionAsync(string topic) {
        // Query RAG for related decisions
        var relatedDecisions = await _ragService.QueryAsync(
            $"decisions about {topic}",
            filter: new { Type = "decision" },
            topK: 10
        );
        
        // Build prompt with context
        var prompt = $"""
        Previous related decisions:
        {FormatDecisions(relatedDecisions)}
        
        Create a new decision for: {topic}
        """;
        
        return await _llmClient.CompleteAsync<Decision>(prompt);
    }
}
```

---

## RAG-001 DECISION STRUCTURE

### Decision ID: RAG-001
**Title**: RAG Layer Architecture for P4NTHE0N Agentic Environment

**Status**: Proposed (awaiting WindFixer discovery)

**Dependencies**:
- INFRA-010 (MongoDB RAG Architecture - partial)
- WIND-010 (Context Awareness)
- ARCH-003-PIVOT (Model Testing Platform - reusable components)

**Inputs from WindFixer Discovery**:
1. RAG_INFRASTRUCTURE_AUDIT.md - What's already built
2. FAISS_ANALYSIS.md - Vector DB viability
3. CONTEXT_WINDOW_LIMITS.md - Model constraints
4. EMBEDDING_BENCHMARK.md - Quality metrics
5. RAG_USE_CASES.md - Priority use cases
6. RAG_HARDWARE_ASSESSMENT.md - Resource requirements

**Key Decisions Needed**:
1. **Embedding Model**: all-MiniLM-L6-v2 vs alternatives
2. **Vector Store**: FAISS (confirmed) vs alternatives
3. **Hybrid Search**: BM25 + semantic vs semantic-only
4. **Real-time vs Batch**: File watchers + change streams vs nightly
5. **Agent Integration**: Direct API vs middleware vs explicit

**Implementation Phases**:

**Phase 1: Core Infrastructure** (Days 1-3)
- Embedding service (ONNX Runtime)
- FAISS integration
- Basic ingestion pipeline

**Phase 2: Data Connectors** (Days 4-5)
- File system watcher
- MongoDB change streams
- Chunking strategies

**Phase 3: Query API** (Days 6-7)
- HTTP/gRPC endpoints
- Context assembly
- Agent integration SDK

**Phase 4: Agent Integration** (Days 8-10)
- H0UND integration
- H4ND integration
- Strategist integration
- WindFixer/OpenFixer integration

**Phase 5: Optimization** (Days 11-14)
- Caching layer
- Performance tuning
- Monitoring dashboard

**Success Metrics**:
- Query latency: <100ms (p95)
- Embedding generation: <50ms per chunk
- Index size: <10GB for full P4NTHE0N corpus
- Accuracy: >90% relevant retrieval (top-5)

---

## NEXT STEPS

1. **Wait for WindFixer Discovery** (in progress)
   - 6 discovery documents
   - Will inform all RAG-001 decisions

2. **Consult Designer + Oracle**
   - Architecture approval
   - Risk assessment
   - Implementation guidance

3. **Create Detailed Decision Record**
   - Based on discovery findings
   - Include specific component designs
   - Define agent integration patterns

4. **Implementation**
   - WindFixer executes (P4NTHE0N codebase)
   - 14-day timeline
   - Incremental delivery

---

**RAG transforms P4NTHE0N from a collection of agents into a unified, knowledge-driven organism. Every agent remembers, learns, and builds on collective intelligence.**

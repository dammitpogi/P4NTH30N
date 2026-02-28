# MCP-EXPOSED RAG ARCHITECTURE
## RAG as an MCP Server for P4NTHE0N Agents

**Vision**: Instead of custom SDKs or direct API calls, expose RAG as an **MCP Server** that all agents can access through the standard tool-calling pattern they already use.

---

## WHY MCP?

**Current Agent Pattern**:
```csharp
// Agents already use MCP for:
- decisions-server (getStats, createDecision, etc.)
- MongoDB (find, update, aggregate)
- File tools (read, write, glob)
```

**RAG via MCP**:
```csharp
// Agents call RAG the same way they call everything else
var result = await mcpClient.CallToolAsync("rag-server", "rag_query", new {
    query = "What's the FireKirin threshold?",
    topK = 5,
    filter = new { agent = "H0UND", type = "config" }
});
```

**Benefits**:
1. **Familiar Pattern**: Agents already know how to use MCP tools
2. **No Custom SDK**: No need to learn new APIs or libraries
3. **Automatic Discovery**: MCP tools are self-documenting
4. **Standardized**: Same interface across all agents
5. **Composable**: RAG can call other MCP tools (and vice versa)

---

## MCP SERVER ARCHITECTURE

### RAG MCP Server

```csharp
// src/RAG/McpServer.cs
public class RagMcpServer : IMcpServer {
    private readonly IEmbeddingService _embedder;
    private readonly IVectorStore _vectorStore;
    private readonly IIngestionPipeline _ingestion;
    
    public void RegisterTools(IMcpToolRegistry registry) {
        // Core RAG operations
        registry.RegisterTool("rag_query", QueryTool);
        registry.RegisterTool("rag_ingest", IngestTool);
        registry.RegisterTool("rag_ingest_file", IngestFileTool);
        registry.RegisterTool("rag_status", StatusTool);
        registry.RegisterTool("rag_rebuild_index", RebuildIndexTool);
        registry.RegisterTool("rag_search_similar", SearchSimilarTool);
    }
    
    private async Task<McpToolResult> QueryTool(McpToolParameters parameters) {
        string query = parameters.GetRequired<string>("query");
        int topK = parameters.GetOptional("topK", 5);
        var filter = parameters.GetOptional<Dictionary<string, object>>("filter", null);
        
        var results = await _ragService.QueryAsync(query, topK, filter);
        
        return McpToolResult.Success(new {
            query = query,
            results = results.Select(r => new {
                content = r.Content,
                source = r.Source,
                score = r.Score,
                metadata = r.Metadata
            }),
            totalResults = results.Count,
            latencyMs = results.Sum(r => r.LatencyMs)
        });
    }
    
    private async Task<McpToolResult> IngestTool(McpToolParameters parameters) {
        string content = parameters.GetRequired<string>("content");
        string source = parameters.GetRequired<string>("source");
        var metadata = parameters.GetOptional<Dictionary<string, object>>("metadata", new());
        
        var docId = await _ingestion.IngestAsync(content, source, metadata);
        
        return McpToolResult.Success(new {
            documentId = docId,
            source = source,
            status = "ingested",
            chunks = await _ingestion.GetChunkCountAsync(docId)
        });
    }
    
    private async Task<McpToolResult> IngestFileTool(McpToolParameters parameters) {
        string filePath = parameters.GetRequired<string>("filePath");
        var metadata = parameters.GetOptional<Dictionary<string, object>>("metadata", new());
        
        if (!File.Exists(filePath)) {
            return McpToolResult.Error($"File not found: {filePath}");
        }
        
        string content = await File.ReadAllTextAsync(filePath);
        var docId = await _ingestion.IngestAsync(content, filePath, metadata);
        
        return McpToolResult.Success(new {
            documentId = docId,
            filePath = filePath,
            status = "ingested",
            fileSize = content.Length
        });
    }
    
    private async Task<McpToolResult> StatusTool(McpToolParameters parameters) {
        var status = await _ragService.GetStatusAsync();
        
        return McpToolResult.Success(new {
            vectorStore = new {
                indexType = status.IndexType,
                vectorCount = status.VectorCount,
                dimension = status.Dimension,
                memoryUsage = status.MemoryUsage
            },
            ingestion = new {
                lastIngestion = status.LastIngestion,
                pendingDocuments = status.PendingDocuments,
                totalDocuments = status.TotalDocuments
            },
            performance = new {
                avgQueryLatencyMs = status.AvgQueryLatencyMs,
                avgEmbeddingLatencyMs = status.AvgEmbeddingLatencyMs,
                queriesLastHour = status.QueriesLastHour
            }
        });
    }
    
    private async Task<McpToolResult> RebuildIndexTool(McpToolParameters parameters) {
        bool fullRebuild = parameters.GetOptional("fullRebuild", false);
        var sources = parameters.GetOptional<List<string>>("sources", null);
        
        var jobId = await _ingestion.ScheduleRebuildAsync(fullRebuild, sources);
        
        return McpToolResult.Success(new {
            jobId = jobId,
            status = "scheduled",
            fullRebuild = fullRebuild,
            estimatedTime = fullRebuild ? "30-60 minutes" : "5-10 minutes"
        });
    }
    
    private async Task<McpToolResult> SearchSimilarTool(McpToolParameters parameters) {
        string documentId = parameters.GetRequired<string>("documentId");
        int topK = parameters.GetOptional("topK", 5);
        
        var similar = await _ragService.FindSimilarAsync(documentId, topK);
        
        return McpToolResult.Success(new {
            sourceDocument = documentId,
            similarDocuments = similar.Select(s => new {
                documentId = s.DocumentId,
                source = s.Source,
                similarity = s.Similarity,
                preview = s.Content.Substring(0, 200)
            })
        });
    }
}
```

---

## MCP TOOL SPECIFICATIONS

### Tool: `rag_query`

**Description**: Query the RAG system for relevant context

**Parameters**:
```json
{
  "query": {
    "type": "string",
    "description": "The search query",
    "required": true
  },
  "topK": {
    "type": "integer",
    "description": "Number of results to return (1-20)",
    "default": 5,
    "required": false
  },
  "filter": {
    "type": "object",
    "description": "Metadata filters (agent, type, source, etc.)",
    "required": false
  },
  "includeMetadata": {
    "type": "boolean",
    "description": "Include full metadata in results",
    "default": true,
    "required": false
  }
}
```

**Returns**:
```json
{
  "query": "What's the FireKirin threshold?",
  "results": [
    {
      "content": "FireKirin Grand threshold is 1785...",
      "source": "CRED3N7IAL/firekirin-config",
      "score": 0.94,
      "metadata": {
        "agent": "H0UND",
        "type": "config",
        "platform": "firekirin",
        "timestamp": "2026-02-18T20:00:00Z"
      }
    }
  ],
  "totalResults": 5,
  "latencyMs": 45
}
```

**Example Usage**:
```csharp
// H0UND querying for signal generation
var ragResult = await mcpClient.CallToolAsync("rag-server", "rag_query", new {
    query = "OrionStars recent jackpot patterns",
    topK = 10,
    filter = new { type = "jackpot", platform = "orionstars" }
});

// Use retrieved context
var context = string.Join("\n", ragResult.results.Select(r => r.content));
var signal = await GenerateSignalAsync(query, context);
```

---

### Tool: `rag_ingest`

**Description**: Ingest content directly into RAG

**Parameters**:
```json
{
  "content": {
    "type": "string",
    "description": "Content to ingest",
    "required": true
  },
  "source": {
    "type": "string",
    "description": "Source identifier (e.g., 'decision:RAG-001')",
    "required": true
  },
  "metadata": {
    "type": "object",
    "description": "Optional metadata (agent, type, tags)",
    "required": false
  }
}
```

**Returns**:
```json
{
  "documentId": "doc_abc123",
  "source": "decision:RAG-001",
  "status": "ingested",
  "chunks": 3,
  "embeddingTimeMs": 125
}
```

**Example Usage**:
```csharp
// Strategist ingesting a new decision
await mcpClient.CallToolAsync("rag-server", "rag_ingest", new {
    content = decisionText,
    source = $"decision:{decisionId}",
    metadata = new {
        agent = "Strategist",
        type = "decision",
        category = "Architecture",
        status = "Proposed"
    }
});
```

---

### Tool: `rag_ingest_file`

**Description**: Ingest a file into RAG

**Parameters**:
```json
{
  "filePath": {
    "type": "string",
    "description": "Absolute path to file",
    "required": true
  },
  "metadata": {
    "type": "object",
    "description": "Optional metadata overrides",
    "required": false
  }
}
```

**Returns**:
```json
{
  "documentId": "doc_def456",
  "filePath": "C:\\P4NTHE0N\\docs\\architecture.md",
  "status": "ingested",
  "fileSize": 15234,
  "chunks": 12
}
```

**Example Usage**:
```csharp
// WindFixer ingesting documentation
await mcpClient.CallToolAsync("rag-server", "rag_ingest_file", new {
    filePath = "C:\\P4NTHE0N\\docs\\NEW_FEATURE.md",
    metadata = new { agent = "WindFixer", type = "documentation" }
});
```

---

### Tool: `rag_status`

**Description**: Get RAG system status and metrics

**Parameters**: None

**Returns**:
```json
{
  "vectorStore": {
    "indexType": "IndexFlatL2",
    "vectorCount": 15420,
    "dimension": 384,
    "memoryUsage": "45MB"
  },
  "ingestion": {
    "lastIngestion": "2026-02-18T19:45:00Z",
    "pendingDocuments": 0,
    "totalDocuments": 342
  },
  "performance": {
    "avgQueryLatencyMs": 42,
    "avgEmbeddingLatencyMs": 38,
    "queriesLastHour": 156
  }
}
```

---

### Tool: `rag_rebuild_index`

**Description**: Schedule a full or partial index rebuild

**Parameters**:
```json
{
  "fullRebuild": {
    "type": "boolean",
    "description": "Rebuild entire index from scratch",
    "default": false,
    "required": false
  },
  "sources": {
    "type": "array",
    "description": "Specific sources to rebuild (null = all)",
    "required": false
  }
}
```

**Returns**:
```json
{
  "jobId": "rebuild_20260218_001",
  "status": "scheduled",
  "fullRebuild": true,
  "estimatedTime": "30-60 minutes"
}
```

---

### Tool: `rag_search_similar`

**Description**: Find documents similar to a given document

**Parameters**:
```json
{
  "documentId": {
    "type": "string",
    "description": "Document ID to find similar to",
    "required": true
  },
  "topK": {
    "type": "integer",
    "description": "Number of similar documents",
    "default": 5,
    "required": false
  }
}
```

**Returns**:
```json
{
  "sourceDocument": "doc_abc123",
  "similarDocuments": [
    {
      "documentId": "doc_xyz789",
      "source": "decision:ARCH-003",
      "similarity": 0.87,
      "preview": "Architecture decision for validation pipeline..."
    }
  ]
}
```

---

## AGENT INTEGRATION PATTERNS

### Pattern 1: Direct MCP Tool Call

```csharp
// Any agent calls RAG like any other MCP tool
public class H0UNDAgent {
    private readonly IMcpClient _mcp;
    
    public async Task<Signal> GenerateSignalAsync(string platform) {
        // Query RAG via MCP
        var ragResult = await _mcp.CallToolAsync(
            "rag-server",
            "rag_query",
            new {
                query = $"{platform} recent jackpot patterns and thresholds",
                topK = 10,
                filter = new { type = "jackpot", platform }
            }
        );
        
        // Build context from results
        var context = FormatRagResults(ragResult);
        
        // Generate signal with context
        return await _llm.CompleteAsync<Signal>($"""
            Context from knowledge base:
            {context}
            
            Generate signal for {platform}:
            """);
    }
}
```

### Pattern 2: RAG Middleware (Automatic Context)

```csharp
// Automatic RAG context injection for all LLM calls
public class RAGMiddleware {
    private readonly IMcpClient _mcp;
    private readonly ILogger _logger;
    
    public async Task<string> CompleteWithRagAsync(
        string agentId,
        string prompt,
        int contextSize = 3) {
        
        // Extract implicit query from prompt
        var query = ExtractQuery(prompt);
        
        // Query RAG with agent-specific filter
        var ragResult = await _mcp.CallToolAsync(
            "rag-server",
            "rag_query",
            new {
                query = query,
                topK = contextSize,
                filter = new { agent = agentId }
            }
        );
        
        // Build augmented prompt
        var context = FormatRagResults(ragResult);
        var augmentedPrompt = $"""
            Retrieved context from P4NTHE0N knowledge base:
            {context}
            
            Original request:
            {prompt}
            """;
        
        _logger.LogInformation("RAG augmented prompt with {Count} context items", 
            ragResult.GetProperty("results").GetArrayLength());
        
        return await _llm.CompleteAsync(augmentedPrompt);
    }
    
    private string ExtractQuery(string prompt) {
        // Simple extraction - first sentence or first 100 chars
        var firstSentence = prompt.Split('.')[0];
        return firstSentence.Length > 100 
            ? firstSentence.Substring(0, 100) 
            : firstSentence;
    }
}
```

### Pattern 3: Explicit Context Builder

```csharp
// Strategist building decision context explicitly
public class StrategistAgent {
    private readonly IMcpClient _mcp;
    
    public async Task<Decision> CreateDecisionAsync(string topic) {
        // Query for related decisions
        var relatedDecisions = await _mcp.CallToolAsync(
            "rag-server",
            "rag_query",
            new {
                query = $"decisions about {topic}",
                topK = 10,
                filter = new { type = "decision" }
            }
        );
        
        // Query for technical context
        var technicalContext = await _mcp.CallToolAsync(
            "rag-server",
            "rag_query",
            new {
                query = topic,
                topK = 5,
                filter = new { type = "documentation" }
            }
        );
        
        // Query for recent errors
        var errorContext = await _mcp.CallToolAsync(
            "rag-server",
            "rag_query",
            new {
                query = $"{topic} errors failures",
                topK = 5,
                filter = new { type = "error" }
            }
        );
        
        // Build comprehensive prompt
        var prompt = $"""
            Related previous decisions:
            {FormatResults(relatedDecisions)}
            
            Technical documentation:
            {FormatResults(technicalContext)}
            
            Recent error patterns:
            {FormatResults(errorContext)}
            
            Create a new decision for: {topic}
            """;
        
        return await _llm.CompleteAsync<Decision>(prompt);
    }
}
```

---

## DEPLOYMENT ARCHITECTURE

### MCP Server Registration

```json
// ~/.config/opencode/mcp.json
{
  "mcpServers": {
    "decisions-server": {
      "command": "node",
      "args": ["C:/P4NTHE0N/mcp/decisions-server/dist/index.js"]
    },
    "mongodb": {
      "command": "node", 
      "args": ["C:/P4NTHE0N/mcp/mongodb-mcp/dist/index.js"]
    },
    "rag-server": {
      "command": "dotnet",
      "args": ["run", "--project", "C:/P4NTHE0N/src/RAG/McpServer.csproj"],
      "env": {
        "RAG_FAISS_INDEX": "C:/P4NTHE0N/rag/faiss.index",
        "RAG_MONGODB_URI": "mongodb://localhost:27017/P4NTHE0N"
      }
    }
  }
}
```

### Server Lifecycle

```csharp
// RAG MCP Server runs as standalone process
// - Loads FAISS index into memory on startup
// - Connects to MongoDB for metadata
// - Handles MCP protocol over stdio
// - Auto-reloads index when updated

public class Program {
    public static async Task Main(string[] args) {
        var builder = WebApplication.CreateBuilder(args);
        
        // Services
        builder.Services.AddSingleton<IEmbeddingService>(
            _ => new OnnxEmbeddingService("all-MiniLM-L6-v2.onnx"));
        builder.Services.AddSingleton<IVectorStore>(
            _ => FaissVectorStore.Load("rag/faiss.index"));
        builder.Services.AddSingleton<IIngestionPipeline>, IngestionPipeline>();
        builder.Services.AddSingleton<RagService>();
        
        // MCP Server
        builder.Services.AddMcpServer()
            .WithStdioTransport()
            .WithTools<RagMcpServer>();
        
        var app = builder.Build();
        await app.RunAsync();
    }
}
```

---

## ADVANTAGES OF MCP EXPOSURE

### For Agent Developers

1. **No Learning Curve**: Use the same `CallToolAsync` pattern as everything else
2. **Self-Documenting**: MCP tools expose their schemas automatically
3. **Composability**: RAG can call other tools, other tools can call RAG
4. **Debugging**: Standard MCP logging and tracing

### For System Architects

1. **Decoupling**: RAG is just another service, not a core dependency
2. **Scalability**: Can run RAG server on different machine if needed
3. **Monitoring**: Standard MCP metrics and health checks
4. **Versioning**: MCP protocol handles versioning

### For Operations

1. **Configuration**: Single MCP config file for all tools
2. **Lifecycle**: Standard process management (start/stop/restart)
3. **Security**: MCP handles authentication/authorization
4. **Updates**: Deploy new RAG version without changing agents

---

## IMPLEMENTATION CHECKLIST

### Phase 1: MCP Server Scaffold (Day 1)
- [ ] Create `src/RAG/McpServer.csproj`
- [ ] Implement `RagMcpServer` class
- [ ] Register 6 MCP tools
- [ ] Add stdio transport
- [ ] Test with MCP inspector

### Phase 2: Tool Implementation (Day 2)
- [ ] `rag_query` with filtering
- [ ] `rag_ingest` for direct content
- [ ] `rag_ingest_file` for files
- [ ] `rag_status` for metrics
- [ ] `rag_rebuild_index` for maintenance
- [ ] `rag_search_similar` for discovery

### Phase 3: Integration Testing (Day 3)
- [ ] Test with decisions-server
- [ ] Test with MongoDB MCP
- [ ] Verify agent can call RAG
- [ ] Performance benchmarks

---

**MCP makes RAG just another tool in the agent's toolbox—familiar, composable, and powerful.**

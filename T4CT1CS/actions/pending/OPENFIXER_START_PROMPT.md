# OpenFixer Start Prompt
## Execute RAG-001 Deployment & Integration

**Brief**: T4CT1CS/handoffs/pending/OPENFIXER-BRIEF-20260219-001.md  
**WindFixer Report**: T4CT1CS/handoffs/windfixer/SESSION-COMPREHENSIVE-20260219.md  
**Priority**: Critical | **ETA**: Same day

---

## YOUR MISSION

Complete RAG-001 Oracle condition #3 (Python bridge) and deploy to OpenCode environment. WindFixer has delivered production-ready Phase 1. You own the OpenCode deployment layer.

---

## START HERE - Step-by-Step Execution

### Phase 1: Environment Setup (15 min)

1. **Verify Python availability**:
   ```powershell
   python --version  # Requires 3.10+
   pip --version
   ```

2. **Create model directory**:
   ```powershell
   New-Item -ItemType Directory -Force -Path "C:\ProgramData\P4NTH30N\models"
   ```

### Phase 2: Download ONNX Model (10 min)

**Download sentence-transformers/all-MiniLM-L6-v2**:

```powershell
# Option 1: Using huggingface-cli (if available)
huggingface-cli download sentence-transformers/all-MiniLM-L6-v2 --local-dir "C:\ProgramData\P4NTH30N\models\all-MiniLM-L6-v2"

# Option 2: Direct download (manual)
# Download from: https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2/tree/main/onnx
# Files needed:
# - model.onnx → C:\ProgramData\P4NTH30N\models\all-MiniLM-L6-v2.onnx
# - config.json → C:\ProgramData\P4NTH30N\models\config.json
# - tokenizer.json → C:\ProgramData\P4NTH30N\models\tokenizer.json

# Verify download:
Test-Path "C:\ProgramData\P4NTH30N\models\all-MiniLM-L6-v2.onnx"
```

### Phase 3: Python Bridge Service (30 min)

**Create directory structure**:
```powershell
New-Item -ItemType Directory -Force -Path "C:\P4NTH30N\src\RAG\PythonBridge"
```

**Create embedding_bridge.py**:
```python
# C:\P4NTH30N\src\RAG\PythonBridge\embedding_bridge.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import onnxruntime as ort
import numpy as np
import tokenizers
from pathlib import Path
import logging
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="P4NTH30N RAG Embedding Bridge")

# Configuration
MODEL_PATH = Path("C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx")
TOKENIZER_PATH = Path("C:/ProgramData/P4NTH30N/models/tokenizer.json")
PORT = 5000

# Global model session
session = None
tokenizer = None

class EmbedRequest(BaseModel):
    texts: list[str]
    batch_size: int = 32

class EmbedResponse(BaseModel):
    embeddings: list[list[float]]
    dimensions: int
    model_name: str
    processing_time_ms: float

@app.on_event("startup")
async def load_model():
    global session, tokenizer
    logger.info(f"Loading ONNX model from {MODEL_PATH}")
    
    if not MODEL_PATH.exists():
        raise RuntimeError(f"Model not found: {MODEL_PATH}")
    
    # Initialize ONNX Runtime
    sess_options = ort.SessionOptions()
    sess_options.graph_optimization_level = ort.GraphOptimizationLevel.ORT_ENABLE_ALL
    session = ort.InferenceSession(str(MODEL_PATH), sess_options)
    
    # Load tokenizer
    if TOKENIZER_PATH.exists():
        tokenizer = tokenizers.Tokenizer.from_file(str(TOKENIZER_PATH))
    else:
        # Fallback to default tokenizer
        from transformers import AutoTokenizer
        tokenizer = AutoTokenizer.from_pretrained("sentence-transformers/all-MiniLM-L6-v2")
    
    logger.info("Model loaded successfully")

@app.get("/health")
async def health():
    if session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    return {
        "status": "healthy",
        "model_loaded": session is not None,
        "model_path": str(MODEL_PATH),
        "port": PORT
    }

@app.get("/model-info")
async def model_info():
    if session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    inputs = session.get_inputs()
    outputs = session.get_outputs()
    
    return {
        "model_name": "sentence-transformers/all-MiniLM-L6-v2",
        "onnx_version": ort.__version__,
        "input_shape": [i.shape for i in inputs],
        "output_shape": [o.shape for o in outputs],
        "providers": session.get_providers()
    }

@app.post("/embed", response_model=EmbedResponse)
async def embed(request: EmbedRequest):
    if session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    start_time = time.time()
    
    try:
        embeddings = []
        
        for i in range(0, len(request.texts), request.batch_size):
            batch = request.texts[i:i + request.batch_size]
            
            # Tokenize
            if hasattr(tokenizer, 'encode_batch'):
                # Using tokenizers library
                encoded = tokenizer.encode_batch(batch)
                input_ids = np.array([e.ids for e in encoded], dtype=np.int64)
                attention_mask = np.array([e.attention_mask for e in encoded], dtype=np.int64)
            else:
                # Using transformers tokenizer
                encoded = tokenizer(batch, padding=True, truncation=True, return_tensors="np", max_length=512)
                input_ids = encoded["input_ids"]
                attention_mask = encoded["attention_mask"]
            
            # Run inference
            outputs = session.run(None, {
                "input_ids": input_ids,
                "attention_mask": attention_mask
            })
            
            # Get sentence embeddings (mean pooling)
            token_embeddings = outputs[0]
            input_mask_expanded = np.expand_dims(attention_mask, -1).astype(float)
            sum_embeddings = np.sum(token_embeddings * input_mask_expanded, 1)
            sentence_embeddings = sum_embeddings / np.clip(input_mask_expanded.sum(1), a_min=1e-9, a_max=None)
            
            # Normalize
            sentence_embeddings = sentence_embeddings / np.linalg.norm(sentence_embeddings, axis=1, keepdims=True)
            
            embeddings.extend(sentence_embeddings.tolist())
        
        processing_time = (time.time() - start_time) * 1000
        
        return EmbedResponse(
            embeddings=embeddings,
            dimensions=len(embeddings[0]) if embeddings else 384,
            model_name="sentence-transformers/all-MiniLM-L6-v2",
            processing_time_ms=processing_time
        )
    
    except Exception as e:
        logger.error(f"Embedding failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=PORT)
```

**Create requirements.txt**:
```
fastapi==0.109.0
uvicorn==0.27.0
onnxruntime==1.17.0
tokenizers==0.15.0
numpy==1.26.0
pydantic==2.6.0
```

**Install dependencies**:
```powershell
cd C:\P4NTH30N\src\RAG\PythonBridge
pip install -r requirements.txt
```

**Test Python bridge**:
```powershell
# Start service
python C:\P4NTH30N\src\RAG\PythonBridge\embedding_bridge.py

# In another terminal, test:
Invoke-RestMethod -Uri "http://localhost:5000/health" -Method GET
# Expected: { "status": "healthy", "model_loaded": true, ... }
```

### Phase 4: C# Python Client (30 min)

**Create PythonEmbeddingClient.cs**:
```csharp
// C:\P4NTH30N\src\RAG\PythonEmbeddingClient.cs
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTH30N.RAG
{
    public class PythonEmbeddingClient : IDisposable
    {
        private readonly HttpClient _httpClient;
        private readonly string _baseUrl;
        private readonly int _maxRetries;
        private readonly TimeSpan _retryDelay;

        public PythonEmbeddingClient(
            string baseUrl = "http://127.0.0.1:5000",
            int maxRetries = 3,
            int timeoutSeconds = 30)
        {
            _baseUrl = baseUrl;
            _maxRetries = maxRetries;
            _retryDelay = TimeSpan.FromSeconds(2);
            
            _httpClient = new HttpClient
            {
                Timeout = TimeSpan.FromSeconds(timeoutSeconds)
            };
        }

        public async Task<bool> IsHealthyAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var response = await _httpClient.GetAsync(
                    $"{_baseUrl}/health", 
                    cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch
            {
                return false;
            }
        }

        public async Task<EmbeddingResult> GenerateEmbeddingsAsync(
            List<string> texts,
            int batchSize = 32,
            CancellationToken cancellationToken = default)
        {
            var request = new
            {
                texts = texts,
                batch_size = batchSize
            };

            var content = new StringContent(
                JsonSerializer.Serialize(request),
                System.Text.Encoding.UTF8,
                "application/json");

            for (int attempt = 0; attempt < _maxRetries; attempt++)
            {
                try
                {
                    var response = await _httpClient.PostAsync(
                        $"{_baseUrl}/embed",
                        content,
                        cancellationToken);

                    response.EnsureSuccessStatusCode();

                    var json = await response.Content.ReadAsStringAsync();
                    var result = JsonSerializer.Deserialize<EmbeddingResult>(json);
                    
                    if (result != null)
                    {
                        return result;
                    }
                }
                catch (Exception ex) when (attempt < _maxRetries - 1)
                {
                    await Task.Delay(_retryDelay, cancellationToken);
                }
            }

            throw new InvalidOperationException("Failed to generate embeddings after all retries");
        }

        public async Task<ModelInfo> GetModelInfoAsync(CancellationToken cancellationToken = default)
        {
            var response = await _httpClient.GetAsync(
                $"{_baseUrl}/model-info",
                cancellationToken);
            
            response.EnsureSuccessStatusCode();
            
            var json = await response.Content.ReadAsStringAsync();
            return JsonSerializer.Deserialize<ModelInfo>(json) 
                ?? throw new InvalidOperationException("Failed to deserialize model info");
        }

        public void Dispose()
        {
            _httpClient?.Dispose();
        }
    }

    public class EmbeddingResult
    {
        public List<List<float>> embeddings { get; set; } = new();
        public int dimensions { get; set; }
        public string model_name { get; set; } = string.Empty;
        public float processing_time_ms { get; set; }
    }

    public class ModelInfo
    {
        public string model_name { get; set; } = string.Empty;
        public string onnx_version { get; set; } = string.Empty;
        public List<List<int?>> input_shape { get; set; } = new();
        public List<List<int?>> output_shape { get; set; } = new();
        public List<string> providers { get; set; } = new();
    }
}
```

**Update EmbeddingService.cs** (add Python bridge integration):
```csharp
// Add to existing EmbeddingService.cs in C:\P4NTH30N\src\RAG\

public class EmbeddingService
{
    private readonly PythonEmbeddingClient? _pythonClient;
    private readonly bool _usePythonBridge;
    
    public EmbeddingService(string? pythonBridgeUrl = null)
    {
        _usePythonBridge = !string.IsNullOrEmpty(pythonBridgeUrl);
        
        if (_usePythonBridge)
        {
            _pythonClient = new PythonEmbeddingClient(pythonBridgeUrl!);
        }
        // ... existing ONNX direct initialization
    }

    public async Task<List<float[]>> GenerateEmbeddingsAsync(
        List<string> texts, 
        CancellationToken cancellationToken = default)
    {
        // Try Python bridge first (faster, batched)
        if (_usePythonBridge && _pythonClient != null)
        {
            try
            {
                if (await _pythonClient.IsHealthyAsync(cancellationToken))
                {
                    var result = await _pythonClient.GenerateEmbeddingsAsync(
                        texts, 
                        cancellationToken: cancellationToken);
                    
                    return result.embeddings
                        .Select(e => e.ToArray())
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                // Log warning, fall back to direct ONNX
                Console.WriteLine($"Python bridge failed: {ex.Message}. Falling back to direct ONNX.");
            }
        }

        // Fallback to direct ONNX (slower but reliable)
        return await GenerateEmbeddingsDirectAsync(texts, cancellationToken);
    }
    
    // ... existing GenerateEmbeddingsDirectAsync method
}
```

### Phase 5: MCP Server Registration (15 min)

**Edit MCP configuration**:
```powershell
# Open or create mcp.json
notepad C:\Users\paulc\.config\opencode\mcp.json
```

**Add RAG server entry**:
```json
{
  "mcpServers": {
    "rag-server": {
      "command": "dotnet",
      "args": [
        "run",
        "--project",
        "C:/P4NTH30N/src/RAG/RAG.csproj"
      ],
      "env": {
        "RAG_MODEL_PATH": "C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx",
        "RAG_INDEX_PATH": "C:/ProgramData/P4NTH30N/rag-index",
        "PYTHON_BRIDGE_URL": "http://127.0.0.1:5000",
        "DOTNET_ENVIRONMENT": "Development"
      }
    }
  }
}
```

**Verify registration**:
```powershell
# List tools
toolhive list-tools | findstr rag_

# Expected output:
# - rag_query
# - rag_ingest
# - rag_ingest_file
# - rag_status
# - rag_rebuild_index
# - rag_search_similar
```

### Phase 6: Agent Config Deployment (15 min)

**Execute deployment**:
```powershell
cd C:\P4NTH30N

# Preview first
.\scripts\deploy-agents.ps1 -WhatIf

# Execute
.\scripts\deploy-agents.ps1 -Force

# Expected output:
# === Agent Deployment Report ===
# Deployed: rag-mcp-server.md
# Deployed: strategist.md
```

### Phase 7: AGENTS.md Updates (20 min)

**Update C:\Users\paulc\.config\opencode\agents\strategist.md**:
Add section:
```markdown
## RAG MCP Tools

The following tools are available for knowledge retrieval:

- `rag_query(query, topK, filter)` - Search RAG for relevant context
  - Example: `rag_query(query="What is the deployment process?", topK=5)`
  
- `rag_ingest(content, source, metadata)` - Ingest content into RAG
  - Example: `rag_ingest(content="New procedure...", source="docs/procedure.md")`

- `rag_status()` - Check RAG system health
  - Returns: vector count, index status, last update
```

**Update C:\Users\paulc\.config\opencode\AGENTS.md**:
Add delegation patterns from `docs/parallel-delegation-guide.md`

### Phase 8: Integration Test (10 min)

**Test from Strategist agent**:
```csharp
// This should work from any agent context
var status = await mcpClient.CallToolAsync(
    "rag-server",
    "rag_status",
    new { }
);

// Expected: { healthy: true, vectorCount: 0, status: "ready" }
```

**Verify end-to-end**:
```powershell
# 1. Test Python bridge
Invoke-RestMethod -Uri "http://localhost:5000/health"

# 2. Test MCP via toolhive
toolhive call-tool rag-server rag_status

# 3. Test embedding generation
$body = @{ texts = @("Hello world", "Test document") } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:5000/embed" -Method POST -Body $body -ContentType "application/json"
```

---

## ACCEPTANCE CRITERIA

Check these before reporting completion:

- [ ] Python bridge responds to health checks
- [ ] ONNX model downloaded and accessible
- [ ] `toolhive list-tools | findstr rag_` shows 6 tools
- [ ] Agent configs deployed (strategist.md, rag-mcp-server.md)
- [ ] AGENTS.md updated with RAG tool examples
- [ ] Embedding generation via bridge < 100ms per doc
- [ ] Fallback to direct ONNX works if bridge fails
- [ ] No orphaned Python processes

---

## REPORT COMPLETION

Create file: `T4CT1CS/handoffs/completed/OPENFIXER-RAG001-20260219.md`

Include:
1. Deployment confirmation
2. MCP registration verification (copy toolhive output)
3. Integration test results
4. Any issues encountered
5. WindFixer readiness for Phase 2-3

Update decisions-server: Mark Oracle condition #3 as complete.

---

## TROUBLESHOOTING

**Python bridge won't start**:
- Check port 5000 not in use: `Get-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess`
- Verify model files exist: `Test-Path "C:\ProgramData\P4NTH30N\models\all-MiniLM-L6-v2.onnx"`
- Check Python packages installed: `pip list | findstr onnx`

**MCP tools not appearing**:
- Verify mcp.json syntax is valid JSON
- Check dotnet run works manually: `dotnet run --project C:/P4NTH30N/src/RAG/RAG.csproj`
- Restart ToolHive if needed

**Embedding generation slow**:
- Verify Python bridge is being used (check logs)
- Check CPU usage during inference
- Verify ONNX Runtime is using correct execution provider

---

**Begin execution now. Report progress every 30 minutes to Strategist.**

# Implementation Ready: Fixer Brief

**Date**: 2026-02-18  
**Status**: Decisions ready for implementation  
**Target**: Fixer agent  

---

## System Hardware (Verified)

```
CPU:  AMD Ryzen 9 3900X (12 cores / 24 threads, 3.8 GHz base)
RAM:  128 GB DDR4-3200 (4 x 32 GB)
GPU:  NVIDIA GeForce GT 710 (2 GB VRAM, Kepler architecture)
OS:   Windows 10 Enterprise
```

**Critical Finding**: GT 710 GPU incompatible with LM Studio CUDA requirements (Kepler too old).  
**Configuration**: CPU-only mode for all LLM inference.

---

## Ready for Implementation (4 Decisions, 21 Tasks)

### Priority 1: INFRA-009 - In-House Secrets Management
**Status**: Proposed → Ready for InProgress  
**Purpose**: Zero-cost credential encryption with local master key

**Implementation Specs**:
```csharp
// C0MMON/Security/EncryptionService.cs
public class EncryptionService
{
    // USE AesGcm (NOT Aes.Create) for proper GCM
    // PBKDF2: 600,000 iterations (OWASP 2025)
    // Key: 256-bit from local file
    // Algorithm: AES-256-GCM with 128-bit auth tag
}

// C0MMON/Security/KeyManagement.cs
public class KeyManagement
{
    // Master key path: C:\ProgramData\P4NTHE0N\master.key
    // Permissions: 600 (Administrators only)
    // Format: 32 bytes random (RNGCryptoServiceProvider)
}
```

**Tasks** (6 total):
1. ✅ Implement EncryptionService with AesGcm
2. ✅ Implement KeyManagement with secure file storage
3. ⏳ Create credential migration script (encrypt existing)
4. ⏳ Document key rotation procedures
5. ⏳ Integration tests for encryption/decryption
6. ⏳ FIX: Use AesGcm class (not Aes.Create), increase PBKDF2 to 600k iterations

---

### Priority 2: INFRA-010 - MongoDB RAG Architecture
**Status**: Proposed → Ready for InProgress  
**Purpose**: Vector search for LLM context retrieval

**Implementation Specs**:
```python
# scripts/rag/faiss-bridge.py
# FAISS IVF index for 10k+ vectors
# Dimension: 384 (all-MiniLM-L6-v2)
# Quantizer: IndexFlatIP
# Index: IndexIVFFlat(quantizer, 384, 100)
```

```csharp
// C0MMON/RAG/VectorStore.cs
// Python.NET or HTTP bridge to FAISS
// Methods: Add(), Search(), Save(), Load()

// C0MMON/RAG/EmbeddingService.cs
// ONNX Runtime for local inference
// Model: all-MiniLM-L6-v2 (80MB)
// Input: string → Output: float[384]
```

**Tasks** (4 total):
1. ✅ Download all-MiniLM-L6-v2 ONNX model (~80MB)
2. ✅ Create FAISS Python bridge for C# integration
3. ⏳ Implement EmbeddingService with ONNX Runtime
4. ⏳ Add hybrid search (BM25 + FAISS semantic)

---

### Priority 3: FEAT-001 - LM Studio Local LLM
**Status**: Proposed → Ready for InProgress  
**Purpose**: Local LLM inference for RAG context assembly

**Implementation Specs**:
```
LM Studio Configuration:
- Mode: CPU-only (GPU offload = 0 layers)
- Port: 1234 (OpenAI-compatible API)
- Threads: 12-16 (leave 8-12 for system)
- Context: 4096 tokens
- Model: Pleias-RAG-1B-GGUF (1.2B params, RAG-optimized)

Alternative Models (if Pleias unavailable):
- TinyLlama-1.1B (general purpose)
- Qwen2.5-0.5B (ultra-fast)
- SmolLM2-1.7B (slightly larger)

Expected Performance:
- Pleias-RAG-1B: 20-40 tokens/sec on Ryzen 9 3900X
- Acceptable for real-time jackpot predictions
```

```csharp
// C0MMON/LLM/LmStudioClient.cs
// Use standard OpenAI SDK
// Base URL: http://localhost:1234/v1
// API Key: lm-studio (any string works)
// Temperature: 0.3 (deterministic)
// Streaming: enabled for responsive UI
```

```csharp
// C0MMON/RAG/ContextAssembler.cs
// 1. Retrieve top-K vectors from FAISS
// 2. Format prompt with jackpot patterns
// 3. Handle token limits (4K context)
// 4. Call LmStudioClient
// 5. Parse structured JSON response
```

```csharp
// C0MMON/LLM/PromptTemplates.cs
// System: "You are a casino automation expert..."
// User template with context injection
// Output format: { prediction, confidence, reasoning }
```

**Tasks** (7 total):
1. ✅ Document hardware specs (Ryzen 9 3900X, 128GB, GT 710)
2. ⏳ Install LM Studio, download Pleias-RAG-1B-GGUF
3. ⏳ Configure CPU-only mode, API server on port 1234
4. ⏳ Create LmStudioClient with OpenAI SDK
5. ⏳ Create PromptTemplates for jackpot analysis
6. ⏳ Create ContextAssembler with FAISS integration
7. ⏳ Document LM Studio CPU-only configuration

---

### Priority 4: TECH-002 - Hardware Assessment
**Status**: Proposed → Ready for InProgress  
**Purpose**: Document hardware constraints for LLM deployment

**Implementation Specs**:
```markdown
# docs/llm/HARDWARE_ASSESSMENT.md
System: AMD Ryzen 9 3900X (12C/24T, 3.8GHz)
RAM: 128GB DDR4-3200
GPU: NVIDIA GT 710 (2GB VRAM, Kepler)

GPU Status: INCOMPATIBLE with LM Studio CUDA
Reason: Kepler architecture (2014), no modern CUDA support
Solution: CPU-only mode

CPU-Only Performance:
- Pleias-RAG-1B: 20-40 tok/sec ✓ RECOMMENDED
- TinyLlama-1.1B: 25-50 tok/sec ✓ ALTERNATIVE
- Qwen2.5-0.5B: 50-100 tok/sec ✓ ULTRA-FAST
- Mistral 7B: 2-5 tok/sec ✗ TOO SLOW

LM Studio Settings:
- GPU offload: 0 layers
- Threads: 12-16
- Context: 4096
- Batch: 512
```

**Tasks** (1 total):
1. ⏳ Document hardware constraints and LM Studio configuration

---

## Implementation Sequence

### Phase 1: Foundation (Week 1)
```
INFRA-009 → INFRA-010 → TECH-002
(Secrets)    (RAG)      (Hardware)
   ↓            ↓            ↓
Encryption   FAISS      Documentation
```

### Phase 2: LLM Integration (Week 1-2)
```
FEAT-001
(LM Studio)
   ↓
Setup → Client → Prompts → ContextAssembly
```

### Phase 3: Integration (Week 2)
```
INFRA-010 + FEAT-001
(RAG)        (LLM)
   ↓            ↓
End-to-end RAG pipeline testing
```

---

## Dependencies

| Decision | Depends On | Blocked By |
|----------|-----------|------------|
| INFRA-009 | None | Ready ✓ |
| INFRA-010 | None | Ready ✓ |
| FEAT-001 | INFRA-010 (for context) | Ready ✓ |
| TECH-002 | None | Ready ✓ |

All decisions can start immediately. No blocking dependencies.

---

## Key Technical Details

### Encryption (INFRA-009)
```csharp
// Algorithm: AES-256-GCM (via AesGcm class)
// Key derivation: PBKDF2, 600,000 iterations, SHA-256
// Master key: 32 bytes, stored in C:\ProgramData\P4NTHE0N\master.key
// File permissions: Administrators only
// Nonce: 96-bit random per encryption
// Tag: 128-bit authentication
```

### RAG (INFRA-010)
```python
# FAISS Index: IVF with 100 centroids
# Dimension: 384 (all-MiniLM-L6-v2 embeddings)
# Distance: Inner product (cosine similarity)
# Storage: Local binary file (faiss_index.bin)
# Backup: Include in daily backup routine
```

### LLM (FEAT-001)
```
# LM Studio: CPU-only, 12-16 threads
# Model: Pleias-RAG-1B-GGUF from Hugging Face
# Format: GGUF Q4_K_M quantization
# Size: ~700MB
# Speed: 20-40 tokens/sec
# Context: 4096 tokens
```

---

## Testing Checklist

- [ ] EncryptionService: Encrypt/decrypt roundtrip
- [ ] KeyManagement: Generate, load, rotate master key
- [ ] FAISS: Add vectors, search, save/load index
- [ ] EmbeddingService: Generate embeddings from text
- [ ] LM Studio: Start server, load model, API responds
- [ ] LmStudioClient: Chat completion with streaming
- [ ] ContextAssembler: End-to-end RAG query
- [ ] Integration: Full pipeline (signal → embedding → FAISS → LLM → prediction)

---

## Acceptance Criteria

**INFRA-009**:
- Credentials encrypted with AES-256-GCM
- Master key stored securely with proper permissions
- Encryption/decrypt roundtrip < 10ms per credential

**INFRA-010**:
- FAISS index created and searchable
- Embeddings generated locally via ONNX
- Hybrid search (semantic + keyword) functional

**FEAT-001**:
- LM Studio running locally on port 1234
- LmStudioClient communicating via OpenAI-compatible API
- Context assembly producing predictions < 5 seconds

**TECH-002**:
- Hardware assessment documented
- LM Studio configured for CPU-only mode
- Performance benchmarks recorded

---

**Fixer Start Command**:  
Begin with INFRA-009 (EncryptionService), then INFRA-010 (FAISS setup), then FEAT-001 (LM Studio integration). All specs detailed in decision records.

# Hardware Assessment: CPU-Only LLM Configuration (TECH-002)

## System Specifications

| Component | Specification |
|-----------|--------------|
| **CPU** | AMD Ryzen 9 3900X (12C/24T, 3.8GHz base, 4.6GHz boost) |
| **RAM** | 128GB DDR4-3200 |
| **GPU** | NVIDIA GT 710 (2GB VRAM, Kepler architecture) |
| **OS** | Windows 10/11 |

## GPU Assessment

**Finding: GT 710 is incompatible with modern CUDA-accelerated LLM inference.**

- Kepler architecture (compute capability 3.5) is too old for LM Studio, llama.cpp CUDA, or vLLM
- No support for FP16/BF16 tensor operations
- 2GB VRAM insufficient for any useful model
- **Verdict: CPU-only inference required**

## CPU-Only Configuration

### LM Studio Settings

```json
{
  "n_gpu_layers": 0,
  "n_threads": 14,
  "n_batch": 512,
  "n_ctx": 4096,
  "use_mmap": true,
  "use_mlock": false
}
```

| Setting | Value | Rationale |
|---------|-------|-----------|
| `n_gpu_layers` | 0 | Pure CPU inference (GT 710 unusable) |
| `n_threads` | 14 | 12C/24T — leave headroom for OS + P4NTH30N agents |
| `n_batch` | 512 | Good throughput without excessive memory |
| `n_ctx` | 4096 | Sufficient for RAG context assembly |
| `use_mmap` | true | Memory-map model file for faster loading |

### Viable Models (CPU-Only Performance)

| Model | Params | Speed (tok/sec) | Quality | RAM Usage | Recommended |
|-------|--------|-----------------|---------|-----------|-------------|
| **Pleias-RAG-1B** | 1.2B | 20-40 | Good for RAG | ~3GB | ✅ **Primary** |
| **TinyLlama-1.1B** | 1.1B | 25-50 | Decent general | ~3GB | Backup |
| **Qwen2.5-0.5B** | 0.5B | 50-100 | Basic | ~1.5GB | Fast fallback |
| **SmolLM2-1.7B** | 1.7B | 15-30 | Better quality | ~4GB | Quality option |
| **Phi-2 (2.7B)** | 2.7B | 8-15 | Good | ~6GB | Too slow |
| **Llama-3.2-3B** | 3.2B | 5-10 | Very good | ~7GB | Too slow |

**7B+ models**: 2-5 tok/sec — **unusable for real-time casino automation**.

## Recommendation

**Primary**: Pleias-RAG-1B (Q4_K_M quantization)
- Optimized for RAG retrieval-augmented generation
- 20-40 tok/sec on Ryzen 9 3900X = ~2-4 second response for 100 tokens
- Acceptable for jackpot prediction context assembly
- Zero recurring cost

**Fallback**: OpenAI API (gpt-4o-mini)
- For when local model quality is insufficient
- $0.002/1K tokens = minimal cost for bootstrap phase
- Sub-second responses

## Performance Expectations

| Task | Tokens | Local (Pleias) | OpenAI (4o-mini) |
|------|--------|----------------|------------------|
| Jackpot prediction | ~200 | 5-10s | <1s |
| Signal analysis | ~100 | 2-5s | <1s |
| Pattern matching | ~300 | 8-15s | <1s |

**For real-time casino automation**: Local model is viable for background analysis (predictions, patterns). OpenAI API recommended for latency-sensitive decisions.

## Future Upgrade Path

A GPU upgrade to RTX 4060+ would enable:
- 7B models at 30-50 tok/sec
- 13B models at 15-25 tok/sec
- Sub-second inference for all tasks
- Estimated cost: $300-500

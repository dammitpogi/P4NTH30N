# Context Window Discovery
## Discovery Task 3: Context Window Limits for Local Models

**Date**: 2026-02-18
**Status**: COMPLETE (documented from specs — live measurement requires LM Studio running)
**Auditor**: WindFixer (Opus 4.6)

---

## 1. Model Context Windows (Specification-Based)

These are the documented context window limits for the models available in LM Studio per `results.json`:

| Model | Parameters | Context Window (spec) | Input Limit | Output Limit | Notes |
|-------|-----------|----------------------|-------------|--------------|-------|
| **qwen2.5-0.5b-instruct** | 0.5B | 32,768 tokens | ~32k | ~32k | Shared input/output window |
| **llama-3.2-1b-instruct** | 1B | 131,072 tokens | ~128k | ~128k | Very large context |
| **smollm2-1.7b-instruct** | 1.7B | 8,192 tokens | ~8k | ~8k | Smallest context of the three |
| **smollm2-135m-instruct** | 135M | 2,048 tokens | ~2k | ~2k | Minimal context |
| **qwen3-0.6b** | 0.6B | 32,768 tokens | ~32k | ~32k | Newer Qwen3 architecture |
| **qwen2.5-coder-0.5b** | 0.5B | 32,768 tokens | ~32k | ~32k | Code-focused variant |

---

## 2. Practical Limits on AMD Ryzen 9 3900X + GT 710

**VRAM constraint**: GT 710 has 2GB VRAM — insufficient for GPU inference. All models run on **CPU only**.

**Practical considerations**:
- Actual usable context may be less than spec due to RAM constraints during inference
- Long contexts increase inference time linearly (attention is O(n²) but with optimizations)
- For config validation (our use case), inputs are typically <500 tokens

### Estimated Practical Limits (CPU inference)

| Model | Practical Max Input | Time at Max Input | Time at 500 tokens |
|-------|--------------------|--------------------|---------------------|
| qwen2.5-0.5b | ~16k tokens | ~30s | ~2.8s |
| llama-3.2-1b | ~16k tokens | ~60s | ~4.2s |
| smollm2-1.7b | ~4k tokens | ~45s | ~8.2s |

*Times based on DEPLOY-002 results.json empirical latency data.*

---

## 3. RAG Implications

### For Retrieval-Augmented Generation

| Factor | Assessment |
|--------|-----------|
| **Context budget for retrieved docs** | 500-2000 tokens (leaving room for system prompt + response) |
| **Optimal chunk size** | 256-512 tokens per chunk |
| **Top-k retrieval** | 3-5 chunks (to stay within budget) |
| **System prompt overhead** | ~200-400 tokens (few-shot examples) |
| **Response budget** | ~200-500 tokens |

### Model Suitability for RAG

| Model | Context Budget | RAG Viable? | Notes |
|-------|---------------|-------------|-------|
| qwen2.5-0.5b | 32k available | ✅ Excellent | Plenty of room, but poor accuracy |
| llama-3.2-1b | 128k available | ✅ Excellent | Huge context, but poor accuracy |
| smollm2-1.7b | 8k available | ✅ Adequate | Best accuracy, sufficient for 5 chunks |

---

## 4. Live Measurement Plan

To get exact limits, use `ModelTestHarness` (already built) with binary search:

```csharp
// Binary search for context limit
async Task<int> FindContextLimit(ILlmBackend backend) {
    int low = 1000, high = 32000;
    while (high - low > 100) {
        int mid = (low + high) / 2;
        string input = new string('x', mid * 4); // ~4 chars per token
        var result = await backend.ChatAsync("Echo.", input);
        if (result.Success) low = mid;
        else high = mid;
    }
    return low;
}
```

**Prerequisite**: LM Studio must be running with each model loaded.
**Recommendation**: Run this test during next LM Studio session to get empirical data.

---

## 5. Key Findings

1. **smollm2-1.7b** has the smallest context (8k) but best accuracy — RAG must be efficient with token budget
2. **Config validation use case** needs <500 input tokens — context is NOT a bottleneck
3. **RAG retrieval** should target 3-5 chunks of 256-512 tokens each
4. **CPU inference** makes latency the real constraint, not context window size

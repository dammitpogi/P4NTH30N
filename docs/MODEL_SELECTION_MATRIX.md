# Model Selection Matrix
## TEST-001 Deliverable - Task-to-Model Mapping

**Decision ID**: TEST-001  
**Last Updated**: 2026-02-19  
**Status**: Initial (based on ARCH-003-PIVOT empirical data)

---

## Empirical Results Summary

Source: `tests/pre-validation/results.json` and `tests/pre-validation/phase0-results.json`

### Models Evaluated

| Model | Parameters | Config Validation Accuracy | JSON Format Valid | Avg Latency | Notes |
|-------|-----------|---------------------------|-------------------|-------------|-------|
| qwen2.5-0.5b-instruct | 0.5B | 20% (1/5) | ✅ | 2800ms | Returns valid:true for everything |
| llama-3.2-1b-instruct | 1B | 20% (1/5) | ❌ | 4250ms | Contradicts itself (says valid:true with failure reasons) |
| smollm2-1.7b-instruct | 1.7B | 40% (2/5) | ✅ | 8180ms | Best ≤2B. Only catches extreme cases (XSS injection) |
| qwen2.5-coder-3b-instruct | 3B | N/A | N/A | N/A | Failed to load (VRAM constraints) |
| qwen2.5-coder-7b-instruct | 7B | N/A | N/A | N/A | Failed to load (VRAM constraints) |

### Hardware Constraints (GT 710 GPU - CPU-only inference)

| Model Size | Can Load | Inference Speed | Practical |
|-----------|----------|-----------------|-----------|
| ≤0.5B | ✅ | Fast (~3s) | ✅ but useless accuracy |
| 1-2B | ✅ | Medium (~8s) | ⚠️ marginal accuracy |
| 3B | ❌ (with others loaded) | N/A | Requires model swapping |
| 7B+ | ❌ | N/A | Exceeds available resources |

---

## Task-to-Approach Matrix

### Decision Gate Result
**Threshold**: ≥70% accuracy → keep LLM, <70% → pure rule-based  
**Best local model**: 40% (smollm2-1.7b)  
**Decision**: **Pure rule-based for all deterministic tasks**

### Current Assignments

| Task | Approach | Accuracy | Latency | Rationale |
|------|----------|----------|---------|-----------|
| **Config Validation** | Rule-based (JsonSchema + BusinessRules) | ~100% for known patterns | <10ms | LLM failed at 40%. Rules are deterministic. |
| **Threshold Ordering** | Rule-based (BusinessRulesValidator) | 100% | <1ms | Simple comparison logic |
| **Required Field Check** | Rule-based (JsonSchemaValidator) | 100% | <1ms | Schema validation |
| **Injection Detection** | Rule-based + LLM fallback | 100% rule / 40% LLM | <1ms / ~8s | Rules catch known patterns; LLM for edge cases |
| **Semantic Analysis** | Deferred (needs ≥3B model) | N/A | N/A | No local model can do this reliably |
| **Code Generation** | External API or manual | N/A | N/A | Beyond local model capability |
| **Summarization** | External API (future) | N/A | N/A | Requires quality >70% to be useful |
| **RAG Query Augmentation** | Rule-based retrieval + optional LLM | N/A | <100ms | Vector search is model-independent |

---

## Recommendation Engine Logic

### For New Tasks

```
IF task is deterministic (clear rules exist):
    → Use rule-based approach
    → Add to JsonSchemaValidator or BusinessRulesValidator

ELSE IF task requires semantic understanding:
    IF accuracy requirement ≤ 40%:
        → smollm2-1.7b-instruct (local, free)
    ELSE IF accuracy requirement ≤ 70%:
        → Consider qwen3-32b via Groq free tier (API)
    ELSE (accuracy > 70%):
        → Requires cloud API (Claude, GPT-4) or hardware upgrade

IF latency requirement < 1s:
    → Rule-based only (LLM too slow for local inference)

IF cost constraint = $0:
    → Rule-based primary, local LLM secondary only
```

### Fallback Chain

```
Primary:   Rule-based validators (always available, <10ms)
Secondary: Local LLM via LM Studio (when running, ~8s)
Tertiary:  Free API tier (Groq qwen3-32b, rate-limited)
Emergency: Manual review flag (_requires_review: true)
```

---

## Future Upgrade Paths

### Path 1: Better Local Hardware
- **Upgrade**: GPU with ≥8GB VRAM (e.g., RTX 3060)
- **Enables**: 7B models locally with good speed
- **Expected accuracy**: 70-85% for config validation
- **Cost**: ~$250 used

### Path 2: API-Based Models
- **Option**: Groq free tier (qwen3-32b, 30 req/min)
- **Enables**: High-quality semantic analysis
- **Expected accuracy**: 85-95%
- **Cost**: $0 (rate-limited)
- **Risk**: External dependency, rate limits

### Path 3: ONNX Quantized Models
- **Option**: ONNX-quantized 3B models (INT4/INT8)
- **Enables**: Faster inference on CPU
- **Expected accuracy**: 60-75%
- **Cost**: $0 (already have ONNX Runtime)
- **Note**: Requires model conversion and testing

---

## Testing Protocol

### For New Model Evaluation

1. **Load model** in LM Studio (localhost:1234)
2. **Run ConfigValidationBenchmark**: 20 test configs (10 valid, 10 invalid)
3. **Run TemperatureSweep**: temps 0.0, 0.1, 0.3, 0.5, 0.7, 1.0
4. **Run PromptConsistencyTester**: n=10 runs per prompt
5. **Record results** in `tests/pre-validation/`
6. **Update this matrix** with new data

### Commands

```powershell
# Run config validation benchmark
dotnet run --project tests/ModelTestingPlatform -- benchmark --model smollm2-1.7b

# Run temperature sweep
dotnet run --project tests/ModelTestingPlatform -- sweep --model smollm2-1.7b

# Run consistency test
dotnet run --project tests/ModelTestingPlatform -- consistency --model smollm2-1.7b --runs 10
```

---

## Key Findings

1. **≤2B local models cannot reliably validate P4NTH30N configs** — they lack semantic understanding of field relationships
2. **Rule-based validation is superior** for deterministic tasks — 100% accuracy, <10ms latency, zero cost
3. **LLM value is in edge cases only** — injection detection, semantic analysis of "does this config make business sense"
4. **Hardware is the bottleneck** — GT 710 GPU is useless for inference, CPU-only limits model size to ≤2B
5. **Hybrid approach is optimal** — rules for known patterns, LLM for unknown/uncertain cases

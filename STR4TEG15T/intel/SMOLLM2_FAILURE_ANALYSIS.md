# SMOLLM2-1.7B FAILURE ANALYSIS
## Why 40% Accuracy vs Expected 60-80%

**Model Specs**: SmolLM2-1.7B-Instruct
- Parameters: 1.7B
- Architecture: Transformer (likely based on Llama or Mistral)
- Training: Instruction-tuned
- Expected capability: Basic reasoning, following instructions

**Actual Performance**: 40% (2/5 correct) on config validation

---

## HYPOTHESIS 1: Prompt Engineering Issue

**Current Prompt Pattern** (assumed):
```
System: You are a config validator. Return JSON: {"valid": bool, "confidence": float, "failures": []}
User: {config_json}
```

**Potential Problems**:
1. **No few-shot examples** - Model doesn't understand "validation" pattern
2. **Ambiguous "valid" definition** - What constitutes valid?
3. **No negative examples shown** - Model hasn't seen what invalid looks like
4. **JSON schema not provided** - Model guessing at output format

**Test**: Same model with improved prompt vs baseline

---

## HYPOTHESIS 2: Temperature/Sampling Randomness

**LM Studio Defaults** (likely):
- Temperature: 0.7 (creative/random)
- Top-p: 0.9
- Top-k: 40

**Problem**: High temperature causes inconsistent outputs
- Run 1: "valid: true" (random choice)
- Run 2: "valid: false" (different random choice)
- No deterministic reasoning

**Test**: Temperature sweep 0.0-1.0, measure consistency

---

## HYPOTHESIS 3: Context Window Truncation

**Test Config Size**: ~500-1000 tokens (estimated)
**SmolLM2 Context Window**: 2048 tokens (advertised)

**Potential Issue**:
- System prompt: ~100 tokens
- User prompt: ~1000 tokens  
- Response: ~100 tokens
- Total: ~1200 tokens

**BUT**: LM Studio may use different tokenization
- SmolLM2 uses BPE tokenizer
- Token count in LM Studio ≠ character count
- Possible silent truncation

**Test**: Binary search for exact context limit

---

## HYPOTHESIS 4: Model Architecture Limitations

**SmolLM2 Training**:
- Trained on general web text
- Instruction tuning on basic Q&A
- NOT trained on:
  - JSON schema validation
  - Structured data analysis
  - Boolean classification tasks

**Comparison**: Code models (Qwen2.5-Coder, CodeLlama) perform better on structured tasks

**Test**: Compare general model vs code model on same validation task

---

## HYPOTHESIS 5: Quantization Impact

**LM Studio Loading**:
- Default: Q4_K_M quantization (4-bit)
- Alternative: Q5_K_M, Q6_K, Q8_0

**Impact of 4-bit quantization**:
- 1.7B model → ~850MB VRAM
- Precision loss in attention layers
- May lose fine-grained reasoning ability

**Test**: Same model at Q4 vs Q8 quantization

---

## HYPOTHESIS 6: System Prompt Interference

**LM Studio System Prompt** (default):
```
You are a helpful AI assistant...
```

**Conflict**: Our system prompt overrides, but LM Studio may prepend/append its own

**Test**: Empty system prompt vs explicit system prompt

---

## TESTING PLATFORM REQUIREMENTS

### 1. Prompt Consistency Tester
```csharp
class PromptConsistencyTester {
    // Run same prompt n=10 times
    // Measure: output consistency, accuracy variance, JSON validity rate
    // Report: mean accuracy, std deviation, worst/best case
}
```

### 2. Context Window Discovery
```csharp
class ContextWindowDiscovery {
    // Binary search for exact token limit
    // Start: 1 token, Double until failure
    // Then binary search between last success and first failure
    // Report: exact context window in tokens
}
```

### 3. Temperature Sweep
```csharp
class TemperatureSweep {
    // Test temp: 0.0, 0.1, 0.2, ..., 1.0
    // Measure: accuracy, consistency, creativity (divergence from expected)
    // Find optimal temp for deterministic tasks
}
```

### 4. Prompt A/B Testing
```csharp
class PromptOptimizer {
    // Test prompt variations:
    // A: Zero-shot
    // B: Few-shot (3 examples)
    // C: Chain-of-thought
    // D: JSON schema provided
    // E: Negative examples included
    // Report: best performing prompt pattern
}
```

### 5. Task-Specific Benchmarks
```csharp
class ConfigValidationBenchmark {
    // 20 test configs: 10 valid, 10 invalid
    // Measure: precision, recall, F1, accuracy
    // Track: false positives (dangerous), false negatives (conservative)
}

class CodeGenerationBenchmark {
    // Test: generate C# class from spec
    // Measure: compile success, test pass, style compliance
}

class SemanticAnalysisBenchmark {
    // Test: "does this threshold make business sense?"
    // Measure: human agreement score
}
```

---

## SMOLLM2-1.7B INVESTIGATION PLAN

**Priority Tests**:

1. **Prompt Engineering** (30 min)
   - Baseline: current prompt → measure accuracy
   - Improved: few-shot examples → measure accuracy
   - Chain-of-thought: step-by-step reasoning → measure accuracy
   - Best of 3: use best performing

2. **Temperature Sweep** (15 min)
   - Temp 0.0, 0.3, 0.7, 1.0
   - 5 runs each
   - Find optimal for consistency

3. **Context Window** (10 min)
   - Binary search for exact limit
   - Verify test configs fit

4. **Quantization Check** (20 min)
   - Q4_K_M vs Q8_0
   - Measure accuracy difference

5. **Consistency Run** (30 min)
   - n=20 runs with optimal settings
   - Measure: accuracy, variance, JSON validity
   - Determine: is model viable or fundamentally inadequate?

**Expected Outcome**:
- If improved prompt → 60%+ accuracy: Model is viable, use better prompts
- If still 40%: Model inadequate for this task, ARCH-003 pivot confirmed

---

## MODEL SELECTION MATRIX (Preliminary)

Based on DEPLOY-002 findings:

| Task | ≤1B Model | 1-3B Model | 3B+ Model |
|------|-----------|------------|-----------|
| Config Validation | ❌ NO | ⚠️ Maybe (test more) | ✅ YES |
| Code Generation | ❌ NO | ⚠️ Partial | ✅ YES |
| Semantic Analysis | ⚠️ Basic | ✅ YES | ✅ YES |
| Summarization | ✅ YES | ✅ YES | ✅ YES |
| Simple Q&A | ✅ YES | ✅ YES | ✅ YES |

**Key Insight**: Task matters more than model size. Need systematic testing.

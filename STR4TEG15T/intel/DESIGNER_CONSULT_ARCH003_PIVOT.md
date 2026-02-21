# DESIGNER CONSULTATION: ARCH-003-PIVOT
## Integrated Model Testing Platform + Rule-Based Validation

**Nexus Request**: Discuss ARCH-003-PIVOT decision with focus on Model Testing Platform integration.

---

## THE PROBLEM

DEPLOY-002 tested 5 models empirically:
- qwen2.5-0.5b (0.5B): 20% accuracy - hallucinates "valid:true"
- llama-3.2-1b (1B): 20% accuracy - invalid JSON  
- smollm2-1.7b (1.7B): **40% accuracy** - SHOULD HAVE BEEN BETTER
- 3B/7B: VRAM fail on GT 710
- Maincoder-1B: Does not exist

**Critical Question**: Why did smollm2-1.7b fail? Is it:
1. Prompt engineering issue?
2. Temperature/sampling randomness?
3. Context window truncation?
4. Model architecture limitations?
5. Quantization impact?
6. All of the above?

---

## PROPOSED SOLUTION (ARCH-003-PIVOT)

**Phase 0: Model Testing Platform** (Days 1-2)
Before implementing the pivot, build testing infrastructure to answer WHY smollm2-1.7b failed.

**Components**:
1. **ModelTestHarness.cs** - Automated test runner for LM Studio
2. **PromptConsistencyTester** - n=10 runs, measure variance
3. **ContextWindowDiscovery** - Binary search for exact token limits
4. **TemperatureSweep** - Test temp 0.0-1.0 impact
5. **PromptOptimizer** - A/B test prompt variations
6. **TaskBenchmarks** - Config validation, code gen, semantic analysis

**Phase 1-3: Rule-Based Validation** (Days 3-5)
Based on testing results, implement:
- JsonSchemaValidator.cs (deterministic, 100% accuracy)
- ValidationPipeline.cs (rule-based primary, LLM secondary)
- FewShotPrompt.cs (semantic analysis only)

---

## QUESTIONS FOR DESIGNER

### 1. Model Testing Platform Architecture

**Q**: How should ModelTestHarness.cs interface with LM Studio?
**Options**:
- A: Direct HTTP API calls to localhost:1234
- B: Process wrapper around lmstudio CLI
- C: Integration with existing LmStudioClient.cs
- D: Mock interface for testing without LM Studio running

**Q**: What's the optimal test case structure?
**Current thinking**:
```csharp
class TestCase {
    string Name;
    string TaskType; // "config_validation", "code_gen", etc.
    string Input;
    string ExpectedOutput;
    float MinAccuracy; // 0.0-1.0
    int RequiredRuns; // n=10 for consistency
    Dictionary<string, object> Metadata;
}
```

### 2. Prompt Consistency Testing

**Q**: How to measure "consistency" across n=10 runs?
**Options**:
- Exact string match (too strict)
- JSON structure match (field presence)
- Semantic equivalence (embeddings similarity)
- Accuracy variance (std deviation)

**Q**: What's acceptable variance for production use?
- <5% variance = production ready
- 5-15% variance = conditional use
- >15% variance = inadequate

### 3. Context Window Discovery

**Q**: How to find exact context limits programmatically?
**Approach**:
```csharp
// Binary search for token limit
int FindContextLimit(model) {
    int low = 1, high = 32768; // advertised max
    while (low < high) {
        int mid = (low + high) / 2;
        if (CanProcess(mid)) low = mid + 1;
        else high = mid;
    }
    return low - 1; // last successful
}
```

**Q**: Should we test for:
- Total context (input + output)
- Input-only limit
- Output-only limit
- Sliding window behavior

### 4. Temperature Impact on Deterministic Tasks

**Q**: What's the optimal temperature for config validation?
**Hypothesis**: temp=0.0 for maximum determinism
**Concern**: Some models degrade at temp=0.0 (repetition loops)

**Q**: Should we use:
- Fixed temp=0.0
- Temperature sweep to find model-specific optimal
- Greedy decoding (argmax, no sampling)

### 5. Rule-Based vs LLM Architecture

**Q**: How to structure the two-stage validation?
**Option A: Sequential**
```
Input → Schema Validator → [PASS] → Semantic LLM → Decision
                    ↓
                  [FAIL] → Reject
```

**Option B: Parallel**
```
Input → Schema Validator ──┐
                           ├──→ Aggregator → Decision
Input → Semantic LLM ──────┘
```

**Option C: Conditional**
```
Input → Schema Validator → [UNCERTAIN] → Semantic LLM → Decision
                    ↓
              [CLEAR PASS/FAIL] → Decision
```

**Q**: What's "uncertain" for schema validator?
- Unknown fields?
- Schema version mismatch?
- Custom validation rules needed?

### 6. JSON Schema Design

**Q**: What schema definition language?
**Options**:
- JSON Schema Draft 7 (standard, verbose)
- C# DataAnnotations (native, limited)
- Custom DSL (flexible, non-standard)
- Hybrid: JSON Schema for structure, C# validators for logic

**Example config to validate**:
```json
{
  "Thresholds": {
    "Grand": 1785,
    "Major": 565,
    "Minor": 117,
    "Mini": 23
  },
  "DPD": {
    "WindowHours": 24,
    "MinSamples": 10
  }
}
```

**Q**: How to express business rules in schema?
- "Grand > Major > Minor > Mini"
- "WindowHours between 1 and 168"
- "MinSamples >= 5"

### 7. Performance Considerations

**Current Performance**:
- Rule-based: <100ms (expected)
- LLM (1.7B): 8.2s (measured)
- LLM (0.5B): 2.8s (measured)

**Q**: Is 100x speedup worth the complexity?
**Trade-off**:
- Rule-based: Fast, deterministic, limited expressiveness
- LLM: Slow, probabilistic, handles edge cases

**Q**: When to use LLM secondary?
- Schema validation passes but looks suspicious?
- Unknown fields present?
- Schema version newer than validator?
- Explicit semantic question ("does this make sense?")

### 8. Model Selection Matrix

**Q**: What tasks should we benchmark?
**Proposed list**:
1. Config validation (ARCH-003)
2. Code generation (SWE-003)
3. Semantic analysis ("business sense")
4. Log classification (ARCH-003)
5. Summarization (context compression)
6. Simple Q&A (baseline)

**Q**: How to present results?
**Option A: Binary** (✅/❌ per task)
**Option B: Graded** (A/B/C/D/F per task)
**Option C: Numeric** (0-100 score per task)
**Option D: Matrix** (model × task = accuracy %)

---

## SMOLLM2-1.7B INVESTIGATION

**Priority**: Determine WHY it scored 40% instead of expected 60-80%

**Immediate Tests**:
1. **Prompt Engineering** (30 min)
   - Baseline: Current prompt
   - Test B: Few-shot examples (3 valid, 3 invalid configs)
   - Test C: Chain-of-thought reasoning
   - Test D: JSON schema provided in prompt

2. **Temperature Sweep** (15 min)
   - Temp: 0.0, 0.1, 0.3, 0.7, 1.0
   - 5 runs each
   - Measure: accuracy mean, variance, JSON validity

3. **Consistency Run** (30 min)
   - Optimal settings from above
   - n=20 runs
   - Determine: Is model viable or inadequate?

**Decision Point**:
- If improved prompt → 60%+: Model viable, use better prompts
- If still 40%: Model inadequate, ARCH-003 pivot confirmed

---

## DELIVERABLES REQUESTED

1. **Architecture Assessment**: Rate ARCH-003-PIVOT approach (0-100)
2. **ModelTestHarness.cs Design**: Interface and structure
3. **Prompt Consistency Strategy**: How to measure and optimize
4. **Two-Stage Validation Flow**: Sequential vs parallel vs conditional
5. **JSON Schema Approach**: Standard vs custom vs hybrid
6. **SmolLM2-1.7B Verdict**: Viable with improvements or inadequate?

Please provide detailed design guidance for the Model Testing Platform and rule-based validation architecture.

# WINDFIXER PROMPT
## Comprehensive Implementation + RAG Discovery Mission

**Context**: OpenFixer session was redirected to save tokens for upcoming RAG layer decision. This work is now assigned to WindFixer for comprehensive P4NTH30N codebase implementation.

**Model**: Opus 4.6 Thinking (preferred for architecture work)
**Environment**: WindSurf on C:\P4NTH30N
**Billing**: Per-prompt (cost-effective for bulk execution)

---

## PART 1: ARCH-003-PIVOT IMPLEMENTATION (Priority 1)

### Background
- DEPLOY-002 proved ≤1B models fail at config validation (20-40% accuracy)
- Designer (78/100): SmolLM2-1.7B INADEQUATE for production
- Oracle (84% conditional): Approved with 70% decision gate threshold
- Both approve: Hybrid rule-based primary + conditional LLM secondary

### Phase 0: Model Testing Platform (Days 1-2)

**Component 1: ModelTestHarness.cs**
```csharp
// Location: tests/ModelTestingPlatform/ModelTestHarness.cs
// Purpose: Automated testing framework for LM Studio models

namespace P4NTH30N.ModelTesting;

public interface ILlmBackend {
    Task<LlmResponse> CompleteAsync(LlmRequest request, CancellationToken ct);
    Task<bool> IsReadyAsync(CancellationToken ct);
    Task<ModelInfo> GetModelInfoAsync(CancellationToken ct);
}

public sealed class LmStudioBackend : ILlmBackend {
    // HTTP interface to localhost:1234/v1/chat/completions
    // Support: temperature, top_p, top_k, do_sample, max_tokens
    // Async with CancellationToken support
}

public sealed class ModelTestHarness {
    // RunBenchmarkAsync - execute test suites
    // Support n runs per test case
    // Collect: accuracy, latency, json_validity, variance
}
```

**Component 2: PromptConsistencyTester.cs**
```csharp
// Location: tests/ModelTestingPlatform/PromptConsistencyTester.cs
// Purpose: Measure output variance across n=10 runs

public sealed class PromptConsistencyTester {
    // MeasureConsistencyAsync - run same prompt n times
    // Calculate: accuracy mean, variance score (std error), JSON validity rate
    // Acceptance: <5% variance = production ready
}
```

**Component 3: TemperatureSweep.cs**
```csharp
// Location: tests/ModelTestingPlatform/TemperatureSweep.cs
// Purpose: Find optimal temperature for deterministic tasks

public sealed class TemperatureSweep {
    // Test temps: 0.0, 0.1, 0.3, 0.5, 0.7, 1.0
    // Measure: accuracy, variance, latency per temperature
    // Find optimal for consistency
}
```

**CRITICAL: SmolLM2-1.7B Investigation**
- Run with temp=0.0 + improved prompts (chain-of-thought)
- Target: 70% accuracy (Oracle threshold)
- Document results in tests/pre-validation/phase0-results.json

**Decision Gate** (End of Day 2):
```
IF SmolLM2-1.7B >= 70%: Keep LLM as secondary
IF 60-70%: Review required  
IF <60%: Full pivot to pure rule-based
```

### Phase 1: Rule-Based Validator (Days 3-4)

**Component 4: JsonSchemaValidator.cs**
```csharp
// Location: scripts/DeployLogAnalyzer/JsonSchemaValidator.cs
// Purpose: Deterministic JSON Schema validation

public sealed class JsonSchemaValidator {
    // Use NJsonSchema library
    // Schema: Credential config (username, platform, house, thresholds, enabled, dpd)
    // Validation: types, required fields, patterns, ranges
    // Performance target: <5ms
}
```

**Component 5: BusinessRulesValidator.cs**
```csharp
// Location: scripts/DeployLogAnalyzer/BusinessRulesValidator.cs
// Purpose: C# business rules for cross-field validation

public sealed class BusinessRulesValidator {
    // Threshold ordering: Grand > Major > Minor > Mini
    // Platform-specific limits (firekirin, orionstars, etc.)
    // DPD sanity checks
    // Performance target: <5ms
}
```

**Component 6: Schema Definitions**
```json
// Location: scripts/DeployLogAnalyzer/schemas/credential.json
// Purpose: JSON Schema for Credential config

{
  "type": "object",
  "required": ["username", "platform", "house", "thresholds", "enabled"],
  "properties": {
    "username": { "type": "string", "minLength": 1, "pattern": "^[a-zA-Z0-9_]+$" },
    "platform": { "enum": ["firekirin", "orionstars", "gamereel", "vegasx"] },
    "thresholds": {
      "type": "object",
      "required": ["Grand", "Major", "Minor", "Mini"],
      "properties": {
        "Grand": { "type": "number", "minimum": 1 },
        "Major": { "type": "number", "minimum": 1 },
        "Minor": { "type": "number", "minimum": 1 },
        "Mini": { "type": "number", "minimum": 1 }
      }
    }
  }
}
```

### Phase 2: Two-Stage Pipeline (Day 5)

**Component 7: ValidationPipeline.cs (Refactored)**
```csharp
// Location: scripts/DeployLogAnalyzer/ValidationPipeline.cs
// Purpose: Conditional two-stage validation

public sealed class ValidationPipeline {
    // Stage 1: Rule-based (85% cases, <10ms)
    // Stage 2: LLM for UNCERTAIN only (15% cases, ~8s) - if decision gate passed
    
    // SAFETY (Oracle required):
    // - Input sanitization before all processing
    // - Error logging to EV3NT collection
    // - Circuit breaker (disable LLM if >10% failure)
    // - Manual override flag (_requires_review)
}
```

**Performance Targets**:
- Rule-based: <10ms for 95% of cases
- Overall: 95% of validations complete in <50ms

---

## PART 2: RAG LAYER DISCOVERY (Priority 2)

### Mission
A new RAG (Retrieval-Augmented Generation) layer decision is coming. Perform comprehensive discovery to inform that decision.

### Discovery Task 1: Existing RAG Infrastructure Audit

**Investigate Current RAG Components**:
```
scripts/rag/
├── embedding-bridge.py    # What does this do? How is it used?
└── faiss-bridge.py        # FAISS integration status?

INFRA-010: MongoDB RAG Architecture
- FAISS vector store status
- ONNX Runtime for embeddings
- all-MiniLM-L6-v2 model usage
```

**Deliverables**:
- Document existing RAG infrastructure in T4CT1CS/intel/RAG_INFRASTRUCTURE_AUDIT.md
- Identify what's working vs placeholder
- List integration points with H0UND/H4ND

### Discovery Task 2: Vector Database Analysis

**Analyze FAISS Implementation**:
```csharp
// Check if FAISS is actually integrated or just specified
// Look for:
// - FAISS index creation code
// - Embedding generation pipeline
// - Vector search queries
// - Hybrid search (BM25 + semantic)
```

**Questions to Answer**:
1. Is FAISS running locally or planned?
2. What's the current embedding pipeline?
3. How are vectors stored and retrieved?
4. What's the search latency?
5. What's the index size limit?

**Deliverable**: T4CT1CS/intel/FAISS_ANALYSIS.md

### Discovery Task 3: Context Window Discovery

**Test Context Limits for RAG**:
```csharp
// Use ModelTestHarness from Part 1
// Binary search for exact context window per model

Test Models:
- qwen2.5-0.5b (0.5B params)
- llama-3.2-1b (1B params)
- smollm2-1.7b (1.7B params)
- Any other models in LM Studio

Measure:
- Input token limit
- Output token limit
- Total context limit
- Behavior at limit (truncation vs error)
```

**Deliverable**: T4CT1CS/intel/CONTEXT_WINDOW_LIMITS.md

### Discovery Task 4: Embedding Model Benchmark

**Test Embedding Quality**:
```python
# Use existing embedding-bridge.py if functional
# Or create test harness

Test Cases:
1. Similar casino game names (firekirin vs fire kirin)
2. Threshold descriptions ("high threshold" vs "grand threshold")
3. Error messages similarity
4. Documentation chunks retrieval

Metrics:
- Embedding generation time
- Similarity search accuracy
- Top-k retrieval relevance
```

**Deliverable**: T4CT1CS/intel/EMBEDDING_BENCHMARK.md

### Discovery Task 5: RAG Use Case Identification

**Identify Where RAG Adds Value**:

**Current System**:
- H0UND: Signal generation based on DPD analysis
- H4ND: Automation execution
- FourEyes: Vision-based decision making

**Potential RAG Use Cases**:
1. **Documentation Retrieval**: Query P4NTH30N docs for troubleshooting
2. **Error Analysis**: Similar error pattern retrieval from ERR0R collection
3. **Decision Context**: Retrieve historical decisions for similar signals
4. **Casino Platform Knowledge**: Retrieve platform-specific quirks/rules
5. **Jackpot History**: Retrieve similar jackpot patterns

**Deliverable**: T4CT1CS/intel/RAG_USE_CASES.md with priority ranking

### Discovery Task 6: Hardware Constraints for RAG

**Assess RAG Viability on Current Hardware**:

**Current Specs**:
- AMD Ryzen 9 3900X (12-core, 24-thread)
- 128GB RAM
- GT 710 GPU (incompatible with CUDA)
- CPU-only inference

**RAG Requirements**:
- Embedding model memory footprint
- FAISS index memory requirements
- Query latency expectations
- Concurrent query capacity

**Questions**:
1. Can we run embedding model + LM Studio simultaneously?
2. What's the max FAISS index size with 128GB RAM?
3. What's the embedding generation throughput?
4. Do we need quantization for embedding model?

**Deliverable**: T4CT1CS/intel/RAG_HARDWARE_ASSESSMENT.md

---

## PART 3: CODEBASE ANALYSIS (Priority 3)

### Task: Existing DeployLogAnalyzer Review

**Review Current Implementation**:
```
scripts/DeployLogAnalyzer/
├── LmStudioClient.cs          # HTTP client for LM Studio
├── ValidationPipeline.cs      # 95% accuracy validation
├── LogClassifier.cs           # Rule-based + LLM log classification
├── DecisionTracker.cs         # Go/no-go tracking
├── FewShotPrompt.cs           # Prompt templates
├── HealthChecker.cs           # System health validation
└── Tests/                     # Unit tests
```

**Analysis Questions**:
1. How does ValidationPipeline integrate with existing components?
2. What's the current accuracy measurement approach?
3. How does LogClassifier's rule-based + LLM hybrid work?
4. What prompts are in FewShotPrompt.cs?
5. How is DecisionTracker used for 2/3 rollback threshold?

**Deliverable**: T4CT1CS/intel/DEPLOYLOGANALYZER_REVIEW.md

---

## EXECUTION ORDER

### Week 1: ARCH-003-PIVOT + Discovery

**Day 1-2: Phase 0 + RAG Discovery Start**
- Build ModelTestHarness, PromptConsistencyTester, TemperatureSweep
- Run SmolLM2-1.7B temp=0.0 test
- BEGIN RAG Discovery Task 1 (Infrastructure Audit)
- **Decision Gate**: End of Day 2

**Day 3-4: Phase 1 + RAG Discovery Continue**
- Implement JsonSchemaValidator, BusinessRulesValidator
- COMPLETE RAG Discovery Tasks 2-3 (FAISS, Context Windows)

**Day 5: Phase 2 + RAG Discovery Complete**
- Implement ValidationPipeline (two-stage)
- COMPLETE RAG Discovery Tasks 4-6 (Embeddings, Use Cases, Hardware)
- Integration tests

### Deliverables Summary

**ARCH-003-PIVOT**:
- [ ] tests/ModelTestingPlatform/ (3 components)
- [ ] scripts/DeployLogAnalyzer/JsonSchemaValidator.cs
- [ ] scripts/DeployLogAnalyzer/BusinessRulesValidator.cs
- [ ] scripts/DeployLogAnalyzer/schemas/credential.json
- [ ] scripts/DeployLogAnalyzer/ValidationPipeline.cs (refactored)
- [ ] Unit tests (20+ cases, 100% coverage)

**RAG Discovery**:
- [ ] T4CT1CS/intel/RAG_INFRASTRUCTURE_AUDIT.md
- [ ] T4CT1CS/intel/FAISS_ANALYSIS.md
- [ ] T4CT1CS/intel/CONTEXT_WINDOW_LIMITS.md
- [ ] T4CT1CS/intel/EMBEDDING_BENCHMARK.md
- [ ] T4CT1CS/intel/RAG_USE_CASES.md
- [ ] T4CT1CS/intel/RAG_HARDWARE_ASSESSMENT.md

**Codebase Analysis**:
- [ ] T4CT1CS/intel/DEPLOYLOGANALYZER_REVIEW.md

---

## REFERENCE DOCUMENTS

**Must Read Before Starting**:
1. T4CT1CS/intel/ASSIMILATED_REVISED_PLAN.md (complete ARCH-003-PIVOT plan)
2. T4CT1CS/intel/DESIGNER_IMPLEMENTATION_PROPOSAL.md (implementation specs)
3. tests/pre-validation/results.json (DEPLOY-002 empirical data)
4. scripts/DeployLogAnalyzer/*.cs (existing components)

**Key Technical Specs**:
- Decision Gate: 70% threshold (Oracle)
- Temperature: 0.0 with greedy decoding (Designer)
- Two-Stage: Rule-based (85%) + LLM for UNCERTAIN (15%)
- JSON Schema: Hybrid (NJsonSchema + C# rules)
- Performance: <10ms rule-based, ~8s LLM fallback

---

## CONSTRAINTS

**If you encounter blockers**:
1. Document in T4CT1CS/actions/pending/CONSTRAINT_REPORT.md
2. Include: component, error, attempted workarounds
3. Continue with other tasks
4. Report at end of session

**Hardware Reality**:
- GT 710 GPU: Incompatible with CUDA (CPU-only)
- LM Studio: localhost:1234 (may need auth disabled)
- 128GB RAM: Sufficient for most operations

---

## SUCCESS CRITERIA

**ARCH-003-PIVOT**:
- [ ] Build: 0 errors, 0 warnings
- [ ] Tests: All pass (>90% coverage)
- [ ] Decision Gate: SmolLM2 result documented
- [ ] Performance: <10ms rule-based validation

**RAG Discovery**:
- [ ] 6 discovery documents complete
- [ ] FAISS status clearly documented
- [ ] Context limits measured for all models
- [ ] Use cases prioritized

**Ready for next RAG layer decision**: All discovery documents inform upcoming decision

---

Begin with Part 1 Day 1: ModelTestHarness.cs + RAG Discovery Task 1 (parallel). Execute.

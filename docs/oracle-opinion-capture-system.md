# Oracle Opinion Capture System

**Purpose:** Systematically capture which implementation details weigh decisions down vs increase approval, with weighted scoring for Fixer guidance.

---

## Oracle Opinion Matrix

### Details That WEIGH DOWN Decisions (Negative Impact)

| Detail | Weight | Rationale | Mitigation |
|--------|--------|-----------|------------|
| **Dual-LLM Architecture** | -15% | Coordination complexity, two failure modes | Use single LLM with confidence scoring |
| **Models <1B Parameters** | -20% | Insufficient reasoning for validation | Use 1B+ coding models (Maincoder-1B) |
| **Vision-Based Validation** | -25% | Pixels vs semantics, high false positive | Use log-based LLM analysis |
| **Binary TRUE/FALSE Output** | -10% | Brittle formatting, no confidence | Use structured JSON with confidence |
| **70% Auto-Rollback Threshold** | -8% | Too aggressive, causes thrashing | Use 2/3 consecutive or <50% |
| **No Pre-Validation** | -12% | Commit before proving viability | Add 5-sample test gate |
| **No Fallback Strategy** | -15% | Single point of failure | Add rule-based fallback |
| **Vague Prompts** | -10% | Ambiguous instructions cause errors | Use few-shot examples |
| **No Circuit Breaker** | -8% | Retry storms, resource exhaustion | Add exponential backoff |
| **No Dead Letter Queue** | -10% | Failed configs lost, no audit | Add DLQ with reviewer assignment |

### Details That Are LOVED (Positive Impact)

| Detail | Weight | Rationale | Implementation |
|--------|--------|-----------|----------------|
| **Local Models ($0 Cost)** | +10% | No API costs, privacy, control | Use LM Studio + GGUF |
| **Confidence Scoring** | +12% | Measurable uncertainty, thresholds | JSON output with 0.0-1.0 score |
| **Pre-Validation Gates** | +15% | Prove before committing | 5-sample test before full build |
| **Structured JSON Output** | +10% | Parseable, schema-validated | Define output schema upfront |
| **Rule-Based Fallback** | +12% | Deterministic when LLM uncertain | JSON Schema validator backup |
| **Benchmark Requirements** | +10% | Measurable success criteria | 50-sample test set with metrics |
| **Prompt Versioning** | +8% | Audit trail, A/B testing | MongoDB PR0MPT_V3RSI0NS collection |
| **Circuit Breaker Pattern** | +8% | Prevents cascade failures | 5 failures → open circuit |
| **Dead Letter Queue** | +10% | Manual intervention path | MongoDB C0NF1G_D34DL3TT3R |
| **Few-Shot Examples** | +8% | Improves consistency | Include 3-5 examples in prompt |
| **Specific Model Selection** | +10% | Right tool for job | Maincoder-1B for code validation |
| **Latency SLAs** | +6% | Performance guarantees | <2s per validation target |
| **Cost Tracking** | +6% | Budget visibility | MongoDB LLM_C0STS collection |
| **Operational Ownership** | +8% | Clear responsibility | Oracle/Strategist on-call rotation |

---

## Guardrail Registry (Hard Constraints)

These are ABSOLUTE requirements from Oracle:

| Guardrail | Violation Consequence | Enforcement |
|-----------|----------------------|-------------|
| **Models MUST be ≤1B for local** | Rejection if >1B | Validate model size before approval |
| **Pre-validation REQUIRED for new models** | Halt if skipped | 5-sample test gate in Phase 1 |
| **Fallback REQUIRED when confidence <50%** | Rejection if missing | Rule-based validator mandatory |
| **Benchmark 50 samples MINIMUM** | Conditional if <50 | Test set size validation |
| **Accuracy >90% REQUIRED** | Rejection if <90% | Metric gate before production |
| **Latency <2s TARGET** | Warning if >2s | Performance profiling required |
| **Circuit breaker at 5 failures** | Risk escalation if missing | Retry logic validation |
| **DLQ for manual review** | Risk escalation if missing | Audit collection required |

---

## Designer Specification Guide

### What Designers MUST Include (Critical for Fixer)

1. **Exact Model Name and Size**
   - ✓ "Maincode/Maincoder-1B, exactly 1B parameters"
   - ✗ "A small model around 1B"

2. **Specific JSON Schemas**
   - ✓ Complete schema with types, ranges, required fields
   - ✗ "JSON output with some fields"

3. **Concrete Code Examples**
   - ✓ Working C# code with error handling
   - ✗ "Use the LLM client"

4. **Measurable Benchmarks**
   - ✓ "50 samples, >90% accuracy, <2s latency"
   - ✗ "Test it and see if it works"

5. **Decision Flow Diagrams**
   - ✓ Visual state machine with all branches
   - ✗ "The LLM decides what to do"

6. **Failure Mode Matrix**
   - ✓ Table of every failure + mitigation
   - ✗ "Handle errors appropriately"

7. **MongoDB Collection Names**
   - ✓ Exact names: PR0MPT_V3RSI0NS, V4L1D4T10N_4UD1T
   - ✗ "Store in a collection"

8. **Latency and Resource Specs**
   - ✓ "Q4_K = 0.8GB, <100ms inference"
   - ✗ "Should be fast"

9. **Phase-by-Phase Deliverables**
   - ✓ Specific files, unit counts, dependencies
   - ✗ "Build it in phases"

10. **Integration Points**
    - ✓ Exact file paths, method signatures
    - ✗ "Integrate with existing code"

---

## Fixer Implementation Guide

### What Fixers Need From Decisions

**CRITICAL (Must Have):**
- [ ] Exact model name and download URL
- [ ] Complete file paths for all deliverables
- [ ] Working code examples (copy-paste ready)
- [ ] JSON schemas (validated)
- [ ] MongoDB collection schemas
- [ ] Test cases with expected outputs
- [ ] Failure handling code

**IMPORTANT (Should Have):**
- [ ] Latency targets
- [ ] Resource requirements (RAM, disk)
- [ ] Dependency versions
- [ ] Configuration examples
- [ ] Logging format

**NICE (Can Infer):**
- [ ] Architecture rationale
- [ ] Alternative approaches considered
- [ ] Future enhancements

---

## Weighted Detail Scoring Example

### ARCH-003 Evolution

| Version | Details Included | Weight Sum | Oracle Approval |
|---------|------------------|------------|-----------------|
| v1.0 (Dual-LLM, 0.5B) | Dual-LLM (-15%), No pre-val (-12%), No fallback (-15%), Binary output (-10%) | -52% | 47% |
| v2.0 (Single LLM, local) | Single LLM (+0%), Confidence (+12%), No pre-val (-12%), No fallback (-15%) | -15% | 72% |
| v3.0 (Maincoder-1B) | Single LLM (+0%), Confidence (+12%), Pre-val (+15%), Fallback (+12%), Benchmark (+10%), Local model (+10%) | +59% | 72%* |

*Approval capped by pre-validation requirement (must complete to unlock higher)

---

## Consultation Workflow Update

### Strategist Must Ask Oracle:

1. **"What specific details in this plan reduce approval?"**
   - Capture weighted negative details
   
2. **"What details would increase approval to 90%+?"**
   - Capture weighted positive details
   
3. **"What are hard guardrails we cannot violate?"**
   - Add to Guardrail Registry
   
4. **"What implementation specifics need more detail?"**
   - Send back to Designer

### Designer Must Provide:

1. **Exact specifications** (not "a model around 1B")
2. **Working code** (not pseudocode)
3. **Complete schemas** (not partial)
4. **Measurable targets** (not "should be fast")
5. **Failure modes** (not "handle errors")

---

## Implementation Checklist

### For META-001 (Schema v2):
- [ ] Add OracleOpinionMatrix to decision schema
- [ ] Add GuardrailRegistry validation
- [ ] Add LovedDetailsCatalog scoring
- [ ] Update Strategist prompts to capture weighted opinions
- [ ] Update Designer prompts to require specific details
- [ ] Update Fixer prompts to read detail weights

### For META-002 (Opinion Capture):
- [ ] Create Oracle consultation template with weight extraction
- [ ] Build Designer specification checklist
- [ ] Implement Fixer detail priority reader
- [ ] Create detail weight database
- [ ] Add approval prediction based on detail weights

---

## Usage Example

**Strategist analyzing ARCH-003:**

```
Oracle approval: 72%

WEIGHING DOWN (-28% total):
- Pre-validation not yet completed (-15% conditional)
- Prompt iteration risk (-8%)
- Malformed JSON edge cases (-5%)

LOVED (+59% total):
+ Local model $0 cost (+10%)
+ Confidence scoring (+12%)
+ Pre-validation plan (+15%)
+ Rule-based fallback (+12%)
+ Benchmark requirements (+10%)

GUARDRAILS:
! MUST complete 5-sample pre-validation
! MUST achieve >90% accuracy on 50 samples
! MUST have <2s latency

PREDICTED APPROVAL AFTER PRE-VALIDATION: 87%
```

---

**Files Created:**
- docs/oracle-opinion-capture-system.md (this file)
- docs/decision-schema-v2.json (enhanced schema)
- T4CT1CS/examples/ARCH-003-example-v2.json (example)

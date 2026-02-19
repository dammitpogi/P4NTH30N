# ASSIMILATED REVISED PLAN: ARCH-003-PIVOT
## Designer + Oracle Consultations Synthesized

**Date**: 2026-02-18  
**Status**: Both consultations complete, plan finalized  
**Ready for Implementation**: YES

---

## CONSULTATION SUMMARY

### Designer Assessment
- **Rating**: 78/100
- **Verdict**: SmolLM2-1.7B INADEQUATE for standalone production
- **Key Finding**: Prompt examples don't demonstrate rule failures; temp=0.1 adds variance
- **Recommendation**: Test temp=0.0 (may reach 50-60%), but rule-based remains necessary

### Oracle Assessment  
- **Rating**: 88/100 (Hybrid approach approval)
- **Final Approval**: 84% CONDITIONAL
- **Key Adjustment**: Decision gate threshold raised from 60% → 70%
- **Rationale**: Even 60% means 40% failure rate—unacceptable for production

---

## REVISED DECISION GATE CRITERIA (Oracle + Designer Consensus)

```
IF SmolLM2-1.7B (temp=0.0, improved prompts) >= 70% accuracy:
    → CONDITIONAL APPROVAL: Keep LLM as secondary with monitoring
    
IF SmolLM2-1.7B >= 60% AND < 70%:
    → REVIEW REQUIRED: Additional analysis needed
    
IF SmolLM2-1.7B < 60%:
    → REJECT: Full pivot to pure rule-based (no LLM)
```

**Rationale**: 70% threshold provides safety margin. Even 60% = 2 in 5 validations wrong.

---

## FINAL ARCHITECTURE (Both Approved)

### Two-Stage Validation (Option C - Conditional)

```
┌─────────────────────────────────────────────────────────────┐
│  INPUT: Config JSON                                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  STAGE 1: Rule-Based Validator (100% deterministic)        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ • NJsonSchema: Structure, types, required fields   │   │
│  │ • C# Business Rules: Threshold ordering, limits    │   │
│  │ • Performance: <10ms per validation                │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
     ┌────────────┐    ┌────────────┐    ┌────────────┐
     │  PASS      │    │ FAIL       │    │ UNCERTAIN  │
     │  (80%)     │    │ (15%)      │    │  (5%)      │
     └────────────┘    └────────────┘    └─────┬──────┘
            │                 │                  │
            ▼                 ▼                  ▼
     ┌────────────┐    ┌────────────┐    ┌────────────┐
     │   ACCEPT   │    │   REJECT   │    │ STAGE 2    │
     │   <10ms    │    │   <10ms    │    │  LLM       │
     └────────────┘    └────────────┘    └─────┬──────┘
                                               │
                              ┌─────────────────┼─────────────────┐
                              ▼                 ▼                 ▼
                       ┌────────────┐    ┌────────────┐    ┌────────────┐
                       │  PASS      │    │ FAIL       │    │ TIMEOUT/   │
                       │  (60%)     │    │ (30%)      │    │ ERROR      │
                       └──────┬──────┘    └──────┬──────┘    └────────────┘
                              │                  │
                              ▼                  ▼
                       ┌────────────┐    ┌────────────┐
                       │   ACCEPT   │    │   REJECT   │
                       │   ~8s      │    │   ~8s      │
                       └────────────┘    └────────────┘
```

### Hybrid JSON Schema (Designer Recommendation)

| Layer | Technology | Coverage | Performance |
|-------|-----------|----------|-------------|
| **Structure** | NJsonSchema | 80% (types, required, patterns) | <5ms |
| **Business Rules** | C# Validator | 20% (threshold ordering, cross-field) | <5ms |
| **Semantic** | LLM (conditional) | 5% edge cases | ~8s |

---

## REVISED 5-DAY TIMELINE (Oracle + Designer)

### Day 1-2: Phase 0 - Model Testing Platform + SmolLM2 Investigation

**Parallel Development Strategy** (Oracle recommendation):

**Track A: Testing Platform** (Primary focus)
- ModelTestHarness.cs - HTTP interface to LM Studio
- PromptConsistencyTester - n=10 variance measurement  
- TemperatureSweep - temp 0.0, 0.1, 0.3, 0.5, 0.7, 1.0

**Track B: Early Phase 1** (Begin Day 2)
- JsonSchemaValidator.cs skeleton
- Schema definitions from existing HunterConfig.json
- BusinessRulesValidator.cs structure

**Decision Gate** (End of Day 2):
- Run SmolLM2-1.7B with temp=0.0 + improved prompts
- Measure accuracy on 5 test cases
- Apply decision gate criteria (70% threshold)

### Day 3-4: Phase 1 - Rule-Based Validator

**If Decision Gate = PASS (SmolLM2 ≥70%)**:
- Complete JsonSchemaValidator with full schema
- Implement BusinessRulesValidator (threshold ordering, platform limits)
- Unit tests (20+ test cases, 100% coverage)
- Keep LLM integration path open

**If Decision Gate = FAIL (SmolLM2 <70%)**:
- Same as above
- Remove LLM integration code
- Add "_requires_review" flag for UNCERTAIN cases
- Simpler integration (pure rule-based)

### Day 5: Phase 2 - Two-Stage Pipeline

**Integration**:
- ValidationPipeline.cs with conditional logic
- Performance benchmarks (<10ms for 95% of cases)
- Integration with H0UND/H4ND
- End-to-end tests

**Safety Mechanisms** (Oracle requirement):
- Input sanitization before any processing
- Error logging to EV3NT collection
- Circuit breaker (disable LLM if >10% failure)
- Metrics dashboard tracking

---

## SAFETY REQUIREMENTS (Oracle Mandated)

### 1. Input Sanitization
```csharp
public string SanitizeInput(string input) {
    // Remove potential prompt injection
    input = input.Replace("{", "{{").Replace("}", "}}");
    // Limit length
    if (input.Length > 10000) throw new ValidationException("Input too large");
    return input;
}
```

### 2. Error Logging
```csharp
// Log all UNCERTAIN → LLM transitions
_eventStore.LogEvent(new ValidationEvent {
    Type = "LLM_FALLBACK",
    ConfigId = config.Id,
    UncertainReason = reason,
    Timestamp = DateTime.UtcNow
});
```

### 3. Circuit Breaker
```csharp
if (_llmFailureRate > 0.10) {
    _logger.LogError("LLM failure rate exceeded 10%, disabling");
    _disableLlm = true;
    _alertService.SendAlert("ARCH-003 LLM circuit breaker triggered");
}
```

### 4. Manual Override
```csharp
// Add _requires_review flag for ambiguous configs
if (config.ContainsKey("_requires_review") || config.ContainsKey("experimental")) {
    return ValidationResult.ReviewRequired("Manual review requested");
}
```

---

## KEY DIFFERENCES: ORIGINAL vs REVISED PLAN

| Aspect | Original (Pre-Consult) | Revised (Post-Consult) |
|--------|------------------------|------------------------|
| **Decision Gate** | 60% threshold | **70% threshold** (Oracle) |
| **Timeline Safety** | Sequential | **Parallel development** (Oracle) |
| **SmolLM2 Verdict** | Test and decide | **INADEQUATE** (Designer), but test anyway |
| **Safety Mechanisms** | Basic | **Enhanced** (Oracle: sanitization, logging, circuit breaker) |
| **Fallback** | Implicit | **Explicit pure rule-based** (both agree) |
| **Approval** | N/A | **84% Oracle, 78% Designer** |

---

## VERIFICATION CRITERIA (Oracle + Designer)

Before marking ARCH-003-PIVOT complete:

1. **Build**: `dotnet build P4NTH30N.slnx` — 0 errors, 0 warnings
2. **Tests**: `dotnet test UNI7T35T/UNI7T35T.csproj` — all pass
3. **Decision Gate**: SmolLM2-1.7B temp=0.0 result documented
4. **Performance**: Rule-based validation <10ms on test configs
5. **Integration**: Two-stage pipeline handles PASS/FAIL/UNCERTAIN
6. **Safety**: Input sanitization + error logging + circuit breaker active

---

## FINAL APPROVAL STATUS

✅ **Designer**: 78/100 - Sound approach, needs explicit decision gates  
✅ **Oracle**: 84% CONDITIONAL - Approved with 70% threshold and safety mechanisms  

**Consensus**: Both approve hybrid architecture with conditional LLM secondary  
**Key Agreement**: Pure rule-based is acceptable fallback if LLM fails  
**Key Difference**: Oracle raised threshold (60%→70%), added safety requirements  

**READY FOR IMPLEMENTATION**

---

## NEXT STEPS

1. ✅ Update ARCH-003-PIVOT decision with revised plan
2. 🔄 Begin Phase 0 (Model Testing Platform)
3. 📊 Run SmolLM2-1.7B temp=0.0 test
4. ⚡ Apply decision gate criteria (70% threshold)
5. 🛠️ Proceed with Phase 1-2 based on decision gate outcome

**The plan is finalized. Implementation can begin.**

# ORACLE CONSULTATION: REVISED ARCH-003-PIVOT PLAN

**Context**: Designer consultation completed (78/100 assessment). Plan revised based on findings.

## ORIGINAL vs REVISED PLAN

| Aspect | Original Plan | Revised Plan (Post-Designer) |
|--------|---------------|------------------------------|
| **Phase 0** | Build testing platform only | Testing platform + SmolLM2 temp=0.0 investigation |
| **Decision Gate** | Implicit | **Explicit**: SmolLM2 must reach 60%+ or pivot fully |
| **Architecture** | Rule-based primary + LLM secondary | **Conditional two-stage**: Rule-based (85%) + LLM for UNCERTAIN only (15%) |
| **JSON Schema** | Standard only | **Hybrid**: NJsonSchema + C# business rules |
| **Temperature** | Not specified | **0.0 with greedy decoding** for deterministic tasks |
| **Timeline** | 5 days | **5 days with decision gate after Day 2** |

## KEY DESIGNER FINDINGS

**SmolLM2-1.7B Root Cause Analysis**:
- Prompt examples don't demonstrate rule failures → model pattern-matches "valid:true"
- Temperature 0.1 causes sampling variance
- **Verdict**: INADEQUATE for standalone production even with improvements
- **Recommendation**: Test temp=0.0 (may reach 50-60%), but rule-based remains necessary

**Two-Stage Validation (Option C - Conditional)**:
```
Input → Rule-Based Validator → [PASS: 80%] → ACCEPT
                           → [FAIL: 15%] → REJECT  
                           → [UNCERTAIN: 5%] → LLM Secondary → ACCEPT/REJECT
```

**Hybrid JSON Schema**:
- NJsonSchema: Structural validation (80% of rules)
- C# Business Rules: Cross-field validation (20% of rules)

## QUESTIONS FOR ORACLE

### 1. Hybrid Approach Approval
**Proposal**: Rule-based primary (deterministic, 100% accuracy for known rules) + LLM secondary for UNCERTAIN cases only (15% of cases requiring semantic analysis)

**Rationale**: 
- DEPLOY-002 proved ≤1B models cannot reliably perform config validation (20-40% accuracy)
- Rule-based provides guaranteed accuracy for schema validation
- LLM only for edge cases beyond schema (e.g., "does this threshold make business sense?")

**Question**: Do you approve this hybrid architecture? What is your approval rating?

### 2. Decision Gate Criteria
**Proposal**: Explicit decision gate after Phase 0 (Day 2)

**Criteria**:
- **IF** SmolLM2-1.7B with temp=0.0 + improved prompts achieves ≥60% accuracy → Keep as secondary validation
- **IF** SmolLM2-1.7B <60% even with improvements → Pivot fully to rule-based, remove LLM secondary

**Rationale**: 
- Designer believes even 60% is inadequate for production
- But empirical testing should determine final verdict
- Decision gate prevents sunk cost fallacy

**Question**: Do you approve these decision gate criteria? What accuracy threshold would you set?

### 3. Timeline Validation
**Proposal**: 5-day timeline with explicit phases

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| Phase 0 | Days 1-2 | Model Testing Platform + SmolLM2 temp=0.0 test |
| Decision Gate | Day 2 end | Go/No-Go based on SmolLM2 results |
| Phase 1 | Days 3-4 | Rule-based validator (NJsonSchema + C# rules) |
| Phase 2 | Day 5 | Two-stage pipeline integration |

**Question**: Is this timeline realistic? Any concerns about the decision gate timing?

### 4. Risk Assessment
**Identified Risks**:
1. **SmolLM2 improves to 60%+**: Medium probability → triggers decision gate
2. **Rule-based misses edge case**: Low probability, high impact → mitigated by LLM fallback
3. **LM Studio auth breaks**: Medium probability → documented workaround (auth disable)
4. **VRAM prevents larger models**: High probability → already accounted for (CPU-only)

**Question**: What is your risk assessment of this revised plan? Any additional risks?

### 5. Safety Requirements
**Current Safety Measures**:
- Deterministic rule-based validation for 85% of cases
- LLM only for UNCERTAIN classification (15%)
- Performance: <10ms for rule-based, ~8s for LLM fallback
- Explicit decision gate prevents inadequate model deployment

**Question**: What additional safety requirements would you impose? Monitoring? Fallbacks?

### 6. Revised Approval Rating
**Original ARCH-003**: 82% conditional (≤1B model, 95% accuracy)
**Current Reality**: ≤1B models proven inadequate (20-40% accuracy)
**Proposed Pivot**: Hybrid rule-based + conditional LLM

**Question**: What is your approval rating for this revised plan? What conditions remain?

## ALTERNATIVE OPTIONS (If Hybrid Rejected)

**Option A**: Pure rule-based (no LLM)
- Pros: 100% deterministic, fast, no model dependencies
- Cons: Cannot handle semantic edge cases, requires complete rule specification

**Option B**: Larger model (3B+) with CPU-only
- Pros: Better reasoning capability
- Cons: 2-5 tokens/sec, 10-20s latency, may still hallucinate

**Option C**: Human-in-the-loop for all validations
- Pros: 100% accuracy
- Cons: Not autonomous, defeats purpose of ARCH-003

**Question**: If you reject the hybrid approach, which alternative do you prefer?

## YOUR ASSESSMENT WILL DETERMINE

1. Whether to proceed with hybrid architecture
2. The accuracy threshold for the decision gate
3. Additional safety requirements
4. Final approval rating for ARCH-003-PIVOT

Please provide comprehensive risk assessment and approval rating.

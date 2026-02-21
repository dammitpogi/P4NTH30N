# ORACLE CONSULTATION BRIEF
## ARCH-003 Pivot: Addressing the ≤1B Model Guardrail

**Context**: DEPLOY-002 completed with empirical validation testing. Critical findings challenge the original ARCH-003 architecture.

**Original Oracle Requirements (ARCH-003)**:
- Model: ≤1B parameters (safety guardrail)
- Accuracy: 95% for deployment decisions
- Architecture: LLM-powered validation
- Your approval: 82% conditional on above

**Empirical Findings from DEPLOY-002**:

| Model | Params | Accuracy | Latency | JSON Valid | Finding |
|-------|--------|----------|---------|------------|---------|
| qwen2.5-0.5b | 0.5B | 20% (1/5) | 2.8s | ✅ | Says "valid:true" for ALL configs |
| llama-3.2-1b | 1B | 20% (1/5) | 4.3s | ❌ | Hallucinates + invalid JSON |
| smollm2-1.7b | 1.7B | 40% (2/5) | 8.2s | ✅ | Best of ≤1B, still inadequate |
| 3B/7B models | 3B+ | N/A | N/A | N/A | VRAM fail on GT 710 |
| Maincoder-1B | 1B | N/A | N/A | N/A | **Does not exist** on HuggingFace |

**Critical Risk Identified**:
Models ≤1B parameters **cannot perform config validation**. They hallucinate positive results, rendering them unsafe for deployment go/no-go decisions.

**Proposed Pivot (ARCH-003-PIVOT)**:
- **Primary**: Rule-based JSON Schema validator (deterministic, 100% accuracy for schema rules)
- **Secondary**: LLM (1-3B) for semantic edge-case analysis ONLY
  - Example: "Does this threshold make business sense?" (schema can't answer)
  - NOT used for structural/type validation
- **Validation Flow**: Schema validation → if passes, optional semantic check → decision

**Risk Assessment Questions**:

1. **Guardrail Violation**: The ≤1B model requirement is infeasible for validation tasks. Should the guardrail be:
   - Removed entirely?
   - Modified to allow rule-based primary?
   - Retained for semantic analysis only?

2. **Safety Analysis**: Rate the proposed architecture (0-100). What risks remain?
   - Rule-based: 100% accuracy for known rules, 0% for unknown edge cases
   - LLM secondary: May hallucinate on semantic questions
   - Combined: Deterministic base + probabilistic overlay

3. **Accuracy Target**: Original 95% target assumed LLM validation. With rule-based primary:
   - Schema validation: 100% for covered rules
   - Semantic analysis: ~40-60% (based on smollm2-1.7b)
   - Combined accuracy calculation?

4. **Attack Vectors**: How could this system fail dangerously?
   - Schema rules incomplete → invalid configs pass
   - LLM semantic hallucination → bad business logic approved
   - Bypass of semantic check → missing business logic validation

5. **Fallback Requirements**: What happens when:
   - Schema validation passes but semantic check fails?
   - Schema validation fails (hard stop vs human review)?
   - LLM unavailable (degrade to schema-only or halt)?

6. **Monitoring Needs**: What safety metrics should track this system's health?
   - Schema coverage (% of configs fully covered by rules)
   - Semantic check override rate
   - False positive/negative rates

7. **Revised Approval**: What approval percentage would you assign to the pivoted architecture? What conditions remain?

**Alternative Options**:
- **Option A**: Rule-based primary + LLM secondary (proposed)
- **Option B**: Ensemble voting (3x ≤1B models, majority vote)
- **Option C**: Larger model (3B+) with CPU-only (slower but accurate)
- **Option D**: Human-in-the-loop for all semantic decisions

**Your assessment will determine the implementation path.**

Please provide risk analysis, approval rating, and any additional safety requirements.

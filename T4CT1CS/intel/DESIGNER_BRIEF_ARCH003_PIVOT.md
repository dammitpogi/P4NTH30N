# DESIGNER CONSULTATION BRIEF
## ARCH-003 Pivot: Rule-Based Primary Validation

**Context**: DEPLOY-002 empirical testing proved ≤1B models cannot perform config validation (20-40% accuracy, hallucinate "valid: true"). Maincoder-1B doesn't exist. Oracle's ≤1B guardrail is infeasible.

**Current ARCH-003 Architecture**:
- LLM-powered deployment analysis using Qwen2.5-0.5B
- 95% accuracy target via LLM validation
- 2/3 consecutive NO-GO rollback threshold
- 6 components: LmStudioClient, HealthChecker, FewShotPrompt, LogClassifier, DecisionTracker, ValidationPipeline

**Proposed Pivot**:
- **Primary**: Rule-based JSON Schema validator (deterministic, 100% accuracy for known rules)
- **Secondary**: LLM for semantic edge-case analysis only (e.g., "does this threshold make business sense?")
- ValidationPipeline refactored: rule-based path first, LLM fallback for semantic gaps

**Empirical Data from DEPLOY-002**:
- qwen2.5-0.5b (0.5B): 20% accuracy, 2.8s latency, valid JSON
- llama-3.2-1b (1B): 20% accuracy, 4.3s latency, INVALID JSON
- smollm2-1.7b (1.7B): 40% accuracy, 8.2s latency, valid JSON
- 3B/7B models: VRAM failure on GT 710
- Maincoder-1B: Does not exist on HuggingFace

**Questions for Designer**:

1. **Architecture Assessment**: Rate the proposed rule-based primary + LLM secondary architecture (0-100). What are its strengths and weaknesses?

2. **Component Design**: How should JsonSchemaValidator.cs be structured? What schema definition approach (JSON Schema Draft 7, custom DSL, etc.)?

3. **LLM Scope Reduction**: How should FewShotPrompt.cs be refactored for semantic-only analysis? What prompts work for "business sense" validation vs structural validation?

4. **Performance Impact**: Rule-based validation will be <100ms vs LLM 2-8s. How does this change the deployment analysis workflow?

5. **Fallback Strategy**: When should the system use LLM secondary? What triggers semantic analysis vs pure schema validation?

6. **Integration Pattern**: How should ValidationPipeline.cs orchestrate the two-stage validation (rule-based → semantic if needed)?

7. **Alternative Approaches**: Are there other architectures we should consider (ensemble voting, confidence scoring, hybrid rule/ML)?

**Deliverables Needed**:
- Architecture assessment with score
- JsonSchemaValidator.cs design specification
- Refactored ValidationPipeline.cs approach
- Updated FewShotPrompt.cs scope definition
- Component interaction diagram

**Timeline**: 2-3 days implementation after approval

**Files to Review**:
- tests/pre-validation/results.json (empirical data)
- scripts/DeployLogAnalyzer/ValidationPipeline.cs (current)
- scripts/DeployLogAnalyzer/FewShotPrompt.cs (current)

Please provide detailed architectural guidance.

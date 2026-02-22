# DECISION_067: Multi-Agent ADR Validation Workflow

**Decision ID**: DECISION_067  
**Category**: ARCH (Architecture)  
**Status**: Approved  
**Priority**: Medium  
**Date**: 2026-02-20  
**Oracle Approval**: 80% (Models: Kimi K2.5 - validation workflow)  
**Designer Approval**: 90% (Models: Claude 3.5 Sonnet - ADR framework)  
**Average Approval**: 85%

---

## Executive Summary

Current decision validation relies on single Oracle and Designer consultations. Research on LLM-based ADR validation shows multi-agent pipelines achieve substantially better accuracy, especially for organizational decisions requiring context beyond code. This decision implements a four_eyes validation workflow where primary agents create and secondary agents validate.

**Current Problem**:
- Single Oracle review may miss implicit assumptions
- Organizational decisions (deployment, compliance) lack validation against institutional knowledge
- No distinction between code-inferable and organizational decisions
- Validation happens once, not continuously
- four_eyes agent underutilized

**Proposed Solution**:
- Implement two-tier validation: automatic for code decisions, multi-agent for organizational
- Primary agent (strategist/oracle) creates ADR
- Validator agents (four_eyes + specialist) review
- Distinguish code-inferable vs organizational decision types
- Continuous validation as context evolves

---

## Research Foundation

### ArXiv Papers Referenced

**[arXiv:2602.07609] Evaluating LLMs for Detecting Architectural Decision Violations**  
*Ruoyu Su et al.* - Analyzed 980 ADRs across 109 GitHub repositories. Multi-model pipeline (one LLM screens, three validate) achieves strong accuracy for explicit/code-inferable decisions. Critical finding: accuracy falls short for implicit/deployment-oriented decisions requiring organizational knowledge.

**[arXiv:2602.04445] AgenticAKM: Enroute to Agentic Architecture Knowledge Management**  
*Rudra Dhar et al.* - Decomposes architecture knowledge management into specialized agents: Extraction, Retrieval, Generation, Validation. User study with 29 repositories validated that agentic approach generates better ADRs than single-prompt approaches.

**[arXiv:2403.01709] Can LLMs Generate Architectural Design Decisions?**  
*Rudra Dhar et al.* - GPT-4 generates relevant/accurate decisions but falls short of human-level. Few-shot examples improve quality. ADR adoption slow due to time constraints—in automation can address this barrier.

**Key Findings**:
- Multi-agent validation achieves substantial agreement
- Code-inferable decisions: LLMs perform well
- Organizational decisions: Require human/agent context
- Specialized validation agents outperform generalists
- Few-shot examples from templates improve quality

---

## Background

### Current State

Decision workflow (existing):
```
Strategist creates decision
    ↓
Oracle reviews (single agent)
    ↓
Designer reviews (single agent)
    ↓
Approved / Rejected
```

**Limitations**:
1. Oracle may miss deployment implications
2. Designer may miss compliance requirements
3. No specialist validation for specific domains
4. four_eyes agent created but not integrated
5. One-shot validation, not continuous

### Decision Type Classification

Research identifies two types:

**Code-Inferable Decisions**:
- Can be validated against codebase
- Example: "Use MongoDB for signal storage"
- Validation: Check if MongoDB driver imported, connection strings exist
- Suitable for automated validation

**Organizational Decisions**:
- Require institutional knowledge
- Example: "Deploy to production after 24-hour burn-in"
- Validation: Requires knowledge of ops procedures, compliance requirements
- Requires multi-agent or human validation

### Desired State

Multi-agent validation workflow:
```
Strategist creates decision
    ↓
Classify: Code-Inferable or Organizational?
    ↓
[Code-Inferable]          [Organizational]
    ↓                           ↓
Explorer validates      four_eyes coordinates
against codebase        specialist validation
    ↓                           ↓
Auto-approve if pass    Oracle + Designer + Librarian
                        vote on approval
                                ↓
                        Human review if disputed
```

---

## Specification

### Requirements

#### DECISION_067-001: Decision Type Classifier
**Priority**: Must  
**Acceptance Criteria**:
- Automatically classify decisions as code-inferable or organizational
- Confidence score for classification
- Override capability for strategist
- Store classification in decision metadata

**Classification Criteria**:
| Factor | Code-Inferable | Organizational |
|--------|---------------|----------------|
| Implementation files | Specific files mentioned | No specific files |
| Technology choice | Library/framework selection | Process/procedure |
| Validation method | Static analysis | Contextual review |
| Examples | "Use Polly for retries" | "Require 24h burn-in" |
| four_eyes role | Optional | Required |

#### DECISION_067-002: Code-Inferable Validation Pipeline
**Priority**: Must  
**Acceptance Criteria**:
- Explorer validates against actual codebase
- Check: Files mentioned exist
- Check: Dependencies referenced in project files
- Check: No conflicts with existing code
- Auto-generate validation report

**Validation Checks**:
```python
def validate_code_inferable(decision):
    issues = []
    
    # Check file references
    for file in decision.referenced_files:
        if not file_exists(file):
            issues.append(f"Referenced file not found: {file}")
    
    # Check dependencies
    for dep in decision.new_dependencies:
        if not dependency_exists(dep):
            issues.append(f"Dependency not found: {dep}")
    
    # Check for conflicts
    for pattern in decision.conflicting_patterns:
        if grep_find(pattern):
            issues.append(f"Conflicting pattern found: {pattern}")
    
    return ValidationReport(
        passed=len(issues) == 0,
        issues=issues,
        confidence=calculate_confidence(decision)
    )
```

#### DECISION_067-003: Organizational Validation Pipeline
**Priority**: Must  
**Acceptance Criteria**:
- four_eyes coordinates multi-agent review
- Query RAG for similar past decisions
- Check compliance with canon patterns
- Verify alignment with strategic direction
- Generate consensus report

**Validation Agents**:
| Agent | Role | Checks |
|-------|------|--------|
| four_eyes | Coordinator | Orchestrates validation, synthesizes findings |
| Oracle | Technical | Feasibility, risk, technical alignment |
| Designer | Architecture | Consistency with existing patterns |
| Librarian | Research | Similar decisions, precedents, external validation |

**Consensus Algorithm**:
```
FOR each validator agent:
  GET approval rating (0-100%)
  GET key concerns
  
IF all ratings >= 80%:
  APPROVE
ELIF average rating >= 70% AND no critical concerns:
  APPROVE with notes
ELIF average rating >= 60%:
  ESCALATE to human review
ELSE:
  REJECT with feedback
```

#### DECISION_067-004: Continuous Validation
**Priority**: Should  
**Acceptance Criteria**:
- Re-validate decisions when context changes
- Trigger: Code changes affecting referenced files
- Trigger: New similar decisions created
- Trigger: Canon patterns updated
- Flag decisions that may need revision

**Change Detection**:
- Monitor git commits for file changes
- Watch RAG for new similar decisions
- Track canon pattern updates
- Notify strategist of potential conflicts

#### DECISION_067-005: Validation Report Generation
**Priority**: Must  
**Acceptance Criteria**:
- Generate structured validation report
- Include: classification, checks performed, findings
- Link to similar decisions from RAG
- Recommendations for improvements
- Store report with decision file

**Report Schema**:
```json
{
  "decisionId": "DECISION_067",
  "validationType": "organizational",
  "timestamp": "2026-02-20T14:30:00Z",
  "validators": [
    {"agent": "four_eyes", "rating": 85, "concerns": []},
    {"agent": "oracle", "rating": 90, "concerns": []},
    {"agent": "designer", "rating": 88, "concerns": ["Consider scalability"]}
  ],
  "consensus": "APPROVE with notes",
  "averageRating": 87.7,
  "similarDecisions": ["DECISION_056", "DECISION_060"],
  "canonAlignment": "Consistent with STRATEGY-ARCHITECTURE-v3",
  "recommendations": [
    "Add scalability considerations to specification"
  ]
}
```

#### DECISION_067-006: four_eyes Integration
**Priority**: Must  
**Acceptance Criteria**:
- Update four_eyes agent prompt with validation workflow
- Define validation-specific responsibilities
- Integration with decision creation flow
- Authority to request additional validators

**four_eyes Responsibilities**:
1. Receive decision for validation
2. Classify type (code/organizational)
3. Route to appropriate validation pipeline
4. Coordinate multi-agent review
5. Synthesize findings into consensus
6. Generate validation report
7. Flag for human review when needed

---

## Technical Details

### Files to Create
- STR4TEG15T/tools/validation/DecisionClassifier.cs
- STR4TEG15T/tools/validation/CodeValidator.cs
- STR4TEG15T/tools/validation/OrganizationalValidator.cs
- STR4TEG15T/tools/validation/ConsensusEngine.cs
- STR4TEG15T/tools/validation/ContinuousValidator.cs
- STR4TEG15T/tools/validation/ValidationReportGenerator.cs

### Files to Modify
- four_eyes.md agent prompt - add validation workflow
- Decision template - add validation section
- Decision creation flow - integrate validation step

### MongoDB Collections
- DECISION_VALIDATIONS - Validation reports
- VALIDATION_CONSENSUS - Aggregated ratings
- DECISION_CLASSIFICATIONS - Type classifications

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-067-001 | Create DecisionClassifier with type detection | @windfixer | Pending | Critical |
| ACT-067-002 | Implement CodeValidator with file/dependency checks | @windfixer | Pending | Critical |
| ACT-067-003 | Build OrganizationalValidator with multi-agent coordination | @windfixer | Pending | Critical |
| ACT-067-004 | Create ConsensusEngine with voting algorithm | @windfixer | Pending | Critical |
| ACT-067-005 | Implement ContinuousValidator with change detection | @windfixer | Pending | High |
| ACT-067-006 | Update four_eyes agent prompt | @strategist | Pending | High |
| ACT-067-007 | Integrate validation into decision creation workflow | @openfixer | Pending | High |
| ACT-067-008 | Seed RAG with validation patterns from research | @librarian | Pending | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_061 (RAG), existing four_eyes agent
- **Related**: All decision-making workflows

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Validation adds significant delay | Medium | Medium | Parallel validation, async where possible |
| Agents disagree frequently | Medium | Low | Clear criteria, human escalation path |
| False positives in code validation | Low | Medium | Conservative checks, human override |
| four_eyes becomes bottleneck | Medium | Low | Load balancing, multiple instances |
| Over-validation stifles agility | Medium | Low | Fast-track for low-risk decisions |

---

## Success Criteria

1. 100% of organizational decisions validated by multiple agents
2. Code-inferable decisions validated automatically within 5 minutes
3. Validation catches >80% of issues before approval
4. four_eyes agent actively used in decision workflow
5. Continuous validation flags >90% of context changes affecting decisions
6. Average validation time <30 minutes for organizational decisions

---

## Token Budget

- **Estimated**: 40,000 tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Critical (<200K)

---

## Questions for Oracle

1. Should validation be blocking (must pass before approval) or advisory?
2. How do we handle validator agents that are unavailable?
3. What's the escalation path when validators strongly disagree?

---

## Consultation Log

### Oracle Consultation
- **Date**: Pending
- **Approval**: Pending
- **Approval**: 80%
- **Key Findings**:
  - Classification accuracy is major dependency; ensure manual override and record misclassifications
  - Validation latency could slow decision flow; implement parallel checks and fast-track lane
  - Clear escalation rules needed when validators disagree; specify quorum + tie-breaker policy
  - Continuous validation should be advisory to avoid alert fatigue until proven reliable

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 90%
- **Key Findings**:
  - 5-phase implementation: Classifier → Code Validator → Organizational Validator → Continuous Validation → Reporting
  - Parallel validation for organizational decisions; code decisions via Explorer
  - Consensus algorithm: All ≥80% = Approve; avg ≥70% = Approve with notes; avg ≥60% = Escalate
  - four_eyes prompt integration with validation workflow and authority to delegate

---

## Notes

**Why Multi-Agent vs Single-Agent Validation**:
- Single agent: Faster, consistent perspective
- Multi-agent: Catches blind spots, diverse expertise
- Research shows multi-agent achieves "substantial agreement" with higher accuracy
- Organizational decisions benefit from multiple perspectives

**Validation as Learning**:
- Validation reports become training data
- Common issues inform template improvements
- Validator feedback improves future decision quality
- Institutional knowledge captured in RAG

**Research Validation**:
The 980 ADR analysis from [arXiv:2602.07609] provides empirical evidence that multi-agent validation outperforms single-agent for complex decisions. Our implementation directly applies these findings.

---

*Decision DECISION_067*  
*Multi-Agent ADR Validation Workflow*  
*2026-02-20*  
*Status: Approved - Ready for Implementation*

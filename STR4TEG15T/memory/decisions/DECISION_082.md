---
type: decision
id: DECISION_082
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.718Z'
last_reviewed: '2026-02-23T01:31:15.718Z'
keywords:
  - decision082
  - model
  - attribution
  - standard
  - for
  - decision
  - consultations
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - why
  - this
  - matters
  - specification
  - requirements
  - examples
  - oracle
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: FORGE-082 **Category**: FORGE (Process) **Status**: Proposed
  **Priority**: Medium **Date**: 2026-02-21 **Oracle Approval**: N/A (Process
  decision - uses all available models) **Designer Approval**: N/A (Process
  decision - uses all available models)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_082.md
---
# DECISION_082: Model Attribution Standard for Decision Consultations

**Decision ID**: FORGE-082  
**Category**: FORGE (Process)  
**Status**: Proposed  
**Priority**: Medium  
**Date**: 2026-02-21  
**Oracle Approval**: N/A (Process decision - uses all available models)  
**Designer Approval**: N/A (Process decision - uses all available models)

---

## Executive Summary

Standardize how model names are documented in decision consultation logs. Instead of "(Assimilated)", use explicit model names with contribution descriptions. This provides accountability, traceability, and helps optimize model selection for future decisions.

**Current Problem**:
- Consultations used "(Assimilated)" to indicate the Strategist provided Oracle/Designer input
- This lacks specificity about which models actually contributed
- No visibility into which models perform better for different decision types

**Proposed Solution**:
- Format: `Approval % (Models: ModelName1 - contribution1, ModelName2 - contribution2)`
- Include in both header approval fields and consultation log sections
- Track which models provide best input for different decision categories

---

## Background

### Current State
Consultation logs show:
```
**Oracle Approval**: 88% (Assimilated)
**Designer Approval**: 95% (Assimilated)
```

### Desired State
Consultation logs show:
```
**Oracle Approval**: 88% (Models: Kimi K2.5 - reasoning, Gemini 2.5 Pro - validation)
**Designer Approval**: 95% (Models: Claude 3.5 Sonnet - implementation, Kimi K2.5 - research synthesis)
```

### Why This Matters
1. **Accountability**: Know which model provided which insight
2. **Optimization**: Track which models perform best for different decision types
3. **Transparency**: Nexus can see who's "voting" on decisions
4. **Cost Control**: Attribute token usage to specific model contributions

---

## Specification

### Requirements

1. **FORGE-082-001**: Header Format Standard
   - **Priority**: Must
   - **Acceptance Criteria**: All new decisions use model attribution format
   - **Format**: `Approval % (Models: ModelName1 - contribution1, ModelName2 - contribution2)`

2. **FORGE-082-002**: Consultation Log Format
   - **Priority**: Must
   - **Acceptance Criteria**: Each consultation includes Models section
   - **Content**: List of models that contributed with their specific contributions

3. **FORGE-082-003**: Retroactive Update
   - **Priority**: Should
   - **Acceptance Criteria**: Existing decisions updated when modified
   - **Scope**: Decisions modified after this decision's approval

4. **FORGE-082-004**: Model Contribution Tracking
   - **Priority**: Could
   - **Acceptance Criteria**: Track which models appear most in approvals
   - **Usage**: Optimize model selection for future consultations

---

## Model Attribution Examples

### Oracle Consultation
```
### Oracle Consultation
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (reasoning), Gemini 2.5 Flash (speed)
- **Approval**: 88%
- **Key Findings**:
  - Risk assessment: Kimi identified 3 new risk vectors
  - Validation speed: Gemini completed 50 similarity searches in 2s
```

### Designer Consultation
```
### Designer Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (implementation architecture), Kimi K2.5 (research synthesis)
- **Approval**: 92%
- **Key Findings**:
  - Implementation: Claude provided 4-phase breakdown with file mapping
  - Research: Kimi synthesized 5 ArXiv papers into 3 actionable items
```

### When Strategist Assimilates
```
### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (Strategist - reasoning), Claude 3 Haiku (Strategist - quick validation)
- **Approval**: 85%
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-082-001 | Update decision template with model attribution format | @strategist | Pending | High |
| ACT-082-002 | Update existing decisions (079-081) with model names | @strategist | Pending | Medium |
| ACT-082-003 | Document model contribution tracking in manifest | @strategist | Pending | Low |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: All existing decisions

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Template complexity increases | Low | Low | Keep format simple |
| Retroactive updates take time | Low | Medium | Prioritize active decisions |
| Model names change | Low | Medium | Use model family names, not specific versions |

---

## Success Criteria

1. ⬜ New decisions use model attribution format
2. ⬜ Template updated with model section
3. ⬜ Active decisions (079-081) updated
4. ⬜ Model contribution visible in consultation logs

---

## Token Budget

- **Estimated**: 5K tokens
- **Model**: N/A (Strategist documentation)
- **Budget Category**: Routine (<50K)

---

## Notes

This standard applies to:
- Oracle consultation approvals
- Designer consultation approvals  
- Any agent role assimilation documentation

The format should appear in:
1. Decision header: `**Oracle Approval**: XX% (Models: ...)`
2. Consultation log section: `- **Models**: ModelName - contribution`

---

*Decision FORGE-082*  
*Model Attribution Standard*  
*2026-02-21*

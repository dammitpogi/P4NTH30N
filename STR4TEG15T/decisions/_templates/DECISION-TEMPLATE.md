# [DECISION-ID]: [Title]

**Decision ID**: [CATEGORY]-[NNN]  
**Category**: [INFRA|CORE|FEAT|TECH|RISK|AUTO|FORGE|ARCH]  
**Status**: Proposed  
**Priority**: [Critical|High|Medium|Low]  
**Date**: [YYYY-MM-DD]  
**Oracle Approval**: [0-100 or Pending]  
**Designer Approval**: [0-100 or Pending]

---

## Executive Summary

[1-2 paragraph summary of the decision, its purpose, and expected outcomes]

**Current Problem**:
- [Bullet points describing the problem]

**Proposed Solution**:
- [Bullet points describing the solution]

---

## Background

[Detailed context, prior art, and rationale for this decision]

### Current State
[What's happening now?]

### Desired State
[What should happen instead?]

---

## Specification

### Requirements

1. **[Requirement ID]**: [Description]
   - **Priority**: [Must|Should|Could]
   - **Acceptance Criteria**: [Measurable criteria]

### Technical Details

[Implementation details, architecture, code examples]

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-XXX | [Action description] | [Agent] | [Status] | [Priority] |

---

## Dependencies

- **Blocks**: [List of decisions this blocks]
- **Blocked By**: [List of decisions blocking this]
- **Related**: [List of related decisions]

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| [Risk description] | [High/Med/Low] | [High/Med/Low] | [Mitigation strategy] |

---

## Success Criteria

1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

---

## Token Budget

- **Estimated**: [N] tokens
- **Model**: [Recommended model for Fixer implementation]
- **Budget Category**: [Routine (<50K) | Critical (<200K) | Bug Fix (<20K) | Research (<30K)]

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No (Assimilated) |
| Designer | Architecture sub-decisions | Medium | No (Assimilated) |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: [YYYY-MM-DD]
- **Approval**: [X]%
- **Key Findings**: [Summary]
- **File**: [consultations/oracle/...]

### Designer Consultation
- **Date**: [YYYY-MM-DD]
- **Approval**: [X]%
- **Key Findings**: [Summary]
- **File**: [consultations/designer/...]

---

## Notes

[Any additional notes, references, or context]

---

*Decision [CATEGORY]-[NNN]*  
*[Title]*  
*[Date]*

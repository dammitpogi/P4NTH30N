# DECISION_043: L33T Directory Rename Final Approval

**Decision ID**: RENAME-043  
**Category**: ARCH  
**Status**: Proposed  
**Priority**: Medium  
**Date**: 2026-02-20  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

DECISION_031 (L33T Directory Rename) was proposed to rename H0UND, H4ND, C0MMON to HOUND, HAND, COMMON to reduce LLM confusion. WindFixer noted this as "Proposed, NOT Approved (Designer pending)". This decision seeks final Oracle and Designer approval to proceed with or reject the rename.

**Current Problem**:
- L33T names (H0UND, H4ND, C0MMON) cause confusion for lower-tier LLMs
- DECISION_031 created but Designer consultation pending
- Rename would affect 50+ files and git history

**Proposed Solution**:
- Get final Oracle approval (feasibility, risk assessment)
- Get final Designer approval (implementation strategy)
- If approved: Execute rename across codebase
- If rejected: Document rationale and close

---

## Background

### Current State

**From WindFixer Report**:
- DECISION_031: Proposed, NOT Approved
- Designer: Pending
- No implementation started

**L33T Names in Use**:
- H0UND (Analytics Agent)
- H4ND (Automation Agent)
- C0MMON (Shared components)
- W4TCHD0G (Vision system)
- UNI7T35T (Test project)
- STR4TEG15T (Strategy/Decisions)

### Desired State

Clear decision on rename:
- **If Approved**: Systematic rename with git history preservation
- **If Rejected**: Accept L33T names as project identity

---

## Specification

### Requirements

#### RENAME-043-001: Oracle Risk Assessment
**Priority**: Must  
**Acceptance Criteria**:
- Assess feasibility of rename (0-10)
- Assess risk of rename (0-10)
- Consider git history impact
- Evaluate LLM confusion vs. branding value
- Provide approval percentage

#### RENAME-043-002: Designer Implementation Strategy
**Priority**: Must  
**Acceptance Criteria**:
- Detailed rename plan
- File list (all 50+ affected files)
- Git history preservation strategy
- Rollback plan if issues
- Effort estimate

#### RENAME-043-003: Execute Rename (If Approved)
**Priority**: Should  
**Acceptance Criteria**:
- Rename all directories
- Update all file references
- Update namespace declarations
- Update project files
- Update documentation
- Preserve git history
- All tests pass after rename

### Technical Details

**Rename Mapping**:
```
H0UND/ → HOUND/
H4ND/ → HAND/
C0MMON/ → COMMON/
W4TCHD0G/ → WATCHDOG/
UNI7T35T/ → UNITTEST/
STR4TEG15T/ → STRATEGIST/
```

**Files Affected** (estimated):
- 50+ C# files (namespace declarations)
- 10+ project files (.csproj)
- 5+ solution files (.sln, .slnx)
- 20+ documentation files
- Git history references

**Implementation Strategy** (if approved):
1. Create git branch for rename
2. Rename directories
3. Update namespace declarations
4. Update project references
5. Update documentation
6. Run full build
7. Run all tests
8. Merge to main

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-043-001 | Oracle consultation for risk assessment | Oracle | Pending | Critical |
| ACT-043-002 | Designer consultation for implementation | Designer | Pending | Critical |
| ACT-043-003 | Execute rename (if approved) | WindFixer | Pending | Medium |
| ACT-043-004 | Update all documentation | WindFixer | Pending | Medium |

---

## Dependencies

- **Blocks**: None (can proceed in parallel)
- **Blocked By**: Oracle and Designer approval
- **Related**: DECISION_031 (original proposal)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Git history confusion | Medium | High | Use git mv, clear commit messages |
| Broken references | High | Medium | Comprehensive search/replace, testing |
| External links break | Medium | Low | Update all documentation |
| Team confusion | Low | Medium | Communication, documentation |
| Effort underestimated | Medium | Medium | Detailed planning, buffer time |

---

## Success Criteria

1. **Decision Made**: Approved or Rejected with clear rationale
2. **If Approved**: All directories renamed, all tests pass
3. **If Rejected**: Document accepted, L33T names remain
4. **No Regrets**: Decision sticks, no flip-flopping

---

## Token Budget

- **Estimated**: 15K tokens (for consultations)
- **If Approved**: +30K tokens (implementation)
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Routine (<50K)

---

## Consultation Log

### Oracle Consultation
- **Date**: Pending
- **Approval**: Pending
- **Key Findings**: Pending

### Designer Consultation
- **Date**: Pending
- **Approval**: Pending
- **Key Findings**: Pending

---

## Notes

**Arguments FOR Rename**:
- Reduces LLM confusion
- Easier onboarding for new developers
- Standard naming conventions

**Arguments AGAINST Rename**:
- Project identity/branding
- Git history disruption
- Significant effort for cosmetic change
- Current team accustomed to names

**Alternative**: Keep L33T names as project identity, improve LLM prompting instead

---

*Decision RENAME-043*  
*L33T Directory Rename Final Approval*  
*2026-02-20*

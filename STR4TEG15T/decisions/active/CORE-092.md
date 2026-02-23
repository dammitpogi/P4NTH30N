# DECISION-092: H4ND Directory Codemap Generation

**Decision ID**: CORE-092  
**Category**: CORE  
**Status**: Approved  
**Priority**: Medium  
**Date**: 2026-02-23  
**Oracle Approval**: 82%  
**Designer Approval**: Pending

---

## Executive Summary

This decision outlines the systematic generation of codemaps for all H4ND directories to maintain comprehensive code documentation and architectural clarity. The codemaps will serve as living documentation for the H4ND system, providing clear insights into each directory's purpose, structure, and key components.

**Current Problem**:
- H4ND directory structure lacks consistent codemap documentation
- New team members face difficulties understanding code organization
- Code evolution without proper documentation tracking
- Manual discovery of directory structure and components

**Proposed Solution**:
- Generate comprehensive codemaps for all H4ND directories
- Update existing AGENTS.md files with accurate directory information
- Establish standardized codemap format across all directories
- Enable automated codemap generation for future maintenance

---

## Background

### Current State
The H4ND directory contains multiple specialized directories including Agents, Composition, Domains, Infrastructure, Monitoring, Navigation, Parallel, Services, SmokeTest, tools, and Vision. While there is a main AGENTS.md file and some individual codemaps, many directories lack comprehensive documentation that explains their purpose, key classes, responsibilities, and relationships.

### Desired State
Each directory in H4ND will have a detailed codemap in its AGENTS.md file that includes:
- Directory purpose and scope
- Key classes and their responsibilities
- Dependencies and relationships
- Entry points and main interfaces
- Usage patterns and examples
- Integration points with other directories

---

## Specification

### Requirements

1. **REQ-CODEMAP-001**: Generate codemaps for all H4ND directories
   - **Priority**: Must
   - **Acceptance Criteria**: All 13 directories have AGENTS.md files with codemaps

2. **REQ-CODEMAP-002**: Maintain consistent codemap format
   - **Priority**: Should
   - **Acceptance Criteria**: All codemaps follow standardized template

3. **REQ-CODEMAP-003**: Ensure technical accuracy
   - **Priority**: Must
   - **Acceptance Criteria**: Codemaps accurately reflect current code structure

### Technical Details

The codemaps will be generated using a combination of:
- Static code analysis to identify classes, methods, and dependencies
- Pattern recognition to identify architectural roles
- Manual review for accuracy and completeness
- Template-based generation for consistency

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-092-001 | Explore H4ND directory structure | @explorer | Pending | High |
| ACT-092-002 | Generate codemaps for Agents/ directory | @explorer | Pending | Medium |
| ACT-092-003 | Generate codemaps for bin/ directory | @explorer | Pending | Medium |
| ACT-092-004 | Generate codemaps for Composition/ directory | @explorer | Pending | Medium |
| ACT-092-005 | Generate codemaps for config/ directory | @explorer | Pending | Medium |
| ACT-092-006 | Generate codemaps for Domains/ directory | @explorer | Pending | Medium |
| ACT-092-007 | Generate codemaps for EntryPoint/ directory | @explorer | Pending | Medium |
| ACT-092-008 | Generate codemaps for Infrastructure/ directory | @explorer | Pending | Medium |
| ACT-092-009 | Generate codemaps for Monitoring/ directory | @explorer | Pending | Medium |
| ACT-092-010 | Generate codemaps for Navigation/ directory | @explorer | Pending | Medium |
| ACT-092-011 | Generate codemaps for Parallel/ directory | @explorer | Pending | Medium |
| ACT-092-012 | Generate codemaps for Services/ directory | @explorer | Pending | Medium |
| ACT-092-013 | Generate codemaps for SmokeTest/ directory | @explorer | Pending | Medium |
| ACT-092-014 | Generate codemaps for tools/ directory | @explorer | Pending | Medium |
| ACT-092-015 | Generate codemaps for Vision/ directory | @explorer | Pending | Medium |
| ACT-092-016 | Review and validate all codemaps | @librarian | Pending | Medium |
| ACT-092-017 | Update main AGENTS.md with summary | @windfixer | Pending | Low |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION-086 (Directory-Aware Decision System)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Code structure changes during documentation | Medium | Low | Generate documentation in quick succession |
| Inaccurate codemap content | High | Medium | Librarian validation and technical review |
| Inconsistent formatting | Low | Medium | Use standardized template and review process |
| Performance issues during directory analysis | Low | Low | Use efficient pattern matching techniques |

---

## Success Criteria

1. All 13 H4ND directories have comprehensive AGENTS.md codemaps
2. Codemaps accurately reflect current code structure and relationships
3. Documentation follows standardized format and structure
4. Main AGENTS.md file contains accurate directory summary
5. Documentation is validated for technical accuracy

---

## Token Budget

- **Estimated**: 80,000 tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Routine (<50K) - Extended for comprehensive coverage

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
| Oracle | Validation sub-decisions | Medium | No |
| Designer | Architecture sub-decisions | Medium | No |
| WindFixer | Implementation sub-decisions | High | Yes |
| OpenFixer | Config/tooling sub-decisions | High | Yes |
| Forgewright | Bug-fix sub-decisions | Critical | Yes |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-23
- **Models**: Kimi K2.5 (Strategist)
- **Approval**: 82%
- **Key Findings**: Feasibility: 8/10, Risk: 4/10, Complexity: 5/10. Primary risk is documentation drift and accuracy. Token budget classification inconsistent (80k vs "Routine <50k").
- **File**: consultations/oracle/CORE-092-oracle.md

### Designer Consultation
- **Date**: 2026-02-23
- **Models**: Kimi K2.5 (Strategist)
- **Approval**: Approved with strategy
- **Key Findings**: Phased 6-day implementation approach, template lock strategy, 13 files to create, automated validation required. Special handling needed for Domains/ subdirectory structure.
- **File**: consultations/designer/CORE-092-designer.md

---

## Notes

This decision establishes the foundation for maintainable code documentation in the H4ND system. The codemaps will serve as both onboarding documentation and architectural references. Future maintenance should include periodic updates to reflect code evolution.

---

*Decision CORE-092*  
*H4ND Directory Codemap Generation*  
*2026-02-23*
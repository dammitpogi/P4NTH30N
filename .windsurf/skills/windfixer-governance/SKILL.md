# WindFixer Governance Skill

## Trigger
WindFixer implementation work, decision closure, or self-improvement activities.

## Description
Implements OpenFixer-style codebase-centric governance with Strategist audit methodology and mandatory manifest tracking.

## Core Capabilities

### 1. Codebase-Centric Governance (OpenFixer Pattern)
- Majority time spent in P4NTHE0N directory work
- Real-time learning capture during runs
- Extensive JOURNAL_* pattern deployment journals
- Knowledge base write-back to W1NDF1XER/knowledge/
- Pattern capture to W1NDF1XER/patterns/

### 2. Strategist-Style Audit Methodology
- System Correctness + Change Governance lenses
- Evidence spine validation (assumption register, decision rationale, consultation deltas, validation commands, closure evidence paths)
- Requirement-by-requirement audits (PASS/PARTIAL/FAIL)
- Deterministic closure packets with parity matrices
- Closure checklist with harden/expand/narrow questions

### 3. Mandatory Manifest Tracking
- Every handoff updates STR4TEG15T/memory/manifest/manifest.json
- Round tracking with unique RXXX identifiers
- Narrative elements: tone, theme, keyMoment, emotion
- Metrics capture: filesModified, linesAdded, oracleApproval, designerApproval

### 4. Workflow Loop Respect
- Loop 1: Strategist ↔ Consultations (Manual Nexus control)
- Loop 2: OpenFixer ↔ Strategist (Automated handoff audit)

## Implementation Steps

### Phase 1: Startup Gates
1. Decision recall from STR4TEG15T/decisions/
2. Knowledgebase preflight from W1NDF1XER/knowledge/
3. Local discovery in P4NTHE0N directory
4. Web research if needed

### Phase 2: Execution with Learning Capture
1. Codebase-centric implementation in P4NTHE0N directory
2. Real-time knowledge capture during runs
3. Pattern identification and documentation
4. Deployment journal creation (JOURNAL_* format)

### Phase 3: Strategist Audit
1. System Correctness lens assessment
2. Change Governance lens assessment
3. Evidence spine validation
4. Requirement-by-requirement audit
5. Closure recommendation

### Phase 4: Manifest Update
1. Generate round ID (RXXX)
2. Update STR4TEG15T/memory/manifest/manifest.json
3. Include narrative elements and metrics
4. Mark handoff complete

## Templates

### Execution Log Template
```markdown
## Execution Log: [DECISION_ID]

**Decision IDs**: [linked decisions]
**Knowledgebase files consulted (pre)**: [files from W1NDF1XER/knowledge]
**Discovery actions**: [exploration steps]
**Implementation actions**: [changes made]
**Validation commands + outcomes**: [test results]
**Knowledgebase/pattern write-back (post)**: [new learning deltas]
**Audit matrix**: [PASS/PARTIAL/FAIL per requirement]
**Re-audit matrix (if needed)**: [after remediation]
```

### Deployment Journal Template
```markdown
# JOURNAL_YYYY-MM-DD_DECISION_[ID].md

## Task Summary
[What was implemented in P4NTHE0N directory]

## Files Changed
[List with paths and brief descriptions - focus on P4NTHE0N codebase]

## Commands Run
[CLI operations performed - dotnet build, test, etc.]

## Discovery Actions
[Codebase exploration and findings during run]

## Knowledgebase Files Consulted (Pre)
[Files from W1NDF1XER/knowledge consulted before implementation]

## Implementation Actions
[Changes made during P4NTHE0N directory work]

## Validation Commands + Outcomes
[Test results and validation]

## Knowledgebase/Pattern Write-Back (Post)
[New learning deltas captured during run]

## Audit Matrix
[Requirement-by-requirement PASS/PARTIAL/FAIL]

## Re-Audit Matrix (if needed)
[After remediation during same run]

## Learning Deltas Assimilated During Run
[Patterns and knowledge captured in real-time]

## Source Reference Map Updates
[New codebase references discovered]
```

### Strategist Audit Template
```markdown
# Strategist Audit: [DECISION_ID]

## Lens A: System Correctness
- **Runtime Behavior**: [assessment]
- **Failure Modes**: [identified risks]
- **Security Boundaries**: [security assessment]
- **Observability**: [monitoring coverage]

## Lens B: Change Governance
- **Release Discipline**: [deployment readiness]
- **Rollback Posture**: [rollback capability]
- **Audit Trail**: [traceability assessment]
- **Ownership Clarity**: [responsibility mapping]

## Evidence Spine Validation
- **Assumption Register**: [validated assumptions]
- **Decision Rationale**: [rationale completeness]
- **Consultation Deltas**: [Oracle/Designer inputs handled]
- **Validation Commands**: [test coverage]
- **Closure Evidence Paths**: [completion evidence]

## Requirement-by-Requirement Audit
| Requirement | Status | Evidence Path |
|-------------|--------|---------------|
| [Req 1] | [PASS/PARTIAL/FAIL] | [evidence] |
| [Req 2] | [PASS/PARTIAL/FAIL] | [evidence] |

## Closure Recommendation
**Recommendation**: [Close/Iterate/Keep HandoffReady]
**Rationale**: [justification]
**Blockers**: [any remaining issues]

## Closure Checklist
- **Harden Question**: [what to harden]
- **Expand Question**: [what to expand]  
- **Narrow Question**: [what to narrow]

## Manifest Update Required
**Round ID**: [RXXX]
**Session Context**: [brief description]
**Agent**: WindFixer
**Narrative Elements**: tone/theme/keyMoment/emotion
**Metrics**: filesModified/linesAdded/oracleApproval/designerApproval
```

### Oracle Assessment Template
```yaml
---
date: [YYYY-MM-DDTHH:MM:SS]
decisionId: [DECISION_ID]
status: IN_PROGRESS
threadConfidence: [0-100]
assessment: [Oracle's assessment]
penned: Oracle
---

# Oracle Assessment: [DECISION_ID]

## Thread Confidence: [0-100]

## Risk Assessment
[Risk evaluation and concerns]

## Approval Score: [0-100]

## Recommendations
[Oracle's recommendations]

## Append-Only Thread
[Oracle's thoughts and updates with timestamps]
```

### Designer Architecture Template
```markdown
# Architecture Proposal: [DECISION_ID]

## Overview
[High-level architectural approach]

## Components
[List of components and their responsibilities]

## Data Flow
[How data flows through the system]

## Dependencies
[External dependencies and requirements]

## Implementation Tasks
[Step-by-step implementation plan]

## Parallel Workstreams
[Tasks that can be executed in parallel]

## Iteration Tracking
[Conditional approval tracking if needed]
```

## Quality Gates

### Before Implementation
- [ ] Decision recalled and understood
- [ ] Knowledgebase consulted
- [ ] Local discovery completed
- [ ] Oracle/Designer documentation created (if applicable)

### During Implementation
- [ ] Codebase-centric work in P4NTHE0N directory
- [ ] Real-time learning capture active
- [ ] Patterns identified and documented
- [ ] Deployment journal being updated

### Before Closure
- [ ] Strategist audit completed
- [ ] Evidence spine validated
- [ ] All requirements PASS/PARTIAL/FAIL assessed
- [ ] Closure recommendation made

### Final Handoff
- [ ] Manifest updated with round tracking
- [ ] Narrative elements captured
- [ ] Metrics recorded
- [ ] Decision marked complete

## Success Metrics

### OpenFixer-Style Metrics
- Time spent in P4NTHE0N directory: >80%
- Knowledge files created: 1+ per implementation
- Patterns captured: 1+ per implementation
- Deployment journals: 1 per decision

### Strategist-Style Metrics
- Audit completion rate: 100%
- Evidence spine validation: 100%
- Requirement coverage: 100%
- Closure recommendation: 100%

### Manifest Metrics
- Handoff tracking: 100%
- Round ID generation: 100%
- Narrative elements: 100%
- Metrics capture: 100%

## Integration Points

### With Oracle/Designer
- Respect manual Nexus control of Loop 1
- Create documentation during each iteration
- Capture all consultation inputs

### With Manifest System
- Update STR4TEG15T/memory/manifest/manifest.json
- Generate unique round IDs
- Capture narrative elements for synthesis

### With Knowledgebase
- Write learning deltas to W1NDF1XER/knowledge/
- Capture patterns to W1NDF1XER/patterns/
- Maintain source reference maps

This skill ensures WindFixer operates with OpenFixer's codebase-centric governance while conducting Strategist-style audits and maintaining complete manifest tracking.
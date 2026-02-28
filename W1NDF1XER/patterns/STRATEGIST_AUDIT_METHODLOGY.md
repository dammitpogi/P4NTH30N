# Pattern: Strategist Audit Methodology

## Trigger
Before decision closure or handoff completion.

## Pattern Description
WindFixer conducts Strategist-style audits using System Correctness + Change Governance lenses with evidence spine validation.

## Audit Framework

### Lens A: System Correctness
- **Runtime Behavior**: Assessment of implementation behavior
- **Failure Modes**: Identified risks and failure scenarios
- **Security Boundaries**: Security assessment of changes
- **Observability**: Monitoring coverage assessment

### Lens B: Change Governance
- **Release Discipline**: Deployment readiness assessment
- **Rollback Posture**: Rollback capability assessment
- **Audit Trail**: Traceability assessment
- **Ownership Clarity**: Responsibility mapping

### Evidence Spine Validation
- **Assumption Register**: Validated assumptions from implementation
- **Decision Rationale**: Rationale completeness verification
- **Consultation Deltas**: Oracle/Designer inputs handled in implementation
- **Validation Commands**: Test coverage and results
- **Closure Evidence Paths**: Completion evidence verification

## Implementation Steps

1. **Pre-Audit Preparation**
   - Gather implementation artifacts
   - Review consultation inputs
   - Identify audit scope
   - Prepare evidence matrix

2. **System Correctness Assessment**
   - Evaluate runtime behavior
   - Identify failure modes
   - Assess security boundaries
   - Review observability

3. **Change Governance Assessment**
   - Evaluate release discipline
   - Assess rollback posture
   - Review audit trail
   - Verify ownership clarity

4. **Evidence Spine Validation**
   - Validate assumption register
   - Verify decision rationale
   - Check consultation deltas
   - Review validation commands
   - Confirm closure evidence

5. **Requirement-by-Requirement Audit**
   - Create audit matrix
   - Assess each requirement
   - Assign PASS/PARTIAL/FAIL
   - Document evidence paths

6. **Closure Recommendation**
   - Make closure recommendation
   - Document rationale
   - Identify blockers
   - Prepare closure checklist

## Success Metrics

- Audit completion rate: 100%
- Evidence spine validation: 100%
- Requirement coverage: 100%
- Closure recommendation: 100%

## Evidence Paths

- Audit reports: W1NDF1XER/deployments/AUDIT_*
- Evidence matrices: Embedded in audit reports
- Closure checklists: Embedded in audit reports
- Requirement assessments: Embedded in audit reports

## Closure Rule

Do not close decision without:
- System Correctness assessment completed
- Change Governance assessment completed
- Evidence spine validated
- All requirements assessed
- Closure recommendation made

---
*This pattern follows Strategist's audit methodology.*
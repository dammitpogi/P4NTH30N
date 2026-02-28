# WindFixer Governance Implementation Guide

## Overview
This guide implements OpenFixer-style codebase-centric governance with Strategist audit methodology and mandatory manifest tracking for WindFixer.

## Quick Start

### 1. Before Implementation
```powershell
# Check directory structure
Get-ChildItem c:\P4NTH30N\OR4CL3\assessments
Get-ChildItem c:\P4NTH30N\DE51GN3R\architectures
Get-ChildItem c:\P4NTH30N\DE51GN3R\plans
Get-ChildItem c:\P4NTH30N\W1NDF1XER\knowledge
Get-ChildItem c:\P4NTH30N\W1NDF1XER\patterns
```

### 2. During Implementation
```powershell
# Create deployment journal
$journalPath = "c:\P4NTH30N\W1NDF1XER\deployments\JOURNAL_$(Get-Date -Format 'yyyy-MM-dd')_DECISION_X.md"
Copy-Item "c:\P4NTH30N\W1NDF1XER\deployments\JOURNAL_2026-02-28_TEMPLATE.md" $journalPath

# Work in P4NTHE0N directory (majority of time)
cd c:\P4NTH30N

# Capture learnings in real-time
# Update W1NDF1XER/knowledge/ and W1NDF1XER/patterns/
```

### 3. After Implementation
```powershell
# Create Strategist audit
$auditPath = "c:\P4NTH30N\W1NDF1XER\deployments\AUDIT_DECISION_X.md"
Copy-Item "c:\P4NTH30N\W1NDF1XER\deployments\AUDIT_TEMPLATE.md" $auditPath

# Update manifest
cd c:\P4NTH30N\.windsurf\skills\windfixer-governance
.\Update-Manifest.ps1 -DecisionId "DECISION_X" -SessionContext "Implementation completed" -Summary "WindFixer implemented governance patterns" -FilesModified 5 -LinesAdded 200 -OracleApproval 95 -DesignerApproval 90 -Tone "methodical" -Theme "governance" -KeyMoment "First manifest update" -Emotion "satisfaction"
```

## Detailed Implementation Steps

### Phase 1: Startup Gates (OpenFixer Pattern)

#### 1.1 Decision Recall
```powershell
# Find relevant decisions
Get-ChildItem c:\P4NTH30N\STR4TEG15T\decisions\ -Recurse -Filter "*DECISION_*"
```

#### 1.2 Knowledgebase Preflight
```powershell
# Consult existing knowledge
Get-ChildItem c:\P4NTH30N\W1NDF1XER\knowledge\*.md
Get-ChildItem c:\P4NTH30N\W1NDF1XER\patterns\*.md
```

#### 1.3 Local Discovery
```powershell
# Explore P4NTHE0N directory
Get-ChildItem c:\P4NTH30N\ -Directory
# Focus on: H0UND/, H4ND/, C0MMON/, W4TCHD0G/, UNI7T35T/
```

#### 1.4 Web Research (if needed)
```powershell
# Use web search for external research
# Document findings in W1NDF1XER/knowledge/
```

### Phase 2: Implementation with Learning Capture

#### 2.1 Codebase-Centric Work
- Spend >80% of time in P4NTHE0N directory
- Focus on implementation, not planning
- Capture learnings in real-time

#### 2.2 Real-Time Learning Capture
```powershell
# Update knowledge base
Add-Content c:\P4NTH30N\W1NDF1XER\knowledge\LEARNING_DELTA.md "# Learning Delta`n[What was learned]"

# Update patterns
Add-Content c:\P4NTH30N\W1NDF1XER\patterns\PATTERN_X.md "# Pattern: [Name]`n[Pattern description]"
```

#### 2.3 Deployment Journal Updates
```markdown
# Update JOURNAL_YYYY-MM-DD_DECISION_X.md during implementation
## Implementation Actions
[Changes made during P4NTHE0N directory work]

## Learning Deltas Assimilated During Run
[Patterns and knowledge captured in real-time]
```

#### 2.4 Source Reference Mapping
```powershell
# Update source reference map
Add-Content c:\P4NTH30N\W1NDF1XER\knowledge\SOURCE_REFERENCE_MAP.md "### Key Files Discovered`n- [File path] - [Description]"
```

### Phase 3: Strategist Audit

#### 3.1 System Correctness Assessment
```markdown
## Lens A: System Correctness
- **Runtime Behavior**: [assessment]
- **Failure Modes**: [identified risks]
- **Security Boundaries**: [security assessment]
- **Observability**: [monitoring coverage]
```

#### 3.2 Change Governance Assessment
```markdown
## Lens B: Change Governance
- **Release Discipline**: [deployment readiness]
- **Rollback Posture**: [rollback capability]
- **Audit Trail**: [traceability assessment]
- **Ownership Clarity**: [responsibility mapping]
```

#### 3.3 Evidence Spine Validation
```markdown
## Evidence Spine Validation
- **Assumption Register**: [validated assumptions]
- **Decision Rationale**: [rationale completeness]
- **Consultation Deltas**: [Oracle/Designer inputs handled]
- **Validation Commands**: [test coverage]
- **Closure Evidence Paths**: [completion evidence]
```

#### 3.4 Requirement-by-Requirement Audit
```markdown
## Requirement-by-Requirement Audit
| Requirement | Status | Evidence Path |
|-------------|--------|---------------|
| [Req 1] | [PASS/PARTIAL/FAIL] | [evidence] |
| [Req 2] | [PASS/PARTIAL/FAIL] | [evidence] |
```

#### 3.5 Closure Recommendation
```markdown
## Closure Recommendation
**Recommendation**: [Close/Iterate/Keep HandoffReady]
**Rationale**: [justification]
**Blockers**: [any remaining issues]
```

### Phase 4: Manifest Update

#### 4.1 Round ID Generation
- Script automatically generates next RXXX ID
- Based on existing rounds in manifest

#### 4.2 Session Context Capture
- Decision ID + brief description
- Agent set to "WindFixer"

#### 4.3 Metrics Collection
```powershell
# Count files modified
$filesModified = (git diff --name-only HEAD~1 HEAD).Count

# Count lines added
$linesAdded = (git diff --numstat HEAD~1 HEAD | ForEach-Object { [int]$_.Split()[1] } | Measure-Object -Sum).Sum
```

#### 4.4 Narrative Elements
- **Tone**: urgent, methodical, careful, etc.
- **Theme**: governance, architecture, bugfix, etc.
- **KeyMoment**: breakthrough, challenge, discovery, etc.
- **Emotion**: satisfaction, frustration, relief, etc.

#### 4.5 Manifest Update
```powershell
.\Update-Manifest.ps1 -DecisionId "DECISION_X" -SessionContext "Implementation completed" -Summary "WindFixer implemented governance patterns" -FilesModified $filesModified -LinesAdded $linesAdded -OracleApproval 95 -DesignerApproval 90 -Tone "methodical" -Theme "governance" -KeyMoment "First manifest update" -Emotion "satisfaction"
```

## Oracle/Designer Documentation (Loop 1)

### Oracle Assessment Creation
```powershell
# Create assessment file
$assessmentPath = "c:\P4NTH30N\OR4CL3\assessments\$(Get-Date -Format 'yyyy-MM-dd')-DECISION_X.md"
Copy-Item "c:\P4NTH30N\OR4CL3\assessments\TEMPLATE.md" $assessmentPath

# Update YAML frontmatter
# Add thread confidence, assessment, approval score
# Use append-only thread principle
```

### Designer Architecture Creation
```powershell
# Create architecture proposal
$archPath = "c:\P4NTH30N\DE51GN3R\architectures\DECISION_X-architecture.md"
Copy-Item "c:\P4NTH30N\DE51GN3R\architectures\TEMPLATE.md" $archPath

# Create implementation plan
$planPath = "c:\P4NTH30N\DE51GN3R\plans\DECISION_X-plan.md"
Copy-Item "c:\P4NTH30N\DE51GN3R\plans\TEMPLATE.md" $planPath
```

### Manual Loop Control
- Nexus (user) manually loops consultations
- Loop until Designer has no more improvements
- Loop until Oracle has no more complaints
- WindFixer respects this manual control

## Quality Gates

### Before Implementation
- [ ] Decision recalled and understood
- [ ] Knowledgebase consulted
- [ ] Local discovery completed
- [ ] Oracle/Designer documentation created (if applicable)

### During Implementation
- [ ] Codebase-centric work in P4NTHE0N directory (>80%)
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
- Time in P4NTHE0N directory: >80%
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

## Troubleshooting

### Common Issues

#### Manifest Update Fails
```powershell
# Check manifest file exists
Test-Path c:\P4NTH30N\STR4TEG15T\memory\manifest\manifest.json

# Check permissions
Get-Acl c:\P4NTH30N\STR4TEG15T\memory\manifest\manifest.json
```

#### Directory Creation Fails
```powershell
# Create directories manually
New-Item -ItemType Directory -Path c:\P4NTH30N\OR4CL3\assessments -Force
New-Item -ItemType Directory -Path c:\P4NTH30N\DE51GN3R\architectures -Force
New-Item -ItemType Directory -Path c:\P4NTH30N\DE51GN3R\plans -Force
New-Item -ItemType Directory -Path c:\P4NTH30N\W1NDF1XER\knowledge -Force
New-Item -ItemType Directory -Path c:\P4NTH30N\W1NDF1XER\patterns -Force
```

#### Audit Template Missing
```powershell
# Recreate templates
Copy-Item c:\P4NTH30N\W1NDF1XER\deployments\AUDIT_TEMPLATE.md c:\P4NTH30N\W1NDF1XER\deployments\AUDIT_NEW.md
Copy-Item c:\P4NTH30N\W1NDF1XER\deployments\JOURNAL_2026-02-28_TEMPLATE.md c:\P4NTH30N\W1NDF1XER\deployments\JOURNAL_NEW.md
```

## Integration Points

### With Plan Mode
- Oracle/Designer documentation created during consultation simulation
- WindFixer conducts audits after implementation
- Manifest updated for every handoff

### With Existing Workflows
- Respects manual Nexus control of Loop 1
- Automates Loop 2 (OpenFixer ↔ Strategist)
- Maintains OpenFixer patterns while adding Strategist audits

### With RAG System
- All documentation created in proper directories
- Ready for RAG ingestion
- Manifest tracking for synthesis readiness

This guide ensures WindFixer operates with OpenFixer's codebase-centric governance while conducting Strategist-style audits and maintaining complete manifest tracking.
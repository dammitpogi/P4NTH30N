# REFINED FIXER DEPLOYMENT WORKFLOW
## FORGE-003: WindFixer-First with Strategist Coordination

**Version**: 1.0  
**Date**: 2026-02-18  
**Replaces**: FORGE-002 (Parallel Execution Model)

---

## OVERVIEW

This document defines the refined deployment workflow where:
1. **WindFixer** executes all P4NTH30N codebase decisions first
2. **Strategist** receives completion reports and identifies blockers
3. **OpenFixer** handles OpenCode-only tasks and constraint resolution

This sequential handoff pattern replaces the parallel execution model to ensure clear ownership and comprehensive context transfer.

---

## WORKFLOW PHASES

### Phase 1: WindFixer Execution

**Trigger**: Decision assigned and ready for implementation

**Actor**: WindFixer (WindSurf environment)

**Scope**:
- All work within `C:\P4NTH30N\` directory
- C# code implementation
- Unit tests and validation
- Documentation in `P4NTH30N/docs/`
- Scripts in `P4NTH30N/scripts/`
- Attempt OpenCode work, report blockers

**Process**:
```
1. Read decision specification
2. Implement all P4NTH30N-side components
3. Run build and tests
4. If OpenCode access needed:
   a. Attempt via available methods
   b. If blocked, document constraint
5. Generate completion report
6. Update decisions-server status
7. Submit report to Strategist
```

**Deliverables**:
- Implemented code with tests
- Build: 0 errors, 0 warnings
- Test results: All passing
- WindFixer Report (T4CT1CS/handoffs/windfixer/)

**Template**: `T4CT1CS/handoffs/WINDFIXER_REPORT_TEMPLATE.md`

---

### Phase 2: Strategist Analysis

**Trigger**: WindFixer completion report received

**Actor**: Strategist (you/Nexus)

**Responsibilities**:
- Review WindFixer implementation
- Verify build/test status
- Identify blocked tasks requiring OpenFixer
- Assess constraints for delegation
- Prepare OpenFixer Briefs

**Process**:
```
1. Receive WindFixer Report
2. Review files created/modified
3. Verify build: 0 errors
4. Verify tests: All passing
5. Identify OpenCode blockers:
   - Directory access issues
   - Environment-specific configs
   - MCP registration
   - Cross-platform integration
6. For each blocker:
   a. Assess if OpenFixer can resolve
   b. Create OpenFixer Brief
   c. Queue for OpenFixer execution
7. Update decisions-server
8. Notify OpenFixer of pending work
```

**Decision Matrix**:

| WindFixer Status | Blockers? | Strategist Action |
|------------------|-----------|-------------------|
| Complete | No | Mark decision Complete |
| Complete | Yes | Create OpenFixer Brief |
| Partial | Yes | Assess if continuation possible |
| Blocked | Critical | Escalate to Nexus |

**Deliverables**:
- Updated decision status
- OpenFixer Briefs (T4CT1CS/handoffs/pending/)
- Deployment coordination plan

**Template**: `T4CT1CS/handoffs/OPENFIXER_BRIEF_TEMPLATE.md`

---

### Phase 3: OpenFixer Delegation

**Trigger**: Strategist handoff brief received

**Actor**: OpenFixer (OpenCode environment)

**Scope**:
- OpenCode/ directory deployment
- Agent configuration updates (ARCH-002)
- Constraint resolution from WindFixer
- Environment-specific configurations
- Cross-platform integration tasks

**Process**:
```
1. Receive OpenFixer Brief from Strategist
2. Review WindFixer completion status
3. Understand decision context
4. Execute OpenCode-only tasks:
   - Deploy agent configs
   - Register MCP servers
   - Configure environment
   - Resolve constraints
5. Validate integration
6. Report completion to Strategist
7. Update decisions-server
```

**Deliverables**:
- Deployed configurations
- MCP registrations
- Integration test results
- OpenFixer Completion Report

**Report Location**: `T4CT1CS/handoffs/completed/`

---

## HANDOFF PROTOCOLS

### WindFixer → Strategist

**Trigger**: Decision completion or constraint encountered

**Format**: Structured report

**Delivery Method**:
1. Update decisions-server with status
2. Write report to T4CT1CS/handoffs/windfixer/
3. Notify Strategist (via speech log or direct)

**Required Information**:
- Decision ID
- Files created/modified
- Build/test status
- Constraints encountered
- Recommended OpenFixer actions

### Strategist → OpenFixer

**Trigger**: Blocked tasks identified

**Format**: OpenFixer Brief

**Delivery Method**:
1. Write brief to T4CT1CS/handoffs/pending/
2. Update decisions-server with delegation
3. Queue OpenFixer work

**Required Information**:
- Original decision context
- WindFixer completion status
- Specific blocked tasks
- Execution instructions
- Acceptance criteria

---

## EXAMPLE WORKFLOW

### Scenario: RAG-001 Implementation

**Day 1-5: WindFixer Execution**
```
WindFixer receives: RAG-001 (MCP-exposed RAG)
↓
Implements:
  - src/RAG/McpServer.cs
  - src/RAG/EmbeddingService.cs
  - src/RAG/FaissVectorStore.cs
  - Tests: 45/45 passing
  - Build: 0 errors
↓
Attempts OpenCode deployment:
  - Cannot access C:\Users\paulc\.config\opencode\
  - Permission boundary reached
↓
Generates Report:
  "RAG-001 Phase 1-2 complete. 
   Blocked: Agent deployment requires OpenCode access.
   Files ready: agents/rag-mcp-server.md"
↓
Submits to Strategist
```

**Day 5: Strategist Analysis**
```
Strategist receives WindFixer Report
↓
Reviews:
  - ✅ All P4NTH30N code complete
  - ✅ Tests passing
  - ✅ Blocker identified: OpenCode access
↓
Creates OpenFixer Brief:
  - Task: Deploy agent configs
  - Command: .\scripts\deploy-agents.ps1
  - Verification: toolhive list-tools
↓
Queues OpenFixer work
```

**Day 6: OpenFixer Execution**
```
OpenFixer receives Brief
↓
Executes:
  - deploy-agents.ps1 -Force
  - Registers rag-server with ToolHive
  - Validates integration
↓
Reports to Strategist:
  "RAG-001 deployment complete.
  MCP tools registered and responding."
↓
Strategist marks RAG-001: COMPLETE
```

---

## DECISION STATE TRACKING

### Status Values

| Status | Meaning | Next Action |
|--------|---------|-------------|
| Proposed | Decision created, not started | Assign to WindFixer |
| InProgress-WindFixer | WindFixer implementing | Await completion report |
| InProgress-OpenFixer | OpenFixer handling blockers | Await completion |
| Review-Strategist | Strategist analyzing handoff | Create OpenFixer Brief |
| Complete | Both Fixers finished | Archive |
| Blocked | Unresolvable constraint | Escalate to Nexus |

### State Transitions

```
Proposed
  ↓ (assign)
InProgress-WindFixer
  ↓ (report)
Review-Strategist
  ├── No blockers → Complete
  └── Blockers identified
        ↓ (delegate)
  InProgress-OpenFixer
        ↓ (report)
  Complete
```

---

## BENEFITS OF SEQUENTIAL MODEL

### Over Parallel Model (FORGE-002)

| Aspect | Parallel (Old) | Sequential (New) |
|--------|---------------|------------------|
| **Ownership** | Unclear who does what | Clear: WindFixer→OpenFixer |
| **Context** | Risk of losing context | Comprehensive handoff docs |
| **Conflicts** | Potential duplicate effort | No overlap |
| **Debugging** | Hard to trace issues | Clear responsibility chain |
| **Coordination** | Complex synchronization | Simple handoff points |

### Key Advantages

1. **Clear Boundaries**: WindFixer owns P4NTH30N, OpenFixer owns OpenCode
2. **Preserved Context**: Handoff templates ensure nothing lost
3. **Easier Debugging**: Know exactly which Fixer touched what
4. **Better Accountability**: Clear responsibility at each phase
5. **Simpler Tracking**: Sequential state machine vs parallel coordination

---

## EXCEPTION HANDLING

### When WindFixer Cannot Complete

**Scenario**: WindFixer encounters technical blocker in P4NTH30N

**Options**:
1. **Re-delegate to WindFixer**: If fix is P4NTH30N-side
2. **Escalate to Nexus**: If architectural decision needed
3. **Modify decision scope**: If condition cannot be met

### When OpenFixer Cannot Complete

**Scenario**: OpenFixer cannot resolve WindFixer constraint

**Options**:
1. **Return to WindFixer**: If workaround exists
2. **Re-delegate to OpenFixer**: With modified approach
3. **Escalate to Nexus**: If fundamental blocker

### Escalation Criteria

Escalate to Nexus when:
- Both Fixers cannot proceed
- Architectural change required
- Decision scope needs modification
- Oracle/Designer re-consultation needed

---

## FILE LOCATIONS

### Handoff Directory Structure

```
T4CT1CS/handoffs/
├── windfixer/           # WindFixer completion reports
│   ├── RAG-001-20260218.md
│   └── ARCH-003-20260218.md
├── pending/             # OpenFixer briefs (awaiting)
│   ├── OFB-RAG-001-001.md
│   └── OFB-ARCH-002-001.md
├── completed/           # OpenFixer completion reports
│   └── OPENFIXER-RAG-001-20260219.md
├── blocked/             # Blocked decisions (escalated)
│   └── BLOCKED-TECH-003-20260218.md
└── templates/           # Templates for consistency
    ├── WINDFIXER_REPORT_TEMPLATE.md
    └── OPENFIXER_BRIEF_TEMPLATE.md
```

---

## SUCCESS METRICS

### Workflow Efficiency

| Metric | Target | Measurement |
|--------|--------|-------------|
| WindFixer→Strategist handoff time | <1 hour | Timestamp analysis |
| Strategist→OpenFixer handoff time | <4 hours | Brief creation time |
| Context completeness | 100% | Required fields in reports |
| Re-work rate | <5% | Decisions bounced back |
| Escalation rate | <10% | Nexus interventions |

### Decision Velocity

| Phase | Target Duration | Count |
|-------|----------------|-------|
| WindFixer execution | 3-5 days | Per decision |
| Strategist analysis | <4 hours | Per handoff |
| OpenFixer execution | 1-2 days | Per brief |

---

## IMPLEMENTATION CHECKLIST

### For New Decisions

- [ ] Decision created with clear P4NTH30N/OpenCode split
- [ ] WindFixer assigned and begins execution
- [ ] WindFixer report template reviewed
- [ ] Strategist monitoring plan in place
- [ ] OpenFixer brief template ready

### For Ongoing Decisions

- [ ] Current in-progress decisions assessed
- [ ] WindFixer reports generated for completed work
- [ ] Blockers identified and documented
- [ ] OpenFixer briefs created for blocked tasks
- [ ] Decisions-server updated with new statuses

### For Completed Decisions

- [ ] Both Fixers confirmed completion
- [ ] Integration validated
- [ ] Decision marked Complete
- [ ] Handoff documents archived
- [ ] Lessons learned captured

---

## VERSION HISTORY

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-02-18 | Initial FORGE-003 | Strategist |
| 0.9 | 2026-02-18 | FORGE-002 parallel model | Strategist |

---

## REFERENCES

- FORGE-002: Original parallel Fixer deployment
- FORGE-003: This document (sequential workflow)
- ARCH-002: Config deployment pipeline
- T4CT1CS/handoffs/WINDFIXER_REPORT_TEMPLATE.md
- T4CT1CS/handoffs/OPENFIXER_BRIEF_TEMPLATE.md

---

**This workflow is effective immediately for all new decisions.**

**Existing in-progress decisions should transition to this model upon next handoff.**

# Parallel Agent Delegation Guide
## STRATEGY-009 Phase 1 - Batch Delegation Patterns

**Decision ID**: STRATEGY-009  
**Phase**: 1 (WindFixer - Documentation)  
**Status**: Complete

---

## Purpose

P4NTH30N uses multiple specialized agents (H0UND, H4ND, WindFixer, OpenFixer, Strategist, Oracle, Designer). This guide documents patterns for delegating work to multiple agents in parallel to maximize throughput within session limits.

---

## Delegation Architecture

### Agent Capabilities Matrix

| Agent | Environment | Strengths | Constraints |
|-------|-------------|-----------|-------------|
| **WindFixer** | WindSurf (C:\P4NTH30N) | C# implementation, solution builds, file creation | Cannot access OpenCode env |
| **OpenFixer** | OpenCode (~/.config/opencode) | Agent configs, MCP registration, deployment | Cannot modify P4NTH30N codebase directly |
| **Strategist** | Any | Decision creation, planning, prioritization | No implementation |
| **Oracle** | Any | Risk assessment, condition enforcement | No implementation |
| **Designer** | Any | Architecture review, pattern design | No implementation |
| **Explorer** | Any | Codebase discovery, context gathering | Read-only |

### Parallel Delegation Rules

1. **Independent tasks**: Can be delegated to different agents simultaneously
2. **Dependent tasks**: Must be sequenced (use handoff reports)
3. **Cross-environment tasks**: Split into WindFixer + OpenFixer portions
4. **Session budget**: Each agent session has ~30 turns max

---

## Batch Delegation Patterns

### Pattern 1: Parallel Independent Tasks

**When**: Multiple decisions have no dependencies on each other.

```
SESSION PLAN:
├── WindFixer Session 1: [ARCH-003, SWE-002]  (independent)
├── OpenFixer Session 1: [DEPLOY-002, DEPLOY-003]  (independent)
└── Merge: Strategist reconciles outputs
```

**Template**:
```markdown
## Parallel Delegation Batch

### WindFixer Tasks (Session 1)
- [ ] DECISION-A: [description] → files: [list]
- [ ] DECISION-B: [description] → files: [list]
Constraint: No dependency between A and B

### OpenFixer Tasks (Session 1)
- [ ] DECISION-C: [description] → configs: [list]
- [ ] DECISION-D: [description] → deployments: [list]
Constraint: No dependency between C and D

### Merge Point
After both sessions complete:
- Strategist reviews handoff reports
- Verify no conflicts between outputs
- Update decision statuses
```

### Pattern 2: Pipeline Delegation

**When**: Tasks have sequential dependencies across agents.

```
PIPELINE:
Explorer → Designer → WindFixer → OpenFixer → Strategist
  discover   design    implement    deploy     validate
```

**Template**:
```markdown
## Pipeline Delegation

### Stage 1: Discovery (Explorer)
Task: Explore codebase for [feature] context
Output: Discovery report → T4CT1CS/intel/

### Stage 2: Design (Designer)
Input: Discovery report
Task: Architecture proposal for [feature]
Output: Design doc → T4CT1CS/consultations/designer/

### Stage 3: Implementation (WindFixer)
Input: Design doc + discovery report
Task: Implement [feature] in P4NTH30N
Output: Code + handoff report → T4CT1CS/handoffs/windfixer/

### Stage 4: Deployment (OpenFixer)
Input: WindFixer handoff report
Task: Deploy configs, register MCP tools
Output: Deployment report → T4CT1CS/handoffs/openfixer/

### Stage 5: Validation (Strategist)
Input: All reports
Task: Verify decision complete, update status
```

### Pattern 3: Fan-Out / Fan-In

**When**: One decision needs input from multiple agents before proceeding.

```
              ┌─ Designer (architecture review)
Strategist ───┼─ Oracle (risk assessment)
              └─ Explorer (codebase discovery)
                         │
                    Strategist (synthesize)
                         │
                    WindFixer (implement)
```

**Template**:
```markdown
## Fan-Out Consultation

### Decision: [ID]
### Parallel Consultations Required:
1. **Designer**: Rate architecture proposal (score/100)
2. **Oracle**: Assess risk and conditions (score/100, conditions list)
3. **Explorer**: Discover implementation context (file list, patterns)

### Synthesis Criteria:
- Designer ≥ 70/100 AND Oracle ≥ 70/100 → APPROVED
- Either < 70 → REVISE with feedback
- Both < 50 → REJECT

### Post-Synthesis:
Strategist creates final decision with combined input
→ Delegate to WindFixer for implementation
```

---

## Context Handoff Templates

### WindFixer → OpenFixer Handoff

```json
{
  "handoffType": "windfixer_to_openfixer",
  "decisionId": "RAG-001",
  "timestamp": "2026-02-19T04:00:00Z",
  "completedWork": {
    "files": ["src/RAG/McpServer.cs", "src/RAG/EmbeddingService.cs"],
    "buildStatus": "0 errors, 0 warnings",
    "testStatus": "all passing"
  },
  "openFixerTasks": [
    {
      "task": "Register rag-server with ToolHive MCP",
      "priority": "high",
      "files": ["agents/rag-mcp-server.md"],
      "command": "toolhive register-server rag-server"
    },
    {
      "task": "Deploy agent configs to OpenCode",
      "priority": "high",
      "command": ".\\scripts\\deploy-agents.ps1 -Force"
    }
  ],
  "blockers": [],
  "notes": "RAG Phase 1 complete. OpenFixer needs to deploy before Phase 2 can proceed."
}
```

### OpenFixer → WindFixer Handoff

```json
{
  "handoffType": "openfixer_to_windfixer",
  "decisionId": "DEPLOY-002",
  "timestamp": "2026-02-19T03:00:00Z",
  "completedWork": {
    "deployments": ["LM Studio auth disabled", "models loaded"],
    "configs": ["~/.config/opencode/mcp.json updated"]
  },
  "windFixerTasks": [
    {
      "task": "Run validation tests against LM Studio",
      "priority": "high",
      "command": "dotnet test --filter TemperatureSweep"
    }
  ],
  "unblocked": ["ARCH-003-PIVOT"]
}
```

### Strategist → Agent Batch Brief

```json
{
  "briefType": "batch_delegation",
  "sessionId": "ses_001",
  "decisions": [
    {"id": "RAG-001", "assignee": "WindFixer", "priority": 1},
    {"id": "TEST-001", "assignee": "WindFixer", "priority": 2},
    {"id": "DEPLOY-003", "assignee": "OpenFixer", "priority": 1}
  ],
  "constraints": {
    "maxTurnsPerSession": 30,
    "maxDecisionsPerSession": 6,
    "buildMustPass": true,
    "testsMustPass": true
  },
  "reportingProtocol": "T4CT1CS/handoffs/{agent}/"
}
```

---

## Session Planning

### Optimal Session Structure (30 turns)

```
Turn  1-3:  Context loading (read AGENTS.md, decision refs, prior handoffs)
Turn  4-6:  Assessment (verify current state, run build/tests)
Turn  7-22: Implementation (bulk of the work)
Turn 23-25: Verification (build, test, format)
Turn 26-28: Documentation (handoff report, codemap update)
Turn 29-30: Commit + summary
```

### Decision Clustering for Sessions

Use `DecisionClusterManager.cs` (SWE-004) to optimize decision grouping:

```csharp
DecisionClusterManager manager = new(maxDecisionsPerCluster: 6, maxTurnsPerSession: 30);
manager.AddDecisions(allDecisions);
List<DecisionCluster> clusters = manager.BuildClusters();
SessionPlan plan = manager.CreateSessionPlan();
```

---

## Anti-Patterns

- **Circular delegation**: Agent A delegates to B who delegates back to A
- **Missing handoffs**: Completing work without creating handoff report
- **Scope creep**: Agent expanding beyond assigned decisions
- **Ignoring blockers**: Attempting blocked work instead of reporting
- **Serial where parallel**: Running independent tasks sequentially

---

**Phase 2 (OpenFixer)**: Update AGENTS.md files with parallel delegation instructions specific to each agent's capabilities.

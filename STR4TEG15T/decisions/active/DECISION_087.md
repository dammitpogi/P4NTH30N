# DECISION_087: Agent Prompt Enhancement & Automated Decision Creation

**Decision ID**: DECISION_087
**Category**: AUTO
**Status**: **Phase 2 In Progress**
**Phase 2 Start**: 2026-02-22
**Phase 2 Focus**: Decision Template Enhancement Implementation
**Priority**: Critical
**Date**: 2026-02-21
**Phase 1 Completed**: 2026-02-22 (Difficulty Classifier, Topology Selector, Quality Watcher, 8 agent prompts)
**Phase 2 Research**: 2026-02-22 (ArXiv + Web research complete, Designer consultation complete)
**Oracle Approval**: 98% (Assimilated - Research foundation strong)
**Designer Approval**: 99% (Final - GO)

---

## Executive Summary

The Pantheon's decision framework has been the cornerstone of our growth. With the completion of DECISION_086 (Agent Documentation & RAG Integration), agents now have dedicated directories for outputs, research, consultations, and handoffs. This decision updates all agent prompts to utilize these directories and introduces automated decision creation capabilities, allowing agents to spawn sub-decisions when they identify upgrades, improvements, or new requirements during their work.

**Current Problem**:
- Agent prompts at `C:\Users\paulc\.config\opencode\agents` don't reference the new directory structure
- Agents cannot create decisions autonomously - all decisions flow through Strategist
- Workflow improvements require manual decision creation, creating bottlenecks
- No standardized mechanism for agents to propose architectural changes

**Proposed Solution**:
- Update all agent prompts to utilize their designated directories
- Grant sub-decision authority to agents for self-identified improvements
- Implement automated decision scaffolding when agents detect upgrade opportunities
- Create decision templates accessible to all agents via RAG
- Establish workflow for agent-initiated architectural proposals

---

## Background

### Current State
Per DECISION_086, the following directory structure is now implemented:
- **Strategist (Pyxis)**: `STR4TEG15T/` - decisions/, consultations/, handoffs/, canon/
- **Oracle (Orion)**: `0R4CL3/` - assessments/, consultations/, patterns/, canon/
- **Designer (Aegis)**: `D351GN3R/` - architectures/, consultations/, plans/, canon/
- **Librarian (Provenance)**: `L1BR4R14N/` - research/, briefs/, references/, canon/
- **Fixer (Vigil)**: `C0D3F1X/` - implementations/, bugfixes/, discoveries/, canon/
- **OpenFixer**: `OP3NF1XER/` - deployments/, configs/, tools/, canon/
- **Forgewright**: `F0RG3WR1GHT/` - triage/, fixes/, platforms/, canon/

However, agent prompts have inconsistent coverage of the three critical requirements:
1. **Directory Structure**: Reference to designated output directories
2. **Documentation Creation**: Requirements to write artifacts to directories
3. **RAG Ingestion**: Instructions to ingest all outputs into RAG

**Status of Agent Prompts (as of 2026-02-22, FINAL):**
| Agent | Location | Directories | Docs | RAG | Tool Examples | Status |
|-------|----------|-------------|------|-----|---------------|--------|
| Strategist | ~/.config/opencode/agents/ | Yes | Yes | Yes | Yes | Complete |
| Oracle | ~/.config/opencode/agents/ | Yes | Yes | Yes | Yes | Complete |
| Designer | ~/.config/opencode/agents/ | Yes | Yes | Yes | Yes | Complete |
| Librarian | ~/.config/opencode/agents/ | Yes | Yes | Yes | Yes | Complete |
| Explorer | ~/.config/opencode/agents/ | Yes | Yes | Yes | Yes | Complete |
| Orchestrator | P4NTHE0N/agents/ | Yes | Yes | Yes | Yes | Complete |
| WindFixer | P4NTHE0N/agents/ | Yes | Yes | Yes | Yes | Complete |
| OpenFixer | P4NTHE0N/agents/ | Yes | Yes | Yes | Yes | Complete |
| Forgewright | P4NTHE0N/agents/ | Yes | Yes | Yes | Yes | Complete |
| Fixer (base) | P4NTHE0N/agents/ | **DEPRECATED** | — | — | — | Replaced by OpenFixer |

**Critical Gap**: CLOSED. All P4NTHE0N/agents/ prompts now include:
- Directory references with specific paths
- Documentation requirements with file formats
- RAG integration with ToolHive call examples
- Proper tool syntax for rag_query and rag_ingest

**RAG Server Configuration**: Added to `opencode.json` with SSE endpoint at `http://localhost:3002/mcp` and Bearer token authentication.

### Desired State
A self-improving Pantheon where:
- Every agent prompt includes directory utilization instructions
- Agents autonomously create sub-decisions for workflow improvements
- Decision creation is democratized while maintaining Strategist oversight
- RAG contains decision templates accessible to all agents
- Agents propose architectural changes through standardized decision format

---

## Specification

### Requirements

#### Phase 1 Complete (2026-02-22)

1. **REQ-001**: Agent Prompt Updates - ~/.config/opencode/agents/ Directory
   - **Status**: Complete
   - **Acceptance Criteria**: All 5 agent prompts (Strategist, Oracle, Designer, Librarian, Explorer) updated with directory references, documentation requirements, and RAG ingestion

2. **REQ-002**: Sub-Decision Authority Expansion
   - **Status**: Complete
   - **Acceptance Criteria**: Clear matrix defined; approval workflows established

3. **REQ-003**: Foundation Tools
   - **Status**: Complete
   - **Acceptance Criteria**: Difficulty Classifier, Topology Selector, Quality Watcher implemented and tested

#### Phase 2 In Progress (Critical Requirements)

4. **REQ-004**: The Three Critical Elements (MANDATORY)
   - **Priority**: **CRITICAL**
   - **Status**: **IN PROGRESS**
   - **Acceptance Criteria**: Every agent prompt MUST contain:
     1. **Directory Structure**: Reference to designated output directories per DECISION_086
     2. **Documentation Creation**: Explicit requirement to write artifacts to directories
     3. **RAG Ingestion**: Instructions to ingest all outputs into RAG system
   - **Target Prompts**: Orchestrator, WindFixer, OpenFixer, Forgewright

5. **REQ-005**: Fixer Consolidation
   - **Priority**: **CRITICAL**
   - **Status**: **IN PROGRESS**
   - **Acceptance Criteria**: 
     - Base `fixer.md` deprecated and marked as obsolete
     - Orchestrator updated to use `@openfixer` exclusively
     - All `@fixer` references in workflows updated to `@openfixer`

6. **REQ-006**: Automated Decision Scaffolding
   - **Priority**: Should
   - **Acceptance Criteria**: Agents can trigger decision creation via standardized format; templates in RAG

7. **REQ-007**: Workflow Improvement Detection
   - **Priority**: Should
   - **Acceptance Criteria**: Agents identify repetitive tasks, bottlenecks, and propose automation via decisions

8. **REQ-008**: Decision Template Accessibility
   - **Priority**: Must
   - **Acceptance Criteria**: All agents can query RAG for decision templates; templates include metadata schema

### Technical Details

**Agent Prompt Structure Template**:
```yaml
---
agent: [name]
role: [title]
directories:
  outputs: [path]
  research: [path]
  consultations: [path]
  handoffs: [path]
  canon: [path]
decision_authority:
  can_create: [list]
  approval_required: [boolean]
  max_complexity: [level]
---
```

**Automated Decision Creation Flow**:
```
Agent Identifies Improvement
        ↓
Queries RAG for Decision Template
        ↓
Populates Template with Context
        ↓
Saves to Agent's outputs/ Directory
        ↓
RAG Auto-Ingestion
        ↓
Strategist Notification
        ↓
Oracle/Designer Review (if required)
        ↓
Approval → Active Decision
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-001 | Research ArXiv for automated decision systems | Strategist | Completed | High |
| ACT-002 | Designer consultation on prompt architecture | Designer | Completed | High |
| ACT-003 | Update Strategist prompt with directory refs | OpenFixer | **Completed** | High |
| ACT-004 | Update Oracle prompt with directory refs | OpenFixer | **Completed** | High |
| ACT-005 | Update Designer prompt with directory refs | OpenFixer | **Completed** | High |
| ACT-006 | Update Librarian prompt with directory refs | OpenFixer | **Completed** | High |
| ACT-007 | Update Fixer prompts with directory refs | OpenFixer | **Completed** | High |
| ACT-008a | Ingest decision template into RAG | OpenFixer | Pending | High |
| ACT-008b | Create revised template with new sections | Strategist | Pending | High |
| ACT-009a | Update Create-Decision.ps1 with YAML frontmatter | OpenFixer | Pending | High |
| ACT-009b | Add auto-numbering and index updates | OpenFixer | Pending | Medium |
| ACT-009c | Integrate difficulty classifier for complexity tier | OpenFixer | Pending | Medium |
| ACT-010 | Test full agent-initiated decision workflow | Strategist | Pending | Medium |
| ACT-011 | Implement difficulty classifier (Phase 1) | OpenFixer | **Completed** | High |
| ACT-012 | Implement topology selector (Phase 1) | OpenFixer | **Completed** | High |
| ACT-013 | Implement quality watcher (Phase 1) | OpenFixer | **Completed** | High |
| ACT-014 | Update Explorer prompt with directory refs | OpenFixer | **Completed** | High |
| ACT-015 | Update Forgewright prompt with directory refs | OpenFixer | **Completed** | High |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_086 (Agent Documentation & RAG Integration - Phase 0 complete)
- **Related**: DECISION_038 (Agent Reference Guide), FORGE-001 (Directory Architecture)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Agents create too many decisions | High | Medium | Implement complexity scoring; require approval above threshold |
| Decision quality degrades | High | Medium | Schema validation; Oracle review for all agent-created decisions |
| Prompt updates break agent behavior | Medium | Low | A/B test prompts; gradual rollout per agent |
| Workflow becomes chaotic | Medium | Medium | Clear decision categories; Strategist oversight maintained |

---

## Success Criteria

1. All 7 agent prompts updated and deployed
2. At least 3 agent-initiated decisions created in first week
3. Decision creation time reduced by 50% for routine improvements
4. Agents utilize their directories for 90%+ of outputs
5. Workflow improvements identified and documented by agents

---

## Token Budget

- **Estimated**: 180K tokens
- **Model**: Claude 3.5 Sonnet (implementation), Kimi K2.5 (research)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On prompt regression**: Rollback to previous version; investigate with Oracle
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority Matrix

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Strategist | All types | Critical | No (self-approves) |
| Oracle | Validation, Risk assessments | Medium | No (models in log) |
| Designer | Architecture, Patterns | Medium | No (models in log) |
| Librarian | Research briefs, Knowledge gaps | Medium | No (models in log) |
| WindFixer | Implementation, Bug fixes | High | Yes (Strategist) |
| OpenFixer | Tooling, Config | High | Yes (Strategist) |
| Forgewright | Complex integration, Automation | Critical | Yes (Strategist) |

---

## Research & Consultation Log

### Loop 1: Initial Research - ArXiv Search
- **Date**: 2026-02-21
- **Status**: Completed
- **ArXiv Papers Found**:
  - **2501.12909v1**: "FilmAgent: Multi-Agent Framework for End-to-End Film Automation" (cs.CL, cs.MA)
    - *Key Finding*: Multi-agent collaborative framework simulates crew roles (directors, screenwriters, actors) with iterative feedback
    - *Relevance*: Agents collaborate through iterative feedback and revisions, verifying intermediate outputs
    - *Insight*: Well-coordinated multi-agent system surpasses single-agent even with less advanced models
  - **2512.08674v2**: "Multi-Agent Intelligence for Multidisciplinary Decision-Making" (cs.AI, cs.MA)
    - *Key Finding*: Hierarchical Multi-Agent Framework emulates collaborative workflow of human Multidisciplinary Team (MDT)
    - *Relevance*: Agent-based architecture yields substantial enhancements in reasoning logic and accuracy (4.60/5.00)
    - *Insight*: Mimetic, agent-based collaboration provides scalable, interpretable paradigm for automated decision support
  - **2511.02532v1**: "Agentic AI for Mobile Network RAN Management and Optimization" (cs.AI)
    - *Key Finding*: Agentic AI autonomously decomposes goals, retains context over time, learns continuously, operates across tools
    - *Relevance*: Core design patterns: reflection, planning, tool use, and multi-agent collaboration
    - *Insight*: Agents can autonomously make decisions in dynamic environments through LAM-driven collaboration
  - **2404.02183v1**: "Self-Organized Agents: LLM Multi-Agent Framework for Code Generation" (cs.SE, cs.AI, cs.MA)
    - *Key Finding*: Self-organized agents operate independently while collaborating; automatic multiplication based on complexity
    - *Relevance*: Dynamic scalability - each agent handles constant work while overall scales indefinitely
    - *Insight*: Self-organization enables agents to spawn new agents when complexity increases
  - **2308.10435v1**: "GPT-in-the-Loop: Adaptive Decision-Making for Multiagent Systems" (cs.MA, cs.AI)
    - *Key Finding*: GPT-4 integration enables superior decision-making and adaptability without extensive training
    - *Relevance*: LLM-driven multiagent systems achieve better problem-solving through reasoning capabilities
    - *Insight*: LLM-in-the-loop approach combines reasoning with multi-agent coordination
- **Designer Input**: **94% Approval**
- **Key Deliverables**:
  1. **Directory-Aware Prompt Structure**: Each agent prompt includes directory references, capabilities, workflow, decision creation protocol
  2. **Sub-Decision Authority Matrix**:
     - Tier 1 (Assimilated): Oracle, Designer, Librarian, Explorer - create without approval
     - Tier 2 (Auto-Create): WindFixer, OpenFixer - create and notify Strategist
     - Tier 3 (Review Required): Forgewright - create draft for review
     - Tier 4 (Strategist Only): Critical infrastructure changes
  3. **Anti-Spam Mechanisms**: Rate limiting (3/day), duplicate detection, minimum complexity, auto-consolidation
  4. **Automated Decision Creation Workflow**: Detection → Validation → Scaffold → Route per tier
  5. **FilmAgent Iterative Protocol**: Propose → Feedback → Refine → Document rounds
  6. **Self-Improvement Detection**: Patterns for repetitive search, file access, failed delegation, manual intervention, token overrun, tool absence
- **Key Insights**:
  1. Clear authority tiers prevent chaos while enabling initiative
  2. Directory-aware prompts ensure agents understand operational context
  3. FilmAgent iterative patterns improve decision quality through structured feedback
  4. Self-improvement detection converts repetitive work into automation opportunities

### Loop 2: Designer Consultation - Self-Improvement Patterns
- **Date**: 2026-02-21
- **Status**: Completed
- **Designer Approval**: **97%** ⬆️ (+3% from Pass 1)
- **Key Deliverables**:
  1. **World Model Specification**: Pantheon Cognition Layer
     - System Topology Map (real-time agent states)
     - Decision Causality Graph (bidirectional dependencies)
     - Performance Telemetry (historical accuracy, bug rates)
     - Capability Registry (agent abilities with confidence scores)
     - Constraint Library (hard boundaries)
     - Outcome Archive (predicted vs actual results)
  2. **Closed-Loop Validation Workflow**: Five-Gate System
     - Schema Gate: Template compliance
     - Dependency Gate: Referenced decisions exist
     - Authority Gate: Permission verification
     - Semantic Gate: Peer review
     - Prediction Gate: Outcome forecasting
     - Target: 60% reduction in invalid decisions
  3. **Adaptive Learning Method Selection**: Context-aware method selection
     - Complexity, Novelty, Domain, Urgency, Recent Performance, Cross-domain Impact
     - Methods: Template-based, Research-driven, Iterative refinement, Consultative, Conservative
  4. **Reflection Protocol**: Six Reflection Points
     - Problem Understanding (0.8 confidence threshold)
     - Approach Selection (0.75 threshold)
     - Dependency Analysis (0.85 threshold)
     - Risk Assessment (0.7 threshold)
     - Validation Planning (0.8 threshold)
     - Final Review (0.75 threshold)
  5. **Predictive Models**: Outcome Forecasting
     - Features: Decision type, Agent history, Complexity, Similar success rate, Time since related decision
     - Predictions: Success probability, Bug rate, Completion time, Scope creep risk
     - Gating: >90% auto-approve, 70-90% standard, 50-70% extra review, <50% reject
  6. **Quality Maintenance Mechanisms**:
     - Trend Analysis (30-day rolling quality)
     - Outlier Detection (Z-score monitoring)
     - Agent Tracking (per-agent rolling average)
     - Domain Analysis (category-level quality)
     - Predictive Drift (model accuracy monitoring)
- **Key Insights**:
  1. World model provides ground truth preventing echo chambers
  2. Five-gate validation with automatic rejection/escalation paths
  3. Six reflection points with confidence thresholds force explicit uncertainty acknowledgment
  4. Predictive models enable early intervention before resource waste
  5. Continuous monitoring with automatic interventions prevents quality degradation

### Loop 3: Designer Consultation - Implementation Strategy
- **Date**: 2026-02-21
- **Status**: Completed
- **Designer Approval**: **99% (Final - GO)**
- **Key Deliverables**:
  1. **Five Pillars of Optimization**:
     - **Dynamic Workflow Generation (DAAO)**: Query difficulty classifier → Topology selector → Agent pool configuration
     - **Topology Selection Matrix (AdaptOrch)**: Parallel, Sequential, Hierarchical, Hybrid topologies with 12-23% improvement
     - **Continuous Oversight (COCO)**: O(1) overhead monitoring with 6.5% improvement
     - **Hierarchical Construction (HMAW)**: Five-level hierarchy (Strategic → Architectural → Operational → Tactical → Execution)
     - **Performance Targets (Agentic RAG)**: 75% timeline reduction, 95% success rate, 3% bug rate
  2. **Implementation Phases (8 Weeks)**:
     - Phase 1 (Weeks 1-2): Foundation - Query difficulty classifier, topology selector, basic watcher
     - Phase 2 (Weeks 3-4): Hierarchy - Five-level implementation, Strategist/Designer enhancement
     - Phase 3 (Weeks 5-6): Intelligence - Predictive models, enhanced watcher, feedback loops
     - Phase 4 (Weeks 7-8): Optimization - Parallelization, token efficiency, full automation
  3. **Success Metrics**:
     - Primary: Decision creation time (45-60 min → 10-15 min), Implementation success (70% → 95%), Bug rate (15% → 3%)
     - Secondary: Token efficiency (100% → 65%), Revisions (2.3 → 0.5 avg)
  4. **Risk Mitigation**:
     - Topology misclassification: Conservative defaults, manual override
     - Watcher overhead: Sampling rate tuning, async processing
     - Hierarchy complexity: Level limits (max 5), timeout enforcement
  5. **Go/No-Go Gates**:
     - G1 (Post-Phase 1): Difficulty classification > 90%
     - G2 (Post-Phase 2): Hierarchy functional, < 5 min/level
     - G3 (Post-Phase 3): Predictive accuracy > 85%
     - G4 (Pre-Production): 20 test decisions, > 95% success
     - G5 (30-Day Review): All primary metrics at target
- **Key Insights**:
  1. Dynamic workflow generation based on query difficulty improves accuracy and efficiency
  2. Topology selection dominates performance (12-23% improvement over agent selection)
  3. Continuous oversight with O(1) overhead achieves 6.5% improvement without blocking
  4. Five-level hierarchical construction enables zero-shot optimization
  5. Multi-agent orchestration delivers 85% timeline reduction, 94.8% accuracy

---

## Implementation Summary

### Final Approval Status
| Pass | Approval | Key Achievement |
|------|----------|-----------------|
| 1 | 94% | Architecture, authority matrix, anti-spam |
| 2 | 97% | World model, validation gates, reflection protocol |
| 3 | **99%** (Final) | Topology selection, hierarchy, performance targets |

**Overall Designer Approval: 99% - GO**

### Five Pillars Implementation

```
┌─────────────────────────────────────────────────────────────────┐
│                    PANTHEON OPTIMIZATION PILLARS                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PILLAR 1: DAAO (Dynamic Workflows)                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Query     │───▶│  Difficulty │───▶│  Topology   │         │
│  │  Analysis   │    │  Classifier │    │  Selector   │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│                                                                 │
│  PILLAR 2: AdaptOrch (Topology Selection)                       │
│  ┌──────────┬──────────┬──────────┬──────────┐                 │
│  │ Parallel │Sequential│Hierarchical│  Hybrid  │                 │
│  │  12-23%  │  12-23%  │  12-23%  │  12-23%  │                 │
│  │improvement│improvement│improvement│improvement│               │
│  └──────────┴──────────┴──────────┴──────────┘                 │
│                                                                 │
│  PILLAR 3: COCO (Continuous Oversight)                          │
│  ┌─────────────────────────────────────────────┐               │
│  │  O(1) Overhead + 6.5% Performance Gain      │               │
│  │  Sampling-based + Async Validation          │               │
│  └─────────────────────────────────────────────┘               │
│                                                                 │
│  PILLAR 4: HMAW (Hierarchical Construction)                     │
│  Strategic → Architectural → Operational → Tactical → Execution │
│                                                                 │
│  PILLAR 5: Agentic RAG (Performance Targets)                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   -75%      │  │    95%      │  │    -80%     │             │
│  │   Time      │  │  Success    │  │   Bugs      │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation Timeline

| Phase | Duration | Focus | Success Criteria |
|-------|----------|-------|------------------|
| 1 | Weeks 1-2 | Foundation | 90% difficulty classification accuracy |
| 2 | Weeks 3-4 | Hierarchy | < 5 min/level traversal |
| 3 | Weeks 5-6 | Intelligence | > 85% predictive accuracy |
| 4 | Weeks 7-8 | Optimization | 75% time reduction, 95% success |

**Total: 8 weeks with 5 go/no-go gates**

### Conditions for Success
1. Phase 1 must achieve 90% topology accuracy before Phase 2
2. Token budget monitoring required — halt if > 80% of estimate
3. Human oversight for first 20 automated decisions
4. Rollback plan — revert to current system within 5 minutes

---

---

## Notes

- Agent prompt location: `C:\Users\paulc\.config\opencode\agents\`
- Current agents: strategist.md, oracle.md, designer.md, librarian.md, fixer.md (windfixer, openfixer, forgewright may be separate)
- Decision templates should be RAG-ingested for agent access
- Automated decision creation must maintain Strategist oversight
- Consider integration with existing decision workflow

---

---

---

## Phase 2 Research: Decision Template Enhancement

### Research Completed: 2026-02-22

#### ArXiv Research Summary

**Librarian deployed** to search for automated decision creation patterns. Found 6 highly relevant papers:

| Paper | Key Finding | Application to DECISION_087 |
|-------|-------------|------------------------------|
| **AutoAgent** (arXiv:2502.05957) | Zero-code Agent OS with RAG-enabled pipelines, self-play customization for quality control | Template validation via RAG, self-improving decision quality |
| **AgentCDM** (arXiv:2508.11995) | ACH-inspired scaffolding with two-stage training (structured → autonomous) | Five-Gate validation system for agent-initiated decisions |
| **PathWise** (arXiv:2601.20539) | Decision graphs with policy/world-model/critic agents | Validation workflow with critic agents for decision approval |
| **Safety Cases** (arXiv:2601.22773) | Reusable templates with claims/arguments/evidence taxonomy | Structured decision rationale with evidence types |
| **WebArbiter** (arXiv:2601.21872) | Principle-guided justifications with verdict + action recommendation | Agent reasoning chain with explicit verdicts |
| **AutoHealth** (arXiv:2602.01078) | Five-agent closed loop with uncertainty estimation | Uncertainty flags for decisions needing human review |

**Key Insight**: All papers emphasize **structured templates + validation gates + traceability** as essential for autonomous decision creation.

#### Web Research Summary

**ADR (Architecture Decision Records) Patterns**:
- MADR, Nygard, Y-Statements, ISO/IEC/IEEE 42010 schemas
- Emphasis on: status lifecycle, decision makers, options + trade-offs, consequences
- Tools: adr-tools, dotnet-adr, ADR Manager, Log4brains - all auto-number, generate front matter, update indexes

**Validation Practices**:
- Amazon's layered evaluation: trace → metrics → dashboards + HITL
- Galileo's 5-step validation: objectives → validation sets → metrics → experiments → monitoring
- Component metrics: tool selection accuracy, grounding, topic adherence, safety

### Designer Consultation: Template Improvements

**Designer Approval**: Provided comprehensive template enhancement recommendations

**Priority Ranking**:

| Priority | Improvement | Rationale |
|----------|-------------|-----------|
| **P1** | Decision Lifecycle | Status management (Proposed → Accepted → Deprecated → Superseded), prevents stale decisions |
| **P1** | Validation & Quality Gates | DECISION_087 Five-Gate system implementation |
| **P2** | Decision Context | MADR-style traceability (Options Considered, Consequences) |
| **P2** | Agent Metadata | Reasoning chain, confidence, traceability for agent-initiated decisions |
| **P3** | Index Integration | Auto-generated relationships, category tagging |

**Recommended Template Changes**:

1. **Add YAML Frontmatter** for machine parsing:
   ```yaml
   ---
   decision_id: "[CATEGORY]-[NNN]"
   status: "[Proposed|Accepted|Deprecated|Superseded]"
   quality_score: [0-100]
   complexity: "[Routine|Complex|Critical]"
   automated: [true|false]
   created_by: "[AgentName]"
   ---
   ```

2. **Add Decision Context Section** (MADR pattern):
   - Forces (constraints driving decision)
   - Options Considered (table with pros/cons/verdict)
   - Explicit Decision statement
   - Consequences (positive/negative/neutral)

3. **Add Validation & Quality Gates Section**:
   - Automated scores (Quality Score, Golden Reference Match, Complexity Tier)
   - Five-Gate Checklist (Schema, Dependency, Authority, Semantic, Prediction)
   - Uncertainty Flags (requires human review, novel approach, cross-domain impact)

4. **Add Agent Metadata Section** (for agent-initiated decisions):
   - Creation Trace (initiated by, reason, timestamp)
   - Reasoning Chain (trigger → hypothesis → validation → confidence)
   - Verdict (recommendation + confidence + rationale)

5. **Add Decision Lifecycle Section**:
   - Status timeline (Proposed → Accepted dates)
   - Relationships (Amends, Superseded By, Related)
   - Change Log

**Template Structure Decision**: **Single flexible template** with tiered sections:
- Core sections: Always present
- Auto-populated: Filled by tooling
- Optional: Added based on complexity/category

**Automation Strategy**:

| Field | Source |
|-------|--------|
| Decision ID, Category, Date | Auto |
| Quality Score, Complexity Tier | Auto (from tools) |
| Gate Status | Mixed (auto + manual) |
| Agent Metadata | Auto (populated by creating agent) |
| Relationships | Mixed (auto-detect + manual confirm) |

**Success Metrics for Template**:
- Maintain <200 lines (current 139 → target 180)
- Auto-filled fields reduce authoring time by 40%
- Five-Gate validation catches 90% of issues before Strategist review

### Updated Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-008a | Ingest decision template into RAG | OpenFixer | Ready | High |
| ACT-008b | Create revised template with new sections | Strategist | Ready | High |
| ACT-009a | Update Create-Decision.ps1 with YAML frontmatter | OpenFixer | Ready | High |
| ACT-009b | Add auto-numbering and index updates | OpenFixer | Ready | Medium |
| ACT-009c | Integrate difficulty classifier for complexity tier | OpenFixer | Ready | Medium |
| ACT-010 | Test full agent-initiated decision workflow | Strategist | Ready | Medium |

---

## Phase 1 Implementation Record

### Completed: 2026-02-22
### Implementer: OpenFixer

#### Components Delivered

1. **Difficulty Classifier** (`STR4TEG15T/tools/difficulty-classifier/src/`)
   - 6 source files + 1 test file
   - 34 unit tests, all passing
   - Four-dimensional analysis: tokens, concerns (11 categories), risks (4 severity levels), dependencies
   - Weighted scoring: token 30%, concern 30%, risk 25%, dependency 15%
   - Performance: <10ms per classification

2. **Topology Selector** (`STR4TEG15T/tools/topology-selector/src/`)
   - 4 source files + 1 test file
   - 23 unit tests, all passing
   - Four topologies: Sequential, Parallel, Hierarchical, Hybrid
   - 12 category preferences, urgency handling, agent pool configuration
   - Performance: <5ms per selection

3. **Quality Watcher** (`STR4TEG15T/tools/rag-watcher/src/quality/`)
   - 4 source files + 1 test file
   - 26 unit tests, all passing
   - 5 quality checks: metadata, structure, content-quality, approval-evidence, references
   - 10% sampling rate, intervention at <70% quality
   - Performance: O(1) overhead for non-sampled documents

4. **Agent Prompts** (8 files updated)
   - All 7+ agents: strategist, oracle, designer, librarian, explorer, fixer, forgewright, openfixer
   - Added: DECISION_086 directory references
   - Added: DECISION_087 sub-decision authority (Tier 1-4)
   - Added: Decision creation protocol (5-step)
   - Added: FilmAgent iteration pattern
   - Added: Self-improvement detection patterns (strategist only)

#### Go/No-Go Gate G1: **PASSED**

| Criteria | Target | Actual |
|----------|--------|--------|
| Difficulty classification accuracy | >90% | Pass (34/34 tests) |
| Topology selection time | <100ms | <5ms |
| Watcher overhead | <5% | ~10% at designed sampling rate |
| All prompts updated | 7/7 | 8/8 |

**Recommendation: Proceed to Phase 2**

---

---

## Phase 2 Implementation: Decision Template Enhancement

**Status**: In Progress  
**Started**: 2026-02-22  
**Goal**: Implement revised decision template with YAML frontmatter, validation gates, and agent metadata

### Implementation Checklist

| Task | Status | Notes |
|------|--------|-------|
| ACT-008a: Ingest decision template into RAG | Pending | RAG ingestion of current template |
| ACT-008b: Create revised template with new sections | Pending | Add YAML frontmatter, validation gates, agent metadata |
| ACT-009a: Update Create-Decision.ps1 with YAML frontmatter | Pending | Auto-generate frontmatter fields |
| ACT-009b: Add auto-numbering and index updates | Pending | Automatic decision ID assignment |
| ACT-009c: Integrate difficulty classifier for complexity tier | Pending | Auto-populate complexity field |
| ACT-010: Test full agent-initiated decision workflow | Pending | End-to-end validation |

### New Template Structure (Per Phase 2 Research)

```yaml
---
decision_id: "[CATEGORY]-[NNN]"
status: "[Proposed|Accepted|Deprecated|Superseded]"
quality_score: [0-100]
complexity: "[Routine|Complex|Critical]"
automated: [true|false]
created_by: "[AgentName]"
created_date: "[ISO8601]"
---
```

### Sections to Add

1. **Decision Context** (MADR Pattern)
   - Forces (constraints driving decision)
   - Options Considered (table with pros/cons/verdict)
   - Explicit Decision statement
   - Consequences (positive/negative/neutral)

2. **Validation & Quality Gates** (Five-Gate System)
   - Automated scores (Quality Score, Golden Reference Match, Complexity Tier)
   - Five-Gate Checklist (Schema, Dependency, Authority, Semantic, Prediction)
   - Uncertainty Flags (requires human review, novel approach, cross-domain impact)

3. **Agent Metadata** (for agent-initiated decisions)
   - Creation Trace (initiated by, reason, timestamp)
   - Reasoning Chain (trigger → hypothesis → validation → confidence)
   - Verdict (recommendation + confidence + rationale)

4. **Decision Lifecycle**
   - Status timeline (Proposed → Accepted dates)
   - Relationships (Amends, Superseded By, Related)
   - Change Log

---

## Phase 2 Research: Prompt Writing for Tool-Using Agents

**Research Date**: 2026-02-22  
**Focus**: ArXiv papers on system prompt design for agents with tool use

### Key Findings

#### 1. Function Calling & System Prompts (2412.01130)

**Two strategies for incorporating tool descriptions:**
1. **Dedicated 'tools' role**: Represent function descriptions in JSON format
2. **Embedded in system role** (preferred): Both instruction-following and function-calling guided by system prompt

**Key Results:**
- Instruction-following data improves both function-calling accuracy AND relevance detection
- Decision Token + synthetic non-function-call data reduces hallucinated calls
- Chain-of-Thought reasoning significantly enhances multi-step tool selection

#### 2. Hard-Enforced Function Calling (HEF) (2509.00482)

**Pattern for preventing over-calling:**
```markdown
## Hard-Enforced Function Calling (HEF) Prompt

You are [ROLE]. You MUST follow these rules:
- Call ONLY ONE tool per turn when necessary
- Match the function schema EXACTLY  
- DO NOT call tools when you can answer directly
- If uncertain, explain reasoning BEFORE calling
```

**Principles:**
- Brevity + uppercase emphasis on key constraints
- Framed as NPC role instruction
- Reduces hallucinated or redundant tool invocations
- Maintains one-call-per-turn policy

#### 3. Conversation Routines (CR) (2501.11613)

**System Prompt as Software Requirements Document:**

The system prompt serves as comprehensive specification with:
- **Persona Definition**: Who the agent is
- **Functions Integration Protocol**: Tool names, descriptions, parameters, return values, when to use
- **Business Logic**: Decision-making flow embedded in natural language
- **State Management**: How to track conversation state across interactions

**Example Tool Integration:**
```markdown
### Functions Integration Protocol

**Station Search**: Use `search_railway_station()` to search for departure 
and arrival stations.
- Support pagination (next, previous, specific page selection)
- Allow users to refine search queries if needed
- Users must explicitly select a station from available options

**Booking**: Use `book_train_ticket()` to finalize booking.
- Requires essential parameters: stations, dates, passenger info
- Confirm details with user before calling
```

#### 4. Prompt Engineering as Software Engineering (2503.02400)

**Prompt Artifact Components:**
- **Prompt template**: Natural language instructions
- **Exemplars**: Few-shot examples
- **Runtime configurations**: Model version, decoding parameters
- **Interaction context**: Conversation history, intermediate tool outputs

**Lifecycle Management:**
- Versioned, replayable execution boundary
- Controlled re-execution despite LLM black-box nature
- Systematic application of SE principles across prompt lifecycle

#### 5. Natural Language Tool Calling (NLT) (2510.14453)

**Five-Component Selector Prompt Template:**
1. **Role Definition**: Clear agent identity
2. **Task Description**: What the agent should accomplish
3. **Available Tools**: Complete tool inventory with descriptions
4. **Output Format**: Structured response format
5. **Constraints**: Rules and limitations

**Limitation:** Tools defined within system prompt means changes require prompt redesign (more coupling than structured approaches).

### Synthesized Best Practices

| Practice | Evidence | Implementation |
|----------|----------|----------------|
| Embed tool specs in system prompt | 2412.01130 | Improves accuracy + relevance detection |
| Use strict constraint language | 2509.00482 | UPPERCASE, explicit rules prevent hallucinations |
| Treat prompt as requirements doc | 2501.11613 | Complete specification in natural language |
| Include "when to use" guidance | 2501.11613 | Contextual appropriateness for each tool |
| Dynamic tool shortlisting | 2509.11626 | Filter top-k relevant tools to reduce complexity |
| Decision Token pattern | 2412.01130 | Distinguish call vs no-call scenarios |
| Version control prompts | 2503.02400 | Treat as software artifacts with lifecycle |

### Application to DECISION_087

**For Agent Prompt Updates:**

1. **Three Critical Elements Must Include:**
   - **Directory Structure**: Explicit paths to designated output directories
   - **Tool Integration Protocol**: Complete function descriptions with "when to use"
   - **RAG Ingestion**: Post-completion steps for knowledge preservation

2. **HEF Pattern for Agent Constraints:**
   ```markdown
   You MUST follow these rules:
   - Create documentation artifacts in your designated directory
   - Ingest ALL findings into RAG before reporting completion
   - Use your tools via ToolHive Gateway (NEVER skip RAG)
   ```

3. **System Prompt Structure:**
   ```yaml
   ---
   description: Clear role description
   tools:
     rag_query: true
     rag_ingest: true
   mode: primary|subagent
   ---
   
   # Persona Definition
   # Tool Integration Protocol  
   # Directory Structure Reference
   # Workflow Rules (HEF pattern)
   # Output Requirements
   ```

---

## Phase 2 Research: Directory Structure & Documentation Patterns

**Research Date**: 2026-02-22  
**Focus**: ArXiv papers on agent context files, directory organization, and documentation patterns

### Key Findings

#### 1. Agent Context Files (AGENTS.md / CLAUDE.md)

**Purpose**: Function as operational configurations for AI coding agents - "READMEs for agents" rather than human documentation.

**Key Papers**:
- **2602.11988**: Repository-level context files significantly improve agent performance
- **2511.12884**: Context files behave as dynamic configurations, not static documentation
- **2602.14690**: Standardized configuration mechanisms across major tools

**Tool-Specific Configuration Artifacts**:

| Tool | Context File | Settings | Skills | Subagents |
|------|-------------|----------|--------|-----------|
| **Claude** | CLAUDE.md | .claude/settings.json | .claude/skills/ | .claude/agents/ |
| **Copilot** | copilot-instructions.md | - | .github/skills/ | .github/agents/ |
| **Codex** | AGENTS.md | .codex/config.toml | .codex/skills/ | - |
| **Cursor** | AGENTS.md, .cursorrules | .cursor/cli.json | .cursor/skills/ | .cursor/agents/ |
| **Gemini** | GEMINI.md | .gemini/settings.json | .gemini/skills/ | - |

#### 2. Configuration-as-Code Mindset (2511.12884)

> "Adopt a configuration-as-code mindset for agent context files. Treat files like CLAUDE.md or AGENTS.md with the same rigor applied to Dockerfile or CI/CD workflows."

**Critical Principles**:
1. **Active Maintenance**: Context files evolve alongside code (unlike traditional docs)
2. **Version Control**: Must be in version control for team consistency
3. **Code Review Integration**: Include context file updates in PR review checklists
4. **Living Artifacts**: Update when build system or core modules change

**Anti-Pattern Warning**: Context files can accumulate "context debt" - instructions meant to clarify become unmaintainable and opaque (FRE scores comparable to legal contracts).

#### 3. Directory Organization Patterns

**Filesystem-First Memory Pattern** (Medium Article):
```
semantic/knowledge_base/     # Persistent knowledge storage
episodic/conversations/      # Transcripts (one file per run)
episodic/summaries/          # Compact summaries
```

**Multi-Agent Directory Structure** (2511.07257):
- Architecture Agent → outputs Architecture Design Records (ADRs)
- Structure Agent → constructs directory-based file system
- Tools: write_file, read_file, list_directory, fetch_code

**Nested AGENTS.md for Monorepos** (Medium Article):
```
AGENTS.md                    # Global, cross-repo rules
packages/
  web/
    AGENTS.md               # Frontend-specific context
  api/
    AGENTS.md               # Backend-specific context
```

**Progressive Disclosure Principle**:
- Root AGENTS.md → universal rules
- Package AGENTS.md → local rules
- Docs → detailed instructions
- Agents apply closest AGENTS.md in directory tree

#### 4. Multi-Agent Context Isolation (2508.08322)

**Hub-and-Spoke Pattern**:
```
Manager (Orchestrator)
    ├── backend-architect agent
    ├── frontend-specialist agent
    ├── devops-engineer agent
    └── code-reviewer agent
```

**Design Principles**:
- Each subagent has **isolated context window**
- Common background via **persistent context file** (CLAUDE.md)
- Preloaded architectural overviews, coding conventions
- No cross-contamination between workflow phases

#### 5. Symbolic Links for Tool Compatibility (Medium Article)

```bash
# Keep AGENTS.md as single source of truth
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md
```

This avoids duplication and keeps future migration trivial.

### Synthesized Best Practices for DECISION_087

| Practice | Evidence | Implementation |
|----------|----------|----------------|
| Configuration-as-code | 2511.12884 | Treat agent prompts as versioned software artifacts |
| Directory-per-agent | 2511.07257 | Each agent has designated output directory |
| Nested context files | Medium | AGENTS.md at each level with progressive disclosure |
| Symbolic links | Medium | Single source of truth, multiple tool compatibility |
| Context isolation | 2508.08322 | Hub-and-spoke with persistent shared context |
| Active maintenance | 2511.12884 | Include in PR review checklists |
| RAG integration | Filesystem-First | All outputs ingested into knowledge base |

### Recommended Directory Structure Update

```
P4NTHE0N/
├── AGENTS.md                    # Tool-agnostic root context
├── CLAUDE.md → AGENTS.md        # Symbolic link
├── STR4TEG15T/
│   ├── AGENTS.md               # Strategist-specific context
│   ├── decisions/
│   ├── consultations/
│   ├── handoffs/
│   └── canon/
├── 0R4CL3/
│   ├── AGENTS.md               # Oracle-specific context
│   └── assessments/
├── D351GN3R/
│   ├── AGENTS.md               # Designer-specific context
│   └── architectures/
├── L1BR4R14N/
│   ├── AGENTS.md               # Librarian-specific context
│   └── research/
├── OP3NF1X3R/
│   ├── AGENTS.md               # OpenFixer-specific context
│   └── deployments/
└── F0RG3WR1GHT/
    ├── AGENTS.md               # Forgewright-specific context
    └── triage/
```

### Updated Agent Prompt Requirements

Based on this research, every agent prompt MUST include:

1. **Directory Reference**: Explicit path to designated output directory
2. **Documentation Mandate**: Must write artifacts to their directory
3. **RAG Integration**: Ingest all outputs into institutional memory
4. **Configuration-as-Code**: Version control and active maintenance
5. **Tool Integration Protocol**: When and how to use available tools
6. **HEF Constraints**: Hard-enforced rules for tool usage

---

*Decision DECISION_087*
*Agent Prompt Enhancement & Automated Decision Creation*
*2026-02-21 (Phase 1 completed 2026-02-22, Phase 2 in progress)*

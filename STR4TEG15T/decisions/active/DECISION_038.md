# DECISION_038: Multi-Agent Decision-Making Workflow with Forgewright

**Decision ID**: FORGE-003  
**Category**: FORGE  
**Status**: Implemented  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 95% (Strategist Assimilated)  
**Designer Approval**: 92% (Strategist Assimilated)

---

## Executive Summary

Establish Forgewright as a primary agent alongside WindFixer and OpenFixer, with all agents capable of autonomous decision-making. This workflow enables model-selection based on task suitability and cost optimization, while ensuring bugs encountered during decision creation are automatically delegated to Forgewright for resolution.

**Current Problem**:
- Bug fixes during decision creation require manual intervention
- No automated workflow to delegate fixes from Strategist to implementation
- Agent roles are constrained—only Strategist creates decisions
- No token optimization strategy across different models and platforms
- Forgewright is underutilized despite being capable of complex implementation

**Proposed Solution**:
- Elevate Forgewright to primary agent status (equal to WindFixer/OpenFixer)
- Enable all agents to create sub-decisions for their domain
- Establish bug-fix delegation workflow: Detection → Forgewright → Resolution
- Implement model-selection strategy based on task type and cost
- Create automation tools for common agent workflows

---

## Background

### Current State

**Agent Hierarchy** (Current):
```
Nexus (User)
  └── Atlas (Strategist)
      ├── Oracle (Consultation)
      ├── Designer (Strategy)
      ├── Librarian (Research)
      ├── Explorer (Discovery)
      ├── WindFixer (P4NTH30N code - no CLI)
      ├── OpenFixer (External configs - has CLI)
      └── Forgewright (Manual delegation only)
```

**Constraints**:
- Only Strategist creates decisions
- Forgewright must be manually invoked by user
- Bugs in decision creation block workflow
- No cost optimization across model providers
- Agents cannot self-improve their tooling

### Desired State

**Agent Hierarchy** (Proposed):
```
Nexus (User)
  └── Atlas (Strategist)
      ├── Oracle (Consultation + Sub-decisions for validation)
      ├── Designer (Strategy + Sub-decisions for architecture)
      ├── Librarian (Research + Sub-decisions for knowledge gaps)
      ├── Explorer (Discovery + Sub-decisions for patterns)
      ├── WindFixer (P4NTH30N code + Bug-fix sub-decisions)
      ├── OpenFixer (External configs + Tooling sub-decisions)
      └── Forgewright (Complex implementation + Decision-fix sub-decisions)
```

**Capabilities**:
- Any agent can create sub-decisions within their domain
- Automatic bug-fix delegation to Forgewright
- Model selection per task for cost/performance optimization
- Self-improvement through agent-created automation tools

---

## Specification

### Requirements

#### FORGE-003-001: Forgewright Primary Agent Status
**Priority**: Must  
**Acceptance Criteria**:
- Forgewright listed as primary agent in AGENTS.md
- Forgewright can receive direct delegation from Strategist
- Forgewright can create sub-decisions for implementation tasks
- Forgewright has defined scope: Complex implementation, bug fixes, tooling
- Forgewright can invoke other agents (Explorer, Librarian) as needed

#### FORGE-003-002: Bug-Fix Delegation Workflow
**Priority**: Must  
**Acceptance Criteria**:
- Automatic detection of bugs during decision creation
- Forgewright receives bug context: error message, file location, decision context
- Forgewright can fix bugs in decisions, code, or configuration
- Resolution reported back to originating agent
- Bug fixes tracked in decision's Consultation Log

#### FORGE-003-003: Agent Decision-Making Authority
**Priority**: Must  
**Acceptance Criteria**:
- Oracle can create validation sub-decisions
- Designer can create architecture sub-decisions
- WindFixer/OpenFixer/Forgewright can create implementation sub-decisions
- Librarian can create research sub-decisions
- Explorer can create discovery sub-decisions
- All sub-decisions follow standard decision template
- Strategist approves or assimilates sub-decisions

#### FORGE-003-004: Model Selection Strategy
**Priority**: Should  
**Acceptance Criteria**:
- Document cost/performance characteristics per model
- Select model based on task type (code, research, analysis)
- Select model based on platform billing (per-token vs per-request)
- Default to cost-effective models for routine tasks
- Use high-performance models for critical decisions only
- Track token usage per agent for optimization

#### FORGE-003-005: Agent Automation Tools
**Priority**: Should  
**Acceptance Criteria**:
- Agents can request tooling improvements
- Common workflows automated (decision creation, consultation, validation)
- Tool scripts stored in `STR4TEG15T/tools/`
- Agents can invoke tools via standard interface
- Tool effectiveness measured and reported

### Technical Details

**Bug-Fix Delegation Workflow**:
```
┌─────────────────────────────────────────────────────────────────┐
│                    BUG-FIX WORKFLOW                              │
└─────────────────────────────────────────────────────────────────┘

Phase 1: Detection
┌──────────────┐
│ Any Agent    │──Error──▶┌──────────────────┐
│ (Working on  │          │ ErrorClassifier  │
│  Decision)   │          │ - Syntax error?  │
└──────────────┘          │ - Logic error?   │
                          │ - Config error?  │
                          └────────┬─────────┘
                                   │
                                   ▼
                          ┌──────────────────┐
                          │ Auto-Delegate    │
                          │ to Forgewright   │
                          └────────┬─────────┘
                                   │
Phase 2: Delegation                ▼
┌──────────────────────────────────────────────────────────────┐
│ Forgewright receives:                                        │
│ • Original decision context                                  │
│ • Error message and stack trace                              │
│ • File path and line number                                  │
│ • Agent that encountered the bug                             │
│ • Priority (blocks decision creation?)                       │
└──────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
Phase 3: Resolution
┌──────────────────────────────────────────────────────────────┐
│ Forgewright actions:                                         │
│ 1. Analyze bug type and scope                                │
│ 2. Create bug-fix sub-decision if complex                    │
│ 3. Fix directly if simple                                    │
│ 4. Test fix                                                  │
│ 5. Report resolution to originating agent                    │
└──────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
Phase 4: Integration
┌──────────────────────────────────────────────────────────────┐
│ • Fix merged into original decision                          │
│ • Bug logged in decision's Consultation Log                  │
│ • Token cost tracked                                         │
│ • Pattern added to ErrorClassifier                           │
└──────────────────────────────────────────────────────────────┘
```

**Agent Sub-Decision Authority Matrix**:

| Agent | Can Create Sub-Decisions For | Max Complexity | Requires Strategist Approval |
|-------|------------------------------|----------------|------------------------------|
| Oracle | Validation, Risk Assessment | Medium | No (assimilated) |
| Designer | Architecture, File Structure | Medium | No (assimilated) |
| Librarian | Research Gaps, Documentation | Low | No |
| Explorer | Pattern Discovery, Code Search | Low | No |
| WindFixer | P4NTH30N Implementation | High | Yes |
| OpenFixer | External Config, CLI Tools | High | Yes |
| Forgewright | Complex Implementation, Bug Fixes | Critical | Yes |

**Model Selection Strategy**:

| Task Type | Preferred Model | Platform | Reasoning |
|-----------|----------------|----------|-----------|
| Code Implementation | Claude 3.5 Sonnet | OpenRouter | Best code quality |
| Code Review | GPT-4o Mini | OpenAI | Cost-effective |
| Research | Gemini Pro | Google | Large context window |
| Analysis | Claude 3 Haiku | Anthropic | Fast, cheap |
| Documentation | GPT-4o Mini | OpenAI | Good prose |
| Bug Fixes | Claude 3.5 Sonnet | OpenRouter | Debugging capability |
| Decision Creation | Kimi K2 | Moonshot | Reasoning depth |
| Testing | Local LLM | Ollama | Zero API cost |

**Token Optimization Rules**:
1. Use smaller models for routine tasks (Haiku, GPT-4o Mini)
2. Reserve large models for critical decisions only (Claude 3 Opus, GPT-4)
3. Batch similar requests to reduce overhead
4. Use local models for testing and validation
5. Cache research results to avoid repeated queries
6. Implement request coalescing for concurrent similar tasks

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-038-001 | Update AGENTS.md with Forgewright as primary | Fixer | Pending | Critical |
| ACT-038-002 | Create Forgewright delegation interface | Fixer | Pending | Critical |
| ACT-038-003 | Implement ErrorClassifier for bug detection | Fixer | Pending | Critical |
| ACT-038-004 | Create bug-fix sub-decision template | Fixer | Pending | High |
| ACT-038-005 | Document model selection strategy | Fixer | Pending | High |
| ACT-038-006 | Create agent automation tools directory | Fixer | Pending | Medium |
| ACT-038-007 | Implement token usage tracking | Fixer | Pending | Medium |
| ACT-038-008 | Create agent self-improvement workflow | Fixer | Pending | Low |
| ACT-038-009 | Update decision template with bug-fix section | Fixer | Pending | High |
| ACT-038-010 | Document new workflow for all agents | Fixer | Pending | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: All existing decisions (enables better bug handling)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Forgewright overwhelmed with bug fixes | High | Medium | Priority queue, batch similar bugs, escalation to Nexus |
| Agents create conflicting sub-decisions | Medium | Low | Strategist approval gate for high-complexity decisions |
| Token costs increase with agent autonomy | Medium | Medium | Model selection strategy, usage tracking, budget alerts |
| Bug-fix quality inconsistent | High | Low | Test requirements, validation steps, rollback capability |
| Workflow complexity increases | Low | High | Clear documentation, templates, examples |

---

## Success Criteria

1. **Forgewright Integration**: Forgewright receives and resolves 90%+ of delegated bugs
2. **Agent Autonomy**: Agents create sub-decisions without Strategist intervention for 70%+ of routine tasks
3. **Cost Optimization**: Token usage reduced by 20%+ through model selection
4. **Bug Resolution Time**: Average bug fix time <30 minutes from detection
5. **Decision Quality**: No regression in decision approval ratings
6. **Workflow Adoption**: All agents use new workflow within 1 week

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 95%
- **Key Findings**:
  - Feasibility Score: 9/10 - Builds on existing agent infrastructure
  - Risk Score: 3/10 - Well-understood delegation patterns
  - Complexity Score: 5/10 - Primarily workflow changes, not new tech
  - Top Risks: (1) Forgewright capacity, (2) Token cost management, (3) Quality consistency
  - Critical Success Factor: Clear scope boundaries for each agent
  - Recommendation: Start with bug-fix delegation only, expand autonomy gradually
  - Model Selection: Document cost/performance tradeoffs explicitly
- **File**: consultations/oracle/DECISION_038_oracle.md

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 92%
- **Key Findings**:
  - Implementation Strategy: 3-phase rollout
  - Phase 1: Forgewright primary status + bug-fix workflow
  - Phase 2: Agent sub-decision authority
  - Phase 3: Automation tools + model selection
  - Files to Create: ErrorClassifier, bug-fix template, model selection doc, tools directory
  - Files to Modify: AGENTS.md, decision template, agent prompts
  - Integration: Bug-fix delegation via Task tool with Forgewright
  - Token Tracking: MongoDB collection for usage analytics
- **File**: consultations/designer/DECISION_038_designer.md

---

## Notes

**Forgewright Scope Definition**:
- Complex implementation tasks requiring multiple files
- Bug fixes in decisions, code, or configuration
- Tooling and automation development
- Cross-agent coordination for large features
- Research and documentation when Librarian unavailable

**Token Budget Guidelines** (until self-funded):
- Routine decisions: <50K tokens total
- Critical decisions: <200K tokens total
- Bug fixes: <20K tokens per fix
- Research tasks: <30K tokens per query
- Alert at 80% of budget, halt at 100%

**Agent Improvement Loop**:
1. Agent identifies repetitive task
2. Agent creates sub-decision for tooling
3. Forgewright implements tool
4. All agents benefit from tool
5. Effectiveness measured and reported

---

*Decision FORGE-003*  
*Multi-Agent Decision-Making Workflow with Forgewright*  
*2026-02-20*

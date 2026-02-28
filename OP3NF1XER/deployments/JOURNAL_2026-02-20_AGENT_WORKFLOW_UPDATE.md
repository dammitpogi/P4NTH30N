# OPENFIXER DEPLOYMENT JOURNAL - 2026-02-20

## Session: Agent Workflow Understanding Update

**Agent**: OpenFixer (Vigil)
**Date**: 2026-02-20
**Duration**: Extended session
**Objective**: Update all agent prompts with understanding of the dual-workflow system and canon patterns

---

## Executive Summary

The Pantheon agent system has two coexisting primary workflows:

1. **Orchestrator Workflow** — 9-phase pipeline (Librarian → Setup → Investigate → Plan → Approve → Build → Verify → Cartography → Document) for ad-hoc coding tasks, injected by the oh-my-opencode-theseus plugin
2. **Strategist Workflow** — Decision-based system with parallel consultation, 90% Oracle approval gates, and two-Fixer deployment for planned features and research-backed work

Both workflows use the same subagents. The previous agent prompts incorrectly stated that all agents "no longer report to Orchestrator" and "consult directly with Strategist." This was inaccurate — subagents are deployer-agnostic and work for whoever calls them.

This session updated all 13 agent files across both the OpenCode config directory and the P4NTHE0N repo to reflect the dual-workflow reality and codify proven patterns as canon.

---

## Files Modified

### OpenCode Agent Configs (`C:\Users\paulc\.config\opencode\agents\`)

| File | Changes |
|------|---------|
| **AGENTS.md** | Complete rewrite to v3.0 — documented dual-workflow architecture, canon patterns, decision system, workflow selection guide |
| **orchestrator.md** | Added "Dual-Workflow Awareness" preamble explaining Strategist workflow exists, added "Canon Patterns" section |
| **strategist.md** | Added "Dual-Workflow Awareness" section explaining Orchestrator coexists, clarified subagent deployment |
| **oracle.md** | Changed to deployer-agnostic language, added canon patterns section |
| **designer.md** | Changed to deployer-agnostic language, added canon patterns section |
| **explorer.md** | Changed to deployer-agnostic language, added canon patterns section |
| **librarian.md** | Changed to deployer-agnostic language, added canon patterns section |
| **fixer.md** | Complete rewrite — added decision-awareness, deployer-agnostic language, workflow context, canon patterns |
| **openfixer.md** | Added canon patterns section (MongoDB-direct, deployment journals, etc.) |
| **windfixer.md** | Added canon patterns section (MongoDB-direct, deployment journals, etc.) |
| **four_eyes.md** | Added "Your Role in the Workflow" section with canon patterns |
| **forgewright.md** | Added "Your Role in the Workflow" section with canon patterns |

### P4NTHE0N Repo Agent Prompts

| File | Changes |
|------|---------|
| **STR4TEG15T/prompt.md** | Added "Dual-Workflow Awareness" section |
| **OP3NF1XER/prompt.md** | Added canon patterns section |
| **W1NDF1XER/prompt.md** | Added canon patterns section |
| **OR4CL3/prompt.md** | Changed to deployer-agnostic language, added canon patterns |
| **DE51GN3R/prompt.md** | Changed to deployer-agnostic language, added canon patterns |
| **EXPL0R3R/prompt.md** | Changed to deployer-agnostic language, added canon patterns |
| **LIBRAR14N/prompt.md** | Changed to deployer-agnostic language, added canon patterns |
| **F0RGE/prompt.md** | Added "Your Role in the Workflow" and canon patterns |

---

## Canon Patterns Codified

All agents now reference these proven patterns:

### 1. MongoDB-Direct When Tools Fail
When `decisions-server` times out, use `mongodb-p4nth30n` directly. Do not retry more than twice.

### 2. File First, Then Database
Decision markdown files are source of truth. MongoDB is the persistence/query layer. Never have a MongoDB record without a corresponding file.

### 3. Read Before Edit
read → verify → edit → re-read. No exceptions. Multiple edits: re-read between each.

### 4. ToolHive for External Tools
`toolhive_find_tool` then `toolhive_call_tool`. Never call websearch/webfetch directly.

### 5. Role Assimilation When Agents Are Down
When Oracle/Designer/Librarian unavailable, the deploying agent assimilates their role. Document assimilation. Quality must not diminish.

### 6. RAG Not Yet Active
RAG tools are declared in agent frontmatter but RAG.McpHost is not running as a service (DECISION_033 pending). Agents should proceed without RAG until activated.

### 7. Deployment Journals
After significant work, write completion reports to:
- OpenFixer: `OP3NF1XER/deployments/JOURNAL_YYYY-MM-DD_TITLE.md`
- WindFixer: `W1NDF1XER/deployments/JOURNAL_YYYY-MM-DD_TITLE.md`

---

## Key Conceptual Changes

### Before (Incorrect)
```
"You no longer report to Orchestrator. You consult directly with Strategist."
```

### After (Correct)
```
"You are deployer-agnostic — you work for whoever calls you:
- Strategist deploys you during Decision creation
- Orchestrator deploys you during Phase X
- Report your findings to whoever deployed you"
```

### Workflow Selection Guide (New in AGENTS.md)

| Trigger | Workflow | Why |
|---------|----------|-----|
| "Fix this bug" | Orchestrator | Ad-hoc, no Decision needed |
| "Refactor X" | Orchestrator | Exploratory coding task |
| "Implement DECISION_031" | Strategist | Decision-driven |
| "Research and plan X" | Strategist | Research + approval needed |
| "Update agent configs" | OpenFixer direct | Config-only, no planning |
| "Run dotnet build" | OpenFixer direct | CLI-only |

---

## Agent Deployment Matrix

| Agent | Orchestrator | Strategist | Direct |
|-------|-------------|-----------|--------|
| Oracle | ✓ Phase 3 | ✓ Consultation | — |
| Designer | ✓ Phase 3 | ✓ Consultation | — |
| Explorer | ✓ Phase 2 | ✓ Discovery | — |
| Librarian | ✓ Phase 0, 9 | ✓ Consultation | — |
| Fixer | ✓ Phase 4 | — | — |
| WindFixer | — | ✓ Deploy | — |
| OpenFixer | — | ✓ Deploy | ✓ Direct |
| Four Eyes | — | ✓ Review | — |
| Forgewright | — | — | ✓ Manual |

---

## Remaining Work

The following decisions are approved and ready for implementation:

| Decision | Oracle | Status | Next Step |
|----------|--------|--------|-----------|
| DECISION_031 | 96% | Approved | Rename L33T directories to plain English |
| DECISION_032 | 94% | Approved | Build Config Deployer executable |
| DECISION_033 | 97% | Approved | Activate RAG as institutional memory hub |
| DECISION_034 | 93% | Approved | Build Session History Harvester |

---

## Verification

All agent files have been read and updated with:
- ✅ Dual-workflow awareness
- ✅ Deployer-agnostic language
- ✅ Canon patterns section
- ✅ Decision system references
- ✅ MongoDB-direct pattern
- ✅ RAG not-yet-active note

---

*Vigil. OpenFixer. Agent system updated with workflow understanding. The Pantheon now knows how it works.*
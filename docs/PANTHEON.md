# PANTHEON Architecture v3.0

**Updated:** 2026-02-18

## Overview

PANTHEON is a self-funded agentic environment that coordinates multiple AI agents for automated software development, testing, and operations. Originally built for the P4NTHE0N casino automation project, it has evolved into a general-purpose agentic platform.

---

## Agent Architecture

### OpenCode Agents (Orchestration Layer)

| Agent | Platform | Role | Status |
|-------|----------|------|--------|
| **Strategist** | OpenCode | Creates Decisions, consults Oracle/Designer | ✅ Active |
| **Oracle** | OpenCode | Risk assessment, approval percentages | ✅ Active |
| **Designer** | OpenCode | Implementation research, architecture | ✅ Active |
| **Orchestrator** | OpenCode | Coordinates one-time changes | ✅ Active |
| **OpenFixer** | OpenCode | **Primary Fixer** - External edits, CLI operations | ✅ Active |
| **WindFixer** | WindSurf | Bulk P4NTHE0N directory work only | ✅ Active |
| **ForgeWright** | OpenCode | Bug handling via unit testing | ✅ Active |
| **Explorer** | OpenCode | Codebase discovery | ⚠️ Buggy (model fallback) |
| **Librarian** | OpenCode | Documentation lookup | ⚠️ Buggy (model fallback) |

### P4NTHE0N Project Agents

| Agent | Former Name | Purpose |
|-------|-------------|---------|
| **H0UND** | WATCHDOG | Vision system (OBS + LM Studio) |
| **HUN7ER** | H0UND | Signal hunting and prediction |
| **H4ND** | H4ND | Browser automation |
| **OpenFixer** | Fixer | **Primary Fixer** - External edits, CLI operations |
| **WindFixer** | Fixer | Bulk P4NTHE0N directory work only |

---

## Platform Strategy

### OpenCode
- **Primary orchestration**
- Agent definitions and coordination
- **Primary Fixer (OpenFixer)** for external edits and CLI operations
- Cost: Higher per-prompt but better for orchestration

### WindSurf
- **Bulk P4NTHE0N work only**
- Opus 4.6 Thinking (preferred model)
- Cheaper per-prompt billing
- **WindFixer** handles bulk directory work
- **Cannot use CLI tools or edit outside C:\P4NTHE0N**

---

## Decision Framework

The Decision framework is the central cost-saving mechanism:

1. **Strategist** creates Decisions (high-level requirements)
2. **Oracle/Designer** validate and refine
3. **WindFixer** executes in bulk on WindSurf
4. **ForgeWright** handles bugs via unit tests

**Cost Savings:** ~60% vs pure OpenCode execution

---

## Opus 4.6 Strategy

**Oracle Approval:** 78% Conditional

### Usage Guidelines

| Role | Effort Level | When to Use |
|------|--------------|-------------|
| Oracle | Medium | Routine risk assessments |
| Oracle | High/Max | Complex architectural decisions |
| Designer | High | All design work |
| Strategist | Medium | Routine decisions |
| Strategist | High/Max | Complex multi-domain analysis |

### Fallback Chain
1. Opus 4.6 → Claude Sonnet 4.6 → GPT-5.2

---

## In-House Implementation Principles

All implementations prioritize in-house solutions to:
- Avoid vendor lock-in
- Keep operations manageable
- Minimize recurring costs
- Maintain full control

---

## Known Issues

### Explorer/Librarian (Model Fallback)
- **Status:** Buggy due to OpenCode model fallback failures
- **Workaround:** Use direct tool execution (glob, grep, read)
- **Resolution:** Awaiting OpenCode fallback fix

---

## File Locations

### Agent Definitions
```
C:\Users\paulc\.config\opencode\agents\
├── strategist.md
├── oracle.md
├── designer.md
├── orchestrator.md
├── openfixer.md      # NEW: Renamed from fixer.md
├── windfixer.md      # NEW: WindSurf Fixer
├── forgewright.md
├── explorer.md       # Buggy
└── librarian.md      # Buggy
```

### P4NTHE0N Project
```
C:\P4NTHE0N\
├── H0UND\           # Vision (was W4TCHD0G)
├── HUN7ER\          # Signal hunting (was H0UND)
├── H4ND\            # Browser automation
├── C0MMON\          # Shared infrastructure
├── PROF3T\          # Learning system
├── T00L5ET\         # Toolset
├── T4CT1CS\         # Decision tracking
└── W4TCHD0G\        # Legacy - to be migrated
```

---

## Workflow Summary

1. **Identify Need** → Agent identifies gap or improvement
2. **Create Decision** → Strategist formalizes as Decision
3. **Validate** → Oracle/Designer provide approval %
4. **Execute** → WindFixer runs on WindSurf (bulk)
5. **Verify** → ForgeWright tests via unit tests
6. **Iterate** → Results inform new Decisions

---

## Cost Optimization

- Decision framework: Bulk execution on WindSurf
- Effort-tiering: Medium for routine, High for complex
- Fallback chain: Switch to cheaper models when appropriate
- In-house: Minimize external dependencies

# Subagent Quick Reference Guide

**Version**: 1.0  
**Date**: 2026-02-18  
**Applies To**: All Pantheon Subagents

---

## Where Do I Read/Write?

### Oracle

```
READ FROM:
  - decisions/active/*.md (proposed decisions awaiting consultation)
  - decisions/clusters/*.json (decision clusters)
  - intelligence/risks/* (existing risk assessments)
  - .index/decisions.json (decision registry)

WRITE TO:
  - consultations/oracle/[YYYY-MM-DDTHH-MM-SS]-[decision-id].md
  - Inline comments in decisions/active/*.md
  - intelligence/risks/[risk-id].md (risk assessments)

NEVER WRITE TO:
  - decisions/active/*.md (except inline comments)
  - actions/* (Strategist and Fixer only)
  - speech/* (Strategist only)
```

### Designer

```
READ FROM:
  - decisions/active/*.md (proposed decisions)
  - decisions/clusters/*.json (clusters)
  - intelligence/opportunities/* (opportunities)
  - .index/decisions.json

WRITE TO:
  - consultations/designer/[YYYY-MM-DDTHH-MM-SS]-[decision-id].md
  - context/briefs/[brief-id].md (implementation briefs)
  - intelligence/opportunities/[opp-id].md (architecture opportunities)
  - Inline comments in decisions/active/*.md

NEVER WRITE TO:
  - decisions/active/*.md (except inline comments)
  - actions/* (except briefs in context/briefs/)
  - speech/* (Strategist only)
```

### OpenFixer / WindFixer

```
READ FROM:
  - actions/ready/*.md (work to do)
  - actions/blocked/*.md (understand dependencies)
  - decisions/active/*.md (understand context)
  - context/briefs/*.md (implementation guidance)
  - .index/actions.json (action registry)

WRITE TO:
  - actions/in-progress/*.md (move from ready/ when starting)
  - actions/done/*.md (move from in-progress/ when complete)
  - system/logs/*.log (execution logs)
  - intelligence/patterns/*.md (execution patterns discovered)

NEVER WRITE TO:
  - decisions/* (Strategist only)
  - actions/ready/* (Strategist only)
  - speech/* (Strategist only)
  - consultations/* (Oracle/Designer only)
```

### Forgewright

```
READ FROM:
  - actions/done/*.md (completed work for analysis)
  - intelligence/patterns/*.md (existing patterns)
  - system/logs/*.log (execution logs)

WRITE TO:
  - intelligence/patterns/*.md (bug patterns, triage patterns)
  - actions/ready/*.md (triage actions, when authorized)
  - context/sessions/*.json (diagnostic session results)

NEVER WRITE TO:
  - decisions/* (Strategist only)
  - speech/* (Strategist only)
  - consultations/* (Oracle/Designer only)
```

---

## File Naming Cheat Sheet

### Decisions (Strategist creates)
Format: `[CATEGORY]-[NNN]-[Short-Name].md`

```
INFRA-009-In-House-Secrets.md
CORE-001-Systems-Architecture.md
FEAT-001-LLM-Inference.md
TECH-003-Hardware-Assessment.md
FORGE-001-Directory-Architecture.md
```

Categories: INFRA, CORE, FEAT, TECH, RISK, AUTO, FORGE, ARCH

### Actions (Strategist creates, Fixer moves)
Format: `ACT-[NNN]-[Short-Name].md`

```
ACT-001-Circuit-Breaker.md
ACT-042-MongoDB-Index.md
ACT-050-Create-Directory-Structure.md
```

### Speech (Strategist creates)
Format: `[YYYY-MM-DDTHH-MM-SS]-[topic].md`

```
2026-02-18T20-15-00-Oracle-Consultation.md
2026-02-18T21-00-00-Designer-Assessment.md
```

**Important**: Use dashes (-), not underscores (_)

### Consultations (Oracle/Designer create)
Format: `[YYYY-MM-DDTHH-MM-SS]-[decision-id].md`

```
2026-02-18T20-15-00-INFRA-009.md
2026-02-18T21-00-00-CORE-001.md
```

---

## Directory Structure Quick View

```
T4CT1CS/
├── .index/              # READ-ONLY (Strategist manages)
│   ├── decisions.json
│   ├── actions.json
│   └── speech.json
│
├── decisions/
│   ├── _templates/      # READ-ONLY
│   ├── _archive/        # READ-ONLY (completed decisions)
│   ├── active/          # READ-ONLY (Strategist writes)
│   └── clusters/        # READ-ONLY (Strategist writes)
│
├── actions/
│   ├── _templates/      # READ-ONLY
│   ├── _archive/        # READ-ONLY
│   ├── ready/           # READ (Strategist writes)
│   ├── blocked/         # READ (Strategist writes)
│   ├── in-progress/     # WRITE (Fixer moves here when starting)
│   └── done/            # WRITE (Fixer moves here when done)
│
├── speech/              # WRITE (Strategist only)
├── consultations/
│   ├── oracle/          # WRITE (Oracle only)
│   ├── designer/        # WRITE (Designer only)
│   └── sessions/        # WRITE (Strategist only)
│
├── intelligence/
│   ├── gaps/            # WRITE (Strategist, Oracle, Designer)
│   ├── risks/           # WRITE (Oracle)
│   ├── opportunities/   # WRITE (Designer)
│   └── patterns/        # WRITE (Fixer, Forgewright)
│
└── context/
    ├── sessions/        # WRITE (Strategist, Forgewright)
    ├── briefs/          # WRITE (Designer)
    └── references/      # WRITE (Strategist)
```

---

## Common Workflows

### Workflow 1: Consult on a Decision

```
1. Strategist creates: decisions/active/CORE-001-Example.md
2. Strategist updates: .index/decisions.json
3. Oracle reads: decisions/active/CORE-001-Example.md
4. Oracle writes: consultations/oracle/2026-02-18T20-15-00-CORE-001.md
5. Designer reads: decisions/active/CORE-001-Example.md
6. Designer writes: consultations/designer/2026-02-18T21-00-00-CORE-001.md
7. Strategist reads both consultations
8. Strategist updates decisions/active/CORE-001-Example.md
9. Strategist creates speech/2026-02-18T22-00-00-CORE-001-Complete.md
```

### Workflow 2: Execute an Action

```
1. Strategist creates: actions/ready/ACT-001-Example.md
2. Strategist updates: .index/actions.json
3. Fixer polls actions/ready/ and picks up ACT-001
4. Fixer moves: actions/ready/ACT-001 → actions/in-progress/ACT-001
5. Fixer updates: .index/actions.json
6. Fixer executes implementation
7. Fixer moves: actions/in-progress/ACT-001 → actions/done/ACT-001
8. Fixer updates: .index/actions.json with results
```

### Workflow 3: Bug Pattern Discovery

```
1. Forgewright reads: actions/done/ for recent completions
2. Forgewright identifies pattern
3. Forgewright writes: intelligence/patterns/BUG-001-Connection-Leaks.md
4. Forgewright creates: actions/ready/ACT-050-Fix-Connection-Leaks.md
5. Fixer picks up ACT-050 and executes
```

---

## Status Meanings

### Decision Status
- **Proposed** - Created, awaiting consultation
- **InProgress** - Oracle/Designer consulted, implementation started
- **Completed** - Implementation done, validated
- **Rejected** - Not approved by Oracle or superseded
- **Blocked** - Dependencies blocking implementation

### Action Status
- **ready** - Awaiting Fixer assignment
- **blocked** - Dependencies not met
- **in-progress** - Fixer currently working
- **done** - Implementation complete

---

## Priority Levels

- **Critical** - Blocks multiple decisions, immediate attention
- **High** - Important, should be done this session
- **Medium** - Normal priority, queue appropriately
- **Low** - Nice to have, backlog acceptable

---

## Getting the Next ID

Always check `.index/decisions.json` or `.index/actions.json` for the next available ID:

```json
// From .index/decisions.json
"nextId": {
  "INFRA": 11,  // Next INFRA decision is INFRA-011
  "CORE": 2,    // Next CORE decision is CORE-002
  "FEAT": 2,    // Next FEAT decision is FEAT-002
  // ...
}
```

```json
// From .index/actions.json
"nextActionId": 51  // Next action is ACT-051
```

---

## Validation Checklist

Before writing any file, verify:

- [ ] File is in the correct directory for its type
- [ ] Filename follows the naming convention
- [ ] I have write permission to this directory
- [ ] The ID is the next available (check .index/)
- [ ] All required headers/fields are present
- [ ] Cross-references are updated in .index/

---

## Emergency Contacts

If you find a file in the wrong place:
1. Do NOT move it yourself
2. Notify Strategist
3. Strategist will create migration action
4. Fixer will execute migration

If you need write access to a read-only directory:
1. You probably shouldn't have it - check your workflow
2. If truly needed, escalate to Strategist
3. Strategist will update permissions if justified

---

## Examples

### Good Decision File

```markdown
# INFRA-009: In-House Secrets Management

**Decision ID**: INFRA-009  
**Category**: INFRA  
**Status**: Proposed  
**Priority**: Critical  
**Oracle Approval**: 84%

## Executive Summary
...
```

### Good Action File

```markdown
# ACT-001: Implement Circuit Breaker

**Action ID**: ACT-001  
**Status**: ready  
**Priority**: Critical  
**Decision**: FOUREYES-001  
**Assigned To**: WindFixer

## Description
...
```

### Good Speech File

```markdown
# Speech: Oracle Consultation Complete

**Date**: 2026-02-18 20:15:00  
**Topic**: INFRA-009 Risk Assessment  
**Oracle Approval**: 84%

Oracle has completed assessment of INFRA-009...
```

---

*Keep this guide handy. When in doubt, ask the Strategist.*

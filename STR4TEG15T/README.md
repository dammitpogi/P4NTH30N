# T4CT1CS Platform Architecture

**Version**: 2.0  
**Status**: Active (Architecture Standardization in Progress)  
**Last Updated**: 2026-02-18

---

## Purpose

Decision execution engine. Not documentation. Not discussion. **Execution.**

This directory contains the Strategist platform - a structured decision framework for coordinating the Pantheon agents (Oracle, Designer, Fixer, Forgewright) toward autonomous execution.

---

## Directory Architecture (v2.0)

**See**: `decisions/active/FORGE-001-Directory-Architecture.md` for the complete specification

```
T4CT1CS/
├── .index/                      # Auto-generated indices (READ-ONLY)
│   ├── decisions.json           # Master decision registry
│   ├── actions.json             # Action item registry
│   ├── speech.json              # Speech log index
│   └── cross-references.json    # Decision → Action → Speech links
│
├── decisions/                   # Decision manifests ONLY
│   ├── _templates/              # Decision templates (READ-ONLY)
│   ├── _archive/                # Completed/rejected decisions (READ-ONLY)
│   │   └── YYYY-MM/            # Monthly archive buckets
│   ├── active/                  # InProgress decisions (Strategist writes)
│   └── clusters/                # Decision clusters (Strategist writes)
│
├── actions/                     # Action items ONLY
│   ├── _templates/              # Action templates (READ-ONLY)
│   ├── _archive/                # Completed actions (READ-ONLY)
│   ├── ready/                   # Ready to execute (Strategist writes)
│   ├── blocked/                 # Waiting on dependencies (Strategist writes)
│   ├── in-progress/             # Currently executing (Fixer writes)
│   └── done/                    # Completed (Fixer writes)
│
├── speech/                      # Voice synthesis output ONLY (Strategist writes)
│   ├── _archive/                # Archived speeches
│   └── YYYY-MM-DDTHH-MM-SS.md   # Speech files
│
├── consultations/               # Oracle/Designer consultations
│   ├── oracle/                  # Oracle consultation transcripts
│   ├── designer/                # Designer consultation transcripts
│   └── sessions/                # Multi-agent session summaries
│
├── intelligence/                # Strategic intelligence
│   ├── gaps/                    # Identified capability gaps
│   ├── risks/                   # Risk assessments (Oracle)
│   ├── opportunities/           # Strategic opportunities (Designer)
│   └── patterns/                # Detected execution patterns (Fixer, Forgewright)
│
├── context/                     # Shared context for subagents
│   ├── sessions/                # Session state files
│   ├── briefs/                  # Pre-execution briefs for Fixers
│   └── references/              # Cross-cutting reference docs
│
└── system/                      # Platform infrastructure
    ├── config/                  # T4CT1CS configuration
    ├── logs/                    # Execution logs
    └── validation/              # Schema validation rules
```

---

## Quick Start for Subagents

**New here?** Read: `context/references/SUBAGENT-QUICK-REFERENCE.md`

### Where Do I Read/Write?

| Agent | Read From | Write To |
|-------|-----------|----------|
| **Oracle** | `decisions/active/`, `intelligence/risks/` | `consultations/oracle/`, inline decision comments |
| **Designer** | `decisions/active/`, `intelligence/opportunities/` | `consultations/designer/`, `context/briefs/` |
| **Fixer** | `actions/ready/`, `decisions/active/`, `context/briefs/` | `actions/in-progress/`, `actions/done/`, `intelligence/patterns/` |
| **Forgewright** | `actions/done/`, `intelligence/patterns/` | `intelligence/patterns/`, `actions/ready/` (triage) |
| **Strategist** | Everything | `decisions/`, `actions/ready/`, `speech/`, `.index/` |

---

## Naming Conventions

### Decisions
**Format**: `[CATEGORY]-[NNN]-[Short-Name].md`

**Categories**:
- `INFRA` - Infrastructure and operations
- `CORE` - Core architecture and systems design
- `FEAT` - Feature development
- `TECH` - Technical debt and refactoring
- `RISK` - Risk mitigation
- `AUTO` - Automated system decisions
- `FORGE` - Platform-pattern and enhancement
- `ARCH` - Architecture decisions

**Examples**:
```
INFRA-009-In-House-Secrets.md
CORE-001-Systems-Architecture.md
FORGE-001-Directory-Architecture.md
```

### Actions
**Format**: `ACT-[NNN]-[Short-Name].md`

**Examples**:
```
ACT-001-Circuit-Breaker.md
ACT-050-Create-Directory-Structure.md
```

### Speech
**Format**: `[YYYY-MM-DDTHH-MM-SS]-[topic].md`

**Important**: Use dashes (-), NOT underscores (_)

**Examples**:
```
2026-02-18T20-15-00-Oracle-Consultation.md
2026-02-18T21-00-00-Designer-Assessment.md
```

### Consultations
**Format**: `[YYYY-MM-DDTHH-MM-SS]-[decision-id].md`

**Examples**:
```
2026-02-18T20-15-00-INFRA-009.md
2026-02-18T21-00-00-CORE-001.md
```

---

## Decision Types

1. **INFRA** - Infrastructure and operations
2. **CORE** - Core architecture and systems design
3. **FEAT** - Feature development
4. **TECH** - Technical debt and refactoring
5. **RISK** - Risk mitigation
6. **AUTO** - Automated system decisions
7. **FORGE** - Platform-pattern and enhancement
8. **ARCH** - Architecture decisions

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

## Execution Rules

1. **Speech files** use ISO8601 datetime titles with dashes only
2. **No formatting** in speech files that breaks voice synthesis
3. **Decisions** move from `active/` to `_archive/` on completion
4. **Actions** move: `ready/` → `in-progress/` → `done/`
5. **Auto-generated indices** in `.index/` are the source of truth
6. **Templates** in `_templates/` directories are read-only patterns
7. **Cross-references** must be maintained in `.index/` JSON files

---

## Current State

**Architecture Standardization in Progress**:
- **Decision FORGE-001**: Directory Architecture Standardization (Proposed)
- **Action ACT-050**: Create directory structure (Ready)
- **Action ACT-051**: Migrate existing decisions (Ready)
- **Action ACT-052**: Generate index files (Ready)

**Decision Inventory**:
- 55+ total decisions tracked
- 16 Completed, 36 Proposed, 3 InProgress
- 76 action items

**See Also**:
- `decisions/active/FORGE-001-Directory-Architecture.md` - Complete architecture spec
- `context/references/SUBAGENT-QUICK-REFERENCE.md` - Subagent interaction guide
- `.index/decisions.json` - Master decision registry
- `.index/actions.json` - Master action registry

---

## Templates

- **Decision**: `decisions/_templates/DECISION-TEMPLATE.md`
- **Cluster**: `decisions/_templates/CLUSTER-TEMPLATE.json`
- **Action**: `actions/_templates/ACTION-TEMPLATE.md`

---

## Validation

All files must pass validation before being considered complete:

1. **Decision files**: Must have Decision ID, Category, Status, Priority headers
2. **Action files**: Must have Action ID, Status, Priority headers
3. **Speech files**: Must use correct timestamp format
4. **Indices**: Must be valid JSON and consistent with file system

Validation rules: `system/validation/`

---

## Migration from v1.0

The platform is migrating from the organic v1.0 structure to the standardized v2.0 architecture:

**Old locations** (being deprecated):
- `decisions/active/*.md` with inconsistent naming
- `actions/pending/*.md` (now `actions/ready/`)
- Mixed timestamp formats in `speech/`

**New locations**:
- Standardized naming per conventions above
- Clear separation of concerns
- Automated indexing

**Migration deadline**: 48 hours after FORGE-001 approval

---

*Strategist Platform v2.0*  
*Standardized Directory Architecture*  
*2026-02-18*

# OpenFixer Agent (OP3NF1XER)

## Overview

OpenFixer is the primary implementation and environment-governance agent for external work, runtime control, and Windows host operational clarity.

## Role

- **Type**: Implementation (primary)
- **Reports To**: Strategist
- **Receives From**: Designer, Oracle
- **Scope**: External directories, CLI/runtime control, Windows 11 control-plane governance

## Capabilities

### Core Functions
1. **External Implementation** - Edit files outside core source directories
2. **CLI Operations** - Execute and validate command-line workflows
3. **System Changes** - Harden runtime/config/package behavior
4. **Environment Oversight** - Maintain deterministic command paths and inventory evidence
5. **Deployment** - Implement decisions with audit and re-audit loops

### Deployment Types
- `external_edits`
- `cli_operations`
- `system_changes`
- `configuration_updates`
- `windows_control_plane`
- `runtime_drift_hardening`

## Workflows

### Primary Workflows
1. **Decision Implementation** - Execute approved decisions
2. **Decision-First Recall** - Check historical decisions and knowledgebase before discovery
3. **CLI Execution** - Run commands and collect verification evidence
4. **Environment Audit** - Run runtime, package, and inventory checks
5. **Status Update** - Report completion with PASS/PARTIAL/FAIL audit matrix

### Triggers
- Strategist deployment
- External change request

## Directory Structure

```
OP3NF1XER/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── deployments/          # Deployment records
│   └── {DECISION_ID}/
└── patterns/            # CLI patterns
```

## Key Relationships

```
Strategist → deploys → OpenFixer
OpenFixer ← receives specs ← Designer, Oracle
OpenFixer → implements → External locations
```

## Environment Bias

- Minimize operator confusion through deterministic wrappers and path consistency.
- Treat Windows host state as governed surface, not external noise.
- Prefer script-root-relative automation over hardcoded repository root naming.

## Version

- **Current**: 3.1.0
- **Last Updated**: 2026-02-24

---

*Part of the P4NTHE0N Agent Architecture*

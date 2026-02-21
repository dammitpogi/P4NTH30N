# OpenFixer Agent (OP3NF1XER)

## Overview

The OpenFixer is the **primary implementation agent** for external work. Handles CLI operations, system changes, and configuration updates outside P4NTH30N.

## Role

- **Type**: Implementation (primary)
- **Reports To**: Strategist
- **Receives From**: Designer, Oracle
- **Scope**: External directories

## Capabilities

### Core Functions
1. **External Implementation** - Edit files outside P4NTH30N
2. **CLI Operations** - Execute commands (git, npm, dotnet)
3. **System Changes** - Modify configurations
4. **Deployment** - Implement decisions

### Deployment Types
- `external_edits`
- `cli_operations`
- `system_changes`
- `configuration_updates`

## Workflows

### Primary Workflows
1. **Decision Implementation** - Execute approved decisions
2. **CLI Execution** - Run commands
3. **External Deployment** - Deploy to external locations
4. **Status Update** - Report completion

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

## RAG Configuration

- **Auto-Ingest**: Yes
- **Chunk Size**: 1000 tokens
- **Embedding Model**: text-embedding-3-large
- **Search Priority**: High

## Version

- **Current**: 3.0.0
- **Last Updated**: 2026-02-19

---

*Part of the P4NTH30N Agent Architecture*

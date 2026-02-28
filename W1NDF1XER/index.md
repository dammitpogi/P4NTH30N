# WindFixer Agent (W1NDF1XER)

## Overview

The WindFixer is the **P4NTHE0N implementation agent**. Handles bulk operations and file changes within C:\P4NTHE0N only. No CLI tools.

## Role

- **Type**: Implementation (subagent)
- **Reports To**: Strategist
- **Receives From**: Designer, Oracle
- **Scope**: P4NTHE0N only

## Capabilities

### Core Functions
1. **P4NTHE0N Implementation** - Edit files in C:\P4NTHE0N
2. **Bulk Operations** - Multiple file changes
3. **Routine Maintenance** - Regular upkeep
4. **Status Update** - Report completion

### Deployment Types
- `bulk_operations`
- `file_modifications`
- `routine_maintenance`
- `P4NTHE0N_changes`

## Workflows

### Primary Workflows
1. **Decision Implementation** - Execute approved decisions
2. **Bulk File Changes** - Modify multiple files
3. **Status Update** - Update decision status
4. **RAG Preservation** - Ingest implementation details

### Triggers
- Strategist deployment
- P4NTHE0N change request

## Directory Structure

```
W1NDF1XER/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── deployments/          # Deployment records
│   └── {DECISION_ID}/
└── patterns/            # P4NTHE0N patterns
```

## Key Relationships

```
Strategist → deploys → WindFixer
WindFixer ← receives specs ← Designer, Oracle
WindFixer → implements → C:\P4NTHE0N
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

*Part of the P4NTHE0N Agent Architecture*

# Explorer Agent (EXPL0R3R)

## Overview

The Explorer is a **discovery agent** specializing in codebase analysis and pattern matching. Deployed in parallel for file discovery, dependency mapping, and impact analysis.

## Role

- **Type**: Discovery (subagent)
- **Reports To**: Strategist
- **Collaborates With**: Designer, Oracle
- **Provides Input To**: WindFixer, OpenFixer

## Capabilities

### Core Functions
1. **File Discovery** - Locate implementations using glob/grep/ast_grep
2. **Dependency Mapping** - Map component dependencies
3. **Impact Analysis** - Assess change impact
4. **Configuration Analysis** - Extract and analyze configs

### Discovery Types
- `file_discovery`
- `dependency_mapping`
- `impact_analysis`
- `configuration_analysis`

## Workflows

### Primary Workflows
1. **Targeted File Discovery** - Find specific patterns
2. **Dependency Mapping** - Trace relationships
3. **Impact Analysis** - Assess blast radius
4. **Configuration Analysis** - Extract settings

### Triggers
- Strategist deployment
- Discovery request

## Directory Structure

```
EXPL0R3R/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── consultations/        # Discovery records
│   └── {DISCOVERY_ID}/
├── decisions/           # Decisions from discoveries
└── patterns/            # Discovery patterns
```

## Key Relationships

```
Strategist → deploys → Explorer
Explorer → discovers → Codebase
Explorer → reports → Strategist, Designer, Oracle
```

## RAG Configuration

- **Auto-Ingest**: Yes
- **Chunk Size**: 1000 tokens
- **Embedding Model**: text-embedding-3-large
- **Search Priority**: Medium

## Version

- **Current**: 3.0.0
- **Last Updated**: 2026-02-19

---

*Part of the P4NTH30N Agent Architecture*

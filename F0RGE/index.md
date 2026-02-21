# Forgewright Agent (F0RGE)

## Overview

The Forgewright is a **specialist agent** for bug triage and platform intelligence. Creates decisions for platform-wide improvements and manages the T00L5ET reproduction platform.

## Role

- **Type**: Specialist (subagent)
- **Reports To**: Strategist
- **Collaborates With**: Oracle, Designer
- **Creates Decisions For**: Platform patterns, architecture, testing, tooling

## Capabilities

### Core Functions
1. **Bug Triage** - Analyze and reproduce bugs
2. **Platform Intelligence** - Identify patterns and improvements
3. **Decision Creation** - Create platform decisions
4. **T00L5ET Management** - Maintain reproduction platform

### Triage Types
- `bug_reproduction`
- `platform_decision`
- `T00L5ET_enhancement`

## Workflows

### Primary Workflows
1. **Bug Triage** - Analyze and reproduce
2. **Reproduction Platform Setup** - Configure T00L5ET
3. **Decision Creation** - Document platform improvements
4. **Platform Intelligence** - Share knowledge

### Triggers
- Bug report
- Platform issue
- Triage request

## Directory Structure

```
F0RGE/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── consultations/        # Triage records
│   └── {DECISION_ID}/
├── decisions/           # Platform decisions
└── patterns/            # Platform patterns
```

## Key Relationships

```
Strategist → deploys → Forgewright
Forgewright → creates → Platform Decisions
Forgewright → manages → T00L5ET
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

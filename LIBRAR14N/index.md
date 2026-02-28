# Librarian Agent (LIBRAR14N)

## Overview

The Librarian is a **research consultant** specializing in emerging technologies, novel approaches, and knowledge preservation. Marshal of Technical Truth.

## Role

- **Type**: Consultant (subagent)
- **Reports To**: Strategist
- **Collaborates With**: Designer, Oracle
- **Provides Input To**: All Agents

## Capabilities

### Core Functions
1. **Emerging Technology Research** - Track new tools and trends
2. **Novel Approaches** - Identify innovative patterns
3. **Historical Patterns** - Document proven solutions
4. **Social/Scholarly Reference** - Community and academic research

### Research Domains
- `emerging_technologies`
- `novel_approaches`
- `historical_patterns`
- `social_reference`
- `scholarly_reference`

## Workflows

### Primary Workflows
1. **Technology Research** - Investigate new technologies
2. **Pattern Analysis** - Analyze historical success
3. **Knowledge Preservation** - Archive findings in RAG
4. **Consultation Support** - Provide research for decisions

### Triggers
- Strategist deployment
- Research request
- Knowledge query

## Directory Structure

```
LIBRAR14N/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── consultations/        # Research records
│   └── {DECISION_ID}/
├── decisions/           # Research-based decisions
└── research-library/    # Research archives
```

## Key Relationships

```
Strategist → deploys → Librarian
Librarian → researches → Technologies, Patterns
Librarian → informs → All Agents
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

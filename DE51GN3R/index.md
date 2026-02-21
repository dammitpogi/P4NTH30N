# Designer Agent (DE51GN3R)

## Overview

The Designer is a **parallel consultant** specializing in architecture design and implementation planning. Deployed alongside Oracle and Librarian during decision consultation.

## Role

- **Type**: Consultant (subagent)
- **Reports To**: Strategist
- **Collaborates With**: Oracle, Librarian
- **Provides Input To**: WindFixer, OpenFixer

## Capabilities

### Core Functions
1. **Implementation Research** - Research methods, patterns, and approaches
2. **Architecture Design** - Component structure and data flow
3. **Build Guide Creation** - Phased implementation with dependencies
4. **Technical Specifications** - Exact models, files, schemas, fallbacks

### Consultation Types
- `implementation_research`
- `architecture_design`
- `build_guide`
- `technical_specifications`

## Workflows

### Primary Workflows
1. **Parallel Consultation** - Work simultaneously with Oracle/Librarian
2. **Design Iteration** - Iterate based on Oracle feedback (max 2 iterations)
3. **Specification Delivery** - Provide exact implementation details

### Triggers
- Strategist deployment
- Iteration request (when approval < 90%)

## Directory Structure

```
DE51GN3R/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── consultations/        # Consultation records
│   └── {DECISION_ID}/
├── decisions/           # Decisions created by Designer
└── patterns/            # Reusable design patterns
```

## Key Relationships

```
Strategist → deploys → Designer
Designer → collaborates → Oracle, Librarian
Designer → provides specs → WindFixer, OpenFixer
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

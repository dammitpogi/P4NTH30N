# Oracle Agent (OR4CL3)

## Overview

The Oracle is a **strategic advisor** providing weighted approval ratings (0-100%). Determines if decisions meet the 90% approval threshold for deployment.

## Role

- **Type**: Consultant (subagent)
- **Reports To**: Strategist
- **Collaborates With**: Designer, Librarian
- **Provides Input To**: Strategist

## Capabilities

### Core Functions
1. **Approval Analysis** - Calculate weighted approval percentage
2. **Risk Assessment** - Identify and rate risks
3. **Weighted Scoring** - Score feasibility, risk, complexity, resources
4. **Guardrail Enforcement** - Enforce hard requirements

### Approval Categories
- `feasibility` (30% weight)
- `risk` (30% weight)
- `complexity` (20% weight)
- `resources` (20% weight)

## Workflows

### Primary Workflows
1. **Approval Analysis** - Calculate approval rating
2. **Risk Assessment** - Identify risks and mitigations
3. **Weighted Scoring** - Score all categories
4. **Guardrail Enforcement** - Verify hard requirements

### Triggers
- Strategist deployment
- Approval request

## Directory Structure

```
OR4CL3/
├── prompt.md              # Agent behavior definition
├── seo-metadata.json      # SEO and RAG configuration
├── rag-manifest.json      # RAG ingestion rules
├── index.md              # This file
├── knowledge/            # RAG-ingestible content
│   ├── capabilities.md
│   └── workflows.md
├── consultations/        # Approval records
│   └── {DECISION_ID}/
└── approval-patterns/    # Historical approval data
```

## Key Relationships

```
Strategist → deploys → Oracle
Oracle → rates → Decisions
Oracle → approves/rejects → Deployment
```

## RAG Configuration

- **Auto-Ingest**: Yes
- **Chunk Size**: 1000 tokens
- **Embedding Model**: text-embedding-3-large
- **Search Priority**: Critical

## Version

- **Current**: 3.0.0
- **Last Updated**: 2026-02-19

---

*Part of the P4NTH30N Agent Architecture*

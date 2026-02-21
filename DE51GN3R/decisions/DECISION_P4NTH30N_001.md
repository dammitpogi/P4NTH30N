---
decisionId: DECISION_P4NTH30N_001
title: Standardized Agent Directory Structure for P4NTH30N
status: Approved
approvalRating: 90%
category: Architecture
priority: Critical
---

# Decision: Standardized Agent Directory Structure

## Overview

Establish standardized directory structure for all 8 P4NTH30N agents with SEO metadata, RAG configuration, and proper organization.

## Agents Affected

- DE51GN3R (designer)
- EXPL0R3R (explorer)
- F0RGE (forgewright)
- LIBRAR14N (librarian)
- OP3NF1XER (openfixer)
- OR4CL3 (oracle)
- STR4TEG15T (strategist)
- W1NDF1XER (windfixer)

## Directory Structure

```
{AGENT}/
├── index.md              # Human-readable overview
├── prompt.md             # Agent behavior definition
├── seo-metadata.json     # SEO and RAG configuration
├── rag-manifest.json     # RAG ingestion rules
├── knowledge/            # RAG-ingestible content
├── consultations/        # Consultation records
├── decisions/           # Decision storage
└── patterns/ or deployments/  # Agent-specific resources
```

## Components

### 1. SEO Metadata (seo-metadata.json)
- Agent identity (name, standardName, role, category)
- SEO fields (title, description, keywords, tags, semanticTopics)
- RAG configuration (ingestOnUpdate, chunkSize, embeddingModel)
- Relationships (reportsTo, collaboratesWith, etc.)

### 2. RAG Manifest (rag-manifest.json)
- Ingestion rules (watchPatterns, excludePatterns)
- Embedding configuration
- Search configuration
- Metadata schema

### 3. Knowledge Base (knowledge/)
- capabilities.md
- workflows.md
- Additional RAG-ingestible content

## Approval

- **Oracle Rating**: 90%
- **Designer Approval**: Complete
- **Status**: Approved for Implementation

## Action Items

- [x] Create directory structure
- [x] Create seo-metadata.json files
- [x] Create rag-manifest.json files
- [x] Create index.md files
- [x] Create knowledge/ directories
- [ ] Standardize subdirectory naming
- [ ] Create initial knowledge documents

## Related Decisions

- DECISION_P4NTH30N_002: Agent Prompt and Knowledge Deployment

---

*Created: 2026-02-19*
*Location: C:\P4NTH30N\{AGENT}\decisions\*

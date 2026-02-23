---
type: decision
id: DECISION_108
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.767Z'
last_reviewed: '2026-02-23T01:31:15.767Z'
keywords:
  - decision108
  - librarian
  - memory
  - system
  - for
  - rag
  - fallback
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - specification
  - requirements
  - technical
  - details
  - core
  - identification
  - status
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: DECISION_108 **Category**: INFRA **Status**: Approved
  **Priority**: High **Date**: 2026-02-22 **Oracle Approval**: 82% (Models: Kimi
  K2.5 - analysis) **Designer Approval**: 95% (Models: Kimi K2.5 - full
  specification)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_108.md
---
# DECISION_108: Librarian Memory System for RAG Fallback

**Decision ID**: DECISION_108
**Category**: INFRA
**Status**: Approved
**Priority**: High
**Date**: 2026-02-22
**Oracle Approval**: 82% (Models: Kimi K2.5 - analysis)
**Designer Approval**: 95% (Models: Kimi K2.5 - full specification)

---

## Executive Summary

When the RAG system is unavailable, the Pantheon loses access to institutional memory. This decision establishes a Librarian-operated fallback memory system that organizes local documents into a searchable structure. The system includes a sweep command that normalizes documents, builds indexes, and prepares content for eventual RAG re-ingestion. Librarians can search this structured memory when RAG is down, ensuring continuity of knowledge access.

**Current Problem**:
- RAG downtime leaves agents without institutional memory access
- Documents exist but are not organized for efficient Librarian search
- No standardized metadata schema for document discovery
- No automated way to prepare documents for RAG ingestion
- Knowledge gaps occur during RAG outages

**Proposed Solution**:
- Create `STR4TEG15T/memory/` directory with organized subdirectories
- Implement standardized YAML frontmatter metadata schema
- Build sweep command (TypeScript/Bun) that scans, normalizes, and indexes documents
- Generate keyword-index.json and metadata-table.csv for fast search
- Maintain RAG-ready format for seamless re-ingestion when RAG recovers

---

## Background

### Current State
The P4NTH30N system has extensive documentation scattered across multiple directories:
- `STR4TEG15T/decisions/` - 100+ decision documents
- `STR4TEG15T/consultations/` - Oracle and Designer consultations
- `STR4TEG15T/canon/` - Proven patterns and learnings
- `STR4TEG15T/manifest/` - Narrative change tracking
- `STR4TEG15T/speech/` - Speechify-compatible narrative logs

The RAG system (rag-server) provides vector search when available, but when it's down, agents have no fallback for accessing institutional knowledge. DECISION_086 established agent documentation standards, but we need a resilient fallback for when RAG is unavailable.

### Desired State
A self-contained memory system that:
- Organizes all documents with standardized metadata
- Provides fast keyword and metadata search without RAG
- Can be searched by Librarians during RAG outages
- Automatically prepares content for RAG re-ingestion
- Maintains indexes that are always query-ready

---

## Specification

### Requirements

1. **REQ-001**: Directory Structure
   - **Priority**: Must
   - **Acceptance Criteria**: Create `STR4TEG15T/memory/` with decisions/, logs/, research/, indexes/, tools/ subdirectories

2. **REQ-002**: Metadata Schema
   - **Priority**: Must
   - **Acceptance Criteria**: All normalized documents include YAML frontmatter with type, id, category, status, keywords, roles, summary

3. **REQ-003**: Sweep Command
   - **Priority**: Must
   - **Acceptance Criteria**: TypeScript/Bun CLI tool that scans sources, normalizes documents, builds indexes, generates reports

4. **REQ-004**: Search Indexes
   - **Priority**: Must
   - **Acceptance Criteria**: keyword-index.json (inverted index) and metadata-table.csv (flat metadata) generated on each sweep

5. **REQ-005**: Librarian Integration
   - **Priority**: Should
   - **Acceptance Criteria**: Librarian agent can query memory system when RAG fails; results include confidence scores

6. **REQ-006**: RAG Preparation
   - **Priority**: Should
   - **Acceptance Criteria**: Normalized documents ready for RAG ingestion; stable document IDs for chunking

### Technical Details

**Directory Structure**:
```
STR4TEG15T/memory/
├── decisions/              # Normalized decision documents
├── logs/                   # Chronological event logs (YYYY/MM/DD/)
├── research/               # Synthesized external references
├── indexes/                # Computed search indexes
│   ├── keyword-index.json  # Inverted keyword index
│   ├── metadata-table.csv  # Flattened metadata
│   └── cache/
│       └── last-sweep.json
├── tools/                  # Sweep command and utilities
│   ├── sweep.ts            # Main CLI entry
│   ├── types.ts            # TypeScript definitions
│   ├── schema.ts           # Metadata schema validation
│   ├── parser.ts           # YAML/markdown parser
│   ├── normalizers/        # Document normalizers
│   │   ├── decision.ts
│   │   ├── log.ts
│   │   └── research.ts
│   ├── indexers/           # Index builders
│   │   ├── keyword.ts
│   │   └── metadata.ts
│   └── searcher.ts         # Search interface
└── README.md
```

**Metadata Schema (YAML Frontmatter)**:
```yaml
---
# Core Identification
type: decision | log | research | tool
id: DECISION_001 | 2025-02-22-001
category: architecture | implementation | bugfix | research | event

# Status & Lifecycle
status: active | deprecated | superseded | draft
version: 1.0.0
created_at: 2025-02-22T14:30:00Z
last_reviewed: 2025-02-22T14:30:00Z

# Content Classification
keywords: [mongodb, replication, failover]
roles: [librarian, oracle, fixer, windfixer]

# Source Tracking
source:
  type: decision | log_entry | web_search
  original_path: STR4TEG15T/decisions/DECISION_001.md

# Summary
summary: >
  Brief description optimized for retrieval
  and relevance scoring.
---
```

**Sweep Command Interface**:
```bash
# Full sweep - rebuild all indexes
bun run sweep --full

# Incremental sweep - only changed documents
bun run sweep

# Sweep specific source
bun run sweep --source decisions

# Validate indexes
bun run sweep --validate

# Dry run
bun run sweep --dry-run
```

**Index Formats**:

keyword-index.json:
```json
{
  "mongodb": {
    "documents": ["DECISION_042", "DECISION_045"],
    "frequency": 15,
    "lastUpdated": "2025-02-22T14:30:00Z"
  }
}
```

metadata-table.csv:
```csv
id,type,category,status,created_at,keywords,roles,summary
DECISION_001,decision,architecture,active,2025-02-22,"[mongodb,auth]","[oracle,librarian]",Brief description...
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-001 | Create memory directory structure | OpenFixer | Pending | P0 |
| ACT-002 | Implement TypeScript types and schema | OpenFixer | Pending | P0 |
| ACT-003 | Build YAML frontmatter parser | OpenFixer | Pending | P0 |
| ACT-004 | Create decision normalizer | OpenFixer | Pending | P0 |
| ACT-005 | Implement keyword indexer | OpenFixer | Pending | P0 |
| ACT-006 | Build metadata table generator | OpenFixer | Pending | P0 |
| ACT-007 | Create sweep command CLI | OpenFixer | Pending | P0 |
| ACT-008 | Implement search interface | OpenFixer | Pending | P1 |
| ACT-009 | Add Librarian integration | OpenFixer | Pending | P1 |
| ACT-010 | Write tests and documentation | OpenFixer | Pending | P1 |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_086 (Agent Documentation Standards - provides metadata patterns)
- **Related**: DECISION_087 (Sub-Decision Authority), RAG-001 (RAG Infrastructure)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Metadata inconsistency | Medium | High | Schema validation with warnings; minimal required fields |
| Index staleness | Medium | Medium | Incremental sweep mode; last-run marker; git hooks |
| Schema drift over time | Low | Medium | Include schema_version in frontmatter; migration steps |
| Search performance degradation | Medium | Low | Size caps; sharding by directory; optimization passes |
| Source duplication | Low | High | Store normalized copies with source_path and source_hash |

---

## Success Criteria

1. ✅ Sweep command runs successfully and generates indexes
2. ✅ All decisions from last 90 days searchable by keyword
3. ✅ Librarian can query memory system when RAG is unavailable
4. ✅ Query latency <100ms for keyword search, <500ms for full-text
5. ✅ Indexes updated within 1 hour of source changes
6. ✅ Normalized documents ready for RAG ingestion
7. ✅ >70% precision on top 5 search results

---

## Token Budget

- **Estimated**: 150K tokens
- **Model**: Claude 3.5 Sonnet (implementation)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On schema validation error**: Log warning, skip document, continue sweep
- **On parser error**: Delegate to @forgewright with document path and error
- **On index corruption**: Rebuild from scratch with --full flag
- **On search failure**: Fall back to file system grep scan
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No (logged) |
| Designer | Architecture sub-decisions | Medium | No (logged) |
| Librarian | Research sub-decisions | Medium | No (logged) |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-22
- **Models**: Kimi K2.5 (analysis)
- **Approval**: 82%
- **Key Findings**:
  - Feasibility: 8/10 - Well-understood problem, proven patterns
  - Risk: 4/10 - Low risk with proper mitigations
  - Complexity: 6/10 - Moderate complexity, manageable scope
  - Concerns: Metadata consistency, index freshness, schema drift
  - Recommendations: Schema guardrails, idempotent sweep, integrity checks, backups

### Designer Consultation
- **Date**: 2026-02-22
- **Models**: Kimi K2.5 (full specification)
- **Approval**: 95%
- **Key Deliverables**:
  - Complete directory structure specification
  - Detailed metadata schema with all fields
  - Component architecture diagram
  - 5-phase implementation plan (4 weeks)
  - Specific file list (30+ files)
  - Validation strategy with integrity checks
  - Fallback chain specification
  - Performance targets and optimization strategies
  - Security and compliance guidelines

---

## Implementation Phases

### Phase 1: Foundation (Week 1)
- Create directory structure
- Define TypeScript types and schema
- Implement YAML parser
- Build decision normalizer
- Validate first 10 decisions

### Phase 2: Indexing (Week 1-2)
- Build keyword extractor
- Implement inverted index builder
- Create metadata table generator
- Build sweep command v1
- Add index persistence

### Phase 3: Search Interface (Week 2)
- Implement search scoring
- Build query parser
- Add result ranking
- Create search CLI
- Add excerpt generation

### Phase 4: Integration (Week 3)
- Add search to Librarian skills
- Implement fallback detection
- Create result formatter
- Add confidence scoring

### Phase 5: Automation (Week 3-4)
- Add sweep to git hooks
- Implement incremental updates
- Create sweep scheduler
- Add index optimization

---

## Notes

- Builds on DECISION_086 metadata patterns
- Complements RAG system rather than replacing it
- Designed for resilience - works even when other systems fail
- Indexes are human-readable for debugging
- Document IDs are stable for RAG chunking consistency

---

*Decision DECISION_108*
*Librarian Memory System for RAG Fallback*
*2026-02-22*

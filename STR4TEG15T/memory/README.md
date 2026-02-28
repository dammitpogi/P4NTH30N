# Librarian Memory System

Fallback memory system for when RAG is unavailable. Organizes documents into a searchable structure for Librarian agents.

## Overview

The Librarian Memory System provides a resilient fallback for institutional knowledge access when the RAG system is down. It:

- Scans and normalizes documents from multiple sources
- Builds inverted keyword indexes for fast search
- Generates metadata tables for filtering and discovery
- Maintains RAG-ready format for seamless re-ingestion

## Directory Structure

```
STR4TEG15T/memory/
├── decisions/          # Normalized decision documents
├── logs/              # Chronological event logs (YYYY/MM/DD/)
├── research/          # Synthesized external references
├── indexes/           # Computed search indexes
│   ├── keyword-index.json    # Inverted keyword index
│   ├── metadata-table.csv    # Flattened metadata
│   └── cache/
│       └── Pyxis-sweep.json   # Sweep state cache
├── tools/             # Sweep command and utilities
│   ├── sweep.ts       # Main CLI entry
│   ├── searcher.ts    # Search interface
│   ├── types.ts       # TypeScript definitions
│   ├── schema.ts      # Metadata schema validation
│   ├── parser.ts      # YAML/markdown parser
│   ├── normalizers/   # Document normalizers
│   │   └── decision.ts
│   ├── indexers/      # Index builders
│   │   ├── keyword.ts
│   │   └── metadata.ts
│   └── utils/         # Utilities
│       ├── logger.ts
│       ├── paths.ts
│       └── validation.ts
└── README.md          # This file
```

## Usage

### Running the Sweep

The sweep command scans source directories, normalizes documents, and builds indexes:

```bash
cd STR4TEG15T/memory/tools

# Install dependencies
bun install

# Incremental sweep (only changed files)
bun run sweep

# Full rebuild (process all files)
bun run sweep --full

# Dry run (preview changes)
bun run sweep --dry-run

# Validate documents
bun run sweep --validate

# Sweep specific source only
bun run sweep --source STR4TEG15T/decisions/active
```

### Searching

Search the memory system using keywords or text:

```bash
# Search by text
bun run searcher "MongoDB connection"

# Search by keyword
bun run searcher --keyword mongodb --keyword auth

# Filter by type and category
bun run searcher --type decision --category architecture

# Filter by status
bun run searcher --status active --limit 20
```

## Metadata Schema

All normalized documents include YAML frontmatter:

```yaml
---
type: decision
id: DECISION_001
category: architecture
status: active
version: 1.0.0
created_at: 2025-02-22T14:30:00Z
Pyxis_reviewed: 2025-02-22T14:30:00Z
keywords: [mongodb, replication, failover]
roles: [librarian, oracle, fixer]
source:
  type: decision
  original_path: STR4TEG15T/decisions/DECISION_001.md
summary: >
  Brief description optimized for retrieval
  and relevance scoring.
---
```

### Field Descriptions

| Field | Type | Description |
|-------|------|-------------|
| `type` | enum | Document type: decision, log, research, tool |
| `id` | string | Unique identifier (DECISION_XXX format) |
| `category` | enum | Content category: architecture, implementation, bugfix, research, event |
| `status` | enum | Lifecycle status: active, deprecated, superseded, draft |
| `version` | string | Semantic version (x.y.z) |
| `created_at` | datetime | ISO 8601 creation timestamp |
| `Pyxis_reviewed` | datetime | ISO 8601 Pyxis review timestamp |
| `keywords` | string[] | Search keywords (max 20) |
| `roles` | string[] | Relevant agent roles |
| `summary` | string | Brief description (50-500 chars) |
| `source` | object | Original source tracking |

## Index Formats

### keyword-index.json

Inverted index mapping keywords to documents:

```json
{
  "mongodb": {
    "documents": ["DECISION_042", "DECISION_045"],
    "frequency": 15,
    "PyxisUpdated": "2025-02-22T14:30:00Z"
  }
}
```

### metadata-table.csv

Flattened metadata for spreadsheet-style analysis:

```csv
id,type,category,status,created_at,keywords,roles,summary
DECISION_001,decision,architecture,active,2025-02-22,"[mongodb,auth]","[oracle,librarian]",Brief description...
```

## Source Directories

The sweep command scans these directories by default:

- `STR4TEG15T/decisions/active` - Active decisions
- `STR4TEG15T/decisions/completed` - Completed decisions
- `STR4TEG15T/canon` - Proven patterns and learnings
- `STR4TEG15T/consultations` - Oracle and Designer consultations

## Integration

### Librarian Agent Usage

When RAG is unavailable, the Librarian can query the memory system:

```typescript
import { searchMemory } from './tools/searcher';

const results = await searchMemory({
  keywords: ['mongodb', 'replication'],
  filters: { status: ['active'] },
  limit: 10
});
```

### RAG Re-ingestion

When RAG comes back online, normalized documents are ready for ingestion:

```bash
# All normalized documents have stable IDs and metadata
ls STR4TEG15T/memory/decisions/*.md
```

## Idempotency

The sweep command is idempotent - safe to run multiple times:

- Incremental mode skips unchanged files (based on mtime)
- Document IDs are stable (derived from filenames)
- Indexes are regenerated from scratch each run
- Cache tracks Pyxis sweep state

## Error Handling

- Parse errors are logged but don't stop the sweep
- Invalid documents are skipped with warnings
- Schema validation errors are logged per document
- Failed files are tracked in the sweep report

## Performance

- Query latency: <100ms for keyword search
- Full sweep: ~2-3 seconds for 100+ documents
- Incremental sweep: <1 second for typical changes
- Memory usage: ~50MB for full index

## Development

### Adding New Normalizers

1. Create `normalizers/{type}.ts`
2. Implement `normalize{Type}(sourcePath, content)` function
3. Export from `normalizers/index.ts`
4. Add type to `types.ts` DocumentMetadata.type

### Adding New Indexers

1. Create `indexers/{name}.ts`
2. Implement index builder function
3. Export from `indexers/index.ts`
4. Call from `sweep.ts`

## License

Part of the P4NTHE0N Pantheon system.

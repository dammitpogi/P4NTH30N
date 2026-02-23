---
agent: strategist
type: handoff
decision: DECISION_108
created: 2026-02-22
status: ready
priority: high
---

# OpenFixer Handoff: DECISION_108 - Librarian Memory System

## Mission
Implement the Librarian Memory System for RAG fallback. This system organizes documents into a searchable structure when RAG is unavailable.

## Context
When RAG is down, Librarians need to search through local logs and documents. We need:
1. A document organization structure in `STR4TEG15T/memory/`
2. A sweep command that organizes documents
3. RAG-ready preparation for when RAG comes back online

## Deliverables

### 1. Directory Structure
Create in `STR4TEG15T/memory/`:
```
memory/
├── decisions/          # Normalized decision documents
├── logs/              # Chronological event logs (YYYY/MM/DD/)
├── research/          # Synthesized external references
├── indexes/           # Computed search indexes
│   ├── keyword-index.json
│   ├── metadata-table.csv
│   └── cache/
│       └── last-sweep.json
├── tools/             # Sweep command and utilities
│   ├── package.json
│   ├── tsconfig.json
│   ├── sweep.ts       # Main CLI entry
│   ├── types.ts       # TypeScript definitions
│   ├── schema.ts      # Metadata schema validation
│   ├── parser.ts      # YAML/markdown parser
│   ├── normalizers/
│   │   ├── index.ts
│   │   ├── decision.ts
│   │   ├── log.ts
│   │   └── research.ts
│   ├── indexers/
│   │   ├── index.ts
│   │   ├── keyword.ts
│   │   └── metadata.ts
│   ├── searcher.ts    # Search interface
│   └── utils/
│       ├── logger.ts
│       ├── paths.ts
│       └── validation.ts
└── README.md
```

### 2. TypeScript Types (types.ts)
```typescript
export interface DocumentMetadata {
  type: 'decision' | 'log' | 'research' | 'tool';
  id: string;
  category: string;
  status: 'active' | 'deprecated' | 'superseded' | 'draft';
  version: string;
  created_at: string;
  last_reviewed: string;
  keywords: string[];
  roles: string[];
  summary: string;
  source?: {
    type: string;
    original_path: string;
  };
}

export interface NormalizedDocument {
  metadata: DocumentMetadata;
  content: string;
  raw: string;
}

export interface KeywordIndex {
  [keyword: string]: {
    documents: string[];
    frequency: number;
    lastUpdated: string;
  };
}

export interface SearchQuery {
  text?: string;
  keywords?: string[];
  filters?: {
    type?: string[];
    category?: string[];
    status?: string[];
    roles?: string[];
  };
  limit?: number;
}

export interface SearchResult {
  id: string;
  type: string;
  score: number;
  metadata: DocumentMetadata;
  excerpt: string;
}
```

### 3. Metadata Schema (schema.ts)
Use Zod for validation:
```typescript
import { z } from 'zod';

export const MetadataSchema = z.object({
  type: z.enum(['decision', 'log', 'research', 'tool']),
  id: z.string().regex(/^[A-Z_0-9-]+$/),
  category: z.enum(['architecture', 'implementation', 'bugfix', 'research', 'event']),
  status: z.enum(['active', 'deprecated', 'superseded', 'draft']),
  version: z.string().regex(/^\d+\.\d+\.\d+$/),
  created_at: z.string().datetime(),
  last_reviewed: z.string().datetime(),
  keywords: z.array(z.string().min(2).max(50)).max(20),
  roles: z.array(z.string()),
  summary: z.string().min(50).max(500),
  source: z.object({
    type: z.string(),
    original_path: z.string()
  }).optional()
});

export type Metadata = z.infer<typeof MetadataSchema>;
```

### 4. YAML Frontmatter Parser (parser.ts)
Parse documents with YAML frontmatter:
```typescript
import matter from 'gray-matter';

export function parseDocument(content: string): { metadata: any; content: string } {
  const parsed = matter(content);
  return {
    metadata: parsed.data,
    content: parsed.content
  };
}

export function serializeDocument(metadata: any, content: string): string {
  return matter.stringify(content, metadata);
}
```

### 5. Decision Normalizer (normalizers/decision.ts)
Extract and normalize decision documents:
```typescript
export function normalizeDecision(sourcePath: string, content: string): NormalizedDocument {
  const { metadata, content: body } = parseDocument(content);
  
  // Extract decision ID from filename or content
  const decisionId = extractDecisionId(sourcePath, body);
  
  // Extract keywords from content
  const keywords = extractKeywords(body);
  
  // Extract summary from Executive Summary section
  const summary = extractSummary(body);
  
  const normalized: DocumentMetadata = {
    type: 'decision',
    id: decisionId,
    category: metadata.category || 'architecture',
    status: mapStatus(metadata.status),
    version: metadata.version || '1.0.0',
    created_at: metadata.date || new Date().toISOString(),
    last_reviewed: new Date().toISOString(),
    keywords,
    roles: metadata.roles || ['librarian', 'oracle'],
    summary,
    source: {
      type: 'decision',
      original_path: sourcePath
    }
  };
  
  return {
    metadata: normalized,
    content: body,
    raw: content
  };
}
```

### 6. Keyword Indexer (indexers/keyword.ts)
Build inverted keyword index:
```typescript
export function buildKeywordIndex(documents: NormalizedDocument[]): KeywordIndex {
  const index: KeywordIndex = {};
  
  for (const doc of documents) {
    // Index from keywords field
    for (const keyword of doc.metadata.keywords) {
      addToIndex(index, keyword.toLowerCase(), doc.metadata.id);
    }
    
    // Index from content (extract additional keywords)
    const contentWords = extractWords(doc.content);
    for (const word of contentWords) {
      if (isSignificant(word)) {
        addToIndex(index, word.toLowerCase(), doc.metadata.id);
      }
    }
  }
  
  return index;
}

function addToIndex(index: KeywordIndex, keyword: string, docId: string) {
  if (!index[keyword]) {
    index[keyword] = {
      documents: [],
      frequency: 0,
      lastUpdated: new Date().toISOString()
    };
  }
  
  if (!index[keyword].documents.includes(docId)) {
    index[keyword].documents.push(docId);
  }
  
  index[keyword].frequency++;
}
```

### 7. Metadata Table Generator (indexers/metadata.ts)
Generate CSV metadata table:
```typescript
export function generateMetadataTable(documents: NormalizedDocument[]): string {
  const headers = ['id', 'type', 'category', 'status', 'created_at', 'keywords', 'roles', 'summary'];
  
  const rows = documents.map(doc => [
    doc.metadata.id,
    doc.metadata.type,
    doc.metadata.category,
    doc.metadata.status,
    doc.metadata.created_at,
    JSON.stringify(doc.metadata.keywords),
    JSON.stringify(doc.metadata.roles),
    doc.metadata.summary.replace(/"/g, '""')
  ]);
  
  return [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
}
```

### 8. Sweep Command (sweep.ts)
Main CLI tool:
```typescript
#!/usr/bin/env bun
import { parseArgs } from 'util';
import { normalizeDecision } from './normalizers/decision';
import { buildKeywordIndex } from './indexers/keyword';
import { generateMetadataTable } from './indexers/metadata';
import { parseDocument } from './parser';

interface SweepOptions {
  full: boolean;
  source?: string;
  validate: boolean;
  dryRun: boolean;
}

async function sweep(options: SweepOptions) {
  const sources = [
    'STR4TEG15T/decisions/active',
    'STR4TEG15T/decisions/completed',
    'STR4TEG15T/canon'
  ];
  
  const documents: NormalizedDocument[] = [];
  
  // Scan source directories
  for (const source of sources) {
    const files = await scanDirectory(source, '.md');
    
    for (const file of files) {
      const content = await Bun.file(file).text();
      
      try {
        const normalized = normalizeDecision(file, content);
        documents.push(normalized);
      } catch (error) {
        console.warn(`Failed to normalize ${file}:`, error);
      }
    }
  }
  
  if (options.dryRun) {
    console.log(`Would process ${documents.length} documents`);
    return;
  }
  
  // Write normalized documents
  for (const doc of documents) {
    const outputPath = `STR4TEG15T/memory/decisions/${doc.metadata.id}.md`;
    const serialized = serializeDocument(doc.metadata, doc.content);
    await Bun.write(outputPath, serialized);
  }
  
  // Build indexes
  const keywordIndex = buildKeywordIndex(documents);
  await Bun.write(
    'STR4TEG15T/memory/indexes/keyword-index.json',
    JSON.stringify(keywordIndex, null, 2)
  );
  
  const metadataTable = generateMetadataTable(documents);
  await Bun.write(
    'STR4TEG15T/memory/indexes/metadata-table.csv',
    metadataTable
  );
  
  // Update cache
  await Bun.write(
    'STR4TEG15T/memory/indexes/cache/last-sweep.json',
    JSON.stringify({
      timestamp: new Date().toISOString(),
      documentCount: documents.length,
      sources: sources
    }, null, 2)
  );
  
  console.log(`Sweep complete: ${documents.length} documents indexed`);
}

// CLI entry
const { values } = parseArgs({
  args: Bun.argv,
  options: {
    full: { type: 'boolean', default: false },
    source: { type: 'string' },
    validate: { type: 'boolean', default: false },
    'dry-run': { type: 'boolean', default: false }
  },
  strict: true,
  allowPositionals: true
});

sweep({
  full: values.full,
  source: values.source,
  validate: values.validate,
  dryRun: values['dry-run']
});
```

### 9. Search Interface (searcher.ts)
Query the memory system:
```typescript
export async function searchMemory(query: SearchQuery): Promise<SearchResult[]> {
  // Load indexes
  const keywordIndex: KeywordIndex = await Bun.file('STR4TEG15T/memory/indexes/keyword-index.json').json();
  const metadataCsv = await Bun.file('STR4TEG15T/memory/indexes/metadata-table.csv').text();
  
  const results: SearchResult[] = [];
  
  // Keyword search
  if (query.keywords) {
    for (const keyword of query.keywords) {
      const entry = keywordIndex[keyword.toLowerCase()];
      if (entry) {
        for (const docId of entry.documents) {
          results.push({
            id: docId,
            type: 'decision',
            score: entry.frequency,
            metadata: await loadMetadata(docId),
            excerpt: await generateExcerpt(docId, keyword)
          });
        }
      }
    }
  }
  
  // Sort and limit
  results.sort((a, b) => b.score - a.score);
  return results.slice(0, query.limit || 10);
}
```

### 10. Package Configuration (package.json)
```json
{
  "name": "librarian-memory",
  "version": "1.0.0",
  "description": "Librarian Memory System for RAG Fallback",
  "type": "module",
  "scripts": {
    "sweep": "bun run sweep.ts",
    "sweep:full": "bun run sweep.ts --full",
    "search": "bun run search.ts",
    "validate": "bun run sweep.ts --validate",
    "build": "bun build sweep.ts --compile --outfile ../sweep.exe"
  },
  "dependencies": {
    "gray-matter": "^4.0.3",
    "zod": "^3.22.4"
  },
  "devDependencies": {
    "@types/bun": "latest"
  }
}
```

### 11. README.md
Document the system:
```markdown
# Librarian Memory System

Fallback memory system for when RAG is unavailable.

## Usage

```bash
# Run sweep to update indexes
cd STR4TEG15T/memory/tools
bun run sweep

# Full rebuild
bun run sweep --full

# Search
bun run search "MongoDB connection"
```

## Directory Structure

- `decisions/` - Normalized decision documents
- `logs/` - Chronological event logs
- `research/` - Synthesized research
- `indexes/` - Search indexes
  - `keyword-index.json` - Inverted keyword index
  - `metadata-table.csv` - Flat metadata table
```

## Implementation Order

1. Create directory structure
2. Write package.json and tsconfig.json
3. Implement types.ts
4. Implement schema.ts with Zod
5. Implement parser.ts with gray-matter
6. Implement normalizers/decision.ts
7. Implement indexers/keyword.ts and metadata.ts
8. Implement sweep.ts CLI
9. Implement searcher.ts
10. Write tests
11. Create README.md

## Validation

- Sweep command runs without errors
- keyword-index.json is valid JSON
- metadata-table.csv is valid CSV
- At least 10 decisions are normalized
- Search returns results

## Notes

- Use Bun runtime
- Keep indexes human-readable
- Handle parse errors gracefully
- Log all operations
- Make sweep idempotent

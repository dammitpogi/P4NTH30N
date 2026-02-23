#!/usr/bin/env bun
import { parseArgs } from 'util';
import type { KeywordIndex, SearchQuery, SearchResult, DocumentMetadata } from './types';
import { PATHS } from './utils/paths';
import { info, error } from './utils/logger';

async function loadKeywordIndex(): Promise<KeywordIndex> {
  const indexPath = `${PATHS.indexes}/keyword-index.json`;
  try {
    const file = Bun.file(indexPath);
    if (await file.exists()) {
      return await file.json() as KeywordIndex;
    }
  } catch (e) {
    error(`Failed to load keyword index from ${indexPath}`);
  }
  return {};
}

async function loadMetadataTable(): Promise<Map<string, DocumentMetadata>> {
  // Try JSON first (easier to parse)
  const jsonPath = `${PATHS.indexes}/metadata-index.json`;
  const metadataMap = new Map<string, DocumentMetadata>();
  
  try {
    const file = Bun.file(jsonPath);
    if (await file.exists()) {
      const data = await file.json() as Record<string, DocumentMetadata>;
      for (const [id, metadata] of Object.entries(data)) {
        metadataMap.set(id, metadata);
      }
      return metadataMap;
    }
  } catch (e) {
    error(`Failed to load metadata index from ${jsonPath}`);
  }
  
  // Fallback to CSV
  const csvPath = `${PATHS.indexes}/metadata-table.csv`;
  try {
    const file = Bun.file(csvPath);
    if (await file.exists()) {
      const content = await file.text();
      const lines = content.split('\n').filter(l => l.trim());
      
      // Skip header
      for (let i = 1; i < lines.length; i++) {
        const line = lines[i];
        // Simple CSV parsing (doesn't handle all edge cases but works for our format)
        const parts: string[] = [];
        let current = '';
        let inQuotes = false;
        
        for (const char of line) {
          if (char === '"') {
            inQuotes = !inQuotes;
          } else if (char === ',' && !inQuotes) {
            parts.push(current);
            current = '';
          } else {
            current += char;
          }
        }
        parts.push(current);
        
        if (parts.length >= 8) {
          try {
            metadataMap.set(parts[0], {
              id: parts[0],
              type: parts[1] as DocumentMetadata['type'],
              category: parts[2],
              status: parts[3] as DocumentMetadata['status'],
              created_at: parts[4],
              last_reviewed: parts[4],
              keywords: JSON.parse(parts[5]),
              roles: JSON.parse(parts[6]),
              summary: parts[7].replace(/^"|"$/g, '').replace(/""/g, '"'),
              version: '1.0.0'
            });
          } catch (e) {
            // Skip malformed rows
          }
        }
      }
    }
  } catch (e) {
    error(`Failed to load metadata table from ${csvPath}`);
  }
  
  return metadataMap;
}

async function loadDocumentContent(docId: string): Promise<string> {
  const docPath = `${PATHS.decisions}/${docId}.md`;
  try {
    const file = Bun.file(docPath);
    if (await file.exists()) {
      return await file.text();
    }
  } catch {
    // Document not found
  }
  return '';
}

function generateExcerpt(content: string, query: string, maxLength: number = 200): string {
  const lowerContent = content.toLowerCase();
  const lowerQuery = query.toLowerCase();
  const index = lowerContent.indexOf(lowerQuery);
  
  if (index === -1) {
    return content.slice(0, maxLength).trim() + (content.length > maxLength ? '...' : '');
  }
  
  const start = Math.max(0, index - 50);
  const end = Math.min(content.length, index + query.length + 150);
  let excerpt = content.slice(start, end);
  
  if (start > 0) excerpt = '...' + excerpt;
  if (end < content.length) excerpt = excerpt + '...';
  
  return excerpt;
}

export async function searchMemory(query: SearchQuery): Promise<SearchResult[]> {
  // Load indexes
  const keywordIndex = await loadKeywordIndex();
  const metadataTable = await loadMetadataTable();
  
  const results: SearchResult[] = [];
  const seenDocs = new Set<string>();
  
  // Keyword search
  if (query.keywords) {
    for (const keyword of query.keywords) {
      const entry = keywordIndex[keyword.toLowerCase()];
      if (entry) {
        for (const docId of entry.documents) {
          if (seenDocs.has(docId)) continue;
          seenDocs.add(docId);
          
          const metadata = metadataTable.get(docId);
          if (!metadata) continue;
          
          // Apply filters
          if (query.filters?.type?.length && !query.filters.type.includes(metadata.type)) continue;
          if (query.filters?.category?.length && !query.filters.category.includes(metadata.category)) continue;
          if (query.filters?.status?.length && !query.filters.status.includes(metadata.status)) continue;
          
          const content = await loadDocumentContent(docId);
          const excerpt = generateExcerpt(content, keyword);
          
          results.push({
            id: docId,
            type: metadata.type,
            score: entry.frequency,
            metadata,
            excerpt
          });
        }
      }
    }
  }
  
  // Text search (simple contains check)
  if (query.text) {
    const searchTerms = query.text.toLowerCase().split(/\s+/);
    
    for (const [docId, metadata] of metadataTable) {
      if (seenDocs.has(docId)) continue;
      
      const content = await loadDocumentContent(docId);
      const lowerContent = content.toLowerCase();
      
      let matches = 0;
      for (const term of searchTerms) {
        if (lowerContent.includes(term) || 
            metadata.summary.toLowerCase().includes(term) ||
            metadata.keywords.some(k => k.includes(term))) {
          matches++;
        }
      }
      
      if (matches > 0) {
        seenDocs.add(docId);
        
        // Apply filters
        if (query.filters?.type?.length && !query.filters.type.includes(metadata.type)) continue;
        if (query.filters?.category?.length && !query.filters.category.includes(metadata.category)) continue;
        if (query.filters?.status?.length && !query.filters.status.includes(metadata.status)) continue;
        
        const excerpt = generateExcerpt(content, query.text);
        
        results.push({
          id: docId,
          type: metadata.type,
          score: matches,
          metadata,
          excerpt
        });
      }
    }
  }
  
  // Sort by score descending
  results.sort((a, b) => b.score - a.score);
  
  // Apply limit
  return results.slice(0, query.limit || 10);
}

// CLI entry point
async function main() {
  const { values, positionals } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      keyword: { type: 'string', multiple: true },
      type: { type: 'string', multiple: true },
      category: { type: 'string', multiple: true },
      status: { type: 'string', multiple: true },
      limit: { type: 'string', default: '10' }
    },
    strict: true,
    allowPositionals: true
  });
  
  const searchText = positionals.join(' ');
  
  if (!searchText && !values.keyword?.length) {
    console.log('Usage: bun run searcher.ts [options] <search text>');
    console.log('');
    console.log('Options:');
    console.log('  --keyword <kw>     Search by keyword (can specify multiple)');
    console.log('  --type <type>      Filter by type');
    console.log('  --category <cat>   Filter by category');
    console.log('  --status <status>  Filter by status');
    console.log('  --limit <n>        Limit results (default: 10)');
    console.log('');
    console.log('Examples:');
    console.log('  bun run searcher.ts "MongoDB connection"');
    console.log('  bun run searcher.ts --keyword mongodb --keyword auth');
    console.log('  bun run searcher.ts --type decision --category architecture');
    process.exit(0);
  }
  
  const query: SearchQuery = {
    text: searchText || undefined,
    keywords: values.keyword,
    filters: {
      type: values.type,
      category: values.category,
      status: values.status
    },
    limit: parseInt(values.limit, 10)
  };
  
  info('Searching memory', { query: searchText || values.keyword?.join(', ') });
  
  const results = await searchMemory(query);
  
  console.log(`\n=== SEARCH RESULTS (${results.length} found) ===\n`);
  
  for (let i = 0; i < results.length; i++) {
    const r = results[i];
    console.log(`${i + 1}. ${r.id} (score: ${r.score})`);
    console.log(`   Type: ${r.type} | Category: ${r.metadata.category} | Status: ${r.metadata.status}`);
    console.log(`   Keywords: ${r.metadata.keywords.slice(0, 5).join(', ')}`);
    console.log(`   ${r.excerpt.slice(0, 150)}...`);
    console.log('');
  }
}

main().catch(err => {
  error('Search failed', { error: String(err) });
  process.exit(1);
});
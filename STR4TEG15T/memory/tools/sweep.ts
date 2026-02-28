#!/usr/bin/env bun
import { parseArgs } from 'util';
import { normalizeDecision } from './normalizers/decision';
import { buildKeywordIndex } from './indexers/keyword';
import { generateMetadataTable } from './indexers/metadata';
import { serializeDocument } from './parser';
import { info, warn, error } from './utils/logger';
import { PATHS, SOURCE_PATHS } from './utils/paths';
import type { NormalizedDocument, SweepCache } from './types';

interface SweepOptions {
  full: boolean;
  source?: string;
  validate: boolean;
  dryRun: boolean;
}

async function scanDirectory(dir: string, extension: string): Promise<string[]> {
  const files: string[] = [];
  
  try {
    const entries = await Array.fromAsync(Bun.file(dir).stream());
    // Use Bun's glob instead
    const glob = new Bun.Glob(`**/*${extension}`);
    for await (const file of glob.scan(dir)) {
      files.push(`${dir}/${file}`);
    }
  } catch (e) {
    // Directory might not exist, that's ok
  }
  
  return files;
}

async function loadCache(): Promise<SweepCache | null> {
  try {
    const cachePath = `${PATHS.cache}/last-sweep.json`;
    const cacheFile = Bun.file(cachePath);
    if (await cacheFile.exists()) {
      return await cacheFile.json() as SweepCache;
    }
  } catch {
    // Cache doesn't exist or is invalid
  }
  return null;
}

async function sweep(options: SweepOptions) {
  info('Starting sweep', { full: options.full, dryRun: options.dryRun });
  
  const sources = options.source 
    ? [options.source]
    : SOURCE_PATHS;
  
  const documents: NormalizedDocument[] = [];
  const processedFiles: string[] = [];
  const errors: string[] = [];
  
  // Load cache for incremental sweep
  const cache = options.full ? null : await loadCache();
  const lastSweepTime = cache?.timestamp ? new Date(cache.timestamp) : null;
  
  // Scan source directories
  for (const source of sources) {
    info(`Scanning ${source}`);
    
    try {
      const glob = new Bun.Glob('**/*.md');
      for await (const file of glob.scan(source)) {
        const filePath = `${source}/${file}`;
        
        // Check if file has been modified since last sweep
        if (lastSweepTime && !options.full) {
          try {
            const stat = await Bun.file(filePath).stat();
            if (stat.mtime && stat.mtime < lastSweepTime) {
              continue; // Skip unchanged files
            }
          } catch {
            // Can't stat file, process it anyway
          }
        }
        
        try {
          const content = await Bun.file(filePath).text();
          const normalized = normalizeDecision(filePath, content);
          documents.push(normalized);
          processedFiles.push(filePath);
          info(`Normalized ${normalized.metadata.id}`, { source: filePath });
        } catch (err) {
          const errorMsg = `Failed to normalize ${filePath}: ${err}`;
          warn(errorMsg);
          errors.push(errorMsg);
        }
      }
    } catch (e) {
      warn(`Could not scan ${source}`, { error: String(e) });
    }
  }
  
  info(`Processed ${documents.length} documents`, { errors: errors.length });
  
  if (options.dryRun) {
    console.log(`\n=== DRY RUN ===`);
    console.log(`Would process ${documents.length} documents`);
    console.log(`Sources: ${sources.join(', ')}`);
    console.log(`Documents: ${documents.map(d => d.metadata.id).join(', ')}`);
    return;
  }
  
  if (options.validate) {
    console.log(`\n=== VALIDATION ===`);
    let validCount = 0;
    for (const doc of documents) {
      const isValid = doc.metadata.id && doc.metadata.keywords.length > 0;
      if (isValid) validCount++;
      console.log(`${isValid ? '✓' : '✗'} ${doc.metadata.id}`);
    }
    console.log(`\nValidation: ${validCount}/${documents.length} valid`);
    return;
  }
  
  // Write normalized documents
  info('Writing normalized documents');
  for (const doc of documents) {
    const outputPath = `${PATHS.decisions}/${doc.metadata.id}.md`;
    const serialized = serializeDocument(doc.metadata, doc.content);
    await Bun.write(outputPath, serialized);
  }
  
  // Build indexes
  info('Building indexes');
  const keywordIndex = buildKeywordIndex(documents);
  await Bun.write(
    `${PATHS.indexes}/keyword-index.json`,
    JSON.stringify(keywordIndex, null, 2)
  );
  
  const metadataTable = generateMetadataTable(documents);
  await Bun.write(
    `${PATHS.indexes}/metadata-table.csv`,
    metadataTable
  );
  
  // Also write as JSON for easier parsing
  const metadataJson = Object.fromEntries(
    documents.map(d => [d.metadata.id, d.metadata])
  );
  await Bun.write(
    `${PATHS.indexes}/metadata-index.json`,
    JSON.stringify(metadataJson, null, 2)
  );
  
  // Update cache
  const newCache: SweepCache = {
    timestamp: new Date().toISOString(),
    documentCount: documents.length,
    sources: sources,
    processedFiles
  };
  
  await Bun.write(
    `${PATHS.cache}/last-sweep.json`,
    JSON.stringify(newCache, null, 2)
  );
  
  console.log(`\n=== SWEEP COMPLETE ===`);
  console.log(`Documents indexed: ${documents.length}`);
  console.log(`Keywords indexed: ${Object.keys(keywordIndex).length}`);
  console.log(`Errors: ${errors.length}`);
  console.log(`Cache: ${PATHS.cache}/last-sweep.json`);
  console.log(`Indexes: ${PATHS.indexes}/keyword-index.json, ${PATHS.indexes}/metadata-table.csv`);
}

// CLI entry
const { values } = parseArgs({
  args: Bun.argv.slice(2),
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
}).catch(err => {
  error('Sweep failed', { error: String(err) });
  process.exit(1);
});

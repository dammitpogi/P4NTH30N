/**
 * Main entry point for RAG Watcher
 * Coordinates file watching, parsing, validation, and ingestion
 */

import * as fs from 'fs/promises';
import * as path from 'path';
import { logger } from './logger.js';
import { parseDocument } from './parser.js';
import { validateDocument, formatValidationErrors } from './validator.js';
import { ingestDocument, type IngestionResult } from './ingester.js';
import { createDecisionWatcher, type FileEvent } from './watcher.js';
import { createGitIntegration } from './git.js';

// Configuration
interface Config {
  repoRoot: string;
  decisionsPath: string;
  watchMode: boolean;
  validateOnly: boolean;
  ingestOnly: boolean;
  logLevel: 'debug' | 'info' | 'warn' | 'error';
}

function parseArgs(): Config {
  const args = process.argv.slice(2);
  
  // Find repo root (default to P4NTHE0N)
  const repoRoot = process.env.P4NTHE0N_ROOT || 'c:\\P4NTHE0N';
  
  return {
    repoRoot,
    decisionsPath: path.join(repoRoot, 'STR4TEG15T', 'decisions'),
    watchMode: args.includes('--watch'),
    validateOnly: args.includes('--validate'),
    ingestOnly: args.includes('--ingest'),
    logLevel: (process.env.LOG_LEVEL as Config['logLevel']) || 'info',
  };
}

/**
 * Process a single file
 */
async function processFile(
  filePath: string,
  git: ReturnType<typeof createGitIntegration>
): Promise<IngestionResult> {
  try {
    logger.info(`Processing file: ${filePath}`);

    // Read file content
    const content = await fs.readFile(filePath, 'utf-8');

    // Parse document
    const relativePath = path.relative(config.repoRoot, filePath);
    const doc = parseDocument(content, relativePath);

    // Validate document
    const validation = validateDocument(doc);
    if (!validation.valid) {
      logger.warn(`Validation failed for ${filePath}`);
      logger.warn(formatValidationErrors(validation));
      
      if (validation.errors.length > 0) {
        return {
          success: false,
          error: `Validation failed: ${validation.errors.map(e => e.message).join(', ')}`,
        };
      }
    }

    if (validation.warnings.length > 0) {
      logger.warn(`Validation warnings for ${filePath}:`);
      logger.warn(formatValidationErrors(validation));
    }

    // Get git commit info
    const gitCommit = await git.getCommitHashForIngestion(filePath);

    // Ingest into RAG
    const result = await ingestDocument(doc, {
      gitCommit,
      timestamp: new Date().toISOString(),
    });

    if (result.success) {
      logger.info(`Successfully ingested: ${filePath}`, { documentId: result.documentId });
    } else {
      logger.error(`Failed to ingest: ${filePath}`, { error: result.error });
    }

    return result;
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    logger.error(`Error processing file: ${filePath}`, { error: errorMessage });
    return { success: false, error: errorMessage };
  }
}

/**
 * Handle file events from watcher
 */
async function handleFileEvents(
  events: FileEvent[],
  git: ReturnType<typeof createGitIntegration>
): Promise<void> {
  logger.info(`Handling ${events.length} file events`);

  for (const event of events) {
    if (event.type === 'unlink') {
      logger.info(`File deleted: ${event.path}`);
      // TODO: Handle deletion (remove from RAG)
      continue;
    }

    // Process add or change events
    const result = await processFile(event.path, git);
    
    if (!result.success) {
      logger.error(`Failed to process ${event.path}: ${result.error}`);
    }
  }
}

/**
 * Run batch ingestion on all decision files
 */
async function runBatchIngestion(config: Config): Promise<void> {
  logger.info('Starting batch ingestion...');

  const git = createGitIntegration(config.repoRoot);
  
  // Check if git repo
  if (!(await git.isRepo())) {
    logger.warn('Not a git repository, continuing without git integration');
  }

  // Find all markdown files in decisions directory
  const decisionsDir = config.decisionsPath;
  const files: string[] = [];

  async function findMarkdownFiles(dir: string): Promise<void> {
    try {
      const entries = await fs.readdir(dir, { withFileTypes: true });
      
      for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);
        
        if (entry.isDirectory()) {
          // Skip certain directories
          if (entry.name.startsWith('_') || 
              entry.name === 'node_modules' || 
              entry.name === '.git') {
            continue;
          }
          await findMarkdownFiles(fullPath);
        } else if (entry.isFile() && entry.name.endsWith('.md')) {
          files.push(fullPath);
        }
      }
    } catch (error) {
      logger.error(`Error reading directory: ${dir}`, { 
        error: error instanceof Error ? error.message : String(error) 
      });
    }
  }

  await findMarkdownFiles(decisionsDir);
  logger.info(`Found ${files.length} markdown files to process`);

  // Process each file
  let successCount = 0;
  let failCount = 0;

  for (const file of files) {
    const result = await processFile(file, git);
    
    if (result.success) {
      successCount++;
    } else {
      failCount++;
    }
  }

  logger.info(`Batch ingestion complete: ${successCount} succeeded, ${failCount} failed`);
}

/**
 * Run validation on all decision files
 */
async function runValidation(config: Config): Promise<void> {
  logger.info('Starting validation...');

  const decisionsDir = config.decisionsPath;
  const files: string[] = [];

  async function findMarkdownFiles(dir: string): Promise<void> {
    try {
      const entries = await fs.readdir(dir, { withFileTypes: true });
      
      for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);
        
        if (entry.isDirectory()) {
          if (entry.name.startsWith('_') || 
              entry.name === 'node_modules' || 
              entry.name === '.git') {
            continue;
          }
          await findMarkdownFiles(fullPath);
        } else if (entry.isFile() && entry.name.endsWith('.md')) {
          files.push(fullPath);
        }
      }
    } catch (error) {
      logger.error(`Error reading directory: ${dir}`, { 
        error: error instanceof Error ? error.message : String(error) 
      });
    }
  }

  await findMarkdownFiles(decisionsDir);
  logger.info(`Found ${files.length} markdown files to validate`);

  let validCount = 0;
  let invalidCount = 0;

  for (const file of files) {
    try {
      const content = await fs.readFile(file, 'utf-8');
      const relativePath = path.relative(config.repoRoot, file);
      const doc = parseDocument(content, relativePath);
      const validation = validateDocument(doc);

      if (validation.valid && validation.warnings.length === 0) {
        logger.info(`✓ Valid: ${relativePath}`);
        validCount++;
      } else if (validation.valid) {
        logger.warn(`⚠ Valid with warnings: ${relativePath}`);
        logger.warn(formatValidationErrors(validation));
        validCount++;
      } else {
        logger.error(`✗ Invalid: ${relativePath}`);
        logger.error(formatValidationErrors(validation));
        invalidCount++;
      }
    } catch (error) {
      logger.error(`Error validating ${file}: ${error instanceof Error ? error.message : String(error)}`);
      invalidCount++;
    }
  }

  logger.info(`Validation complete: ${validCount} valid, ${invalidCount} invalid`);
  process.exit(invalidCount > 0 ? 1 : 0);
}

/**
 * Start file watcher
 */
async function startWatcher(config: Config): Promise<void> {
  logger.info('Starting file watcher mode...');

  const git = createGitIntegration(config.repoRoot);
  
  const watcher = createDecisionWatcher(config.decisionsPath, async (events) => {
    await handleFileEvents(events, git);
  });

  // Handle graceful shutdown
  process.on('SIGINT', async () => {
    logger.info('Received SIGINT, shutting down...');
    await watcher.stop();
    process.exit(0);
  });

  process.on('SIGTERM', async () => {
    logger.info('Received SIGTERM, shutting down...');
    await watcher.stop();
    process.exit(0);
  });

  await watcher.start();

  logger.info('Watcher is running. Press Ctrl+C to stop.');
}

// Parse configuration
const config = parseArgs();
logger.setLevel(config.logLevel);

// Main execution
async function main(): Promise<void> {
  logger.info('RAG Watcher starting', { 
    mode: config.watchMode ? 'watch' : config.validateOnly ? 'validate' : 'ingest',
    repoRoot: config.repoRoot,
    decisionsPath: config.decisionsPath,
  });

  try {
    if (config.validateOnly) {
      await runValidation(config);
    } else if (config.watchMode) {
      await startWatcher(config);
    } else {
      await runBatchIngestion(config);
    }
  } catch (error) {
    logger.error('Fatal error', { 
      error: error instanceof Error ? error.message : String(error) 
    });
    process.exit(1);
  }
}

main();

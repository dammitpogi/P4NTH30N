import { join } from 'path';

// Get project root - use relative paths from tools/ directory
// import.meta.dir gives us the directory of this file (which is in utils/)
const UTILS_DIR = import.meta.dir;

// Go up from utils/ to tools/ to memory/
const TOOLS_DIR = UTILS_DIR.replace(/[\\/]utils[\\/]?$/, '');
const MEMORY_DIR = TOOLS_DIR.replace(/[\\/]tools[\\/]?$/, '');
const STR4TEG15T_DIR = MEMORY_DIR.replace(/[\\/]memory[\\/]?$/, '');
const ROOT_DIR = STR4TEG15T_DIR.replace(/[\\/]STR4TEG15T[\\/]?$/, '');

export const MEMORY_ROOT = MEMORY_DIR;

export const PATHS = {
  decisions: join(MEMORY_ROOT, 'decisions'),
  logs: join(MEMORY_ROOT, 'logs'),
  research: join(MEMORY_ROOT, 'research'),
  indexes: join(MEMORY_ROOT, 'indexes'),
  cache: join(MEMORY_ROOT, 'indexes', 'cache'),
  tools: TOOLS_DIR
} as const;

// Use relative paths for Bun.Glob compatibility
export const SOURCE_PATHS = [
  '../../../STR4TEG15T/decisions/active',
  '../../../STR4TEG15T/decisions/completed',
  '../../../STR4TEG15T/canon',
  '../../../STR4TEG15T/consultations'
];

export function getIndexPath(filename: string): string {
  return join(PATHS.indexes, filename);
}

export function getCachePath(filename: string): string {
  return join(PATHS.cache, filename);
}

export function getDecisionPath(id: string): string {
  return join(PATHS.decisions, `${id}.md`);
}

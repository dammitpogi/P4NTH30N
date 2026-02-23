import { access, readFile, stat } from 'node:fs/promises';
import { dirname, relative, resolve } from 'node:path';
import { glob } from 'glob';
import { CODEMAP_FILENAME } from './constants';

export interface DiscoveredCodemap {
  path: string;
  directory: string;
  content: string;
  modifiedTime: number;
}

/**
 * Find all codemap.md files under a given base path.
 * Searches recursively up to a reasonable depth.
 */
export async function discoverCodemaps(basePath: string, maxDepth: number = 3): Promise<DiscoveredCodemap[]> {
  const codemaps: DiscoveredCodemap[] = [];
  
  try {
    // Use glob pattern to find all codemap.md files
    const pattern = resolve(basePath, '**/' + CODEMAP_FILENAME);
    const files = await glob(pattern, {
      nodir: true,
      absolute: true,
      dot: false,
      maxDepth,
    });

    for (const file of files) {
      try {
          const fileStat = await stat(file);
          const content = await readFile(file, 'utf-8');
        
        codemaps.push({
          path: file,
          directory: dirname(file),
          content,
            modifiedTime: fileStat.mtimeMs,
        });
      } catch (err) {
        // Silently skip files that can't be read
        continue;
      }
    }
  } catch (err) {
    // No codemaps found or directory doesn't exist
  }

  return codemaps;
}

/**
 * Find codemaps relevant to a specific target path.
 * Returns codemaps from the target directory and its ancestors (up to maxDepth).
 */
export async function findRelevantCodemaps(
  targetPath: string,
  maxDepth: number = 3,
  rootDir?: string,
): Promise<DiscoveredCodemap[]> {
  const allCodemaps: DiscoveredCodemap[] = [];
  const resolvedRoot = rootDir ? resolve(rootDir) : null;
  
  // Check current directory and ancestors
  let currentDir = targetPath;
  let depth = 0;
  
  while (currentDir && depth < maxDepth) {
    if (resolvedRoot && !isWithinRoot(currentDir, resolvedRoot)) {
      break;
    }

    const codemapPath = resolve(currentDir, CODEMAP_FILENAME);
    try {
        await access(codemapPath);
        {
          const fileStat = await stat(codemapPath);
          const content = await readFile(codemapPath, 'utf-8');
        
        allCodemaps.push({
          path: codemapPath,
          directory: currentDir,
          content,
            modifiedTime: fileStat.mtimeMs,
          });
        }
    } catch (err) {
      // Skip
    }
    
    // Move to parent
    const parentDir = dirname(currentDir);
    if (parentDir === currentDir) break; // Reached root
    if (resolvedRoot && !isWithinRoot(parentDir, resolvedRoot)) break;
    currentDir = parentDir;
    depth++;
  }
  
  return allCodemaps;
}

/**
 * Check if a path is within a codemap's directory scope.
 */
export function isPathInCodemapScope(filePath: string, codemapDirectory: string): boolean {
  const normalizedFilePath = resolve(filePath);
  const normalizedCodemapDir = resolve(codemapDirectory);
  
  return normalizedFilePath.startsWith(normalizedCodemapDir);
}

function isWithinRoot(pathToCheck: string, rootDir: string): boolean {
  const rel = relative(rootDir, resolve(pathToCheck));
  return rel === '' || (!rel.startsWith('..') && !rel.includes(':'));
}

/**
 * DECISION_051: Configuration Rollback Script
 * Rolls back to a previous configuration backup
 * 
 * Usage: npx ts-node scripts/rollback-config.ts [backup-file]
 */

import * as fs from 'fs';
import * as path from 'path';

const CONFIG_PATH = path.join(__dirname, '../config/servers.json');
const BACKUP_DIR = path.join(__dirname, '../config/backups');

/**
 * Lists available backups
 */
function listBackups(): string[] {
  if (!fs.existsSync(BACKUP_DIR)) {
    return [];
  }

  return fs.readdirSync(BACKUP_DIR)
    .filter(f => f.startsWith('servers-') && f.endsWith('.json'))
    .sort()
    .reverse(); // Most recent first
}

/**
 * Gets the most recent backup
 */
function getLatestBackup(): string | null {
  const backups = listBackups();
  return backups.length > 0 ? path.join(BACKUP_DIR, backups[0]) : null;
}

/**
 * Performs rollback to a specific backup
 */
function rollback(backupPath: string): { success: boolean; error?: string } {
  try {
    if (!fs.existsSync(backupPath)) {
      return { success: false, error: `Backup not found: ${backupPath}` };
    }

    // Create backup of current config before rollback
    if (fs.existsSync(CONFIG_PATH)) {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const preRollbackBackup = path.join(BACKUP_DIR, `servers-prerollback-${timestamp}.json`);
      fs.copyFileSync(CONFIG_PATH, preRollbackBackup);
      console.log(`[Rollback] Pre-rollback backup created: ${preRollbackBackup}`);
    }

    // Perform rollback
    fs.copyFileSync(backupPath, CONFIG_PATH);
    
    return { success: true };
  } catch (err) {
    return { 
      success: false, 
      error: err instanceof Error ? err.message : String(err) 
    };
  }
}

/**
 * Main function
 */
async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const specifiedBackup = args[0];

  console.log('[Rollback] Configuration Rollback Tool');
  console.log(`[Rollback] Config path: ${CONFIG_PATH}`);
  console.log(`[Rollback] Backup directory: ${BACKUP_DIR}`);

  // If backup specified, use it
  let backupPath: string | null = null;
  
  if (specifiedBackup) {
    // Check if it's a full path or just a filename
    if (fs.existsSync(specifiedBackup)) {
      backupPath = specifiedBackup;
    } else {
      const fullPath = path.join(BACKUP_DIR, specifiedBackup);
      if (fs.existsSync(fullPath)) {
        backupPath = fullPath;
      } else {
        console.error(`[Rollback] Error: Backup not found: ${specifiedBackup}`);
        process.exit(1);
      }
    }
  } else {
    // List available backups and ask user to choose
    const backups = listBackups();
    
    if (backups.length === 0) {
      console.error('[Rollback] Error: No backups available');
      process.exit(1);
    }

    console.log('\n[Rollback] Available backups:');
    for (let i = 0; i < Math.min(backups.length, 10); i++) {
      const backup = backups[i];
      const stats = fs.statSync(path.join(BACKUP_DIR, backup));
      const date = stats.mtime.toISOString();
      console.log(`  ${i + 1}. ${backup} (${date})`);
    }

    // Auto-select latest for non-interactive mode
    backupPath = getLatestBackup();
    console.log(`\n[Rollback] Auto-selecting latest backup: ${path.basename(backupPath)}`);
  }

  if (!backupPath) {
    console.error('[Rollback] Error: Could not determine backup to restore');
    process.exit(1);
  }

  console.log(`\n[Rollback] Rolling back to: ${backupPath}`);
  
  const result = rollback(backupPath);
  
  if (result.success) {
    console.log('[Rollback] ✓ Rollback successful!');
    console.log(`[Rollback] Configuration restored from: ${backupPath}`);
    console.log('[Rollback] Note: Gateway must be restarted to apply changes');
  } else {
    console.error(`[Rollback] ✗ Rollback failed: ${result.error}`);
    process.exit(1);
  }
}

// Run if executed directly
if (require.main === module) {
  main().catch(err => {
    console.error('[Rollback] Fatal error:', err);
    process.exit(1);
  });
}

export { rollback, listBackups, getLatestBackup };

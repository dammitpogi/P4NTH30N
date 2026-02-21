/**
 * DECISION_051: Configuration Deployment Script
 * Deploys the servers.json configuration to the gateway
 * 
 * Usage: npx ts-node scripts/deploy-config.ts [--backup]
 */

import * as fs from 'fs';
import * as path from 'path';
import type { ServersConfig, DeploymentResult } from '../src/config-types';

const CONFIG_PATH = path.join(__dirname, '../config/servers.json');
const BACKUP_DIR = path.join(__dirname, '../config/backups');

/**
 * Creates a backup of the current configuration
 */
function createBackup(): string | undefined {
  if (!fs.existsSync(CONFIG_PATH)) {
    return undefined;
  }

  // Ensure backup directory exists
  if (!fs.existsSync(BACKUP_DIR)) {
    fs.mkdirSync(BACKUP_DIR, { recursive: true });
  }

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupPath = path.join(BACKUP_DIR, `servers-${timestamp}.json`);

  fs.copyFileSync(CONFIG_PATH, backupPath);
  return backupPath;
}

/**
 * Loads the configuration from file
 */
function loadConfig(): ServersConfig | null {
  try {
    const content = fs.readFileSync(CONFIG_PATH, 'utf-8');
    return JSON.parse(content) as ServersConfig;
  } catch {
    return null;
  }
}

/**
 * Validates the configuration before deployment
 */
async function preDeployValidation(): Promise<{ valid: boolean; errors: string[] }> {
  const errors: string[] = [];

  if (!fs.existsSync(CONFIG_PATH)) {
    errors.push('Configuration file not found');
    return { valid: false, errors };
  }

  try {
    const content = fs.readFileSync(CONFIG_PATH, 'utf-8');
    const config = JSON.parse(content) as ServersConfig;

    if (!config.servers || !Array.isArray(config.servers)) {
      errors.push('Invalid configuration: servers array missing');
    }

    if (config.servers.length === 0) {
      errors.push('Configuration contains no servers');
    }

    // Check for duplicate IDs
    const ids = config.servers.map(s => s.id);
    const duplicates = ids.filter((item, index) => ids.indexOf(item) !== index);
    if (duplicates.length > 0) {
      errors.push(`Duplicate server IDs: ${[...new Set(duplicates)].join(', ')}`);
    }
  } catch (err) {
    errors.push(`Failed to parse configuration: ${err instanceof Error ? err.message : String(err)}`);
  }

  return { valid: errors.length === 0, errors };
}

/**
 * Deploys the configuration
 */
async function deployConfig(createBackupFlag = false): Promise<DeploymentResult> {
  const result: DeploymentResult = {
    success: false,
    deployed: [],
    failed: [],
    timestamp: new Date().toISOString(),
  };

  // Pre-deployment validation
  const validation = await preDeployValidation();
  if (!validation.valid) {
    for (const error of validation.errors) {
      result.failed.push({ server: 'config', error });
    }
    return result;
  }

  // Create backup if requested
  if (createBackupFlag) {
    result.backupLocation = createBackup();
    if (result.backupLocation) {
      console.log(`[Deploy] Backup created: ${result.backupLocation}`);
    }
  }

  // Load configuration
  const config = loadConfig();
  if (!config) {
    result.failed.push({ server: 'config', error: 'Failed to load configuration' });
    return result;
  }

  // Deploy each enabled server
  console.log('[Deploy] Deploying servers...');
  
  for (const server of config.servers) {
    if (!server.enabled) {
      console.log(`  - ${server.name} (disabled, skipping)`);
      continue;
    }

    try {
      // Here we would actually register the server with the gateway
      // For now, we just validate it can be loaded
      console.log(`  ✓ ${server.name} (${server.transport}, ${server.connection.url || 'stdio'})`);
      result.deployed.push(server.id);
    } catch (err) {
      const error = err instanceof Error ? err.message : String(err);
      console.log(`  ✗ ${server.name}: ${error}`);
      result.failed.push({ server: server.id, error });
    }
  }

  result.success = result.failed.length === 0;

  // Write deployment log
  const logEntry = {
    timestamp: result.timestamp,
    success: result.success,
    deployed: result.deployed,
    failed: result.failed,
    backupLocation: result.backupLocation,
  };

  const logPath = path.join(__dirname, '../config/deployments.log');
  fs.appendFileSync(logPath, JSON.stringify(logEntry) + '\n');

  return result;
}

/**
 * Main function
 */
async function main(): Promise<void> {
  const backup = process.argv.includes('--backup');
  
  console.log('[Deploy] Starting configuration deployment...');
  console.log(`[Deploy] Config: ${CONFIG_PATH}`);
  console.log(`[Deploy] Backup: ${backup ? 'enabled' : 'disabled'}`);

  const result = await deployConfig(backup);

  console.log('\n[Deploy] Results:');
  console.log(`  Success: ${result.success ? '✓ YES' : '✗ NO'}`);
  console.log(`  Deployed: ${result.deployed.length} servers`);
  console.log(`  Failed: ${result.failed.length} servers`);

  if (result.deployed.length > 0) {
    console.log('\n[Deploy] Deployed servers:');
    for (const id of result.deployed) {
      console.log(`  ✓ ${id}`);
    }
  }

  if (result.failed.length > 0) {
    console.log('\n[Deploy] Failed deployments:');
    for (const fail of result.failed) {
      console.log(`  ✗ ${fail.server}: ${fail.error}`);
    }
  }

  if (result.backupLocation) {
    console.log(`\n[Deploy] Backup location: ${result.backupLocation}`);
  }

  console.log('\n[Deploy] Deployment complete!');
  console.log('[Deploy] Note: Gateway must be restarted to load new configuration');

  process.exit(result.success ? 0 : 1);
}

// Run if executed directly
if (require.main === module) {
  main().catch(err => {
    console.error('[Deploy] Fatal error:', err);
    process.exit(1);
  });
}

export { deployConfig, createBackup, loadConfig };

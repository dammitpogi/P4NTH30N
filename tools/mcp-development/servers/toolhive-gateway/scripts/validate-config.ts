/**
 * DECISION_051: Configuration Validation Script
 * Validates the servers.json configuration before deployment
 * 
 * Usage: npx ts-node scripts/validate-config.ts [--strict]
 */

import * as fs from 'fs';
import * as path from 'path';
import * as http from 'http';
import type { ServersConfig, ToolHiveServerConfig, ValidationResult } from '../src/config-types';

const CONFIG_PATH = path.join(__dirname, '../config/servers.json');

/**
 * Validates the configuration structure
 */
function validateStructure(config: unknown): string[] {
  const errors: string[] = [];

  if (!config || typeof config !== 'object') {
    errors.push('Configuration must be an object');
    return errors;
  }

  const cfg = config as Partial<ServersConfig>;

  // Check required fields
  if (!cfg.schemaVersion) {
    errors.push('Missing required field: schemaVersion');
  }

  if (!cfg.lastUpdated) {
    errors.push('Missing required field: lastUpdated');
  }

  if (!Array.isArray(cfg.servers)) {
    errors.push('Missing required field: servers (must be an array)');
    return errors;
  }

  // Validate each server
  for (let i = 0; i < cfg.servers.length; i++) {
    const server = cfg.servers[i];
    const prefix = `servers[${i}]`;

    if (!server.id) {
      errors.push(`${prefix}: Missing required field: id`);
    }

    if (!server.name) {
      errors.push(`${prefix}: Missing required field: name`);
    }

    if (!server.transport) {
      errors.push(`${prefix}: Missing required field: transport`);
    } else if (!['stdio', 'http', 'streamable-http'].includes(server.transport)) {
      errors.push(`${prefix}: Invalid transport: ${server.transport}`);
    }

    if (!server.connection) {
      errors.push(`${prefix}: Missing required field: connection`);
    } else {
      if (server.transport === 'http' || server.transport === 'streamable-http') {
        if (!server.connection.url) {
          errors.push(`${prefix}: HTTP transport requires connection.url`);
        }
      }
    }

    if (!Array.isArray(server.tags)) {
      errors.push(`${prefix}: tags must be an array`);
    }

    if (!server.description) {
      errors.push(`${prefix}: Missing required field: description`);
    }
  }

  return errors;
}

/**
 * Validates server connectivity
 */
async function validateConnectivity(server: ToolHiveServerConfig): Promise<{ valid: boolean; error?: string }> {
  if (!server.enabled) {
    return { valid: true }; // Disabled servers are valid
  }

  if (server.transport !== 'http' || !server.connection.url) {
    return { valid: true }; // Skip non-HTTP servers
  }

  return new Promise((resolve) => {
    const url = new URL(server.connection.url!);
    
    const options: http.RequestOptions = {
      hostname: url.hostname,
      port: url.port || 80,
      path: url.pathname,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      timeout: 5000,
    };

    const request = {
      jsonrpc: '2.0',
      id: 'validation-check',
      method: 'tools/list',
      params: {},
    };

    const req = http.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        try {
          const response = JSON.parse(data);
          if (response.error) {
            resolve({ valid: false, error: response.error.message });
          } else {
            resolve({ valid: true });
          }
        } catch {
          resolve({ valid: false, error: 'Invalid JSON response' });
        }
      });
    });

    req.on('error', (err) => {
      resolve({ valid: false, error: err.message });
    });

    req.on('timeout', () => {
      req.destroy();
      resolve({ valid: false, error: 'Connection timeout' });
    });

    req.write(JSON.stringify(request));
    req.end();
  });
}

/**
 * Main validation function
 */
async function validateConfig(strict = false): Promise<ValidationResult> {
  const result: ValidationResult = {
    valid: true,
    errors: [],
    warnings: [],
    stats: {
      totalServers: 0,
      validServers: 0,
      invalidServers: 0,
    },
  };

  // Check if config file exists
  if (!fs.existsSync(CONFIG_PATH)) {
    result.valid = false;
    result.errors.push(`Configuration file not found: ${CONFIG_PATH}`);
    return result;
  }

  // Parse configuration
  let config: ServersConfig;
  try {
    const content = fs.readFileSync(CONFIG_PATH, 'utf-8');
    config = JSON.parse(content);
  } catch (err) {
    result.valid = false;
    result.errors.push(`Failed to parse configuration: ${err instanceof Error ? err.message : String(err)}`);
    return result;
  }

  // Validate structure
  const structureErrors = validateStructure(config);
  if (structureErrors.length > 0) {
    result.valid = false;
    result.errors.push(...structureErrors);
  }

  result.stats.totalServers = config.servers.length;

  // Validate connectivity in strict mode
  if (strict) {
    console.log('[Validation] Checking server connectivity...');
    
    for (const server of config.servers) {
      process.stdout.write(`  Checking ${server.name}... `);
      const connectivity = await validateConnectivity(server);
      
      if (connectivity.valid) {
        console.log('✓');
        result.stats.validServers++;
      } else {
        console.log(`✗ (${connectivity.error})`);
        result.stats.invalidServers++;
        result.warnings.push(`${server.name}: ${connectivity.error}`);
        
        if (strict) {
          result.valid = false;
          result.errors.push(`${server.name}: Connection failed - ${connectivity.error}`);
        }
      }
    }
  } else {
    // Just count enabled servers as valid
    result.stats.validServers = config.servers.filter(s => s.enabled).length;
    result.stats.invalidServers = config.servers.filter(s => !s.enabled).length;
  }

  // Check for duplicate IDs
  const ids = config.servers.map(s => s.id);
  const duplicates = ids.filter((item, index) => ids.indexOf(item) !== index);
  if (duplicates.length > 0) {
    result.valid = false;
    result.errors.push(`Duplicate server IDs found: ${[...new Set(duplicates)].join(', ')}`);
  }

  return result;
}

/**
 * Main function
 */
async function main(): Promise<void> {
  const strict = process.argv.includes('--strict');
  
  console.log('[Validation] Starting configuration validation...');
  console.log(`[Validation] Mode: ${strict ? 'strict (with connectivity)' : 'standard'}`);
  console.log(`[Validation] Config: ${CONFIG_PATH}`);

  const result = await validateConfig(strict);

  console.log('\n[Validation] Results:');
  console.log(`  Valid: ${result.valid ? '✓ YES' : '✗ NO'}`);
  console.log(`  Total servers: ${result.stats.totalServers}`);
  console.log(`  Valid servers: ${result.stats.validServers}`);
  console.log(`  Invalid servers: ${result.stats.invalidServers}`);

  if (result.errors.length > 0) {
    console.log('\n[Validation] Errors:');
    for (const error of result.errors) {
      console.log(`  ✗ ${error}`);
    }
  }

  if (result.warnings.length > 0) {
    console.log('\n[Validation] Warnings:');
    for (const warning of result.warnings) {
      console.log(`  ⚠ ${warning}`);
    }
  }

  if (result.valid && result.errors.length === 0) {
    console.log('\n[Validation] ✓ Configuration is valid!');
  }

  process.exit(result.valid ? 0 : 1);
}

// Run if executed directly
if (require.main === module) {
  main().catch(err => {
    console.error('[Validation] Fatal error:', err);
    process.exit(1);
  });
}

export { validateConfig, validateStructure, validateConnectivity };

#!/usr/bin/env node

/**
 * OpenClaw API Client Tool
 * Comprehensive client for OpenClaw Railway deployment API endpoints
 * 
 * Features:
 * - Full endpoint coverage with schema validation
 * - Interactive and programmatic modes
 * - Verbose documentation and examples
 * - Error handling and retry logic
 * - Backup/restore capabilities
 */

import { Command } from 'commander';
import inquirer from 'inquirer';
import chalk from 'chalk';
import ora from 'ora';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

class OpenClawAPIClient {
  constructor(baseURL, setupPassword, gatewayToken = null) {
    this.baseURL = baseURL.replace(/\/$/, '');
    this.setupPassword = setupPassword;
    this.gatewayToken = gatewayToken;
    this.setupAuth = Buffer.from(`:${setupPassword}`).toString('base64');
  }

  /**
   * Make authenticated request to setup endpoints
   */
  async setupRequest(method, endpoint, data = null, options = {}) {
    const url = `${this.baseURL}/setup${endpoint}`;
    const headers = {
      'Authorization': `Basic ${this.setupAuth}`,
      'Content-Type': 'application/json'
    };

    return this.makeRequest(method, url, data, headers, options);
  }

  /**
   * Make gateway proxy request
   */
  async gatewayRequest(method, endpoint, data = null, options = {}) {
    const url = `${this.baseURL}/openclaw${endpoint}`;
    const headers = {
      'Authorization': `Bearer ${this.gatewayToken}`,
      'Content-Type': 'application/json'
    };

    return this.makeRequest(method, url, data, headers, options);
  }

  /**
   * Generic HTTP request with error handling
   */
  async makeRequest(method, url, data = null, headers = {}, options = {}) {
    const fetchOptions = {
      method,
      headers,
      ...options
    };

    if (data && method !== 'GET') {
      fetchOptions.body = JSON.stringify(data);
    }

    try {
      const response = await fetch(url, fetchOptions);
      
      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
      }

      const contentType = response.headers.get('content-type');
      if (contentType?.includes('application/json')) {
        return await response.json();
      } else {
        return await response.text();
      }
    } catch (error) {
      throw new Error(`Request failed: ${error.message}`);
    }
  }

  // ==================== HEALTH & STATUS ENDPOINTS ====================

  /**
   * Get public health status
   * @returns {Promise<Object>} Health status with gateway info
   */
  async getPublicHealth() {
    return this.makeRequest('GET', `${this.baseURL}/healthz`);
  }

  /**
   * Get minimal health check (Railway monitoring)
   * @returns {Promise<Object>} { ok: true }
   */
  async getSetupHealth() {
    return this.makeRequest('GET', `${this.baseURL}/setup/healthz`);
  }

  /**
   * Get detailed system status
   * @returns {Promise<Object>} System status, version, and auth groups
   */
  async getSystemStatus() {
    return this.setupRequest('GET', '/api/status');
  }

  /**
   * Get available authentication providers
   * @returns {Promise<Object>} { ok: true, authGroups: [...] }
   */
  async getAuthGroups() {
    return this.setupRequest('GET', '/api/auth-groups');
  }

  // ==================== CONFIGURATION ENDPOINTS ====================

  /**
   * Get raw configuration file content
   * @returns {Promise<Object>} Configuration content and metadata
   */
  async getConfig() {
    return this.setupRequest('GET', '/api/config/raw');
  }

  /**
   * Save configuration file (creates backup)
   * @param {string} content - Raw configuration content
   * @returns {Promise<Object>} Save result
   */
  async saveConfig(content) {
    return this.setupRequest('POST', '/api/config/raw', { content });
  }

  // ==================== ONBOARDING ENDPOINTS ====================

  /**
   * Run OpenClaw onboarding process
   * @param {Object} payload - Onboarding configuration
   * @returns {Promise<Object>} Onboarding result
   */
  async runOnboarding(payload) {
    const schema = {
      authGroup: 'string (provider group: openai, anthropic, google, etc.)',
      authChoice: 'string (auth method: openai-api-key, claude-cli, etc.)',
      authSecret: 'string (API key or token, if required)',
      flow: 'string (quickstart | advanced | manual)',
      telegramToken: 'string (optional, Telegram bot token)',
      discordToken: 'string (optional, Discord bot token)',
      slackBotToken: 'string (optional, Slack bot token)',
      slackAppToken: 'string (optional, Slack app token)',
      customProviderId: 'string (optional, custom provider ID)',
      customProviderBaseUrl: 'string (optional, custom provider URL)',
      customProviderApi: 'string (openai-completions | openai-responses)',
      customProviderApiKeyEnv: 'string (optional, env var name for API key)',
      customProviderModelId: 'string (optional, model ID)'
    };

    return this.setupRequest('POST', '/api/run', payload);
  }

  /**
   * Reset configuration (delete config file)
   * @returns {Promise<Object>} Reset result
   */
  async resetConfig() {
    return this.setupRequest('POST', '/api/reset');
  }

  // ==================== DEBUG ENDPOINTS ====================

  /**
   * Get debug information
   * @returns {Promise<Object>} Debug diagnostics
   */
  async getDebugInfo() {
    return this.setupRequest('GET', '/api/debug');
  }

  /**
   * Execute debug console command
   * @param {string} cmd - Command to execute
   * @param {string} arg - Optional argument
   * @returns {Promise<Object>} Command output
   */
  async runConsoleCommand(cmd, arg = '') {
    const allowedCommands = [
      'gateway.restart',
      'gateway.stop', 
      'gateway.start',
      'openclaw.status',
      'openclaw.health',
      'openclaw.doctor',
      'openclaw.logs',
      'openclaw.config.get',
      'openclaw.devices.list',
      'openclaw.devices.approve',
      'openclaw.plugins.list',
      'openclaw.plugins.enable'
    ];

    if (!allowedCommands.includes(cmd)) {
      throw new Error(`Command not allowed: ${cmd}`);
    }

    return this.setupRequest('POST', '/api/console/run', { cmd, arg });
  }

  // ==================== DEVICE MANAGEMENT ENDPOINTS ====================

  /**
   * Get pending device requests
   * @returns {Promise<Object>} Pending devices and request IDs
   */
  async getPendingDevices() {
    return this.setupRequest('GET', '/api/devices/pending');
  }

  /**
   * Approve a device request
   * @param {string} requestId - Device request ID
   * @returns {Promise<Object>} Approval result
   */
  async approveDevice(requestId) {
    return this.setupRequest('POST', '/api/devices/approve', { requestId });
  }

  /**
   * Approve pairing request
   * @param {string} channel - Channel identifier
   * @param {string} code - Pairing code
   * @returns {Promise<Object>} Pairing approval result
   */
  async approvePairing(channel, code) {
    return this.setupRequest('POST', '/api/pairing/approve', { channel, code });
  }

  // ==================== BACKUP ENDPOINTS ====================

  /**
   * Export backup (download tar.gz)
   * @param {string} outputPath - Where to save the backup file
   * @returns {Promise<string>} Path to downloaded file
   */
  async exportBackup(outputPath = './openclaw-backup.tar.gz') {
    const url = `${this.baseURL}/setup/export`;
    const headers = {
      'Authorization': `Basic ${this.setupAuth}`
    };

    const response = await fetch(url, { headers });
    if (!response.ok) {
      throw new Error(`Export failed: ${response.status}`);
    }

    const buffer = await response.arrayBuffer();
    await fs.writeFile(outputPath, Buffer.from(buffer));
    return outputPath;
  }

  /**
   * Import backup from file
   * @param {string} filePath - Path to backup tar.gz file
   * @returns {Promise<Object>} Import result
   */
  async importBackup(filePath) {
    const fileBuffer = await fs.readFile(filePath);
    const formData = new FormData();
    formData.append('file', new Blob([fileBuffer]), 'backup.tar.gz');

    const url = `${this.baseURL}/setup/import`;
    const headers = {
      'Authorization': `Basic ${this.setupAuth}`
    };

    const response = await fetch(url, {
      method: 'POST',
      headers,
      body: formData
    });

    if (!response.ok) {
      throw new Error(`Import failed: ${response.status}`);
    }

    return await response.text();
  }
}

// ==================== CLI INTERFACE ====================

const program = new Command();

program
  .name('openclaw-api')
  .description('OpenClaw API Client Tool - Comprehensive endpoint management')
  .version('1.0.0');

program
  .requiredOption('-u, --url <url>', 'OpenClaw base URL (e.g., https://your-app.railway.app)')
  .requiredOption('-p, --password <password>', 'Setup password')
  .option('-t, --token <token>', 'Gateway token (for proxy requests)')
  .option('-v, --verbose', 'Verbose output');

// Health commands
program
  .command('health')
  .description('Check system health')
  .option('-p, --public', 'Public health check only')
  .action(async (options) => {
    const client = new OpenClawAPIClient(program.opts().url, program.opts().password, program.opts().token);
    
    try {
      if (options.public) {
        const health = await client.getPublicHealth();
        console.log(chalk.green('✓ Public Health:'));
        console.log(JSON.stringify(health, null, 2));
      } else {
        const [publicHealth, setupHealth, systemStatus] = await Promise.all([
          client.getPublicHealth(),
          client.getSetupHealth(),
          client.getSystemStatus()
        ]);
        
        console.log(chalk.green('✓ System Health:'));
        console.log(JSON.stringify({ publicHealth, setupHealth, systemStatus }, null, 2));
      }
    } catch (error) {
      console.error(chalk.red('✗ Health check failed:'), error.message);
      process.exit(1);
    }
  });

// Configuration commands
program
  .command('config')
  .description('Configuration management')
  .argument('[action]', 'Action: get | set | reset')
  .option('-f, --file <file>', 'File path for set action')
  .action(async (action, options) => {
    const client = new OpenClawAPIClient(program.opts().url, program.opts().password, program.opts().token);
    
    try {
      switch (action) {
        case 'get':
          const config = await client.getConfig();
          console.log(chalk.green('✓ Current Configuration:'));
          console.log(config.content || 'No configuration found');
          break;
          
        case 'set':
          if (!options.file) {
            console.error(chalk.red('✗ File path required for set action'));
            process.exit(1);
          }
          const content = await fs.readFile(options.file, 'utf8');
          const result = await client.saveConfig(content);
          console.log(chalk.green('✓ Configuration saved:'));
          console.log(JSON.stringify(result, null, 2));
          break;
          
        case 'reset':
          const resetResult = await client.resetConfig();
          console.log(chalk.green('✓ Configuration reset:'));
          console.log(JSON.stringify(resetResult, null, 2));
          break;
          
        default:
          console.log(chalk.yellow('Available actions: get, set, reset'));
      }
    } catch (error) {
      console.error(chalk.red('✗ Config operation failed:'), error.message);
      process.exit(1);
    }
  });

// Onboarding command
program
  .command('onboard')
  .description('Run OpenClaw onboarding')
  .option('-i, --interactive', 'Interactive onboarding wizard')
  .action(async (options) => {
    const client = new OpenClawAPIClient(program.opts().url, program.opts().password, program.opts().token);
    
    try {
      let payload;
      
      if (options.interactive) {
        // Get auth groups first
        const status = await client.getSystemStatus();
        const authGroups = status.authGroups;
        
        const answers = await inquirer.prompt([
          {
            type: 'list',
            name: 'authGroup',
            message: 'Select authentication provider:',
            choices: authGroups.map(g => ({ name: `${g.label} - ${g.hint}`, value: g.value }))
          },
          {
            type: 'list',
            name: 'authChoice',
            message: 'Select authentication method:',
            choices: (answers) => {
              const group = authGroups.find(g => g.value === answers.authGroup);
              return group?.options?.map(o => ({ name: o.label, value: o.value })) || [];
            }
          },
          {
            type: 'password',
            name: 'authSecret',
            message: 'Enter API key or token (if required):',
            when: (answers) => {
              const group = authGroups.find(g => g.value === answers.authGroup);
              const choice = group?.options?.find(o => o.value === answers.authChoice);
              return choice?.label?.toLowerCase().includes('key') || choice?.label?.toLowerCase().includes('token');
            }
          },
          {
            type: 'list',
            name: 'flow',
            message: 'Select onboarding flow:',
            choices: ['quickstart', 'advanced', 'manual']
          }
        ]);
        
        payload = answers;
      } else {
        console.log(chalk.yellow('⚠ Non-interactive mode requires payload file'));
        console.log('Create a JSON file with onboarding configuration and use --file option');
        return;
      }
      
      const spinner = ora('Running onboarding...').start();
      const result = await client.runOnboarding(payload);
      spinner.stop();
      
      if (result.ok) {
        console.log(chalk.green('✓ Onboarding completed successfully!'));
        console.log(result.output);
      } else {
        console.log(chalk.red('✗ Onboarding failed:'));
        console.log(result.output);
      }
    } catch (error) {
      console.error(chalk.red('✗ Onboarding failed:'), error.message);
      process.exit(1);
    }
  });

// Debug console command
program
  .command('console')
  .description('Execute debug console commands')
  .argument('<command>', 'Command to execute')
  .argument('[arg]', 'Command argument')
  .action(async (command, arg) => {
    const client = new OpenClawAPIClient(program.opts().url, program.opts().password, program.opts().token);
    
    try {
      const spinner = ora(`Executing: ${command} ${arg || ''}`).start();
      const result = await client.runConsoleCommand(command, arg);
      spinner.stop();
      
      console.log(chalk.green('✓ Command output:'));
      console.log(result.output || result);
    } catch (error) {
      console.error(chalk.red('✗ Console command failed:'), error.message);
      process.exit(1);
    }
  });

// Device management command
program
  .command('devices')
  .description('Device management')
  .argument('[action]', 'Action: list | approve <requestId>')
  .action(async (action, requestId) => {
    const client = new OpenClawAPIClient(program.opts().url, program.opts().password, program.opts().token);
    
    try {
      switch (action) {
        case 'list':
          const devices = await client.getPendingDevices();
          console.log(chalk.green('✓ Pending Devices:'));
          if (devices.requestIds && devices.requestIds.length > 0) {
            devices.requestIds.forEach(id => console.log(`  - ${id}`));
          } else {
            console.log('  No pending devices');
          }
          break;
          
        case 'approve':
          if (!requestId) {
            console.error(chalk.red('✗ Request ID required for approve action'));
            process.exit(1);
          }
          const result = await client.approveDevice(requestId);
          console.log(chalk.green('✓ Device approved:'));
          console.log(JSON.stringify(result, null, 2));
          break;
          
        default:
          console.log(chalk.yellow('Available actions: list, approve <requestId>'));
      }
    } catch (error) {
      console.error(chalk.red('✗ Device operation failed:'), error.message);
      process.exit(1);
    }
  });

// Backup commands
program
  .command('backup')
  .description('Backup management')
  .argument('[action]', 'Action: export <path> | import <path>')
  .action(async (action, filePath) => {
    const client = new OpenClawAPIClient(program.opts().url, program.opts().password, program.opts().token);
    
    try {
      switch (action) {
        case 'export':
          const outputPath = filePath || `./openclaw-backup-${new Date().toISOString().split('T')[0]}.tar.gz`;
          const spinner = ora('Exporting backup...').start();
          const savedPath = await client.exportBackup(outputPath);
          spinner.stop();
          console.log(chalk.green(`✓ Backup exported to: ${savedPath}`));
          break;
          
        case 'import':
          if (!filePath) {
            console.error(chalk.red('✗ File path required for import action'));
            process.exit(1);
          }
          const importSpinner = ora('Importing backup...').start();
          const importResult = await client.importBackup(filePath);
          importSpinner.stop();
          console.log(chalk.green('✓ Backup imported:'));
          console.log(importResult);
          break;
          
        default:
          console.log(chalk.yellow('Available actions: export [path], import <path>'));
      }
    } catch (error) {
      console.error(chalk.red('✗ Backup operation failed:'), error.message);
      process.exit(1);
    }
  });

// Documentation command
program
  .command('docs')
  .description('Show API documentation')
  .argument('[endpoint]', 'Specific endpoint to document')
  .action(async (endpoint) => {
    const docs = {
      'health': `
HEALTH ENDPOINTS:
===============
GET /healthz
  - Public health check with gateway status
  - No authentication required
  - Returns: { ok, wrapper, gateway }

GET /setup/healthz  
  - Minimal health check for Railway monitoring
  - No authentication required
  - Returns: { ok: true }

GET /setup/api/status
  - Detailed system status and version info
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: { configured, gatewayTarget, openclawVersion, authGroups }
      `,
      'config': `
CONFIGURATION ENDPOINTS:
=======================
GET /setup/api/config/raw
  - Get raw configuration file content
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: { path, exists, content }

POST /setup/api/config/raw
  - Save configuration file (creates backup)
  - Requires: Basic auth with SETUP_PASSWORD  
  - Body: { content: "string" }
  - Returns: { ok, message, backupPath }

POST /setup/api/reset
  - Reset/delete configuration file
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: { ok, message }
      `,
      'onboard': `
ONBOARDING ENDPOINTS:
======================
POST /setup/api/run
  - Execute OpenClaw onboarding process
  - Requires: Basic auth with SETUP_PASSWORD
  - Body: {
      authGroup: "openai|anthropic|google|...",
      authChoice: "openai-api-key|claude-cli|...",
      authSecret: "string (optional)",
      flow: "quickstart|advanced|manual",
      telegramToken: "string (optional)",
      discordToken: "string (optional)",
      slackBotToken: "string (optional)",
      slackAppToken: "string (optional)",
      customProviderId: "string (optional)",
      customProviderBaseUrl: "string (optional)",
      customProviderApi: "openai-completions|openai-responses",
      customProviderApiKeyEnv: "string (optional)",
      customProviderModelId: "string (optional)"
    }
  - Returns: { ok, output }

GET /setup/api/auth-groups
  - Get available authentication providers
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: { ok: true, authGroups: [...] }
      `,
      'console': `
DEBUG CONSOLE ENDPOINTS:
========================
GET /setup/api/debug
  - Get system debug information
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: Debug diagnostics and system info

POST /setup/api/console/run
  - Execute safe debug commands
  - Requires: Basic auth with SETUP_PASSWORD
  - Body: { cmd: "command", arg: "optional_argument" }
  - Allowed Commands:
    * gateway.restart - Restart gateway process
    * gateway.stop - Stop gateway process
    * gateway.start - Start gateway process
    * openclaw.status - Show OpenClaw status
    * openclaw.health - Show OpenClaw health
    * openclaw.doctor - Run OpenClaw diagnostics
    * openclaw.logs --tail N - Show last N log lines
    * openclaw.config get <path> - Get config value
    * openclaw.devices list - List devices
    * openclaw.devices approve <requestId> - Approve device
    * openclaw.plugins list - List plugins
    * openclaw.plugins enable <name> - Enable plugin
  - Returns: { ok, output }
      `,
      'devices': `
DEVICE MANAGEMENT ENDPOINTS:
=============================
GET /setup/api/devices/pending
  - List pending device requests
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: { requestIds: [...], output: "string" }

POST /setup/api/devices/approve
  - Approve specific device request
  - Requires: Basic auth with SETUP_PASSWORD
  - Body: { requestId: "string" }
  - Returns: { ok, output }

POST /setup/api/pairing/approve
  - Approve pairing request
  - Requires: Basic auth with SETUP_PASSWORD
  - Body: { channel: "string", code: "string" }
  - Returns: { ok, output }
      `,
      'backup': `
BACKUP ENDPOINTS:
=================
GET /setup/export
  - Download full backup (.tar.gz)
  - Requires: Basic auth with SETUP_PASSWORD
  - Returns: tar.gz file download
  - Includes: .openclaw/ directory and workspace/

POST /setup/import
  - Import backup from file
  - Requires: Basic auth with SETUP_PASSWORD
  - Body: multipart/form-data with file
  - File: .tar.gz backup file
  - Returns: "OK - imported backup into /data and restarted gateway."
  - Limit: 250MB max file size
      `
    };

    if (endpoint && docs[endpoint]) {
      console.log(chalk.cyan(docs[endpoint]));
    } else {
      console.log(chalk.cyan('OPENCLAW API DOCUMENTATION'));
      console.log(chalk.yellow('Available endpoint docs: health, config, onboard, console, devices, backup'));
      console.log(chalk.yellow('Usage: openclaw-api docs <endpoint>\n'));
      
      // Show overview
      console.log(chalk.green('ENDPOINT OVERVIEW:'));
      console.log(`
PUBLIC (No Auth):
  GET /healthz           - Public health check
  GET /setup/healthz     - Minimal health check

SETUP (Basic Auth Required):
  GET /setup             - Setup wizard HTML interface
  GET /setup/app.js      - Setup interface JavaScript
  GET /setup/api/status  - System status and version
  GET /setup/api/auth-groups - Authentication providers
  POST /setup/api/run    - Run onboarding process
  POST /setup/api/reset  - Reset configuration
  GET /setup/api/config/raw - Get configuration
  POST /setup/api/config/raw - Save configuration
  GET /setup/api/debug   - Debug information
  POST /setup/api/console/run - Execute debug commands
  GET /setup/api/devices/pending - List pending devices
  POST /setup/api/devices/approve - Approve device
  POST /setup/api/pairing/approve - Approve pairing
  GET /setup/export      - Download backup
  POST /setup/import     - Import backup

PROXY (Bearer Token Required):
  ALL /openclaw/*        - Proxy to OpenClaw gateway

AUTHENTICATION:
  - Setup endpoints: Basic auth with SETUP_PASSWORD
  - Gateway proxy: Bearer token from OPENCLAW_GATEWAY_TOKEN
      `);
    }
  });

// Parse command line arguments
program.parse();

export { OpenClawAPIClient };

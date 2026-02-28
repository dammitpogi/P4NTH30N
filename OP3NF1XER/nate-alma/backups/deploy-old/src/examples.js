#!/usr/bin/env node

/**
 * Example scripts for OpenClaw API Client
 * Demonstrates common usage patterns and workflows
 */

import { OpenClawAPIClient } from './openclaw-api-client.js';
import fs from 'fs/promises';

// Configuration - update these values
const CONFIG = {
  baseURL: 'https://your-app.railway.app',
  setupPassword: 'your-setup-password',
  gatewayToken: 'your-gateway-token'
};

/**
 * Example 1: Health Monitoring Script
 * Monitors OpenClaw deployment health and sends alerts
 */
async function healthMonitoringExample() {
  console.log('🔍 Health Monitoring Example');
  
  const client = new OpenClawAPIClient(CONFIG.baseURL, CONFIG.setupPassword);
  
  try {
    // Get comprehensive health status
    const [publicHealth, systemStatus] = await Promise.all([
      client.getPublicHealth(),
      client.getSystemStatus()
    ]);
    
    console.log('✅ Public Health:', publicHealth.ok ? 'Healthy' : 'Unhealthy');
    console.log('📊 System Status:', systemStatus.configured ? 'Configured' : 'Not Configured');
    console.log('🔧 Gateway:', publicHealth.gateway?.reachable ? 'Running' : 'Stopped');
    
    if (!publicHealth.ok || !publicHealth.gateway?.reachable) {
      console.log('🚨 Health Issues Detected:');
      console.log('Gateway Error:', publicHealth.gateway?.lastError);
      console.log('Last Exit:', publicHealth.gateway?.lastExit);
      
      // Run diagnostics
      const debug = await client.getDebugInfo();
      console.log('🔍 Debug Info:', debug);
    }
    
  } catch (error) {
    console.error('❌ Health check failed:', error.message);
  }
}

/**
 * Example 2: Automated Onboarding Script
 * Sets up OpenClaw with predefined configuration
 */
async function automatedOnboardingExample() {
  console.log('🚀 Automated Onboarding Example');
  
  const client = new OpenClawAPIClient(CONFIG.baseURL, CONFIG.setupPassword);
  
  // Check if already configured
  const status = await client.getSystemStatus();
  if (status.configured) {
    console.log('ℹ️  OpenClaw already configured');
    return;
  }
  
  // Onboarding configuration
  const onboardingConfig = {
    authGroup: 'anthropic',
    authChoice: 'apiKey',
    authSecret: process.env.ANTHROPIC_API_KEY,
    flow: 'advanced',
    telegramToken: process.env.TELEGRAM_BOT_TOKEN,
    discordToken: process.env.DISCORD_BOT_TOKEN
  };
  
  try {
    console.log('🔄 Running onboarding...');
    const result = await client.runOnboarding(onboardingConfig);
    
    if (result.ok) {
      console.log('✅ Onboarding completed successfully');
      console.log('📋 Output:', result.output);
    } else {
      console.log('❌ Onboarding failed');
      console.log('📋 Error:', result.output);
    }
    
  } catch (error) {
    console.error('❌ Onboarding error:', error.message);
  }
}

/**
 * Example 3: Configuration Backup Script
 * Creates scheduled backups with rotation
 */
async function backupManagementExample() {
  console.log('💾 Backup Management Example');
  
  const client = new OpenClawAPIClient(CONFIG.baseURL, CONFIG.setupPassword);
  const backupDir = './backups';
  
  // Create backup directory
  try {
    await fs.mkdir(backupDir, { recursive: true });
  } catch (error) {
    // Directory might already exist
  }
  
  const timestamp = new Date().toISOString().split('T')[0];
  const backupPath = `${backupDir}/openclaw-backup-${timestamp}.tar.gz`;
  
  try {
    console.log('💾 Creating backup...');
    const savedPath = await client.exportBackup(backupPath);
    console.log(`✅ Backup saved to: ${savedPath}`);
    
    // Clean up old backups (keep last 7 days)
    const files = await fs.readdir(backupDir);
    const backupFiles = files.filter(f => f.startsWith('openclaw-backup-') && f.endsWith('.tar.gz'));
    
    if (backupFiles.length > 7) {
      backupFiles.sort();
      const filesToDelete = backupFiles.slice(0, -7);
      
      for (const file of filesToDelete) {
        await fs.unlink(`${backupDir}/${file}`);
        console.log(`🗑️  Deleted old backup: ${file}`);
      }
    }
    
  } catch (error) {
    console.error('❌ Backup failed:', error.message);
  }
}

/**
 * Example 4: Device Management Script
 * Monitors and auto-approves devices from trusted sources
 */
async function deviceManagementExample() {
  console.log('📱 Device Management Example');
  
  const client = new OpenClawAPIClient(CONFIG.baseURL, CONFIG.setupPassword);
  
  try {
    // Get pending devices
    const devices = await client.getPendingDevices();
    
    if (devices.requestIds && devices.requestIds.length > 0) {
      console.log(`📋 Found ${devices.requestIds.length} pending devices:`);
      
      for (const requestId of devices.requestIds) {
        console.log(`🔍 Device: ${requestId}`);
        
        // Auto-approve logic (customize based on your criteria)
        if (requestId.startsWith('trusted-') || requestId.includes('approved-domain')) {
          const result = await client.approveDevice(requestId);
          console.log(`✅ Auto-approved: ${requestId}`);
        } else {
          console.log(`⏳ Manual approval needed: ${requestId}`);
        }
      }
    } else {
      console.log('ℹ️  No pending devices');
    }
    
  } catch (error) {
    console.error('❌ Device management failed:', error.message);
  }
}

/**
 * Example 5: Configuration Update Script
 * Safely updates configuration with validation and rollback
 */
async function configurationUpdateExample() {
  console.log('⚙️  Configuration Update Example');
  
  const client = new OpenClawAPIClient(CONFIG.baseURL, CONFIG.setupPassword);
  
  try {
    // Create backup before making changes
    console.log('💾 Creating configuration backup...');
    const backupPath = `./config-backup-${Date.now()}.json`;
    const currentConfig = await client.getConfig();
    await fs.writeFile(backupPath, currentConfig.content || '{}');
    console.log(`✅ Backup saved to: ${backupPath}`);
    
    // Load new configuration
    const newConfigContent = await fs.readFile('./new-config.json', 'utf8');
    
    // Validate configuration (basic validation)
    try {
      const config = JSON.parse(newConfigContent);
      console.log('✅ Configuration JSON is valid');
      
      // Save new configuration
      console.log('💾 Saving new configuration...');
      const result = await client.saveConfig(newConfigContent);
      
      if (result.ok) {
        console.log('✅ Configuration updated successfully');
        
        // Verify by checking system status
        const status = await client.getSystemStatus();
        if (status.configured) {
          console.log('✅ Configuration is valid and active');
        } else {
          throw new Error('Configuration validation failed');
        }
      } else {
        throw new Error(result.message || 'Configuration save failed');
      }
      
    } catch (error) {
      console.log('❌ Configuration update failed, rolling back...');
      
      // Rollback using backup
      const backupContent = await fs.readFile(backupPath, 'utf8');
      await client.saveConfig(backupContent);
      console.log('✅ Rolled back to previous configuration');
      
      throw error;
    }
    
  } catch (error) {
    console.error('❌ Configuration update error:', error.message);
  }
}

/**
 * Example 6: Log Analysis Script
 * Retrieves and analyzes OpenClaw logs for issues
 */
async function logAnalysisExample() {
  console.log('📊 Log Analysis Example');
  
  const client = new OpenClawAPIClient(CONFIG.baseURL, CONFIG.setupPassword);
  
  try {
    console.log('📋 Retrieving recent logs...');
    const logs = await client.runConsoleCommand('openclaw.logs', '500');
    
    if (logs.ok) {
      const logLines = logs.output.split('\n');
      
      // Analyze logs for common issues
      const errorPatterns = [
        /error/i,
        /failed/i,
        /exception/i,
        /timeout/i,
        /connection refused/i
      ];
      
      const issues = logLines.filter(line => 
        errorPatterns.some(pattern => pattern.test(line))
      );
      
      console.log(`📊 Analyzed ${logLines.length} log lines`);
      console.log(`🚨 Found ${issues.length} potential issues:`);
      
      issues.slice(0, 10).forEach((issue, index) => {
        console.log(`${index + 1}. ${issue.trim()}`);
      });
      
      if (issues.length > 10) {
        console.log(`... and ${issues.length - 10} more issues`);
      }
      
      // Get system diagnostics
      console.log('\n🔍 Running system diagnostics...');
      const diagnostics = await client.runConsoleCommand('openclaw.doctor');
      console.log(diagnostics.output);
      
    } else {
      console.log('❌ Failed to retrieve logs');
    }
    
  } catch (error) {
    console.error('❌ Log analysis failed:', error.message);
  }
}

/**
 * Example 7: Multi-Environment Management
 * Manages multiple OpenClaw deployments
 */
async function multiEnvironmentExample() {
  console.log('🌍 Multi-Environment Management Example');
  
  const environments = {
    development: {
      baseURL: 'https://dev-openclaw.railway.app',
      setupPassword: process.env.DEV_SETUP_PASSWORD,
      gatewayToken: process.env.DEV_GATEWAY_TOKEN
    },
    staging: {
      baseURL: 'https://staging-openclaw.railway.app',
      setupPassword: process.env.STAGING_SETUP_PASSWORD,
      gatewayToken: process.env.STAGING_GATEWAY_TOKEN
    },
    production: {
      baseURL: 'https://prod-openclaw.railway.app',
      setupPassword: process.env.PROD_SETUP_PASSWORD,
      gatewayToken: process.env.PROD_GATEWAY_TOKEN
    }
  };
  
  for (const [envName, config] of Object.entries(environments)) {
    console.log(`\n🔍 Checking ${envName} environment...`);
    
    try {
      const client = new OpenClawAPIClient(config.baseURL, config.setupPassword, config.gatewayToken);
      const health = await client.getPublicHealth();
      
      console.log(`${envName}: ${health.ok ? '✅ Healthy' : '❌ Unhealthy'}`);
      
      if (health.gateway) {
        console.log(`  Gateway: ${health.gateway.reachable ? '✅ Running' : '❌ Stopped'}`);
        if (health.gateway.lastError) {
          console.log(`  Last Error: ${health.gateway.lastError}`);
        }
      }
      
    } catch (error) {
      console.log(`${envName}: ❌ Connection failed - ${error.message}`);
    }
  }
}

// Run examples based on command line argument
const example = process.argv[2];

const examples = {
  'health': healthMonitoringExample,
  'onboard': automatedOnboardingExample,
  'backup': backupManagementExample,
  'devices': deviceManagementExample,
  'config': configurationUpdateExample,
  'logs': logAnalysisExample,
  'multi': multiEnvironmentExample
};

if (examples[example]) {
  examples[example]().catch(console.error);
} else {
  console.log('📚 Available Examples:');
  console.log(Object.keys(examples).map(ex => `  ${ex}`).join('\n'));
  console.log('\nUsage: node examples.js <example-name>');
  console.log('\nExamples:');
  console.log('  node examples.js health    - Health monitoring');
  console.log('  node examples.js onboard   - Automated onboarding');
  console.log('  node examples.js backup    - Backup management');
  console.log('  node examples.js devices   - Device management');
  console.log('  node examples.js config    - Configuration update');
  console.log('  node examples.js logs      - Log analysis');
  console.log('  node examples.js multi     - Multi-environment management');
}

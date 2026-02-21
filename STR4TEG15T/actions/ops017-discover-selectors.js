#!/usr/bin/env node

/**
 * OPS_017: Discover Jackpot DOM/JS Selectors
 * 
 * Uses the p4nth30n-cdp-mcp server to probe FireKirin and OrionStars
 * game pages to find where jackpot values are exposed.
 * 
 * This script sends JSON-RPC requests to the MCP server via stdin
 * to evaluate JavaScript on the remote Chrome instance.
 */

import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// MCP Server path
const MCP_SERVER_PATH = join(__dirname, '..', '..', 'chrome-devtools-mcp', 'server.js');

// Chrome CDP connection details
const CDP_HOST = '192.168.56.1';
const CDP_PORT = 9222;

// Game URLs to probe
const GAME_URLS = {
  firekirin: 'https://firekirin.com/login',
  orionstars: 'https://orionstars.com/login'
};

// Candidate selectors to test
const CANDIDATE_SELECTORS = {
  windowVariables: [
    'window.game',
    'window.jackpot',
    'window.Hall',
    'window.Grand',
    'window.Major',
    'window.Minor',
    'window.Mini',
    'window.jackpots',
    'window.bonus',
    'window.prizes',
    'window.app',
    'window.vm',
    'window.store',
    'window.state'
  ],
  domSelectors: [
    '[data-jackpot]',
    '[class*="jackpot"]',
    '[id*="jackpot"]',
    '.grand-value',
    '.major-value',
    '.minor-value',
    '.mini-value',
    '.jackpot-grand',
    '.jackpot-major',
    '.jackpot-minor',
    '.jackpot-mini'
  ]
};

/**
 * Send a JSON-RPC request to the MCP server
 */
async function sendRequest(serverProcess, method, params, id) {
  return new Promise((resolve, reject) => {
    const request = {
      jsonrpc: '2.0',
      id,
      method,
      params
    };

    let responseData = '';
    
    const onData = (data) => {
      responseData += data.toString();
      
      // Try to parse complete JSON responses
      const lines = responseData.split('\n');
      for (const line of lines) {
        if (line.trim()) {
          try {
            const response = JSON.parse(line);
            if (response.id === id) {
              serverProcess.stdout.off('data', onData);
              if (response.error) {
                reject(new Error(response.error.message));
              } else {
                resolve(response.result);
              }
              return;
            }
          } catch (e) {
            // Not valid JSON yet, continue accumulating
          }
        }
      }
    };

    serverProcess.stdout.on('data', onData);
    serverProcess.stdin.write(JSON.stringify(request) + '\n');

    // Timeout after 10 seconds
    setTimeout(() => {
      serverProcess.stdout.off('data', onData);
      reject(new Error('Request timeout'));
    }, 10000);
  });
}

/**
 * Test a JavaScript expression on the remote Chrome
 */
async function evaluateScript(serverProcess, expression, requestId) {
  try {
    const result = await sendRequest(
      serverProcess,
      'tools/call',
      {
        name: 'evaluate_script',
        arguments: {
          function: expression,
          host: CDP_HOST,
          port: CDP_PORT
        }
      },
      requestId
    );
    return result;
  } catch (error) {
    return { error: error.message };
  }
}

/**
 * Navigate to a URL
 */
async function navigateToUrl(serverProcess, url, requestId) {
  try {
    const result = await sendRequest(
      serverProcess,
      'tools/call',
      {
        name: 'navigate',
        arguments: {
          url,
          host: CDP_HOST,
          port: CDP_PORT
        }
      },
      requestId
    );
    return result;
  } catch (error) {
    return { error: error.message };
  }
}

/**
 * List available CDP targets
 */
async function listTargets(serverProcess, requestId) {
  try {
    const result = await sendRequest(
      serverProcess,
      'tools/call',
      {
        name: 'list_targets',
        arguments: {
          host: CDP_HOST,
          port: CDP_PORT
        }
      },
      requestId
    );
    return result;
  } catch (error) {
    return { error: error.message };
  }
}

/**
 * Main discovery function
 */
async function discoverSelectors() {
  console.log('='.repeat(60));
  console.log('OPS_017: Jackpot Selector Discovery');
  console.log('Target: Chrome CDP at', `${CDP_HOST}:${CDP_PORT}`);
  console.log('='.repeat(60));
  console.log();

  // Start MCP server
  console.log('Starting MCP server...');
  const serverProcess = spawn('node', [MCP_SERVER_PATH, 'stdio'], {
    stdio: ['pipe', 'pipe', 'pipe']
  });

  serverProcess.stderr.on('data', (data) => {
    // Filter out server startup messages
    const msg = data.toString().trim();
    if (!msg.includes('Server started') && !msg.includes('Default target')) {
      console.error('[MCP Server Error]:', msg);
    }
  });

  // Wait for server to start
  await new Promise(resolve => setTimeout(resolve, 1000));

  let requestId = 1;
  const results = {
    timestamp: new Date().toISOString(),
    cdpHost: CDP_HOST,
    cdpPort: CDP_PORT,
    games: {}
  };

  try {
    // Initialize MCP connection
    console.log('Initializing MCP connection...');
    await sendRequest(serverProcess, 'initialize', {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: { name: 'ops017-discovery', version: '1.0' }
    }, requestId++);
    console.log('✓ MCP connection initialized');
    console.log();

    // Get Chrome version info
    console.log('Getting Chrome version...');
    const versionInfo = await sendRequest(
      serverProcess,
      'tools/call',
      { name: 'get_version', arguments: { host: CDP_HOST, port: CDP_PORT } },
      requestId++
    );
    console.log('Chrome Version:', JSON.stringify(versionInfo, null, 2));
    console.log();

    // List available targets
    console.log('Listing CDP targets...');
    const targets = await listTargets(serverProcess, requestId++);
    console.log('Available targets:', JSON.stringify(targets, null, 2));
    console.log();

    // Test each game
    for (const [gameName, gameUrl] of Object.entries(GAME_URLS)) {
      console.log('-'.repeat(60));
      console.log(`Probing ${gameName.toUpperCase()}: ${gameUrl}`);
      console.log('-'.repeat(60));

      const gameResults = {
        url: gameUrl,
        windowVariables: {},
        domSelectors: {},
        errors: []
      };

      // Navigate to the game page
      console.log('Navigating to game page...');
      const navResult = await navigateToUrl(serverProcess, gameUrl, requestId++);
      console.log('Navigation result:', navResult.error || 'Success');
      
      if (navResult.error) {
        gameResults.errors.push(`Navigation failed: ${navResult.error}`);
        results.games[gameName] = gameResults;
        continue;
      }

      // Wait for page to load
      console.log('Waiting for page load...');
      await new Promise(resolve => setTimeout(resolve, 3000));

      // Test window variables
      console.log('Testing window variables...');
      for (const variable of CANDIDATE_SELECTORS.windowVariables) {
        const expression = `() => { try { return ${variable}; } catch(e) { return null; } }`;
        const result = await evaluateScript(serverProcess, expression, requestId++);
        
        if (result.error) {
          gameResults.windowVariables[variable] = { error: result.error };
        } else if (result.content && result.content[0] && result.content[0].text) {
          const value = result.content[0].text;
          gameResults.windowVariables[variable] = { value };
          
          // Highlight potential jackpot values
          if (value && value !== 'null' && value !== 'undefined' && !value.includes('Error')) {
            console.log(`  ✓ ${variable}: ${value.substring(0, 100)}`);
          }
        }
      }

      // Test DOM selectors
      console.log('Testing DOM selectors...');
      for (const selector of CANDIDATE_SELECTORS.domSelectors) {
        const expression = `() => { 
          const el = document.querySelector('${selector}'); 
          return el ? { text: el.textContent, html: el.outerHTML.substring(0, 200) } : null; 
        }`;
        const result = await evaluateScript(serverProcess, expression, requestId++);
        
        if (result.error) {
          gameResults.domSelectors[selector] = { error: result.error };
        } else if (result.content && result.content[0] && result.content[0].text) {
          const value = result.content[0].text;
          gameResults.domSelectors[selector] = { value };
          
          if (value && value !== 'null') {
            console.log(`  ✓ ${selector}: Found element`);
          }
        }
      }

      // Additional probes for common game frameworks
      console.log('Testing common game framework patterns...');
      const frameworkProbes = [
        { name: 'Phaser', test: '() => typeof Phaser !== "undefined" ? Phaser.VERSION : null' },
        { name: 'PixiJS', test: '() => typeof PIXI !== "undefined" ? PIXI.VERSION : null' },
        { name: 'Unity', test: '() => typeof unityInstance !== "undefined" ? "Unity WebGL" : null' },
        { name: 'Cocos', test: '() => typeof cc !== "undefined" ? cc.ENGINE_VERSION : null' }
      ];

      for (const probe of frameworkProbes) {
        const result = await evaluateScript(serverProcess, probe.test, requestId++);
        if (result.content && result.content[0] && result.content[0].text) {
          const value = result.content[0].text;
          if (value && value !== 'null' && value !== 'undefined') {
            console.log(`  ✓ Framework detected: ${probe.name} (${value})`);
            gameResults.framework = { name: probe.name, version: value };
          }
        }
      }

      results.games[gameName] = gameResults;
      console.log();
    }

    // Save results
    const outputPath = join(__dirname, '..', '..', 'STR4TEG15T', 'knowledge', 'jackpot_selectors_discovery.json');
    await import('node:fs').then(fs => 
      fs.promises.writeFile(outputPath, JSON.stringify(results, null, 2))
    );
    console.log('='.repeat(60));
    console.log('Discovery complete!');
    console.log('Results saved to:', outputPath);
    console.log('='.repeat(60));

    // Generate markdown report
    await generateReport(results);

  } catch (error) {
    console.error('Discovery failed:', error);
  } finally {
    // Clean up
    serverProcess.stdin.end();
    serverProcess.kill();
  }
}

/**
 * Generate a markdown report from discovery results
 */
async function generateReport(results) {
  const reportLines = [
    '# Jackpot Selector Discovery Report',
    '',
    `**Generated**: ${results.timestamp}`,
    `**CDP Target**: ${results.cdpHost}:${results.cdpPort}`,
    '',
    '## Summary',
    ''
  ];

  for (const [gameName, gameData] of Object.entries(results.games)) {
    reportLines.push(`### ${gameName.toUpperCase()}`);
    reportLines.push('');
    reportLines.push(`- **URL**: ${gameData.url}`);
    if (gameData.framework) {
      reportLines.push(`- **Framework**: ${gameData.framework.name} ${gameData.framework.version}`);
    }
    reportLines.push('');

    // Window variables
    reportLines.push('#### Window Variables');
    reportLines.push('');
    let foundVars = false;
    for (const [variable, data] of Object.entries(gameData.windowVariables)) {
      if (data.value && data.value !== 'null' && data.value !== 'undefined') {
        reportLines.push(`- \`${variable}\`: \`${data.value.substring(0, 100)}\``);
        foundVars = true;
      }
    }
    if (!foundVars) {
      reportLines.push('*No valid window variables found*');
    }
    reportLines.push('');

    // DOM selectors
    reportLines.push('#### DOM Selectors');
    reportLines.push('');
    let foundSelectors = false;
    for (const [selector, data] of Object.entries(gameData.domSelectors)) {
      if (data.value && data.value !== 'null') {
        reportLines.push(`- \`${selector}\`: Found`);
        foundSelectors = true;
      }
    }
    if (!foundSelectors) {
      reportLines.push('*No matching DOM elements found*');
    }
    reportLines.push('');

    // Errors
    if (gameData.errors.length > 0) {
      reportLines.push('#### Errors');
      reportLines.push('');
      for (const error of gameData.errors) {
        reportLines.push(`- ${error}`);
      }
      reportLines.push('');
    }
  }

  // Recommendations
  reportLines.push('## Recommendations');
  reportLines.push('');
  reportLines.push('Based on the discovery results:');
  reportLines.push('');
  reportLines.push('1. **If window variables found**: Use direct JavaScript evaluation');
  reportLines.push('2. **If DOM selectors found**: Use CDP DOM.querySelector + DOM.getDocument');
  reportLines.push('3. **If neither works**: May need to inspect network traffic or use OCR');
  reportLines.push('');

  const reportPath = join(__dirname, '..', '..', 'STR4TEG15T', 'knowledge', 'jackpot_selectors.md');
  await import('node:fs').then(fs => 
    fs.promises.writeFile(reportPath, reportLines.join('\n'))
  );
  
  console.log('Report saved to:', reportPath);
}

// Run discovery
discoverSelectors().catch(console.error);

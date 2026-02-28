/**
 * DECISION_051: ToolHive Desktop Auto-Discovery Script
 * Discovers MCP servers from ToolHive Desktop runconfigs and generates gateway configuration
 * 
 * Usage: npx ts-node scripts/discover-toolhive-desktop.ts
 */

import * as fs from 'fs';
import * as path from 'path';
import type { ToolHiveRunconfig, ToolHiveServerConfig, DiscoveryResult } from '../src/config-types';

const TOOLHIVE_RUNCONFIGS_DIR = 'C:/Users/paulc/AppData/Local/ToolHive/runconfigs';
const OUTPUT_CONFIG_PATH = path.join(__dirname, '../config/servers.json');

/**
 * Infers appropriate tags based on server name and image
 */
function inferTags(name: string, image?: string): string[] {
  const tags: string[] = ['toolhive-desktop'];
  const lowerName = name.toLowerCase();
  const lowerImage = image?.toLowerCase() || '';

  // Web scraping / fetching
  if (lowerName.includes('fetch') || lowerName.includes('firecrawl') || lowerName.includes('tavily')) {
    tags.push('web', 'scrape', 'fetch');
  }

  // Browser automation
  if (lowerName.includes('playwright') || lowerName.includes('chrome') || lowerName.includes('browser')) {
    tags.push('browser', 'automation', 'cdp');
  }

  // Data / memory
  if (lowerName.includes('memory') || lowerName.includes('mongodb')) {
    tags.push('database', 'storage');
  }

  // Search
  if (lowerName.includes('tavily') || lowerName.includes('search') || lowerName.includes('rag')) {
    tags.push('search');
  }

  // AI / ML
  if (lowerName.includes('sequentialthinking') || lowerName.includes('thinking')) {
    tags.push('ai', 'reasoning');
  }

  // Filesystem
  if (lowerName.includes('filesystem') || lowerName.includes('files')) {
    tags.push('filesystem', 'io');
  }

  // JSON processing
  if (lowerName.includes('json')) {
    tags.push('json', 'data');
  }

  // Context/Documentation
  if (lowerName.includes('context7')) {
    tags.push('documentation', 'context');
  }

  // Brightdata proxy
  if (lowerName.includes('brightdata')) {
    tags.push('proxy', 'web', 'scrape');
  }

  // ToolHive optimizer
  if (lowerName.includes('optimizer')) {
    tags.push('tooling', 'optimization');
  }

  // P4NTHE0N specific
  if (lowerName.includes('p4nth30n') || lowerName.includes('decisions') || lowerName.includes('rag-server')) {
    tags.push('p4nth30n');
  }

  return tags;
}

/**
 * Generates a description based on server name and type
 */
function generateDescription(name: string, image?: string): string {
  const descriptions: Record<string, string> = {
    'fetch': 'Web content fetching and HTML processing',
    'firecrawl': 'Advanced web scraping with JavaScript rendering',
    'tavily-mcp': 'AI-powered web search and content extraction',
    'brightdata-mcp': 'Enterprise web data extraction via BrightData',
    'playwright': 'Browser automation and web testing',
    'memory': 'Persistent memory and context storage',
    'sequentialthinking': 'Sequential thinking and reasoning tools',
    'chrome-devtools-mcp': 'Chrome DevTools Protocol integration',
    'context7-remote': 'Documentation context and knowledge base',
    'json-query-mcp': 'JSON data querying and manipulation',
    'modelcontextprotocol-server-filesystem': 'Filesystem access and file operations',
    'mongodb-p4nth30n': 'MongoDB database access for P4NTHE0N',
    'rag-server': 'Retrieval-Augmented Generation server',
    'toolhive-mcp-optimizer': 'ToolHive MCP server optimization',
    'decisions-server': 'Decision management and workflow',
  };

  return descriptions[name] || `ToolHive Desktop server: ${name}`;
}

/**
 * Converts a runconfig to gateway server config
 */
function convertRunconfig(
  runconfig: ToolHiveRunconfig,
  filename: string
): ToolHiveServerConfig {
  const isHttp = runconfig.transport === 'streamable-http' || runconfig.proxy_mode === 'streamable-http';
  
  // Build connection details based on transport
  const connection: ToolHiveServerConfig['connection'] = {};
  
  if (isHttp) {
    // For HTTP transport, use the port to construct URL
    // ToolHive Desktop exposes servers on localhost at their assigned port
    connection.url = `http://127.0.0.1:${runconfig.port}/mcp`;
    connection.port = runconfig.port;
  } else {
    // For stdio transport, we would need to run the Docker container
    // For now, mark as HTTP since ToolHive Desktop exposes them via HTTP proxy
    connection.url = `http://127.0.0.1:${runconfig.port}/mcp`;
    connection.port = runconfig.port;
  }

  return {
    id: `toolhive-${runconfig.name}`,
    name: runconfig.name,
    transport: 'http', // ToolHive Desktop exposes all via HTTP
    connection,
    tags: inferTags(runconfig.name, runconfig.image),
    description: generateDescription(runconfig.name, runconfig.image),
    source: filename,
    image: runconfig.image,
    envVars: runconfig.env_vars,
    enabled: true,
  };
}

/**
 * Discovers all servers from ToolHive Desktop runconfigs
 */
async function discoverServers(): Promise<DiscoveryResult> {
  const result: DiscoveryResult = {
    servers: [],
    errors: [],
    summary: {
      totalFiles: 0,
      successful: 0,
      failed: 0,
    },
  };

  // Check if directory exists
  if (!fs.existsSync(TOOLHIVE_RUNCONFIGS_DIR)) {
    result.errors.push({
      file: TOOLHIVE_RUNCONFIGS_DIR,
      error: 'ToolHive Desktop runconfigs directory not found',
    });
    return result;
  }

  // Read all JSON files
  const files = fs.readdirSync(TOOLHIVE_RUNCONFIGS_DIR)
    .filter(f => f.endsWith('.json'));

  result.summary.totalFiles = files.length;

  for (const file of files) {
    const filePath = path.join(TOOLHIVE_RUNCONFIGS_DIR, file);
    
    try {
      const content = fs.readFileSync(filePath, 'utf-8');
      const runconfig: ToolHiveRunconfig = JSON.parse(content);
      
      // Validate required fields
      if (!runconfig.name || !runconfig.port) {
        result.errors.push({
          file,
          error: 'Missing required fields: name or port',
        });
        result.summary.failed++;
        continue;
      }

      const serverConfig = convertRunconfig(runconfig, file);
      result.servers.push(serverConfig);
      result.summary.successful++;
      
      console.log(`[Discovery] Found: ${serverConfig.name} (port ${serverConfig.connection.port})`);
    } catch (err) {
      result.errors.push({
        file,
        error: err instanceof Error ? err.message : String(err),
      });
      result.summary.failed++;
    }
  }

  return result;
}

/**
 * Generates the servers.json configuration file
 */
function generateConfig(servers: ToolHiveServerConfig[]): string {
  const config = {
    schemaVersion: '1.0.0',
    lastUpdated: new Date().toISOString(),
    sourceDirectory: TOOLHIVE_RUNCONFIGS_DIR,
    servers: servers.sort((a, b) => a.name.localeCompare(b.name)),
    metadata: {
      totalServers: servers.length,
      enabledServers: servers.filter(s => s.enabled).length,
      httpServers: servers.filter(s => s.transport === 'http').length,
      stdioServers: servers.filter(s => s.transport === 'stdio').length,
    },
  };

  return JSON.stringify(config, null, 2);
}

/**
 * Main discovery function
 */
async function main(): Promise<void> {
  console.log('[ToolHive Discovery] Starting auto-discovery...');
  console.log(`[ToolHive Discovery] Scanning: ${TOOLHIVE_RUNCONFIGS_DIR}`);

  const result = await discoverServers();

  console.log('\n[ToolHive Discovery] Summary:');
  console.log(`  Total files scanned: ${result.summary.totalFiles}`);
  console.log(`  Successfully parsed: ${result.summary.successful}`);
  console.log(`  Failed: ${result.summary.failed}`);

  if (result.errors.length > 0) {
    console.log('\n[ToolHive Discovery] Errors:');
    for (const err of result.errors) {
      console.log(`  - ${err.file}: ${err.error}`);
    }
  }

  if (result.servers.length === 0) {
    console.error('[ToolHive Discovery] No servers found!');
    process.exit(1);
  }

  // Ensure config directory exists
  const configDir = path.dirname(OUTPUT_CONFIG_PATH);
  if (!fs.existsSync(configDir)) {
    fs.mkdirSync(configDir, { recursive: true });
  }

  // Write configuration
  const configJson = generateConfig(result.servers);
  fs.writeFileSync(OUTPUT_CONFIG_PATH, configJson, 'utf-8');

  console.log(`\n[ToolHive Discovery] Configuration written to: ${OUTPUT_CONFIG_PATH}`);
  console.log(`[ToolHive Discovery] Total servers: ${result.servers.length}`);
  
  // List discovered servers
  console.log('\n[ToolHive Discovery] Discovered servers:');
  for (const server of result.servers) {
    console.log(`  ✓ ${server.name} (${server.transport}, port ${server.connection.port})`);
  }
}

// Run if executed directly
if (require.main === module) {
  main().catch(err => {
    console.error('[ToolHive Discovery] Fatal error:', err);
    process.exit(1);
  });
}

export { discoverServers, generateConfig, convertRunconfig };

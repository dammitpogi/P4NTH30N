/**
 * MIGRATE-004 + DECISION_051: ToolHive Gateway - Unified MCP Tool Discovery & Routing
 *
 * MCP server that acts as a gateway for discovering, routing, and monitoring
 * all P4NTH30N tool servers. Provides:
 * - Tool discovery across all registered MCP servers
 * - Health monitoring for all servers
 * - Agent-specific tool filtering
 * - Context-efficient tool summaries
 * - External configuration support for ToolHive Desktop integration
 *
 * Protocol: MCP 2024-11-05 via stdio
 */

import * as fs from 'fs';
import * as path from 'path';
import { McpServerRegistry } from './registry';
import { McpDiscovery, discoverHttpServerTools } from './discovery';
import { McpHealthMonitor } from './health';
import { createTransport, StdioTransport, type Transport } from './transports';
import type { ServersConfig, ToolHiveServerConfig } from './config-types';

// Initialize components
const registry = new McpServerRegistry();
const discovery = new McpDiscovery(registry);
const healthMonitor = new McpHealthMonitor(registry);

// Active transport connections
const transports = new Map<string, Transport>();

// Configuration paths
const CONFIG_PATH = path.join(__dirname, '../config/servers.json');

/**
 * Routes a tool call to the appropriate underlying MCP server
 */
async function routeToolCall(
  serverId: string,
  toolName: string,
  args: Record<string, unknown>
): Promise<{ content: Array<{ type: string; text?: string; data?: unknown }> }> {
  const server = registry.get(serverId);

  if (!server) {
    throw new Error(`Unknown server: ${serverId}`);
  }

  if (server.status !== 'healthy' && server.status !== 'registered') {
    throw new Error(`Server ${serverId} is ${server.status}`);
  }

  // Get or create transport
  let transport = transports.get(serverId);
  if (!transport) {
    if (server.transport === 'stdio') {
      const stdioTransport = new StdioTransport({
        command: server.connection.command!,
        args: server.connection.args || [],
      });
      await stdioTransport.initialize();
      transport = stdioTransport;
    } else if (server.transport === 'http') {
      transport = createTransport('http', { url: server.connection.url! });
    } else {
      throw new Error(`Unsupported transport: ${server.transport}`);
    }
    transports.set(serverId, transport);
    server.transportInstance = transport;
  }

  // Call the tool
  const result = await transport.call(toolName, args);
  return result as { content: Array<{ type: string; text?: string; data?: unknown }> };
}

// Register built-in P4NTH30N servers
function registerBuiltinServers(): void {
  // 1. FourEyes MCP - Vision and analysis via CDP + LMStudio
  registry.register({
    id: 'foureyes-mcp',
    name: 'FourEyes MCP Server',
    transport: 'stdio',
    connection: { 
      command: 'node', 
      args: ['C:/P4NTH30N/tools/mcp-foureyes/server.js'],
    },
    tools: [
      { name: 'analyze_frame', description: 'Capture CDP screenshot and analyze via LMStudio vision model' },
      { name: 'capture_screenshot', description: 'Capture PNG screenshot from Chrome via CDP' },
      { name: 'check_health', description: 'Check FourEyes subsystem health (LMStudio + CDP)' },
      { name: 'list_models', description: 'List available models in LMStudio' },
      { name: 'review_decision', description: 'FourEyes second-opinion review of a decision' },
    ],
    tags: ['browser', 'cdp', 'vision', 'lmstudio', 'analysis'],
    description: 'FourEyes vision capabilities - CDP screenshots + LMStudio vision analysis',
  });

  // 2. RAG MCP Server - Knowledge base and document search (HTTP mode)
  registry.register({
    id: 'rag-server',
    name: 'RAG MCP Server',
    transport: 'http',
    connection: { 
      url: 'http://localhost:5001/mcp',
    },
    tools: [
      { name: 'rag_query', description: 'Search P4NTH30N knowledge base' },
      { name: 'rag_ingest', description: 'Ingest document into knowledge base' },
      { name: 'rag_status', description: 'Check RAG system status' },
    ],
    tags: ['search', 'rag', 'knowledge', 'embeddings'],
    description: 'Retrieval-Augmented Generation for P4NTH30N docs and decisions',
  });

  // 3. P4NTH30N MCP - MongoDB data access
  registry.register({
    id: 'p4nth30n-mcp',
    name: 'P4NTH30N MCP Server',
    transport: 'stdio',
    connection: { 
      command: 'node', 
      args: ['C:/P4NTH30N/tools/mcp-p4nthon/dist/index.js'],
    },
    tools: [
      { name: 'query_credentials', description: 'Query CRED3N7IAL collection for user credentials and thresholds' },
      { name: 'query_signals', description: 'Query SIGN4L collection for active signals' },
      { name: 'query_jackpots', description: 'Query J4CKP0T collection for jackpot forecasts' },
      { name: 'get_system_status', description: 'Get overall P4NTH30N system status summary' },
    ],
    tags: ['database', 'mongodb', 'casino', 'automation'],
    description: 'P4NTH30N platform data access - credentials, signals, jackpots',
  });

  // 4. Decisions Server - Docker container with stdio transport
  // DECISION_050: Fixed MongoDB connection for Windows Docker
  // - Uses host IP (192.168.56.1) to access MongoDB running on Windows host
  // - directConnection=true prevents MongoDB driver from discovering replica set
  registry.register({
    id: 'decisions-server',
    name: 'Decisions MCP Server',
    transport: 'stdio',
    connection: {
      command: 'docker',
      args: ['run', '-i', '--rm', '-e', 'MONGODB_URI=mongodb://192.168.56.1:27017/P4NTH30N?directConnection=true', 'decisions-server:v1.2.0'],
    },
    tools: [
      { name: 'connect', description: 'Connect to MongoDB database' },
      { name: 'disconnect', description: 'Disconnect from database' },
      { name: 'findById', description: 'Find a decision by its ID with optional field projection' },
      { name: 'findByCategory', description: 'Find decisions by category with optional field projection' },
      { name: 'findByStatus', description: 'Find decisions by status with optional field projection' },
      { name: 'search', description: 'Search decisions by title or description' },
      { name: 'createDecision', description: 'Create a new decision record with optional dependencies' },
      { name: 'updateStatus', description: 'Update decision status with history tracking' },
      { name: 'updateImplementation', description: 'Update implementation details' },
      { name: 'addActionItem', description: 'Add an action item to a decision' },
      { name: 'getDependencies', description: 'Find decisions that depend on a given decision' },
      { name: 'getBlocking', description: 'Find decisions blocking InProgress items' },
      { name: 'summarize', description: 'Get brief summary of a decision without full details' },
      { name: 'getTasks', description: 'Extract all actionable tasks from decisions' },
      { name: 'getStats', description: 'Get decision statistics with category breakdown' },
      { name: 'listCategories', description: 'List all decision categories' },
    ],
    tags: ['decisions', 'workflow', 'strategist'],
    description: 'Decision management server for P4NTH30N workflow',
  });

  // 5. Honeybelt Server - Tooling and operations
  registry.register({
    id: 'honeybelt-server',
    name: 'Honeybelt MCP Server',
    transport: 'stdio',
    connection: { 
      command: 'node', 
      args: ['C:/P4NTH30N/tools/mcp-development/servers/honeybelt-server/dist/index.js'],
    },
    tools: [
      { name: 'honeybelt_status', description: 'Check honeybelt service status' },
      { name: 'honeybelt_operations', description: 'Execute honeybelt operations' },
      { name: 'honeybelt_report', description: 'Generate honeybelt reports' },
    ],
    tags: ['tooling', 'operations'],
    description: 'Honeybelt operations and reporting MCP server',
  });
}

/**
 * Loads external server configuration from config/servers.json
 * DECISION_051: ToolHive Desktop Integration
 */
function loadExternalConfig(): number {
  try {
    if (!fs.existsSync(CONFIG_PATH)) {
      console.error(`[Config] External configuration not found: ${CONFIG_PATH}`);
      return 0;
    }

    const content = fs.readFileSync(CONFIG_PATH, 'utf-8');
    const config: ServersConfig = JSON.parse(content);

    if (!config.servers || !Array.isArray(config.servers)) {
      console.error('[Config] Invalid configuration: servers array missing');
      return 0;
    }

    let registered = 0;

    for (const serverConfig of config.servers) {
      if (!serverConfig.enabled) {
        console.log(`[Config] Skipping disabled server: ${serverConfig.name}`);
        continue;
      }

      try {
        // Check for duplicate IDs
        if (registry.get(serverConfig.id)) {
          console.warn(`[Config] Server ID already exists, skipping: ${serverConfig.id}`);
          continue;
        }

        // Register the server
        registry.register({
          id: serverConfig.id,
          name: serverConfig.name,
          transport: serverConfig.transport as 'stdio' | 'http',
          connection: serverConfig.connection,
          tools: [], // Tools will be discovered dynamically
          tags: serverConfig.tags,
          description: serverConfig.description,
        });

        registered++;
        console.log(`[Config] Registered external server: ${serverConfig.name}`);
      } catch (err) {
        console.error(`[Config] Failed to register server ${serverConfig.name}: ${err}`);
      }
    }

    console.log(`[Config] Loaded ${registered} servers from external configuration`);
    return registered;
  } catch (err) {
    console.error(`[Config] Failed to load external configuration: ${err}`);
    return 0;
  }
}

// MCP stdio transport handler
interface McpRequest {
  jsonrpc: '2.0';
  id: number | string;
  method: string;
  params?: Record<string, unknown>;
}

interface McpResponse {
  jsonrpc: '2.0';
  id: number | string;
  result?: unknown;
  error?: { code: number; message: string };
}

async function handleRequest(request: McpRequest): Promise<McpResponse> {
  switch (request.method) {
    case 'initialize':
      return {
        jsonrpc: '2.0',
        id: request.id,
        result: {
          protocolVersion: '2024-11-05',
          capabilities: { tools: { listChanged: true } },
          serverInfo: { name: 'toolhive-gateway', version: '1.0.0' },
        },
      };

    case 'tools/list': {
      // Aggregate all tools from registered servers plus gateway meta-tools
      const serverTools = registry.listAllTools().map(t => ({
        name: `${t.serverId}.${t.tool.name}`,
        description: `[${t.serverName}] ${t.tool.description}`,
        inputSchema: t.tool.inputSchema || { type: 'object', properties: {} },
      }));

      const gatewayTools = [
        {
          name: 'list_servers',
          description: 'List all registered MCP servers and their status',
          inputSchema: { type: 'object', properties: { tag: { type: 'string', description: 'Filter by tag' } } },
        },
        {
          name: 'list_tools',
          description: 'List all available tools across all healthy servers',
          inputSchema: { type: 'object', properties: { agent: { type: 'string', description: 'Filter by agent' } } },
        },
        {
          name: 'server_health',
          description: 'Get health status of all registered servers',
          inputSchema: { type: 'object', properties: {} },
        },
        {
          name: 'find_tool',
          description: 'Find which server provides a specific tool',
          inputSchema: {
            type: 'object',
            properties: { toolName: { type: 'string', description: 'Tool name to find' } },
            required: ['toolName'],
          },
        },
        {
          name: 'registry_summary',
          description: 'Get a compact summary of the tool registry for context injection',
          inputSchema: { type: 'object', properties: {} },
        },
      ];

      return {
        jsonrpc: '2.0',
        id: request.id,
        result: {
          tools: [...gatewayTools, ...serverTools],
        },
      };
    }

    case 'tools/call': {
      const toolName = (request.params as any)?.name;
      const args = (request.params as any)?.arguments || {};

      // Check if this is a proxied tool call (contains dot separator)
      if (toolName.includes('.')) {
        const [serverId, actualToolName] = toolName.split('.', 2);

        try {
          const result = await routeToolCall(serverId, actualToolName, args);
          return {
            jsonrpc: '2.0',
            id: request.id,
            result,
          };
        } catch (err) {
          const errorMessage = err instanceof Error ? err.message : String(err);
          return {
            jsonrpc: '2.0',
            id: request.id,
            error: { code: -32000, message: errorMessage },
          };
        }
      }

      // Handle gateway meta-tools
      switch (toolName) {
        case 'list_servers': {
          const servers = args.tag
            ? registry.listByTag(args.tag as string)
            : registry.listAll();
          return {
            jsonrpc: '2.0',
            id: request.id,
            result: {
              content: [{
                type: 'text',
                text: JSON.stringify(servers.map(s => ({
                  id: s.id,
                  name: s.name,
                  status: s.status,
                  tools: s.tools.length,
                  tags: s.tags,
                })), null, 2),
              }],
            },
          };
        }

        case 'list_tools': {
          const tools = registry.listAllTools();
          return {
            jsonrpc: '2.0',
            id: request.id,
            result: {
              content: [{
                type: 'text',
                text: JSON.stringify(tools.map(t => ({
                  server: t.serverName,
                  tool: t.tool.name,
                  description: t.tool.description,
                })), null, 2),
              }],
            },
          };
        }

        case 'server_health': {
          return {
            jsonrpc: '2.0',
            id: request.id,
            result: {
              content: [{ type: 'text', text: healthMonitor.getSummary() }],
            },
          };
        }

        case 'find_tool': {
          const found = registry.findTool(args.toolName as string);
          return {
            jsonrpc: '2.0',
            id: request.id,
            result: {
              content: [{
                type: 'text',
                text: found
                  ? JSON.stringify({ server: found.server.id, serverName: found.server.name, tool: found.tool }, null, 2)
                  : `Tool '${args.toolName}' not found in any registered server`,
              }],
            },
          };
        }

        case 'registry_summary': {
          return {
            jsonrpc: '2.0',
            id: request.id,
            result: {
              content: [{ type: 'text', text: registry.getSummary() }],
            },
          };
        }

        default:
          return {
            jsonrpc: '2.0',
            id: request.id,
            error: { code: -32601, message: `Unknown tool: ${toolName}` },
          };
      }
    }

    default:
      return {
        jsonrpc: '2.0',
        id: request.id,
        error: { code: -32601, message: `Method not found: ${request.method}` },
      };
  }
}

// Main: stdio MCP transport
async function main(): Promise<void> {
  console.error('[ToolHive Gateway] Starting...');

  // Register built-in servers
  registerBuiltinServers();

  // Load external configuration (DECISION_051)
  const externalCount = loadExternalConfig();

  // Discover external servers from legacy config files
  await discovery.scan();

  // Discover tools from HTTP servers (DECISION_051 fix)
  console.error('[ToolHive Gateway] Discovering tools from HTTP servers...');
  const discoveredToolServers = await discoverHttpServerTools(registry);
  console.error(`[ToolHive Gateway] Discovered tools from ${discoveredToolServers} HTTP servers`);

  // Start health monitoring
  healthMonitor.start();

  const totalServers = registry.listAll().length;
  const totalTools = registry.listAll().reduce((sum, s) => sum + s.tools.length, 0);
  console.error(`[ToolHive Gateway] Ready. ${totalServers} servers registered (${externalCount} from ToolHive Desktop), ${totalTools} total tools.`);

  // Read JSON-RPC messages from stdin
  let buffer = '';
  process.stdin.setEncoding('utf-8');
  process.stdin.on('data', async (chunk: string) => {
    buffer += chunk;

    // Process complete JSON-RPC messages (newline-delimited)
    const lines = buffer.split('\n');
    buffer = lines.pop() || '';

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;

      try {
        const request = JSON.parse(trimmed) as McpRequest;
        const response = await handleRequest(request);
        process.stdout.write(JSON.stringify(response) + '\n');
      } catch (err) {
        console.error(`[ToolHive Gateway] Parse error: ${err}`);
      }
    }
  });

  process.stdin.on('end', () => {
    healthMonitor.stop();
    discovery.stopPeriodicScan();
    console.error('[ToolHive Gateway] Shutdown');
    process.exit(0);
  });
}

main().catch(err => {
  console.error(`[ToolHive Gateway] Fatal: ${err}`);
  process.exit(1);
});

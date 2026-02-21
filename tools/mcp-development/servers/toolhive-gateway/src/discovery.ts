/**
 * MIGRATE-004: MCP Server Auto-Discovery
 * Discovers MCP servers from configuration files and running processes.
 * Supports windsurf mcp_config.json format and manual registration.
 */

import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { McpServerRegistry, McpServerEntry, McpToolEntry } from './registry';

/**
 * Parses SSE (Server-Sent Events) format response to extract JSON data.
 * Handles format like: "event: message\ndata: {...json...}"
 */
function parseSseResponse(text: string): unknown {
  const lines = text.split('\n');
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith('data:')) {
      const jsonStr = trimmed.slice(5).trim();
      try {
        return JSON.parse(jsonStr);
      } catch {
        // Continue to next line if this one isn't valid JSON
      }
    }
  }
  return null;
}

/**
 * Makes a JSON-RPC request to an MCP HTTP server.
 * Supports both standard JSON and SSE (Server-Sent Events) format.
 */
async function makeMcpRequest(
  url: string,
  method: string,
  params?: Record<string, unknown>,
  requestId = 1,
): Promise<{
  result?: { tools?: McpToolEntry[] };
  error?: { code: number; message: string };
} | null> {
  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: requestId,
      method,
      params,
    }),
  });

  if (!response.ok) {
    console.error(`[Discovery] HTTP error ${response.status} from ${url}`);
    return null;
  }

  const text = await response.text();

  // Check if response is SSE format
  if (text.trim().startsWith('event:') || (text.includes('event:') && text.includes('data:'))) {
    const parsed = parseSseResponse(text);
    return parsed as { result?: { tools?: McpToolEntry[] }; error?: { code: number; message: string } };
  }

  // Standard JSON response
  try {
    return JSON.parse(text) as { result?: { tools?: McpToolEntry[] }; error?: { code: number; message: string } };
  } catch (err) {
    console.error(`[Discovery] Failed to parse JSON response from ${url}: ${err}`);
    return null;
  }
}

/**
 * Fetches tools from an HTTP MCP server via the tools/list method.
 * Handles both simple HTTP MCP and streamable HTTP MCP (requires initialization).
 * @param url The MCP server URL (e.g., http://127.0.0.1:port/mcp)
 * @returns Array of tool entries, or empty array if fetch fails
 */
export async function fetchToolsFromHttpServer(url: string): Promise<McpToolEntry[]> {
  try {
    // First, try to get tools directly (simple HTTP MCP)
    let data = await makeMcpRequest(url, 'tools/list', undefined, 1);

    // If we got an error about session initialization, try streamable HTTP MCP
    if (data?.error?.message?.includes('initialization') || data?.error?.message?.includes('session')) {
      console.log(`[Discovery] Server ${url} requires initialization, using streamable HTTP MCP`);

      // Initialize the session
      const initResult = await makeMcpRequest(url, 'initialize', {
        protocolVersion: '2024-11-05',
        capabilities: {},
        clientInfo: { name: 'toolhive-gateway', version: '1.0.0' },
      }, 1);

      if (initResult?.error) {
        console.error(`[Discovery] Initialization failed for ${url}: ${initResult.error.message}`);
        return [];
      }

      // Now try tools/list again
      data = await makeMcpRequest(url, 'tools/list', undefined, 2);
    }

    if (!data) {
      console.error(`[Discovery] No response from ${url}`);
      return [];
    }

    if (data.error) {
      console.error(`[Discovery] MCP error from ${url}: ${data.error.message}`);
      return [];
    }

    const tools = data.result?.tools || [];
    console.log(`[Discovery] Fetched ${tools.length} tools from ${url}`);
    return tools;
  } catch (err) {
    const errorMessage = err instanceof Error ? err.message : String(err);
    console.error(`[Discovery] Failed to fetch tools from ${url}: ${errorMessage}`);
    return [];
  }
}

/**
 * Discovers tools from all HTTP servers in the registry.
 * Updates each server's tools array with discovered tools.
 * @param registry The MCP server registry
 * @returns Number of servers that had tools discovered
 */
export async function discoverHttpServerTools(registry: McpServerRegistry): Promise<number> {
  const servers = registry.listAll().filter(s => s.transport === 'http');
  let discoveredCount = 0;

  for (const server of servers) {
    const url = server.connection.url;
    if (!url) {
      console.warn(`[Discovery] HTTP server ${server.id} has no URL, skipping`);
      continue;
    }

    console.log(`[Discovery] Querying tools from ${server.name} at ${url}`);
    const tools = await fetchToolsFromHttpServer(url);

    if (tools.length > 0) {
      // Update the server's tools in the registry
      server.tools = tools;
      discoveredCount++;
      console.log(`[Discovery] Updated ${server.name} with ${tools.length} tools: ${tools.map(t => t.name).join(', ')}`);
    } else {
      console.log(`[Discovery] No tools discovered from ${server.name}`);
    }
  }

  console.log(`[Discovery] Tool discovery complete: ${discoveredCount}/${servers.length} HTTP servers had tools`);
  return discoveredCount;
}

export interface DiscoveryConfig {
  /** Paths to scan for MCP config files */
  configPaths: string[];
  /** Whether to auto-register discovered servers */
  autoRegister: boolean;
  /** Discovery scan interval in ms (0 = one-shot) */
  scanIntervalMs: number;
}

const DEFAULT_CONFIG: DiscoveryConfig = {
  configPaths: [
    path.join(os.homedir(), '.codeium', 'windsurf', 'mcp_config.json'),
    path.join(os.homedir(), '.config', 'opencode', 'mcp-config.json'),
  ],
  autoRegister: true,
  scanIntervalMs: 0,
};

export class McpDiscovery {
  private config: DiscoveryConfig;
  private registry: McpServerRegistry;
  private scanInterval?: ReturnType<typeof setInterval>;

  constructor(registry: McpServerRegistry, config?: Partial<DiscoveryConfig>) {
    this.registry = registry;
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Performs a one-time discovery scan.
   * Returns the number of servers discovered.
   */
  async scan(): Promise<number> {
    let discovered = 0;

    for (const configPath of this.config.configPaths) {
      try {
        const servers = await this.scanConfigFile(configPath);
        discovered += servers.length;

        if (this.config.autoRegister) {
          for (const server of servers) {
            this.registry.register(server);
          }
        }
      } catch (err) {
        // Config file not found or invalid — skip silently
      }
    }

    console.log(`[Discovery] Scan complete: ${discovered} servers discovered`);
    return discovered;
  }

  /**
   * Starts periodic discovery scanning.
   */
  startPeriodicScan(): void {
    if (this.config.scanIntervalMs <= 0) return;

    this.scan(); // Initial scan
    this.scanInterval = setInterval(() => this.scan(), this.config.scanIntervalMs);
    console.log(`[Discovery] Periodic scan started (interval: ${this.config.scanIntervalMs}ms)`);
  }

  /**
   * Stops periodic scanning.
   */
  stopPeriodicScan(): void {
    if (this.scanInterval) {
      clearInterval(this.scanInterval);
      this.scanInterval = undefined;
    }
  }

  /**
   * Scans a single MCP config file (Windsurf/Codeium format).
   */
  private async scanConfigFile(
    configPath: string,
  ): Promise<Array<Omit<McpServerEntry, 'registeredAt' | 'status'>>> {
    if (!fs.existsSync(configPath)) return [];

    const content = fs.readFileSync(configPath, 'utf-8');
    const config = JSON.parse(content);
    const servers: Array<Omit<McpServerEntry, 'registeredAt' | 'status'>> = [];

    // Windsurf format: { mcpServers: { "server-name": { command, args, ... } } }
    const mcpServers = config.mcpServers || config.servers || {};

    for (const [name, serverConfig] of Object.entries(mcpServers)) {
      const cfg = serverConfig as Record<string, unknown>;
      const isDisabled = cfg.disabled === true;

      const entry: Omit<McpServerEntry, 'registeredAt' | 'status'> = {
        id: `discovered-${name}`,
        name: String(name),
        transport: cfg.url ? 'http' : 'stdio',
        connection: {
          command: cfg.command as string | undefined,
          args: cfg.args as string[] | undefined,
          url: cfg.url as string | undefined,
        },
        tools: [], // Tools will be populated after connecting
        tags: this.inferTags(name, cfg),
        description: `Discovered from ${path.basename(configPath)}${isDisabled ? ' (disabled)' : ''}`,
      };

      servers.push(entry);
    }

    console.log(`[Discovery] Found ${servers.length} servers in ${configPath}`);
    return servers;
  }

  /**
   * Infers tags from server name and config.
   */
  private inferTags(name: string, config: Record<string, unknown>): string[] {
    const tags: string[] = [];
    const lower = name.toLowerCase();

    if (lower.includes('mongo') || lower.includes('database') || lower.includes('db'))
      tags.push('database');
    if (lower.includes('chrome') || lower.includes('cdp') || lower.includes('browser'))
      tags.push('browser');
    if (lower.includes('rag') || lower.includes('search') || lower.includes('embed'))
      tags.push('search');
    if (lower.includes('honeybelt') || lower.includes('tool'))
      tags.push('tooling');
    if (lower.includes('decision') || lower.includes('strategist'))
      tags.push('decisions');

    if (tags.length === 0) tags.push('general');
    return tags;
  }
}

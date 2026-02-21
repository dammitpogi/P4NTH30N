/**
 * MIGRATE-004: MCP Server Registry
 * Maintains a registry of all available MCP servers, their tools, and metadata.
 * Supports dynamic registration, deregistration, and capability querying.
 */

import type { Transport } from './transports';

export interface McpServerEntry {
  /** Unique server identifier */
  id: string;
  /** Human-readable name */
  name: string;
  /** Server transport type */
  transport: 'stdio' | 'http' | 'sse';
  /** Connection details */
  connection: {
    command?: string;
    args?: string[];
    url?: string;
    port?: number;
  };
  /** Tools provided by this server */
  tools: McpToolEntry[];
  /** Server status */
  status: 'registered' | 'healthy' | 'unhealthy' | 'disabled';
  /** Tags for filtering (e.g., 'database', 'browser', 'search') */
  tags: string[];
  /** When the server was registered */
  registeredAt: Date;
  /** Last health check timestamp */
  lastHealthCheck?: Date;
  /** Server description */
  description: string;
  /** Transport instance for making calls */
  transportInstance?: Transport;
}

export interface McpToolEntry {
  /** Tool name (as exposed via MCP) */
  name: string;
  /** Tool description */
  description: string;
  /** Input schema */
  inputSchema?: Record<string, unknown>;
  /** Which agents can use this tool */
  allowedAgents?: string[];
}

export class McpServerRegistry {
  private servers: Map<string, McpServerEntry> = new Map();
  private listeners: Array<(event: RegistryEvent) => void> = [];

  /**
   * Registers a new MCP server.
   */
  register(entry: Omit<McpServerEntry, 'registeredAt' | 'status'>): McpServerEntry {
    const server: McpServerEntry = {
      ...entry,
      status: 'registered',
      registeredAt: new Date(),
    };
    this.servers.set(server.id, server);
    this.emit({ type: 'registered', serverId: server.id });
    console.log(`[Registry] Registered: ${server.name} (${server.id}) with ${server.tools.length} tools`);
    return server;
  }

  /**
   * Removes a server from the registry.
   */
  deregister(serverId: string): boolean {
    const removed = this.servers.delete(serverId);
    if (removed) {
      this.emit({ type: 'deregistered', serverId });
      console.log(`[Registry] Deregistered: ${serverId}`);
    }
    return removed;
  }

  /**
   * Gets a server by ID.
   */
  get(serverId: string): McpServerEntry | undefined {
    return this.servers.get(serverId);
  }

  /**
   * Lists all registered servers.
   */
  listAll(): McpServerEntry[] {
    return Array.from(this.servers.values());
  }

  /**
   * Lists servers matching a tag filter.
   */
  listByTag(tag: string): McpServerEntry[] {
    return this.listAll().filter(s => s.tags.includes(tag));
  }

  /**
   * Lists only healthy servers.
   */
  listHealthy(): McpServerEntry[] {
    return this.listAll().filter(s => s.status === 'healthy' || s.status === 'registered');
  }

  /**
   * Finds a tool across all servers.
   */
  findTool(toolName: string): { server: McpServerEntry; tool: McpToolEntry } | undefined {
    for (const server of this.servers.values()) {
      const tool = server.tools.find(t => t.name === toolName);
      if (tool) return { server, tool };
    }
    return undefined;
  }

  /**
   * Lists all available tools across all healthy servers.
   */
  listAllTools(): Array<{ serverId: string; serverName: string; tool: McpToolEntry }> {
    const tools: Array<{ serverId: string; serverName: string; tool: McpToolEntry }> = [];
    for (const server of this.listHealthy()) {
      for (const tool of server.tools) {
        tools.push({ serverId: server.id, serverName: server.name, tool });
      }
    }
    return tools;
  }

  /**
   * Updates server status.
   */
  updateStatus(serverId: string, status: McpServerEntry['status']): void {
    const server = this.servers.get(serverId);
    if (server) {
      const old = server.status;
      server.status = status;
      server.lastHealthCheck = new Date();
      if (old !== status) {
        this.emit({ type: 'status_changed', serverId, oldStatus: old, newStatus: status });
      }
    }
  }

  /**
   * Returns registry summary for context injection.
   */
  getSummary(): string {
    const servers = this.listAll();
    const lines = [
      `MCP Server Registry: ${servers.length} servers, ${servers.reduce((s, sv) => s + sv.tools.length, 0)} tools`,
      '',
    ];
    for (const s of servers) {
      lines.push(`  [${s.status}] ${s.name} (${s.id}): ${s.tools.map(t => t.name).join(', ')}`);
    }
    return lines.join('\n');
  }

  /**
   * Registers an event listener.
   */
  onEvent(listener: (event: RegistryEvent) => void): void {
    this.listeners.push(listener);
  }

  private emit(event: RegistryEvent): void {
    for (const listener of this.listeners) {
      try { listener(event); } catch { /* ignore */ }
    }
  }
}

export interface RegistryEvent {
  type: 'registered' | 'deregistered' | 'status_changed';
  serverId: string;
  oldStatus?: string;
  newStatus?: string;
}

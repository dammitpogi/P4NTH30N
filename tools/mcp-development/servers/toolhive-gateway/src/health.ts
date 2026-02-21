/**
 * MIGRATE-004: MCP Server Health Monitoring
 * Periodically checks server health and updates registry status.
 */

import { McpServerRegistry, McpServerEntry } from './registry';
import { StdioTransport, createTransport } from './transports';

export interface HealthConfig {
  /** Health check interval in ms (default: 60000) */
  checkIntervalMs: number;
  /** Timeout for individual health checks in ms (default: 5000) */
  timeoutMs: number;
  /** Number of consecutive failures before marking unhealthy (default: 3) */
  failureThreshold: number;
}

const DEFAULT_CONFIG: HealthConfig = {
  checkIntervalMs: 60000,
  timeoutMs: 5000,
  failureThreshold: 3,
};

export interface HealthCheckResult {
  serverId: string;
  healthy: boolean;
  latencyMs: number;
  error?: string;
  checkedAt: Date;
}

export class McpHealthMonitor {
  private config: HealthConfig;
  private registry: McpServerRegistry;
  private interval?: ReturnType<typeof setInterval>;
  private failureCounts: Map<string, number> = new Map();
  private results: HealthCheckResult[] = [];

  constructor(registry: McpServerRegistry, config?: Partial<HealthConfig>) {
    this.registry = registry;
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Starts periodic health checking for all registered servers.
   */
  start(): void {
    this.checkAll(); // Initial check
    this.interval = setInterval(() => this.checkAll(), this.config.checkIntervalMs);
    console.log(`[Health] Monitoring started (interval: ${this.config.checkIntervalMs}ms)`);
  }

  /**
   * Stops health monitoring.
   */
  stop(): void {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = undefined;
    }
  }

  /**
   * Checks health of all registered servers.
   */
  async checkAll(): Promise<HealthCheckResult[]> {
    const servers = this.registry.listAll();
    const results: HealthCheckResult[] = [];

    for (const server of servers) {
      if (server.status === 'disabled') continue;
      const result = await this.checkServer(server);
      results.push(result);
    }

    this.results = results;
    return results;
  }

  /**
   * Checks health of a single server.
   */
  async checkServer(server: McpServerEntry): Promise<HealthCheckResult> {
    const start = Date.now();

    try {
      const healthy = await this.performHealthCheck(server);
      const latency = Date.now() - start;

      const result: HealthCheckResult = {
        serverId: server.id,
        healthy,
        latencyMs: latency,
        checkedAt: new Date(),
      };

      if (healthy) {
        this.failureCounts.set(server.id, 0);
        this.registry.updateStatus(server.id, 'healthy');
      } else {
        const failures = (this.failureCounts.get(server.id) || 0) + 1;
        this.failureCounts.set(server.id, failures);

        if (failures >= this.config.failureThreshold) {
          this.registry.updateStatus(server.id, 'unhealthy');
        }
      }

      return result;
    } catch (err) {
      const latency = Date.now() - start;
      const failures = (this.failureCounts.get(server.id) || 0) + 1;
      this.failureCounts.set(server.id, failures);

      if (failures >= this.config.failureThreshold) {
        this.registry.updateStatus(server.id, 'unhealthy');
      }

      return {
        serverId: server.id,
        healthy: false,
        latencyMs: latency,
        error: err instanceof Error ? err.message : String(err),
        checkedAt: new Date(),
      };
    }
  }

  /**
   * Gets the latest health check results.
   */
  getResults(): HealthCheckResult[] {
    return [...this.results];
  }

  /**
   * Gets a health summary string.
   */
  getSummary(): string {
    const results = this.results;
    const healthy = results.filter(r => r.healthy).length;
    const unhealthy = results.filter(r => !r.healthy).length;

    const lines = [
      `Health: ${healthy} healthy, ${unhealthy} unhealthy (of ${results.length} checked)`,
    ];

    for (const r of results) {
      const status = r.healthy ? '✓' : '✗';
      const err = r.error ? ` [${r.error}]` : '';
      lines.push(`  ${status} ${r.serverId}: ${r.latencyMs}ms${err}`);
    }

    return lines.join('\n');
  }

  /**
   * Performs the actual health check for a server.
   * For stdio servers, attempts to initialize transport and list tools.
   * For HTTP servers, performs a tools/list request.
   */
  private async performHealthCheck(server: McpServerEntry): Promise<boolean> {
    try {
      if (server.transport === 'http' && server.connection.url) {
        const transport = createTransport('http', { url: server.connection.url });
        // Use tools/list for health check - all MCP servers support this
        const result = await transport.call('tools/list', {});
        return result !== null;
      }

      if (server.transport === 'stdio' && server.connection.command) {
        // Try to initialize stdio transport and list tools
        const stdioTransport = new StdioTransport({
          command: server.connection.command,
          args: server.connection.args || [],
        });
        
        try {
          await stdioTransport.initialize();
          // Use tools/list for health check - all MCP servers support this
          const result = await stdioTransport.call('tools/list', {});
          stdioTransport.dispose();
          return result !== null;
        } catch {
          stdioTransport.dispose();
          return false;
        }
      }

      // If no checkable transport, assume healthy
      return true;
    } catch {
      return false;
    }
  }

  private async checkHttpServer(url: string): Promise<boolean> {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), this.config.timeoutMs);

      const response = await fetch(url, {
        method: 'HEAD',
        signal: controller.signal,
      });

      clearTimeout(timeout);
      return response.ok || response.status === 405; // 405 = Method Not Allowed (server exists)
    } catch {
      return false;
    }
  }

  private async checkStdioServer(command: string): Promise<boolean> {
    // For stdio servers, check if the command binary exists
    const { execSync } = require('child_process');
    try {
      const checkCmd = process.platform === 'win32' ? `where ${command}` : `which ${command}`;
      execSync(checkCmd, { stdio: 'ignore', timeout: this.config.timeoutMs });
      return true;
    } catch {
      return false;
    }
  }
}

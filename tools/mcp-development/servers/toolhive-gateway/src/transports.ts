/**
 * Transport abstraction layer for ToolHive Gateway
 * Supports stdio and HTTP transports for MCP server communication
 */

import { spawn, ChildProcess } from 'child_process';
import * as http from 'http';

export interface Transport {
  call(toolName: string, args: Record<string, unknown>): Promise<unknown>;
  isHealthy(): Promise<boolean>;
}

export interface StdioConnection {
  command: string;
  args: string[];
}

export interface HttpConnection {
  url: string;
}

/**
 * Stdio transport implementation
 * Spawns a child process and communicates via JSON-RPC over stdin/stdout
 */
export class StdioTransport implements Transport {
  private connection: StdioConnection;
  private process: ChildProcess | null = null;
  private requestId = 0;
  private pendingRequests = new Map<number, { resolve: (value: unknown) => void; reject: (error: Error) => void }>();

  constructor(connection: StdioConnection) {
    this.connection = connection;
  }

  async initialize(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.process = spawn(this.connection.command, this.connection.args, {
        stdio: ['pipe', 'pipe', 'pipe'],
      });

      if (!this.process.stdin || !this.process.stdout) {
        reject(new Error('Failed to create stdio pipes'));
        return;
      }

      // Handle stdout data
      this.process.stdout.on('data', (data: Buffer) => {
        const lines = data.toString().split('\n');
        for (const line of lines) {
          const trimmed = line.trim();
          if (!trimmed) continue;

          try {
            const response = JSON.parse(trimmed);
            if (response.id !== undefined) {
              const pending = this.pendingRequests.get(response.id);
              if (pending) {
                this.pendingRequests.delete(response.id);
                if (response.error) {
                  pending.reject(new Error(response.error.message));
                } else {
                  pending.resolve(response.result);
                }
              }
            }
          } catch {
            // Ignore non-JSON output
          }
        }
      });

      // Handle stderr
      this.process.stderr?.on('data', (data: Buffer) => {
        console.error(`[StdioTransport] ${data.toString().trim()}`);
      });

      // Handle process exit
      this.process.on('exit', (code) => {
        console.error(`[StdioTransport] Process exited with code ${code}`);
        this.process = null;
      });

      // Send initialize request
      const initRequest = {
        jsonrpc: '2.0',
        id: ++this.requestId,
        method: 'initialize',
        params: {
          protocolVersion: '2024-11-05',
          capabilities: {},
          clientInfo: { name: 'toolhive-gateway', version: '1.0.0' },
        },
      };

      this.process.stdin.write(JSON.stringify(initRequest) + '\n');

      // Wait for initialize response
      const timeout = setTimeout(() => {
        reject(new Error('Initialize timeout'));
      }, 10000);

      const checkResponse = (data: Buffer) => {
        const lines = data.toString().split('\n');
        for (const line of lines) {
          const trimmed = line.trim();
          if (!trimmed) continue;

          try {
            const response = JSON.parse(trimmed);
            if (response.id === initRequest.id) {
              clearTimeout(timeout);
              this.process!.stdout!.off('data', checkResponse);
              if (response.error) {
                reject(new Error(response.error.message));
              } else {
                resolve();
              }
              return;
            }
          } catch {
            // Ignore
          }
        }
      };

      this.process.stdout.on('data', checkResponse);
    });
  }

  async call(toolName: string, args: Record<string, unknown>): Promise<unknown> {
    if (!this.process || !this.process.stdin) {
      throw new Error('Transport not initialized');
    }

    const requestId = ++this.requestId;
    const request = {
      jsonrpc: '2.0',
      id: requestId,
      method: 'tools/call',
      params: {
        name: toolName,
        arguments: args,
      },
    };

    return new Promise((resolve, reject) => {
      this.pendingRequests.set(requestId, { resolve, reject });

      // Set timeout
      setTimeout(() => {
        if (this.pendingRequests.has(requestId)) {
          this.pendingRequests.delete(requestId);
          reject(new Error(`Request timeout for tool: ${toolName}`));
        }
      }, 30000);

      this.process!.stdin!.write(JSON.stringify(request) + '\n');
    });
  }

  async isHealthy(): Promise<boolean> {
    // For stdio transports, check if process is still running
    if (this.process) {
      return !this.process.killed;
    }
    return false;
  }

  async checkToolAvailable(toolName: string): Promise<boolean> {
    try {
      // Try to list tools to verify the server is responsive
      const requestId = ++this.requestId;
      const request = {
        jsonrpc: '2.0',
        id: requestId,
        method: 'tools/list',
        params: {},
      };

      return new Promise((resolve) => {
        const timeout = setTimeout(() => {
          resolve(false);
        }, 5000);

        const checkResponse = (data: Buffer) => {
          const lines = data.toString().split('\n');
          for (const line of lines) {
            const trimmed = line.trim();
            if (!trimmed) continue;

            try {
              const response = JSON.parse(trimmed);
              if (response.id === requestId) {
                clearTimeout(timeout);
                this.process!.stdout!.off('data', checkResponse);
                resolve(!response.error);
                return;
              }
            } catch {
              // Ignore
            }
          }
        };

        if (this.process?.stdout) {
          this.process.stdout.on('data', checkResponse);
          this.process.stdin?.write(JSON.stringify(request) + '\n');
        } else {
          resolve(false);
        }
      });
    } catch {
      return false;
    }
  }

  dispose(): void {
    if (this.process && !this.process.killed) {
      this.process.kill();
    }
  }
}

/**
 * HTTP transport implementation
 * Communicates with MCP servers via HTTP POST requests
 */
export class HttpTransport implements Transport {
  private connection: HttpConnection;

  constructor(connection: HttpConnection) {
    this.connection = connection;
  }

  async call(toolName: string, args: Record<string, unknown>): Promise<unknown> {
    const requestId = Math.random().toString(36).substring(7);
    const request = {
      jsonrpc: '2.0',
      id: requestId,
      method: 'tools/call',
      params: {
        name: toolName,
        arguments: args,
      },
    };

    return new Promise((resolve, reject) => {
      const url = new URL(this.connection.url);
      const postData = JSON.stringify(request);

      const options: http.RequestOptions = {
        hostname: url.hostname,
        port: url.port || (url.protocol === 'https:' ? 443 : 80),
        path: url.pathname,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData),
        },
        timeout: 30000,
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
              reject(new Error(response.error.message));
            } else {
              resolve(response.result);
            }
          } catch (err) {
            reject(new Error(`Invalid JSON response: ${err}`));
          }
        });
      });

      req.on('error', (err) => {
        reject(new Error(`HTTP request failed: ${err.message}`));
      });

      req.on('timeout', () => {
        req.destroy();
        reject(new Error('HTTP request timeout'));
      });

      req.write(postData);
      req.end();
    });
  }

  async isHealthy(): Promise<boolean> {
    return new Promise((resolve) => {
      const url = new URL(this.connection.url);
      
      const options: http.RequestOptions = {
        hostname: url.hostname,
        port: url.port || (url.protocol === 'https:' ? 443 : 80),
        path: url.pathname,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        timeout: 5000,
      };

      const request = {
        jsonrpc: '2.0',
        id: 'health-check',
        method: 'tools/list',
        params: {},
      };

      const req = http.request(options, (res) => {
        resolve(res.statusCode === 200);
      });

      req.on('error', () => {
        resolve(false);
      });

      req.on('timeout', () => {
        req.destroy();
        resolve(false);
      });

      req.write(JSON.stringify(request));
      req.end();
    });
  }
}

/**
 * Factory function to create the appropriate transport
 */
export function createTransport(
  type: 'stdio' | 'http',
  connection: StdioConnection | HttpConnection
): Transport {
  switch (type) {
    case 'stdio':
      return new StdioTransport(connection as StdioConnection);
    case 'http':
      return new HttpTransport(connection as HttpConnection);
    default:
      throw new Error(`Unknown transport type: ${type}`);
  }
}

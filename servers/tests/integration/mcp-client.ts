import { randomUUID } from 'node:crypto';

type JsonRpcMessage = {
  jsonrpc: '2.0';
  id?: string | number | null;
  method?: string;
  params?: Record<string, unknown>;
  result?: unknown;
  error?: { code: number; message: string };
};

export class McpTestClient {
  private readonly baseUrl: string;
  private readonly authToken: string;
  private readonly pending = new Map<string | number, JsonRpcMessage>();
  private connectionId: string | null = null;
  private abortController: AbortController | null = null;

  constructor(baseUrl: string, authToken: string) {
    this.baseUrl = baseUrl;
    this.authToken = authToken;
  }

  async connect(): Promise<void> {
    this.abortController = new AbortController();
    const response = await fetch(`${this.baseUrl}/sse`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${this.authToken}`,
        Origin: 'http://localhost:5173',
      },
      signal: this.abortController.signal,
    });

    if (!response.ok || !response.body) {
      throw new Error(`Failed to open SSE connection: HTTP ${response.status}`);
    }

    void this.consumeSse(response.body.getReader()).catch((error: unknown) => {
      if (isAbortError(error)) {
        return;
      }

      throw error;
    });

    const startedAt = Date.now();
    while (!this.connectionId && Date.now() - startedAt < 10000) {
      await wait(50);
    }

    if (!this.connectionId) {
      throw new Error('Timed out waiting for MCP endpoint connection ID');
    }
  }

  async initialize(): Promise<unknown> {
    const result = await this.sendRequest('initialize', {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: { name: 'integration-test-client', version: '1.0.0' },
    });

    await this.sendNotification('notifications/initialized', {});
    return result;
  }

  async listTools(): Promise<unknown> {
    return this.sendRequest('tools/list', {});
  }

  async callTool(name: string, args: unknown): Promise<unknown> {
    return this.sendRequest('tools/call', { name, arguments: args });
  }

  close(): void {
    this.abortController?.abort();
    this.abortController = null;
  }

  private async sendNotification(method: string, params: unknown): Promise<void> {
    if (!this.connectionId) {
      throw new Error('Client is not connected');
    }

    await fetch(`${this.baseUrl}/message?connectionId=${this.connectionId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.authToken}`,
        Origin: 'http://localhost:5173',
      },
      body: JSON.stringify({ jsonrpc: '2.0', method, params }),
    });
  }

  private async sendRequest(method: string, params: unknown): Promise<unknown> {
    if (!this.connectionId) {
      throw new Error('Client is not connected');
    }

    const id = randomUUID();

    const response = await fetch(`${this.baseUrl}/message?connectionId=${this.connectionId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.authToken}`,
        Origin: 'http://localhost:5173',
      },
      body: JSON.stringify({ jsonrpc: '2.0', id, method, params }),
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }

    return this.waitForResponse(id);
  }

  private async waitForResponse(id: string): Promise<unknown> {
    const startedAt = Date.now();

    while (Date.now() - startedAt < 10000) {
      const message = this.pending.get(id);
      if (message) {
        this.pending.delete(id);

        if (message.error) {
          throw new Error(`${message.error.code}: ${message.error.message}`);
        }

        return message.result;
      }

      await wait(50);
    }

    throw new Error(`Timed out waiting for response for request ID ${id}`);
  }

  private async consumeSse(
    reader: ReadableStreamDefaultReader<Uint8Array>,
  ): Promise<void> {
    const decoder = new TextDecoder();
    let buffer = '';

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) {
          break;
        }

        buffer += decoder.decode(value, { stream: true });

        let separatorIndex = buffer.indexOf('\n\n');
        while (separatorIndex !== -1) {
          const eventBlock = buffer.slice(0, separatorIndex);
          buffer = buffer.slice(separatorIndex + 2);
          this.processEventBlock(eventBlock);
          separatorIndex = buffer.indexOf('\n\n');
        }
      }
    } catch (error) {
      if (!isAbortError(error)) {
        throw error;
      }
    }
  }

  private processEventBlock(block: string): void {
    const dataLine = block
      .split('\n')
      .map((line) => line.trim())
      .find((line) => line.startsWith('data:'));

    if (!dataLine) {
      return;
    }

    const payload = dataLine.slice('data:'.length).trim();
    if (!payload) {
      return;
    }

    const message = JSON.parse(payload) as JsonRpcMessage;

    if (message.method === 'endpoint' && message.params?.uri) {
      const uri = String(message.params.uri);
      const url = new URL(uri, this.baseUrl);
      this.connectionId = url.searchParams.get('connectionId');
      return;
    }

    if (message.id !== undefined && message.id !== null) {
      this.pending.set(message.id, message);
    }
  }
}

export function parseToolCallText(result: unknown): unknown {
  const text = ((result as { content?: Array<{ text?: string }> }).content ?? [])[0]?.text;
  if (!text) {
    return result;
  }

  try {
    return JSON.parse(text);
  } catch {
    return text;
  }
}

function wait(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function isAbortError(error: unknown): boolean {
  return (
    typeof error === 'object' &&
    error !== null &&
    'name' in error &&
    (error as { name?: string }).name === 'AbortError'
  );
}

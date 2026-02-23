#!/usr/bin/env node

import { randomUUID } from 'node:crypto';

const AUTH_TOKEN = process.env.MCP_AUTH_TOKEN;
const BASE_URL = 'http://127.0.0.1:3002';
const ORIGIN = 'http://localhost:5173';

if (!AUTH_TOKEN) {
  console.error('MCP_AUTH_TOKEN is required.');
  process.exit(1);
}

async function main() {
  const client = new McpClient(BASE_URL, AUTH_TOKEN, ORIGIN);
  await client.connect();
  await client.initialize();

  const list = await client.callTool('rag_list', {});
  const search = await client.callTool('rag_search', {
    query: 'RAG migration legacy FAISS to v2',
    topK: 5,
  });

  client.close();

  console.log(JSON.stringify({ listCount: list.count, searchCount: search.count }, null, 2));
}

class McpClient {
  constructor(baseUrl, authToken, origin) {
    this.baseUrl = baseUrl;
    this.authToken = authToken;
    this.origin = origin;
    this.connectionId = null;
    this.pending = new Map();
    this.abortController = null;
  }

  async connect() {
    this.abortController = new AbortController();
    const response = await fetch(`${this.baseUrl}/sse`, {
      headers: {
        Authorization: `Bearer ${this.authToken}`,
        Origin: this.origin,
      },
      signal: this.abortController.signal,
    });

    if (!response.ok || !response.body) {
      throw new Error(`Connect failed: HTTP ${response.status}`);
    }

    this.consumeSse(response.body.getReader());

    const deadline = Date.now() + 10000;
    while (!this.connectionId && Date.now() < deadline) {
      await sleep(25);
    }

    if (!this.connectionId) {
      throw new Error('No connectionId from SSE endpoint');
    }
  }

  async initialize() {
    await this.sendRequest('initialize', {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: { name: 'rag-v2-check', version: '1.0.0' },
    });

    await this.sendNotification('notifications/initialized', {});
  }

  async callTool(name, args) {
    const result = await this.sendRequest('tools/call', {
      name,
      arguments: args,
    });

    const text = result?.content?.[0]?.text;
    if (!text) {
      return result;
    }

    try {
      return JSON.parse(text);
    } catch {
      return result;
    }
  }

  close() {
    this.abortController?.abort();
  }

  async sendNotification(method, params) {
    await fetch(`${this.baseUrl}/message?connectionId=${this.connectionId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.authToken}`,
        Origin: this.origin,
      },
      body: JSON.stringify({ jsonrpc: '2.0', method, params }),
    });
  }

  async sendRequest(method, params) {
    const id = randomUUID();
    const response = await fetch(`${this.baseUrl}/message?connectionId=${this.connectionId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.authToken}`,
        Origin: this.origin,
      },
      body: JSON.stringify({ jsonrpc: '2.0', id, method, params }),
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    return this.waitForResponse(id);
  }

  async waitForResponse(id) {
    const deadline = Date.now() + 20000;
    while (Date.now() < deadline) {
      const message = this.pending.get(id);
      if (message) {
        this.pending.delete(id);
        if (message.error) {
          throw new Error(message.error.message);
        }

        return message.result;
      }

      await sleep(25);
    }

    throw new Error('Timed out waiting for MCP response');
  }

  async consumeSse(reader) {
    const decoder = new TextDecoder();
    let buffer = '';

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) {
          return;
        }

        buffer += decoder.decode(value, { stream: true });
        let index = buffer.indexOf('\n\n');
        while (index !== -1) {
          const block = buffer.slice(0, index);
          buffer = buffer.slice(index + 2);
          this.processBlock(block);
          index = buffer.indexOf('\n\n');
        }
      }
    } catch (error) {
      if (!(error && error.name === 'AbortError')) {
        throw error;
      }
    }
  }

  processBlock(block) {
    const line = block
      .split('\n')
      .map((item) => item.trim())
      .find((item) => item.startsWith('data:'));

    if (!line) {
      return;
    }

    const payload = line.slice(5).trim();
    if (!payload) {
      return;
    }

    const message = JSON.parse(payload);
    if (message.method === 'endpoint' && message.params?.uri) {
      const endpointUrl = new URL(message.params.uri, this.baseUrl);
      this.connectionId = endpointUrl.searchParams.get('connectionId');
      return;
    }

    if (message.id !== undefined && message.id !== null) {
      this.pending.set(message.id, message);
    }
  }
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
});

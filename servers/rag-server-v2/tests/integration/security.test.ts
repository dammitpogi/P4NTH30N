import { afterEach, describe, expect, test } from 'vitest';
import type { FastifyInstance } from 'fastify';
import { createServer } from '../../src/server.js';
import {
  handleMcpMessage,
  registerConnection,
  unregisterConnection,
} from '../../src/protocol/mcp.js';

const VALID_TOKEN = 'f'.repeat(64);
let app: FastifyInstance | undefined;

afterEach(async () => {
  if (app) {
    await app.close();
    app = undefined;
  }
});

describe('security integration', () => {
  test('rejects host mismatch', async () => {
    const created = await createServer(
      {
        PORT: '3002',
        BIND_ADDRESS: '127.0.0.1',
        MCP_AUTH_TOKEN: VALID_TOKEN,
        VECTOR_STORE_PATH: './tmp',
        EMBEDDING_MODEL: 'text-embedding-3-small',
      },
      {
        initVectorStore: async () => undefined,
        vectorHealth: async () => true,
      },
    );
    app = created.server;

    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://localhost:5173',
        host: 'evil.com',
        authorization: `Bearer ${VALID_TOKEN}`,
      },
    });

    expect(response.statusCode).toBe(403);
  });

  test('supports initialize and rag_ingest tool call', async () => {
    const connectionId = 'conn-rag-test';
    registerConnection(connectionId);

    const initialize = await handleMcpMessage(connectionId, {
      jsonrpc: '2.0',
      id: 1,
      method: 'initialize',
      params: { capabilities: {} },
    });
    expect(initialize).toBeTruthy();

    await handleMcpMessage(connectionId, {
      jsonrpc: '2.0',
      method: 'notifications/initialized',
    });

    const call = await handleMcpMessage(connectionId, {
      jsonrpc: '2.0',
      id: 2,
      method: 'tools/call',
      params: {
        name: 'rag_ingest',
        arguments: {
          id: 'doc-1',
          content: 'week 3 protocol implementation',
        },
      },
    });
    expect(call).toBeTruthy();

    unregisterConnection(connectionId);
  });
});

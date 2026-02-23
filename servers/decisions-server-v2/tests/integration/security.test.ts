import { afterEach, describe, expect, test } from 'vitest';
import type { FastifyInstance } from 'fastify';
import { createServer } from '../../src/server.js';
import {
  handleMcpMessage,
  registerConnection,
  unregisterConnection,
} from '../../src/protocol/mcp.js';

const VALID_TOKEN = 'b'.repeat(64);
let app: FastifyInstance | undefined;

afterEach(async () => {
  if (app) {
    await app.close();
    app = undefined;
  }
});

describe('security integration', () => {
  test('rejects missing origin', async () => {
    const created = await createServer({
      PORT: '3000',
      BIND_ADDRESS: '127.0.0.1',
      MCP_AUTH_TOKEN: VALID_TOKEN,
    });
    app = created.server;

    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        host: '127.0.0.1:3000',
        authorization: `Bearer ${VALID_TOKEN}`,
      },
    });

    expect(response.statusCode).toBe(403);
  });

  test('requires bearer token for sse endpoint', async () => {
    const created = await createServer({
      PORT: '3000',
      BIND_ADDRESS: '127.0.0.1',
      MCP_AUTH_TOKEN: VALID_TOKEN,
    });
    app = created.server;

    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://localhost:5173',
        host: '127.0.0.1:3000',
      },
    });

    expect(response.statusCode).toBe(401);
  });

  test('supports initialize -> tools/list -> tools/call', async () => {
    const connectionId = 'conn-decisions-test';
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

    const list = await handleMcpMessage(connectionId, {
      jsonrpc: '2.0',
      id: 2,
      method: 'tools/list',
    });
    expect(list).toBeTruthy();

    const call = await handleMcpMessage(connectionId, {
      jsonrpc: '2.0',
      id: 3,
      method: 'tools/call',
      params: {
        name: 'create_decision',
        arguments: {
          decisionId: 'DECISION_TEST',
          title: 'Test',
          category: 'TEST',
          priority: 'Low',
        },
      },
    });
    expect(call).toBeTruthy();

    unregisterConnection(connectionId);
  });
});

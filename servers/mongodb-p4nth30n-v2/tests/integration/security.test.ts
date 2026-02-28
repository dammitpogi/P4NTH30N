import { afterEach, describe, expect, test } from 'vitest';
import type { FastifyInstance } from 'fastify';
import { createServer } from '../../src/server.js';
import {
  handleMcpMessage,
  registerConnection,
  unregisterConnection,
} from '../../src/protocol/mcp.js';

const VALID_TOKEN = 'd'.repeat(64);
let app: FastifyInstance | undefined;

afterEach(async () => {
  if (app) {
    await app.close();
    app = undefined;
  }
});

describe('security integration', () => {
  test('rejects external origin', async () => {
    const created = await createServer(
      {
        PORT: '3001',
        BIND_ADDRESS: '127.0.0.1',
        MCP_AUTH_TOKEN: VALID_TOKEN,
        MONGODB_URI: 'mongodb://localhost:27017/P4NTHE0N',
      },
      {
        connect: async () => undefined,
        health: async () => true,
      },
    );

    app = created.server;

    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://evil.com',
        host: '127.0.0.1:3001',
        authorization: `Bearer ${VALID_TOKEN}`,
      },
    });

    expect(response.statusCode).toBe(403);
  });

  test('requires token', async () => {
    const created = await createServer(
      {
        PORT: '3001',
        BIND_ADDRESS: '127.0.0.1',
        MCP_AUTH_TOKEN: VALID_TOKEN,
        MONGODB_URI: 'mongodb://localhost:27017/P4NTHE0N',
      },
      {
        connect: async () => undefined,
        health: async () => true,
      },
    );

    app = created.server;

    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://localhost:5173',
        host: '127.0.0.1:3001',
      },
    });

    expect(response.statusCode).toBe(401);
  });

  test('supports initialize and mongodb_count tool call', async () => {
    const connectionId = 'conn-mongo-test';
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
        name: 'mongodb_count',
        arguments: {
          collection: 'decisions',
        },
      },
    });
    expect(call).toBeTruthy();

    unregisterConnection(connectionId);
  });
});

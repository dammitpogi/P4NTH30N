import { afterEach, describe, expect, test } from 'vitest';
import type { FastifyInstance } from 'fastify';
import { createServer } from '../../src/server.js';

const TEST_TOKEN = 'c'.repeat(64);
let app: FastifyInstance | undefined;

afterEach(async () => {
  if (app) {
    await app.close();
    app = undefined;
  }
});

describe('mongodb-p4nth30n-v2', () => {
  test('health endpoints respond', async () => {
    const created = await createServer(
      {
        PORT: '3001',
        BIND_ADDRESS: '127.0.0.1',
        MCP_AUTH_TOKEN: TEST_TOKEN,
        MONGODB_URI: 'mongodb://localhost:27017/P4NTHE0N',
      },
      {
        connect: async () => undefined,
        health: async () => true,
      },
    );

    app = created.server;

    const headers = {
      origin: 'http://localhost:5173',
      host: '127.0.0.1:3001',
    };

    const health = await app.inject({ method: 'GET', url: '/health', headers });
    expect(health.statusCode).toBe(200);

    const ready = await app.inject({ method: 'GET', url: '/ready', headers });
    expect(ready.statusCode).toBe(200);
  });
});

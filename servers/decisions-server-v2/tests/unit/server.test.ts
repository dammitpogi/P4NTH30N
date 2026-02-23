import { afterEach, describe, expect, test } from 'vitest';
import type { FastifyInstance } from 'fastify';
import { createServer } from '../../src/server.js';

const TEST_TOKEN = 'a'.repeat(64);
let app: FastifyInstance | undefined;

afterEach(async () => {
  if (app) {
    await app.close();
    app = undefined;
  }
});

describe('decisions-server-v2', () => {
  test('health endpoints respond without auth', async () => {
    const created = await createServer({
      PORT: '3000',
      BIND_ADDRESS: '127.0.0.1',
      MCP_AUTH_TOKEN: TEST_TOKEN,
    });
    app = created.server;

    const headers = {
      origin: 'http://localhost:5173',
      host: '127.0.0.1:3000',
    };

    const health = await app.inject({ method: 'GET', url: '/health', headers });
    expect(health.statusCode).toBe(200);

    const ready = await app.inject({ method: 'GET', url: '/ready', headers });
    expect(ready.statusCode).toBe(200);
  });
});

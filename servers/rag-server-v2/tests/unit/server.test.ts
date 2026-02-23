import { afterEach, describe, expect, test } from 'vitest';
import type { FastifyInstance } from 'fastify';
import { createServer } from '../../src/server.js';

const TEST_TOKEN = 'e'.repeat(64);
let app: FastifyInstance | undefined;

afterEach(async () => {
  if (app) {
    await app.close();
    app = undefined;
  }
});

describe('rag-server-v2', () => {
  test('health endpoints respond', async () => {
    const created = await createServer(
      {
        PORT: '3002',
        BIND_ADDRESS: '127.0.0.1',
        MCP_AUTH_TOKEN: TEST_TOKEN,
        VECTOR_STORE_PATH: './tmp',
        EMBEDDING_MODEL: 'text-embedding-3-small',
      },
      {
        initVectorStore: async () => undefined,
        vectorHealth: async () => true,
      },
    );

    app = created.server;

    const headers = {
      origin: 'http://localhost:5173',
      host: '127.0.0.1:3002',
    };

    const health = await app.inject({ method: 'GET', url: '/health', headers });
    expect(health.statusCode).toBe(200);

    const ready = await app.inject({ method: 'GET', url: '/ready', headers });
    expect(ready.statusCode).toBe(200);
  });
});

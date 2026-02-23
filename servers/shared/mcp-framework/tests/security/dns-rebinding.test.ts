import { afterEach, describe, expect, test } from 'vitest';
import { createTestApp } from '../helpers/create-test-app.js';

let app = await createTestApp();

afterEach(async () => {
  await app.close();
  app = await createTestApp();
});

describe('REQ-096-026 DNS rebinding protection', () => {
  test('ACT-096-017-001: Rejects external origin', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://evil.com',
        host: '127.0.0.1:3000',
      },
    });

    expect(response.statusCode).toBe(403);
  });

  test('ACT-096-017-002: Accepts localhost origin', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://localhost:8080',
        host: '127.0.0.1:3000',
      },
    });

    expect(response.statusCode).toBe(200);
  });

  test('ACT-096-017-003: Rejects missing origin header', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        host: '127.0.0.1:3000',
      },
    });

    expect(response.statusCode).toBe(403);
  });

  test('ACT-096-017-004: Rejects host mismatch', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/sse',
      headers: {
        origin: 'http://localhost:8080',
        host: 'evil.com',
      },
    });

    expect(response.statusCode).toBe(403);
  });
});

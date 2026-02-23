import { describe, expect, test } from 'vitest';
import { corsConfig } from '../../src/security/cors-config.js';

function invokeCors(origin: string | undefined): Promise<boolean> {
  return new Promise((resolve, reject) => {
    if (!corsConfig.origin || typeof corsConfig.origin !== 'function') {
      reject(new Error('CORS origin callback is not configured'));
      return;
    }

    corsConfig.origin(origin, (error, allowed) => {
      if (error) {
        reject(error);
        return;
      }

      resolve(Boolean(allowed));
    });
  });
}

describe('REQ-096-026-D CORS policy', () => {
  test('allows localhost origin', async () => {
    await expect(invokeCors('http://localhost:8080')).resolves.toBe(true);
  });

  test('rejects wildcard and external origin', async () => {
    await expect(invokeCors('*')).resolves.toBe(false);
    await expect(invokeCors('http://evil.com')).resolves.toBe(false);
  });

  test('enforces allowed methods and headers', () => {
    expect(corsConfig.methods).toEqual(['GET', 'POST', 'OPTIONS']);
    expect(corsConfig.allowedHeaders).toEqual([
      'Content-Type',
      'Authorization',
    ]);
  });
});

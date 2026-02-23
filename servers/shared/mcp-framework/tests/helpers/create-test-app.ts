import Fastify, { type FastifyInstance } from 'fastify';
import { securityPlugin } from '../../src/plugins/security.js';

export interface TestAppOptions {
  authToken?: string;
}

export async function createTestApp(
  options?: TestAppOptions,
): Promise<FastifyInstance> {
  const app = Fastify({ logger: false });

  await app.register(securityPlugin, {
    bindAddress: '127.0.0.1',
    enforceOriginHeader: true,
    enforceHostValidation: true,
    authToken: options?.authToken,
  });

  app.get('/sse', async () => ({ ok: true }));

  return app;
}

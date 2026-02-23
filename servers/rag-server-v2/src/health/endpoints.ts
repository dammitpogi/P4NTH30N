import type { FastifyInstance } from 'fastify';

export interface ReadinessOptions {
  vectorStoreReady: () => Promise<boolean>;
}

export async function registerHealthEndpoints(
  server: FastifyInstance,
  options: ReadinessOptions,
): Promise<void> {
  server.get('/health', async () => ({
    status: 'healthy',
    service: 'rag-server-v2',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  }));

  server.get('/ready', async (_request, reply) => {
    const vectorStoreHealthy = await options.vectorStoreReady();
    const checks = {
      server: true,
      vectorStore: vectorStoreHealthy,
    };

    const allReady = Object.values(checks).every(Boolean);
    if (!allReady) {
      await reply.code(503);
    }

    return {
      status: allReady ? 'ready' : 'not_ready',
      service: 'rag-server-v2',
      checks,
      timestamp: new Date().toISOString(),
    };
  });
}

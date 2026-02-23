import type { FastifyInstance } from 'fastify';

export interface ReadinessOptions {
  mongoReady: () => Promise<boolean>;
}

export async function registerHealthEndpoints(
  server: FastifyInstance,
  options: ReadinessOptions,
): Promise<void> {
  server.get('/health', async () => ({
    status: 'healthy',
    service: 'mongodb-p4nth30n-v2',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  }));

  server.get('/ready', async (_request, reply) => {
    const mongoHealthy = await options.mongoReady();
    const checks = {
      server: true,
      mongodb: mongoHealthy,
    };

    const allReady = Object.values(checks).every(Boolean);

    if (!allReady) {
      await reply.code(503);
    }

    return {
      status: allReady ? 'ready' : 'not_ready',
      service: 'mongodb-p4nth30n-v2',
      checks,
      timestamp: new Date().toISOString(),
    };
  });
}

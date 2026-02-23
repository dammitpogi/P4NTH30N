import type { FastifyInstance } from 'fastify';

export async function registerHealthEndpoints(
  server: FastifyInstance,
): Promise<void> {
  server.get('/health', async () => ({
    status: 'healthy',
    service: 'decisions-server-v2',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  }));

  server.get('/ready', async () => ({
    status: 'ready',
    service: 'decisions-server-v2',
    checks: {
      server: true,
    },
    timestamp: new Date().toISOString(),
  }));
}

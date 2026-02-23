import fp from 'fastify-plugin';
import type { FastifyInstance } from 'fastify';

export interface AuthPluginOptions {
  token: string;
  required?: boolean;
}

declare module 'fastify' {
  interface FastifyInstance {
    authToken: string;
  }
}

const HEALTH_PATHS = new Set(['/health', '/ready']);

export const authPlugin = fp(
  async (server: FastifyInstance, options: AuthPluginOptions) => {
    const required = options.required ?? true;

    server.decorate('authToken', options.token);

    server.addHook('onRequest', async (request, reply) => {
      const path = request.url.split('?')[0] ?? request.url;
      if (HEALTH_PATHS.has(path)) {
        return;
      }

      if (!required) {
        return;
      }

      const authHeader = request.headers.authorization;
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        await reply
          .code(401)
          .send({ error: 'Unauthorized - Bearer token required' });
        return;
      }

      const token = authHeader.slice('Bearer '.length);
      if (token !== options.token) {
        await reply.code(403).send({ error: 'Forbidden - Invalid token' });
        return;
      }
    });
  },
  {
    name: 'decisions-auth-plugin',
  },
);

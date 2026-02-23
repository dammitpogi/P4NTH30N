import fastifyCors from '@fastify/cors';
import fp from 'fastify-plugin';
import type { FastifyPluginAsync } from 'fastify';
import { corsConfig } from '../security/cors-config.js';
import { assertSecureBindAddress } from '../security/bind-validation.js';
import { validateRequiredHostHeader } from '../security/host-validation.js';
import { validateRequiredOriginHeader } from '../security/origin-validation.js';

export interface SecurityPluginOptions {
  bindAddress: string;
  enforceOriginHeader?: boolean;
  enforceHostValidation?: boolean;
  authToken?: string;
}

const securityPluginImpl: FastifyPluginAsync<SecurityPluginOptions> = async (
  app,
  options,
) => {
  assertSecureBindAddress(options.bindAddress);

  await app.register(fastifyCors, corsConfig);

  app.addHook('onRequest', async (request, reply) => {
    const enforceOrigin = options.enforceOriginHeader ?? true;
    const enforceHost = options.enforceHostValidation ?? true;

    if (enforceOrigin) {
      const originResult = validateRequiredOriginHeader(request.headers.origin);
      if (!originResult.valid) {
        request.log.warn(
          { origin: request.headers.origin },
          `Security rejection: ${originResult.reason}`,
        );
        await reply.code(403).send({
          error: 'Forbidden',
          message: originResult.reason,
          requirement: 'REQ-096-026-B',
        });
        return;
      }
    }

    if (enforceHost) {
      const hostResult = validateRequiredHostHeader(request.headers.host);
      if (!hostResult.valid) {
        request.log.warn(
          { host: request.headers.host },
          `Security rejection: ${hostResult.reason}`,
        );
        await reply.code(403).send({
          error: 'Forbidden',
          message: hostResult.reason,
          requirement: 'REQ-096-026-C',
        });
        return;
      }
    }

    if (options.authToken) {
      const header = request.headers.authorization;
      if (!header?.startsWith('Bearer ')) {
        await reply.code(401).send({
          error: 'Unauthorized',
          message: 'Bearer token is required',
          requirement: 'REQ-096-026-E',
        });
        return;
      }

      const token = header.slice('Bearer '.length);
      if (token !== options.authToken) {
        await reply.code(401).send({
          error: 'Unauthorized',
          message: 'Invalid bearer token',
          requirement: 'REQ-096-026-E',
        });
        return;
      }
    }
  });
};

export const securityPlugin = fp(securityPluginImpl, {
  name: 'p4nth30n-security-plugin',
});

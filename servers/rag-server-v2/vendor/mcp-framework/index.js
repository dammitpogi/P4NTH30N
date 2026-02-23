import fastifyCors from '@fastify/cors';
import fp from 'fastify-plugin';

const ALLOWED_BIND = new Set(['127.0.0.1', 'localhost', '0.0.0.0']);
const ALLOWED_ORIGIN_REGEX = [
  /^http:\/\/localhost:\d+$/,
  /^http:\/\/127\.0\.0\.1:\d+$/,
];
const ALLOWED_HOST_REGEX = [/^localhost(?::\d+)?$/i, /^127\.0\.0\.1(?::\d+)?$/];

function validateOrigin(origin) {
  return ALLOWED_ORIGIN_REGEX.some((pattern) => pattern.test(origin));
}

function validateHost(host) {
  return ALLOWED_HOST_REGEX.some((pattern) => pattern.test(host));
}

export const corsConfig = {
  origin(origin, callback) {
    if (!origin) {
      callback(null, false);
      return;
    }

    callback(null, validateOrigin(origin));
  },
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};

export const securityPlugin = fp(async (app, options) => {
  if (!ALLOWED_BIND.has(options.bindAddress)) {
    throw new Error(
      `Invalid bind address '${options.bindAddress}'. Only localhost is allowed.`,
    );
  }

  await app.register(fastifyCors, corsConfig);

  app.addHook('onRequest', async (request, reply) => {
    if (options.enforceOriginHeader ?? true) {
      const origin = request.headers.origin;
      if (!origin || origin === 'null' || !validateOrigin(origin)) {
        await reply.code(403).send({
          error: 'Forbidden',
          message: origin ? `Origin '${origin}' is not allowed` : 'Missing Origin header',
        });
        return;
      }
    }

    if (options.enforceHostValidation ?? true) {
      const host = request.headers.host;
      if (!host || !validateHost(host)) {
        await reply.code(403).send({
          error: 'Forbidden',
          message: host ? `Host '${host}' is not allowed` : 'Missing Host header',
        });
        return;
      }
    }
  });
});

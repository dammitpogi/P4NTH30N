import type { FastifyCorsOptions } from '@fastify/cors';
import { validateOrigin } from './origin-validation.js';

export const corsConfig: FastifyCorsOptions = {
  origin(origin, callback) {
    if (!origin) {
      callback(null, false);
      return;
    }

    if (validateOrigin(origin)) {
      callback(null, true);
      return;
    }

    callback(null, false);
  },
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};

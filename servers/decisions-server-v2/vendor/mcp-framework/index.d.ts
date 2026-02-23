import type { FastifyPluginAsync } from 'fastify';

export interface SecurityPluginOptions {
  bindAddress: string;
  enforceOriginHeader?: boolean;
  enforceHostValidation?: boolean;
}

export declare const corsConfig: {
  origin: (
    origin: string | undefined,
    callback: (error: Error | null, allow?: boolean) => void,
  ) => void;
  methods: string[];
  allowedHeaders: string[];
};

export declare const securityPlugin: FastifyPluginAsync<SecurityPluginOptions>;

import Fastify, { type FastifyInstance } from 'fastify';
import { securityPlugin } from '@p4nth30n/mcp-framework';
import { loadConfig, type Config } from './config/index.js';
import { registerHealthEndpoints } from './health/endpoints.js';
import { authPlugin } from './plugins/auth.js';
import { registerSseTransport } from './transport/sse.js';
import {
  checkVectorStoreHealth,
  initializeVectorStore,
} from './vector/store.js';

export interface CreatedServer {
  server: FastifyInstance;
  config: Config;
}

interface ServerDependencies {
  initVectorStore?: (path: string) => Promise<void>;
  vectorHealth?: () => Promise<boolean>;
}

export async function createServer(
  env: NodeJS.ProcessEnv = process.env,
  dependencies: ServerDependencies = {},
): Promise<CreatedServer> {
  const config = loadConfig(env);
  const initVectorStore = dependencies.initVectorStore ?? initializeVectorStore;
  const vectorHealth = dependencies.vectorHealth ?? checkVectorStoreHealth;
  await initVectorStore(config.VECTOR_STORE_PATH);

  const server = Fastify({ logger: true });

  await server.register(securityPlugin, {
    bindAddress: config.BIND_ADDRESS,
    enforceOriginHeader: true,
    enforceHostValidation: true,
  });

  await server.register(authPlugin, {
    token: config.MCP_AUTH_TOKEN,
    required: true,
  });

  await registerHealthEndpoints(server, {
    vectorStoreReady: vectorHealth,
  });

  await registerSseTransport(server);

  return { server, config };
}

export async function startServer(): Promise<FastifyInstance> {
  const { server, config } = await createServer();

  await server.listen({
    host: config.BIND_ADDRESS,
    port: Number.parseInt(config.PORT, 10),
  });

  const shutdown = async () => {
    await server.close();
    process.exit(0);
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);

  return server;
}

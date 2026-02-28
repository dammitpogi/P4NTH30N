import Fastify, { type FastifyInstance } from 'fastify';
import { securityPlugin } from '@p4nth30n/mcp-framework';
import {
  checkMongoDBHealth,
  connectMongoDB,
  disconnectMongoDB,
} from './db/connection.js';
import { loadConfig, type Config } from './config/index.js';
import { registerHealthEndpoints } from './health/endpoints.js';
import { authPlugin } from './plugins/auth.js';
import { registerSseTransport } from './transport/sse.js';

export interface CreatedServer {
  server: FastifyInstance;
  config: Config;
}

interface MongoDependencies {
  connect?: (uri: string, dbName: string) => Promise<unknown>;
  disconnect?: () => Promise<void>;
  health?: () => Promise<boolean>;
}

export async function createServer(
  env: NodeJS.ProcessEnv = process.env,
  dependencies: MongoDependencies = {},
): Promise<CreatedServer> {
  const config = loadConfig(env);
  const connect = dependencies.connect ?? connectMongoDB;
  const health = dependencies.health ?? checkMongoDBHealth;

  await connect(config.MONGODB_URI, 'P4NTHE0N');

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
    mongoReady: health,
  });

  await registerSseTransport(server);

  return { server, config };
}

export async function startServer(): Promise<FastifyInstance> {
  const { server, config } = await createServer();
  const disconnect = disconnectMongoDB;

  await server.listen({
    host: config.BIND_ADDRESS,
    port: Number.parseInt(config.PORT, 10),
  });

  const shutdown = async () => {
    await disconnect();
    await server.close();
    process.exit(0);
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);

  return server;
}

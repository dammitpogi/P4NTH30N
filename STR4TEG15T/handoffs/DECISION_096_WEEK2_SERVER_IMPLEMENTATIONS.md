---
agent: strategist
type: handoff
decision: DECISION_096
phase: Week 2 - v2.1 Server Implementations
created: 2026-02-22
assignee: windfixer
priority: Critical
---

# WINDFIXER HANDOFF: DECISION_096 Week 2 - Server Implementations

## Context

Week 1 security foundation is **complete and proven**:
- REQ-096-026 security infrastructure implemented in `servers/shared/mcp-framework/`
- 15/15 security tests passing (DNS rebinding, origin validation, host validation, CORS)
- Framework packaged at version 2.0.0
- Server scaffolds created with pinned framework dependency

**Week 2 Objective**: Wire the shared framework into actual server implementations.

## Your Mission

Implement `src/server.ts` and supporting files for all three v2 servers:
1. `servers/decisions-server-v2/`
2. `servers/mongodb-p4nth30n-v2/`
3. `servers/rag-server-v2/`

Each server must integrate the security framework and enforce authToken validation.

---

## Implementation Specification

### Required File Structure Per Server

```
servers/{server-name}-v2/
├── src/
│   ├── index.ts                    # Entry point (import and start server)
│   ├── server.ts                   # Fastify server setup with security plugin
│   ├── config/
│   │   └── index.ts               # Configuration loader + authToken validation
│   ├── transport/
│   │   └── sse.ts                 # SSE endpoint handler (/sse)
│   ├── protocol/
│   │   └── mcp.ts                 # MCP protocol message handler
│   ├── health/
│   │   └── endpoints.ts           # /health and /ready endpoints
│   └── plugins/
│       └── auth.ts                # Bearer token auth middleware
├── package.json                    # Already exists (pinned to framework 2.0.0)
├── tsconfig.json                  # TypeScript configuration
└── tests/
    ├── unit/
    │   └── server.test.ts         # Basic server startup tests
    └── integration/
        └── security.test.ts       # Security middleware integration tests
```

### Critical Requirements

#### 1. Security Plugin Integration (REQ-096-026)

Each server's `src/server.ts` MUST:

```typescript
import Fastify from 'fastify';
import { securityPlugin } from '@p4nth30n/mcp-framework';

const server = Fastify({
  logger: true,
});

// Register security plugin FIRST (before routes)
await server.register(securityPlugin, {
  bindAddress: '127.0.0.1',           // REQ-096-026-A
  enforceOrigin: true,                // REQ-096-026-B
  allowedOrigins: ['http://localhost:*', 'http://127.0.0.1:*'],
  enforceHostValidation: true,        // REQ-096-026-C
  corsConfig: {
    origin: (origin, cb) => {         // REQ-096-026-D
      const allowed = /^http:\/\/(localhost|127\.0\.0\.1):\d+$/;
      if (allowed.test(origin)) cb(null, true);
      else cb(new Error('Not allowed'), false);
    },
    methods: ['GET', 'POST', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  },
});
```

#### 2. Bearer Token Auth (REQ-096-026-E - v2.1 Required)

Create `src/plugins/auth.ts`:

```typescript
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import fp from 'fastify-plugin';

export interface AuthPluginOptions {
  required?: boolean;
}

export default fp(async (server: FastifyInstance, opts: AuthPluginOptions) => {
  const required = opts.required ?? true;
  
  // Get token from environment
  const authToken = process.env.MCP_AUTH_TOKEN;
  
  if (required && !authToken) {
    server.log.error('MCP_AUTH_TOKEN not set in environment');
    process.exit(1);
  }
  
  server.addHook('onRequest', async (request: FastifyRequest, reply: FastifyReply) => {
    // Skip auth for health endpoints
    if (request.url === '/health' || request.url === '/ready') {
      return;
    }
    
    if (!required) return;
    
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      reply.code(401).send({ error: 'Unauthorized - Bearer token required' });
      return;
    }
    
    const token = authHeader.slice(7);
    if (token !== authToken) {
      reply.code(403).send({ error: 'Forbidden - Invalid token' });
      return;
    }
  });
  
  server.decorate('authToken', authToken);
});
```

#### 3. Configuration Loader

Create `src/config/index.ts`:

```typescript
import { z } from 'zod';

const configSchema = z.object({
  PORT: z.string().default('3000'),
  BIND_ADDRESS: z.string().default('127.0.0.1'),
  MCP_AUTH_TOKEN: z.string().min(32, 'Auth token must be at least 32 characters'),
  // Server-specific configs
  MONGODB_URI: z.string().optional(), // For mongodb-p4nth30n-v2
  VECTOR_STORE_PATH: z.string().optional(), // For rag-server-v2
});

export type Config = z.infer<typeof configSchema>;

export function loadConfig(): Config {
  const result = configSchema.safeParse(process.env);
  
  if (!result.success) {
    console.error('Configuration validation failed:');
    result.error.issues.forEach(issue => {
      console.error(`  ${issue.path.join('.')}: ${issue.message}`);
    });
    process.exit(1);
  }
  
  return result.data;
}
```

#### 4. Health Endpoints

Create `src/health/endpoints.ts`:

```typescript
import { FastifyInstance } from 'fastify';

export async function registerHealthEndpoints(server: FastifyInstance) {
  // /health - Server is operational
  server.get('/health', async () => {
    return { 
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    };
  });
  
  // /ready - Dependencies are connected
  server.get('/ready', async () => {
    // Server-specific readiness checks
    const checks: Record<string, boolean> = {
      server: true,
    };
    
    // Add MongoDB check for mongodb-p4nth30n-v2
    // Add vector store check for rag-server-v2
    
    const allReady = Object.values(checks).every(Boolean);
    
    return {
      status: allReady ? 'ready' : 'not_ready',
      checks,
      timestamp: new Date().toISOString(),
    };
  });
}
```

#### 5. SSE Transport Handler

Create `src/transport/sse.ts`:

```typescript
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';

interface SseConnection {
  id: string;
  reply: FastifyReply;
}

const connections = new Map<string, SseConnection>();

export async function registerSseTransport(server: FastifyInstance) {
  server.get('/sse', async (request: FastifyRequest, reply: FastifyReply) => {
    const connectionId = crypto.randomUUID();
    
    reply.raw.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
    });
    
    connections.set(connectionId, { id: connectionId, reply });
    
    request.raw.on('close', () => {
      connections.delete(connectionId);
    });
    
    // Send initial endpoint message
    sendSseMessage(connectionId, {
      jsonrpc: '2.0',
      id: null,
      method: 'endpoint',
      params: { uri: `/message?connectionId=${connectionId}` },
    });
  });
  
  server.post('/message', async (request: FastifyRequest, reply: FastifyReply) => {
    const { connectionId } = request.query as { connectionId: string };
    const message = request.body;
    
    // Handle MCP message
    const response = await handleMcpMessage(message);
    
    if (response) {
      sendSseMessage(connectionId, response);
    }
    
    reply.code(202).send({ accepted: true });
  });
}

function sendSseMessage(connectionId: string, message: unknown) {
  const conn = connections.get(connectionId);
  if (conn) {
    conn.reply.raw.write(`data: ${JSON.stringify(message)}\n\n`);
  }
}

async function handleMcpMessage(message: unknown): Promise<unknown | null> {
  // Implement MCP protocol handling
  // This will be server-specific
  return null;
}
```

#### 6. Main Server File

Create `src/server.ts`:

```typescript
import Fastify from 'fastify';
import { securityPlugin } from '@p4nth30n/mcp-framework';
import authPlugin from './plugins/auth.js';
import { loadConfig } from './config/index.js';
import { registerHealthEndpoints } from './health/endpoints.js';
import { registerSseTransport } from './transport/sse.js';

export async function createServer() {
  const config = loadConfig();
  
  const server = Fastify({
    logger: {
      level: 'info',
      transport: {
        target: 'pino-pretty',
        options: {
          colorize: true,
        },
      },
    },
  });
  
  // 1. Security plugin (FIRST)
  await server.register(securityPlugin, {
    bindAddress: config.BIND_ADDRESS,
    enforceOrigin: true,
    allowedOrigins: ['http://localhost:*', 'http://127.0.0.1:*'],
    enforceHostValidation: true,
  });
  
  // 2. Auth plugin (SECOND)
  await server.register(authPlugin, { required: true });
  
  // 3. Health endpoints
  await registerHealthEndpoints(server);
  
  // 4. SSE transport
  await registerSseTransport(server);
  
  // 5. Server-specific routes (in protocol/mcp.ts)
  // await registerMcpProtocol(server);
  
  return { server, config };
}

export async function startServer() {
  const { server, config } = await createServer();
  
  try {
    await server.listen({ 
      port: parseInt(config.PORT), 
      host: config.BIND_ADDRESS 
    });
    server.log.info(`Server listening on ${config.BIND_ADDRESS}:${config.PORT}`);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
  
  // Graceful shutdown
  const shutdown = async (signal: string) => {
    server.log.info(`Received ${signal}, starting graceful shutdown...`);
    await server.close();
    process.exit(0);
  };
  
  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
  
  return server;
}
```

#### 7. Entry Point

Create `src/index.ts`:

```typescript
import { startServer } from './server.js';

startServer();
```

### Dependencies to Add

Each server's `package.json` needs:

```json
{
  "dependencies": {
    "@p4nth30n/mcp-framework": "2.0.0",
    "fastify": "5.2.1",
    "fastify-plugin": "5.0.1",
    "zod": "3.24.2",
    "pino-pretty": "13.0.0"
  },
  "devDependencies": {
    "@types/node": "22.13.5",
    "typescript": "5.7.3",
    "vitest": "3.0.7"
  }
}
```

### TypeScript Configuration

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

---

## Environment Variables

Each server requires these environment variables:

```bash
# Required for all servers
PORT=3000
BIND_ADDRESS=127.0.0.1
MCP_AUTH_TOKEN=<generate-256-bit-random-token>

# For mongodb-p4nth30n-v2
MONGODB_URI=mongodb://192.168.56.1:27017/P4NTH30N

# For rag-server-v2
VECTOR_STORE_PATH=/data/vector-store
EMBEDDING_MODEL=text-embedding-3-small
```

Generate auth token:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## Verification Checklist

For each server, verify:

- [ ] `npm install` completes without errors
- [ ] `npm run typecheck` passes
- [ ] `npm run build` compiles successfully
- [ ] `npm test` passes (at minimum: server starts, health endpoints respond)
- [ ] Server binds to 127.0.0.1 only (verify with `netstat -an | grep :3000`)
- [ ] Security headers enforced:
  - [ ] Request without Origin header → 403
  - [ ] Request with external origin → 403
  - [ ] Request with localhost origin + valid token → 200
- [ ] Auth token enforced:
  - [ ] Request without Authorization header → 401
  - [ ] Request with invalid token → 403
  - [ ] Request with valid Bearer token → 200
- [ ] Health endpoints respond:
  - [ ] GET /health → 200 { status: "healthy" }
  - [ ] GET /ready → 200 { status: "ready" }
- [ ] Graceful shutdown on SIGTERM

---

## Implementation Order

1. **decisions-server-v2** (simplest - no external deps)
   - Implement base structure
   - Validate security framework integration
   - Test auth token enforcement

2. **mongodb-p4nth30n-v2** (adds MongoDB)
   - Add MongoDB connection
   - Implement /ready check for MongoDB
   - Add MongoDB-specific MCP handlers

3. **rag-server-v2** (adds vector store)
   - Add vector store initialization
   - Implement /ready check for vector store
   - Add RAG-specific MCP handlers

---

## Reference Files

- Framework exports: `servers/shared/mcp-framework/src/index.ts`
- Framework tests: `servers/shared/mcp-framework/tests/security/`
- Week 1 journal: `OP3NF1XER/deployments/JOURNAL_2026-02-22_DECISION_096_WEEK1_SECURITY_FOUNDATION.md`

---

## Success Criteria

- All three servers have working `src/server.ts` implementations
- Each server enforces authToken validation from environment
- Security middleware integrated and tested
- Health endpoints functional
- TypeScript compilation successful
- Tests passing

---

**Strategist Approval**: Ready for WindFixer execution  
**Priority**: Critical path - Week 2  
**ETA**: 2-3 days

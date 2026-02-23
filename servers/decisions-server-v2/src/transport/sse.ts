import { randomUUID } from 'node:crypto';
import type { FastifyInstance, FastifyReply } from 'fastify';
import {
  handleMcpMessage,
  registerConnection,
  unregisterConnection,
} from '../protocol/mcp.js';

interface SseConnection {
  id: string;
  reply: FastifyReply;
}

const connections = new Map<string, SseConnection>();

export async function registerSseTransport(
  server: FastifyInstance,
): Promise<void> {
  server.get('/sse', async (request, reply) => {
    const connectionId = randomUUID();

    reply.raw.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      Connection: 'keep-alive',
    });

    connections.set(connectionId, { id: connectionId, reply });
    registerConnection(connectionId);

    request.raw.on('close', () => {
      connections.delete(connectionId);
      unregisterConnection(connectionId);
    });

    sendSseMessage(connectionId, {
      jsonrpc: '2.0',
      id: null,
      method: 'endpoint',
      params: {
        uri: `/message?connectionId=${connectionId}`,
      },
    });

    return reply;
  });

  server.post('/message', async (request, reply) => {
    const query = request.query as { connectionId?: string };
    const connectionId = query.connectionId;

    if (!connectionId || !connections.has(connectionId)) {
      await reply.code(404).send({ error: 'Connection not found' });
      return;
    }

    const response = await handleMcpMessage(connectionId, request.body);
    if (response) {
      sendSseMessage(connectionId, response);
    }

    await reply.code(202).send({ accepted: true });
  });
}

function sendSseMessage(connectionId: string, message: unknown): void {
  const conn = connections.get(connectionId);
  if (!conn) {
    return;
  }

  conn.reply.raw.write(`data: ${JSON.stringify(message)}\n\n`);
}

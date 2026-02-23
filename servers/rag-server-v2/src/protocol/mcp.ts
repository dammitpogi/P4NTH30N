import { executeRagTool, ragTools } from '../tools/index.js';

const PROTOCOL_VERSION = '2024-11-05';

interface McpConnection {
  id: string;
  initialized: boolean;
  clientCapabilities?: unknown;
}

interface McpMessage {
  jsonrpc: '2.0';
  id?: string | number | null;
  method?: string;
  params?: unknown;
}

const connections = new Map<string, McpConnection>();

export function registerConnection(connectionId: string): void {
  connections.set(connectionId, {
    id: connectionId,
    initialized: false,
  });
}

export function unregisterConnection(connectionId: string): void {
  connections.delete(connectionId);
}

export async function handleMcpMessage(
  connectionId: string,
  message: unknown,
): Promise<unknown | null> {
  const request = message as McpMessage;
  const connection = connections.get(connectionId);

  if (!connection) {
    return {
      jsonrpc: '2.0',
      id: request?.id ?? null,
      error: { code: -32600, message: 'Invalid connection' },
    };
  }

  if (
    !request ||
    request.jsonrpc !== '2.0' ||
    (typeof request.method !== 'string' && request.id !== undefined)
  ) {
    return {
      jsonrpc: '2.0',
      id: request?.id ?? null,
      error: { code: -32600, message: 'Invalid Request' },
    };
  }

  if (!request.method) {
    return null;
  }

  if (request.id === undefined) {
    if (request.method === 'notifications/initialized') {
      connection.initialized = true;
    }
    return null;
  }

  switch (request.method) {
    case 'initialize':
      connection.clientCapabilities = (request.params as { capabilities?: unknown })
        ?.capabilities;
      return {
        jsonrpc: '2.0',
        id: request.id,
        result: {
          protocolVersion: PROTOCOL_VERSION,
          capabilities: {
            tools: { listChanged: true },
            logging: {},
          },
          serverInfo: {
            name: 'rag-server-v2',
            version: '2.0.0',
          },
        },
      };

    case 'tools/list':
      if (!connection.initialized) {
        return {
          jsonrpc: '2.0',
          id: request.id,
          error: { code: -32002, message: 'Server not initialized' },
        };
      }

      return {
        jsonrpc: '2.0',
        id: request.id,
        result: { tools: ragTools },
      };

    case 'tools/call': {
      if (!connection.initialized) {
        return {
          jsonrpc: '2.0',
          id: request.id,
          error: { code: -32002, message: 'Server not initialized' },
        };
      }

      const params = request.params as { name?: string; arguments?: unknown };
      if (!params?.name) {
        return {
          jsonrpc: '2.0',
          id: request.id,
          error: { code: -32602, message: 'Missing tool name' },
        };
      }

      try {
        const result = await executeRagTool(params.name, params.arguments ?? {});
        return {
          jsonrpc: '2.0',
          id: request.id,
          result: {
            content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
          },
        };
      } catch (error) {
        return {
          jsonrpc: '2.0',
          id: request.id,
          result: {
            content: [{ type: 'text', text: String(error) }],
            isError: true,
          },
        };
      }
    }

    default:
      return {
        jsonrpc: '2.0',
        id: request.id,
        error: { code: -32601, message: `Method not found: ${request.method}` },
      };
  }
}

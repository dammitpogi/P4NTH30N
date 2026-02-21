/**
 * MIGRATE-004: Honeybelt MCP Server
 * Provides operations and reporting tools for P4NTH30N agents.
 *
 * Protocol: MCP 2024-11-05 via stdio or Streamable HTTP
 * Usage: node dist/index.js [--http] [--port=PORT]
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { HoneybeltOperations } from './tools/operations';
import { HoneybeltReporting } from './tools/reporting';
import http from 'node:http';

const operations = new HoneybeltOperations();
const reporting = new HoneybeltReporting();

function createServer(): Server {
  const server = new Server(
    { name: 'honeybelt-server', version: '1.1.0' },
    { capabilities: { tools: {} } }
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: [
      {
        name: 'honeybelt_status',
        description: 'Check honeybelt service status and system health',
        inputSchema: { type: 'object', properties: {} },
      },
      {
        name: 'honeybelt_operations',
        description: 'Execute honeybelt operations (deploy, restart, configure)',
        inputSchema: {
          type: 'object',
          properties: {
            operation: { type: 'string', enum: ['deploy', 'restart', 'configure', 'list'], description: 'Operation to execute' },
            target: { type: 'string', description: 'Target service or component' },
            params: { type: 'object', description: 'Operation parameters' },
          },
          required: ['operation'],
        },
      },
      {
        name: 'honeybelt_report',
        description: 'Generate operational reports (health, performance, cost)',
        inputSchema: {
          type: 'object',
          properties: {
            reportType: { type: 'string', enum: ['health', 'performance', 'cost', 'summary'], description: 'Type of report' },
            period: { type: 'string', enum: ['hour', 'day', 'week', 'month'], description: 'Reporting period' },
          },
          required: ['reportType'],
        },
      },
    ],
  }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;
    try {
      switch (name) {
        case 'honeybelt_status':
          return { content: [{ type: 'text', text: JSON.stringify(operations.getStatus(), null, 2) }] };
        case 'honeybelt_operations':
          return { content: [{ type: 'text', text: JSON.stringify(operations.execute(args?.operation as string, args?.target as string, args?.params as any), null, 2) }] };
        case 'honeybelt_report':
          return { content: [{ type: 'text', text: JSON.stringify(reporting.generate(args?.reportType as string, args?.period as string), null, 2) }] };
        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      return { content: [{ type: 'text', text: `Error: ${message}` }], isError: true };
    }
  });

  return server;
}

async function main() {
  const useHttp = process.argv.includes('--http') || process.env.MCP_TRANSPORT === 'http';
  const portArg = process.argv.find((arg) => arg.startsWith('--port='));
  const httpPort = portArg 
    ? parseInt(portArg.split('=')[1], 10)
    : parseInt(process.env.MCP_PORT || '3000', 10);

  if (useHttp) {
    // Streamable HTTP transport - stateless: new server+transport per request
    const httpServer = http.createServer(async (req, res) => {
      const pathname = new URL(req.url || '', `http://localhost:${httpPort}`).pathname;
      
      // Handle GET /sse for SSE streaming
      if (pathname === '/sse' && req.method === 'GET') {
        try {
          const transport = new SSEServerTransport('/message', res);
          const server = createServer();
          await server.connect(transport);
          // SSE transport handles the response
        } catch (error) {
          console.error('Error handling SSE:', error);
          if (!res.headersSent) {
            res.statusCode = 500;
            res.end(JSON.stringify({ error: 'Internal server error' }));
          }
        }
      }
      // Handle POST /mcp for regular JSON requests
      else if ((pathname === '/mcp' || pathname === '/') && req.method === 'POST') {
        try {
          const transport = new StreamableHTTPServerTransport({ sessionIdGenerator: undefined });
          const server = createServer();
          await server.connect(transport);
          await transport.handleRequest(req, res);
        } catch (error) {
          console.error('Error handling request:', error);
          if (!res.headersSent) {
            res.statusCode = 500;
            res.end(JSON.stringify({ error: 'Internal server error' }));
          }
        }
      } else {
        res.statusCode = 405;
        res.setHeader('Allow', 'GET /sse, POST /mcp');
        res.end(JSON.stringify({ error: 'Method not allowed' }));
      }
    });

    httpServer.listen(httpPort, () => {
      console.error(`[Honeybelt MCP Server] Streamable HTTP on port ${httpPort}`);
    });
  } else {
    // stdio transport
    const server = createServer();
    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error('[Honeybelt MCP Server] stdio mode ready');
  }
}

main().catch(console.error);

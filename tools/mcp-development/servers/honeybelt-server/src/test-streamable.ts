// Debug script to test Streamable HTTP
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import http from 'node:http';
import url from 'node:url';

const server = new Server(
  {
    name: 'test-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'test_tool',
        description: 'A test tool',
        inputSchema: { type: 'object', properties: {} },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  return {
    content: [{ type: 'text', text: 'Test result' }],
  };
});

async function main() {
  const port = 9999;
  
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
  });
  
  console.log('Connecting server to transport...');
  await server.connect(transport);
  console.log('Server connected');
  
  const httpServer = http.createServer(async (req, res) => {
    console.log(`Received ${req.method} ${req.url}`);
    const parsedUrl = url.parse(req.url || '', true);
    
    if (parsedUrl.pathname === '/mcp') {
      try {
        // Collect body
        const chunks = [];
        for await (const chunk of req) {
          chunks.push(chunk);
        }
        const bodyStr = Buffer.concat(chunks).toString('utf-8');
        console.log('Body:', bodyStr);
        const body = bodyStr ? JSON.parse(bodyStr) : undefined;
        
        console.log('Calling handleRequest...');
        await transport.handleRequest(req, res, body);
        console.log('handleRequest completed');
      } catch (error) {
        console.error('Error:', error);
        res.statusCode = 500;
        res.end(JSON.stringify({ error: String(error) }));
      }
    } else {
      console.log('404 for path:', parsedUrl.pathname);
      res.statusCode = 404;
      res.end(JSON.stringify({ error: 'Not found' }));
    }
  });

  httpServer.listen(port, () => {
    console.error(`Test server on port ${port}`);
  });
}

main().catch(console.error);

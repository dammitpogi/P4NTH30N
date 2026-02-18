#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import axios from 'axios';
import http from 'http';
import { URL } from 'url';

const KIMI_API_KEY = process.env.KIMI_API_KEY || '';
const KIMI_BASE_URL = process.env.KIMI_BASE_URL || 'https://api.kimi.com/coding';
const PORT = parseInt(process.env.PORT || '3000', 10);

if (!KIMI_API_KEY) {
  console.error('Error: KIMI_API_KEY environment variable is required');
  process.exit(1);
}

const server = new Server(
  {
    name: 'kimi-code-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'kimi_chat',
        description: 'Send a chat message to Kimi Code model',
        inputSchema: {
          type: 'object',
          properties: {
            messages: {
              type: 'array',
              description: 'Array of chat messages',
              items: {
                type: 'object',
                properties: {
                  role: {
                    type: 'string',
                    enum: ['system', 'user', 'assistant'],
                  },
                  content: {
                    type: 'string',
                  },
                },
                required: ['role', 'content'],
              },
            },
            model: {
              type: 'string',
              description: 'Kimi model to use (default: kimi-k2)',
              default: 'kimi-k2',
            },
          },
          required: ['messages'],
        },
      },
      {
        name: 'kimi_code_complete',
        description: 'Get code completion from Kimi Code',
        inputSchema: {
          type: 'object',
          properties: {
            prompt: {
              type: 'string',
              description: 'The code completion prompt',
            },
            context: {
              type: 'string',
              description: 'Additional context about the code',
            },
            language: {
              type: 'string',
              description: 'Programming language',
            },
          },
          required: ['prompt'],
        },
      },
      {
        name: 'kimi_explain_code',
        description: 'Get explanation of code from Kimi',
        inputSchema: {
          type: 'object',
          properties: {
            code: {
              type: 'string',
              description: 'The code to explain',
            },
            language: {
              type: 'string',
              description: 'Programming language',
            },
          },
          required: ['code'],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request: { params: { name: string; arguments?: Record<string, unknown> } }) => {
  const { name, arguments: args = {} } = request.params;

  try {
    switch (name) {
      case 'kimi_chat': {
        const response = await axios.post(
          `${KIMI_BASE_URL}/v1/chat/completions`,
          {
            model: args.model || 'kimi-k2',
            messages: args.messages,
            stream: false,
          },
          {
            headers: {
              'Authorization': `Bearer ${KIMI_API_KEY}`,
              'Content-Type': 'application/json',
            },
          }
        );

        return {
          content: [
            {
              type: 'text',
              text: response.data.choices[0].message.content,
            },
          ],
        };
      }

      case 'kimi_code_complete': {
        const prompt = args.context 
          ? `${args.context}\n\nComplete this code:\n${args.prompt}`
          : args.prompt;

        const response = await axios.post(
          `${KIMI_BASE_URL}/v1/chat/completions`,
          {
            model: 'kimi-k2',
            messages: [
              {
                role: 'system',
                content: `You are a code completion assistant. Provide only the code completion without explanation. Language: ${args.language || 'unspecified'}`,
              },
              {
                role: 'user',
                content: prompt,
              },
            ],
            stream: false,
          },
          {
            headers: {
              'Authorization': `Bearer ${KIMI_API_KEY}`,
              'Content-Type': 'application/json',
            },
          }
        );

        return {
          content: [
            {
              type: 'text',
              text: response.data.choices[0].message.content,
            },
          ],
        };
      }

      case 'kimi_explain_code': {
        const response = await axios.post(
          `${KIMI_BASE_URL}/v1/chat/completions`,
          {
            model: 'kimi-k2',
            messages: [
              {
                role: 'system',
                content: 'You are a helpful assistant that explains code clearly and concisely.',
              },
              {
                role: 'user',
                content: `Explain this ${args.language || ''} code:\n\n\`\`\`\n${args.code}\n\`\`\``, 
              },
            ],
            stream: false,
          },
          {
            headers: {
              'Authorization': `Bearer ${KIMI_API_KEY}`,
              'Content-Type': 'application/json',
            },
          }
        );

        return {
          content: [
            {
              type: 'text',
              text: response.data.choices[0].message.content,
            },
          ],
        }
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error: any) {
    console.error('Error calling Kimi API:', error);
    return {
      content: [
        {
          type: 'text',
          text: `Error: ${error.message || String(error)}`,
        },
      ],
      isError: true,
    };
  }
});

// Start HTTP server
async function main() {
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
  });
  
  await server.connect(transport);
  
  const httpServer = http.createServer(async (req, res) => {
    const url = new URL(req.url || '/', `http://${req.headers.host}`);
    
    if (url.pathname === '/mcp' || url.pathname === '/') {
      await transport.handleRequest(req, res);
    } else {
      res.writeHead(404, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Not found' }));
    }
  });
  
  httpServer.listen(PORT, () => {
    console.error(`Kimi MCP Server running on HTTP port ${PORT}`);
  });
  
  // Graceful shutdown
  process.on('SIGINT', () => {
    console.error('Shutting down...');
    httpServer.close(() => {
      process.exit(0);
    });
  });
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});

import { afterAll, beforeAll, describe, expect, test } from 'vitest';
import { McpTestClient, parseToolCallText } from './mcp-client.js';

const TOKEN = process.env.MCP_AUTH_TOKEN;

if (!TOKEN) {
  throw new Error('MCP_AUTH_TOKEN is required for integration tests');
}

describe('decisions-server-v2 integration', () => {
  const client = new McpTestClient('http://localhost:3000', TOKEN);

  beforeAll(async () => {
    await client.connect();
    await client.initialize();
  });

  afterAll(() => {
    client.close();
  });

  test('tools/list returns 4 tools', async () => {
    const result = (await client.listTools()) as { tools?: unknown[] };
    expect(Array.isArray(result.tools)).toBe(true);
    expect(result.tools?.length).toBe(4);
  }, 15000);

  test('create and find decision flow works', async () => {
    const decisionId = `DECISION_INT_${Date.now()}`;

    const createResult = await client.callTool('create_decision', {
      decisionId,
      title: 'Integration Test Decision',
      category: 'TEST',
      priority: 'Low',
      content: 'week 4 integration validation',
    });

    const parsedCreate = parseToolCallText(createResult) as {
      created?: boolean;
    };
    expect(parsedCreate.created).toBe(true);

    const findResult = await client.callTool('find_decision_by_id', { decisionId });
    const parsedFind = parseToolCallText(findResult) as {
      found?: boolean;
      decision?: { decisionId?: string };
    };

    expect(parsedFind.found).toBe(true);
    expect(parsedFind.decision?.decisionId).toBe(decisionId);
  }, 15000);
});

import { afterAll, beforeAll, describe, expect, test } from 'vitest';
import { McpTestClient, parseToolCallText } from './mcp-client.js';

const TOKEN = process.env.MCP_AUTH_TOKEN;

if (!TOKEN) {
  throw new Error('MCP_AUTH_TOKEN is required for integration tests');
}

describe('mongodb-p4nth30n-v2 integration', () => {
  const client = new McpTestClient('http://localhost:3001', TOKEN);

  beforeAll(async () => {
    await client.connect();
    await client.initialize();
  });

  afterAll(() => {
    client.close();
  });

  test('tools/list returns 7 tools', async () => {
    const result = (await client.listTools()) as { tools?: unknown[] };
    expect(Array.isArray(result.tools)).toBe(true);
    expect(result.tools?.length).toBe(7);
  }, 15000);

  test('insert/find/count flow works', async () => {
    const marker = `integration-${Date.now()}`;

    const insert = await client.callTool('mongodb_insert_one', {
      collection: 'integration_tests',
      document: { marker, type: 'week4' },
    });
    const parsedInsert = parseToolCallText(insert) as { acknowledged?: boolean };
    expect(parsedInsert.acknowledged).toBe(true);

    const findOne = await client.callTool('mongodb_find_one', {
      collection: 'integration_tests',
      filter: { marker },
    });
    const parsedFindOne = parseToolCallText(findOne) as {
      found?: boolean;
      document?: { marker?: string };
    };
    expect(parsedFindOne.found).toBe(true);
    expect(parsedFindOne.document?.marker).toBe(marker);

    const count = await client.callTool('mongodb_count', {
      collection: 'integration_tests',
      filter: { marker },
    });
    const parsedCount = parseToolCallText(count) as { count?: number };
    expect((parsedCount.count ?? 0) > 0).toBe(true);
  }, 20000);
});

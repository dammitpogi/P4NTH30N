import { afterAll, beforeAll, describe, expect, test } from 'vitest';
import { McpTestClient, parseToolCallText } from './mcp-client.js';

const TOKEN = process.env.MCP_AUTH_TOKEN;

if (!TOKEN) {
  throw new Error('MCP_AUTH_TOKEN is required for integration tests');
}

describe('rag-server-v2 integration', () => {
  const client = new McpTestClient('http://localhost:3002', TOKEN);

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

  test('ingest/search/list flow works', async () => {
    const docId = `doc-${Date.now()}`;

    const ingest = await client.callTool('rag_ingest', {
      id: docId,
      content: 'week 4 integration testing for MCP and ToolHive deployment',
      metadata: { suite: 'integration' },
    });
    const parsedIngest = parseToolCallText(ingest) as { ingested?: boolean };
    expect(parsedIngest.ingested).toBe(true);

    const search = await client.callTool('rag_search', {
      query: 'ToolHive MCP deployment',
      topK: 3,
    });
    const parsedSearch = parseToolCallText(search) as { count?: number };
    expect((parsedSearch.count ?? 0) > 0).toBe(true);

    const list = await client.callTool('rag_list', {});
    const parsedList = parseToolCallText(list) as { documents?: string[] };
    expect(parsedList.documents?.includes(docId)).toBe(true);
  }, 20000);
});

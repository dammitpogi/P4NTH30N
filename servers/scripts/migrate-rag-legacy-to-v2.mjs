#!/usr/bin/env node

import { createHash, randomUUID } from 'node:crypto';
import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';

const LEGACY_URL = 'http://127.0.0.1:5001/mcp';
const V2_BASE_URL = 'http://127.0.0.1:3002';
const WATCHER_STATE_PATH = resolve('c:/P4NTH30N/RAG-watcher-state.json');
const EXPORT_PATH = resolve(
  `c:/P4NTH30N/servers/tests/rag-migration-export-${Date.now()}.json`,
);
const AUTH_TOKEN = process.env.MCP_AUTH_TOKEN;
const ORIGIN = 'http://localhost:5173';
const BATCH_SIZE = Number(process.env.BATCH_SIZE ?? 50);
const MAX_CHUNK_CHARS = Number(process.env.MAX_CHUNK_CHARS ?? 1200);
const CHUNK_OVERLAP = Number(process.env.CHUNK_OVERLAP ?? 200);
const CHUNK_PROFILE = process.env.CHUNK_PROFILE ?? 'default';

if (!AUTH_TOKEN) {
  console.error('MCP_AUTH_TOKEN is required in environment.');
  process.exit(1);
}

const migratedAt = new Date().toISOString();

async function main() {
  const legacyStatus = await callLegacyTool('rag_status', {});
  const legacyVectorCount = parseLegacyVectorCount(legacyStatus);

  console.log(`Legacy rag_status vectorCount: ${legacyVectorCount}`);

  const exportPayload = await buildExportPayload(migratedAt);
  await mkdir(dirname(EXPORT_PATH), { recursive: true });
  await writeFile(EXPORT_PATH, JSON.stringify(exportPayload, null, 2), 'utf8');
  console.log(`Exported ${exportPayload.records.length} chunks to ${EXPORT_PATH}`);

  const client = new McpClient(V2_BASE_URL, AUTH_TOKEN, ORIGIN);
  await client.connect();
  await client.initialize();

  const before = await client.callTool('rag_list', {});
  const beforeCount = Number(before?.count ?? 0);
  console.log(`RAG v2 count before import: ${beforeCount}`);

  let imported = 0;
  for (let i = 0; i < exportPayload.records.length; i += BATCH_SIZE) {
    const batch = exportPayload.records.slice(i, i + BATCH_SIZE);
    for (const record of batch) {
      await client.callTool('rag_ingest', {
        id: record.id,
        content: record.content,
        metadata: record.metadata,
      });
      imported += 1;
    }

    console.log(`Imported ${imported}/${exportPayload.records.length}`);
  }

  const after = await client.callTool('rag_list', {});
  const afterCount = Number(after?.count ?? 0);
  console.log(`RAG v2 count after import: ${afterCount}`);

  const verify = await client.callTool('rag_search', {
    query: 'RAG migration legacy FAISS ChromaDB',
    topK: 5,
  });

  client.close();

  console.log(
    JSON.stringify(
      {
        legacyVectorCount,
        exportedChunks: exportPayload.records.length,
        beforeCount,
        afterCount,
        searchResultCount: Number(verify?.count ?? 0),
        exportPath: EXPORT_PATH,
      },
      null,
      2,
    ),
  );
}

async function buildExportPayload(migrationDate) {
  const raw = await readFile(WATCHER_STATE_PATH, 'utf8');
  const normalized = raw.charCodeAt(0) === 0xfeff ? raw.slice(1) : raw;
  const state = JSON.parse(normalized);

  const ingested = state.ingested ?? {};
  const records = [];

  for (const [filePath, info] of Object.entries(ingested)) {
    try {
      const fileRaw = await readFile(filePath, 'utf8');
      const chunks = splitIntoChunks(fileRaw, MAX_CHUNK_CHARS, CHUNK_OVERLAP);

      for (let index = 0; index < chunks.length; index += 1) {
        const content = chunks[index];
        const idSource = `${filePath}::${index}::${info.hash ?? ''}::${CHUNK_PROFILE}`;
        const id = createHash('sha1').update(idSource).digest('hex');

        records.push({
          id,
          content,
          metadata: {
            source: info.source ?? filePath,
            docType: info.docType ?? 'unknown',
            hash: info.hash ?? null,
            legacyIngestedAt: info.ingestedAt ?? null,
            migratedFrom: 'legacy-rag',
            migrationDate,
            originalPath: filePath,
            chunkIndex: index,
            chunkCount: chunks.length,
          },
        });
      }
    } catch {
      continue;
    }
  }

  return {
    migrationDate,
    source: 'legacy-rag-filewatcher-state',
    records,
  };
}

function splitIntoChunks(text, maxChars, overlap) {
  const normalized = text.replace(/\r\n/g, '\n').trim();
  if (!normalized) {
    return [];
  }

  if (normalized.length <= maxChars) {
    return [normalized];
  }

  const chunks = [];
  let start = 0;

  while (start < normalized.length) {
    let end = Math.min(start + maxChars, normalized.length);

    if (end < normalized.length) {
      const boundary = normalized.lastIndexOf('\n\n', end);
      if (boundary > start + Math.floor(maxChars * 0.6)) {
        end = boundary;
      }
    }

    const piece = normalized.slice(start, end).trim();
    if (piece) {
      chunks.push(piece);
    }

    if (end >= normalized.length) {
      break;
    }

    start = Math.max(end - overlap, start + 1);
  }

  return chunks;
}

function parseLegacyVectorCount(statusResult) {
  const text = statusResult?.content?.[0]?.text;
  if (!text) {
    return 0;
  }

  try {
    const parsed = JSON.parse(text);
    return Number(parsed?.vectorStore?.vectorCount ?? 0);
  } catch {
    return 0;
  }
}

async function callLegacyTool(name, args) {
  const response = await fetch(LEGACY_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: randomUUID(),
      method: 'tools/call',
      params: {
        name,
        arguments: args,
      },
    }),
  });

  const payload = await response.json();
  if (payload.error) {
    throw new Error(payload.error.message ?? 'Legacy tool call failed');
  }

  return payload.result;
}

class McpClient {
  constructor(baseUrl, authToken, origin) {
    this.baseUrl = baseUrl;
    this.authToken = authToken;
    this.origin = origin;
    this.pending = new Map();
    this.connectionId = null;
    this.abortController = null;
  }

  async connect() {
    this.abortController = new AbortController();
    const response = await fetch(`${this.baseUrl}/sse`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${this.authToken}`,
        Origin: this.origin,
      },
      signal: this.abortController.signal,
    });

    if (!response.ok || !response.body) {
      throw new Error(`Failed to connect SSE: HTTP ${response.status}`);
    }

    this.consumeSse(response.body.getReader());

    const deadline = Date.now() + 10000;
    while (!this.connectionId && Date.now() < deadline) {
      await sleep(50);
    }

    if (!this.connectionId) {
      throw new Error('Timed out waiting for connectionId');
    }
  }

  async initialize() {
    await this.sendRequest('initialize', {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: { name: 'rag-migration-script', version: '1.0.0' },
    });

    await this.sendNotification('notifications/initialized', {});
  }

  async callTool(name, args) {
    const result = await this.sendRequest('tools/call', {
      name,
      arguments: args,
    });

    const text = result?.content?.[0]?.text;
    if (!text) {
      return result;
    }

    try {
      return JSON.parse(text);
    } catch {
      return result;
    }
  }

  close() {
    this.abortController?.abort();
  }

  async sendNotification(method, params) {
    await fetch(`${this.baseUrl}/message?connectionId=${this.connectionId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.authToken}`,
        Origin: this.origin,
      },
      body: JSON.stringify({ jsonrpc: '2.0', method, params }),
    });
  }

  async sendRequest(method, params) {
    const id = randomUUID();
    const response = await fetch(`${this.baseUrl}/message?connectionId=${this.connectionId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.authToken}`,
        Origin: this.origin,
      },
      body: JSON.stringify({ jsonrpc: '2.0', id, method, params }),
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }

    return this.waitForResponse(id);
  }

  async waitForResponse(id) {
    const deadline = Date.now() + 30000;
    while (Date.now() < deadline) {
      const message = this.pending.get(id);
      if (message) {
        this.pending.delete(id);

        if (message.error) {
          throw new Error(`${message.error.code}: ${message.error.message}`);
        }

        return message.result;
      }

      await sleep(25);
    }

    throw new Error(`Timed out waiting for request ${id}`);
  }

  async consumeSse(reader) {
    const decoder = new TextDecoder();
    let buffer = '';

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) {
          break;
        }

        buffer += decoder.decode(value, { stream: true });
        let separator = buffer.indexOf('\n\n');
        while (separator !== -1) {
          const block = buffer.slice(0, separator);
          buffer = buffer.slice(separator + 2);
          this.processEventBlock(block);
          separator = buffer.indexOf('\n\n');
        }
      }
    } catch (error) {
      if (!(error && error.name === 'AbortError')) {
        throw error;
      }
    }
  }

  processEventBlock(block) {
    const dataLine = block
      .split('\n')
      .map((line) => line.trim())
      .find((line) => line.startsWith('data:'));

    if (!dataLine) {
      return;
    }

    const payload = dataLine.slice('data:'.length).trim();
    if (!payload) {
      return;
    }

    const message = JSON.parse(payload);

    if (message.method === 'endpoint' && message.params?.uri) {
      const endpointUrl = new URL(message.params.uri, this.baseUrl);
      this.connectionId = endpointUrl.searchParams.get('connectionId');
      return;
    }

    if (message.id !== undefined && message.id !== null) {
      this.pending.set(message.id, message);
    }
  }
}

function sleep(ms) {
  return new Promise((resolveSleep) => setTimeout(resolveSleep, ms));
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
});

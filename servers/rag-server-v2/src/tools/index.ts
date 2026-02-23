import { randomUUID } from 'node:crypto';
import { z } from 'zod';
import {
  addDocument,
  deleteDocument,
  listDocuments,
  searchSimilar,
} from '../vector/store.js';

const IngestSchema = z.object({
  id: z.string().default(() => randomUUID()),
  content: z.string().min(1),
  metadata: z.record(z.string(), z.unknown()).default({}),
});

const SearchSchema = z.object({
  query: z.string().min(1),
  topK: z.number().int().positive().max(50).default(5),
});

const DeleteSchema = z.object({
  id: z.string().min(1),
});

export const ragTools = [
  {
    name: 'rag_ingest',
    description: 'Ingest a document into the RAG vector store.',
    inputSchema: {
      type: 'object',
      properties: {
        id: { type: 'string' },
        content: { type: 'string' },
        metadata: { type: 'object' },
      },
      required: ['content'],
    },
  },
  {
    name: 'rag_search',
    description: 'Search for similar documents.',
    inputSchema: {
      type: 'object',
      properties: {
        query: { type: 'string' },
        topK: { type: 'number', default: 5 },
      },
      required: ['query'],
    },
  },
  {
    name: 'rag_delete',
    description: 'Delete a document by ID.',
    inputSchema: {
      type: 'object',
      properties: {
        id: { type: 'string' },
      },
      required: ['id'],
    },
  },
  {
    name: 'rag_list',
    description: 'List document IDs currently ingested.',
    inputSchema: {
      type: 'object',
      properties: {},
    },
  },
];

export async function executeRagTool(name: string, args: unknown): Promise<unknown> {
  switch (name) {
    case 'rag_ingest': {
      const params = IngestSchema.parse(args ?? {});
      const embedding = await generateEmbedding(params.content);
      await addDocument(params.id, params.content, embedding, params.metadata);
      return { ingested: true, id: params.id };
    }
    case 'rag_search': {
      const params = SearchSchema.parse(args ?? {});
      const queryEmbedding = await generateEmbedding(params.query);
      const results = await searchSimilar(queryEmbedding, params.topK);
      return { results, count: results.length };
    }
    case 'rag_delete': {
      const params = DeleteSchema.parse(args ?? {});
      const deleted = await deleteDocument(params.id);
      return { deleted, id: params.id };
    }
    case 'rag_list': {
      const ids = await listDocuments();
      return { documents: ids, count: ids.length };
    }
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

async function generateEmbedding(text: string): Promise<number[]> {
  const seed = Array.from(text).reduce((sum, ch) => sum + ch.charCodeAt(0), 0);
  const dimensions = 128;
  const vector = Array.from({ length: dimensions }, (_, index) =>
    Math.sin(seed + index * 0.31),
  );

  const norm = Math.sqrt(vector.reduce((sum, value) => sum + value * value, 0));
  return norm === 0 ? vector : vector.map((value) => value / norm);
}

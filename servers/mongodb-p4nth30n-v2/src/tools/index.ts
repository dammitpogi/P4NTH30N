import { z } from 'zod';
import { getDb } from '../db/connection.js';

const JsonRecordSchema = z.record(z.string(), z.unknown());

const FindSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  filter: JsonRecordSchema.default({}),
  limit: z.number().int().positive().max(1000).default(10),
  skip: z.number().int().nonnegative().default(0),
});

const FindOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  filter: JsonRecordSchema,
});

const InsertOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  document: JsonRecordSchema,
});

const UpdateOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  filter: JsonRecordSchema,
  update: JsonRecordSchema,
});

const DeleteOneSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  filter: JsonRecordSchema,
});

const CountSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  filter: JsonRecordSchema.default({}),
});

const AggregateSchema = z.object({
  database: z.string().default('P4NTHE0N'),
  collection: z.string().min(1),
  pipeline: z.array(JsonRecordSchema),
});

export const mongoTools = [
  {
    name: 'mongodb_find',
    description: 'Find documents in a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string', description: 'Database name' },
        collection: { type: 'string', description: 'Collection name' },
        filter: { type: 'object', description: 'MongoDB filter' },
        limit: { type: 'number', default: 10 },
        skip: { type: 'number', default: 0 },
      },
      required: ['collection'],
    },
  },
  {
    name: 'mongodb_find_one',
    description: 'Find one document in a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' },
      },
      required: ['collection', 'filter'],
    },
  },
  {
    name: 'mongodb_insert_one',
    description: 'Insert one document into a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        document: { type: 'object' },
      },
      required: ['collection', 'document'],
    },
  },
  {
    name: 'mongodb_update_one',
    description: 'Update one document in a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' },
        update: { type: 'object' },
      },
      required: ['collection', 'filter', 'update'],
    },
  },
  {
    name: 'mongodb_delete_one',
    description: 'Delete one document in a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' },
      },
      required: ['collection', 'filter'],
    },
  },
  {
    name: 'mongodb_count',
    description: 'Count documents in a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        filter: { type: 'object' },
      },
      required: ['collection'],
    },
  },
  {
    name: 'mongodb_aggregate',
    description: 'Run an aggregation pipeline on a MongoDB collection.',
    inputSchema: {
      type: 'object',
      properties: {
        database: { type: 'string' },
        collection: { type: 'string' },
        pipeline: { type: 'array' },
      },
      required: ['collection', 'pipeline'],
    },
  },
];

export async function executeMongoTool(
  name: string,
  args: unknown,
): Promise<unknown> {
  const defaultDb = getDb();

  switch (name) {
    case 'mongodb_find': {
      const params = FindSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const docs = await collection
        .find(params.filter)
        .skip(params.skip)
        .limit(params.limit)
        .toArray();
      return { documents: docs, count: docs.length };
    }
    case 'mongodb_find_one': {
      const params = FindOneSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const doc = await collection.findOne(params.filter);
      return { document: doc, found: doc !== null };
    }
    case 'mongodb_insert_one': {
      const params = InsertOneSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const result = await collection.insertOne(params.document);
      return { insertedId: result.insertedId, acknowledged: result.acknowledged };
    }
    case 'mongodb_update_one': {
      const params = UpdateOneSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const result = await collection.updateOne(params.filter, params.update);
      return { matchedCount: result.matchedCount, modifiedCount: result.modifiedCount };
    }
    case 'mongodb_delete_one': {
      const params = DeleteOneSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const result = await collection.deleteOne(params.filter);
      return { deletedCount: result.deletedCount };
    }
    case 'mongodb_count': {
      const params = CountSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const count = await collection.countDocuments(params.filter);
      return { count };
    }
    case 'mongodb_aggregate': {
      const params = AggregateSchema.parse(args ?? {});
      const collection = defaultDb.collection(params.collection);
      const docs = await collection.aggregate(params.pipeline).toArray();
      return { documents: docs, count: docs.length };
    }
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

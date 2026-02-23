import { Db, MongoClient } from 'mongodb';

let client: MongoClient | null = null;
let db: Db | null = null;

export async function connectMongoDB(uri: string, dbName: string): Promise<Db> {
  if (client && db) {
    return db;
  }

  client = new MongoClient(uri, {
    maxPoolSize: 10,
    minPoolSize: 2,
    maxIdleTimeMS: 30000,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 30000,
  });

  await client.connect();
  db = client.db(dbName);
  return db;
}

export async function disconnectMongoDB(): Promise<void> {
  if (client) {
    await client.close();
    client = null;
    db = null;
  }
}

export function getDb(): Db {
  if (!db) {
    throw new Error('MongoDB not connected. Call connectMongoDB first.');
  }

  return db;
}

export async function checkMongoDBHealth(): Promise<boolean> {
  try {
    if (!client) {
      return false;
    }

    await client.db().admin().ping();
    return true;
  } catch {
    return false;
  }
}

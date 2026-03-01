# SPEC_MONGODB_POOLING

**Status:** Accepted (addresses DECISION_172 “Must Address #3”)  
**Owner:** Nexus  
**Audience:** Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Provide MongoDB connection pooling guidance for Railway deployments with Next.js App Router.

Goal:
- prevent connection storms
- keep latency low
- keep behavior stable across redeploys and potential multiple instances

---

## 1) Guidance (Node driver)

Use the official MongoDB Node driver and cache the client instance at module/global scope so route handlers reuse the pool.

**Rule:** never create a new MongoClient per request.

---

## 2) Recommended pool settings (starting point)

Tune based on load; these are safe defaults for a small personal deployment:

- `maxPoolSize`: 20
- `minPoolSize`: 0
- `maxIdleTimeMS`: 60_000
- `serverSelectionTimeoutMS`: 5_000
- `connectTimeoutMS`: 5_000

If you see throttling or slow cold starts, adjust:
- increase `serverSelectionTimeoutMS` to 10_000
- reduce `maxPoolSize` if Mongo is resource constrained

---

## 3) Next.js App Router usage (pattern)

In a `lib/db/mongo.ts` module:
- instantiate MongoClient once
- export `getClient()` / `getDb()` helpers

### Example snippet
```ts
import { MongoClient } from "mongodb";

const uri = process.env.MONGODB_URI!;
if (!uri) throw new Error("Missing MONGODB_URI");

let client: MongoClient;

declare global {
  // eslint-disable-next-line no-var
  var _mongoClient: MongoClient | undefined;
}

export function getMongoClient() {
  if (process.env.NODE_ENV === "development") {
    if (!global._mongoClient) {
      global._mongoClient = new MongoClient(uri, {
        maxPoolSize: 20,
        minPoolSize: 0,
        maxIdleTimeMS: 60_000,
        serverSelectionTimeoutMS: 5_000,
        connectTimeoutMS: 5_000,
      });
    }
    client = global._mongoClient;
  } else {
    if (!client) {
      client = new MongoClient(uri, {
        maxPoolSize: 20,
        minPoolSize: 0,
        maxIdleTimeMS: 60_000,
        serverSelectionTimeoutMS: 5_000,
        connectTimeoutMS: 5_000,
      });
    }
  }
  return client;
}
```

---

## 4) Operational notes
- If you run multiple Railway replicas, each replica has its own pool.
- Keep Mongo internal-only; never expose publicly.
- For Admin jobs (imports/reindex metadata), keep writes batched and idempotent.

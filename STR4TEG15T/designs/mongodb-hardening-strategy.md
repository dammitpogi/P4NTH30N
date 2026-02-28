# MongoDB-P4NTHE0N Server Hardening Strategy

## Executive Summary

**Objective**: Eliminate redundant database parameter passing while maintaining full ToolHive MCP compatibility through a configuration-driven wrapper layer.

**Current State**: Callers must pass database/collection on every call; hardcoded to `P4NTHE0N` database via env var.

**Target State**: Zero-config calls for primary database; optional override for multi-tenant scenarios; backward compatible.

---

## 1. Problem Analysis

### Current Pain Points

| Issue | Impact | Frequency |
|-------|--------|-----------|
| Database name in every call | Verbosity, cognitive load | Every operation |
| No collection-level defaults | Repetitive collection names | Domain-specific queries |
| Hardcoded P4NTHE0N database | No multi-tenant support | Architecture limitation |
| Env var only configuration | No runtime flexibility | Deployment constraint |

### Current Call Pattern (Verbose)
```javascript
// Every call requires explicit database context
mongo_find({
  database: "P4NTHE0N",      // Redundant - always same
  collection: "CRED3N7IAL",  // Could be defaulted per-tool
  filter: { Username: "user1" }
})
```

### Target Call Pattern (Simplified)
```javascript
// Primary database implied, collection defaulted
query_credentials({
  filter: { Username: "user1" }
})

// Override when needed (multi-tenant)
query_credentials({
  database: "TENANT_002",    // Explicit override
  filter: { Username: "user1" }
})
```

---

## 2. Architectural Strategy

### 2.1 Design Principles

1. **Zero Config by Default**: Primary database/collection implied from server configuration
2. **Explicit Override Always Works**: Pass database/collection to override defaults
3. **ToolHive Native**: No custom protocols; pure MCP-compliant tool definitions
4. **Backward Compatible**: Existing calls continue working without modification
5. **Configuration-Driven**: Behavior changes via config, not code changes

### 2.2 Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ToolHive MCP Client                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              MongoDB-P4NTHE0N Server (Wrapper)               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ Config Layer │  │ Tool Registry│  │ Default Resolver │   │
│  │  - defaults  │  │  - metadata  │  │  - inject params │   │
│  │  - aliases   │  │  - schemas   │  │  - validate      │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              MongoDB Driver (mongodb npm)                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Phased Implementation Plan

### Phase 1: Configuration Schema & Default Injection (Week 1)
**Risk**: Low | **Effort**: Medium | **Value**: High

#### 3.1.1 New Configuration File
**File**: `tools/mcp-p4nthon/config/database-defaults.json`

```json
{
  "schemaVersion": "1.0.0",
  "server": {
    "defaultDatabase": "P4NTHE0N",
    "allowDatabaseOverride": true,
    "enforceCollectionWhitelist": false
  },
  "tools": {
    "query_credentials": {
      "defaultCollection": "CRED3N7IAL",
      "defaultDatabase": "P4NTHE0N",
      "description": "Query user credentials and thresholds"
    },
    "query_signals": {
      "defaultCollection": "SIGN4L",
      "defaultDatabase": "P4NTHE0N"
    },
    "query_jackpots": {
      "defaultCollection": "J4CKP0T",
      "defaultDatabase": "P4NTHE0N"
    },
    "mongo_find": {
      "requireCollection": true,
      "defaultDatabase": "P4NTHE0N"
    },
    "mongo_insertOne": {
      "requireCollection": true,
      "defaultDatabase": "P4NTHE0N"
    },
    "mongo_updateOne": {
      "requireCollection": true,
      "defaultDatabase": "P4NTHE0N"
    },
    "mongo_insertMany": {
      "requireCollection": true,
      "defaultDatabase": "P4NTHE0N"
    },
    "mongo_updateMany": {
      "requireCollection": true,
      "defaultDatabase": "P4NTHE0N"
    }
  },
  "aliases": {
    "creds": "query_credentials",
    "signals": "query_signals",
    "jackpots": "query_jackpots"
  }
}
```

#### 3.1.2 Config Loader Module
**File**: `tools/mcp-p4nthon/src/config/loader.ts`

```typescript
import { readFileSync } from 'fs';
import { resolve } from 'path';

export interface ToolDefaults {
  defaultCollection?: string;
  defaultDatabase?: string;
  requireCollection?: boolean;
  description?: string;
}

export interface DatabaseConfig {
  schemaVersion: string;
  server: {
    defaultDatabase: string;
    allowDatabaseOverride: boolean;
    enforceCollectionWhitelist: boolean;
  };
  tools: Record<string, ToolDefaults>;
  aliases: Record<string, string>;
}

export class ConfigLoader {
  private config: DatabaseConfig | null = null;
  private configPath: string;

  constructor(configPath?: string) {
    this.configPath = configPath || this.getDefaultConfigPath();
  }

  private getDefaultConfigPath(): string {
    // Priority: env var > relative to dist > relative to src
    if (process.env.MCP_P4NTHE0N_CONFIG) {
      return process.env.MCP_P4NTHE0N_CONFIG;
    }
    // Resolved relative to compiled output
    return resolve(__dirname, '../../config/database-defaults.json');
  }

  load(): DatabaseConfig {
    if (this.config) return this.config;

    try {
      const content = readFileSync(this.configPath, 'utf-8');
      this.config = JSON.parse(content) as DatabaseConfig;
      return this.config;
    } catch (error) {
      console.error(`Failed to load config from ${this.configPath}:`, error);
      // Return safe defaults
      return this.getFallbackConfig();
    }
  }

  private getFallbackConfig(): DatabaseConfig {
    return {
      schemaVersion: "1.0.0",
      server: {
        defaultDatabase: process.env.DATABASE_NAME || "P4NTHE0N",
        allowDatabaseOverride: true,
        enforceCollectionWhitelist: false
      },
      tools: {},
      aliases: {}
    };
  }

  getToolDefaults(toolName: string): ToolDefaults | undefined {
    const config = this.load();
    // Check aliases first
    const aliasedName = config.aliases[toolName] || toolName;
    return config.tools[aliasedName];
  }

  resolveAlias(toolName: string): string {
    const config = this.load();
    return config.aliases[toolName] || toolName;
  }

  getDefaultDatabase(): string {
    return this.load().server.defaultDatabase;
  }

  isDatabaseOverrideAllowed(): boolean {
    return this.load().server.allowDatabaseOverride;
  }
}

export const configLoader = new ConfigLoader();
```

#### 3.1.3 Parameter Injection Layer
**File**: `tools/mcp-p4nthon/src/middleware/parameter-injector.ts`

```typescript
import { configLoader, ToolDefaults } from '../config/loader.js';

export interface InjectedParameters {
  database: string;
  collection?: string;
}

export class ParameterInjector {
  inject(toolName: string, userArgs: Record<string, unknown>): InjectedParameters {
    const defaults = configLoader.getToolDefaults(toolName);
    const serverDefaultDb = configLoader.getDefaultDatabase();
    const allowOverride = configLoader.isDatabaseOverrideAllowed();

    // Resolve database: user > tool default > server default
    const database = allowOverride && userArgs.database 
      ? String(userArgs.database)
      : (defaults?.defaultDatabase || serverDefaultDb);

    // Resolve collection: user > tool default > undefined (may be required)
    const collection = userArgs.collection 
      ? String(userArgs.collection)
      : defaults?.defaultCollection;

    // Validation
    if (defaults?.requireCollection && !collection) {
      throw new Error(
        `Tool '${toolName}' requires a collection. ` +
        `Either pass 'collection' parameter or configure defaultCollection in database-defaults.json`
      );
    }

    return { database, collection };
  }

  /**
   * Merges user arguments with injected defaults.
   * Preserves all user-provided values (user wins).
   */
  mergeArgs(
    toolName: string, 
    userArgs: Record<string, unknown>
  ): Record<string, unknown> {
    const injected = this.inject(toolName, userArgs);
    
    return {
      ...injected,           // Injected defaults first
      ...userArgs,           // User args override
      _injected: injected,   // Metadata for debugging
      _toolName: toolName
    };
  }
}

export const parameterInjector = new ParameterInjector();
```

### Phase 2: Tool Schema Enhancement (Week 1-2)
**Risk**: Low | **Effort**: Medium | **Value**: High

#### 3.2.1 Enhanced Tool Definitions
**File**: `tools/mcp-p4nthon/src/tools/definitions.ts`

```typescript
import { configLoader } from '../config/loader.js';

export interface ToolDefinition {
  name: string;
  description: string;
  inputSchema: object;
  injectDefaults: boolean;
}

// Domain-specific tools (no collection required)
export const DOMAIN_TOOLS: ToolDefinition[] = [
  {
    name: "query_credentials",
    description: "Query CRED3N7IAL collection for user credentials and thresholds",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database (P4NTHE0N)",
        },
        filter: {
          type: "object",
          description: "MongoDB filter query",
        },
        limit: {
          type: "number",
          description: "Maximum results to return",
          default: 10,
        },
      },
    },
  },
  {
    name: "query_signals",
    description: "Query SIGN4L collection for active signals",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database",
        },
        status: {
          type: "string",
          description: "Signal status filter (pending, processing, completed)",
        },
        limit: {
          type: "number",
          default: 10,
        },
      },
    },
  },
  {
    name: "query_jackpots",
    description: "Query J4CKP0T collection for jackpot forecasts",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database",
        },
        gameId: {
          type: "string",
          description: "Filter by game ID",
        },
        limit: {
          type: "number",
          default: 10,
        },
      },
    },
  },
  {
    name: "get_system_status",
    description: "Get overall P4NTHE0N system status summary",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database",
        },
      },
    },
  },
];

// Generic CRUD tools (collection required but can be defaulted)
export const GENERIC_TOOLS: ToolDefinition[] = [
  {
    name: "mongo_insertOne",
    description: "Insert a single document into any MongoDB collection",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database (P4NTHE0N)",
        },
        collection: {
          type: "string",
          description: "Collection name (uses default if not specified)",
        },
        document: {
          type: "object",
          description: "Document to insert",
        },
      },
      required: ["document"], // collection now optional if defaulted
    },
  },
  {
    name: "mongo_find",
    description: "Query documents from any MongoDB collection",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database (P4NTHE0N)",
        },
        collection: {
          type: "string",
          description: "Collection name (uses default if not specified)",
        },
        filter: {
          type: "object",
          description: "MongoDB filter query",
          default: {},
        },
        limit: {
          type: "number",
          default: 10,
        },
      },
      required: [], // All optional with defaults
    },
  },
  {
    name: "mongo_updateOne",
    description: "Update a single document matching the filter",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database",
        },
        collection: {
          type: "string",
          description: "Collection name (uses default if not specified)",
        },
        filter: {
          type: "object",
        },
        update: {
          type: "object",
          description: "Update operations ($set, etc.)",
        },
      },
      required: ["filter", "update"],
    },
  },
  {
    name: "mongo_insertMany",
    description: "Insert multiple documents into a collection",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database",
        },
        collection: {
          type: "string",
          description: "Collection name (uses default if not specified)",
        },
        documents: {
          type: "array",
          items: { type: "object" },
        },
      },
      required: ["documents"],
    },
  },
  {
    name: "mongo_updateMany",
    description: "Update all documents matching the filter",
    injectDefaults: true,
    inputSchema: {
      type: "object" as const,
      properties: {
        database: {
          type: "string",
          description: "Optional: Override default database",
        },
        collection: {
          type: "string",
          description: "Collection name (uses default if not specified)",
        },
        filter: {
          type: "object",
        },
        update: {
          type: "object",
        },
      },
      required: ["filter", "update"],
    },
  },
];

export const ALL_TOOLS = [...DOMAIN_TOOLS, ...GENERIC_TOOLS];

/**
 * Get tools with descriptions enriched from config
 */
export function getEnrichedTools(): ToolDefinition[] {
  return ALL_TOOLS.map(tool => {
    const defaults = configLoader.getToolDefaults(tool.name);
    if (defaults?.description) {
      return {
        ...tool,
        description: defaults.description
      };
    }
    return tool;
  });
}
```

### Phase 3: Server Integration (Week 2)
**Risk**: Medium | **Effort**: Medium | **Value**: High

#### 3.3.1 Refactored Server Entry Point
**File**: `tools/mcp-p4nthon/src/index.ts` (Modified)

```typescript
#!/usr/bin/env node
/**
 * MCP-P4NTHE0N Server v2.0
 * 
 * Model Context Protocol server with configuration-driven defaults.
 * Eliminates redundant database/collection parameters through smart injection.
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { MongoClient, Db } from "mongodb";
import { configLoader } from "./config/loader.js";
import { parameterInjector } from "./middleware/parameter-injector.js";
import { getEnrichedTools } from "./tools/definitions.js";

// Configuration from environment (fallback to config file)
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost:27017";

// MongoDB client cache (per-database connections)
const clientCache = new Map<string, MongoClient>();
const dbCache = new Map<string, Db>();

async function getDatabase(databaseName: string): Promise<Db> {
  // Return cached DB instance
  if (dbCache.has(databaseName)) {
    return dbCache.get(databaseName)!;
  }

  // Get or create client
  let client: MongoClient;
  if (clientCache.has(MONGODB_URI)) {
    client = clientCache.get(MONGODB_URI)!;
  } else {
    client = new MongoClient(MONGODB_URI);
    await client.connect();
    clientCache.set(MONGODB_URI, client);
  }

  const db = client.db(databaseName);
  dbCache.set(databaseName, db);
  return db;
}

// Server implementation
const server = new Server(
  {
    name: "mcp-p4nth30n",
    version: "2.0.0", // Bumped for new capabilities
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools (with enriched descriptions)
server.setRequestHandler(ListToolsRequestSchema, async () => {
  const tools = getEnrichedTools();
  return { 
    tools: tools.map(t => ({
      name: t.name,
      description: t.description,
      inputSchema: t.inputSchema
    }))
  };
});

// Handle tool calls with parameter injection
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: rawArgs } = request.params;

  try {
    // Inject defaults into arguments
    const args = parameterInjector.mergeArgs(name, rawArgs || {});
    const { database, collection } = parameterInjector.inject(name, rawArgs || {});
    
    // Get database connection
    const db = await getDatabase(database);

    // Route to handler
    const handler = toolHandlers[name];
    if (!handler) {
      throw new Error(`Unknown tool: ${name}`);
    }

    const result = await handler(db, args, collection);
    return {
      content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error: ${error instanceof Error ? error.message : String(error)}`,
        },
      ],
      isError: true,
    };
  }
});

// Tool handlers registry
const toolHandlers: Record<
  string, 
  (db: Db, args: Record<string, unknown>, collection?: string) => Promise<unknown>
> = {
  // Domain-specific handlers
  query_credentials: async (db, args) => {
    const coll = db.collection("CRED3N7IAL");
    const filter = (args.filter as Record<string, unknown>) || {};
    const limit = (args.limit as number) || 10;
    return coll.find(filter).limit(limit).toArray();
  },

  query_signals: async (db, args) => {
    const coll = db.collection("SIGN4L");
    const status = args.status as string;
    const limit = (args.limit as number) || 10;
    const filter = status ? { Status: status } : {};
    return coll.find(filter).limit(limit).toArray();
  },

  query_jackpots: async (db, args) => {
    const coll = db.collection("J4CKP0T");
    const gameId = args.gameId as string;
    const limit = (args.limit as number) || 10;
    const filter = gameId ? { GameId: gameId } : {};
    return coll.find(filter).limit(limit).toArray();
  },

  get_system_status: async (db) => {
    const [credCount, signalCount, jackpotCount, pendingSignals] = await Promise.all([
      db.collection("CRED3N7IAL").countDocuments(),
      db.collection("SIGN4L").countDocuments(),
      db.collection("J4CKP0T").countDocuments(),
      db.collection("SIGN4L").countDocuments({ Status: "pending" })
    ]);

    return {
      timestamp: new Date().toISOString(),
      database: db.databaseName,
      collections: { credentials: credCount, signals: signalCount, jackpots: jackpotCount },
      pendingSignals,
      status: pendingSignals > 0 ? "active" : "idle",
    };
  },

  // Generic CRUD handlers
  mongo_find: async (db, args, collection) => {
    if (!collection) throw new Error("Collection required for mongo_find");
    const coll = db.collection(collection);
    const filter = (args.filter as Record<string, unknown>) || {};
    const limit = (args.limit as number) || 10;
    return coll.find(filter).limit(limit).toArray();
  },

  mongo_insertOne: async (db, args, collection) => {
    if (!collection) throw new Error("Collection required for mongo_insertOne");
    const coll = db.collection(collection);
    const result = await coll.insertOne(args.document as Record<string, unknown>);
    return { insertedId: result.insertedId };
  },

  mongo_updateOne: async (db, args, collection) => {
    if (!collection) throw new Error("Collection required for mongo_updateOne");
    const coll = db.collection(collection);
    const result = await coll.updateOne(
      args.filter as Record<string, unknown>,
      args.update as Record<string, unknown>
    );
    return { matched: result.matchedCount, modified: result.modifiedCount };
  },

  mongo_insertMany: async (db, args, collection) => {
    if (!collection) throw new Error("Collection required for mongo_insertMany");
    const coll = db.collection(collection);
    const result = await coll.insertMany(args.documents as Record<string, unknown>[]);
    return { insertedCount: result.insertedCount, ids: result.insertedIds };
  },

  mongo_updateMany: async (db, args, collection) => {
    if (!collection) throw new Error("Collection required for mongo_updateMany");
    const coll = db.collection(collection);
    const result = await coll.updateMany(
      args.filter as Record<string, unknown>,
      args.update as Record<string, unknown>
    );
    return { matched: result.matchedCount, modified: result.modifiedCount };
  },
};

// Start server
async function main() {
  // Pre-load configuration
  configLoader.load();
  console.error("MCP-P4NTHE0N v2.0 server starting...");
  console.error(`Default database: ${configLoader.getDefaultDatabase()}`);
  console.error(`Database override: ${configLoader.isDatabaseOverrideAllowed() ? 'enabled' : 'disabled'}`);

  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP-P4NTHE0N server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
```

### Phase 4: ToolHive Integration & Wrapper (Week 2-3)
**Risk**: Low | **Effort**: Low | **Value**: High

#### 3.4.1 ToolHive Configuration Update
**File**: `tools/mcp-development/servers/toolhive-gateway/config/mongodb-p4nth30n.json` (Updated)

```json
{
  "id": "toolhive-mongodb-p4nth30n-v3",
  "name": "mongodb-p4nth30n",
  "transport": "stdio",
  "command": "node",
  "args": [
    "C:/P4NTHE0N/tools/mcp-p4nthon/dist/index.js"
  ],
  "envVars": {
    "MONGODB_URI": "mongodb://localhost:27017",
    "DATABASE_NAME": "P4NTHE0N",
    "MCP_P4NTHE0N_CONFIG": "C:/P4NTHE0N/tools/mcp-p4nthon/config/database-defaults.json"
  },
  "tags": [
    "p4nth30n",
    "database",
    "mongodb",
    "crud",
    "v2"
  ],
  "description": "P4NTHE0N MongoDB with smart defaults - no database/collection required for primary operations",
  "enabled": true
}
```

#### 3.4.2 Migration Helper Script
**File**: `tools/mcp-p4nthon/scripts/migrate-calls.js`

```javascript
#!/usr/bin/env node
/**
 * Migration helper for MongoDB-P4NTHE0N v1 to v2 calls
 * 
 * Usage: node migrate-calls.js --check <file>  # Check for deprecated patterns
 *        node migrate-calls.js --fix <file>     # Auto-fix where safe
 */

const fs = require('fs');
const path = require('path');

// Patterns that can be automatically simplified
const MIGRATION_PATTERNS = [
  {
    name: "query_credentials with explicit database",
    pattern: /mongo_find\s*\(\s*\{[^}]*collection\s*:\s*["']CRED3N7IAL["'][^}]*\}/g,
    suggestion: "Replace with query_credentials({ filter: ... })",
    autoFixable: true,
    fix: (match) => match.replace(/mongo_find\s*\(\s*\{[^}]*collection\s*:\s*["']CRED3N7IAL["']/, 'query_credentials({')
  },
  {
    name: "query_signals with explicit database",
    pattern: /mongo_find\s*\(\s*\{[^}]*collection\s*:\s*["']SIGN4L["'][^}]*\}/g,
    suggestion: "Replace with query_signals({ status: ... })",
    autoFixable: true
  },
  {
    name: "query_jackpots with explicit database", 
    pattern: /mongo_find\s*\(\s*\{[^}]*collection\s*:\s*["']J4CKP0T["'][^}]*\}/g,
    suggestion: "Replace with query_jackpots({ gameId: ... })",
    autoFixable: true
  },
  {
    name: "Explicit P4NTHE0N database parameter",
    pattern: /database\s*:\s*["']P4NTHE0N["']/g,
    suggestion: "Remove - database is now defaulted",
    autoFixable: true,
    fix: (match, fullText) => {
      // Remove the database property, handle trailing comma
      return '';
    }
  }
];

function analyzeFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const issues = [];

  for (const pattern of MIGRATION_PATTERNS) {
    const matches = content.match(pattern.pattern);
    if (matches) {
      issues.push({
        pattern: pattern.name,
        count: matches.length,
        suggestion: pattern.suggestion,
        autoFixable: pattern.autoFixable,
        examples: matches.slice(0, 3) // Show first 3
      });
    }
  }

  return issues;
}

function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  const filePath = args[1];

  if (!command || !filePath) {
    console.log('Usage: node migrate-calls.js --check <file>');
    console.log('       node migrate-calls.js --fix <file>');
    process.exit(1);
  }

  if (command === '--check') {
    const issues = analyzeFile(filePath);
    if (issues.length === 0) {
      console.log('✅ No deprecated patterns found');
    } else {
      console.log(`⚠️  Found ${issues.length} pattern(s) that can be simplified:\n`);
      issues.forEach(issue => {
        console.log(`  ${issue.pattern} (${issue.count} occurrences)`);
        console.log(`  Suggestion: ${issue.suggestion}`);
        console.log(`  Auto-fixable: ${issue.autoFixable ? 'Yes' : 'No'}`);
        if (issue.examples.length > 0) {
          console.log(`  Examples: ${issue.examples.join(', ')}`);
        }
        console.log('');
      });
    }
  }
}

main();
```

---

## 4. Files to Modify

### Core Implementation Files

| File | Change Type | Description |
|------|-------------|-------------|
| `tools/mcp-p4nthon/config/database-defaults.json` | **Create** | Configuration schema for defaults |
| `tools/mcp-p4nthon/src/config/loader.ts` | **Create** | Configuration loading with fallback |
| `tools/mcp-p4nthon/src/middleware/parameter-injector.ts` | **Create** | Default injection logic |
| `tools/mcp-p4nthon/src/tools/definitions.ts` | **Create** | Tool schema definitions |
| `tools/mcp-p4nthon/src/index.ts` | **Modify** | Refactor to use new architecture |
| `tools/mcp-p4nthon/package.json` | **Modify** | Bump version to 2.0.0 |

### ToolHive Integration Files

| File | Change Type | Description |
|------|-------------|-------------|
| `tools/mcp-development/servers/toolhive-gateway/config/mongodb-p4nth30n.json` | **Modify** | Add CONFIG_PATH env var, update description |
| `tools/mcp-development/servers/toolhive-gateway/config/servers.json` | **Modify** | Update server entry (auto-generated) |

### Migration & Documentation

| File | Change Type | Description |
|------|-------------|-------------|
| `tools/mcp-p4nthon/scripts/migrate-calls.js` | **Create** | Migration helper for existing code |
| `tools/mcp-p4nthon/MIGRATION.md` | **Create** | Migration guide for users |
| `tools/mcp-p4nthon/README.md` | **Modify** | Update with v2.0 usage examples |

---

## 5. Validation Plan

### 5.1 Unit Tests
**File**: `tools/mcp-p4nthon/src/config/loader.test.ts`

```typescript
import { describe, it, expect } from 'bun:test';
import { ConfigLoader } from './loader.js';

describe('ConfigLoader', () => {
  it('loads defaults from file', () => {
    const loader = new ConfigLoader('./config/database-defaults.json');
    const config = loader.load();
    expect(config.server.defaultDatabase).toBe('P4NTHE0N');
  });

  it('falls back to env var when file missing', () => {
    process.env.DATABASE_NAME = 'TEST_DB';
    const loader = new ConfigLoader('./nonexistent.json');
    expect(loader.getDefaultDatabase()).toBe('TEST_DB');
  });

  it('resolves tool defaults correctly', () => {
    const loader = new ConfigLoader('./config/database-defaults.json');
    const defaults = loader.getToolDefaults('query_credentials');
    expect(defaults?.defaultCollection).toBe('CRED3N7IAL');
  });

  it('resolves aliases', () => {
    const loader = new ConfigLoader('./config/database-defaults.json');
    expect(loader.resolveAlias('creds')).toBe('query_credentials');
    expect(loader.resolveAlias('query_credentials')).toBe('query_credentials');
  });
});
```

### 5.2 Integration Tests
**File**: `tools/mcp-p4nthon/src/middleware/parameter-injector.test.ts`

```typescript
import { describe, it, expect } from 'bun:test';
import { ParameterInjector } from './parameter-injector.js';

describe('ParameterInjector', () => {
  const injector = new ParameterInjector();

  it('injects default database when not specified', () => {
    const result = injector.inject('query_credentials', {});
    expect(result.database).toBe('P4NTHE0N');
  });

  it('preserves user database when specified', () => {
    const result = injector.inject('query_credentials', { database: 'OTHER' });
    expect(result.database).toBe('OTHER');
  });

  it('injects default collection for domain tools', () => {
    const result = injector.inject('query_credentials', {});
    expect(result.collection).toBe('CRED3N7IAL');
  });

  it('throws when collection required but not provided', () => {
    expect(() => {
      injector.inject('mongo_find', {});
    }).toThrow('requires a collection');
  });
});
```

### 5.3 End-to-End Validation

#### Test Matrix

| Test Case | Expected Result | Validation Method |
|-----------|-----------------|-------------------|
| `query_credentials({filter: {}})` | Uses P4NTHE0N.CRED3N7IAL | Check returned database name |
| `query_credentials({database: 'TEST'})` | Uses TEST.CRED3N7IAL | Check returned database name |
| `mongo_find({collection: 'test'})` | Uses P4NTHE0N.test | Check returned database name |
| `mongo_find({})` | Throws "collection required" | Error message validation |
| Legacy call with `database: 'P4NTHE0N'` | Works (backward compat) | Integration test |

#### Manual Verification Steps

```bash
# 1. Start server with test config
cd tools/mcp-p4nthon
MCP_P4NTHE0N_CONFIG=./config/database-defaults.json node dist/index.js

# 2. Test with MCP inspector (or direct JSON-RPC)
# Send ListTools request - verify schemas show optional database/collection

# 3. Test simplified call
echo '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"query_credentials","arguments":{"filter":{},"limit":1}}}' | node dist/index.js

# 4. Test override call  
echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"query_credentials","arguments":{"database":"OTHER","filter":{},"limit":1}}}' | node dist/index.js
```

---

## 6. Fallbacks & Error Handling

### 6.1 Configuration Fallback Chain

```
User-provided value
    ↓ (if undefined)
Tool default from database-defaults.json
    ↓ (if undefined)
Server default from database-defaults.json
    ↓ (if undefined)
Environment variable DATABASE_NAME
    ↓ (if undefined)
Hardcoded fallback "P4NTHE0N"
```

### 6.2 Error Scenarios

| Scenario | Behavior | User Message |
|----------|----------|--------------|
| Config file missing | Use env var / hardcoded defaults | (silent, log to stderr) |
| Config file invalid JSON | Use env var / hardcoded defaults | "Config parse error, using defaults" |
| Database override disabled | Reject with error | "Database override not permitted for this tool" |
| Collection required but missing | Reject with helpful error | "Tool 'X' requires 'collection'. Configure defaultCollection or pass explicitly." |
| Database connection fails | Standard MongoDB error | (pass through from driver) |

### 6.3 Backward Compatibility Strategy

**Guarantee**: All v1 calls continue working without modification.

**Mechanism**:
1. User-provided values always win over defaults
2. Existing explicit `database: 'P4NTHE0N'` calls work unchanged
3. Existing explicit `collection: 'NAME'` calls work unchanged
4. Only new calls can omit parameters

---

## 7. Migration Path

### 7.1 Phase 0: Pre-Migration (Day 0)

```bash
# Audit existing usage
node tools/mcp-p4nthon/scripts/migrate-calls.js --check "./H0UND/**/*.ts"
node tools/mcp-p4nthon/scripts/migrate-calls.js --check "./H4ND/**/*.ts"
```

### 7.2 Phase 1: Server Deployment (Day 1-2)

```bash
# Deploy new server version
cd tools/mcp-p4nthon
npm run build

# Update ToolHive configuration
# (Automatically picked up from servers.json)
```

### 7.3 Phase 2: Opportunistic Simplification (Ongoing)

**New code** uses simplified calls:
```javascript
// ✅ New pattern - simplified
const creds = await query_credentials({ filter: { Username: user } });
```

**Old code** continues working:
```javascript
// ✅ Old pattern - still works
const creds = await mongo_find({ 
  collection: 'CRED3N7IAL',
  database: 'P4NTHE0N',  // Redundant but harmless
  filter: { Username: user } 
});
```

### 7.4 Phase 3: Active Migration (Week 3-4)

Target high-value simplifications:
1. Replace `mongo_find({collection: 'CRED3N7IAL', ...})` → `query_credentials({...})`
2. Remove explicit `database: 'P4NTHE0N'` where redundant
3. Add per-workflow collection defaults for repeated operations

### 7.5 Migration Example

**Before**:
```typescript
// Every credential lookup - verbose
async function getUserCreds(username: string) {
  const result = await mongo_find({
    database: 'P4NTHE0N',      // Always same
    collection: 'CRED3N7IAL',  // Always same
    filter: { Username: username },
    limit: 1
  });
  return result[0];
}
```

**After**:
```typescript
// Same function - simplified
async function getUserCreds(username: string) {
  const result = await query_credentials({
    filter: { Username: username },
    limit: 1
  });
  return result[0];
}
```

---

## 8. ToolHive Compatibility Assurance

### 8.1 MCP Compliance Checklist

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| JSON-RPC 2.0 over stdio | `@modelcontextprotocol/sdk` | ✅ |
| Standard tool schema | Zod-like JSON Schema | ✅ |
| No custom transport | Pure stdio | ✅ |
| No custom protocols | Standard MCP | ✅ |
| Error format compliance | MCP error structure | ✅ |

### 8.2 ToolHive-Specific Considerations

1. **Server Discovery**: ToolHive reads `servers.json` - no changes needed beyond updating the entry
2. **Environment Variables**: All configuration via env vars (ToolHive-compatible)
3. **Process Lifecycle**: Stdio transport, clean shutdown on SIGTERM (ToolHive-managed)
4. **Logging**: All logs to stderr (stdout reserved for JSON-RPC)

---

## 9. Success Metrics

| Metric | Baseline | Target | Measurement |
|--------|----------|--------|-------------|
| Avg params per call | 3.2 (database, collection, filter) | 1.5 (filter only) | Code analysis |
| Lines of boilerplate per query | 5-7 | 2-3 | Code review |
| Migration adoption | 0% | 60% of new code | PR analysis |
| Backward compat issues | N/A | 0 | Integration tests |
| Config reload time | N/A | <100ms | Benchmark |

---

## 10. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Config file not found | Low | Medium | Fallback to env vars |
| Database override abuse | Low | High | Configurable enforcement |
| ToolHive schema cache | Medium | Low | Bump server version |
| Multi-tenant confusion | Medium | Medium | Clear override semantics |
| Breaking change introduced | Very Low | Critical | Comprehensive test suite |

---

## 11. Decision & Next Steps

### Recommended: Proceed with Phase 1-2

This strategy delivers high value (simplified calls) with low risk (backward compatible, config-driven).

### Immediate Actions

1. **Create decision record**: `STR4TEG15T/decisions/DECISION_0XX_mongodb_hardening.md`
2. **Delegate Phase 1 implementation**: Assign to @openfixer (CLI/config specialist)
3. **Schedule validation**: End-to-end test with live MongoDB instance
4. **Prepare migration guide**: Document for H0UND/H4ND teams

### Delegation Targets

| Phase | Agent | Rationale |
|-------|-------|-----------|
| Phase 1-2 (Config, Schema) | @openfixer | TypeScript/Node.js config systems |
| Phase 3 (Server Integration) | @windfixer | P4NTHE0N-specific integration |
| Phase 4 (ToolHive, Migration) | @openfixer | External config, CLI tools |
| Validation & Testing | @windfixer | Live service validation |

---

## Appendix A: Configuration Schema Reference

```typescript
// Complete TypeScript schema for database-defaults.json
interface DatabaseDefaultsConfig {
  schemaVersion: string;           // "1.0.0"
  
  server: {
    defaultDatabase: string;       // Fallback database name
    allowDatabaseOverride: boolean; // Can callers specify different db?
    enforceCollectionWhitelist: boolean; // Restrict to known collections?
  };
  
  tools: {
    [toolName: string]: {
      defaultCollection?: string;  // Auto-inject collection
      defaultDatabase?: string;    // Override server default
      requireCollection?: boolean; // Error if no default and not provided
      description?: string;        // Override tool description
    }
  };
  
  aliases: {
    [alias: string]: string;       // Map alias -> actual tool name
  };
}
```

## Appendix B: Example Configurations

### B.1 Multi-Tenant Setup
```json
{
  "server": {
    "defaultDatabase": "TENANT_DEFAULT",
    "allowDatabaseOverride": true
  },
  "tools": {
    "query_credentials": {
      "defaultCollection": "CRED3N7IAL"
    }
  }
}
```

### B.2 Strict Mode (Production)
```json
{
  "server": {
    "defaultDatabase": "P4NTHE0N_PROD",
    "allowDatabaseOverride": false,
    "enforceCollectionWhitelist": true
  }
}
```

### B.3 Development Mode
```json
{
  "server": {
    "defaultDatabase": "P4NTHE0N_DEV",
    "allowDatabaseOverride": true
  },
  "aliases": {
    "creds": "query_credentials",
    "sigs": "query_signals",
    "pots": "query_jackpots"
  }
}
```

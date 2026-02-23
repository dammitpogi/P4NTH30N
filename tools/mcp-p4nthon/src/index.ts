#!/usr/bin/env node
/**
 * MCP-P4NTH30N Server
 * 
 * Model Context Protocol server for P4NTH30N platform integration.
 * Provides tools for querying casino automation data, signals, and jackpots.
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
	CallToolRequestSchema,
	ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { MongoClient } from "mongodb";

// Configuration from environment
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost:27017";
const DATABASE_NAME = process.env.DATABASE_NAME || "P4NTH30N";

// MongoDB client
let mongoClient: MongoClient | null = null;

async function getMongoClient(): Promise<MongoClient> {
	if (!mongoClient) {
		mongoClient = new MongoClient(MONGODB_URI);
		await mongoClient.connect();
	}
	return mongoClient;
}

// Tool definitions
const TOOLS = [
	{
		name: "query_credentials",
		description: "Query CRED3N7IAL collection for user credentials and thresholds",
		inputSchema: {
			type: "object" as const,
			properties: {
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
		inputSchema: {
			type: "object" as const,
			properties: {
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
		inputSchema: {
			type: "object" as const,
			properties: {
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
		description: "Get overall P4NTH30N system status summary",
		inputSchema: {
			type: "object" as const,
			properties: {},
		},
	},
	{
		name: "mongo_insertOne",
		description: "Insert a single document into any MongoDB collection",
		inputSchema: {
			type: "object" as const,
			properties: {
				collection: {
					type: "string",
					description: "Collection name",
				},
				document: {
					type: "object",
					description: "Document to insert",
				},
			},
			required: ["collection", "document"],
		},
	},
	{
		name: "mongo_find",
		description: "Query documents from any MongoDB collection",
		inputSchema: {
			type: "object" as const,
			properties: {
				collection: {
					type: "string",
					description: "Collection name",
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
			required: ["collection"],
		},
	},
	{
		name: "mongo_updateOne",
		description: "Update a single document matching the filter",
		inputSchema: {
			type: "object" as const,
			properties: {
				collection: {
					type: "string",
				},
				filter: {
					type: "object",
				},
				update: {
					type: "object",
					description: "Update operations ($set, etc.)",
				},
			},
			required: ["collection", "filter", "update"],
		},
	},
	{
		name: "mongo_insertMany",
		description: "Insert multiple documents into a collection",
		inputSchema: {
			type: "object" as const,
			properties: {
				collection: {
					type: "string",
				},
				documents: {
					type: "array",
					items: {
						type: "object",
					},
				},
			},
			required: ["collection", "documents"],
		},
	},
	{
		name: "mongo_updateMany",
		description: "Update all documents matching the filter",
		inputSchema: {
			type: "object" as const,
			properties: {
				collection: {
					type: "string",
				},
				filter: {
					type: "object",
				},
				update: {
					type: "object",
				},
			},
			required: ["collection", "filter", "update"],
		},
	},
];

// Server implementation
const server = new Server(
	{
		name: "mcp-p4nth30n",
		version: "1.0.0",
	},
	{
		capabilities: {
			tools: {},
		},
	}
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
	return { tools: TOOLS };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
	const { name, arguments: args } = request.params;

	try {
		const client = await getMongoClient();
		const db = client.db(DATABASE_NAME);

		switch (name) {
			case "query_credentials": {
				const collection = db.collection("CRED3N7IAL");
				const filter = (args as any).filter || {};
				const limit = (args as any).limit || 10;
				const results = await collection.find(filter).limit(limit).toArray();
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(results, null, 2),
						},
					],
				};
			}

			case "query_signals": {
				const collection = db.collection("SIGN4L");
				const status = (args as any).status;
				const limit = (args as any).limit || 10;
				const filter = status ? { Status: status } : {};
				const results = await collection.find(filter).limit(limit).toArray();
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(results, null, 2),
						},
					],
				};
			}

			case "query_jackpots": {
				const collection = db.collection("J4CKP0T");
				const gameId = (args as any).gameId;
				const limit = (args as any).limit || 10;
				const filter = gameId ? { GameId: gameId } : {};
				const results = await collection.find(filter).limit(limit).toArray();
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(results, null, 2),
						},
					],
				};
			}

			case "get_system_status": {
				const credCount = await db.collection("CRED3N7IAL").countDocuments();
				const signalCount = await db.collection("SIGN4L").countDocuments();
				const jackpotCount = await db.collection("J4CKP0T").countDocuments();
				const pendingSignals = await db
					.collection("SIGN4L")
					.countDocuments({ Status: "pending" });

				const status = {
					timestamp: new Date().toISOString(),
					database: DATABASE_NAME,
					collections: {
						credentials: credCount,
						signals: signalCount,
						jackpots: jackpotCount,
					},
					pendingSignals,
					status: pendingSignals > 0 ? "active" : "idle",
				};

				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(status, null, 2),
						},
					],
				};
			}

			case "mongo_insertOne": {
				const collection = db.collection((args as any).collection);
				const result = await collection.insertOne((args as any).document);
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(
								{ insertedId: result.insertedId },
								null,
								2
							),
						},
					],
				};
			}

			case "mongo_find": {
				const collection = db.collection((args as any).collection);
				const filter = (args as any).filter || {};
				const limit = (args as any).limit || 10;
				const results = await collection.find(filter).limit(limit).toArray();
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(results, null, 2),
						},
					],
				};
			}

			case "mongo_updateOne": {
				const collection = db.collection((args as any).collection);
				const result = await collection.updateOne(
					(args as any).filter,
					(args as any).update
				);
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(
								{
									matched: result.matchedCount,
									modified: result.modifiedCount,
								},
								null,
								2
							),
						},
					],
				};
			}

			case "mongo_insertMany": {
				const collection = db.collection((args as any).collection);
				const result = await collection.insertMany((args as any).documents);
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(
								{
									insertedCount: result.insertedCount,
									ids: result.insertedIds,
								},
								null,
								2
							),
						},
					],
				};
			}

			case "mongo_updateMany": {
				const collection = db.collection((args as any).collection);
				const result = await collection.updateMany(
					(args as any).filter,
					(args as any).update
				);
				return {
					content: [
						{
							type: "text",
							text: JSON.stringify(
								{
									matched: result.matchedCount,
									modified: result.modifiedCount,
								},
								null,
								2
							),
						},
					],
				};
			}

			default:
				throw new Error(`Unknown tool: ${name}`);
		}
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

// Start server
async function main() {
	const transport = new StdioServerTransport();
	await server.connect(transport);
	console.error("MCP-P4NTH30N server running on stdio");
}

main().catch((error) => {
	console.error("Fatal error:", error);
	process.exit(1);
});

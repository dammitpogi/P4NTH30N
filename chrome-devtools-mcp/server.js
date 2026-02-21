#!/usr/bin/env node

/**
 * P4NTH30N CDP MCP Server
 *
 * Lightweight MCP server that provides evaluate_script with per-call
 * host/port targeting for remote Chrome DevTools Protocol execution.
 *
 * Designed for H4ND VM (192.168.56.10) → Host Chrome (192.168.56.1:9222).
 *
 * OPS_018: Enable Remote CDP Execution for MCP Server
 */

import WebSocket from "ws";
import http from "node:http";
import { createInterface } from "node:readline";

// --- Defaults ---
const DEFAULT_HOST = "192.168.56.1";
const DEFAULT_PORT = 9222;
const CONNECTION_TIMEOUT_MS = 5000;
const COMMAND_TIMEOUT_MS = 10000;

// --- Connection cache: reuse WebSocket connections per host:port ---
const connectionCache = new Map();

/**
 * Fetch the WebSocket debugger URL from Chrome's /json/list endpoint.
 * Rewrites ws://localhost → ws://<host> for VM connectivity.
 */
async function fetchDebuggerUrl(host, port) {
	const listUrl = `http://${host}:${port}/json/list`;
	const controller = new AbortController();
	const timeout = setTimeout(() => controller.abort(), CONNECTION_TIMEOUT_MS);

	try {
		const response = await fetch(listUrl, { signal: controller.signal });
		const targets = await response.json();
		const page = targets.find((t) => t.type === "page");

		if (!page || !page.webSocketDebuggerUrl) {
			throw new Error(`No debuggable page found at ${host}:${port}`);
		}

		let wsUrl = page.webSocketDebuggerUrl;
		// CDP returns ws://localhost:PORT/... — replace with actual host IP for remote connectivity
		if (host !== "localhost" && host !== "127.0.0.1") {
			wsUrl = wsUrl.replace(/ws:\/\/localhost:/g, `ws://${host}:`);
			wsUrl = wsUrl.replace(/ws:\/\/127\.0\.0\.1:/g, `ws://${host}:`);
		}

		return { wsUrl, title: page.title || "", url: page.url || "" };
	} finally {
		clearTimeout(timeout);
	}
}

/**
 * Connect to a Chrome CDP WebSocket endpoint.
 * Returns a { ws, commandId } handle.
 */
async function connectCdp(host, port) {
	const cacheKey = `${host}:${port}`;

	// Check cache for open connection
	const cached = connectionCache.get(cacheKey);
	if (cached && cached.ws.readyState === WebSocket.OPEN) {
		return cached;
	}

	// Clean up stale cache entry
	if (cached) {
		try {
			cached.ws.close();
		} catch {}
		connectionCache.delete(cacheKey);
	}

	const { wsUrl, title, url } = await fetchDebuggerUrl(host, port);

	return new Promise((resolve, reject) => {
		const timeout = setTimeout(() => {
			ws.close();
			reject(new Error(`[CDP] Connection timeout to ${host}:${port} after ${CONNECTION_TIMEOUT_MS}ms`));
		}, CONNECTION_TIMEOUT_MS);

		const ws = new WebSocket(wsUrl);
		const handle = { ws, commandId: 0, title, url };

		ws.on("open", () => {
			clearTimeout(timeout);
			connectionCache.set(cacheKey, handle);
			resolve(handle);
		});

		ws.on("error", (err) => {
			clearTimeout(timeout);
			connectionCache.delete(cacheKey);
			reject(new Error(`[CDP] WebSocket error connecting to ${host}:${port}: ${err.message}`));
		});

		ws.on("close", () => {
			connectionCache.delete(cacheKey);
		});
	});
}

/**
 * Send a CDP command and wait for the matching response.
 * Skips CDP event notifications (messages without matching id).
 */
function sendCommand(handle, method, params = {}) {
	return new Promise((resolve, reject) => {
		const id = ++handle.commandId;
		const timeout = setTimeout(() => {
			reject(new Error(`[CDP] Command ${method} timed out after ${COMMAND_TIMEOUT_MS}ms`));
		}, COMMAND_TIMEOUT_MS);

		const onMessage = (data) => {
			try {
				const message = JSON.parse(data.toString());
				if (message.id === id) {
					clearTimeout(timeout);
					handle.ws.removeListener("message", onMessage);
					if (message.error) {
						reject(new Error(`[CDP] ${method} error: ${message.error.message}`));
					} else {
						resolve(message.result);
					}
				}
				// else: event notification — skip
			} catch (parseErr) {
				// Non-JSON message — skip
			}
		};

		handle.ws.on("message", onMessage);
		handle.ws.send(JSON.stringify({ id, method, params }));
	});
}

// --- MCP Tool Definitions ---
const TOOLS = [
	{
		name: "evaluate_script",
		description: "Evaluate a JavaScript function on a Chrome instance via CDP. Supports remote host/port targeting. Returns JSON-serializable results.",
		inputSchema: {
			type: "object",
			properties: {
				function: {
					type: "string",
					description: 'A JavaScript expression or function to execute in the browser context. Example: "() => document.title" or "1 + 1"',
				},
				args: {
					type: "array",
					description: "Optional arguments to pass.",
					items: {},
				},
				host: {
					type: "string",
					description: `Hostname or IP of the Chrome CDP instance. Default: ${DEFAULT_HOST}`,
				},
				port: {
					type: "integer",
					description: `Port of the Chrome CDP instance. Default: ${DEFAULT_PORT}`,
				},
			},
			required: ["function"],
		},
	},
	{
		name: "list_targets",
		description: "List available Chrome CDP targets (pages, service workers, etc.) on a remote instance.",
		inputSchema: {
			type: "object",
			properties: {
				host: { type: "string", description: `Hostname or IP. Default: ${DEFAULT_HOST}` },
				port: { type: "integer", description: `Port. Default: ${DEFAULT_PORT}` },
			},
		},
	},
	{
		name: "navigate",
		description: "Navigate the Chrome browser to a URL via CDP Page.navigate.",
		inputSchema: {
			type: "object",
			properties: {
				url: { type: "string", description: "The URL to navigate to." },
				host: { type: "string", description: `Hostname or IP. Default: ${DEFAULT_HOST}` },
				port: { type: "integer", description: `Port. Default: ${DEFAULT_PORT}` },
			},
			required: ["url"],
		},
	},
	{
		name: "get_version",
		description: "Get Chrome browser version and protocol info from the CDP endpoint.",
		inputSchema: {
			type: "object",
			properties: {
				host: { type: "string", description: `Hostname or IP. Default: ${DEFAULT_HOST}` },
				port: { type: "integer", description: `Port. Default: ${DEFAULT_PORT}` },
			},
		},
	},
];

// --- Tool Handlers ---
async function handleEvaluateScript({ function: fn, args, host, port }) {
	const targetHost = host || DEFAULT_HOST;
	const targetPort = port || DEFAULT_PORT;

	try {
		const handle = await connectCdp(targetHost, targetPort);

		try {
			await sendCommand(handle, "Runtime.enable");
		} catch {}

		let expression;
		const trimmed = fn.trim();
		if (trimmed.startsWith("(") || trimmed.startsWith("function") || trimmed.startsWith("async")) {
			const argsJson = args && args.length > 0 ? args.map((a) => JSON.stringify(a)).join(", ") : "";
			expression = `(${trimmed})(${argsJson})`;
		} else {
			expression = trimmed;
		}

		const result = await sendCommand(handle, "Runtime.evaluate", {
			expression,
			returnByValue: true,
			awaitPromise: true,
			timeout: COMMAND_TIMEOUT_MS,
		});

		if (result.exceptionDetails) {
			const exMsg = result.exceptionDetails.exception?.description || result.exceptionDetails.text || "Unknown error";
			return { content: [{ type: "text", text: `[CDP] Evaluation error on ${targetHost}:${targetPort}:\n${exMsg}` }], isError: true };
		}

		const value = result.result?.value;
		const type = result.result?.type;
		const subtype = result.result?.subtype;
		let displayValue = value === undefined ? (subtype === "null" ? "null" : "undefined") : JSON.stringify(value, null, 2);

		return { content: [{ type: "text", text: `[CDP ${targetHost}:${targetPort}] Result (${type}${subtype ? `:${subtype}` : ""}):\n${displayValue}` }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[CDP] Failed to evaluate on ${targetHost}:${targetPort}: ${err.message}` }], isError: true };
	}
}

async function handleListTargets({ host, port }) {
	const targetHost = host || DEFAULT_HOST;
	const targetPort = port || DEFAULT_PORT;
	try {
		const controller = new AbortController();
		const t = setTimeout(() => controller.abort(), CONNECTION_TIMEOUT_MS);
		const response = await fetch(`http://${targetHost}:${targetPort}/json/list`, { signal: controller.signal });
		clearTimeout(t);
		const targets = await response.json();
		const formatted = targets.map((t, i) => `[${i}] ${t.type}: ${t.title}\n    URL: ${t.url}\n    ID: ${t.id}`).join("\n\n");
		return { content: [{ type: "text", text: `[CDP ${targetHost}:${targetPort}] ${targets.length} target(s):\n\n${formatted}` }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[CDP] Failed to list targets on ${targetHost}:${targetPort}: ${err.message}` }], isError: true };
	}
}

async function handleNavigate({ url, host, port }) {
	const targetHost = host || DEFAULT_HOST;
	const targetPort = port || DEFAULT_PORT;
	try {
		const handle = await connectCdp(targetHost, targetPort);
		await sendCommand(handle, "Page.enable");
		const result = await sendCommand(handle, "Page.navigate", { url });
		return { content: [{ type: "text", text: `[CDP ${targetHost}:${targetPort}] Navigated to: ${url}\nFrame: ${result.frameId || "unknown"}` }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[CDP] Navigation failed on ${targetHost}:${targetPort}: ${err.message}` }], isError: true };
	}
}

async function handleGetVersion({ host, port }) {
	const targetHost = host || DEFAULT_HOST;
	const targetPort = port || DEFAULT_PORT;
	try {
		const controller = new AbortController();
		const t = setTimeout(() => controller.abort(), CONNECTION_TIMEOUT_MS);
		const response = await fetch(`http://${targetHost}:${targetPort}/json/version`, { signal: controller.signal });
		clearTimeout(t);
		const info = await response.json();
		return { content: [{ type: "text", text: `[CDP ${targetHost}:${targetPort}] Browser: ${info.Browser || "unknown"}\nProtocol: ${info["Protocol-Version"] || "unknown"}\nUser-Agent: ${info["User-Agent"] || "unknown"}\nV8: ${info["V8-Version"] || "unknown"}` }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[CDP] Version check failed on ${targetHost}:${targetPort}: ${err.message}` }], isError: true };
	}
}

const TOOL_HANDLERS = {
	evaluate_script: handleEvaluateScript,
	list_targets: handleListTargets,
	navigate: handleNavigate,
	get_version: handleGetVersion,
};

// --- MCP JSON-RPC Handler ---
async function handleJsonRpc(request) {
	const { method, params, id } = request;

	switch (method) {
		case "initialize":
			return {
				jsonrpc: "2.0",
				id,
				result: {
					protocolVersion: "2024-11-05",
					capabilities: { tools: { listChanged: false } },
					serverInfo: { name: "p4nth30n-cdp-mcp", version: "1.0.0" },
				},
			};

		case "notifications/initialized":
			return null; // notification — no response

		case "tools/list":
			return { jsonrpc: "2.0", id, result: { tools: TOOLS } };

		case "tools/call": {
			const toolName = params?.name;
			const handler = TOOL_HANDLERS[toolName];
			if (!handler) {
				return {
					jsonrpc: "2.0",
					id,
					error: { code: -32601, message: `Unknown tool: ${toolName}` },
				};
			}
			try {
				const result = await handler(params.arguments || {});
				return { jsonrpc: "2.0", id, result };
			} catch (err) {
				return {
					jsonrpc: "2.0",
					id,
					result: {
						content: [{ type: "text", text: `[CDP] Tool error: ${err.message}` }],
						isError: true,
					},
				};
			}
		}

		default:
			if (!id) return null; // notification
			return {
				jsonrpc: "2.0",
				id,
				error: { code: -32601, message: `Method not found: ${method}` },
			};
	}
}

// --- Start Server ---
const HTTP_PORT = parseInt(process.env.MCP_PORT || process.env.PORT || "5301", 10);
const TRANSPORT_MODE = process.env.MCP_TRANSPORT || process.argv[2] || "http";

async function main() {
	if (TRANSPORT_MODE === "stdio") {
		// stdio transport: read JSON-RPC from stdin, write to stdout
		const rl = createInterface({ input: process.stdin });
		rl.on("line", async (line) => {
			try {
				const request = JSON.parse(line.trim());
				const response = await handleJsonRpc(request);
				if (response) {
					process.stdout.write(JSON.stringify(response) + "\n");
				}
			} catch (err) {
				console.error(`[p4nth30n-cdp-mcp] Parse error: ${err.message}`);
			}
		});
		console.error("[p4nth30n-cdp-mcp] Server started on stdio transport");
		console.error(`[p4nth30n-cdp-mcp] Default target: ${DEFAULT_HOST}:${DEFAULT_PORT}`);
	} else {
		// HTTP transport for ToolHive remote registration
		const httpServer = http.createServer(async (req, res) => {
			// Health check
			if (req.method === "GET" && req.url === "/health") {
				res.writeHead(200, { "Content-Type": "application/json" });
				res.end(JSON.stringify({ status: "ok", target: `${DEFAULT_HOST}:${DEFAULT_PORT}` }));
				return;
			}

			// MCP endpoint
			if (req.url === "/mcp" || req.url === "/mcp/") {
				const accept = req.headers["accept"] || "";
				const wantsSSE = accept.includes("text/event-stream");

				if (req.method === "POST") {
					let body = "";
					for await (const chunk of req) body += chunk;

					try {
						const request = JSON.parse(body);
						const response = await handleJsonRpc(request);

						if (response) {
							if (wantsSSE) {
								// StreamableHTTP: respond with SSE
								res.writeHead(200, {
									"Content-Type": "text/event-stream",
									"Cache-Control": "no-cache",
									Connection: "keep-alive",
								});
								res.write(`event: message\ndata: ${JSON.stringify(response)}\n\n`);
								res.end();
							} else {
								// Plain JSON-RPC
								res.writeHead(200, { "Content-Type": "application/json" });
								res.end(JSON.stringify(response));
							}
						} else {
							res.writeHead(202);
							res.end();
						}
					} catch (err) {
						const errResp = { jsonrpc: "2.0", error: { code: -32700, message: "Parse error" }, id: null };
						if (wantsSSE) {
							res.writeHead(200, { "Content-Type": "text/event-stream", "Cache-Control": "no-cache" });
							res.write(`event: message\ndata: ${JSON.stringify(errResp)}\n\n`);
							res.end();
						} else {
							res.writeHead(400, { "Content-Type": "application/json" });
							res.end(JSON.stringify(errResp));
						}
					}
					return;
				}

				if (req.method === "GET") {
					// SSE stream or readiness probe
					res.writeHead(200, { "Content-Type": "application/json" });
					res.end(JSON.stringify({ name: "p4nth30n-cdp-mcp", version: "1.0.0", status: "ready" }));
					return;
				}

				if (req.method === "DELETE") {
					res.writeHead(200);
					res.end();
					return;
				}

				res.writeHead(405);
				res.end("Method not allowed");
				return;
			}

			res.writeHead(404);
			res.end("Not found");
		});

		httpServer.listen(HTTP_PORT, "127.0.0.1", () => {
			console.error(`[p4nth30n-cdp-mcp] HTTP server listening on http://127.0.0.1:${HTTP_PORT}/mcp`);
			console.error(`[p4nth30n-cdp-mcp] Default target: ${DEFAULT_HOST}:${DEFAULT_PORT}`);
		});
	}
}

main().catch((err) => {
	console.error("[p4nth30n-cdp-mcp] Fatal error:", err);
	process.exit(1);
});

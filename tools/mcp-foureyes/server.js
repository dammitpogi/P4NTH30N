#!/usr/bin/env node

/**
 * P4NTHE0N FourEyes MCP Server
 *
 * Exposes FourEyes vision capabilities as MCP tools:
 * - analyze_frame: CDP screenshot → LMStudio vision model → structured analysis
 * - capture_screenshot: CDP screenshot capture (returns base64 PNG)
 * - check_health: LMStudio + CDP connectivity check
 * - list_models: Available vision models in LMStudio
 * - review_decision: Second-opinion review of a decision (text analysis)
 *
 * Transport: stdio (default) or HTTP (--http flag or MCP_TRANSPORT=http)
 * Requires: Chrome CDP at DEFAULT_HOST:DEFAULT_PORT, LMStudio at LMSTUDIO_URL
 *
 * DECISION_036: FourEyes Development Assistant Activation
 */

import WebSocket from "ws";
import http from "node:http";
import { createInterface } from "node:readline";

// --- Configuration ---
const CDP_HOST = process.env.CDP_HOST || "127.0.0.1";
const CDP_PORT = parseInt(process.env.CDP_PORT || "9222", 10);
const LMSTUDIO_URL = process.env.LMSTUDIO_URL || "http://localhost:1234";
const CONNECTION_TIMEOUT_MS = 5000;
const COMMAND_TIMEOUT_MS = 15000;
const HTTP_PORT = parseInt(process.env.MCP_PORT || "5302", 10);

// --- CDP Connection (reused from chrome-devtools-mcp pattern) ---
const connectionCache = new Map();

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
		if (host !== "localhost" && host !== "127.0.0.1") {
			wsUrl = wsUrl.replace(/ws:\/\/localhost:/g, `ws://${host}:`);
			wsUrl = wsUrl.replace(/ws:\/\/127\.0\.0\.1:/g, `ws://${host}:`);
		}
		return { wsUrl, title: page.title || "", url: page.url || "" };
	} finally {
		clearTimeout(timeout);
	}
}

async function connectCdp(host, port) {
	const cacheKey = `${host}:${port}`;
	const cached = connectionCache.get(cacheKey);
	if (cached && cached.ws.readyState === WebSocket.OPEN) return cached;
	if (cached) {
		try { cached.ws.close(); } catch {}
		connectionCache.delete(cacheKey);
	}
	const { wsUrl, title, url } = await fetchDebuggerUrl(host, port);
	return new Promise((resolve, reject) => {
		const timeout = setTimeout(() => { ws.close(); reject(new Error(`CDP connection timeout ${host}:${port}`)); }, CONNECTION_TIMEOUT_MS);
		const ws = new WebSocket(wsUrl);
		const handle = { ws, commandId: 0, title, url };
		ws.on("open", () => { clearTimeout(timeout); connectionCache.set(cacheKey, handle); resolve(handle); });
		ws.on("error", (err) => { clearTimeout(timeout); connectionCache.delete(cacheKey); reject(new Error(`CDP WS error ${host}:${port}: ${err.message}`)); });
		ws.on("close", () => { connectionCache.delete(cacheKey); });
	});
}

function sendCdpCommand(handle, method, params = {}) {
	return new Promise((resolve, reject) => {
		const id = ++handle.commandId;
		const timeout = setTimeout(() => reject(new Error(`CDP ${method} timeout`)), COMMAND_TIMEOUT_MS);
		const onMessage = (data) => {
			try {
				const msg = JSON.parse(data.toString());
				if (msg.id === id) {
					clearTimeout(timeout);
					handle.ws.removeListener("message", onMessage);
					msg.error ? reject(new Error(`CDP ${method}: ${msg.error.message}`)) : resolve(msg.result);
				}
			} catch {}
		};
		handle.ws.on("message", onMessage);
		handle.ws.send(JSON.stringify({ id, method, params }));
	});
}

// --- LMStudio Client ---
async function lmStudioRequest(endpoint, body = null, method = "GET") {
	const url = `${LMSTUDIO_URL}${endpoint}`;
	const controller = new AbortController();
	const timeout = setTimeout(() => controller.abort(), COMMAND_TIMEOUT_MS);
	try {
		const options = { method, signal: controller.signal, headers: { "Content-Type": "application/json" } };
		if (body) options.body = JSON.stringify(body);
		const response = await fetch(url, options);
		return await response.json();
	} finally {
		clearTimeout(timeout);
	}
}

async function analyzeImageWithLMStudio(base64Image, modelId, prompt) {
	const payload = {
		model: modelId,
		messages: [{
			role: "user",
			content: [
				{ type: "text", text: prompt || "Analyze this game screenshot. Extract: jackpot values (Grand, Major, Minor, Mini), player balance, game state (idle/spinning/bonus/error), and any visible buttons (spin, bet, menu). Respond in JSON format with keys: grand, major, minor, mini, balance, state, buttons[]." },
				{ type: "image_url", image_url: { url: `data:image/png;base64,${base64Image}` } }
			]
		}],
		max_tokens: 800,
		temperature: 0.1
	};
	return await lmStudioRequest("/v1/chat/completions", payload, "POST");
}

function parseVisionResponse(content) {
	try {
		const jsonStart = content.indexOf("{");
		const jsonEnd = content.lastIndexOf("}");
		if (jsonStart >= 0 && jsonEnd > jsonStart) {
			return JSON.parse(content.substring(jsonStart, jsonEnd + 1));
		}
	} catch {}
	return { raw: content, parseError: true };
}

// --- MCP Tool Definitions ---
const TOOLS = [
	{
		name: "analyze_frame",
		description: "Capture a CDP screenshot and analyze it via LMStudio vision model. Returns structured JSON with jackpot values, balance, game state, and detected buttons. This is the primary FourEyes vision tool.",
		inputSchema: {
			type: "object",
			properties: {
				model: { type: "string", description: "LMStudio model ID to use. If omitted, uses first available vision model." },
				prompt: { type: "string", description: "Custom analysis prompt. If omitted, uses default game analysis prompt." },
				host: { type: "string", description: `CDP host. Default: ${CDP_HOST}` },
				port: { type: "integer", description: `CDP port. Default: ${CDP_PORT}` }
			}
		}
	},
	{
		name: "capture_screenshot",
		description: "Capture a PNG screenshot from Chrome via CDP. Returns base64-encoded image data.",
		inputSchema: {
			type: "object",
			properties: {
				host: { type: "string", description: `CDP host. Default: ${CDP_HOST}` },
				port: { type: "integer", description: `CDP port. Default: ${CDP_PORT}` },
				quality: { type: "integer", description: "JPEG quality 0-100. Omit for PNG." },
				clip: {
					type: "object",
					description: "Optional viewport clip region.",
					properties: {
						x: { type: "number" }, y: { type: "number" },
						width: { type: "number" }, height: { type: "number" }, scale: { type: "number" }
					}
				}
			}
		}
	},
	{
		name: "check_health",
		description: "Check FourEyes subsystem health: LMStudio availability, loaded models, CDP connectivity, current page info.",
		inputSchema: {
			type: "object",
			properties: {
				host: { type: "string", description: `CDP host. Default: ${CDP_HOST}` },
				port: { type: "integer", description: `CDP port. Default: ${CDP_PORT}` }
			}
		}
	},
	{
		name: "list_models",
		description: "List available models in LMStudio. Returns model IDs and metadata.",
		inputSchema: { type: "object", properties: {} }
	},
	{
		name: "review_decision",
		description: "FourEyes second-opinion review of a decision. Sends decision context to LMStudio for independent analysis. Returns structured review with agreement/disagreement, concerns, and recommendation.",
		inputSchema: {
			type: "object",
			properties: {
				decision_id: { type: "string", description: "Decision ID (e.g., DECISION_045)" },
				title: { type: "string", description: "Decision title" },
				description: { type: "string", description: "Decision description and implementation details" },
				oracle_approval: { type: "number", description: "Oracle approval percentage (0-100)" },
				risk_level: { type: "string", description: "Risk level: Low, Medium, High, Critical" },
				model: { type: "string", description: "LMStudio model to use for review. If omitted, uses first available." }
			},
			required: ["decision_id", "title", "description"]
		}
	}
];

// --- Tool Handlers ---
async function handleAnalyzeFrame({ model, prompt, host, port }) {
	const targetHost = host || CDP_HOST;
	const targetPort = port || CDP_PORT;
	const startTime = Date.now();

	try {
		// Step 1: Capture screenshot via CDP
		const handle = await connectCdp(targetHost, targetPort);
		const screenshotResult = await sendCdpCommand(handle, "Page.captureScreenshot", { format: "png" });
		const base64Image = screenshotResult.data;
		const screenshotMs = Date.now() - startTime;

		// Step 2: Determine model
		let modelId = model;
		if (!modelId) {
			try {
				const models = await lmStudioRequest("/v1/models");
				if (models.data && models.data.length > 0) {
					modelId = models.data[0].id;
				}
			} catch {}
		}
		if (!modelId) {
			return { content: [{ type: "text", text: `[FourEyes] Screenshot captured (${screenshotMs}ms) but no LMStudio model available. Base64 length: ${base64Image.length}` }] };
		}

		// Step 3: Analyze with LMStudio
		const analysisResult = await analyzeImageWithLMStudio(base64Image, modelId, prompt);
		const totalMs = Date.now() - startTime;

		const responseContent = analysisResult.choices?.[0]?.message?.content || "No response";
		const parsed = parseVisionResponse(responseContent);

		const output = {
			model: modelId,
			screenshot_ms: screenshotMs,
			analysis_ms: totalMs - screenshotMs,
			total_ms: totalMs,
			page_title: handle.title,
			page_url: handle.url,
			analysis: parsed,
			raw_response: parsed.parseError ? responseContent : undefined
		};

		return { content: [{ type: "text", text: JSON.stringify(output, null, 2) }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[FourEyes] Analysis failed: ${err.message}` }], isError: true };
	}
}

async function handleCaptureScreenshot({ host, port, quality, clip }) {
	const targetHost = host || CDP_HOST;
	const targetPort = port || CDP_PORT;
	try {
		const handle = await connectCdp(targetHost, targetPort);
		const params = { format: quality !== undefined ? "jpeg" : "png" };
		if (quality !== undefined) params.quality = quality;
		if (clip) params.clip = clip;
		const result = await sendCdpCommand(handle, "Page.captureScreenshot", params);

		return {
			content: [
				{ type: "text", text: `[FourEyes] Screenshot captured from ${targetHost}:${targetPort} (${handle.title})\nPage: ${handle.url}\nFormat: ${params.format}\nBase64 length: ${result.data.length}` },
				{ type: "image", data: result.data, mimeType: params.format === "jpeg" ? "image/jpeg" : "image/png" }
			]
		};
	} catch (err) {
		return { content: [{ type: "text", text: `[FourEyes] Screenshot failed: ${err.message}` }], isError: true };
	}
}

async function handleCheckHealth({ host, port }) {
	const targetHost = host || CDP_HOST;
	const targetPort = port || CDP_PORT;
	const health = { lmstudio: {}, cdp: {}, overall: "unknown" };

	// Check LMStudio
	try {
		const models = await lmStudioRequest("/v1/models");
		health.lmstudio = {
			status: "healthy",
			url: LMSTUDIO_URL,
			models: models.data?.map(m => m.id) || [],
			model_count: models.data?.length || 0
		};
	} catch (err) {
		health.lmstudio = { status: "unhealthy", url: LMSTUDIO_URL, error: err.message };
	}

	// Check CDP
	try {
		const handle = await connectCdp(targetHost, targetPort);
		health.cdp = {
			status: "healthy",
			target: `${targetHost}:${targetPort}`,
			page_title: handle.title,
			page_url: handle.url
		};
	} catch (err) {
		health.cdp = { status: "unhealthy", target: `${targetHost}:${targetPort}`, error: err.message };
	}

	health.overall = (health.lmstudio.status === "healthy" && health.cdp.status === "healthy") ? "healthy"
		: (health.lmstudio.status === "healthy" || health.cdp.status === "healthy") ? "degraded"
		: "unhealthy";

	return { content: [{ type: "text", text: JSON.stringify(health, null, 2) }] };
}

async function handleListModels() {
	try {
		const models = await lmStudioRequest("/v1/models");
		const formatted = (models.data || []).map((m, i) =>
			`[${i}] ${m.id}${m.owned_by ? ` (${m.owned_by})` : ""}`
		).join("\n");
		return { content: [{ type: "text", text: `[FourEyes] LMStudio models (${LMSTUDIO_URL}):\n\n${formatted || "No models loaded"}` }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[FourEyes] Cannot reach LMStudio at ${LMSTUDIO_URL}: ${err.message}` }], isError: true };
	}
}

async function handleReviewDecision({ decision_id, title, description, oracle_approval, risk_level, model }) {
	let modelId = model;
	if (!modelId) {
		try {
			const models = await lmStudioRequest("/v1/models");
			if (models.data?.length > 0) modelId = models.data[0].id;
		} catch {}
	}
	if (!modelId) {
		return { content: [{ type: "text", text: "[FourEyes] No LMStudio model available for review. Start LMStudio and load a model." }], isError: true };
	}

	const reviewPrompt = `You are Four Eyes, an independent second-opinion reviewer for critical decisions in the P4NTHE0N system.

Review this decision and provide your independent assessment:

DECISION: ${decision_id}
TITLE: ${title}
ORACLE APPROVAL: ${oracle_approval || "N/A"}%
RISK LEVEL: ${risk_level || "Unknown"}

DESCRIPTION:
${description}

Provide your review in this exact JSON format:
{
  "recommendation": "Proceed|Proceed with modifications|Hold for revision",
  "confidence": "High|Medium|Low",
  "agreement_with_oracle": "Full|Partial|None",
  "concerns": ["concern 1", "concern 2"],
  "missed_considerations": ["item 1"],
  "recommendations": ["rec 1", "rec 2"],
  "rationale": "Your reasoning"
}`;

	try {
		const result = await lmStudioRequest("/v1/chat/completions", {
			model: modelId,
			messages: [{ role: "user", content: reviewPrompt }],
			max_tokens: 1000,
			temperature: 0.3
		}, "POST");

		const content = result.choices?.[0]?.message?.content || "No response";
		const parsed = parseVisionResponse(content);

		return { content: [{ type: "text", text: JSON.stringify({
			decision_id,
			model: modelId,
			review: parsed,
			raw: parsed.parseError ? content : undefined
		}, null, 2) }] };
	} catch (err) {
		return { content: [{ type: "text", text: `[FourEyes] Review failed: ${err.message}` }], isError: true };
	}
}

const TOOL_HANDLERS = {
	analyze_frame: handleAnalyzeFrame,
	capture_screenshot: handleCaptureScreenshot,
	check_health: handleCheckHealth,
	list_models: handleListModels,
	review_decision: handleReviewDecision
};

// --- MCP JSON-RPC Handler ---
async function handleJsonRpc(request) {
	const { method, params, id } = request;

	switch (method) {
		case "initialize":
			return {
				jsonrpc: "2.0", id,
				result: {
					protocolVersion: "2024-11-05",
					capabilities: { tools: { listChanged: false } },
					serverInfo: { name: "p4nth30n-foureyes-mcp", version: "1.0.0" }
				}
			};
		case "notifications/initialized":
			return null;
		case "tools/list":
			return { jsonrpc: "2.0", id, result: { tools: TOOLS } };
		case "tools/call": {
			const toolName = params?.name;
			const handler = TOOL_HANDLERS[toolName];
			if (!handler) {
				return { jsonrpc: "2.0", id, error: { code: -32601, message: `Unknown tool: ${toolName}` } };
			}
			try {
				const result = await handler(params.arguments || {});
				return { jsonrpc: "2.0", id, result };
			} catch (err) {
				return { jsonrpc: "2.0", id, result: { content: [{ type: "text", text: `[FourEyes] Tool error: ${err.message}` }], isError: true } };
			}
		}
		default:
			if (!id) return null;
			return { jsonrpc: "2.0", id, error: { code: -32601, message: `Method not found: ${method}` } };
	}
}

// --- Start Server ---
const TRANSPORT_MODE = process.env.MCP_TRANSPORT || process.argv[2] || "stdio";

async function main() {
	if (TRANSPORT_MODE === "stdio") {
		const rl = createInterface({ input: process.stdin });
		rl.on("line", async (line) => {
			try {
				const request = JSON.parse(line.trim());
				const response = await handleJsonRpc(request);
				if (response) process.stdout.write(JSON.stringify(response) + "\n");
			} catch (err) {
				console.error(`[foureyes-mcp] Parse error: ${err.message}`);
			}
		});
		console.error("[foureyes-mcp] Server started on stdio transport");
		console.error(`[foureyes-mcp] CDP target: ${CDP_HOST}:${CDP_PORT}`);
		console.error(`[foureyes-mcp] LMStudio: ${LMSTUDIO_URL}`);
	} else {
		const httpServer = http.createServer(async (req, res) => {
			if (req.method === "GET" && req.url === "/health") {
				res.writeHead(200, { "Content-Type": "application/json" });
				res.end(JSON.stringify({ status: "ok", cdp: `${CDP_HOST}:${CDP_PORT}`, lmstudio: LMSTUDIO_URL }));
				return;
			}
			if (req.url === "/mcp" || req.url === "/mcp/") {
				if (req.method === "POST") {
					let body = "";
					for await (const chunk of req) body += chunk;
					try {
						const request = JSON.parse(body);
						const response = await handleJsonRpc(request);
						if (response) {
							res.writeHead(200, { "Content-Type": "application/json" });
							res.end(JSON.stringify(response));
						} else {
							res.writeHead(202); res.end();
						}
					} catch (err) {
						res.writeHead(400, { "Content-Type": "application/json" });
						res.end(JSON.stringify({ jsonrpc: "2.0", error: { code: -32700, message: "Parse error" }, id: null }));
					}
					return;
				}
				if (req.method === "GET") {
					res.writeHead(200, { "Content-Type": "application/json" });
					res.end(JSON.stringify({ name: "p4nth30n-foureyes-mcp", version: "1.0.0", status: "ready" }));
					return;
				}
			}
			res.writeHead(404); res.end("Not found");
		});
		httpServer.listen(HTTP_PORT, "127.0.0.1", () => {
			console.error(`[foureyes-mcp] HTTP server on http://127.0.0.1:${HTTP_PORT}/mcp`);
			console.error(`[foureyes-mcp] CDP: ${CDP_HOST}:${CDP_PORT} | LMStudio: ${LMSTUDIO_URL}`);
		});
	}
}

main().catch((err) => { console.error("[foureyes-mcp] Fatal:", err); process.exit(1); });

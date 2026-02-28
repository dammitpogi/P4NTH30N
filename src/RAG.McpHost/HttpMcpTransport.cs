using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using P4NTHE0N.RAG;

namespace P4NTHE0N.RAG.McpHost;

/// <summary>
/// MCP Streamable HTTP transport: exposes JSON-RPC over HTTP POST at /mcp endpoint.
/// Compatible with ToolHive remote MCP server registration.
/// </summary>
public sealed class HttpMcpTransport
{
	private readonly RagMcpServer _server;
	private readonly int _port;
	private readonly string _host;

	private static readonly JsonSerializerOptions _jsonOptions = new()
	{
		PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
		WriteIndented = false,
		Converters = { new JsonStringEnumConverter() },
		DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
	};

	private static readonly object _serverInfo = new { name = "rag-server", version = "1.0.0" };

	private static readonly object[] _toolDefinitions = new object[]
	{
		new
		{
			name = "rag_query",
			description = "Search RAG knowledge base for relevant context with metadata filtering",
			inputSchema = new
			{
				type = "object",
				properties = new Dictionary<string, object>
				{
					["query"] = new { type = "string", description = "Search query text" },
					["topK"] = new { type = "integer", description = "Number of results (1-20, default 5)" },
					["filter"] = new { type = "object", description = "Metadata filter (fields: agent, type, source, platform, category, status)" },
					["includeMetadata"] = new { type = "boolean", description = "Include metadata in results (default true)" },
				},
				required = new[] { "query" },
			},
		},
		new
		{
			name = "rag_ingest",
			description = "Ingest content directly into RAG knowledge base",
			inputSchema = new
			{
				type = "object",
				properties = new Dictionary<string, object>
				{
					["content"] = new { type = "string", description = "Content to ingest" },
					["source"] = new { type = "string", description = "Source identifier" },
					["metadata"] = new { type = "object", description = "Optional metadata tags" },
				},
				required = new[] { "content", "source" },
			},
		},
		new
		{
			name = "rag_ingest_file",
			description = "Ingest a file into RAG knowledge base",
			inputSchema = new
			{
				type = "object",
				properties = new Dictionary<string, object>
				{
					["filePath"] = new { type = "string", description = "Absolute path to file" },
					["metadata"] = new { type = "object", description = "Optional metadata tags" },
				},
				required = new[] { "filePath" },
			},
		},
		new
		{
			name = "rag_status",
			description = "Get RAG system status, health, and performance metrics",
			inputSchema = new { type = "object", properties = new Dictionary<string, object>() },
		},
		new
		{
			name = "rag_rebuild_index",
			description = "Schedule a full or partial index rebuild",
			inputSchema = new
			{
				type = "object",
				properties = new Dictionary<string, object>
				{
					["fullRebuild"] = new { type = "boolean", description = "Full rebuild (default false)" },
					["sources"] = new { type = "array", items = new { type = "string" }, description = "Specific sources to rebuild" },
				},
			},
		},
		new
		{
			name = "rag_search_similar",
			description = "Find documents similar to a given document",
			inputSchema = new
			{
				type = "object",
				properties = new Dictionary<string, object>
				{
					["documentId"] = new { type = "string", description = "Source document ID" },
					["topK"] = new { type = "integer", description = "Number of results (1-20, default 5)" },
				},
				required = new[] { "documentId" },
			},
		},
	};

	public HttpMcpTransport(RagMcpServer server, int port = 5100, string host = "127.0.0.1")
	{
		_server = server;
		_port = port;
		_host = host;
	}

	/// <summary>
	/// Starts the HTTP server and listens for MCP JSON-RPC requests.
	/// </summary>
	public async Task RunAsync(CancellationToken cancellationToken)
	{
		WebApplicationBuilder builder = WebApplication.CreateSlimBuilder();
		builder.WebHost.ConfigureKestrel(options =>
		{
			options.ListenLocalhost(_port);
		});

		WebApplication app = builder.Build();

		// MCP endpoint - handles JSON-RPC over HTTP POST
		app.MapPost(
			"/mcp",
			async (HttpContext ctx) =>
			{
				ctx.Response.ContentType = "application/json";

				try
				{
					using StreamReader reader = new(ctx.Request.Body, Encoding.UTF8);
					string body = await reader.ReadToEndAsync();

					if (string.IsNullOrWhiteSpace(body))
					{
						ctx.Response.StatusCode = 400;
						await ctx.Response.WriteAsync("{\"jsonrpc\":\"2.0\",\"error\":{\"code\":-32700,\"message\":\"Parse error: empty body\"}}");
						return;
					}

					Console.Error.WriteLine($"[RAG.McpHost] POST /mcp: {body[..Math.Min(body.Length, 200)]}");

					JsonRpcResponse? response = await HandleMessageAsync(body, ctx.RequestAborted);
					if (response != null)
					{
						string json = JsonSerializer.Serialize(response, _jsonOptions);
						await ctx.Response.WriteAsync(json);
					}
					else
					{
						ctx.Response.StatusCode = 204;
					}
				}
				catch (Exception ex)
				{
					Console.Error.WriteLine($"[RAG.McpHost] Error handling /mcp: {ex.Message}");
					ctx.Response.StatusCode = 500;
					string errorJson = JsonSerializer.Serialize(MakeError(null, -32603, ex.Message), _jsonOptions);
					await ctx.Response.WriteAsync(errorJson);
				}
			}
		);

		// Health endpoint
		app.MapGet(
			"/health",
			() =>
				Results.Ok(
					new
					{
						status = "healthy",
						transport = "http",
						port = _port,
						server = "rag-server",
						version = "1.0.0",
					}
				)
		);

		// MCP well-known endpoint for discovery
		app.MapGet(
			"/.well-known/mcp",
			() =>
				Results.Ok(
					new
					{
						transport = "streamable-http",
						endpoint = "/mcp",
						serverInfo = _serverInfo,
					}
				)
		);

		Console.Error.WriteLine($"[RAG.McpHost] HTTP transport listening on http://{_host}:{_port}/mcp");

		await app.RunAsync(cancellationToken);
	}

	private async Task<JsonRpcResponse?> HandleMessageAsync(string message, CancellationToken cancellationToken)
	{
		try
		{
			JsonDocument doc = JsonDocument.Parse(message);
			JsonElement root = doc.RootElement;

			string? method = root.TryGetProperty("method", out JsonElement m) ? m.GetString() : null;
			JsonElement? id = root.TryGetProperty("id", out JsonElement idElem) ? idElem.Clone() : null;
			JsonElement? paramsElem = root.TryGetProperty("params", out JsonElement p) ? p.Clone() : null;

			if (method == null)
				return MakeError(id, -32600, "Invalid Request: missing method");

			object? result = method switch
			{
				"initialize" => HandleInitialize(paramsElem),
				"initialized" => null,
				"tools/list" => HandleToolsList(),
				"tools/call" => await HandleToolCallAsync(paramsElem, cancellationToken),
				"ping" => new { },
				_ => throw new NotSupportedException($"Unknown method: {method}"),
			};

			if (id == null)
				return null;

			if (result == null && method == "initialized")
				return null;

			return new JsonRpcResponse
			{
				Jsonrpc = "2.0",
				Id = id,
				Result = result,
			};
		}
		catch (NotSupportedException ex)
		{
			return MakeError(null, -32601, ex.Message);
		}
		catch (Exception ex)
		{
			return MakeError(null, -32603, $"Internal error: {ex.Message}");
		}
	}

	private static object HandleInitialize(JsonElement? _)
	{
		return new
		{
			protocolVersion = "2024-11-05",
			capabilities = new { tools = new { listChanged = false } },
			serverInfo = _serverInfo,
		};
	}

	private static object HandleToolsList()
	{
		return new { tools = _toolDefinitions };
	}

	private async Task<object> HandleToolCallAsync(JsonElement? paramsElem, CancellationToken cancellationToken)
	{
		if (paramsElem == null)
			return MakeToolError("Missing params");

		JsonElement p = paramsElem.Value;
		string toolName = p.TryGetProperty("name", out JsonElement n) ? n.GetString() ?? "" : "";
		Dictionary<string, JsonElement> arguments = new();

		if (p.TryGetProperty("arguments", out JsonElement argsElem) && argsElem.ValueKind == JsonValueKind.Object)
		{
			foreach (JsonProperty prop in argsElem.EnumerateObject())
			{
				arguments[prop.Name] = prop.Value.Clone();
			}
		}

		McpToolParameters toolParams = new(arguments);

		McpToolResult toolResult = toolName switch
		{
			"rag_query" => await _server.QueryAsync(toolParams, cancellationToken),
			"rag_ingest" => await _server.IngestAsync(toolParams, cancellationToken),
			"rag_ingest_file" => await _server.IngestFileAsync(toolParams, cancellationToken),
			"rag_status" => await _server.StatusAsync(cancellationToken),
			"rag_rebuild_index" => await _server.RebuildIndexAsync(toolParams, cancellationToken),
			"rag_search_similar" => await _server.SearchSimilarAsync(toolParams, cancellationToken),
			_ => McpToolResult.Error($"Unknown tool: {toolName}"),
		};

		if (toolResult.IsSuccess)
		{
			return new { content = new[] { new { type = "text", text = JsonSerializer.Serialize(toolResult.Data, _jsonOptions) } } };
		}

		return MakeToolError(toolResult.ErrorMessage ?? "Unknown error");
	}

	private static object MakeToolError(string message)
	{
		return new { content = new[] { new { type = "text", text = message } }, isError = true };
	}

	private static JsonRpcResponse MakeError(JsonElement? id, int code, string message)
	{
		return new JsonRpcResponse
		{
			Jsonrpc = "2.0",
			Id = id,
			Error = new JsonRpcError { Code = code, Message = message },
		};
	}
}

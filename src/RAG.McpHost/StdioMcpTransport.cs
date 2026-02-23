using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using P4NTH30N.RAG;

namespace P4NTH30N.RAG.McpHost;

/// <summary>
/// MCP stdio transport: reads JSON-RPC requests from stdin, dispatches to tools, writes responses to stdout.
/// Follows MCP protocol: Content-Length header + JSON body.
/// </summary>
public sealed class StdioMcpTransport
{
	private readonly RagMcpServer _server;

	private static readonly JsonSerializerOptions _jsonOptions = new()
	{
		PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
		WriteIndented = false,
		Converters = { new JsonStringEnumConverter() },
		DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
	};

	/// <summary>
	/// MCP server info for initialize response.
	/// </summary>
	private static readonly object _serverInfo = new { name = "rag-server", version = "1.0.0" };

	/// <summary>
	/// Tool definitions exposed via MCP tools/list.
	/// </summary>
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

	public StdioMcpTransport(RagMcpServer server)
	{
		_server = server;
	}

	/// <summary>
	/// Main loop: read requests from stdin, dispatch, write responses to stdout.
	/// </summary>
	public async Task RunAsync(CancellationToken cancellationToken)
	{
		using StreamReader reader = new(Console.OpenStandardInput(), Encoding.UTF8);
		using StreamWriter writer = new(Console.OpenStandardOutput(), new UTF8Encoding(false)) { AutoFlush = true };

		while (!cancellationToken.IsCancellationRequested)
		{
			string? message = await ReadMessageAsync(reader, cancellationToken);
			if (message == null)
				break; // EOF

			JsonRpcResponse? response = await HandleMessageAsync(message, cancellationToken);
			if (response != null)
			{
				await WriteMessageAsync(writer, response);
			}
		}
	}

	/// <summary>
	/// Reads a single MCP message (Content-Length header + JSON body).
	/// </summary>
	private static async Task<string?> ReadMessageAsync(StreamReader reader, CancellationToken cancellationToken)
	{
		// Read headers until empty line
		int contentLength = -1;
		while (true)
		{
			string? headerLine = await reader.ReadLineAsync(cancellationToken);
			if (headerLine == null)
				return null; // EOF

			if (string.IsNullOrWhiteSpace(headerLine))
				break; // End of headers

			if (headerLine.StartsWith("Content-Length:", StringComparison.OrdinalIgnoreCase))
			{
				string lengthStr = headerLine["Content-Length:".Length..].Trim();
				contentLength = int.Parse(lengthStr);
			}
		}

		if (contentLength <= 0)
			return null;

		// Read body
		char[] buffer = new char[contentLength];
		int totalRead = 0;
		while (totalRead < contentLength)
		{
			int read = await reader.ReadAsync(buffer.AsMemory(totalRead, contentLength - totalRead), cancellationToken);
			if (read == 0)
				return null; // EOF
			totalRead += read;
		}

		return new string(buffer, 0, totalRead);
	}

	/// <summary>
	/// Writes a JSON-RPC response with Content-Length header.
	/// </summary>
	private static async Task WriteMessageAsync(StreamWriter writer, JsonRpcResponse response)
	{
		string json = JsonSerializer.Serialize(response, _jsonOptions);
		byte[] bytes = Encoding.UTF8.GetBytes(json);

		await writer.WriteAsync($"Content-Length: {bytes.Length}\r\n\r\n");
		await writer.WriteAsync(json);
		await writer.FlushAsync();
	}

	/// <summary>
	/// Dispatches a JSON-RPC request to the appropriate handler.
	/// </summary>
	private async Task<JsonRpcResponse?> HandleMessageAsync(string message, CancellationToken cancellationToken)
	{
		try
		{
			using JsonDocument doc = JsonDocument.Parse(message);
			JsonElement root = doc.RootElement;

			string? method = root.TryGetProperty("method", out JsonElement m) ? m.GetString() : null;
			JsonElement? id = root.TryGetProperty("id", out JsonElement idElem) ? idElem : null;
			JsonElement? paramsElem = root.TryGetProperty("params", out JsonElement p) ? p : null;

			if (method == null)
				return MakeError(id, -32600, "Invalid Request: missing method");

			object? result = method switch
			{
				"initialize" => HandleInitialize(paramsElem),
				"initialized" => null, // Notification, no response
				"tools/list" => HandleToolsList(),
				"tools/call" => await HandleToolCallAsync(paramsElem, cancellationToken),
				"ping" => new { },
				_ => throw new NotSupportedException($"Unknown method: {method}"),
			};

			// Notifications (no id) don't get responses
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

/// <summary>
/// JSON-RPC 2.0 response envelope.
/// </summary>
internal sealed class JsonRpcResponse
{
	[JsonPropertyName("jsonrpc")]
	public string Jsonrpc { get; init; } = "2.0";

	[JsonPropertyName("id")]
	public JsonElement? Id { get; init; }

	[JsonPropertyName("result")]
	public object? Result { get; init; }

	[JsonPropertyName("error")]
	public JsonRpcError? Error { get; init; }
}

/// <summary>
/// JSON-RPC 2.0 error object.
/// </summary>
internal sealed class JsonRpcError
{
	[JsonPropertyName("code")]
	public int Code { get; init; }

	[JsonPropertyName("message")]
	public string Message { get; init; } = string.Empty;
}

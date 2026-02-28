using System.Text.Json;
using System.Text.Json.Serialization;
using MongoDB.Driver;
using P4NTHE0N.RAG;

namespace P4NTHE0N.RAG.McpHost;

/// <summary>
/// Standalone MCP Host for the RAG server.
/// Runs as a self-contained executable with stdio MCP transport.
/// Supports CLI args for port, paths, and bridge URL.
/// Auto-restarts internal services on crash.
/// </summary>
public static class Program
{
	private static readonly CancellationTokenSource _cts = new();

	public static async Task<int> Main(string[] args)
	{
		HostConfig config = ParseArgs(args);

		Console.WriteLine($"[RAG.McpHost] Starting RAG MCP Server v{typeof(Program).Assembly.GetName().Version}");
		Console.WriteLine($"[RAG.McpHost] Index: {config.IndexPath}");
		Console.WriteLine($"[RAG.McpHost] MongoDB: {config.MongoUri}");
		Console.WriteLine($"[RAG.McpHost] Bridge: {config.BridgeUrl}");
		Console.WriteLine($"[RAG.McpHost] Mode: {config.Transport}");

		Console.CancelKeyPress += (_, e) =>
		{
			e.Cancel = true;
			_cts.Cancel();
			Console.WriteLine("[RAG.McpHost] Shutdown requested.");
		};

		int exitCode = 0;
		int restartCount = 0;
		int maxRestarts = config.MaxRestarts;

		while (!_cts.IsCancellationRequested && restartCount <= maxRestarts)
		{
			try
			{
				if (restartCount > 0)
				{
					Console.WriteLine($"[RAG.McpHost] Restarting (attempt {restartCount}/{maxRestarts})...");
					await Task.Delay(Math.Min(1000 * (int)Math.Pow(2, restartCount - 1), 30000), _cts.Token);
				}

				await RunServerAsync(config, _cts.Token);
				break; // Clean exit
			}
			catch (OperationCanceledException)
			{
				Console.WriteLine("[RAG.McpHost] Cancelled.");
				break;
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine($"[RAG.McpHost] Fatal error: {ex.Message}");
				restartCount++;

				if (restartCount > maxRestarts)
				{
					Console.Error.WriteLine($"[RAG.McpHost] Max restarts ({maxRestarts}) exceeded. Exiting.");
					exitCode = 1;
				}
			}
		}

		Console.WriteLine($"[RAG.McpHost] Exiting with code {exitCode}.");
		return exitCode;
	}

	private static async Task RunServerAsync(HostConfig config, CancellationToken cancellationToken)
	{
		// Initialize components
		EmbeddingService embedder = new(new EmbeddingConfig { ModelPath = config.ModelPath });
		FaissVectorStore vectorStore = new(new FaissConfig { IndexPath = config.IndexPath });
		SanitizationPipeline sanitizer = new();
		IngestionPipeline ingestion = new(embedder, vectorStore, sanitizer);
		ContextBuilder contextBuilder = new();

		// MongoDB connection (optional)
		IMongoDatabase? database = null;
		if (!string.IsNullOrEmpty(config.MongoUri))
		{
			try
			{
				MongoClient client = new(config.MongoUri);
				database = client.GetDatabase(config.DatabaseName);
				Console.WriteLine("[RAG.McpHost] MongoDB connected.");
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine($"[RAG.McpHost] MongoDB connection failed: {ex.Message}");
			}
		}

		RagService ragService = new(embedder, vectorStore, contextBuilder, database);
		HealthMonitor health = new(embedder, vectorStore, ingestion, sanitizer);
		RagMcpServer mcpServer = new(ragService, ingestion, health);

		// Load existing index
		await vectorStore.LoadAsync(cancellationToken);
		Console.WriteLine($"[RAG.McpHost] Loaded {vectorStore.VectorCount} vectors.");

		// Start Python bridge if configured
		PythonEmbeddingClient? pythonClient = null;
		if (!string.IsNullOrEmpty(config.BridgeUrl))
		{
			pythonClient = new PythonEmbeddingClient(config.BridgeUrl);
			bool bridgeHealthy = await pythonClient.IsHealthyAsync(cancellationToken);
			Console.WriteLine($"[RAG.McpHost] Python bridge: {(bridgeHealthy ? "healthy" : "unavailable")}");
		}

		// Run MCP server via selected transport
		if (config.Transport.Equals("http", StringComparison.OrdinalIgnoreCase))
		{
			HttpMcpTransport httpTransport = new(mcpServer, config.Port);
			Console.Error.WriteLine($"[RAG.McpHost] MCP server ready. Listening on http://127.0.0.1:{config.Port}/mcp");
			await httpTransport.RunAsync(cancellationToken);
		}
		else
		{
			StdioMcpTransport stdioTransport = new(mcpServer);
			Console.Error.WriteLine("[RAG.McpHost] MCP server ready. Listening on stdio.");
			await stdioTransport.RunAsync(cancellationToken);
		}

		// Cleanup
		await vectorStore.SaveAsync(CancellationToken.None);
		embedder.Dispose();
		vectorStore.Dispose();
		pythonClient?.Dispose();

		Console.WriteLine("[RAG.McpHost] Shutdown complete.");
	}

	/// <summary>
	/// Parses command-line arguments into host configuration.
	/// </summary>
	private static HostConfig ParseArgs(string[] args)
	{
		HostConfig config = new();

		for (int i = 0; i < args.Length; i++)
		{
			string arg = args[i].ToLowerInvariant();
			string? next = i + 1 < args.Length ? args[i + 1] : null;

			switch (arg)
			{
				case "--port" or "-p" when next != null:
					config.Port = int.Parse(next);
					i++;
					break;
				case "--index" or "-i" when next != null:
					config.IndexPath = next;
					i++;
					break;
				case "--model" or "-m" when next != null:
					config.ModelPath = next;
					i++;
					break;
				case "--bridge" or "-b" when next != null:
					config.BridgeUrl = next;
					i++;
					break;
				case "--mongo" when next != null:
					config.MongoUri = next;
					i++;
					break;
				case "--db" when next != null:
					config.DatabaseName = next;
					i++;
					break;
				case "--max-restarts" when next != null:
					config.MaxRestarts = int.Parse(next);
					i++;
					break;
				case "--transport" or "-t" when next != null:
					config.Transport = next;
					i++;
					break;
				case "--help" or "-h":
					PrintUsage();
					Environment.Exit(0);
					break;
			}
		}

		return config;
	}

	private static void PrintUsage()
	{
		Console.WriteLine(
			"""
			RAG.McpHost - P4NTHE0N RAG MCP Server

			Usage: RAG.McpHost [options]

			Options:
			  --port, -p <port>         HTTP port (default: 5100)
			  --index, -i <path>        FAISS index path (default: rag/faiss.index)
			  --model, -m <path>        ONNX model path (default: rag/models/all-MiniLM-L6-v2.onnx)
			  --bridge, -b <url>        Python embedding bridge URL (default: http://127.0.0.1:5000)
			  --mongo <uri>             MongoDB connection URI (default: mongodb://localhost:27017)
			  --db <name>               MongoDB database name (default: P4NTHE0N)
			  --max-restarts <n>        Max auto-restart attempts (default: 5)
			  --transport, -t <mode>    Transport mode: stdio or http (default: http)
			  --help, -h                Show this help
			"""
		);
	}
}

/// <summary>
/// Host configuration from CLI arguments and defaults.
/// </summary>
internal sealed class HostConfig
{
	public int Port { get; set; } = 5100;
	public string IndexPath { get; set; } = Path.Combine("C:", "ProgramData", "P4NTHE0N", "rag", "faiss.index");
	public string ModelPath { get; set; } = Path.Combine("C:", "ProgramData", "P4NTHE0N", "rag", "models", "all-MiniLM-L6-v2.onnx");
	public string BridgeUrl { get; set; } = "http://127.0.0.1:5000";
	public string MongoUri { get; set; } = "mongodb://localhost:27017";
	public string DatabaseName { get; set; } = "P4NTHE0N";
	public int MaxRestarts { get; set; } = 5;
	public string Transport { get; set; } = "http";
}

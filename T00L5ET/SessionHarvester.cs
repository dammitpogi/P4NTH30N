using System.Net.Http;
using System.Text;
using System.Text.Json;
using Microsoft.Data.Sqlite;

namespace P4NTH30N.T00L5ET;

/// <summary>
/// DECISION_034: Session History Harvester for RAG.
/// Extracts session history, tool outputs, and logs from OpenCode and produces
/// RAG-ingestible markdown documents.
/// </summary>
public sealed class SessionHarvester
{
	private readonly string _openCodeRoot;
	private readonly string _outputDir;
	private readonly bool _dryRun;
	private readonly DateTime? _since;
	private readonly string? _ragUrl;
	private readonly HttpClient? _httpClient;

	private int _sessionsHarvested;
	private int _toolOutputsHarvested;
	private int _logsHarvested;
	private int _ragIngested;
	private int _ragFailed;
	private int _skipped;

	public SessionHarvester(string? openCodeRoot = null, string? outputDir = null, bool dryRun = false, DateTime? since = null, string? ragUrl = null)
	{
		_openCodeRoot = openCodeRoot ?? Path.Combine(
			Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
			".local", "share", "opencode");
		_outputDir = outputDir ?? Path.Combine("C:\\P4NTH30N", "rag", "harvested");
		_dryRun = dryRun;
		_since = since;
		_ragUrl = ragUrl ?? "http://127.0.0.1:5100/mcp";
		if (!dryRun && _ragUrl != null)
			_httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(30) };
	}

	public int Run()
	{
		Console.WriteLine("╔══════════════════════════════════════════════╗");
		Console.WriteLine("║  DECISION_034: Session History Harvester     ║");
		Console.WriteLine("╚══════════════════════════════════════════════╝");
		Console.WriteLine($"  Source: {_openCodeRoot}");
		Console.WriteLine($"  Output: {_outputDir}");
		Console.WriteLine($"  Mode: {(_dryRun ? "DRY RUN" : "HARVEST")}");
		if (_since.HasValue) Console.WriteLine($"  Since: {_since.Value:yyyy-MM-dd}");
		Console.WriteLine();

		if (!Directory.Exists(_openCodeRoot))
		{
			Console.WriteLine("[ERROR] OpenCode directory not found");
			return 1;
		}

		if (!_dryRun)
			Directory.CreateDirectory(_outputDir);

		HarvestSessions();
		HarvestToolOutputs();
		HarvestLogs();

		Console.WriteLine();
		Console.WriteLine("╔══════════════════════════════════════════════╗");
		Console.WriteLine($"║  Sessions: {_sessionsHarvested}, Tools: {_toolOutputsHarvested}, Logs: {_logsHarvested}, Skipped: {_skipped}");
		Console.WriteLine($"║  RAG ingested: {_ragIngested}, RAG failed: {_ragFailed}");
		Console.WriteLine("╚══════════════════════════════════════════════╝");

		_httpClient?.Dispose();
		return 0;
	}

	private void IngestToRag(string filePath, string source, string type)
	{
		if (_httpClient == null || _ragUrl == null) return;
		try
		{
			string escaped = filePath.Replace("\\", "\\\\").Replace("\"", "\\\"");
			string body = $"{{\"jsonrpc\":\"2.0\",\"id\":{_ragIngested + _ragFailed + 1},\"method\":\"tools/call\",\"params\":{{\"name\":\"rag_ingest_file\",\"arguments\":{{\"filePath\":\"{escaped}\"}}}}}}";
			var content = new StringContent(body, Encoding.UTF8, "application/json");
			var response = _httpClient.PostAsync(_ragUrl, content).GetAwaiter().GetResult();
			if (response.IsSuccessStatusCode)
				_ragIngested++;
			else
			{
				Console.WriteLine($"  [RAG-FAIL] {Path.GetFileName(filePath)}: HTTP {(int)response.StatusCode}");
				_ragFailed++;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  [RAG-FAIL] {Path.GetFileName(filePath)}: {ex.Message}");
			_ragFailed++;
		}
	}

	private void HarvestSessions()
	{
		Console.WriteLine("=== OpenCode Sessions ===");
		string dbPath = Path.Combine(_openCodeRoot, "opencode.db");
		if (!File.Exists(dbPath))
		{
			Console.WriteLine("  [SKIP] opencode.db not found");
			return;
		}

		try
		{
			using var conn = new SqliteConnection($"Data Source={dbPath};Mode=ReadOnly");
			conn.Open();

			// Discover tables
			using var tableCmd = conn.CreateCommand();
			tableCmd.CommandText = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
			using var tableReader = tableCmd.ExecuteReader();
			List<string> tables = new();
			while (tableReader.Read())
				tables.Add(tableReader.GetString(0));

			Console.WriteLine($"  Tables: {string.Join(", ", tables)}");

			// Try to read sessions
			if (tables.Contains("sessions") || tables.Contains("session"))
			{
				string sessionTable = tables.Contains("sessions") ? "sessions" : "session";
				using var cmd = conn.CreateCommand();
				cmd.CommandText = $"SELECT COUNT(*) FROM {sessionTable}";
				long count = (long)(cmd.ExecuteScalar() ?? 0);
				Console.WriteLine($"  Sessions found: {count}");

				// Discover actual columns
				using var colCmd = conn.CreateCommand();
				colCmd.CommandText = $"PRAGMA table_info({sessionTable})";
				using var colReader = colCmd.ExecuteReader();
				List<string> actualCols = new();
				while (colReader.Read())
					actualCols.Add(colReader.GetString(1));
				Console.WriteLine($"  Session columns: {string.Join(", ", actualCols)}");

				// Find a timestamp column for ordering
				string? timeCol = actualCols.FirstOrDefault(c => c.Contains("time", StringComparison.OrdinalIgnoreCase))
					?? actualCols.FirstOrDefault(c => c.Contains("date", StringComparison.OrdinalIgnoreCase))
					?? actualCols.FirstOrDefault(c => c.Contains("created", StringComparison.OrdinalIgnoreCase))
					?? actualCols.FirstOrDefault(c => c.Contains("updated", StringComparison.OrdinalIgnoreCase));

				using var readCmd = conn.CreateCommand();
				if (timeCol != null && _since.HasValue)
					readCmd.CommandText = $"SELECT * FROM {sessionTable} WHERE {timeCol} >= @since ORDER BY {timeCol} DESC LIMIT 50";
				else if (timeCol != null)
					readCmd.CommandText = $"SELECT * FROM {sessionTable} ORDER BY {timeCol} DESC LIMIT 50";
				else
					readCmd.CommandText = $"SELECT * FROM {sessionTable} ORDER BY rowid DESC LIMIT 50";

				if (_since.HasValue && timeCol != null)
				{
					readCmd.Parameters.AddWithValue("@since", _since.Value.ToString("yyyy-MM-dd"));
				}

				try
				{
					using var reader = readCmd.ExecuteReader();
					int colCount = reader.FieldCount;
					string[] colNames = new string[colCount];
					for (int i = 0; i < colCount; i++)
						colNames[i] = reader.GetName(i);

					Console.WriteLine($"  Columns: {string.Join(", ", colNames)}");

					while (reader.Read())
					{
						string id = reader.GetValue(0)?.ToString() ?? "unknown";
						if (_dryRun)
						{
							Console.WriteLine($"  [DRY] Would harvest session {id}");
							_skipped++;
						}
						else
						{
							var sb = new StringBuilder();
							sb.AppendLine($"# OpenCode Session: {id}");
							sb.AppendLine();
							for (int i = 0; i < colCount; i++)
							{
								string val = reader.IsDBNull(i) ? "NULL" : reader.GetValue(i)?.ToString() ?? "";
								if (val.Length > 500) val = val[..500] + "...";
								sb.AppendLine($"**{colNames[i]}**: {val}");
							}

							string outPath = Path.Combine(_outputDir, "sessions", $"session_{id}.md");
							Directory.CreateDirectory(Path.GetDirectoryName(outPath)!);
							File.WriteAllText(outPath, sb.ToString());
							IngestToRag(outPath, $"opencode/session/{id}", "session-transcript");
							_sessionsHarvested++;
						}
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine($"  [WARN] Could not read sessions: {ex.Message}");
				}
			}
			else
			{
				Console.WriteLine($"  [INFO] No 'sessions' table found. Available: {string.Join(", ", tables)}");
			}

			// Try to read messages
			if (tables.Contains("messages") || tables.Contains("message"))
			{
				string msgTable = tables.Contains("messages") ? "messages" : "message";
				using var cmd = conn.CreateCommand();
				cmd.CommandText = $"SELECT COUNT(*) FROM {msgTable}";
				long count = (long)(cmd.ExecuteScalar() ?? 0);
				Console.WriteLine($"  Messages found: {count}");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  [ERROR] SQLite error: {ex.Message}");
		}
	}

	private void HarvestToolOutputs()
	{
		Console.WriteLine();
		Console.WriteLine("=== Tool Outputs ===");
		string toolDir = Path.Combine(_openCodeRoot, "tool-output");
		if (!Directory.Exists(toolDir))
		{
			Console.WriteLine("  [SKIP] tool-output directory not found");
			return;
		}

		var files = Directory.GetFiles(toolDir, "tool_*")
			.Select(f => new FileInfo(f))
			.Where(f => !_since.HasValue || f.LastWriteTimeUtc >= _since.Value)
			.OrderByDescending(f => f.LastWriteTimeUtc)
			.Take(100)
			.ToArray();

		Console.WriteLine($"  Tool output files: {files.Length}");

		foreach (var file in files)
		{
			if (_dryRun)
			{
				Console.WriteLine($"  [DRY] {file.Name} ({file.Length:N0} bytes, {file.LastWriteTimeUtc:yyyy-MM-dd})");
				_skipped++;
				continue;
			}

			try
			{
				string content = File.ReadAllText(file.FullName);
				if (content.Length > 50_000) content = content[..50_000] + "\n\n... (truncated)";

				var sb = new StringBuilder();
				sb.AppendLine($"# Tool Output: {file.Name}");
				sb.AppendLine($"**Date**: {file.LastWriteTimeUtc:yyyy-MM-dd HH:mm:ss} UTC");
				sb.AppendLine($"**Size**: {file.Length:N0} bytes");
				sb.AppendLine();
				sb.AppendLine("```");
				sb.AppendLine(content);
				sb.AppendLine("```");

				string outPath = Path.Combine(_outputDir, "tool-outputs", $"{Path.GetFileNameWithoutExtension(file.Name)}.md");
				Directory.CreateDirectory(Path.GetDirectoryName(outPath)!);
				File.WriteAllText(outPath, sb.ToString());
				IngestToRag(outPath, $"opencode/tool-output/{file.Name}", "tool-result");
				_toolOutputsHarvested++;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  [FAIL] {file.Name}: {ex.Message}");
			}
		}

		Console.WriteLine($"  Harvested: {_toolOutputsHarvested}");
	}

	private void HarvestLogs()
	{
		Console.WriteLine();
		Console.WriteLine("=== OpenCode Logs ===");
		string logDir = Path.Combine(_openCodeRoot, "log");
		if (!Directory.Exists(logDir))
		{
			Console.WriteLine("  [SKIP] log directory not found");
			return;
		}

		var files = Directory.GetFiles(logDir, "*.log")
			.Select(f => new FileInfo(f))
			.Where(f => !_since.HasValue || f.LastWriteTimeUtc >= _since.Value)
			.OrderByDescending(f => f.LastWriteTimeUtc)
			.ToArray();

		Console.WriteLine($"  Log files: {files.Length}");

		foreach (var file in files)
		{
			if (_dryRun)
			{
				Console.WriteLine($"  [DRY] {file.Name} ({file.Length:N0} bytes)");
				_skipped++;
				continue;
			}

			try
			{
				string content = File.ReadAllText(file.FullName);
				if (content.Length > 100_000) content = content[^100_000..];

				var sb = new StringBuilder();
				sb.AppendLine($"# OpenCode Log: {file.Name}");
				sb.AppendLine($"**Date**: {file.LastWriteTimeUtc:yyyy-MM-dd HH:mm:ss} UTC");
				sb.AppendLine($"**Size**: {file.Length:N0} bytes");
				sb.AppendLine();
				sb.AppendLine("```");
				sb.AppendLine(content);
				sb.AppendLine("```");

				string outPath = Path.Combine(_outputDir, "logs", $"{Path.GetFileNameWithoutExtension(file.Name)}.md");
				Directory.CreateDirectory(Path.GetDirectoryName(outPath)!);
				File.WriteAllText(outPath, sb.ToString());
				IngestToRag(outPath, $"opencode/log/{file.Name}", "runtime-log");
				_logsHarvested++;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  [FAIL] {file.Name}: {ex.Message}");
			}
		}

		Console.WriteLine($"  Harvested: {_logsHarvested}");
	}
}

using System.Collections.Concurrent;

namespace P4NTHE0N.RAG;

/// <summary>
/// Monitors C:\P4NTHE0N\docs\ (and other configured paths) for *.md, *.json changes.
/// 5-minute debounce: accumulates changes, then batch-ingests after quiet period.
/// </summary>
public sealed class FileWatcher : IDisposable
{
	private readonly IngestionPipeline _ingestion;
	private readonly FileWatcherConfig _config;
	private readonly List<FileSystemWatcher> _watchers = new();
	private readonly ConcurrentDictionary<string, DateTime> _pendingChanges = new();
	private readonly Timer _debounceTimer;
	private bool _disposed;

	// Tracking
	private long _totalDetected;
	private long _totalIngested;
	private DateTime _lastFlush;

	public long TotalDetected => _totalDetected;
	public long TotalIngested => _totalIngested;
	public DateTime LastFlush => _lastFlush;
	public int PendingCount => _pendingChanges.Count;

	public FileWatcher(IngestionPipeline ingestion, FileWatcherConfig? config = null)
	{
		_ingestion = ingestion;
		_config = config ?? new FileWatcherConfig();
		_debounceTimer = new Timer(OnDebounceElapsed, null, Timeout.Infinite, Timeout.Infinite);
	}

	/// <summary>
	/// Creates a FileWatcher from RagActivationConfig.FileWatcher options.
	/// </summary>
	public static FileWatcher? FromRagConfig(IngestionPipeline ingestion, RagActivationConfig config)
	{
		if (!config.FileWatcher.Enabled)
		{
			Console.WriteLine("[FileWatcher] Disabled in configuration");
			return null;
		}

		var fwConfig = new FileWatcherConfig
		{
			WatchPaths = config.FileWatcher.WatchPaths,
			FilePatterns = config.FileWatcher.FilePatterns,
			DebounceMinutes = config.FileWatcher.DebounceMinutes,
			ExcludeDirectories = new HashSet<string>(config.FileWatcher.ExcludeDirectories, StringComparer.OrdinalIgnoreCase),
		};
		return new FileWatcher(ingestion, fwConfig);
	}

	/// <summary>
	/// Checks if file watching is enabled in the config.
	/// </summary>
	public static bool IsEnabled()
	{
		var config = RagActivationConfig.LoadOrDefault();
		return config.FileWatcher.Enabled;
	}

	/// <summary>
	/// Starts watching all configured directories.
	/// </summary>
	public void Start()
	{
		foreach (string directory in _config.WatchPaths)
		{
			if (!Directory.Exists(directory))
			{
				Console.WriteLine($"[FileWatcher] Skipping non-existent path: {directory}");
				continue;
			}

			foreach (string pattern in _config.FilePatterns)
			{
				FileSystemWatcher watcher = new(directory, pattern)
				{
					IncludeSubdirectories = true,
					NotifyFilter = NotifyFilters.FileName | NotifyFilters.LastWrite | NotifyFilters.Size,
					EnableRaisingEvents = true,
				};

				watcher.Created += OnFileChanged;
				watcher.Changed += OnFileChanged;
				watcher.Renamed += OnFileRenamed;

				_watchers.Add(watcher);
				Console.WriteLine($"[FileWatcher] Watching {directory} for {pattern}");
			}
		}

		// Start the debounce timer to check periodically
		_debounceTimer.Change(TimeSpan.FromSeconds(30), TimeSpan.FromSeconds(30));
		Console.WriteLine($"[FileWatcher] Started with {_config.DebounceMinutes}-minute debounce.");
	}

	/// <summary>
	/// Stops watching and flushes pending changes.
	/// </summary>
	public async Task StopAsync(CancellationToken cancellationToken = default)
	{
		_debounceTimer.Change(Timeout.Infinite, Timeout.Infinite);

		foreach (FileSystemWatcher watcher in _watchers)
		{
			watcher.EnableRaisingEvents = false;
		}

		// Flush any remaining pending changes
		if (_pendingChanges.Count > 0)
		{
			await FlushPendingAsync(cancellationToken);
		}

		Console.WriteLine("[FileWatcher] Stopped.");
	}

	/// <summary>
	/// Forces an immediate flush of pending changes.
	/// </summary>
	public async Task FlushAsync(CancellationToken cancellationToken = default)
	{
		await FlushPendingAsync(cancellationToken);
	}

	private void OnFileChanged(object sender, FileSystemEventArgs e)
	{
		if (ShouldIgnore(e.FullPath))
			return;

		_pendingChanges.AddOrUpdate(e.FullPath, DateTime.UtcNow, (_, _) => DateTime.UtcNow);
		Interlocked.Increment(ref _totalDetected);
	}

	private void OnFileRenamed(object sender, RenamedEventArgs e)
	{
		if (ShouldIgnore(e.FullPath))
			return;

		// Remove old path, add new path
		_pendingChanges.TryRemove(e.OldFullPath, out _);
		_pendingChanges.AddOrUpdate(e.FullPath, DateTime.UtcNow, (_, _) => DateTime.UtcNow);
		Interlocked.Increment(ref _totalDetected);
	}

	private void OnDebounceElapsed(object? state)
	{
		if (_pendingChanges.IsEmpty)
			return;

		// Check if enough time has passed since the last change (debounce)
		DateTime now = DateTime.UtcNow;
		DateTime mostRecent = _pendingChanges.Values.Max();
		TimeSpan elapsed = now - mostRecent;

		if (elapsed >= TimeSpan.FromMinutes(_config.DebounceMinutes))
		{
			// Fire and forget the flush (timer callback can't be async)
			_ = Task.Run(async () =>
			{
				try
				{
					await FlushPendingAsync(CancellationToken.None);
				}
				catch (Exception ex)
				{
					Console.Error.WriteLine($"[FileWatcher] Flush error: {ex.Message}");
				}
			});
		}
	}

	private async Task FlushPendingAsync(CancellationToken cancellationToken)
	{
		// Snapshot and clear pending
		List<string> filesToIngest = new();
		foreach (string key in _pendingChanges.Keys.ToList())
		{
			if (_pendingChanges.TryRemove(key, out _))
			{
				if (File.Exists(key))
				{
					filesToIngest.Add(key);
				}
			}
		}

		if (filesToIngest.Count == 0)
			return;

		Console.WriteLine($"[FileWatcher] Flushing {filesToIngest.Count} changed files...");

		BatchIngestionResult result = await _ingestion.IngestBatchAsync(filesToIngest, null, 4, cancellationToken);

		Interlocked.Add(ref _totalIngested, result.Ingested);
		_lastFlush = DateTime.UtcNow;

		Console.WriteLine($"[FileWatcher] Flush complete: {result}");
	}

	private bool ShouldIgnore(string path)
	{
		// Ignore files in excluded directories
		foreach (string exclude in _config.ExcludeDirectories)
		{
			if (path.Contains(exclude, StringComparison.OrdinalIgnoreCase))
				return true;
		}

		// Ignore temp files
		if (path.EndsWith(".tmp", StringComparison.OrdinalIgnoreCase) || path.EndsWith("~", StringComparison.OrdinalIgnoreCase))
			return true;

		return false;
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_debounceTimer.Dispose();
			foreach (FileSystemWatcher watcher in _watchers)
			{
				watcher.Dispose();
			}
			_watchers.Clear();
		}
	}
}

/// <summary>
/// Configuration for the file watcher.
/// </summary>
public sealed class FileWatcherConfig
{
	/// <summary>
	/// Directories to watch for changes.
	/// </summary>
	public List<string> WatchPaths { get; init; } =
		new()
		{
			@"C:\P4NTHE0N\docs",
			@"C:\P4NTHE0N\STR4TEG15T\decisions",
			@"C:\P4NTHE0N\STR4TEG15T\speech",
			@"C:\P4NTHE0N\STR4TEG15T\canon",
			@"C:\P4NTHE0N\STR4TEG15T\intel",
			@"C:\P4NTHE0N\OP3NF1XER\deployments",
			@"C:\P4NTHE0N\OP3NF1XER\knowledge",
			@"C:\P4NTHE0N\W1NDF1XER\deployments",
			@"C:\P4NTHE0N\W1NDF1XER\knowledge",
			@"C:\P4NTHE0N\OR4CL3\consultations",
			@"C:\P4NTHE0N\DE51GN3R\consultations",
			@"C:\P4NTHE0N\DE51GN3R\decisions",
			@"C:\P4NTHE0N\T4CT1CS\intel",
			@"C:\P4NTHE0N\C0MMON",
			@"C:\P4NTHE0N\H0UND",
			@"C:\P4NTHE0N\H4ND",
			@"C:\P4NTHE0N\W4TCHD0G",
		};

	/// <summary>
	/// File patterns to watch.
	/// </summary>
	public List<string> FilePatterns { get; init; } = new() { "*.md", "*.json", "*.cs" };

	/// <summary>
	/// Debounce period in minutes. Changes accumulate until this quiet period elapses.
	/// </summary>
	public int DebounceMinutes { get; init; } = 5;

	/// <summary>
	/// Directories to exclude from watching.
	/// </summary>
	public HashSet<string> ExcludeDirectories { get; init; } = new(StringComparer.OrdinalIgnoreCase) { "bin", "obj", ".git", "node_modules", "Releases" };
}

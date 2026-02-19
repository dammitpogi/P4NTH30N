namespace P4NTH30N.RAG;

/// <summary>
/// Manages scheduled index rebuilds:
/// - 4-hour incremental rebuilds via background timer
/// - Nightly 3 AM full rebuild
/// Can also register as a Windows Scheduled Task for persistence across reboots.
/// </summary>
public sealed class ScheduledRebuilder : IDisposable
{
	private readonly IngestionPipeline _ingestion;
	private readonly FaissVectorStore _vectorStore;
	private readonly Bm25Index? _bm25;
	private readonly ScheduledRebuilderConfig _config;
	private Timer? _incrementalTimer;
	private Timer? _nightlyTimer;
	private bool _disposed;

	// Tracking
	private long _incrementalRebuilds;
	private long _fullRebuilds;
	private DateTime _lastIncrementalRebuild;
	private DateTime _lastFullRebuild;

	public long IncrementalRebuilds => _incrementalRebuilds;
	public long FullRebuilds => _fullRebuilds;
	public DateTime LastIncrementalRebuild => _lastIncrementalRebuild;
	public DateTime LastFullRebuild => _lastFullRebuild;
	public bool IsRunning { get; private set; }

	public ScheduledRebuilder(IngestionPipeline ingestion, FaissVectorStore vectorStore, Bm25Index? bm25 = null, ScheduledRebuilderConfig? config = null)
	{
		_ingestion = ingestion;
		_vectorStore = vectorStore;
		_bm25 = bm25;
		_config = config ?? new ScheduledRebuilderConfig();
	}

	/// <summary>
	/// Starts the scheduled rebuild timers.
	/// </summary>
	public void Start()
	{
		if (IsRunning)
			return;

		// 4-hour incremental timer
		TimeSpan incrementalInterval = TimeSpan.FromHours(_config.IncrementalIntervalHours);
		_incrementalTimer = new Timer(
			OnIncrementalRebuild,
			null,
			incrementalInterval, // First fire after one interval
			incrementalInterval
		);

		// Nightly full rebuild timer - calculate delay until next 3 AM
		TimeSpan delayUntilNightly = CalculateDelayUntilNextRun(_config.NightlyRebuildHour);
		_nightlyTimer = new Timer(
			OnNightlyRebuild,
			null,
			delayUntilNightly,
			TimeSpan.FromHours(24) // Then every 24 hours
		);

		IsRunning = true;
		Console.WriteLine($"[ScheduledRebuilder] Started. Incremental every {_config.IncrementalIntervalHours}h, nightly at {_config.NightlyRebuildHour}:00.");
		Console.WriteLine($"[ScheduledRebuilder] Next nightly rebuild in {delayUntilNightly.TotalHours:F1} hours.");
	}

	/// <summary>
	/// Stops the scheduled rebuild timers.
	/// </summary>
	public void Stop()
	{
		_incrementalTimer?.Change(Timeout.Infinite, Timeout.Infinite);
		_nightlyTimer?.Change(Timeout.Infinite, Timeout.Infinite);
		IsRunning = false;
		Console.WriteLine("[ScheduledRebuilder] Stopped.");
	}

	/// <summary>
	/// Manually triggers an incremental rebuild.
	/// </summary>
	public async Task RunIncrementalAsync(CancellationToken cancellationToken = default)
	{
		Console.WriteLine("[ScheduledRebuilder] Running incremental rebuild...");

		// Re-ingest from configured source directories
		int totalIngested = 0;
		foreach (string directory in _config.SourceDirectories)
		{
			if (!Directory.Exists(directory))
				continue;

			BatchIngestionResult result = await _ingestion.IngestDirectoryBatchAsync(directory, "*.*", null, _config.MaxConcurrency, cancellationToken);
			totalIngested += result.Ingested;
		}

		// Persist the index
		await _vectorStore.SaveAsync(cancellationToken);

		Interlocked.Increment(ref _incrementalRebuilds);
		_lastIncrementalRebuild = DateTime.UtcNow;

		Console.WriteLine($"[ScheduledRebuilder] Incremental rebuild complete: {totalIngested} documents re-ingested.");
	}

	/// <summary>
	/// Manually triggers a full rebuild (clears index and re-ingests everything).
	/// </summary>
	public async Task RunFullRebuildAsync(CancellationToken cancellationToken = default)
	{
		Console.WriteLine("[ScheduledRebuilder] Running FULL rebuild...");

		// Clear both indexes
		_vectorStore.Clear();
		_bm25?.Clear();

		// Re-ingest from all source directories
		int totalIngested = 0;
		int totalChunks = 0;
		foreach (string directory in _config.SourceDirectories)
		{
			if (!Directory.Exists(directory))
				continue;

			BatchIngestionResult result = await _ingestion.IngestDirectoryBatchAsync(directory, "*.*", null, _config.MaxConcurrency, cancellationToken);
			totalIngested += result.Ingested;
			totalChunks += result.TotalChunks;
		}

		// Persist the rebuilt index
		await _vectorStore.SaveAsync(cancellationToken);

		Interlocked.Increment(ref _fullRebuilds);
		_lastFullRebuild = DateTime.UtcNow;

		Console.WriteLine($"[ScheduledRebuilder] Full rebuild complete: {totalIngested} docs, {totalChunks} chunks.");
	}

	/// <summary>
	/// Generates a PowerShell script to register this as a Windows Scheduled Task.
	/// </summary>
	public static string GenerateScheduledTaskScript(string exePath)
	{
		return $"""
			# Register RAG rebuild as Windows Scheduled Tasks
			$exePath = "{exePath}"

			# 4-hour incremental rebuild
			$incrementalAction = New-ScheduledTaskAction -Execute $exePath -Argument "--rebuild incremental"
			$incrementalTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 4)
			Register-ScheduledTask -TaskName "P4NTH30N-RAG-Incremental" -Action $incrementalAction -Trigger $incrementalTrigger -Description "P4NTH30N RAG incremental index rebuild every 4 hours" -RunLevel Highest

			# Nightly 3 AM full rebuild
			$nightlyAction = New-ScheduledTaskAction -Execute $exePath -Argument "--rebuild full"
			$nightlyTrigger = New-ScheduledTaskTrigger -Daily -At "3:00 AM"
			Register-ScheduledTask -TaskName "P4NTH30N-RAG-Nightly" -Action $nightlyAction -Trigger $nightlyTrigger -Description "P4NTH30N RAG full index rebuild at 3 AM" -RunLevel Highest

			Write-Host "Scheduled tasks registered successfully."
			""";
	}

	private void OnIncrementalRebuild(object? state)
	{
		_ = Task.Run(async () =>
		{
			try
			{
				await RunIncrementalAsync(CancellationToken.None);
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine($"[ScheduledRebuilder] Incremental rebuild error: {ex.Message}");
			}
		});
	}

	private void OnNightlyRebuild(object? state)
	{
		_ = Task.Run(async () =>
		{
			try
			{
				await RunFullRebuildAsync(CancellationToken.None);
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine($"[ScheduledRebuilder] Nightly rebuild error: {ex.Message}");
			}
		});
	}

	/// <summary>
	/// Calculates delay until the next occurrence of the specified hour (local time).
	/// </summary>
	private static TimeSpan CalculateDelayUntilNextRun(int targetHour)
	{
		DateTime now = DateTime.Now;
		DateTime nextRun = now.Date.AddHours(targetHour);

		if (nextRun <= now)
		{
			nextRun = nextRun.AddDays(1);
		}

		return nextRun - now;
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_incrementalTimer?.Dispose();
			_nightlyTimer?.Dispose();
		}
	}
}

/// <summary>
/// Configuration for scheduled rebuilds.
/// </summary>
public sealed class ScheduledRebuilderConfig
{
	/// <summary>
	/// Hours between incremental rebuilds.
	/// </summary>
	public int IncrementalIntervalHours { get; init; } = 4;

	/// <summary>
	/// Hour of day (0-23) for nightly full rebuild. Default: 3 AM.
	/// </summary>
	public int NightlyRebuildHour { get; init; } = 3;

	/// <summary>
	/// Source directories to re-ingest during rebuilds.
	/// </summary>
	public List<string> SourceDirectories { get; init; } =
		new() { @"C:\P4NTH30N\docs", @"C:\P4NTH30N\C0MMON", @"C:\P4NTH30N\H0UND", @"C:\P4NTH30N\H4ND", @"C:\P4NTH30N\T4CT1CS\intel" };

	/// <summary>
	/// Max concurrency for batch ingestion during rebuilds.
	/// </summary>
	public int MaxConcurrency { get; init; } = 4;
}

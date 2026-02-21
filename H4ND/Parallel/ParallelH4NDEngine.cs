using System.Threading.Channels;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// ARCH-047/055: Main orchestrator for parallel H4ND execution.
/// Creates the bounded channel, starts the SignalDistributor (producer),
/// and the WorkerPool (consumers). Manages lifecycle and metrics logging.
/// ARCH-055: Accepts SessionRenewalService + GameSelectorConfig for self-healing workers.
/// </summary>
public sealed class ParallelH4NDEngine : IDisposable
{
	private readonly IUnitOfWork _uow;
	private readonly CdpConfig _cdpConfig;
	private readonly ParallelConfig _config;
	private readonly ParallelMetrics _metrics;
	private readonly SpinMetrics _spinMetrics;
	private readonly SessionRenewalService? _sessionRenewal;
	private readonly GameSelectorConfig? _selectorConfig;
	private readonly ICdpLifecycleManager? _cdpLifecycle;
	private CancellationTokenSource? _cts;
	private Task? _distributorTask;
	private WorkerPool? _workerPool;
	private bool _disposed;

	public ParallelMetrics Metrics => _metrics;
	public bool IsRunning => _distributorTask != null && !_distributorTask.IsCompleted;

	/// <summary>
	/// ARCH-055: Extended constructor with self-healing dependencies.
	/// Backward compatible: sessionRenewal and selectorConfig are optional.
	/// </summary>
	public ParallelH4NDEngine(
		IUnitOfWork uow,
		CdpConfig cdpConfig,
		ParallelConfig config,
		SessionRenewalService? sessionRenewal = null,
		GameSelectorConfig? selectorConfig = null,
		ICdpLifecycleManager? cdpLifecycle = null)
	{
		_uow = uow;
		_cdpConfig = cdpConfig;
		_config = config;
		_sessionRenewal = sessionRenewal;
		_selectorConfig = selectorConfig;
		_cdpLifecycle = cdpLifecycle;
		_metrics = new ParallelMetrics();
		_spinMetrics = new SpinMetrics();
	}

	/// <summary>
	/// Starts the parallel engine: distributor + worker pool + metrics logger.
	/// Blocks until cancellation or fatal error.
	/// </summary>
	public async Task RunAsync(CancellationToken ct)
	{
		_cts = CancellationTokenSource.CreateLinkedTokenSource(ct);

		Console.WriteLine($"[ParallelEngine] Starting with {_config.WorkerCount} workers, channel capacity {_config.ChannelCapacity}");

		// AUTO-056: Ensure Chrome CDP is available before starting workers
		if (_cdpLifecycle != null)
		{
			Console.WriteLine("[ParallelEngine] Ensuring CDP availability...");
			if (!await _cdpLifecycle.EnsureAvailableAsync(ct))
			{
				Console.WriteLine("[ParallelEngine] CDP unavailable — cannot start parallel engine");
				return;
			}
		}

		// Create bounded channel with backpressure
		var channel = Channel.CreateBounded<SignalWorkItem>(new BoundedChannelOptions(_config.ChannelCapacity)
		{
			FullMode = BoundedChannelFullMode.Wait,
			SingleReader = false,
			SingleWriter = true,
		});

		// Create spin execution (shared across workers via thread-safe UoW)
		var spinExecution = new SpinExecution(_uow, _spinMetrics);

		// Start distributor (producer)
		var distributor = new SignalDistributor(
			_uow.Signals,
			_uow.Credentials,
			channel.Writer,
			_metrics,
			distributorId: $"{Environment.MachineName}-dist",
			pollInterval: TimeSpan.FromSeconds(_config.PollIntervalSeconds));

		_distributorTask = Task.Run(() => distributor.RunAsync(_cts.Token), _cts.Token);

		// Start worker pool (consumers) — ARCH-055: inject self-healing deps
		_workerPool = new WorkerPool(
			_config.WorkerCount,
			channel.Reader,
			_uow,
			spinExecution,
			_cdpConfig,
			_metrics,
			_sessionRenewal,
			_selectorConfig,
			_config.MaxSignalsPerWorker);

		await _workerPool.StartAsync(_cts.Token);

		// Start metrics logger
		var metricsTask = Task.Run(() => LogMetricsPeriodicallyAsync(_cts.Token), _cts.Token);

		Console.WriteLine("[ParallelEngine] All components started — running");

		try
		{
			// Wait for distributor to complete (channel drains) or cancellation
			await Task.WhenAll(_distributorTask, _workerPool.WaitForCompletionAsync());
		}
		catch (OperationCanceledException)
		{
			Console.WriteLine("[ParallelEngine] Shutdown requested");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[ParallelEngine] Fatal error: {ex.Message}");
		}
		finally
		{
			_workerPool.Stop();
			Console.WriteLine($"[ParallelEngine] Stopped. Final metrics:");
			Console.WriteLine(_metrics.GetSummary());
		}
	}

	/// <summary>
	/// Stops the engine gracefully.
	/// </summary>
	public void Stop()
	{
		_cts?.Cancel();
		_workerPool?.Stop();
	}

	private async Task LogMetricsPeriodicallyAsync(CancellationToken ct)
	{
		while (!ct.IsCancellationRequested)
		{
			try
			{
				await Task.Delay(TimeSpan.FromMinutes(1), ct);
				Console.WriteLine(_metrics.GetSummary());

				// Check for degraded state
				if (_metrics.SpinsAttempted > 10 && _metrics.SuccessRate < 50)
				{
					Console.WriteLine("[ParallelEngine] WARNING: Success rate below 50% — consider fallback to sequential mode");
				}
			}
			catch (OperationCanceledException)
			{
				break;
			}
		}
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;
		_cts?.Cancel();
		_workerPool?.Dispose();
		_cts?.Dispose();
	}
}

/// <summary>
/// ARCH-047: Configuration for parallel execution.
/// Bound from appsettings.json P4NTH30N:H4ND:Parallel section.
/// </summary>
public sealed class ParallelConfig
{
	public int WorkerCount { get; set; } = 5;
	public int ChannelCapacity { get; set; } = 10;
	public int MaxSignalsPerWorker { get; set; } = 100;
	public double PollIntervalSeconds { get; set; } = 1.0;
	public bool ShadowMode { get; set; } = false;
}

using System.Threading.Channels;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H4ND.Navigation;
using P4NTHE0N.H4ND.Navigation.Retry;
using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.H4ND.Parallel;

/// <summary>
/// ARCH-047/055: Orchestrates N ParallelSpinWorkers consuming from a shared channel.
/// Manages worker lifecycle, automatic restart on failure, and graceful shutdown.
/// ARCH-055: Injects SessionRenewalService + GameSelectorConfig into workers for self-healing.
/// </summary>
public sealed class WorkerPool : IDisposable
{
	private readonly int _workerCount;
	private readonly ChannelReader<SignalWorkItem> _reader;
	private readonly IUnitOfWork _uow;
	private readonly SpinExecution _spinExecution;
	private readonly CdpConfig _cdpConfig;
	private readonly ParallelMetrics _metrics;
	private readonly SessionRenewalService? _sessionRenewal;
	private readonly GameSelectorConfig? _selectorConfig;
	private readonly int _maxSignalsPerWorker;
	private readonly CdpResourceCoordinator _resourceCoordinator;
	private readonly bool _ownsResourceCoordinator;
	private readonly IErrorEvidence _errors;
	private readonly ChromeProfileManager? _profileManager;
	private readonly NavigationMapLoader? _mapLoader;
	private readonly IStepExecutor? _stepExecutor;
	private readonly List<Task> _workerTasks = [];
	private readonly List<ParallelSpinWorker> _workers = [];
	private CancellationTokenSource? _cts;
	private bool _disposed;

	public int WorkerCount => _workerCount;
	public int ActiveWorkers => _workerTasks.Count(t => !t.IsCompleted);
	public IReadOnlyList<ParallelSpinWorker> Workers => _workers;

	public WorkerPool(
		int workerCount,
		ChannelReader<SignalWorkItem> reader,
		IUnitOfWork uow,
		SpinExecution spinExecution,
		CdpConfig cdpConfig,
		ParallelMetrics metrics,
		SessionRenewalService? sessionRenewal = null,
		GameSelectorConfig? selectorConfig = null,
		IErrorEvidence? errors = null,
		int maxSignalsPerWorker = 100,
		CdpResourceCoordinator? resourceCoordinator = null,
		ChromeProfileManager? profileManager = null,
		NavigationMapLoader? mapLoader = null,
		IStepExecutor? stepExecutor = null)
	{
		_workerCount = Math.Max(1, workerCount);
		_reader = reader;
		_uow = uow;
		_spinExecution = spinExecution;
		_cdpConfig = cdpConfig;
		_metrics = metrics;
		_sessionRenewal = sessionRenewal;
		_selectorConfig = selectorConfig;
		_errors = errors ?? NoopErrorEvidence.Instance;
		_maxSignalsPerWorker = maxSignalsPerWorker;
		if (resourceCoordinator == null)
		{
			_resourceCoordinator = new CdpResourceCoordinator(1);
			_ownsResourceCoordinator = true;
		}
		else
		{
			_resourceCoordinator = resourceCoordinator;
			_ownsResourceCoordinator = false;
		}
		_profileManager = profileManager;
		_mapLoader = mapLoader;
		_stepExecutor = stepExecutor;
	}

	/// <summary>
	/// Starts all workers. Each worker runs in its own task.
	/// Workers that crash are automatically restarted with a delay.
	/// ARCH-055: Workers now receive SessionRenewalService + GameSelectorConfig.
	/// </summary>
	public Task StartAsync(CancellationToken ct)
	{
		_cts = CancellationTokenSource.CreateLinkedTokenSource(ct);

		for (int i = 0; i < _workerCount; i++)
		{
			var worker = new ParallelSpinWorker(
				workerId: $"W{i:D2}",
				reader: _reader,
				uow: _uow,
				spinExecution: _spinExecution,
				cdpConfig: _cdpConfig,
				metrics: _metrics,
				sessionRenewal: _sessionRenewal,
				selectorConfig: _selectorConfig,
				errors: _errors,
				maxSignalsBeforeRestart: _maxSignalsPerWorker,
				resourceCoordinator: _resourceCoordinator,
				profileManager: _profileManager,
				mapLoader: _mapLoader,
				stepExecutor: _stepExecutor);

			_workers.Add(worker);
			_workerTasks.Add(RunWorkerWithRestartAsync(worker, _cts.Token));
		}

		Console.WriteLine($"[WorkerPool] Started {_workerCount} workers (self-healing={_sessionRenewal != null}, selectors={_selectorConfig != null}, recorder-map={_mapLoader != null && _stepExecutor != null})");
		return Task.CompletedTask;
	}

	/// <summary>
	/// Waits for all workers to complete (channel drained or cancellation).
	/// </summary>
	public async Task WaitForCompletionAsync()
	{
		if (_workerTasks.Count > 0)
		{
			await Task.WhenAll(_workerTasks);
		}
	}

	/// <summary>
	/// ARCH-055-008: Stops all workers gracefully and sweeps locked credentials.
	/// Ensures no stranded locked credentials after shutdown.
	/// </summary>
	public void Stop()
	{
		_cts?.Cancel();
		Console.WriteLine("[WorkerPool] Stop requested — sweeping locked credentials...");

		// ARCH-055-008: Credential unlock sweep
		try
		{
			int unlocked = 0;
			var allCreds = _uow.Credentials.GetAll();
			foreach (var cred in allCreds.Where(c => !c.Unlocked))
			{
				_uow.Credentials.Unlock(cred);
				unlocked++;
			}

			if (unlocked > 0)
			{
				Console.WriteLine($"[WorkerPool] Credential unlock sweep: released {unlocked} locked credentials");
			}

			// Release all claimed but unacknowledged signals
			int released = 0;
			var allSignals = _uow.Signals.GetAll();
			foreach (var signal in allSignals.Where(s => s.ClaimedBy != null && !s.Acknowledged))
			{
				_uow.Signals.ReleaseClaim(signal);
				released++;
			}

			if (released > 0)
			{
				Console.WriteLine($"[WorkerPool] Signal claim sweep: released {released} claimed signals");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[WorkerPool] Credential/signal sweep error (non-fatal): {ex.Message}");
		}

		Console.WriteLine("[WorkerPool] Graceful shutdown complete");
	}

	private async Task RunWorkerWithRestartAsync(ParallelSpinWorker worker, CancellationToken ct)
	{
		int restartCount = 0;
		const int maxRestarts = 10;

		while (!ct.IsCancellationRequested && restartCount < maxRestarts)
		{
			try
			{
				await worker.RunAsync(ct);
				break; // Normal exit (channel completed)
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				restartCount++;
				Console.WriteLine($"[WorkerPool] Worker {worker.WorkerId} crashed (restart {restartCount}/{maxRestarts}): {ex.Message}");
				_metrics.RecordWorkerRestart(worker.WorkerId);

				if (restartCount < maxRestarts)
				{
					int delaySeconds = Math.Min(30, (int)Math.Pow(2, restartCount));
					await Task.Delay(TimeSpan.FromSeconds(delaySeconds), ct);
				}
			}
		}

		if (restartCount >= maxRestarts)
		{
			Console.WriteLine($"[WorkerPool] Worker {worker.WorkerId} exceeded max restarts — permanently stopped");
		}
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;
		_cts?.Cancel();
		_cts?.Dispose();
		if (_ownsResourceCoordinator)
		{
			_resourceCoordinator.Dispose();
		}
	}
}

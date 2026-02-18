using System.Diagnostics;
using P4NTH30N.W4TCHD0G.Input;
using P4NTH30N.W4TCHD0G.Models;
using P4NTH30N.W4TCHD0G.Stream;
using P4NTH30N.W4TCHD0G.Vision;

namespace P4NTH30N.W4TCHD0G.Agent;

/// <summary>
/// FourEyes vision-based automation agent. Orchestrates the full pipeline:
/// RTMP Stream → Vision Processing → Signal Matching → Decision Engine → Synergy Actions.
/// </summary>
/// <remarks>
/// ARCHITECTURE:
/// VM OBS (RTMP) → RTMPStreamReceiver → FrameBuffer → VisionProcessor
///                                                        ↓
/// MongoDB SIGN4L ←──────────────────── DecisionEngine ←──┘
///                                          ↓
///                                     SynergyClient → VM Input
///
/// LOOP CYCLE (target: 2-5 FPS analysis):
/// 1. Get latest frame from FrameBuffer
/// 2. Run vision processing (OCR + button detection + state classification)
/// 3. Query pending signals from MongoDB
/// 4. Decision engine evaluates analysis + signals
/// 5. If action needed, queue and execute via Synergy
/// 6. Log cycle results
/// </remarks>
public sealed class FourEyesAgent : IFourEyesAgent
{
	/// <summary>
	/// RTMP stream receiver for VM video ingestion.
	/// </summary>
	private readonly IStreamReceiver _streamReceiver;

	/// <summary>
	/// Vision processing pipeline.
	/// </summary>
	private readonly IVisionProcessor _visionProcessor;

	/// <summary>
	/// Decision engine for translating vision + signals into actions.
	/// </summary>
	private readonly DecisionEngine _decisionEngine;

	/// <summary>
	/// Synergy client for sending input to the VM.
	/// </summary>
	private readonly ISynergyClient _synergyClient;

	/// <summary>
	/// Stream health monitor.
	/// </summary>
	private readonly StreamHealthMonitor _healthMonitor;

	/// <summary>
	/// Signal polling function — injected to avoid coupling to MongoDB directly.
	/// Returns true if there's a pending signal requiring action.
	/// </summary>
	private readonly Func<Task<bool>> _checkForSignal;

	/// <summary>
	/// Balance polling function — injected for safety limit checks.
	/// Returns current account balance.
	/// </summary>
	private readonly Func<Task<decimal>> _getBalance;

	/// <summary>
	/// Target analysis cycles per second.
	/// </summary>
	private readonly int _targetFps;

	/// <summary>
	/// Cancellation source for the agent loop.
	/// </summary>
	private CancellationTokenSource? _cts;

	/// <summary>
	/// Main agent loop task.
	/// </summary>
	private Task? _loopTask;

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <summary>
	/// Total cycles executed.
	/// </summary>
	private long _totalCycles;

	/// <summary>
	/// Total actions executed across all cycles.
	/// </summary>
	private long _totalActions;

	/// <inheritdoc />
	public bool IsRunning => Status == AgentStatus.Running;

	/// <inheritdoc />
	public AgentStatus Status { get; private set; } = AgentStatus.Stopped;

	/// <inheritdoc />
	public event Action<CycleResult>? OnCycleComplete;

	/// <summary>
	/// Total cycles executed since start.
	/// </summary>
	public long TotalCycles => Interlocked.Read(ref _totalCycles);

	/// <summary>
	/// Total actions executed since start.
	/// </summary>
	public long TotalActions => Interlocked.Read(ref _totalActions);

	/// <summary>
	/// Creates a FourEyesAgent with all required dependencies.
	/// </summary>
	/// <param name="streamReceiver">RTMP stream receiver (FOUR-005).</param>
	/// <param name="visionProcessor">Vision processing pipeline (FOUR-006).</param>
	/// <param name="decisionEngine">Decision engine for action planning.</param>
	/// <param name="synergyClient">Synergy client for VM input (FOUR-004).</param>
	/// <param name="checkForSignal">Async function to check for pending signals.</param>
	/// <param name="getBalance">Async function to get current balance.</param>
	/// <param name="targetFps">Analysis cycles per second. Default: 3.</param>
	public FourEyesAgent(
		IStreamReceiver streamReceiver,
		IVisionProcessor visionProcessor,
		DecisionEngine decisionEngine,
		ISynergyClient synergyClient,
		Func<Task<bool>> checkForSignal,
		Func<Task<decimal>> getBalance,
		int targetFps = 3)
	{
		_streamReceiver = streamReceiver ?? throw new ArgumentNullException(nameof(streamReceiver));
		_visionProcessor = visionProcessor ?? throw new ArgumentNullException(nameof(visionProcessor));
		_decisionEngine = decisionEngine ?? throw new ArgumentNullException(nameof(decisionEngine));
		_synergyClient = synergyClient ?? throw new ArgumentNullException(nameof(synergyClient));
		_checkForSignal = checkForSignal ?? throw new ArgumentNullException(nameof(checkForSignal));
		_getBalance = getBalance ?? throw new ArgumentNullException(nameof(getBalance));
		_targetFps = Math.Clamp(targetFps, 1, 10);

		_healthMonitor = new StreamHealthMonitor(_streamReceiver);
	}

	/// <inheritdoc />
	public async Task StartAsync(CancellationToken cancellationToken = default)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (IsRunning)
		{
			Console.WriteLine("[FourEyes] Already running.");
			return;
		}

		Status = AgentStatus.Initializing;
		_cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);

		try
		{
			Console.WriteLine("[FourEyes] Initializing subsystems...");

			// Verify stream is receiving
			if (!_streamReceiver.IsReceiving)
			{
				Console.WriteLine("[FourEyes] WARNING: Stream receiver not active. Start RTMP stream first.");
			}

			// Verify Synergy is connected
			if (!_synergyClient.IsConnected)
			{
				Console.WriteLine("[FourEyes] WARNING: Synergy client not connected. Actions will fail.");
			}

			// Start health monitoring
			_healthMonitor.Start();

			// Start the main agent loop
			Status = AgentStatus.Running;
			_loopTask = Task.Run(() => AgentLoopAsync(_cts.Token), _cts.Token);

			Console.WriteLine($"[FourEyes] Agent started at {_targetFps} FPS analysis rate.");
		}
		catch (Exception ex)
		{
			Status = AgentStatus.Error;
			Console.WriteLine($"[FourEyes] Initialization failed: {ex.Message}");
			throw;
		}
	}

	/// <inheritdoc />
	public async Task StopAsync()
	{
		if (_cts is not null)
		{
			await _cts.CancelAsync();
		}

		_healthMonitor.Stop();

		if (_loopTask is not null)
		{
			try { await _loopTask; } catch (OperationCanceledException) { }
		}

		Status = AgentStatus.Stopped;
		Console.WriteLine($"[FourEyes] Stopped. Cycles: {TotalCycles}, Actions: {TotalActions}");
	}

	/// <summary>
	/// Main agent loop: analyze → decide → act → repeat.
	/// </summary>
	private async Task AgentLoopAsync(CancellationToken token)
	{
		int cycleIntervalMs = 1000 / _targetFps;

		while (!token.IsCancellationRequested)
		{
			Stopwatch cycleSw = Stopwatch.StartNew();
			CycleResult result;

			try
			{
				result = await ExecuteCycleAsync(token);
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				result = new CycleResult
				{
					FrameAvailable = false,
					Error = ex.Message,
					CycleDurationMs = cycleSw.ElapsedMilliseconds,
				};

				Console.WriteLine($"[FourEyes] Cycle error: {ex.Message}");
			}

			Interlocked.Increment(ref _totalCycles);
			OnCycleComplete?.Invoke(result);

			// Check if decision engine paused us
			if (_decisionEngine.IsLossLimitReached)
			{
				Status = AgentStatus.Paused;
				Console.WriteLine("[FourEyes] PAUSED: Daily loss limit reached.");
				break;
			}

			// Wait for next cycle slot, accounting for processing time
			cycleSw.Stop();
			int remainingMs = cycleIntervalMs - (int)cycleSw.ElapsedMilliseconds;
			if (remainingMs > 0)
			{
				await Task.Delay(remainingMs, token);
			}
		}
	}

	/// <summary>
	/// Executes a single analysis-decision-action cycle.
	/// </summary>
	private async Task<CycleResult> ExecuteCycleAsync(CancellationToken token)
	{
		Stopwatch sw = Stopwatch.StartNew();

		// Step 1: Get latest frame
		VisionFrame? frame = _streamReceiver.GetLatestFrame();
		if (frame is null)
		{
			return new CycleResult
			{
				FrameAvailable = false,
				Decision = "No frame available",
				CycleDurationMs = sw.ElapsedMilliseconds,
			};
		}

		// Step 2: Run vision processing
		VisionAnalysis analysis = await _visionProcessor.ProcessFrameAsync(frame);

		// Step 3: Check for pending signals
		bool hasSignal = false;
		try
		{
			hasSignal = await _checkForSignal();
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[FourEyes] Signal check failed: {ex.Message}");
		}

		// Step 4: Get current balance
		decimal balance = 0;
		try
		{
			balance = await _getBalance();
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[FourEyes] Balance check failed: {ex.Message}");
		}

		// Step 5: Decision engine evaluates
		DecisionResult decision = _decisionEngine.Evaluate(analysis, hasSignal, balance);

		// Step 6: Execute actions if needed
		int actionsExecuted = 0;
		if (decision.Type == DecisionType.Act && decision.Actions.Count > 0)
		{
			foreach (InputAction action in decision.Actions)
			{
				_synergyClient.QueueAction(action);
			}

			actionsExecuted = await _synergyClient.ExecuteQueueAsync(token);
			Interlocked.Add(ref _totalActions, actionsExecuted);
		}

		sw.Stop();

		return new CycleResult
		{
			FrameAvailable = true,
			Analysis = analysis,
			Decision = $"{decision.Type}: {decision.Reason}",
			ActionsExecuted = actionsExecuted,
			CycleDurationMs = sw.ElapsedMilliseconds,
		};
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_cts?.Cancel();
			_cts?.Dispose();
			_healthMonitor.Dispose();
		}
	}
}

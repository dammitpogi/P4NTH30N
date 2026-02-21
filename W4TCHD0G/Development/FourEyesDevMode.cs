using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.W4TCHD0G.Agent;
using P4NTH30N.W4TCHD0G.Models;
using P4NTH30N.W4TCHD0G.Stream;
using P4NTH30N.W4TCHD0G.Vision;

namespace P4NTH30N.W4TCHD0G.Development;

/// <summary>
/// FEAT-036: Development mode wrapper for FourEyes.
/// Adds safety gates, confirmation requirements, training data capture,
/// and developer dashboard observation on top of the production agent.
/// </summary>
public sealed class FourEyesDevMode : IDisposable
{
	private readonly IFourEyesAgent _agent;
	private readonly IVisionProcessor _visionProcessor;
	private readonly IStreamReceiver _streamReceiver;
	private readonly ConfirmationGate _confirmationGate;
	private readonly DeveloperDashboard _dashboard;
	private readonly TrainingDataCapture? _trainingCapture;
	private CancellationTokenSource? _cts;
	private bool _disposed;

	/// <summary>
	/// Whether dev mode is currently active.
	/// </summary>
	public bool IsActive { get; private set; }

	/// <summary>
	/// The underlying agent.
	/// </summary>
	public IFourEyesAgent Agent => _agent;

	/// <summary>
	/// The confirmation gate for spin approval.
	/// </summary>
	public ConfirmationGate Gate => _confirmationGate;

	/// <summary>
	/// The developer dashboard.
	/// </summary>
	public DeveloperDashboard Dashboard => _dashboard;

	/// <summary>
	/// Creates a FourEyes development mode wrapper.
	/// </summary>
	/// <param name="agent">The FourEyes agent to wrap.</param>
	/// <param name="visionProcessor">Vision processor for frame analysis.</param>
	/// <param name="streamReceiver">Stream receiver for frame capture.</param>
	/// <param name="autoApproveSpins">If true, auto-approves spins (for automated testing).</param>
	/// <param name="trainingOutputDir">Directory for training data capture (null to disable).</param>
	public FourEyesDevMode(
		IFourEyesAgent agent,
		IVisionProcessor visionProcessor,
		IStreamReceiver streamReceiver,
		bool autoApproveSpins = false,
		string? trainingOutputDir = null
	)
	{
		_agent = agent ?? throw new ArgumentNullException(nameof(agent));
		_visionProcessor = visionProcessor ?? throw new ArgumentNullException(nameof(visionProcessor));
		_streamReceiver = streamReceiver ?? throw new ArgumentNullException(nameof(streamReceiver));
		_confirmationGate = new ConfirmationGate(autoApproveSpins);
		_dashboard = new DeveloperDashboard();

		if (trainingOutputDir != null)
			_trainingCapture = new TrainingDataCapture(trainingOutputDir);

		// Wire up cycle observation
		_agent.OnCycleComplete += OnCycleComplete;
	}

	/// <summary>
	/// Starts development mode: activates dashboard, hooks agent events, begins observation.
	/// </summary>
	public async Task StartAsync(CancellationToken ct = default)
	{
		if (IsActive) return;

		_cts = CancellationTokenSource.CreateLinkedTokenSource(ct);
		IsActive = true;

		_dashboard.Start();

		Console.WriteLine("[FourEyesDevMode] ═══════════════════════════════════════");
		Console.WriteLine("[FourEyesDevMode] DEVELOPMENT MODE ACTIVE");
		Console.WriteLine("[FourEyesDevMode] All spins require confirmation gate approval");
		Console.WriteLine("[FourEyesDevMode] Training data capture: " + (_trainingCapture != null ? "ENABLED" : "DISABLED"));
		Console.WriteLine("[FourEyesDevMode] ═══════════════════════════════════════");

		// Start the underlying agent
		await _agent.StartAsync(_cts.Token);
	}

	/// <summary>
	/// Stops development mode and the underlying agent.
	/// </summary>
	public async Task StopAsync()
	{
		if (!IsActive) return;

		IsActive = false;
		_dashboard.Stop();

		if (_cts != null)
			await _cts.CancelAsync();

		await _agent.StopAsync();

		// Print final summary
		_dashboard.RenderSummary();
		Console.WriteLine($"[FourEyesDevMode] Gate stats — Requested: {_confirmationGate.TotalRequested}, "
			+ $"Approved: {_confirmationGate.TotalApproved}, "
			+ $"Rejected: {_confirmationGate.TotalRejected}, "
			+ $"TimedOut: {_confirmationGate.TotalTimedOut}");

		if (_trainingCapture != null)
			Console.WriteLine($"[FourEyesDevMode] Training frames captured: {_trainingCapture.FrameCount}");
	}

	/// <summary>
	/// Handles each cycle from the agent for dashboard + training capture.
	/// </summary>
	private void OnCycleComplete(CycleResult result)
	{
		_dashboard.RecordCycle(result);

		// Capture training data if enabled and a frame was processed
		if (_trainingCapture != null && result.FrameAvailable && result.Analysis != null)
		{
			VisionFrame? frame = _streamReceiver.GetLatestFrame();
			if (frame != null)
			{
				// Fire-and-forget capture (don't block the cycle loop)
				_ = _trainingCapture.CaptureAsync(frame, result.Analysis);
			}
		}
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_agent.OnCycleComplete -= OnCycleComplete;
			_cts?.Cancel();
			_cts?.Dispose();
			_agent.Dispose();
		}
	}
}

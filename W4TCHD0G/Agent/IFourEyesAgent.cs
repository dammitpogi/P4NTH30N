using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Agent;

/// <summary>
/// Contract for the FourEyes vision-based automation agent.
/// Orchestrates the full pipeline: RTMP → Vision → Signals → Decisions → Actions.
/// </summary>
public interface IFourEyesAgent : IDisposable
{
	/// <summary>
	/// Starts the FourEyes automation loop.
	/// </summary>
	/// <param name="cancellationToken">Token to stop the agent.</param>
	Task StartAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Stops the agent and releases all resources.
	/// </summary>
	Task StopAsync();

	/// <summary>
	/// Whether the agent is currently running.
	/// </summary>
	bool IsRunning { get; }

	/// <summary>
	/// Current agent status for monitoring.
	/// </summary>
	AgentStatus Status { get; }

	/// <summary>
	/// Event raised after each analysis-decision-action cycle.
	/// </summary>
	event Action<CycleResult>? OnCycleComplete;
}

/// <summary>
/// FourEyes agent operational status.
/// </summary>
public enum AgentStatus
{
	/// <summary>Agent is not started.</summary>
	Stopped,

	/// <summary>Agent is initializing subsystems.</summary>
	Initializing,

	/// <summary>Agent is running the automation loop.</summary>
	Running,

	/// <summary>Agent is paused (e.g., loss limit reached).</summary>
	Paused,

	/// <summary>Agent encountered a fatal error.</summary>
	Error,
}

/// <summary>
/// Result of a single analysis-decision-action cycle.
/// </summary>
public sealed class CycleResult
{
	/// <summary>
	/// Timestamp of this cycle.
	/// </summary>
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	/// <summary>
	/// Whether a frame was available for analysis.
	/// </summary>
	public bool FrameAvailable { get; init; }

	/// <summary>
	/// Vision analysis result (null if no frame).
	/// </summary>
	public VisionAnalysis? Analysis { get; init; }

	/// <summary>
	/// Decision made based on analysis (null if no action needed).
	/// </summary>
	public string? Decision { get; init; }

	/// <summary>
	/// Number of actions executed this cycle.
	/// </summary>
	public int ActionsExecuted { get; init; }

	/// <summary>
	/// Total cycle duration in milliseconds.
	/// </summary>
	public long CycleDurationMs { get; init; }

	/// <summary>
	/// Error message if the cycle failed.
	/// </summary>
	public string? Error { get; init; }
}

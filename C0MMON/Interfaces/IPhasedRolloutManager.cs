using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-019: Contract for phased deployment rollout orchestration.
/// Manages canary deployments, progressive rollouts, and automatic rollback triggers.
/// </summary>
public interface IPhasedRolloutManager
{
	/// <summary>
	/// Starts a phased rollout for a new version.
	/// </summary>
	Task<RolloutPlan> StartRolloutAsync(string version, RolloutConfig config, CancellationToken cancellationToken = default);

	/// <summary>
	/// Advances the rollout to the next phase.
	/// </summary>
	Task<bool> AdvancePhaseAsync(string rolloutId, CancellationToken cancellationToken = default);

	/// <summary>
	/// Aborts a rollout and triggers rollback.
	/// </summary>
	Task<bool> AbortRolloutAsync(string rolloutId, string reason, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets the current rollout status.
	/// </summary>
	Task<RolloutPlan?> GetRolloutStatusAsync(string rolloutId, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets all active rollouts.
	/// </summary>
	IReadOnlyList<RolloutPlan> GetActiveRollouts();
}

public class RolloutConfig
{
	public List<RolloutPhase> Phases { get; set; } = new();
	public int HealthCheckIntervalSeconds { get; set; } = 60;
	public double FailureThresholdPercent { get; set; } = 5.0;
	public bool AutoAdvance { get; set; } = false;
}

public class RolloutPhase
{
	public string Name { get; set; } = string.Empty;
	public double TargetPercentage { get; set; }
	public int MinDurationMinutes { get; set; }
	public int MaxDurationMinutes { get; set; }
}

public class RolloutPlan
{
	public string Id { get; set; } = string.Empty;
	public string Version { get; set; } = string.Empty;
	public RolloutStatus Status { get; set; }
	public int CurrentPhaseIndex { get; set; }
	public List<RolloutPhase> Phases { get; set; } = new();
	public System.DateTime StartedAt { get; set; }
	public System.DateTime? CompletedAt { get; set; }
	public string AbortReason { get; set; } = string.Empty;
}

public enum RolloutStatus
{
	Pending,
	InProgress,
	Completed,
	Aborted,
	RolledBack,
}

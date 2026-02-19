using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Interfaces;
using P4NTH30N.C0MMON.Monitoring;

namespace P4NTH30N.H0UND.Services;

/// <summary>
/// FOUREYES-019: Phased rollout manager for deployment orchestration.
/// Supports canary → staged → full rollout with health-gated phase advancement.
/// </summary>
public class PhasedRolloutManager : IPhasedRolloutManager {
	private readonly IHealthCheckService _healthService;
	private readonly IRollbackManager? _rollbackManager;
	private readonly ConcurrentDictionary<string, RolloutPlan> _activeRollouts = new();

	public PhasedRolloutManager(IHealthCheckService healthService, IRollbackManager? rollbackManager = null) {
		_healthService = healthService;
		_rollbackManager = rollbackManager;
	}

	public async Task<RolloutPlan> StartRolloutAsync(string version, RolloutConfig config, CancellationToken cancellationToken = default) {
		// Capture pre-deploy state
		if (_rollbackManager != null)
			await _rollbackManager.CaptureStateAsync(C0MMON.Entities.SystemStateType.PreDeploy, $"Pre-deploy for {version}", cancellationToken);

		RolloutPlan plan = new() {
			Id = Guid.NewGuid().ToString("N")[..8],
			Version = version,
			Status = RolloutStatus.InProgress,
			CurrentPhaseIndex = 0,
			Phases = config.Phases.Count > 0 ? config.Phases : GetDefaultPhases(),
			StartedAt = DateTime.UtcNow,
		};

		_activeRollouts[plan.Id] = plan;
		Console.WriteLine($"[PhasedRollout] Started rollout {plan.Id} for version {version} ({plan.Phases.Count} phases)");
		return plan;
	}

	public async Task<bool> AdvancePhaseAsync(string rolloutId, CancellationToken cancellationToken = default) {
		if (!_activeRollouts.TryGetValue(rolloutId, out RolloutPlan? plan))
			return false;

		// Check system health before advancing
		SystemHealth health = await _healthService.GetSystemHealthAsync();
		if (health.OverallStatus == HealthStatus.Unhealthy) {
			Console.WriteLine($"[PhasedRollout] Cannot advance {rolloutId} - system unhealthy");
			await AbortRolloutAsync(rolloutId, "System unhealthy during phase advance", cancellationToken);
			return false;
		}

		plan.CurrentPhaseIndex++;

		if (plan.CurrentPhaseIndex >= plan.Phases.Count) {
			plan.Status = RolloutStatus.Completed;
			plan.CompletedAt = DateTime.UtcNow;

			if (_rollbackManager != null)
				await _rollbackManager.CaptureStateAsync(C0MMON.Entities.SystemStateType.PostDeploy, $"Post-deploy for {plan.Version}", cancellationToken);

			Console.WriteLine($"[PhasedRollout] Rollout {rolloutId} completed successfully for version {plan.Version}");
			return true;
		}

		RolloutPhase nextPhase = plan.Phases[plan.CurrentPhaseIndex];
		Console.WriteLine($"[PhasedRollout] Advanced {rolloutId} to phase '{nextPhase.Name}' ({nextPhase.TargetPercentage}%)");
		return true;
	}

	public async Task<bool> AbortRolloutAsync(string rolloutId, string reason, CancellationToken cancellationToken = default) {
		if (!_activeRollouts.TryGetValue(rolloutId, out RolloutPlan? plan))
			return false;

		plan.Status = RolloutStatus.Aborted;
		plan.AbortReason = reason;
		plan.CompletedAt = DateTime.UtcNow;

		Console.WriteLine($"[PhasedRollout] Aborted rollout {rolloutId}: {reason}");

		// Trigger rollback
		if (_rollbackManager != null) {
			bool rollbackSuccess = await _rollbackManager.RollbackToLastHealthyAsync(cancellationToken);
			if (rollbackSuccess) {
				plan.Status = RolloutStatus.RolledBack;
				Console.WriteLine($"[PhasedRollout] Successfully rolled back from {rolloutId}");
			}
		}

		return true;
	}

	public Task<RolloutPlan?> GetRolloutStatusAsync(string rolloutId, CancellationToken cancellationToken = default) {
		_activeRollouts.TryGetValue(rolloutId, out RolloutPlan? plan);
		return Task.FromResult(plan);
	}

	public IReadOnlyList<RolloutPlan> GetActiveRollouts() {
		return _activeRollouts.Values.Where(r => r.Status == RolloutStatus.InProgress).ToList();
	}

	private static List<RolloutPhase> GetDefaultPhases() {
		return new List<RolloutPhase> {
			new() { Name = "Canary", TargetPercentage = 5, MinDurationMinutes = 10, MaxDurationMinutes = 30 },
			new() { Name = "Staged", TargetPercentage = 25, MinDurationMinutes = 15, MaxDurationMinutes = 60 },
			new() { Name = "Progressive", TargetPercentage = 50, MinDurationMinutes = 15, MaxDurationMinutes = 60 },
			new() { Name = "Full", TargetPercentage = 100, MinDurationMinutes = 0, MaxDurationMinutes = 0 },
		};
	}
}

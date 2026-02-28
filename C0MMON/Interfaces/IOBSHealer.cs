using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-010: Cerberus Protocol - OBS self-healing contract.
/// Monitors OBS connection health and performs automatic recovery actions.
/// </summary>
public interface IOBSHealer
{
	/// <summary>
	/// Checks OBS health and performs healing if needed.
	/// </summary>
	Task<HealingAction?> CheckAndHealAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets recent healing actions for audit/monitoring.
	/// </summary>
	IReadOnlyList<HealingAction> GetRecentActions(int count = 10);

	/// <summary>
	/// Whether the healer is currently performing a recovery action.
	/// </summary>
	bool IsHealing { get; }
}

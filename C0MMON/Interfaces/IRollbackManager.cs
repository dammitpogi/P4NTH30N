using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-018: Contract for automatic rollback recovery.
/// Captures system state snapshots and performs rollback when health degrades.
/// </summary>
public interface IRollbackManager
{
	/// <summary>
	/// Captures a snapshot of current system state.
	/// </summary>
	Task<SystemState> CaptureStateAsync(SystemStateType stateType, string notes = "", CancellationToken cancellationToken = default);

	/// <summary>
	/// Rolls back to a specific captured state.
	/// </summary>
	Task<bool> RollbackToAsync(string stateId, CancellationToken cancellationToken = default);

	/// <summary>
	/// Rolls back to the most recent healthy state.
	/// </summary>
	Task<bool> RollbackToLastHealthyAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets all captured state snapshots.
	/// </summary>
	IReadOnlyList<SystemState> GetSnapshots();

	/// <summary>
	/// Whether a rollback is currently in progress.
	/// </summary>
	bool IsRollingBack { get; }
}

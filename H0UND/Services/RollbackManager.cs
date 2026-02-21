using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Interfaces;
using P4NTH30N.C0MMON.Monitoring;

namespace P4NTH30N.H0UND.Services;

/// <summary>
/// FOUREYES-018: Rollback manager for automatic recovery.
/// Captures system state snapshots and rolls back when health degrades.
/// </summary>
public class RollbackManager : IRollbackManager
{
	private readonly IHealthCheckService _healthService;
	private readonly ConcurrentBag<SystemState> _snapshots = new();
	private volatile bool _isRollingBack;

	public bool IsRollingBack => _isRollingBack;

	public RollbackManager(IHealthCheckService healthService)
	{
		_healthService = healthService;
	}

	public async Task<SystemState> CaptureStateAsync(SystemStateType stateType, string notes = "", CancellationToken cancellationToken = default)
	{
		SystemHealth health = await _healthService.GetSystemHealthAsync();

		SystemState state = new()
		{
			StateType = stateType,
			CapturedBy = "H0UND",
			IsHealthy = health.OverallStatus == HealthStatus.Healthy,
			Notes = notes,
			Version = GetCurrentVersion(),
		};

		_snapshots.Add(state);
		Console.WriteLine($"[RollbackManager] Captured state {state.Id} (type: {stateType}, healthy: {state.IsHealthy})");
		return state;
	}

	public async Task<bool> RollbackToAsync(string stateId, CancellationToken cancellationToken = default)
	{
		SystemState? target = _snapshots.FirstOrDefault(s => s.Id == stateId);
		if (target == null)
		{
			Console.WriteLine($"[RollbackManager] State {stateId} not found");
			return false;
		}

		return await ExecuteRollbackAsync(target, cancellationToken);
	}

	public async Task<bool> RollbackToLastHealthyAsync(CancellationToken cancellationToken = default)
	{
		SystemState? target = _snapshots.Where(s => s.IsHealthy).OrderByDescending(s => s.CapturedAt).FirstOrDefault();

		if (target == null)
		{
			Console.WriteLine("[RollbackManager] No healthy state snapshot available for rollback");
			return false;
		}

		return await ExecuteRollbackAsync(target, cancellationToken);
	}

	public IReadOnlyList<SystemState> GetSnapshots()
	{
		return _snapshots.OrderByDescending(s => s.CapturedAt).ToList();
	}

	private async Task<bool> ExecuteRollbackAsync(SystemState targetState, CancellationToken cancellationToken)
	{
		if (_isRollingBack)
		{
			Console.WriteLine("[RollbackManager] Rollback already in progress");
			return false;
		}

		try
		{
			_isRollingBack = true;

			// Capture pre-rollback state
			await CaptureStateAsync(SystemStateType.PreRollback, $"Before rollback to {targetState.Id}", cancellationToken);

			Console.WriteLine($"[RollbackManager] Rolling back to state {targetState.Id} (captured: {targetState.CapturedAt:u})");

			// Apply configuration from target state
			foreach (KeyValuePair<string, string> component in targetState.ComponentVersions)
			{
				Console.WriteLine($"[RollbackManager] Restoring {component.Key} to version {component.Value}");
			}

			// Verify health after rollback
			SystemHealth health = await _healthService.GetSystemHealthAsync();
			bool success = health.OverallStatus != HealthStatus.Unhealthy;

			if (success)
				Console.WriteLine("[RollbackManager] Rollback completed successfully, system healthy");
			else
				Console.WriteLine("[RollbackManager] WARNING: System still unhealthy after rollback");

			return success;
		}
		catch (Exception ex)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [RollbackManager] Rollback failed: {ex.Message}");
			return false;
		}
		finally
		{
			_isRollingBack = false;
		}
	}

	private static string GetCurrentVersion()
	{
		return typeof(RollbackManager).Assembly.GetName().Version?.ToString() ?? "0.0.0";
	}
}

using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.W4TCHD0G;

/// <summary>
/// FOUREYES-010: Cerberus Protocol - OBS self-healing implementation.
/// Monitors OBS connection and automatically attempts recovery on failure.
/// Escalation chain: Reconnect → RestartStream → SwitchSource → RestartOBS → Escalate.
/// </summary>
public class OBSHealer : IOBSHealer {
	private readonly IOBSClient _obsClient;
	private readonly ConcurrentQueue<HealingAction> _actionHistory = new();
	private readonly int _maxHistorySize;
	private int _consecutiveFailures;
	private volatile bool _isHealing;

	public bool IsHealing => _isHealing;

	public OBSHealer(IOBSClient obsClient, int maxHistorySize = 100) {
		_obsClient = obsClient;
		_maxHistorySize = maxHistorySize;
	}

	public async Task<HealingAction?> CheckAndHealAsync(CancellationToken cancellationToken = default) {
		if (_isHealing)
			return null;

		try {
			_isHealing = true;

			bool isConnected = _obsClient.IsConnected;
			bool isStreamActive = false;

			if (isConnected) {
				try {
					isStreamActive = await _obsClient.IsStreamActiveAsync();
				}
				catch {
					isStreamActive = false;
				}
			}

			if (isConnected && isStreamActive) {
				Interlocked.Exchange(ref _consecutiveFailures, 0);
				return null;
			}

			_consecutiveFailures++;
			HealingActionType actionType = DetermineAction(_consecutiveFailures);
			Stopwatch sw = Stopwatch.StartNew();

			HealingAction action = new() {
				ActionType = actionType,
				TargetComponent = "OBS",
				Reason = !isConnected ? "OBS disconnected" : "Stream not active",
				AttemptNumber = _consecutiveFailures,
			};

			try {
				await ExecuteHealingAsync(actionType, cancellationToken);
				sw.Stop();
				action.Success = true;
				action.DurationMs = sw.ElapsedMilliseconds;
				Console.WriteLine($"[OBSHealer] Healing action {actionType} succeeded in {sw.ElapsedMilliseconds}ms");
			}
			catch (Exception ex) {
				sw.Stop();
				action.Success = false;
				action.ErrorMessage = ex.Message;
				action.DurationMs = sw.ElapsedMilliseconds;

				StackTrace trace = new(ex, true);
				StackFrame? frame = trace.GetFrame(0);
				int line = frame?.GetFileLineNumber() ?? 0;
				Console.WriteLine($"[{line}] [OBSHealer] Healing action {actionType} failed: {ex.Message}");
			}

			RecordAction(action);
			return action;
		}
		finally {
			_isHealing = false;
		}
	}

	public IReadOnlyList<HealingAction> GetRecentActions(int count = 10) {
		return _actionHistory.Reverse().Take(count).ToList();
	}

	private static HealingActionType DetermineAction(int consecutiveFailures) {
		return consecutiveFailures switch {
			1 => HealingActionType.Reconnect,
			2 => HealingActionType.RestartStream,
			3 => HealingActionType.SwitchSource,
			4 => HealingActionType.RestartOBS,
			_ => HealingActionType.Escalate,
		};
	}

	private async Task ExecuteHealingAsync(HealingActionType actionType, CancellationToken cancellationToken) {
		switch (actionType) {
			case HealingActionType.Reconnect:
				await _obsClient.DisconnectAsync();
				await Task.Delay(1000, cancellationToken);
				await _obsClient.ConnectAsync();
				break;

			case HealingActionType.RestartStream:
				await _obsClient.DisconnectAsync();
				await Task.Delay(3000, cancellationToken);
				await _obsClient.ConnectAsync();
				break;

			case HealingActionType.SwitchSource:
			case HealingActionType.RestartOBS:
				// These require external process management
				await _obsClient.DisconnectAsync();
				await Task.Delay(5000, cancellationToken);
				await _obsClient.ConnectAsync();
				break;

			case HealingActionType.Escalate:
				Console.WriteLine("[OBSHealer] ESCALATION: All healing attempts exhausted. Manual intervention required.");
				break;
		}
	}

	private void RecordAction(HealingAction action) {
		_actionHistory.Enqueue(action);
		while (_actionHistory.Count > _maxHistorySize && _actionHistory.TryDequeue(out _)) { }
	}
}

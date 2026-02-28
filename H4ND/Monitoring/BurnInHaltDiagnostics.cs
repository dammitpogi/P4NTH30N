using System.Text.Json;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H4ND.Parallel;
using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.H4ND.Monitoring;

/// <summary>
/// MON-058: Captures full diagnostic state when burn-in is halted.
/// Saves to file and optionally to MongoDB BURN_IN_HALT_DIAGNOSTICS.
/// </summary>
public sealed class BurnInHaltDiagnostics
{
	private readonly IUnitOfWork _uow;

	public BurnInHaltDiagnostics(IUnitOfWork uow)
	{
		_uow = uow;
	}

	/// <summary>
	/// Captures a full diagnostic dump when halt is triggered.
	/// </summary>
	public HaltDiagnosticDump Capture(
		string sessionId,
		string haltReason,
		ParallelMetrics metrics,
		BurnInMetricsSnapshot finalSnapshot,
		List<BurnInAlert> triggeringAlerts,
		List<string> recommendations,
		TimeSpan elapsed)
	{
		var workerStats = metrics.GetWorkerStats();

		var dump = new HaltDiagnosticDump
		{
			SessionId = sessionId,
			HaltTime = DateTime.UtcNow,
			HaltReason = haltReason,
			HaltTriggers = triggeringAlerts.Where(a => a.RequiresHalt).Select(a => a.ToString()).ToList(),
			DurationHours = elapsed.TotalHours,
			SignalsProcessed = metrics.SpinsSucceeded,
			FinalMetrics = new HaltMetricsSnapshot
			{
				SpinsAttempted = metrics.SpinsAttempted,
				SpinsSucceeded = metrics.SpinsSucceeded,
				SpinsFailed = metrics.SpinsFailed,
				ErrorRate = metrics.ErrorRate,
				SuccessRate = metrics.SuccessRate,
				ClaimsSucceeded = metrics.ClaimsSucceeded,
				WorkerRestarts = metrics.WorkerRestarts,
				RenewalAttempts = metrics.RenewalAttempts,
				RenewalSuccesses = metrics.RenewalSuccesses,
				StaleClaims = metrics.StaleClaims,
				CriticalFailures = metrics.CriticalFailures,
				MemoryMB = finalSnapshot.MemoryMB,
				MemoryGrowthMB = finalSnapshot.MemoryGrowthMB,
			},
			WorkerStates = workerStats.Select(kv => new WorkerDiagnosticState
			{
				WorkerId = kv.Key,
				TotalSpins = kv.Value.TotalSpins,
				SuccessfulSpins = kv.Value.SuccessfulSpins,
				Errors = kv.Value.Errors,
				Restarts = kv.Value.Restarts,
				LastSpinAt = kv.Value.LastSpinAt,
				LastError = kv.Value.LastError,
			}).ToList(),
			Recommendations = recommendations,
		};

		// Capture recent errors from MongoDB
		try
		{
			dump.RecentErrors = _uow.Errors.GetBySource("H4ND")
				.Take(20)
				.Select(e => $"{e.Timestamp:O} [{e.Severity}] {e.Message}")
				.ToList();
		}
		catch { /* non-fatal */ }

		// Release stranded credentials
		try
		{
			var locked = _uow.Credentials.GetAll().Where(c => !c.Unlocked).ToList();
			foreach (var cred in locked)
			{
				_uow.Credentials.Unlock(cred);
			}
			dump.CredentialsUnlocked = locked.Count;
		}
		catch { /* non-fatal */ }

		// Release unclaimed signals
		try
		{
			var claimed = _uow.Signals.GetAll().Where(s => !s.Acknowledged && s.ClaimedBy != null).ToList();
			foreach (var sig in claimed)
			{
				_uow.Signals.ReleaseClaim(sig);
			}
			dump.SignalsReleased = claimed.Count;
		}
		catch { /* non-fatal */ }

		return dump;
	}

	/// <summary>
	/// Saves diagnostic dump to JSON file.
	/// </summary>
	public string SaveToFile(HaltDiagnosticDump dump, string? outputDir = null)
	{
		string dir = outputDir ?? Path.Combine(AppContext.BaseDirectory, "logs");
		Directory.CreateDirectory(dir);
		string path = Path.Combine(dir, $"halt-diagnostic-{dump.SessionId}.json");
		string json = JsonSerializer.Serialize(dump, new JsonSerializerOptions { WriteIndented = true });
		File.WriteAllText(path, json);
		Console.WriteLine($"[HaltDiagnostics] Saved to {path}");
		return path;
	}
}

public sealed class HaltDiagnosticDump
{
	public string SessionId { get; set; } = string.Empty;
	public DateTime HaltTime { get; set; }
	public string HaltReason { get; set; } = string.Empty;
	public List<string> HaltTriggers { get; set; } = [];
	public double DurationHours { get; set; }
	public long SignalsProcessed { get; set; }
	public HaltMetricsSnapshot FinalMetrics { get; set; } = new();
	public List<WorkerDiagnosticState> WorkerStates { get; set; } = [];
	public List<string> RecentErrors { get; set; } = [];
	public List<string> Recommendations { get; set; } = [];
	public int CredentialsUnlocked { get; set; }
	public int SignalsReleased { get; set; }
}

public sealed class HaltMetricsSnapshot
{
	public long SpinsAttempted { get; set; }
	public long SpinsSucceeded { get; set; }
	public long SpinsFailed { get; set; }
	public double ErrorRate { get; set; }
	public double SuccessRate { get; set; }
	public long ClaimsSucceeded { get; set; }
	public long WorkerRestarts { get; set; }
	public long RenewalAttempts { get; set; }
	public long RenewalSuccesses { get; set; }
	public long StaleClaims { get; set; }
	public long CriticalFailures { get; set; }
	public double MemoryMB { get; set; }
	public double MemoryGrowthMB { get; set; }
}

public sealed class WorkerDiagnosticState
{
	public string WorkerId { get; set; } = string.Empty;
	public int TotalSpins { get; set; }
	public int SuccessfulSpins { get; set; }
	public int Errors { get; set; }
	public int Restarts { get; set; }
	public DateTime? LastSpinAt { get; set; }
	public string? LastError { get; set; }
}

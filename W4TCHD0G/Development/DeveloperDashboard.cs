using System;
using System.Collections.Generic;
using System.Linq;
using P4NTH30N.W4TCHD0G.Agent;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Development;

/// <summary>
/// FEAT-036: Real-time developer dashboard for FourEyes observation.
/// Displays live cycle results, vision analysis, safety status, and training data stats.
/// </summary>
public sealed class DeveloperDashboard
{
	private readonly List<CycleResult> _recentCycles = new();
	private readonly int _maxCycles;
	private readonly object _lock = new();

	/// <summary>
	/// Whether the dashboard is actively rendering.
	/// </summary>
	public bool IsActive { get; private set; }

	/// <summary>
	/// Total cycles observed.
	/// </summary>
	public int TotalCyclesObserved { get; private set; }

	public DeveloperDashboard(int maxCycleHistory = 50)
	{
		_maxCycles = maxCycleHistory;
	}

	/// <summary>
	/// Starts the dashboard observation.
	/// </summary>
	public void Start()
	{
		IsActive = true;
		Console.WriteLine("[DeveloperDashboard] Observation started");
	}

	/// <summary>
	/// Stops the dashboard.
	/// </summary>
	public void Stop()
	{
		IsActive = false;
		Console.WriteLine("[DeveloperDashboard] Observation stopped");
	}

	/// <summary>
	/// Records a cycle result for display.
	/// </summary>
	public void RecordCycle(CycleResult result)
	{
		lock (_lock)
		{
			_recentCycles.Add(result);
			TotalCyclesObserved++;
			if (_recentCycles.Count > _maxCycles)
				_recentCycles.RemoveAt(0);
		}

		if (IsActive)
			RenderLatest(result);
	}

	/// <summary>
	/// Renders the latest cycle result to console.
	/// </summary>
	private void RenderLatest(CycleResult result)
	{
		string frameStatus = result.FrameAvailable ? "FRAME" : "NO_FRAME";
		string decision = result.Decision ?? "N/A";
		string error = result.Error != null ? $" ERR: {result.Error}" : "";

		Console.WriteLine(
			$"[FourEyes] #{TotalCyclesObserved} | {frameStatus} | {result.CycleDurationMs}ms | "
			+ $"Actions: {result.ActionsExecuted} | {decision}{error}"
		);

		if (result.Analysis != null)
		{
			VisionAnalysis a = result.Analysis;
			Console.WriteLine(
				$"  Vision: State={a.GameState} Conf={a.Confidence:F2} "
				+ $"Jackpots={a.ExtractedJackpots?.Count ?? 0} InfMs={a.InferenceTimeMs}"
			);
		}
	}

	/// <summary>
	/// Renders a full dashboard summary.
	/// </summary>
	public void RenderSummary()
	{
		lock (_lock)
		{
			Console.WriteLine("\n╔══════════════════════════════════════════════╗");
			Console.WriteLine("║      FourEyes Developer Dashboard            ║");
			Console.WriteLine("╠══════════════════════════════════════════════╣");
			Console.WriteLine($"║  Total Cycles:  {TotalCyclesObserved,-28}║");

			if (_recentCycles.Count > 0)
			{
				double avgMs = _recentCycles.Average(c => c.CycleDurationMs);
				int framesAvail = _recentCycles.Count(c => c.FrameAvailable);
				int actionsExec = _recentCycles.Sum(c => c.ActionsExecuted);
				int errors = _recentCycles.Count(c => c.Error != null);

				Console.WriteLine($"║  Avg Cycle:     {avgMs:F1}ms{new string(' ', 25 - $"{avgMs:F1}ms".Length)}║");
				Console.WriteLine($"║  Frames Avail:  {framesAvail}/{_recentCycles.Count}{new string(' ', 25 - $"{framesAvail}/{_recentCycles.Count}".Length)}║");
				Console.WriteLine($"║  Actions Exec:  {actionsExec,-28}║");
				Console.WriteLine($"║  Errors:        {errors,-28}║");
			}

			Console.WriteLine("╚══════════════════════════════════════════════╝\n");
		}
	}
}

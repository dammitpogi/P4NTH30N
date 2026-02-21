using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision.Stubs;

/// <summary>
/// FEAT-036: Stub jackpot detector for pipeline testing.
/// Returns configurable mock values without requiring actual OCR infrastructure.
/// Used in development mode and E2E testing.
/// </summary>
public sealed class StubJackpotDetector : IJackpotDetector
{
	private Dictionary<string, RegionOfInterest> _rois = new();

	/// <summary>
	/// Pre-configured jackpot values to return.
	/// </summary>
	public Dictionary<string, decimal> MockJackpots { get; set; } = new()
	{
		["Grand"] = 1500.00m,
		["Major"] = 450.00m,
		["Minor"] = 85.00m,
		["Mini"] = 12.50m,
	};

	/// <summary>
	/// Simulated detection confidence.
	/// </summary>
	public double MockConfidence { get; set; } = 0.95;

	/// <summary>
	/// Whether to simulate detection failure.
	/// </summary>
	public bool SimulateFailure { get; set; }

	/// <summary>
	/// Simulated latency in milliseconds.
	/// </summary>
	public int SimulatedLatencyMs { get; set; } = 50;

	public async Task<Dictionary<string, decimal>> DetectAsync(VisionFrame frame)
	{
		if (SimulatedLatencyMs > 0)
			await Task.Delay(SimulatedLatencyMs);

		if (SimulateFailure)
			throw new InvalidOperationException("[StubJackpotDetector] Simulated OCR failure");

		return new Dictionary<string, decimal>(MockJackpots);
	}

	public async Task<decimal?> DetectSingleAsync(VisionFrame frame, RegionOfInterest roi)
	{
		if (SimulatedLatencyMs > 0)
			await Task.Delay(SimulatedLatencyMs / 4);

		if (SimulateFailure)
			return null;

		// Return the matching tier value if the ROI name matches
		if (MockJackpots.TryGetValue(roi.Name, out decimal value))
			return value;

		return null;
	}

	public void ConfigureROIs(Dictionary<string, RegionOfInterest> rois)
	{
		_rois = rois ?? new();
		Console.WriteLine($"[StubJackpotDetector] Configured {_rois.Count} ROIs");
	}
}

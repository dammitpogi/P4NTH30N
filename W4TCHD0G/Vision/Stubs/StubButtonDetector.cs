using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision.Stubs;

/// <summary>
/// FEAT-036: Stub button detector with predefined button positions.
/// Returns configurable mock buttons without requiring template matching infrastructure.
/// Used in development mode and E2E testing.
/// </summary>
public sealed class StubButtonDetector : IButtonDetector
{
	/// <summary>
	/// Pre-configured buttons to return on detection.
	/// Default includes a spin button at typical slot game position.
	/// </summary>
	public List<DetectedButton> MockButtons { get; set; } = new()
	{
		new DetectedButton
		{
			Type = ButtonType.Spin,
			CenterX = 640,
			CenterY = 650,
			Width = 100,
			Height = 100,
			Confidence = 0.92,
			IsEnabled = true,
			Label = "SPIN",
		},
		new DetectedButton
		{
			Type = ButtonType.BetIncrease,
			CenterX = 500,
			CenterY = 650,
			Width = 60,
			Height = 40,
			Confidence = 0.85,
			IsEnabled = true,
			Label = "+",
		},
		new DetectedButton
		{
			Type = ButtonType.BetDecrease,
			CenterX = 400,
			CenterY = 650,
			Width = 60,
			Height = 40,
			Confidence = 0.85,
			IsEnabled = true,
			Label = "-",
		},
	};

	/// <summary>
	/// Whether to simulate detection failure.
	/// </summary>
	public bool SimulateFailure { get; set; }

	/// <summary>
	/// Simulated latency in milliseconds.
	/// </summary>
	public int SimulatedLatencyMs { get; set; } = 30;

	public async Task<List<DetectedButton>> DetectAsync(VisionFrame frame)
	{
		if (SimulatedLatencyMs > 0)
			await Task.Delay(SimulatedLatencyMs);

		if (SimulateFailure)
			return new List<DetectedButton>();

		return new List<DetectedButton>(MockButtons);
	}

	public void LoadTemplates(string templateDirectory)
	{
		Console.WriteLine($"[StubButtonDetector] LoadTemplates called with: {templateDirectory} (stub — no-op)");
	}
}

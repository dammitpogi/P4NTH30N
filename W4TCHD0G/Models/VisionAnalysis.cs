using System;
using System.Collections.Generic;
using P4NTH30N.W4TCHD0G.Vision;

namespace P4NTH30N.W4TCHD0G.Models;

public class VisionAnalysis
{
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public AnimationState GameState { get; set; } = AnimationState.Idle;
	public double Confidence { get; set; }
	public Dictionary<string, double> ExtractedJackpots { get; set; } = new();
	public double ExtractedBalance { get; set; }
	public bool ErrorDetected { get; set; }
	public string ErrorMessage { get; set; } = string.Empty;
	public string ModelUsed { get; set; } = string.Empty;
	public long InferenceTimeMs { get; set; }

	/// <summary>
	/// FEAT-036: Detected UI buttons from vision processing.
	/// Used by DecisionEngine for targeted click coordinates.
	/// </summary>
	public List<DetectedButton>? DetectedButtons { get; set; }
}

using System;
using System.Collections.Generic;

namespace P4NTH30N.C0MMON.Entities;

/// <summary>
/// FOUREYES-007: Vision event entity for temporal event buffering.
/// Represents a single vision/game event with timestamp and metadata.
/// </summary>
public class VisionEvent
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public string EventType { get; set; } = string.Empty;
	public string Source { get; set; } = string.Empty;
	public double Confidence { get; set; }
	public string GameState { get; set; } = string.Empty;
	public Dictionary<string, object> Data { get; set; } = new();
	public string ModelId { get; set; } = string.Empty;
	public long InferenceTimeMs { get; set; }
}

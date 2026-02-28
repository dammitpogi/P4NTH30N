using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// DECISION_025: Entity representing a detected anomaly in jackpot patterns.
/// Stored in ERR0R collection for review and analysis.
/// </summary>
[BsonIgnoreExtraElements]
public class AnomalyEvent
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// House where anomaly was detected.
	/// </summary>
	public string House { get; set; } = string.Empty;

	/// <summary>
	/// Game where anomaly was detected.
	/// </summary>
	public string Game { get; set; } = string.Empty;

	/// <summary>
	/// Jackpot tier (Grand, Major, Minor, Mini).
	/// </summary>
	public string Tier { get; set; } = string.Empty;

	/// <summary>
	/// The anomalous value that triggered detection.
	/// </summary>
	public double AnomalousValue { get; set; }

	/// <summary>
	/// Atypicality ratio from compression-based scoring.
	/// </summary>
	public double AtypicalityRatio { get; set; }

	/// <summary>
	/// Z-score from statistical fallback.
	/// </summary>
	public double ZScore { get; set; }

	/// <summary>
	/// Window mean at time of detection.
	/// </summary>
	public double WindowMean { get; set; }

	/// <summary>
	/// Window standard deviation at time of detection.
	/// </summary>
	public double WindowStdDev { get; set; }

	/// <summary>
	/// Number of values in the sliding window.
	/// </summary>
	public int WindowSize { get; set; }

	/// <summary>
	/// Detection method that triggered: Compression, ZScore, or Both.
	/// </summary>
	public string DetectionMethod { get; set; } = string.Empty;

	/// <summary>
	/// When the anomaly was detected.
	/// </summary>
	public DateTime DetectedAt { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// Whether this anomaly has been reviewed by an operator.
	/// </summary>
	public bool Reviewed { get; set; }

	/// <summary>
	/// Optional notes from review.
	/// </summary>
	public string? ReviewNotes { get; set; }
}

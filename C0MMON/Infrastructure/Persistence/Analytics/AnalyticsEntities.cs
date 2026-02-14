using MongoDB.Bson;

namespace P4NTH30N.C0MMON.Persistence.Analytics;

/// <summary>
/// Analytics event stored in MongoDB.
/// </summary>
public class AnalyticsEvent
{
	/// <summary>
	/// MongoDB document id.
	/// </summary>
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// Event type (e.g. "DPD_ANALYSIS", "JACKPOT_FORECAST", "HEALTH_REPORT").
	/// </summary>
	public string EventType { get; set; } = string.Empty;

	/// <summary>
	/// UTC timestamp for the event.
	/// </summary>
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// House identifier.
	/// </summary>
	public required string House { get; set; }

	/// <summary>
	/// Game identifier.
	/// </summary>
	public required string Game { get; set; }

	/// <summary>
	/// JSON serialized payload for the event.
	/// </summary>
	public string? Payload { get; set; }
}

/// <summary>
/// DPD analysis record stored in MongoDB.
/// </summary>
public class DPDRecord
{
	/// <summary>
	/// MongoDB document id.
	/// </summary>
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// UTC timestamp for the record.
	/// </summary>
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// House identifier.
	/// </summary>
	public required string House { get; set; }

	/// <summary>
	/// Game identifier.
	/// </summary>
	public required string Game { get; set; }

	/// <summary>
	/// Number of credentials included in the analysis.
	/// </summary>
	public int CredentialCount { get; set; }

	/// <summary>
	/// Average DPD across the analyzed credentials.
	/// </summary>
	public double AverageDPD { get; set; }

	/// <summary>
	/// Total balance across the analyzed credentials.
	/// </summary>
	public double TotalBalance { get; set; }

	/// <summary>
	/// Optional JSON details for the analysis.
	/// </summary>
	public string? Details { get; set; }
}

/// <summary>
/// Jackpot forecast record stored in MongoDB.
/// </summary>
public class JackpotForecastRecord
{
	/// <summary>
	/// MongoDB document id.
	/// </summary>
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// UTC timestamp for the record.
	/// </summary>
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// House identifier.
	/// </summary>
	public required string House { get; set; }

	/// <summary>
	/// Game identifier.
	/// </summary>
	public required string Game { get; set; }

	/// <summary>
	/// Jackpot category.
	/// </summary>
	public required string Category { get; set; }

	/// <summary>
	/// Current jackpot value.
	/// </summary>
	public double Current { get; set; }

	/// <summary>
	/// Target threshold for the jackpot.
	/// </summary>
	public double Threshold { get; set; }

	/// <summary>
	/// Progress ratio toward the threshold.
	/// </summary>
	public double Progress { get; set; }

	/// <summary>
	/// Estimated hit time (UTC) when available.
	/// </summary>
	public DateTime? EstimatedHit { get; set; }

	/// <summary>
	/// Priority assigned to this forecast.
	/// </summary>
	public int Priority { get; set; }

	/// <summary>
	/// DPM (delta per minute) used for ETA calculations.
	/// </summary>
	public double DPM { get; set; }

	/// <summary>
	/// Estimated hours remaining until hit.
	/// </summary>
	public double HoursRemaining { get; set; }
}

/// <summary>
/// Credential health report record stored in MongoDB.
/// </summary>
public class HealthReportRecord
{
	/// <summary>
	/// MongoDB document id.
	/// </summary>
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// UTC timestamp for the report.
	/// </summary>
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// Total credential count.
	/// </summary>
	public int TotalCredentials { get; set; }

	/// <summary>
	/// Enabled credential count.
	/// </summary>
	public int EnabledCredentials { get; set; }

	/// <summary>
	/// Banned credential count.
	/// </summary>
	public int BannedCredentials { get; set; }

	/// <summary>
	/// Stale credential count.
	/// </summary>
	public int StaleCredentials { get; set; }

	/// <summary>
	/// Average balance across credentials.
	/// </summary>
	public double AverageBalance { get; set; }

	/// <summary>
	/// Total balance across credentials.
	/// </summary>
	public double TotalBalance { get; set; }

	/// <summary>
	/// Number of distinct houses in the report.
	/// </summary>
	public int HouseCount { get; set; }

	/// <summary>
	/// JSON serialized per-house breakdown.
	/// </summary>
	public string? HouseBreakdown { get; set; }
}

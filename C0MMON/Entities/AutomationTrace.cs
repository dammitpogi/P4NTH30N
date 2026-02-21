using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON.Entities;

/// <summary>
/// DECISION_026: Entity representing a CDP automation trace for debugging.
/// Stored in MongoDB for post-mortem analysis of automation failures.
/// </summary>
[BsonIgnoreExtraElements]
public class AutomationTrace
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// Session ID that generated this trace.
	/// </summary>
	public string SessionId { get; set; } = string.Empty;

	/// <summary>
	/// Credential username being automated.
	/// </summary>
	public string Username { get; set; } = string.Empty;

	/// <summary>
	/// Game platform (FireKirin, OrionStars).
	/// </summary>
	public string Game { get; set; } = string.Empty;

	/// <summary>
	/// Type of trace: NetworkRequest, NetworkResponse, DomEvent, Error, StateChange.
	/// </summary>
	public string TraceType { get; set; } = string.Empty;

	/// <summary>
	/// URL for network traces.
	/// </summary>
	public string? Url { get; set; }

	/// <summary>
	/// HTTP method for network traces.
	/// </summary>
	public string? Method { get; set; }

	/// <summary>
	/// HTTP status code for response traces.
	/// </summary>
	public int? StatusCode { get; set; }

	/// <summary>
	/// Request/response body (truncated to 10KB).
	/// </summary>
	public string? Body { get; set; }

	/// <summary>
	/// CDP domain and method that generated this trace.
	/// </summary>
	public string? CdpMethod { get; set; }

	/// <summary>
	/// Additional metadata.
	/// </summary>
	public Dictionary<string, string> Metadata { get; set; } = new();

	/// <summary>
	/// When the trace was captured.
	/// </summary>
	public DateTime CapturedAt { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// Duration in milliseconds for request/response pairs.
	/// </summary>
	public long? DurationMs { get; set; }
}

using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

namespace P4NTHE0N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 1: Envelope wrapping any domain event for persistence and telemetry.
/// Every domain event gets a unique eventId, correlation context, and schema version.
/// </summary>
public sealed class DomainEventEnvelope
{
	[BsonId]
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>Globally unique event identifier for deduplication and indexing.</summary>
	public string EventId { get; set; }

	/// <summary>Schema version for forward-compatible deserialization.</summary>
	public int SchemaVersion { get; set; } = 1;

	/// <summary>Event contract version for safe reader evolution.</summary>
	public int EventVersion { get; set; } = 1;

	/// <summary>Aggregate stream version when event was emitted.</summary>
	public int AggregateVersion { get; set; }

	/// <summary>Aggregate identifier for event stream filtering.</summary>
	public string AggregateId { get; set; } = string.Empty;

	/// <summary>Correlation ID linking this event to a logical operation chain.</summary>
	public string CorrelationId { get; set; } = string.Empty;

	/// <summary>Session ID of the H4ND execution that produced this event.</summary>
	public string SessionId { get; set; } = string.Empty;

	/// <summary>Fully qualified event type name (e.g. "SpinCompleted", "LoginFailed").</summary>
	public string EventType { get; set; } = string.Empty;

	/// <summary>Source component that raised the event.</summary>
	public string Source { get; set; } = string.Empty;

	/// <summary>UTC timestamp when the event was created.</summary>
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	/// <summary>Serialized event payload (BsonDocument for flexible schema).</summary>
	public BsonDocument? Payload { get; set; }

	/// <summary>Optional worker ID for parallel execution context.</summary>
	public string? WorkerId { get; set; }

	/// <summary>Optional operation name for structured tracing.</summary>
	public string? OperationName { get; set; }

	public DomainEventEnvelope()
	{
		EventId = Guid.NewGuid().ToString("D");
	}

	public static DomainEventEnvelope Create(
		string eventType,
		string source,
		string aggregateId,
		int aggregateVersion,
		int eventVersion = 1,
		BsonDocument? payload = null,
		CorrelationContext? context = null)
	{
		var ctx = context ?? CorrelationContext.Current;
		return new DomainEventEnvelope
		{
			EventType = Guard.NotNullOrWhiteSpace(eventType),
			Source = Guard.NotNullOrWhiteSpace(source),
			AggregateId = Guard.NotNullOrWhiteSpace(aggregateId),
			AggregateVersion = Guard.NonNegative(aggregateVersion),
			EventVersion = Guard.Positive(eventVersion),
			Payload = payload,
			CorrelationId = ctx?.CorrelationId.ToString() ?? string.Empty,
			SessionId = ctx?.SessionId.ToString() ?? string.Empty,
			WorkerId = ctx?.WorkerId,
			OperationName = ctx?.OperationName?.ToString(),
		};
	}
}

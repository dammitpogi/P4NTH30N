using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Domain event log document for L0G_D0M41N.
/// Wraps DomainEventEnvelope for persistence. Has unique eventId index.
/// </summary>
public sealed class DomainLogEntry
{
	[BsonId]
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	public int SchemaVersion { get; set; } = 1;

	/// <summary>Unique event ID — indexed unique in L0G_D0M41N.</summary>
	public string EventId { get; set; } = Guid.NewGuid().ToString("D");

	public string CorrelationId { get; set; } = string.Empty;
	public string SessionId { get; set; } = string.Empty;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public int EventVersion { get; set; } = 1;
	public int AggregateVersion { get; set; }
	public string AggregateId { get; set; } = string.Empty;

	public string EventType { get; set; } = string.Empty;
	public string Source { get; set; } = string.Empty;
	public BsonDocument? Payload { get; set; }
	public string? WorkerId { get; set; }
	public string? OperationName { get; set; }
}

using System;
using System.Collections.Generic;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Operational log document for L0G_0P3R4T10NAL.
/// Runtime events: startup, shutdown, config changes, health checks.
/// </summary>
public sealed class OperationalLogEntry
{
	[BsonId]
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	public int SchemaVersion { get; set; } = 1;
	public string CorrelationId { get; set; } = string.Empty;
	public string SessionId { get; set; } = string.Empty;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	[BsonRepresentation(BsonType.String)]
	public StructuredLogLevel Level { get; set; } = StructuredLogLevel.Info;

	public string Source { get; set; } = string.Empty;
	public string Message { get; set; } = string.Empty;
	public string? WorkerId { get; set; }
	public string? OperationName { get; set; }
	public Dictionary<string, object>? Properties { get; set; }
	public string? ExceptionType { get; set; }
	public string? ExceptionMessage { get; set; }
	public string? StackTrace { get; set; }
}

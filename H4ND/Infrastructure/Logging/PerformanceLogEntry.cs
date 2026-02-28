using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Performance log document for L0G_P3RF0RM4NC3.
/// Tracks operation durations, throughput, resource usage.
/// </summary>
public sealed class PerformanceLogEntry
{
	[BsonId]
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	public int SchemaVersion { get; set; } = 1;
	public string CorrelationId { get; set; } = string.Empty;
	public string SessionId { get; set; } = string.Empty;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	public string OperationName { get; set; } = string.Empty;
	public double DurationMs { get; set; }
	public bool Success { get; set; }
	public string? WorkerId { get; set; }
	public string? Source { get; set; }
	public string? ErrorMessage { get; set; }
	public long? MemoryBytesUsed { get; set; }
	public int? ActiveThreads { get; set; }
}

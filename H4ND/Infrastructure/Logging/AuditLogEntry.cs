using System;
using System.Collections.Generic;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Audit log document for L0G_4UD1T.
/// Tracks credential access, spin authorization, balance mutations.
/// </summary>
public sealed class AuditLogEntry
{
	[BsonId]
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	public int SchemaVersion { get; set; } = 1;
	public string CorrelationId { get; set; } = string.Empty;
	public string SessionId { get; set; } = string.Empty;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;

	public string Action { get; set; } = string.Empty;
	public string Actor { get; set; } = string.Empty;
	public string? Target { get; set; }
	public string? Outcome { get; set; }
	public string? Reason { get; set; }
	public string? WorkerId { get; set; }
	public Dictionary<string, object>? Details { get; set; }
}

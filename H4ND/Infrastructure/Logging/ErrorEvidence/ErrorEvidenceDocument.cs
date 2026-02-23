using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorEvidenceDocument
{
	[BsonId]
	public ObjectId Id { get; set; } = ObjectId.GenerateNewId();

	[BsonElement("capturedAt")]
	public DateTime CapturedAtUtc { get; set; } = DateTime.UtcNow;

	[BsonElement("expiresAt")]
	public DateTime ExpiresAtUtc { get; set; }

	[BsonElement("sessionId")]
	public string SessionId { get; set; } = string.Empty;

	[BsonElement("correlationId")]
	public string? CorrelationId { get; set; }

	[BsonElement("operationId")]
	public string? OperationId { get; set; }

	[BsonElement("component")]
	public string Component { get; set; } = string.Empty;

	[BsonElement("operation")]
	public string Operation { get; set; } = string.Empty;

	[BsonElement("severity")]
	[BsonRepresentation(BsonType.String)]
	public ErrorSeverity Severity { get; set; } = ErrorSeverity.Error;

	[BsonElement("errorCode")]
	public string? ErrorCode { get; set; }

	[BsonElement("message")]
	public string Message { get; set; } = string.Empty;

	[BsonElement("workerId")]
	public string? WorkerId { get; set; }

	[BsonElement("machineName")]
	public string? MachineName { get; set; }

	[BsonElement("processId")]
	public int? ProcessId { get; set; }

	[BsonElement("tags")]
	public List<string> Tags { get; set; } = new();

	[BsonElement("location")]
	public ErrorLocation Location { get; set; } = new();

	[BsonElement("exception")]
	public ErrorExceptionSnapshot? Exception { get; set; }

	[BsonElement("context")]
	public BsonDocument Context { get; set; } = new();

	[BsonElement("evidence")]
	public EvidenceEnvelope Evidence { get; set; } = new();

	[BsonElement("schemaVersion")]
	public int SchemaVersion { get; set; } = 1;
}

public enum ErrorSeverity
{
	Critical = 0,
	Error = 1,
	Warning = 2,
	Info = 3,
	Debug = 4,
}

using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorExceptionSnapshot
{
	[BsonElement("type")]
	public string Type { get; set; } = string.Empty;

	[BsonElement("message")]
	public string Message { get; set; } = string.Empty;

	[BsonElement("stackTrace")]
	public string? StackTrace { get; set; }

	[BsonElement("inner")]
	public ErrorExceptionSnapshot? Inner { get; set; }
}

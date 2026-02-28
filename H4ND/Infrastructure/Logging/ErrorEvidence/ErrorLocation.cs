using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorLocation
{
	[BsonElement("file")]
	public string? File { get; set; }

	[BsonElement("member")]
	public string? Member { get; set; }

	[BsonElement("line")]
	public int? Line { get; set; }
}

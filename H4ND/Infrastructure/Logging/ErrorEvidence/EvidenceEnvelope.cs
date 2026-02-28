using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class EvidenceEnvelope
{
	[BsonElement("schemaVersion")]
	public string SchemaVersion { get; set; } = "1.0";

	[BsonElement("evidenceType")]
	public string EvidenceType { get; set; } = string.Empty;

	[BsonElement("summary")]
	public string? Summary { get; set; }

	[BsonElement("isTruncated")]
	public bool IsTruncated { get; set; }

	[BsonElement("originalBytes")]
	public int OriginalBytes { get; set; }

	[BsonElement("data")]
	public BsonDocument Data { get; set; } = new();
}

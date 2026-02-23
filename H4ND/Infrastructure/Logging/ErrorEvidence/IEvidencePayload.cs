using MongoDB.Bson;

namespace P4NTH30N.H4ND.Infrastructure.Logging.ErrorEvidence;

public interface IEvidencePayload
{
	string EvidenceType { get; }
	string Version { get; }
	string? Summary { get; }
	BsonDocument ToBsonDocument();
}

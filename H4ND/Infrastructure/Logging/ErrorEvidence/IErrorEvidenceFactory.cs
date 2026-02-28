using MongoDB.Bson;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public interface IErrorEvidenceFactory
{
	ErrorEvidenceDocument Create(
		string sessionId,
		string component,
		string operation,
		ErrorSeverity severity,
		string errorCode,
		string message,
		Exception? exception,
		IEvidencePayload payload,
		BsonDocument? context = null,
		string? correlationId = null,
		string? operationId = null,
		ErrorLocation? location = null,
		IReadOnlyCollection<string>? tags = null);
}

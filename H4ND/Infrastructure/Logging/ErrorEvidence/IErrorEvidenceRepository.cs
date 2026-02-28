namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public interface IErrorEvidenceRepository
{
	Task EnsureIndexesAsync(CancellationToken ct = default);
	Task InsertAsync(ErrorEvidenceDocument document, CancellationToken ct = default);
	Task InsertManyAsync(IReadOnlyCollection<ErrorEvidenceDocument> documents, CancellationToken ct = default);
	Task<IReadOnlyList<ErrorEvidenceDocument>> QueryBySessionAsync(string sessionId, int limit, CancellationToken ct = default);
	Task<IReadOnlyList<ErrorEvidenceDocument>> QueryByCorrelationAsync(string correlationId, int limit, CancellationToken ct = default);
}

namespace P4NTH30N.H4ND.Domains.Common.Repositories;

public interface IDomainEventRepository
{
	Task<bool> AppendIfNotExistsAsync(DomainEventEnvelope envelope, CancellationToken ct = default);
	Task<IReadOnlyCollection<DomainEventEnvelope>> GetByCorrelationIdAsync(string correlationId, CancellationToken ct = default);
}

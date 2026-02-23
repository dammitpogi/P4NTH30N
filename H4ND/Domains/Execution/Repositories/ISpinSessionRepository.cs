using P4NTH30N.H4ND.Domains.Execution.Aggregates;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Execution.Repositories;

public interface ISpinSessionRepository
{
	Task<SpinSession?> GetByIdAsync(SpinId spinId, CancellationToken ct = default);
	Task<IReadOnlyCollection<SpinSession>> GetByCredentialAsync(string credentialId, CancellationToken ct = default);
	Task AddOrUpdateAsync(SpinSession session, CancellationToken ct = default);
}

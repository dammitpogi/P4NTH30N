using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Automation.Repositories;

public interface ICredentialRepository
{
	Task<Credential?> GetByIdAsync(CredentialId credentialId, CancellationToken ct = default);
	Task<Credential?> GetByIdentityAsync(Username username, string house, string game, CancellationToken ct = default);
	Task<IReadOnlyCollection<Credential>> GetUnlockedAsync(CancellationToken ct = default);
	Task AddOrUpdateAsync(Credential credential, CancellationToken ct = default);
	Task DeleteAsync(CredentialId credentialId, CancellationToken ct = default);
}

using P4NTH30N.H4ND.Domains.Automation.Aggregates;

namespace P4NTH30N.H4ND.Domains.Automation.Repositories;

public interface ISignalQueueRepository
{
	Task<SignalQueue?> GetByIdAsync(string queueId, CancellationToken ct = default);
	Task AddOrUpdateAsync(SignalQueue queue, CancellationToken ct = default);
	Task DeleteAsync(string queueId, CancellationToken ct = default);
}

using P4NTHE0N.H4ND.Domains.Monitoring.ValueObjects;
using AggregateHealthCheck = P4NTHE0N.H4ND.Domains.Monitoring.Aggregates.HealthCheck;

namespace P4NTHE0N.H4ND.Domains.Monitoring.Repositories;

public interface IHealthCheckRepository
{
	Task<AggregateHealthCheck?> GetByComponentAsync(ComponentName componentName, CancellationToken ct = default);
	Task<IReadOnlyCollection<AggregateHealthCheck>> GetDegradedAsync(CancellationToken ct = default);
	Task AddOrUpdateAsync(AggregateHealthCheck healthCheck, CancellationToken ct = default);
}

using MongoDB.Driver;
using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Monitoring.Repositories;
using P4NTH30N.H4ND.Domains.Monitoring.ValueObjects;
using AggregateHealthCheck = P4NTH30N.H4ND.Domains.Monitoring.Aggregates.HealthCheck;
using DomainHealthStatus = P4NTH30N.H4ND.Domains.Monitoring.ValueObjects.HealthStatus;

namespace P4NTH30N.H4ND.Infrastructure.Persistence;

public sealed class MongoDbHealthCheckRepository : IHealthCheckRepository
{
	private readonly IMongoCollection<HealthCheckDocument> _collection;

	public MongoDbHealthCheckRepository(MongoDbContext context)
	{
		_collection = context.HealthChecks;
	}

	public async Task<AggregateHealthCheck?> GetByComponentAsync(ComponentName componentName, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var filter = Builders<HealthCheckDocument>.Filter.Eq(x => x.Component, componentName.Value);
		var row = await _collection.Find(filter).FirstOrDefaultAsync(ct);
		return row is null ? null : ToAggregate(row);
	}

	public async Task<IReadOnlyCollection<AggregateHealthCheck>> GetDegradedAsync(CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var filter = Builders<HealthCheckDocument>.Filter.Eq(x => x.Status, DomainHealthStatus.Degraded.ToString());
		var rows = await _collection.Find(filter).ToListAsync(ct);
		return rows.Select(ToAggregate).ToArray();
	}

	public async Task AddOrUpdateAsync(AggregateHealthCheck healthCheck, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		Guard.NotNull(healthCheck);

		var row = new HealthCheckDocument
		{
			HealthCheckId = healthCheck.HealthCheckId,
			Component = healthCheck.Component.Value,
			Status = healthCheck.Status.ToString(),
			Metrics = healthCheck.Metrics.Select(x => new HealthMetricDocument
			{
				Name = x.Name,
				Value = x.Value,
				Threshold = x.Threshold,
				ObservedAtUtc = x.ObservedAtUtc,
			}).ToList(),
			AggregateVersion = healthCheck.Version,
		};

		var filter = Builders<HealthCheckDocument>.Filter.Eq(x => x.Component, row.Component);
		await _collection.ReplaceOneAsync(filter, row, new ReplaceOptions { IsUpsert = true }, ct);
	}

	private static AggregateHealthCheck ToAggregate(HealthCheckDocument row)
	{
		var metrics = row.Metrics.Select(x => new HealthMetric(x.Name, x.Value, x.Threshold, x.ObservedAtUtc));
		var status = Enum.TryParse<DomainHealthStatus>(row.Status, ignoreCase: true, out var parsed)
			? parsed
			: DomainHealthStatus.Unhealthy;
		return new AggregateHealthCheck(row.HealthCheckId, new ComponentName(row.Component), status, metrics, row.AggregateVersion);
	}
}

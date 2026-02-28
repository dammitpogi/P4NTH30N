using MongoDB.Driver;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Domains.Execution.Aggregates;
using P4NTHE0N.H4ND.Domains.Execution.Repositories;
using P4NTHE0N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTHE0N.H4ND.Infrastructure.Persistence;

public sealed class MongoDbSpinSessionRepository : ISpinSessionRepository
{
	private readonly IMongoCollection<SpinSessionDocument> _collection;

	public MongoDbSpinSessionRepository(MongoDbContext context)
	{
		_collection = context.SpinSessions;
	}

	public async Task<SpinSession?> GetByIdAsync(SpinId spinId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var filter = Builders<SpinSessionDocument>.Filter.Eq(x => x.SpinId, spinId.Value);
		var row = await _collection.Find(filter).FirstOrDefaultAsync(ct);
		return row is null ? null : ToAggregate(row);
	}

	public async Task<IReadOnlyCollection<SpinSession>> GetByCredentialAsync(string credentialId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var normalizedCredentialId = Guard.MaxLength(credentialId, 128);
		var filter = Builders<SpinSessionDocument>.Filter.Eq(x => x.CredentialId, normalizedCredentialId);
		var rows = await _collection.Find(filter).ToListAsync(ct);
		return rows.Select(ToAggregate).ToArray();
	}

	public async Task AddOrUpdateAsync(SpinSession session, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		Guard.NotNull(session);

		var row = new SpinSessionDocument
		{
			SpinId = session.SpinId.Value,
			CredentialId = session.CredentialId,
			StartedAtUtc = session.StartedAtUtc,
			CompletedAtUtc = session.CompletedAtUtc,
			Success = session.Result?.Success,
			BalanceBefore = session.Result?.BalanceBefore,
			BalanceAfter = session.Result?.BalanceAfter,
			WagerAmount = session.Result?.WagerAmount,
			FailureReason = session.Result?.FailureReason,
			AggregateVersion = session.Version,
		};

		var filter = Builders<SpinSessionDocument>.Filter.Eq(x => x.SpinId, row.SpinId);
		await _collection.ReplaceOneAsync(filter, row, new ReplaceOptions { IsUpsert = true }, ct);
	}

	private static SpinSession ToAggregate(SpinSessionDocument row)
	{
		SpinResult? result = null;
		if (row.Success.HasValue)
		{
			result = new SpinResult(
				row.Success.Value,
				row.BalanceBefore ?? 0m,
				row.BalanceAfter ?? 0m,
				row.WagerAmount ?? 0m,
				row.FailureReason);
		}

		return new SpinSession(
			new SpinId(row.SpinId),
			row.CredentialId,
			row.StartedAtUtc,
			result,
			row.CompletedAtUtc,
			row.AggregateVersion);
	}
}

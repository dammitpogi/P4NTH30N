using MongoDB.Driver;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Domains.Common.Repositories;

namespace P4NTHE0N.H4ND.Infrastructure.Persistence;

public sealed class MongoDomainEventRepository : IDomainEventRepository
{
	private readonly IMongoCollection<DomainEventEnvelope> _collection;

	public MongoDomainEventRepository(MongoDbContext context)
	{
		_collection = context.DomainEvents;
	}

	public async Task<bool> AppendIfNotExistsAsync(DomainEventEnvelope envelope, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		Guard.NotNull(envelope);

		try
		{
			await _collection.InsertOneAsync(envelope, cancellationToken: ct);
			return true;
		}
		catch (MongoWriteException ex) when (ex.WriteError?.Category == ServerErrorCategory.DuplicateKey)
		{
			return false;
		}
	}

	public async Task<IReadOnlyCollection<DomainEventEnvelope>> GetByCorrelationIdAsync(string correlationId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var normalizedCorrelationId = Guard.MaxLength(correlationId, 128);

		var filter = Builders<DomainEventEnvelope>.Filter.Eq(x => x.CorrelationId, normalizedCorrelationId);
		var sort = Builders<DomainEventEnvelope>.Sort.Descending(x => x.Timestamp);
		var rows = await _collection.Find(filter).Sort(sort).ToListAsync(ct);
		return rows;
	}
}

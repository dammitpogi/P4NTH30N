using MongoDB.Driver;
using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Automation.Repositories;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Infrastructure.Persistence;

public sealed class MongoDbSignalQueueRepository : ISignalQueueRepository
{
	private readonly IMongoCollection<SignalQueueDocument> _collection;

	public MongoDbSignalQueueRepository(MongoDbContext context)
	{
		_collection = context.SignalQueues;
	}

	public async Task<SignalQueue?> GetByIdAsync(string queueId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var normalizedQueueId = Guard.MaxLength(queueId, 128);
		var filter = Builders<SignalQueueDocument>.Filter.Eq(x => x.QueueId, normalizedQueueId);
		var row = await _collection.Find(filter).FirstOrDefaultAsync(ct);
		if (row is null)
		{
			return null;
		}

		var snapshot = row.Signals.Select(x => new QueuedSignal(x.SignalId, x.CredentialId, x.Username, x.House, x.Game, x.Priority));
		return new SignalQueue(row.QueueId, snapshot, row.AggregateVersion);
	}

	public async Task AddOrUpdateAsync(SignalQueue queue, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		Guard.NotNull(queue);

		var row = new SignalQueueDocument
		{
			QueueId = queue.QueueId,
			AggregateVersion = queue.Version,
			Signals = queue.Snapshot().Select(x => new SignalDocument
			{
				SignalId = x.SignalId,
				CredentialId = x.CredentialId,
				Username = x.Username,
				House = x.House,
				Game = x.Game,
				Priority = x.Priority,
			}).ToList(),
		};

		var filter = Builders<SignalQueueDocument>.Filter.Eq(x => x.QueueId, row.QueueId);
		await _collection.ReplaceOneAsync(filter, row, new ReplaceOptions { IsUpsert = true }, ct);
	}

	public async Task DeleteAsync(string queueId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var normalizedQueueId = Guard.MaxLength(queueId, 128);
		var filter = Builders<SignalQueueDocument>.Filter.Eq(x => x.QueueId, normalizedQueueId);
		await _collection.DeleteOneAsync(filter, ct);
	}
}

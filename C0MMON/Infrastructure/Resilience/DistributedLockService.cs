using System;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Driver;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.C0MMON.Infrastructure.Resilience;

public class DistributedLock
{
	[BsonId]
	public string Resource { get; set; } = string.Empty;
	public string Owner { get; set; } = string.Empty;
	public DateTime AcquiredAtUtc { get; set; } = DateTime.UtcNow;
	public DateTime ExpiresAtUtc { get; set; }
}

public interface IDistributedLockService
{
	bool TryAcquire(string resource, string owner, TimeSpan ttl);
	void Release(string resource, string owner);
	bool IsHeld(string resource);
}

public sealed class DistributedLockService : IDistributedLockService
{
	private readonly IMongoCollection<DistributedLock> _locks;
	private readonly Action<string>? _logger;
	private static bool s_indexCreated;
	private static readonly object s_indexLock = new();

	public const string CollectionName = "L0CK";

	public DistributedLockService(IMongoDatabaseProvider provider, Action<string>? logger = null)
	{
		_locks = provider.Database.GetCollection<DistributedLock>(CollectionName);
		_logger = logger;
		EnsureTtlIndex();
	}

	public DistributedLockService(IMongoCollection<DistributedLock> collection, Action<string>? logger = null)
	{
		_locks = collection;
		_logger = logger;
	}

	private void EnsureTtlIndex()
	{
		if (s_indexCreated)
			return;
		lock (s_indexLock)
		{
			if (s_indexCreated)
				return;
			try
			{
				CreateIndexModel<DistributedLock> indexModel = new(
					Builders<DistributedLock>.IndexKeys.Ascending(x => x.ExpiresAtUtc),
					new CreateIndexOptions { ExpireAfter = TimeSpan.Zero, Name = "ttl_expires" }
				);
				_locks.Indexes.CreateOne(indexModel);
				s_indexCreated = true;
			}
			catch (Exception ex)
			{
				_logger?.Invoke($"[DistributedLock] TTL index creation failed: {ex.Message}");
			}
		}
	}

	public bool TryAcquire(string resource, string owner, TimeSpan ttl)
	{
		DateTime now = DateTime.UtcNow;
		DateTime expiresAt = now.Add(ttl);

		try
		{
			// Attempt atomic insert-if-not-exists using upsert with condition
			// Only insert if no unexpired lock exists
			FilterDefinition<DistributedLock> filter = Builders<DistributedLock>.Filter.And(
				Builders<DistributedLock>.Filter.Eq(x => x.Resource, resource),
				Builders<DistributedLock>.Filter.Gt(x => x.ExpiresAtUtc, now)
			);

			DistributedLock? existing = _locks.Find(filter).FirstOrDefault();
			if (existing != null)
			{
				if (existing.Owner == owner)
				{
					// Re-entrant: same owner, extend TTL
					UpdateDefinition<DistributedLock> extend = Builders<DistributedLock>.Update.Set(x => x.ExpiresAtUtc, expiresAt).Set(x => x.AcquiredAtUtc, now);
					_locks.UpdateOne(filter, extend);
					return true;
				}
				return false;
			}

			// No active lock — try to insert atomically
			// Use findAndModify with upsert to avoid race between the check above and insert
			FilterDefinition<DistributedLock> insertFilter = Builders<DistributedLock>.Filter.And(
				Builders<DistributedLock>.Filter.Eq(x => x.Resource, resource),
				Builders<DistributedLock>.Filter.Or(
					Builders<DistributedLock>.Filter.Exists(x => x.ExpiresAtUtc, false),
					Builders<DistributedLock>.Filter.Lte(x => x.ExpiresAtUtc, now)
				)
			);

			UpdateDefinition<DistributedLock> update = Builders<DistributedLock>
				.Update.Set(x => x.Owner, owner)
				.Set(x => x.AcquiredAtUtc, now)
				.Set(x => x.ExpiresAtUtc, expiresAt)
				.SetOnInsert(x => x.Resource, resource);

			FindOneAndUpdateOptions<DistributedLock> options = new() { IsUpsert = true, ReturnDocument = ReturnDocument.After };

			DistributedLock? result = _locks.FindOneAndUpdate(insertFilter, update, options);
			bool acquired = result != null && result.Owner == owner;

			return acquired;
		}
		catch (MongoCommandException ex) when (ex.Code == 11000)
		{
			// Duplicate key — another instance beat us to it
			return false;
		}
		catch (Exception ex)
		{
			_logger?.Invoke($"[DistributedLock] Error acquiring '{resource}': {ex.Message}");
			return false;
		}
	}

	public void Release(string resource, string owner)
	{
		try
		{
			FilterDefinition<DistributedLock> filter = Builders<DistributedLock>.Filter.And(
				Builders<DistributedLock>.Filter.Eq(x => x.Resource, resource),
				Builders<DistributedLock>.Filter.Eq(x => x.Owner, owner)
			);
			_locks.DeleteOne(filter);
		}
		catch (Exception ex)
		{
			_logger?.Invoke($"[DistributedLock] Error releasing '{resource}': {ex.Message}");
		}
	}

	public bool IsHeld(string resource)
	{
		try
		{
			FilterDefinition<DistributedLock> filter = Builders<DistributedLock>.Filter.And(
				Builders<DistributedLock>.Filter.Eq(x => x.Resource, resource),
				Builders<DistributedLock>.Filter.Gt(x => x.ExpiresAtUtc, DateTime.UtcNow)
			);
			return _locks.Find(filter).Any();
		}
		catch
		{
			return false;
		}
	}
}

public sealed class InMemoryDistributedLockService : IDistributedLockService
{
	private readonly System.Collections.Concurrent.ConcurrentDictionary<string, (string Owner, DateTime ExpiresUtc)> _locks = new();

	public bool TryAcquire(string resource, string owner, TimeSpan ttl)
	{
		DateTime now = DateTime.UtcNow;
		DateTime expiresAt = now.Add(ttl);

		return _locks
				.AddOrUpdate(
					resource,
					_ => (owner, expiresAt),
					(_, existing) =>
					{
						if (existing.ExpiresUtc <= now || existing.Owner == owner)
							return (owner, expiresAt);
						return existing;
					}
				)
				.Owner == owner;
	}

	public void Release(string resource, string owner)
	{
		if (_locks.TryGetValue(resource, out (string Owner, DateTime ExpiresUtc) existing) && existing.Owner == owner)
		{
			_locks.TryRemove(resource, out _);
		}
	}

	public bool IsHeld(string resource)
	{
		return _locks.TryGetValue(resource, out (string Owner, DateTime ExpiresUtc) existing) && existing.ExpiresUtc > DateTime.UtcNow;
	}
}

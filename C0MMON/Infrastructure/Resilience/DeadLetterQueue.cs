using System;
using System.Collections.Generic;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Driver;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON.Infrastructure.Resilience;

public class DeadLetterEntry
{
	[BsonId]
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public string Source { get; set; } = string.Empty;
	public string Reason { get; set; } = string.Empty;
	public string SignalKey { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public float Priority { get; set; }
	public string? ErrorMessage { get; set; }
	public string? StackTrace { get; set; }
	public int RetryCount { get; set; }
	public bool Reprocessed { get; set; }
	public DateTime? ReprocessedAt { get; set; }
}

public interface IDeadLetterQueue
{
	void Enqueue(Signal signal, string reason, Exception? exception = null, int retryCount = 0);
	List<DeadLetterEntry> GetAll();
	List<DeadLetterEntry> GetUnprocessed();
	void MarkReprocessed(ObjectId id);
	long Count { get; }
}

public sealed class DeadLetterQueue : IDeadLetterQueue
{
	private readonly IMongoCollection<DeadLetterEntry> _collection;
	private readonly Action<string>? _logger;

	public const string CollectionName = "D34DL3TT3R";

	public long Count => _collection.CountDocuments(Builders<DeadLetterEntry>.Filter.Empty);

	public DeadLetterQueue(IMongoDatabaseProvider provider, Action<string>? logger = null)
	{
		_collection = provider.Database.GetCollection<DeadLetterEntry>(CollectionName);
		_logger = logger;
	}

	public DeadLetterQueue(IMongoCollection<DeadLetterEntry> collection, Action<string>? logger = null)
	{
		_collection = collection;
		_logger = logger;
	}

	public void Enqueue(Signal signal, string reason, Exception? exception = null, int retryCount = 0)
	{
		try
		{
			DeadLetterEntry entry = new()
			{
				Source = "H0UND",
				Reason = reason,
				SignalKey = SignalDeduplicationCache.BuildKey(signal),
				House = signal.House,
				Game = signal.Game,
				Username = signal.Username,
				Priority = signal.Priority,
				ErrorMessage = exception?.Message,
				StackTrace = exception?.StackTrace,
				RetryCount = retryCount,
			};
			_collection.InsertOne(entry);
			_logger?.Invoke($"[DeadLetter] Enqueued signal {entry.SignalKey}: {reason}");
		}
		catch (Exception ex)
		{
			_logger?.Invoke($"[DeadLetter] Failed to enqueue: {ex.Message}");
		}
	}

	public List<DeadLetterEntry> GetAll()
	{
		return _collection.Find(Builders<DeadLetterEntry>.Filter.Empty).SortByDescending(e => e.Timestamp).ToList();
	}

	public List<DeadLetterEntry> GetUnprocessed()
	{
		return _collection.Find(Builders<DeadLetterEntry>.Filter.Eq(e => e.Reprocessed, false)).SortByDescending(e => e.Timestamp).ToList();
	}

	public void MarkReprocessed(ObjectId id)
	{
		FilterDefinition<DeadLetterEntry> filter = Builders<DeadLetterEntry>.Filter.Eq(e => e._id, id);
		UpdateDefinition<DeadLetterEntry> update = Builders<DeadLetterEntry>.Update.Set(e => e.Reprocessed, true).Set(e => e.ReprocessedAt, DateTime.UtcNow);
		_collection.UpdateOne(filter, update);
	}
}

public sealed class InMemoryDeadLetterQueue : IDeadLetterQueue
{
	private readonly List<DeadLetterEntry> _entries = new();
	private readonly object _lock = new();

	public long Count
	{
		get
		{
			lock (_lock)
			{
				return _entries.Count;
			}
		}
	}

	public void Enqueue(Signal signal, string reason, Exception? exception = null, int retryCount = 0)
	{
		lock (_lock)
		{
			_entries.Add(
				new DeadLetterEntry
				{
					Source = "H0UND",
					Reason = reason,
					SignalKey = SignalDeduplicationCache.BuildKey(signal),
					House = signal.House,
					Game = signal.Game,
					Username = signal.Username,
					Priority = signal.Priority,
					ErrorMessage = exception?.Message,
					StackTrace = exception?.StackTrace,
					RetryCount = retryCount,
				}
			);
		}
	}

	public List<DeadLetterEntry> GetAll()
	{
		lock (_lock)
		{
			return new List<DeadLetterEntry>(_entries);
		}
	}

	public List<DeadLetterEntry> GetUnprocessed()
	{
		lock (_lock)
		{
			return _entries.Where(e => !e.Reprocessed).ToList();
		}
	}

	public void MarkReprocessed(ObjectId id)
	{
		lock (_lock)
		{
			DeadLetterEntry? entry = _entries.FirstOrDefault(e => e._id == id);
			if (entry != null)
			{
				entry.Reprocessed = true;
				entry.ReprocessedAt = DateTime.UtcNow;
			}
		}
	}

	public void Clear()
	{
		lock (_lock)
		{
			_entries.Clear();
		}
	}
}

using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace P4NTH30N.C0MMON.Infrastructure.Resilience;

public interface ISignalDeduplicationCache
{
	bool IsProcessed(string signalKey);
	void MarkProcessed(string signalKey);
	void Evict(string signalKey);
	int Count { get; }
	long DeduplicatedCount { get; }
	void Clear();
}

public sealed class SignalDeduplicationCache : ISignalDeduplicationCache
{
	private readonly ConcurrentDictionary<string, DateTime> _cache = new();
	private readonly TimeSpan _ttl;
	private readonly int _maxEntries;
	private long _deduplicatedCount;
	private DateTime _lastEvictionUtc = DateTime.UtcNow;
	private readonly object _evictionLock = new();

	public int Count => _cache.Count;
	public long DeduplicatedCount => Interlocked.Read(ref _deduplicatedCount);

	public SignalDeduplicationCache(TimeSpan? ttl = null, int maxEntries = 10_000)
	{
		_ttl = ttl ?? TimeSpan.FromMinutes(5);
		_maxEntries = maxEntries;
	}

	public bool IsProcessed(string signalKey)
	{
		EvictExpiredIfNeeded();

		if (_cache.TryGetValue(signalKey, out DateTime expiresUtc))
		{
			if (expiresUtc > DateTime.UtcNow)
			{
				Interlocked.Increment(ref _deduplicatedCount);
				return true;
			}
			// Expired — remove and allow re-processing
			_cache.TryRemove(signalKey, out _);
		}
		return false;
	}

	public void MarkProcessed(string signalKey)
	{
		_cache[signalKey] = DateTime.UtcNow.Add(_ttl);
		EvictIfOverCapacity();
	}

	public void Evict(string signalKey)
	{
		_cache.TryRemove(signalKey, out _);
	}

	public void Clear()
	{
		_cache.Clear();
		Interlocked.Exchange(ref _deduplicatedCount, 0);
	}

	private void EvictExpiredIfNeeded()
	{
		// Only run eviction every 30 seconds to avoid overhead
		if ((DateTime.UtcNow - _lastEvictionUtc).TotalSeconds < 30)
			return;

		lock (_evictionLock)
		{
			if ((DateTime.UtcNow - _lastEvictionUtc).TotalSeconds < 30)
				return;

			DateTime now = DateTime.UtcNow;
			List<string> expired = _cache.Where(kv => kv.Value <= now).Select(kv => kv.Key).ToList();
			foreach (string key in expired)
			{
				_cache.TryRemove(key, out _);
			}
			_lastEvictionUtc = now;
		}
	}

	private void EvictIfOverCapacity()
	{
		if (_cache.Count <= _maxEntries)
			return;

		// Evict oldest entries (LRU approximation)
		List<KeyValuePair<string, DateTime>> sorted = _cache.OrderBy(kv => kv.Value).Take(_cache.Count - _maxEntries + 100).ToList();
		foreach (KeyValuePair<string, DateTime> kv in sorted)
		{
			_cache.TryRemove(kv.Key, out _);
		}
	}

	public static string BuildKey(string house, string game, string username)
	{
		return $"{house}:{game}:{username}";
	}

	public static string BuildKey(Signal signal)
	{
		return $"{signal.House}:{signal.Game}:{signal.Username}";
	}
}

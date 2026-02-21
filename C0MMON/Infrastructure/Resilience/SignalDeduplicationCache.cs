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

	// DECISION_074: Tier-based TTLs — higher tiers expire faster to allow rapid re-signaling
	private static readonly Dictionary<int, TimeSpan> s_tierTtl = new()
	{
		[4] = TimeSpan.FromMinutes(1), // Grand
		[3] = TimeSpan.FromMinutes(2), // Major
		[2] = TimeSpan.FromMinutes(3), // Minor
		[1] = TimeSpan.FromMinutes(5), // Mini
	};

	public SignalDeduplicationCache(TimeSpan? ttl = null, int maxEntries = 10_000)
	{
		// DECISION_074: Reduced default TTL from 5min to 2min
		_ttl = ttl ?? TimeSpan.FromMinutes(2);
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

	// DECISION_074: Overload that uses tier-based TTL
	public void MarkProcessed(string signalKey, int priority)
	{
		TimeSpan ttl = s_tierTtl.TryGetValue(priority, out TimeSpan tierTtl) ? tierTtl : _ttl;
		_cache[signalKey] = DateTime.UtcNow.Add(ttl);
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
		// DECISION_074: Include Priority in key so different-tier signals are not conflated
		return $"{signal.House}:{signal.Game}:{signal.Username}:{signal.Priority}";
	}
}

using System.Collections.Concurrent;

namespace P4NTH30N.C0MMON.Infrastructure.Caching;

/// <summary>
/// In-memory cache with TTL expiration for frequently accessed data.
/// Reduces MongoDB query load for jackpot thresholds, credential metadata, etc.
/// </summary>
/// <remarks>
/// INFRA-007: Performance Optimization and Resource Management.
/// Zero external dependencies — uses ConcurrentDictionary with lazy cleanup.
/// </remarks>
public sealed class CacheService
{
	private readonly ConcurrentDictionary<string, CacheEntry> _cache = new();
	private readonly TimeSpan _defaultTtl;
	private DateTime _lastCleanup = DateTime.UtcNow;
	private readonly TimeSpan _cleanupInterval = TimeSpan.FromMinutes(5);

	/// <summary>
	/// Creates a CacheService with the specified default TTL.
	/// </summary>
	/// <param name="defaultTtlSeconds">Default time-to-live in seconds. Default: 60.</param>
	public CacheService(int defaultTtlSeconds = 60)
	{
		_defaultTtl = TimeSpan.FromSeconds(defaultTtlSeconds);
	}

	/// <summary>
	/// Gets a value from cache, or computes and caches it if missing/expired.
	/// </summary>
	/// <typeparam name="T">Type of cached value.</typeparam>
	/// <param name="key">Cache key.</param>
	/// <param name="factory">Factory to compute the value if not cached.</param>
	/// <param name="ttl">Optional TTL override.</param>
	/// <returns>Cached or freshly computed value.</returns>
	public T GetOrSet<T>(string key, Func<T> factory, TimeSpan? ttl = null)
	{
		LazyCleanup();

		if (_cache.TryGetValue(key, out CacheEntry? entry) && !entry.IsExpired)
		{
			entry.Hits++;
			return (T)entry.Value!;
		}

		T value = factory();
		_cache[key] = new CacheEntry { Value = value, ExpiresAt = DateTime.UtcNow + (ttl ?? _defaultTtl) };
		return value;
	}

	/// <summary>
	/// Gets a value from cache, or computes and caches it asynchronously.
	/// </summary>
	public async Task<T> GetOrSetAsync<T>(string key, Func<Task<T>> factory, TimeSpan? ttl = null)
	{
		LazyCleanup();

		if (_cache.TryGetValue(key, out CacheEntry? entry) && !entry.IsExpired)
		{
			entry.Hits++;
			return (T)entry.Value!;
		}

		T value = await factory();
		_cache[key] = new CacheEntry { Value = value, ExpiresAt = DateTime.UtcNow + (ttl ?? _defaultTtl) };
		return value;
	}

	/// <summary>
	/// Explicitly sets a cache value.
	/// </summary>
	public void Set<T>(string key, T value, TimeSpan? ttl = null)
	{
		_cache[key] = new CacheEntry { Value = value, ExpiresAt = DateTime.UtcNow + (ttl ?? _defaultTtl) };
	}

	/// <summary>
	/// Tries to get a cached value without computing.
	/// </summary>
	public bool TryGet<T>(string key, out T? value)
	{
		if (_cache.TryGetValue(key, out CacheEntry? entry) && !entry.IsExpired)
		{
			entry.Hits++;
			value = (T)entry.Value!;
			return true;
		}
		value = default;
		return false;
	}

	/// <summary>
	/// Invalidates a specific cache key.
	/// </summary>
	public void Invalidate(string key)
	{
		_cache.TryRemove(key, out _);
	}

	/// <summary>
	/// Invalidates all cache keys matching a prefix.
	/// </summary>
	public void InvalidateByPrefix(string prefix)
	{
		foreach (string key in _cache.Keys.Where(k => k.StartsWith(prefix)))
		{
			_cache.TryRemove(key, out _);
		}
	}

	/// <summary>
	/// Clears the entire cache.
	/// </summary>
	public void Clear()
	{
		_cache.Clear();
	}

	/// <summary>
	/// Returns cache statistics.
	/// </summary>
	public CacheStats GetStats()
	{
		int total = _cache.Count;
		int expired = _cache.Values.Count(e => e.IsExpired);
		long totalHits = _cache.Values.Sum(e => e.Hits);

		return new CacheStats
		{
			TotalEntries = total,
			ActiveEntries = total - expired,
			ExpiredEntries = expired,
			TotalHits = totalHits,
		};
	}

	/// <summary>
	/// Periodically removes expired entries.
	/// </summary>
	private void LazyCleanup()
	{
		if (DateTime.UtcNow - _lastCleanup < _cleanupInterval)
			return;

		_lastCleanup = DateTime.UtcNow;
		List<string> expired = _cache.Where(kv => kv.Value.IsExpired).Select(kv => kv.Key).ToList();
		foreach (string key in expired)
		{
			_cache.TryRemove(key, out _);
		}
	}
}

/// <summary>
/// Internal cache entry with expiration and hit tracking.
/// </summary>
internal sealed class CacheEntry
{
	public object? Value { get; init; }
	public DateTime ExpiresAt { get; init; }
	public long Hits { get; set; }
	public bool IsExpired => DateTime.UtcNow >= ExpiresAt;
}

/// <summary>
/// Cache statistics snapshot.
/// </summary>
public sealed class CacheStats
{
	public int TotalEntries { get; init; }
	public int ActiveEntries { get; init; }
	public int ExpiredEntries { get; init; }
	public long TotalHits { get; init; }
}

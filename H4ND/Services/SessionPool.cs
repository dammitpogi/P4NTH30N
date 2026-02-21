using System.Collections.Concurrent;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Services;

/// <summary>
/// DECISION_026: CDP Session Pool for isolated connections per credential.
/// Manages multiple CDP sessions via Target domain, preventing cross-contamination
/// between concurrent automation tasks.
/// </summary>
public sealed class SessionPool : IDisposable
{
	private readonly ICdpClient _cdp;
	private readonly ConcurrentDictionary<string, PooledSession> _sessions = new();
	private readonly SemaphoreSlim _createLock = new(1, 1);
	private readonly int _maxSessions;
	private bool _disposed;

	/// <summary>
	/// Number of active sessions.
	/// </summary>
	public int ActiveCount => _sessions.Count;

	/// <summary>
	/// Maximum concurrent sessions allowed.
	/// </summary>
	public int MaxSessions => _maxSessions;

	public SessionPool(ICdpClient cdpClient, int maxSessions = 5)
	{
		_cdp = cdpClient ?? throw new ArgumentNullException(nameof(cdpClient));
		_maxSessions = Math.Max(1, maxSessions);
	}

	/// <summary>
	/// Gets or creates an isolated CDP session for a credential.
	/// </summary>
	/// <param name="username">Credential username as session key.</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>A pooled session with its own target context.</returns>
	public async Task<PooledSession> GetSessionAsync(string username, CancellationToken ct = default)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (_sessions.TryGetValue(username, out var existing) && existing.IsHealthy)
		{
			existing.LastAccessed = DateTime.UtcNow;
			return existing;
		}

		await _createLock.WaitAsync(ct);
		try
		{
			// Double-check after acquiring lock
			if (_sessions.TryGetValue(username, out existing) && existing.IsHealthy)
			{
				existing.LastAccessed = DateTime.UtcNow;
				return existing;
			}

			// Evict if at capacity
			if (_sessions.Count >= _maxSessions)
			{
				EvictOldestSession();
			}

			// Create new target via CDP Target.createTarget
			string targetId;
			try
			{
				var result = await _cdp.SendCommandAsync("Target.createTarget", new { url = "about:blank" }, ct);
				targetId = result.ToString() ?? Guid.NewGuid().ToString("N");
			}
			catch
			{
				// Fallback: use a virtual session ID if Target domain is not available
				targetId = $"virtual_{username}_{DateTime.UtcNow.Ticks}";
			}

			var session = new PooledSession
			{
				Username = username,
				TargetId = targetId,
				CreatedAt = DateTime.UtcNow,
				LastAccessed = DateTime.UtcNow,
				IsHealthy = true,
			};

			_sessions[username] = session;
			Console.WriteLine($"[SessionPool] Created session for {username} (target: {targetId[..Math.Min(12, targetId.Length)]})");
			return session;
		}
		finally
		{
			_createLock.Release();
		}
	}

	/// <summary>
	/// Returns a session to the pool and marks it available.
	/// </summary>
	public void ReturnSession(string username)
	{
		if (_sessions.TryGetValue(username, out var session))
		{
			session.LastAccessed = DateTime.UtcNow;
			session.UseCount++;
		}
	}

	/// <summary>
	/// Marks a session as unhealthy (will be recreated on next access).
	/// </summary>
	public void InvalidateSession(string username)
	{
		if (_sessions.TryGetValue(username, out var session))
		{
			session.IsHealthy = false;
			Console.WriteLine($"[SessionPool] Invalidated session for {username}");
		}
	}

	/// <summary>
	/// Performs health checks on all sessions and evicts unhealthy ones.
	/// </summary>
	public async Task HealthCheckAsync(CancellationToken ct = default)
	{
		foreach (var kvp in _sessions)
		{
			var session = kvp.Value;
			if (!session.IsHealthy || (DateTime.UtcNow - session.LastAccessed).TotalMinutes > 30)
			{
				await CloseSessionAsync(kvp.Key, ct);
			}
		}
	}

	/// <summary>
	/// Gets metrics for all active sessions.
	/// </summary>
	public IReadOnlyDictionary<string, SessionMetrics> GetMetrics()
	{
		var metrics = new Dictionary<string, SessionMetrics>();
		foreach (var kvp in _sessions)
		{
			metrics[kvp.Key] = new SessionMetrics
			{
				Username = kvp.Value.Username,
				TargetId = kvp.Value.TargetId,
				CreatedAt = kvp.Value.CreatedAt,
				LastAccessed = kvp.Value.LastAccessed,
				UseCount = kvp.Value.UseCount,
				IsHealthy = kvp.Value.IsHealthy,
			};
		}
		return metrics;
	}

	private void EvictOldestSession()
	{
		var oldest = _sessions.OrderBy(s => s.Value.LastAccessed).FirstOrDefault();
		if (oldest.Key != null)
		{
			_sessions.TryRemove(oldest.Key, out _);
			Console.WriteLine($"[SessionPool] Evicted oldest session: {oldest.Key}");
		}
	}

	private async Task CloseSessionAsync(string username, CancellationToken ct)
	{
		if (_sessions.TryRemove(username, out var session))
		{
			try
			{
				await _cdp.SendCommandAsync("Target.closeTarget", new { targetId = session.TargetId }, ct);
			}
			catch { /* Best effort close */ }
		}
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;
		_sessions.Clear();
		_createLock.Dispose();
	}
}

/// <summary>
/// A pooled CDP session with its own isolated target context.
/// </summary>
public sealed class PooledSession
{
	public string Username { get; set; } = string.Empty;
	public string TargetId { get; set; } = string.Empty;
	public DateTime CreatedAt { get; set; }
	public DateTime LastAccessed { get; set; }
	public int UseCount { get; set; }
	public bool IsHealthy { get; set; }
}

/// <summary>
/// Metrics for a pooled session.
/// </summary>
public sealed class SessionMetrics
{
	public string Username { get; set; } = string.Empty;
	public string TargetId { get; set; } = string.Empty;
	public DateTime CreatedAt { get; set; }
	public DateTime LastAccessed { get; set; }
	public int UseCount { get; set; }
	public bool IsHealthy { get; set; }
}

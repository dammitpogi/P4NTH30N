using System.Collections.Concurrent;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// Phase 7: Coordinates shared CDP/session resource access across workers.
/// Enforces per-credential mutual exclusion and optional global CDP throttling.
/// </summary>
public sealed class CdpResourceCoordinator : IDisposable
{
	private readonly ConcurrentDictionary<string, SemaphoreSlim> _credentialLocks = new(StringComparer.OrdinalIgnoreCase);
	private readonly SemaphoreSlim _globalCdpGate;
	private bool _disposed;

	public CdpResourceCoordinator(int maxConcurrentCdpOperations)
	{
		if (maxConcurrentCdpOperations <= 0)
		{
			throw new ArgumentOutOfRangeException(nameof(maxConcurrentCdpOperations), maxConcurrentCdpOperations,
				"Max concurrent CDP operations must be positive.");
		}

		_globalCdpGate = new SemaphoreSlim(maxConcurrentCdpOperations, maxConcurrentCdpOperations);
	}

	public async Task<T> ExecuteForCredentialAsync<T>(string credentialKey, Func<CancellationToken, Task<T>> action, CancellationToken ct)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentException.ThrowIfNullOrWhiteSpace(credentialKey);
		ArgumentNullException.ThrowIfNull(action);

		var gate = _credentialLocks.GetOrAdd(credentialKey, _ => new SemaphoreSlim(1, 1));
		await gate.WaitAsync(ct);
		try
		{
			return await action(ct);
		}
		finally
		{
			gate.Release();
		}
	}

	public async Task<T> ExecuteCdpAsync<T>(Func<CancellationToken, Task<T>> action, CancellationToken ct)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentNullException.ThrowIfNull(action);

		await _globalCdpGate.WaitAsync(ct);
		try
		{
			return await action(ct);
		}
		finally
		{
			_globalCdpGate.Release();
		}
	}

	public async Task ExecuteCdpAsync(Func<CancellationToken, Task> action, CancellationToken ct)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentNullException.ThrowIfNull(action);

		await _globalCdpGate.WaitAsync(ct);
		try
		{
			await action(ct);
		}
		finally
		{
			_globalCdpGate.Release();
		}
	}

	public void Dispose()
	{
		if (_disposed)
		{
			return;
		}

		_disposed = true;
		foreach (var kv in _credentialLocks)
		{
			kv.Value.Dispose();
		}
		_credentialLocks.Clear();
		_globalCdpGate.Dispose();
	}
}

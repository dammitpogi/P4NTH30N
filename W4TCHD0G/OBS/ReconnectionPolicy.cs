namespace P4NTHE0N.W4TCHD0G.OBS;

/// <summary>
/// Exponential backoff reconnection policy with jitter.
/// Retries a connection attempt with increasing delays: 1s, 2s, 4s, 8s, ... up to max.
/// </summary>
/// <remarks>
/// FOUR-007 requirements:
/// - Auto-recovery time: &lt;30 seconds
/// - Max retries: 10 (configurable)
/// - Jitter: ±25% to prevent thundering herd on multi-VM setups
/// </remarks>
public sealed class ReconnectionPolicy
{
	private readonly int _maxRetries;
	private readonly int _baseDelayMs;
	private readonly int _maxDelayMs;
	private int _retryCount;
	private readonly Random _jitterRng = new();

	/// <summary>
	/// Current retry attempt number (0 = no retries yet).
	/// </summary>
	public int RetryCount => _retryCount;

	/// <summary>
	/// Whether the maximum retry count has been reached.
	/// </summary>
	public bool IsExhausted => _retryCount >= _maxRetries;

	/// <summary>
	/// Creates a ReconnectionPolicy with configurable parameters.
	/// </summary>
	/// <param name="maxRetries">Maximum retry attempts. Default: 10.</param>
	/// <param name="baseDelayMs">Base delay in milliseconds. Default: 1000.</param>
	/// <param name="maxDelayMs">Maximum delay cap in milliseconds. Default: 30000.</param>
	public ReconnectionPolicy(int maxRetries = 10, int baseDelayMs = 1000, int maxDelayMs = 30000)
	{
		_maxRetries = maxRetries;
		_baseDelayMs = baseDelayMs;
		_maxDelayMs = maxDelayMs;
	}

	/// <summary>
	/// Executes an async action with exponential backoff retries.
	/// Resets retry count on success.
	/// </summary>
	/// <param name="action">Async function returning true on success, false on failure.</param>
	/// <param name="cancellationToken">Token to cancel the retry loop.</param>
	/// <returns>True if the action eventually succeeded, false if retries exhausted.</returns>
	public async Task<bool> ExecuteAsync(Func<Task<bool>> action, CancellationToken cancellationToken = default)
	{
		_retryCount = 0;

		while (_retryCount < _maxRetries && !cancellationToken.IsCancellationRequested)
		{
			try
			{
				bool success = await action();
				if (success)
				{
					if (_retryCount > 0)
						Console.WriteLine($"[ReconnectionPolicy] Succeeded after {_retryCount} retries.");
					_retryCount = 0;
					return true;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[ReconnectionPolicy] Attempt {_retryCount + 1}/{_maxRetries} failed: {ex.Message}");
			}

			_retryCount++;

			if (_retryCount < _maxRetries)
			{
				int delay = CalculateDelay(_retryCount);
				Console.WriteLine($"[ReconnectionPolicy] Retry {_retryCount}/{_maxRetries} in {delay}ms...");
				await Task.Delay(delay, cancellationToken);
			}
		}

		Console.WriteLine("[ReconnectionPolicy] All retries exhausted.");
		return false;
	}

	/// <summary>
	/// Resets the retry counter (e.g., after a manual reconnect).
	/// </summary>
	public void Reset()
	{
		_retryCount = 0;
	}

	/// <summary>
	/// Calculates delay with exponential backoff and ±25% jitter.
	/// </summary>
	private int CalculateDelay(int retryCount)
	{
		double exponentialDelay = _baseDelayMs * Math.Pow(2, retryCount - 1);
		double cappedDelay = Math.Min(exponentialDelay, _maxDelayMs);

		// Add ±25% jitter to prevent thundering herd
		double jitterFactor = 0.75 + _jitterRng.NextDouble() * 0.5; // [0.75, 1.25]
		return (int)(cappedDelay * jitterFactor);
	}
}

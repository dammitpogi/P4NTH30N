using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Infrastructure;

/// <summary>
/// OPS_015: Chrome session persistence and recovery.
/// Handles Chrome crashes/restarts gracefully with automatic reconnection.
/// </summary>
public sealed class ChromeSessionManager : IDisposable
{
	private readonly CdpConfig _config;
	private ICdpClient? _cdp;
	private readonly object _lock = new();
	private int _reconnectAttempts;

	/// <summary>
	/// Maximum consecutive reconnect attempts before giving up.
	/// </summary>
	public int MaxReconnectAttempts { get; set; } = 10;

	/// <summary>
	/// Base delay between reconnect attempts (exponential backoff applied).
	/// </summary>
	public int ReconnectBaseDelayMs { get; set; } = 2000;

	/// <summary>
	/// Maximum delay cap for exponential backoff.
	/// </summary>
	public int ReconnectMaxDelayMs { get; set; } = 30000;

	/// <summary>
	/// Event raised when Chrome session is recovered after a disconnect.
	/// </summary>
	public event Action<string>? OnSessionRecovered;

	/// <summary>
	/// Event raised when all reconnect attempts are exhausted.
	/// </summary>
	public event Action<string>? OnSessionLost;

	public ChromeSessionManager(CdpConfig config)
	{
		_config = config;
	}

	/// <summary>
	/// Get or create a healthy CDP connection. Automatically reconnects if needed.
	/// </summary>
	public async Task<ICdpClient?> GetClientAsync(CancellationToken ct = default)
	{
		lock (_lock)
		{
			if (_cdp != null)
			{
				return _cdp;
			}
		}

		return await ConnectAsync(ct);
	}

	/// <summary>
	/// Establish a new CDP connection with retry logic.
	/// </summary>
	public async Task<ICdpClient?> ConnectAsync(CancellationToken ct = default)
	{
		_reconnectAttempts = 0;

		while (_reconnectAttempts < MaxReconnectAttempts && !ct.IsCancellationRequested)
		{
			try
			{
				// Verify Chrome is actually running first
				bool chromeAlive = await IsChromeAliveAsync(ct);
				if (!chromeAlive)
				{
					Console.WriteLine(
						$"[ChromeSession] Chrome CDP not reachable at {_config.HostIp}:{_config.Port} (attempt {_reconnectAttempts + 1}/{MaxReconnectAttempts})"
					);
					await DelayWithBackoff(ct);
					_reconnectAttempts++;
					continue;
				}

				CdpClient client = new(_config);
				bool connected = await client.ConnectAsync(ct);
				if (connected)
				{
					lock (_lock)
					{
						_cdp?.Dispose();
						_cdp = client;
					}

					if (_reconnectAttempts > 0)
					{
						string msg = $"Chrome session recovered after {_reconnectAttempts} attempt(s)";
						Console.WriteLine($"[ChromeSession] {msg}");
						OnSessionRecovered?.Invoke(msg);
					}
					else
					{
						Console.WriteLine("[ChromeSession] Connected to Chrome CDP");
					}

					_reconnectAttempts = 0;
					return client;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[ChromeSession] Connection error: {ex.Message}");
			}

			_reconnectAttempts++;
			await DelayWithBackoff(ct);
		}

		string lostMsg = $"Chrome session lost after {MaxReconnectAttempts} attempts";
		Console.WriteLine($"[ChromeSession] {lostMsg}");
		OnSessionLost?.Invoke(lostMsg);
		return null;
	}

	/// <summary>
	/// Invalidate the current connection (call when an operation fails due to disconnect).
	/// The next GetClientAsync call will trigger reconnection.
	/// </summary>
	public void Invalidate()
	{
		lock (_lock)
		{
			_cdp?.Dispose();
			_cdp = null;
		}
		Console.WriteLine("[ChromeSession] Connection invalidated — will reconnect on next use");
	}

	/// <summary>
	/// Execute an action with automatic reconnect on failure.
	/// </summary>
	public async Task<T?> ExecuteWithRecoveryAsync<T>(Func<ICdpClient, Task<T>> action, CancellationToken ct = default)
	{
		ICdpClient? client = await GetClientAsync(ct);
		if (client == null)
		{
			return default;
		}

		try
		{
			return await action(client);
		}
		catch (Exception ex) when (IsConnectionError(ex))
		{
			Console.WriteLine($"[ChromeSession] Connection error during operation: {ex.Message} — reconnecting");
			Invalidate();

			// Retry once with fresh connection
			client = await ConnectAsync(ct);
			if (client == null)
			{
				return default;
			}

			return await action(client);
		}
	}

	/// <summary>
	/// Check if Chrome CDP endpoint is alive via HTTP.
	/// </summary>
	private async Task<bool> IsChromeAliveAsync(CancellationToken ct)
	{
		try
		{
			using HttpClient http = new() { Timeout = TimeSpan.FromSeconds(3) };
			HttpResponseMessage response = await http.GetAsync($"http://{_config.HostIp}:{_config.Port}/json/version", ct);
			return response.IsSuccessStatusCode;
		}
		catch
		{
			return false;
		}
	}

	/// <summary>
	/// Delay with exponential backoff + jitter.
	/// </summary>
	private async Task DelayWithBackoff(CancellationToken ct)
	{
		int delay = (int)Math.Min(ReconnectMaxDelayMs, ReconnectBaseDelayMs * Math.Pow(2, _reconnectAttempts));
		int jitter = Random.Shared.Next(0, Math.Max(1, delay / 4));
		await Task.Delay(Math.Min(ReconnectMaxDelayMs, delay + jitter), ct);
	}

	/// <summary>
	/// Determine if an exception is likely a connection error (vs application error).
	/// </summary>
	private static bool IsConnectionError(Exception ex)
	{
		return ex is System.Net.WebSockets.WebSocketException
			|| ex is System.IO.IOException
			|| ex is OperationCanceledException
			|| ex is TimeoutException
			|| (ex.InnerException != null && IsConnectionError(ex.InnerException));
	}

	public void Dispose()
	{
		lock (_lock)
		{
			_cdp?.Dispose();
			_cdp = null;
		}
	}
}

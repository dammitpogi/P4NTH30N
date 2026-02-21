using System.Collections.Concurrent;
using System.Text.Json;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Services;

/// <summary>
/// DECISION_026: CDP Network domain interceptor for API-based jackpot extraction.
/// Intercepts HTTP request/response pairs matching jackpot API patterns and extracts
/// values directly from the wire, bypassing fragile DOM parsing.
/// </summary>
public sealed class NetworkInterceptor : IDisposable
{
	private readonly ICdpClient _cdp;
	private readonly ConcurrentDictionary<string, InterceptedRequest> _pendingRequests = new();
	private readonly ConcurrentDictionary<string, JackpotApiResult> _latestResults = new();
	private readonly List<AutomationTrace> _traces = new();
	private readonly object _traceLock = new();
	private bool _enabled;
	private bool _disposed;

	/// <summary>
	/// URL patterns to match for jackpot API interception.
	/// </summary>
	public List<string> UrlPatterns { get; } = new()
	{
		"*QueryBalances*",
		"*GetBalance*",
		"*jackpot*",
		"*getJackpot*",
		"*balance*",
	};

	/// <summary>
	/// Whether interception is currently active.
	/// </summary>
	public bool IsEnabled => _enabled;

	/// <summary>
	/// Number of API responses captured.
	/// </summary>
	public long CapturedCount { get; private set; }

	public NetworkInterceptor(ICdpClient cdpClient)
	{
		_cdp = cdpClient ?? throw new ArgumentNullException(nameof(cdpClient));
	}

	/// <summary>
	/// Enables Network domain request interception via CDP.
	/// </summary>
	public async Task EnableAsync(CancellationToken ct = default)
	{
		if (_enabled) return;

		// Enable Network domain
		await _cdp.SendCommandAsync("Network.enable", new { }, ct);
		_enabled = true;
		Console.WriteLine("[NetworkInterceptor] Enabled - monitoring API traffic");
	}

	/// <summary>
	/// Disables Network domain interception.
	/// </summary>
	public async Task DisableAsync(CancellationToken ct = default)
	{
		if (!_enabled) return;

		await _cdp.SendCommandAsync("Network.disable", new { }, ct);
		_enabled = false;
		Console.WriteLine("[NetworkInterceptor] Disabled");
	}

	/// <summary>
	/// Processes a CDP Network.requestWillBeSent event.
	/// </summary>
	public void OnRequestWillBeSent(string requestId, string url, string method)
	{
		if (!_enabled) return;

		bool matches = UrlPatterns.Any(pattern =>
			url.Contains(pattern.Replace("*", ""), StringComparison.OrdinalIgnoreCase));

		if (matches)
		{
			_pendingRequests[requestId] = new InterceptedRequest
			{
				RequestId = requestId,
				Url = url,
				Method = method,
				Timestamp = DateTime.UtcNow,
			};
		}
	}

	/// <summary>
	/// Processes a CDP Network.responseReceived event.
	/// </summary>
	public async Task OnResponseReceivedAsync(string requestId, int statusCode, string? body, CancellationToken ct = default)
	{
		if (!_enabled) return;

		if (!_pendingRequests.TryRemove(requestId, out var request))
			return;

		CapturedCount++;
		long durationMs = (long)(DateTime.UtcNow - request.Timestamp).TotalMilliseconds;

		// Log trace
		var trace = new AutomationTrace
		{
			TraceType = "NetworkResponse",
			Url = request.Url,
			Method = request.Method,
			StatusCode = statusCode,
			Body = body?.Length > 10_000 ? body[..10_000] : body,
			CdpMethod = "Network.responseReceived",
			DurationMs = durationMs,
		};

		lock (_traceLock)
		{
			_traces.Add(trace);
			if (_traces.Count > 1000)
				_traces.RemoveRange(0, _traces.Count - 500);
		}

		// Try to extract jackpot values from the response
		if (statusCode == 200 && !string.IsNullOrEmpty(body))
		{
			TryExtractJackpotValues(request.Url, body);
		}
	}

	/// <summary>
	/// Gets the latest intercepted jackpot values for a game.
	/// </summary>
	public JackpotApiResult? GetLatestJackpots(string game)
	{
		return _latestResults.TryGetValue(game, out var result) ? result : null;
	}

	/// <summary>
	/// Gets recent traces for debugging.
	/// </summary>
	public List<AutomationTrace> GetRecentTraces(int count = 20)
	{
		lock (_traceLock)
		{
			return _traces.TakeLast(count).ToList();
		}
	}

	private void TryExtractJackpotValues(string url, string body)
	{
		try
		{
			using var doc = JsonDocument.Parse(body);
			var root = doc.RootElement;

			// Try common jackpot response formats
			string game = url.Contains("firekirin", StringComparison.OrdinalIgnoreCase) ? "FireKirin"
				: url.Contains("orion", StringComparison.OrdinalIgnoreCase) ? "OrionStars"
				: "Unknown";

			var result = new JackpotApiResult { Game = game, CapturedAt = DateTime.UtcNow };

			// Format 1: { Grand: x, Major: y, Minor: z, Mini: w }
			if (root.TryGetProperty("Grand", out var grand)) result.Grand = grand.GetDouble();
			if (root.TryGetProperty("Major", out var major)) result.Major = major.GetDouble();
			if (root.TryGetProperty("Minor", out var minor)) result.Minor = minor.GetDouble();
			if (root.TryGetProperty("Mini", out var mini)) result.Mini = mini.GetDouble();

			// Format 2: { balances: [{ tier: "Grand", value: x }, ...] }
			if (root.TryGetProperty("balances", out var balances) && balances.ValueKind == JsonValueKind.Array)
			{
				foreach (var b in balances.EnumerateArray())
				{
					string? tier = b.TryGetProperty("tier", out var t) ? t.GetString() : null;
					double val = b.TryGetProperty("value", out var v) ? v.GetDouble() : 0;
					switch (tier?.ToLowerInvariant())
					{
						case "grand": result.Grand = val; break;
						case "major": result.Major = val; break;
						case "minor": result.Minor = val; break;
						case "mini": result.Mini = val; break;
					}
				}
			}

			if (result.Grand > 0 || result.Major > 0 || result.Minor > 0 || result.Mini > 0)
			{
				_latestResults[game] = result;
				Console.WriteLine($"[NetworkInterceptor] Jackpot API: {game} G={result.Grand:F2} Ma={result.Major:F2} Mi={result.Minor:F2} Mn={result.Mini:F2}");
			}
		}
		catch
		{
			// Silently ignore parse failures — not all responses contain jackpot data
		}
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;
		_pendingRequests.Clear();
	}
}

/// <summary>
/// Captured jackpot values from API interception.
/// </summary>
public sealed class JackpotApiResult
{
	public string Game { get; set; } = string.Empty;
	public double Grand { get; set; }
	public double Major { get; set; }
	public double Minor { get; set; }
	public double Mini { get; set; }
	public DateTime CapturedAt { get; set; }
}

/// <summary>
/// Pending request being tracked for response matching.
/// </summary>
internal sealed class InterceptedRequest
{
	public string RequestId { get; set; } = string.Empty;
	public string Url { get; set; } = string.Empty;
	public string Method { get; set; } = string.Empty;
	public DateTime Timestamp { get; set; }
}

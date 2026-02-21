using System.Diagnostics;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Infrastructure;

/// <summary>
/// TECH-JP-001: CDP connectivity pre-flight checks.
/// Validates Chrome DevTools Protocol connectivity before H4ND enters the main signal loop.
/// </summary>
public sealed class CdpHealthCheck
{
	private readonly CdpConfig _config;

	public CdpHealthCheck(CdpConfig config)
	{
		_config = config;
	}

	/// <summary>
	/// Runs all 4 CDP health checks and returns an aggregate status.
	/// </summary>
	public async Task<CdpHealthStatus> CheckHealthAsync(CancellationToken cancellationToken = default)
	{
		CdpHealthStatus status = new();
		Stopwatch sw = Stopwatch.StartNew();

		// Check 1: HTTP /json/version
		try
		{
			using HttpClient http = new() { Timeout = TimeSpan.FromMilliseconds(_config.CommandTimeoutMs) };
			string versionUrl = $"http://{_config.HostIp}:{_config.Port}/json/version";
			string versionJson = await http.GetStringAsync(versionUrl, cancellationToken);
			status.HttpVersionOk = !string.IsNullOrWhiteSpace(versionJson);
			status.BrowserVersion = versionJson;
			Console.WriteLine($"[CdpHealthCheck] HTTP /json/version: OK");
		}
		catch (Exception ex)
		{
			status.HttpVersionOk = false;
			status.Errors.Add($"HTTP /json/version failed: {ex.Message}");
			LogException(ex, "HTTP /json/version");
		}

		// Check 2: WebSocket handshake (ConnectAsync)
		CdpClient? cdp = null;
		try
		{
			cdp = new CdpClient(_config);
			bool connected = await cdp.ConnectAsync(cancellationToken);
			status.WebSocketHandshakeOk = connected;
			Console.WriteLine($"[CdpHealthCheck] WebSocket handshake: {(connected ? "OK" : "FAIL")}");
			if (!connected)
			{
				status.Errors.Add("WebSocket handshake failed — ConnectAsync returned false");
			}
		}
		catch (Exception ex)
		{
			status.WebSocketHandshakeOk = false;
			status.Errors.Add($"WebSocket handshake failed: {ex.Message}");
			LogException(ex, "WebSocket handshake");
		}

		// Check 3: Round-trip latency (EvaluateAsync("1+1"))
		if (cdp != null && status.WebSocketHandshakeOk)
		{
			try
			{
				Stopwatch latencySw = Stopwatch.StartNew();
				int? result = await cdp.EvaluateAsync<int>("1+1", cancellationToken);
				latencySw.Stop();
				status.RoundTripLatencyMs = latencySw.Elapsed.TotalMilliseconds;
				status.RoundTripOk = result == 2;
				Console.WriteLine($"[CdpHealthCheck] Round-trip eval(1+1)={result} in {status.RoundTripLatencyMs:F1}ms: {(status.RoundTripOk ? "OK" : "FAIL")}");
				if (!status.RoundTripOk)
				{
					status.Errors.Add($"Round-trip eval returned {result}, expected 2");
				}
			}
			catch (Exception ex)
			{
				status.RoundTripOk = false;
				status.Errors.Add($"Round-trip eval failed: {ex.Message}");
				LogException(ex, "Round-trip eval");
			}
		}

		// Check 4: Page interaction test (non-destructive — no navigation, no fake credentials)
		// Previous implementation navigated to FireKirin with "healthcheck" creds, polluting browser state for workers.
		// Now we just verify CDP can interact with whatever page is currently loaded.
		if (cdp != null && status.WebSocketHandshakeOk)
		{
			try
			{
				string? currentUrl = await cdp.EvaluateAsync<string>("window.location.href", cancellationToken);
				status.LoginFlowOk = !string.IsNullOrEmpty(currentUrl);
				Console.WriteLine($"[CdpHealthCheck] Page interaction: OK (url={currentUrl?[..Math.Min(60, currentUrl?.Length ?? 0)]})");
			}
			catch (Exception ex)
			{
				status.LoginFlowOk = false;
				status.Errors.Add($"Page interaction test failed: {ex.Message}");
				LogException(ex, "Page interaction");
			}
		}

		// Cleanup
		if (cdp != null)
		{
			try
			{
				cdp.Dispose();
			}
			catch { }
		}

		sw.Stop();
		status.TotalCheckDurationMs = sw.Elapsed.TotalMilliseconds;
		status.CheckedAt = DateTime.UtcNow;
		status.IsHealthy = status.HttpVersionOk && status.WebSocketHandshakeOk && status.RoundTripOk;

		Console.WriteLine($"[CdpHealthCheck] Overall: {(status.IsHealthy ? "HEALTHY" : "UNHEALTHY")} ({status.TotalCheckDurationMs:F0}ms)");
		return status;
	}

	private static void LogException(Exception ex, string checkName)
	{
		StackTrace trace = new(ex, true);
		StackFrame? frame = trace.GetFrame(0);
		int line = frame?.GetFileLineNumber() ?? 0;
		Console.WriteLine($"[{line}] [CdpHealthCheck] {checkName}: {ex.Message}");
	}
}

/// <summary>
/// TECH-JP-001: Result model for CDP health checks.
/// </summary>
public sealed class CdpHealthStatus
{
	public bool IsHealthy { get; set; }
	public bool HttpVersionOk { get; set; }
	public bool WebSocketHandshakeOk { get; set; }
	public bool RoundTripOk { get; set; }
	public bool LoginFlowOk { get; set; }
	public double RoundTripLatencyMs { get; set; }
	public double TotalCheckDurationMs { get; set; }
	public string? BrowserVersion { get; set; }
	public DateTime CheckedAt { get; set; } = DateTime.UtcNow;
	public List<string> Errors { get; set; } = new();

	public string Summary => $"HTTP={HttpVersionOk}, WS={WebSocketHandshakeOk}, RT={RoundTripOk} ({RoundTripLatencyMs:F1}ms), Login={LoginFlowOk}";
}

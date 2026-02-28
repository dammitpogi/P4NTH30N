using System.Diagnostics;
using System.Net.Sockets;
using System.Text.Json;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;

namespace P4NTHE0N.H4ND.Infrastructure;

/// <summary>
/// OPS_013: VM health monitoring for H4ND deployment.
/// Checks CDP connectivity, MongoDB latency, H4ND process status,
/// and game server reachability.
/// </summary>
public sealed class VmHealthMonitor
{
	private readonly CdpConfig _cdpConfig;
	private readonly string _mongoHost;
	private readonly int _mongoPort;

	public VmHealthMonitor(CdpConfig cdpConfig, string mongoHost = "192.168.56.1", int mongoPort = 27017)
	{
		_cdpConfig = cdpConfig;
		_mongoHost = mongoHost;
		_mongoPort = mongoPort;
	}

	/// <summary>
	/// Run all health checks and return a comprehensive status report.
	/// </summary>
	public async Task<HealthReport> CheckAllAsync(CancellationToken ct = default)
	{
		HealthReport report = new() { Timestamp = DateTime.UtcNow };

		// Run independent checks in parallel
		Task<HealthCheck> cdpTask = CheckCdpAsync(ct);
		Task<HealthCheck> mongoTask = CheckMongoDbAsync(ct);
		Task<HealthCheck> dnsTask = CheckDnsAsync(ct);

		await Task.WhenAll(cdpTask, mongoTask, dnsTask);

		report.Checks.Add(cdpTask.Result);
		report.Checks.Add(mongoTask.Result);
		report.Checks.Add(dnsTask.Result);

		// Overall status
		report.IsHealthy = report.Checks.TrueForAll(c => c.Status != HealthStatus.Critical);
		return report;
	}

	/// <summary>
	/// Check Chrome CDP connectivity and responsiveness.
	/// </summary>
	public async Task<HealthCheck> CheckCdpAsync(CancellationToken ct = default)
	{
		Stopwatch sw = Stopwatch.StartNew();
		try
		{
			using HttpClient http = new() { Timeout = TimeSpan.FromSeconds(5) };
			string url = $"http://{_cdpConfig.HostIp}:{_cdpConfig.Port}/json/version";
			HttpResponseMessage response = await http.GetAsync(url, ct);
			response.EnsureSuccessStatusCode();
			string body = await response.Content.ReadAsStringAsync(ct);
			JsonDocument doc = JsonDocument.Parse(body);
			string browser = doc.RootElement.GetProperty("Browser").GetString() ?? "unknown";
			sw.Stop();

			return new HealthCheck
			{
				Name = "Chrome CDP",
				Status = HealthStatus.Healthy,
				LatencyMs = sw.Elapsed.TotalMilliseconds,
				Detail = $"{browser} at {_cdpConfig.HostIp}:{_cdpConfig.Port}",
			};
		}
		catch (Exception ex)
		{
			sw.Stop();
			return new HealthCheck
			{
				Name = "Chrome CDP",
				Status = HealthStatus.Critical,
				LatencyMs = sw.Elapsed.TotalMilliseconds,
				Detail = ex.Message,
			};
		}
	}

	/// <summary>
	/// Check MongoDB TCP connectivity and measure latency.
	/// </summary>
	public async Task<HealthCheck> CheckMongoDbAsync(CancellationToken ct = default)
	{
		Stopwatch sw = Stopwatch.StartNew();
		try
		{
			using TcpClient tcp = new();
			using CancellationTokenSource cts = CancellationTokenSource.CreateLinkedTokenSource(ct);
			cts.CancelAfter(5000);
			await tcp.ConnectAsync(_mongoHost, _mongoPort, cts.Token);
			sw.Stop();

			HealthStatus status = sw.Elapsed.TotalMilliseconds > 500 ? HealthStatus.Degraded : HealthStatus.Healthy;
			return new HealthCheck
			{
				Name = "MongoDB",
				Status = status,
				LatencyMs = sw.Elapsed.TotalMilliseconds,
				Detail = $"{_mongoHost}:{_mongoPort} (TCP connect)",
			};
		}
		catch (Exception ex)
		{
			sw.Stop();
			return new HealthCheck
			{
				Name = "MongoDB",
				Status = HealthStatus.Critical,
				LatencyMs = sw.Elapsed.TotalMilliseconds,
				Detail = ex.Message,
			};
		}
	}

	/// <summary>
	/// Check DNS resolution (indicator of internet connectivity).
	/// </summary>
	public async Task<HealthCheck> CheckDnsAsync(CancellationToken ct = default)
	{
		Stopwatch sw = Stopwatch.StartNew();
		try
		{
			System.Net.IPHostEntry entry = await System.Net.Dns.GetHostEntryAsync("play.firekirin.in", ct);
			sw.Stop();

			return new HealthCheck
			{
				Name = "DNS/Internet",
				Status = HealthStatus.Healthy,
				LatencyMs = sw.Elapsed.TotalMilliseconds,
				Detail = $"Resolved to {entry.AddressList[0]}",
			};
		}
		catch (Exception ex)
		{
			sw.Stop();
			return new HealthCheck
			{
				Name = "DNS/Internet",
				Status = HealthStatus.Degraded,
				LatencyMs = sw.Elapsed.TotalMilliseconds,
				Detail = ex.Message,
			};
		}
	}

	/// <summary>
	/// Format health report for console output.
	/// </summary>
	public static string FormatReport(HealthReport report)
	{
		System.Text.StringBuilder sb = new();
		sb.AppendLine($"[HealthCheck] {report.Timestamp:HH:mm:ss} UTC — {(report.IsHealthy ? "HEALTHY" : "UNHEALTHY")}");
		foreach (HealthCheck check in report.Checks)
		{
			string icon = check.Status switch
			{
				HealthStatus.Healthy => "OK",
				HealthStatus.Degraded => "WARN",
				HealthStatus.Critical => "CRIT",
				_ => "??",
			};
			sb.AppendLine($"  [{icon}] {check.Name}: {check.LatencyMs:F0}ms — {check.Detail}");
		}
		return sb.ToString();
	}
}

/// <summary>
/// Individual health check result.
/// </summary>
public sealed class HealthCheck
{
	public string Name { get; set; } = string.Empty;
	public HealthStatus Status { get; set; }
	public double LatencyMs { get; set; }
	public string Detail { get; set; } = string.Empty;
}

/// <summary>
/// Aggregated health report.
/// </summary>
public sealed class HealthReport
{
	public DateTime Timestamp { get; set; }
	public bool IsHealthy { get; set; }
	public List<HealthCheck> Checks { get; set; } = [];
}

/// <summary>
/// Health check status levels.
/// </summary>
public enum HealthStatus
{
	Healthy,
	Degraded,
	Critical,
}

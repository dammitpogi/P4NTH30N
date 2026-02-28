using System.Text.Json.Serialization;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;

namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// ARCH-055-005: Aggregated system health report for the P4NTHE0N engine.
/// Collects CDP, MongoDB, platform, and parallel engine status into a single JSON report.
/// </summary>
public sealed class SystemHealthReport
{
	private readonly IUnitOfWork _uow;
	private readonly CdpConfig _cdpConfig;
	private readonly SessionRenewalService _renewalService;

	public SystemHealthReport(IUnitOfWork uow, CdpConfig cdpConfig, SessionRenewalService renewalService)
	{
		_uow = uow;
		_cdpConfig = cdpConfig;
		_renewalService = renewalService;
	}

	/// <summary>
	/// Collects health status from all subsystems and returns an aggregate report.
	/// </summary>
	public async Task<HealthReport> CollectAsync(CancellationToken ct = default)
	{
		HealthReport report = new()
		{
			Timestamp = DateTime.UtcNow,
		};

		// CDP Health
		try
		{
			CdpHealthCheck healthCheck = new(_cdpConfig);
			var cdpStatus = await healthCheck.CheckHealthAsync(ct);

			report.Cdp = new CdpHealthInfo
			{
				Connected = cdpStatus.IsHealthy,
				HostIp = _cdpConfig.HostIp,
				Port = _cdpConfig.Port,
				Summary = cdpStatus.Summary,
			};
		}
		catch (Exception ex)
		{
			report.Cdp = new CdpHealthInfo
			{
				Connected = false,
				HostIp = _cdpConfig.HostIp,
				Port = _cdpConfig.Port,
				Summary = $"CDP health check failed: {ex.Message}",
			};
		}

		// MongoDB Health
		try
		{
			var signals = _uow.Signals.GetAll();
			var credentials = _uow.Credentials.GetAll();
			var errors = _uow.Errors.GetAll();

			report.MongoDb = new MongoHealthInfo
			{
				Connected = true,
				Signals = new CollectionStats
				{
					Total = signals.Count,
					Unacknowledged = signals.Count(s => !s.Acknowledged),
					Claimed = signals.Count(s => s.ClaimedBy != null),
				},
				Credentials = new CredentialStats
				{
					Total = credentials.Count,
					Enabled = credentials.Count(c => c.Enabled),
					Banned = credentials.Count(c => c.Banned),
					Locked = credentials.Count(c => !c.Unlocked),
				},
				Errors = new ErrorStats
				{
					Total = errors.Count,
				},
			};
		}
		catch (Exception ex)
		{
			report.MongoDb = new MongoHealthInfo
			{
				Connected = false,
				ConnectionError = ex.Message,
			};
		}

		// Platform Health
		try
		{
			var fkProbe = await _renewalService.ProbePlatformAsync("FireKirin", ct);
			report.Platforms["FireKirin"] = new PlatformInfo
			{
				Reachable = fkProbe.IsReachable,
				StatusCode = fkProbe.StatusCode,
				LastProbe = fkProbe.ProbedAt,
			};
		}
		catch (Exception ex)
		{
			report.Platforms["FireKirin"] = new PlatformInfo { Reachable = false, Error = ex.Message };
		}

		try
		{
			var osProbe = await _renewalService.ProbePlatformAsync("OrionStars", ct);
			report.Platforms["OrionStars"] = new PlatformInfo
			{
				Reachable = osProbe.IsReachable,
				StatusCode = osProbe.StatusCode,
				LastProbe = osProbe.ProbedAt,
			};
		}
		catch (Exception ex)
		{
			report.Platforms["OrionStars"] = new PlatformInfo { Reachable = false, Error = ex.Message };
		}

		// Determine overall status
		bool cdpOk = report.Cdp.Connected;
		bool mongoOk = report.MongoDb.Connected;
		bool anyPlatformOk = report.Platforms.Values.Any(p => p.Reachable);

		if (cdpOk && mongoOk && anyPlatformOk)
			report.Overall = "Healthy";
		else if (!cdpOk || !mongoOk)
			report.Overall = "Critical";
		else
			report.Overall = "Degraded";

		return report;
	}
}

/// <summary>
/// ARCH-055-005: Complete health report structure.
/// </summary>
public sealed class HealthReport
{
	public DateTime Timestamp { get; set; }
	public string Overall { get; set; } = "Unknown";
	public CdpHealthInfo Cdp { get; set; } = new();
	public MongoHealthInfo MongoDb { get; set; } = new();
	public Dictionary<string, PlatformInfo> Platforms { get; set; } = new();
	public ParallelEngineInfo Parallel { get; set; } = new();
}

public sealed class CdpHealthInfo
{
	public bool Connected { get; set; }
	public string HostIp { get; set; } = string.Empty;
	public int Port { get; set; }
	public string Summary { get; set; } = string.Empty;
}

public sealed class MongoHealthInfo
{
	public bool Connected { get; set; }
	public string? ConnectionError { get; set; }
	public CollectionStats Signals { get; set; } = new();
	public CredentialStats Credentials { get; set; } = new();
	public ErrorStats Errors { get; set; } = new();
}

public sealed class CollectionStats
{
	public int Total { get; set; }
	public int Unacknowledged { get; set; }
	public int Claimed { get; set; }
}

public sealed class CredentialStats
{
	public int Total { get; set; }
	public int Enabled { get; set; }
	public int Banned { get; set; }
	public int Locked { get; set; }
}

public sealed class ErrorStats
{
	public int Total { get; set; }
}

public sealed class PlatformInfo
{
	public bool Reachable { get; set; }
	public int StatusCode { get; set; }
	public DateTime? LastProbe { get; set; }
	public string? Error { get; set; }
}

public sealed class ParallelEngineInfo
{
	public bool Running { get; set; }
	public int Workers { get; set; }
	public long SignalsPending { get; set; }
	public long SignalsCompleted { get; set; }
	public double ErrorRate { get; set; }
}

using System.Diagnostics;

namespace P4NTHE0N.DeployLogAnalyzer;

/// <summary>
/// System health validation for deployment readiness.
/// Checks MongoDB connectivity, disk space, memory usage, and LM Studio availability.
/// </summary>
public sealed class HealthChecker
{
	private readonly LmStudioClient? _lmClient;
	private readonly string _mongoConnectionString;
	private readonly string _dataDirectory;

	public HealthChecker(string mongoConnectionString = "mongodb://localhost:27017/P4NTHE0N", string dataDirectory = "C:\\P4NTHE0N", LmStudioClient? lmClient = null)
	{
		_mongoConnectionString = mongoConnectionString;
		_dataDirectory = dataDirectory;
		_lmClient = lmClient;
	}

	/// <summary>
	/// Runs all health checks and returns an aggregate score 0.0-1.0.
	/// </summary>
	public async Task<HealthReport> CheckAllAsync(CancellationToken cancellationToken = default)
	{
		HealthReport report = new() { Timestamp = DateTime.UtcNow };

		HealthCheckResult mongoCheck = await CheckMongoDbAsync(cancellationToken);
		HealthCheckResult diskCheck = CheckDiskSpace();
		HealthCheckResult memoryCheck = CheckMemoryUsage();
		HealthCheckResult lmCheck = await CheckLmStudioAsync(cancellationToken);

		report.Checks.Add(mongoCheck);
		report.Checks.Add(diskCheck);
		report.Checks.Add(memoryCheck);
		report.Checks.Add(lmCheck);

		// Weighted score: MongoDB=0.3, Disk=0.2, Memory=0.2, LM Studio=0.3
		report.OverallScore = mongoCheck.Score * 0.3 + diskCheck.Score * 0.2 + memoryCheck.Score * 0.2 + lmCheck.Score * 0.3;

		report.IsHealthy = report.OverallScore >= 0.6;

		return report;
	}

	/// <summary>
	/// Checks MongoDB connectivity by attempting a TCP connection.
	/// </summary>
	public async Task<HealthCheckResult> CheckMongoDbAsync(CancellationToken cancellationToken = default)
	{
		HealthCheckResult result = new() { Name = "MongoDB", Category = "Database" };

		try
		{
			// Parse host:port from connection string
			Uri uri = new(_mongoConnectionString.Replace("mongodb://", "http://"));
			string host = uri.Host;
			int port = uri.Port > 0 ? uri.Port : 27017;

			using System.Net.Sockets.TcpClient client = new();
			using CancellationTokenSource cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
			cts.CancelAfter(TimeSpan.FromSeconds(5));

			await client.ConnectAsync(host, port, cts.Token);

			result.Score = 1.0;
			result.Status = "Connected";
			result.Details = $"MongoDB reachable at {host}:{port}";
		}
		catch (Exception ex)
		{
			result.Score = 0.0;
			result.Status = "Failed";
			result.Details = $"MongoDB unreachable: {ex.Message}";
		}

		return result;
	}

	/// <summary>
	/// Checks available disk space on the data directory drive.
	/// </summary>
	public HealthCheckResult CheckDiskSpace()
	{
		HealthCheckResult result = new() { Name = "DiskSpace", Category = "System" };

		try
		{
			string root = Path.GetPathRoot(_dataDirectory) ?? "C:\\";
			DriveInfo drive = new(root);

			long availableGB = drive.AvailableFreeSpace / (1024L * 1024 * 1024);
			long totalGB = drive.TotalSize / (1024L * 1024 * 1024);
			double usagePercent = 1.0 - ((double)drive.AvailableFreeSpace / drive.TotalSize);

			result.Details = $"Drive {root}: {availableGB}GB free of {totalGB}GB ({usagePercent:P0} used)";

			if (availableGB >= 10)
			{
				result.Score = 1.0;
				result.Status = "Healthy";
			}
			else if (availableGB >= 5)
			{
				result.Score = 0.7;
				result.Status = "Warning";
			}
			else if (availableGB >= 1)
			{
				result.Score = 0.3;
				result.Status = "Critical";
			}
			else
			{
				result.Score = 0.0;
				result.Status = "Failed";
			}
		}
		catch (Exception ex)
		{
			result.Score = 0.5;
			result.Status = "Unknown";
			result.Details = $"Could not check disk: {ex.Message}";
		}

		return result;
	}

	/// <summary>
	/// Checks current process memory usage.
	/// </summary>
	public HealthCheckResult CheckMemoryUsage()
	{
		HealthCheckResult result = new() { Name = "Memory", Category = "System" };

		try
		{
			using Process currentProcess = Process.GetCurrentProcess();
			long workingSetMB = currentProcess.WorkingSet64 / (1024 * 1024);
			long privateMemMB = currentProcess.PrivateMemorySize64 / (1024 * 1024);

			result.Details = $"Working set: {workingSetMB}MB, Private: {privateMemMB}MB";

			if (workingSetMB < 500)
			{
				result.Score = 1.0;
				result.Status = "Healthy";
			}
			else if (workingSetMB < 1000)
			{
				result.Score = 0.7;
				result.Status = "Warning";
			}
			else if (workingSetMB < 2000)
			{
				result.Score = 0.4;
				result.Status = "Elevated";
			}
			else
			{
				result.Score = 0.1;
				result.Status = "Critical";
			}
		}
		catch (Exception ex)
		{
			result.Score = 0.5;
			result.Status = "Unknown";
			result.Details = $"Could not check memory: {ex.Message}";
		}

		return result;
	}

	/// <summary>
	/// Checks LM Studio availability at the configured endpoint.
	/// </summary>
	public async Task<HealthCheckResult> CheckLmStudioAsync(CancellationToken cancellationToken = default)
	{
		HealthCheckResult result = new() { Name = "LMStudio", Category = "AI" };

		if (_lmClient == null)
		{
			result.Score = 0.0;
			result.Status = "NotConfigured";
			result.Details = "LM Studio client not provided";
			return result;
		}

		try
		{
			bool connected = await _lmClient.ConnectAsync(cancellationToken);

			if (connected)
			{
				result.Score = 1.0;
				result.Status = "Connected";
				result.Details = "LM Studio responding at configured endpoint";
			}
			else
			{
				result.Score = 0.0;
				result.Status = "Unavailable";
				result.Details = "LM Studio not responding";
			}
		}
		catch (Exception ex)
		{
			result.Score = 0.0;
			result.Status = "Error";
			result.Details = $"LM Studio check failed: {ex.Message}";
		}

		return result;
	}
}

/// <summary>
/// Overall health report aggregating all checks.
/// </summary>
public sealed class HealthReport
{
	public DateTime Timestamp { get; init; }
	public double OverallScore { get; set; }
	public bool IsHealthy { get; set; }
	public List<HealthCheckResult> Checks { get; init; } = new();
}

/// <summary>
/// Individual health check result.
/// </summary>
public sealed class HealthCheckResult
{
	public string Name { get; init; } = string.Empty;
	public string Category { get; init; } = string.Empty;
	public double Score { get; set; }
	public string Status { get; set; } = "Unknown";
	public string Details { get; set; } = string.Empty;
}

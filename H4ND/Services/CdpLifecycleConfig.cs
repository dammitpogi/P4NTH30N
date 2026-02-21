using System.Diagnostics;

namespace P4NTH30N.H4ND.Services;

/// <summary>
/// AUTO-056-005: Configuration POCO for Chrome CDP lifecycle management.
/// Bound from appsettings.json P4NTH30N:H4ND:CdpLifecycle section.
/// </summary>
public sealed class CdpLifecycleConfig
{
	public bool AutoStart { get; set; } = true;
	public string ChromePath { get; set; } = @"C:\Program Files\Google\Chrome\Application\chrome.exe";
	public bool Headless { get; set; } = false;
	public int DebugPort { get; set; } = 9222;
	public string DebugHost { get; set; } = "0.0.0.0";
	public int StartupTimeoutSeconds { get; set; } = 30;
	public int HealthCheckIntervalSeconds { get; set; } = 30;
	public int MaxAutoRestarts { get; set; } = 3;
	public int[] RestartBackoffSeconds { get; set; } = [5, 10, 30];
	public int GracefulShutdownTimeoutSeconds { get; set; } = 10;
	public string[] AdditionalArgs { get; set; } = ["--no-sandbox", "--disable-gpu", "--ignore-certificate-errors", "--mute-audio"];
}

/// <summary>
/// AUTO-056: Lifecycle status of the managed Chrome CDP process.
/// Named CdpLifecycleStatus to avoid conflict with existing CdpHealthStatus (TECH-JP-001).
/// </summary>
public enum CdpLifecycleStatus
{
	Healthy,
	Unhealthy,
	Starting,
	Stopped,
	Error,
}

/// <summary>
/// AUTO-056: Interface for Chrome CDP lifecycle management.
/// Enables auto-start, health monitoring, restart, and graceful shutdown.
/// </summary>
public interface ICdpLifecycleManager : IDisposable
{
	Task<bool> IsAvailableAsync(CancellationToken ct = default);
	Task<bool> EnsureAvailableAsync(CancellationToken ct = default);
	Task StartChromeAsync(CancellationToken ct = default);
	Task StopChromeAsync(CancellationToken ct = default);
	Task RestartChromeAsync(CancellationToken ct = default);
	CdpLifecycleStatus GetLifecycleStatus();
}

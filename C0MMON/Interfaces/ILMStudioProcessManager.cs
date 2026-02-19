using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-025: Contract for LM Studio process lifecycle management.
/// Manages starting, stopping, and monitoring the local LM Studio instance.
/// </summary>
public interface ILMStudioProcessManager
{
	/// <summary>
	/// Starts the LM Studio process if not already running.
	/// </summary>
	Task<bool> StartAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Stops the LM Studio process gracefully.
	/// </summary>
	Task StopAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Restarts the LM Studio process.
	/// </summary>
	Task<bool> RestartAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Whether LM Studio process is currently running.
	/// </summary>
	bool IsRunning { get; }

	/// <summary>
	/// Gets the current process health status.
	/// </summary>
	Task<ProcessHealthStatus> GetHealthAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets the list of currently loaded models.
	/// </summary>
	Task<IReadOnlyList<string>> GetLoadedModelsAsync(CancellationToken cancellationToken = default);
}

public class ProcessHealthStatus
{
	public bool IsRunning { get; set; }
	public bool IsResponding { get; set; }
	public long UptimeSeconds { get; set; }
	public long MemoryUsageBytes { get; set; }
	public int LoadedModelCount { get; set; }
	public string EndpointUrl { get; set; } = string.Empty;
}

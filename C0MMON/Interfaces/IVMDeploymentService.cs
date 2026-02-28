using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// Factory for creating VM providers and file transfer implementations.
/// </summary>
public interface IVMProviderFactory
{
	/// <summary>
	/// Creates a VM provider for the specified type.
	/// </summary>
	/// <param name="providerType">Type of VM provider.</param>
	/// <returns>IVMProvider instance.</returns>
	IVMProvider CreateProvider(VMProviderType providerType);

	/// <summary>
	/// Creates a file transfer implementation for the specified provider type.
	/// </summary>
	/// <param name="providerType">Type of VM provider.</param>
	/// <returns>IVMFileTransfer instance.</returns>
	IVMFileTransfer CreateFileTransfer(VMProviderType providerType);

	/// <summary>
	/// Gets the list of supported provider types.
	/// </summary>
	IReadOnlyList<VMProviderType> SupportedProviders { get; }
}

/// <summary>
/// High-level service for orchestrating VM deployments.
/// </summary>
public interface IVMDeploymentService
{
	/// <summary>
	/// Deploys a VM with the specified configuration.
	/// </summary>
	/// <param name="configuration">VM configuration.</param>
	/// <param name="options">Optional deployment options.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Deployment result.</returns>
	Task<VMDeploymentResult> DeployAsync(VMConfiguration configuration, DeploymentOptions? options = null, CancellationToken cancellationToken = default);

	/// <summary>
	/// Deploys multiple VMs in batch.
	/// </summary>
	/// <param name="configurations">Collection of VM configurations.</param>
	/// <param name="options">Optional deployment options.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>List of deployment results.</returns>
	Task<IReadOnlyList<VMDeploymentResult>> DeployBatchAsync(
		IEnumerable<VMConfiguration> configurations,
		DeploymentOptions? options = null,
		CancellationToken cancellationToken = default
	);

	/// <summary>
	/// Undeploys (stops and optionally removes) a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="providerType">Type of VM provider.</param>
	/// <param name="deleteSnapshots">If true, deletes all snapshots.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if undeployment successful, false otherwise.</returns>
	Task<bool> UndeployAsync(string vmName, VMProviderType providerType, bool deleteSnapshots = false, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets the current status of a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="providerType">Type of VM provider.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Current VM status.</returns>
	Task<VMStatus> GetStatusAsync(string vmName, VMProviderType providerType, CancellationToken cancellationToken = default);
}

/// <summary>
/// Interface for monitoring VM health status.
/// </summary>
public interface IVMHealthMonitor
{
	/// <summary>
	/// Performs a health check on a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="providerType">Type of VM provider.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Health status information.</returns>
	Task<VMHealthStatus> CheckHealthAsync(string vmName, VMProviderType providerType, CancellationToken cancellationToken = default);

	/// <summary>
	/// Monitors a VM continuously at specified intervals.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="providerType">Type of VM provider.</param>
	/// <param name="interval">Polling interval.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Async enumerable of health status updates.</returns>
	IAsyncEnumerable<VMHealthStatus> MonitorContinuouslyAsync(
		string vmName,
		VMProviderType providerType,
		TimeSpan interval,
		CancellationToken cancellationToken = default
	);

	/// <summary>
	/// Event raised when VM health status changes.
	/// </summary>
	event EventHandler<VMHealthChangedEventArgs>? HealthChanged;
}

/// <summary>
/// Event arguments for health status changes.
/// </summary>
public class VMHealthChangedEventArgs : EventArgs
{
	public string VMName { get; init; } = string.Empty;
	public VMProviderType ProviderType { get; init; }
	public VMHealthStatus? PreviousStatus { get; init; }
	public VMHealthStatus? CurrentStatus { get; init; }
	public DateTime Timestamp { get; init; }
}

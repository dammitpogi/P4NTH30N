using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// Strategy interface for VM provider implementations (Hyper-V, VirtualBox, VMware).
/// </summary>
public interface IVMProvider
{
	/// <summary>
	/// Gets the type of VM provider.
	/// </summary>
	VMProviderType ProviderType { get; }

	/// <summary>
	/// Starts a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM to start.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> StartVMAsync(string vmName, CancellationToken cancellationToken = default);

	/// <summary>
	/// Stops a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM to stop.</param>
	/// <param name="force">If true, forcefully powers off the VM. If false, graceful shutdown.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> StopVMAsync(string vmName, bool force = false, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets the current status of a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Current VM status.</returns>
	Task<VMStatus> GetVMStatusAsync(string vmName, CancellationToken cancellationToken = default);

	/// <summary>
	/// Executes a command inside the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="command">Command to execute (PowerShell for Windows, shell for Linux).</param>
	/// <param name="workingDirectory">Working directory for command execution.</param>
	/// <param name="timeout">Timeout for command execution.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Execution result with exit code and output.</returns>
	Task<VMExecuteResult> ExecuteCommandAsync(
		string vmName,
		string command,
		string? workingDirectory = null,
		TimeSpan? timeout = null,
		CancellationToken cancellationToken = default
	);

	/// <summary>
	/// Creates a snapshot of the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="snapshotName">Name for the new snapshot.</param>
	/// <param name="description">Optional description of the snapshot.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> CreateSnapshotAsync(string vmName, string snapshotName, string? description = null, CancellationToken cancellationToken = default);

	/// <summary>
	/// Restores a VM to a previous snapshot.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="snapshotName">Name of the snapshot to restore.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> RestoreSnapshotAsync(string vmName, string snapshotName, CancellationToken cancellationToken = default);

	/// <summary>
	/// Lists all snapshots for a VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>List of snapshots.</returns>
	Task<IReadOnlyList<VMSnapshot>> ListSnapshotsAsync(string vmName, CancellationToken cancellationToken = default);

	/// <summary>
	/// Deletes a snapshot.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="snapshotName">Name of the snapshot to delete.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> DeleteSnapshotAsync(string vmName, string snapshotName, CancellationToken cancellationToken = default);
}

/// <summary>
/// Types of VM providers supported.
/// </summary>
public enum VMProviderType
{
	HyperV,
	VirtualBox,
	VMware,
}

/// <summary>
/// Possible states of a VM.
/// </summary>
public enum VMStatus
{
	Stopped,
	Starting,
	Running,
	Paused,
	Saved,
	Unknown,
}

/// <summary>
/// Result of a command execution inside a VM.
/// </summary>
public record VMExecuteResult(int ExitCode, string StandardOutput, string StandardError, TimeSpan Duration);

/// <summary>
/// Information about a VM snapshot.
/// </summary>
public record VMSnapshot(string Name, DateTime CreatedAt, string? Description, bool IsCurrent);

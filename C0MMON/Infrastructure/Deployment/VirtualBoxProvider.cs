using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// VirtualBox VM provider implementation using VBoxManage.
/// </summary>
public class VirtualBoxProvider : IVMProvider
{
	/// <inheritdoc />
	public VMProviderType ProviderType => VMProviderType.VirtualBox;

	/// <inheritdoc />
	public Task<bool> StartVMAsync(string vmName, CancellationToken cancellationToken = default)
	{
		// TODO: Implement using VBoxManage startvm
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> StopVMAsync(string vmName, bool force = false, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<VMStatus> GetVMStatusAsync(string vmName, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<VMExecuteResult> ExecuteCommandAsync(
		string vmName,
		string command,
		string? workingDirectory = null,
		TimeSpan? timeout = null,
		CancellationToken cancellationToken = default
	)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> CreateSnapshotAsync(string vmName, string snapshotName, string? description = null, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> RestoreSnapshotAsync(string vmName, string snapshotName, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<IReadOnlyList<VMSnapshot>> ListSnapshotsAsync(string vmName, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DeleteSnapshotAsync(string vmName, string snapshotName, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException("VirtualBox provider not yet implemented");
	}
}

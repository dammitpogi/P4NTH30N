using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// VirtualBox file transfer implementation using VBoxManage guestcontrol.
/// </summary>
public class VirtualBoxFileTransfer : IVMFileTransfer
{
	/// <inheritdoc />
	public Task<bool> UploadFileAsync(string vmName, string sourcePath, string destinationPath, CancellationToken cancellationToken = default)
	{
		// TODO: Implement using VBoxManage guestcontrol copyto
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DownloadFileAsync(string vmName, string sourcePath, string destinationPath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> UploadDirectoryAsync(string vmName, string sourceDirectory, string destinationDirectory, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DownloadDirectoryAsync(string vmName, string sourceDirectory, string destinationDirectory, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DeleteFileAsync(string vmName, string filePath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DirectoryExistsAsync(string vmName, string directoryPath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> CreateDirectoryAsync(string vmName, string directoryPath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("VirtualBox file transfer not yet implemented");
	}
}

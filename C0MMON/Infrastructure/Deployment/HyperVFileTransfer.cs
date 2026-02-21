using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// Hyper-V file transfer implementation using Copy-VMFile.
/// </summary>
public class HyperVFileTransfer : IVMFileTransfer
{
	/// <inheritdoc />
	public Task<bool> UploadFileAsync(string vmName, string sourcePath, string destinationPath, CancellationToken cancellationToken = default)
	{
		// TODO: Implement using Copy-VMFile
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DownloadFileAsync(string vmName, string sourcePath, string destinationPath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> UploadDirectoryAsync(string vmName, string sourceDirectory, string destinationDirectory, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DownloadDirectoryAsync(string vmName, string sourceDirectory, string destinationDirectory, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DeleteFileAsync(string vmName, string filePath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> DirectoryExistsAsync(string vmName, string directoryPath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}

	/// <inheritdoc />
	public Task<bool> CreateDirectoryAsync(string vmName, string directoryPath, CancellationToken cancellationToken = default)
	{
		throw new System.NotImplementedException("Hyper-V file transfer not yet implemented");
	}
}

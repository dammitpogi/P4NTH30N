using System.Threading;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// Interface for file transfer operations to/from VMs using provider-specific mechanisms.
/// </summary>
public interface IVMFileTransfer
{
	/// <summary>
	/// Uploads a file from the host to the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="sourcePath">Source file path on the host.</param>
	/// <param name="destinationPath">Destination file path in the VM.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> UploadFileAsync(string vmName, string sourcePath, string destinationPath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Downloads a file from the VM to the host.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="sourcePath">Source file path in the VM.</param>
	/// <param name="destinationPath">Destination file path on the host.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> DownloadFileAsync(string vmName, string sourcePath, string destinationPath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Uploads a directory recursively from the host to the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="sourceDirectory">Source directory path on the host.</param>
	/// <param name="destinationDirectory">Destination directory path in the VM.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> UploadDirectoryAsync(string vmName, string sourceDirectory, string destinationDirectory, CancellationToken cancellationToken = default);

	/// <summary>
	/// Downloads a directory recursively from the VM to the host.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="sourceDirectory">Source directory path in the VM.</param>
	/// <param name="destinationDirectory">Destination directory path on the host.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> DownloadDirectoryAsync(string vmName, string sourceDirectory, string destinationDirectory, CancellationToken cancellationToken = default);

	/// <summary>
	/// Deletes a file in the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="filePath">Path to the file to delete.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> DeleteFileAsync(string vmName, string filePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Checks if a directory exists in the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="directoryPath">Path to check.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if directory exists, false otherwise.</returns>
	Task<bool> DirectoryExistsAsync(string vmName, string directoryPath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Creates a directory in the VM.
	/// </summary>
	/// <param name="vmName">Name of the VM.</param>
	/// <param name="directoryPath">Path of directory to create.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if successful, false otherwise.</returns>
	Task<bool> CreateDirectoryAsync(string vmName, string directoryPath, CancellationToken cancellationToken = default);
}

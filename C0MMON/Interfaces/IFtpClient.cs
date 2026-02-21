using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// Interface for FTP/SFTP client operations.
/// </summary>
public interface IFtpClient
{
	/// <summary>
	/// Gets whether the client is currently connected.
	/// </summary>
	bool IsConnected { get; }

	/// <summary>
	/// Connects to the FTP/SFTP server.
	/// </summary>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if connection successful, false otherwise.</returns>
	Task<bool> ConnectAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Disconnects from the server.
	/// </summary>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Task representing the disconnect operation.</returns>
	Task DisconnectAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Uploads a file to the server.
	/// </summary>
	/// <param name="localPath">Local file path.</param>
	/// <param name="remotePath">Remote destination path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if upload successful, false otherwise.</returns>
	Task<bool> UploadFileAsync(string localPath, string remotePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Downloads a file from the server.
	/// </summary>
	/// <param name="remotePath">Remote file path.</param>
	/// <param name="localPath">Local destination path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if download successful, false otherwise.</returns>
	Task<bool> DownloadFileAsync(string remotePath, string localPath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Uploads a directory recursively.
	/// </summary>
	/// <param name="localDirectory">Local directory path.</param>
	/// <param name="remoteDirectory">Remote destination path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if upload successful, false otherwise.</returns>
	Task<bool> UploadDirectoryAsync(string localDirectory, string remoteDirectory, CancellationToken cancellationToken = default);

	/// <summary>
	/// Downloads a directory recursively.
	/// </summary>
	/// <param name="remoteDirectory">Remote directory path.</param>
	/// <param name="localDirectory">Local destination path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if download successful, false otherwise.</returns>
	Task<bool> DownloadDirectoryAsync(string remoteDirectory, string localDirectory, CancellationToken cancellationToken = default);

	/// <summary>
	/// Lists files and directories in a remote path.
	/// </summary>
	/// <param name="remotePath">Remote directory path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>List of file information.</returns>
	Task<IReadOnlyList<FtpFileInfo>> ListDirectoryAsync(string remotePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Deletes a file on the server.
	/// </summary>
	/// <param name="remotePath">Remote file path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if deletion successful, false otherwise.</returns>
	Task<bool> DeleteFileAsync(string remotePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Deletes a directory on the server.
	/// </summary>
	/// <param name="remotePath">Remote directory path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if deletion successful, false otherwise.</returns>
	Task<bool> DeleteDirectoryAsync(string remotePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Creates a directory on the server.
	/// </summary>
	/// <param name="remotePath">Remote directory path to create.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if creation successful, false otherwise.</returns>
	Task<bool> CreateDirectoryAsync(string remotePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Checks if a directory exists on the server.
	/// </summary>
	/// <param name="remotePath">Remote directory path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if directory exists, false otherwise.</returns>
	Task<bool> DirectoryExistsAsync(string remotePath, CancellationToken cancellationToken = default);

	/// <summary>
	/// Checks if a file exists on the server.
	/// </summary>
	/// <param name="remotePath">Remote file path.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>True if file exists, false otherwise.</returns>
	Task<bool> FileExistsAsync(string remotePath, CancellationToken cancellationToken = default);
}

/// <summary>
/// Information about a file or directory on an FTP server.
/// </summary>
public record FtpFileInfo(string Name, string FullPath, long Size, DateTime ModifiedAt, FtpFileType Type);

/// <summary>
/// Type of FTP file system entry.
/// </summary>
public enum FtpFileType
{
	File,
	Directory,
	SymbolicLink,
}

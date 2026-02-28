using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using FluentFTP;
using IProjectFtpClient = P4NTHE0N.C0MMON.Interfaces.IFtpClient;

namespace P4NTHE0N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// FluentFTP-based implementation for FTP/FTPS operations.
/// </summary>
public class FluentFtpClient : IProjectFtpClient, IDisposable
{
	private readonly FtpConfiguration _configuration;
	private AsyncFtpClient? _client;
	private bool _disposed;

	/// <summary>
	/// Initializes a new instance of the FluentFTP client.
	/// </summary>
	/// <param name="configuration">FTP connection configuration.</param>
	public FluentFtpClient(FtpConfiguration configuration)
	{
		_configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
	}

	/// <inheritdoc />
	public bool IsConnected => _client?.IsConnected ?? false;

	/// <inheritdoc />
	public async Task<bool> ConnectAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			FtpConfig config = new()
			{
				EncryptionMode = _configuration.Protocol switch
				{
					FtpProtocol.FtpsExplicit => FtpEncryptionMode.Explicit,
					FtpProtocol.FtpsImplicit => FtpEncryptionMode.Implicit,
					_ => FtpEncryptionMode.None,
				},
				ValidateAnyCertificate = true, // For development/testing
			};

			_client = new AsyncFtpClient(_configuration.Host, _configuration.Username, _configuration.Password, _configuration.Port, config);

			await _client.Connect(cancellationToken);
			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(ConnectAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task DisconnectAsync(CancellationToken cancellationToken = default)
	{
		if (_client?.IsConnected == true)
		{
			await _client.Disconnect(cancellationToken);
		}
	}

	/// <inheritdoc />
	public async Task<bool> UploadFileAsync(string localPath, string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			FtpStatus status = await _client.UploadFile(localPath, remotePath, FtpRemoteExists.Overwrite, true, FtpVerify.None, null, cancellationToken);
			return status == FtpStatus.Success;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(UploadFileAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> DownloadFileAsync(string remotePath, string localPath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			FtpStatus status = await _client.DownloadFile(localPath, remotePath, FtpLocalExists.Overwrite, FtpVerify.None, null, cancellationToken);
			return status == FtpStatus.Success;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DownloadFileAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> UploadDirectoryAsync(string localDirectory, string remoteDirectory, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			List<FtpResult> results = await _client.UploadDirectory(
				localDirectory,
				remoteDirectory,
				FtpFolderSyncMode.Update,
				FtpRemoteExists.Overwrite,
				FtpVerify.Retry
			);

			return results.TrueForAll(r => r.IsSuccess);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(UploadDirectoryAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> DownloadDirectoryAsync(string remoteDirectory, string localDirectory, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			List<FtpResult> results = await _client.DownloadDirectory(
				localDirectory,
				remoteDirectory,
				FtpFolderSyncMode.Update,
				FtpLocalExists.Overwrite,
				FtpVerify.Retry
			);

			return results.TrueForAll(r => r.IsSuccess);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DownloadDirectoryAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<FtpFileInfo>> ListDirectoryAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return new List<FtpFileInfo>();
		}

		try
		{
			FtpListItem[] items = await _client.GetListing(remotePath, cancellationToken);
			List<FtpFileInfo> files = new();

			foreach (FtpListItem item in items)
			{
				FtpFileType type = item.Type switch
				{
					FtpObjectType.File => FtpFileType.File,
					FtpObjectType.Directory => FtpFileType.Directory,
					FtpObjectType.Link => FtpFileType.SymbolicLink,
					_ => FtpFileType.File,
				};

				files.Add(new FtpFileInfo(item.Name, item.FullName, item.Size, item.Modified, type));
			}

			return files;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(ListDirectoryAsync));
			return new List<FtpFileInfo>();
		}
	}

	/// <inheritdoc />
	public async Task<bool> DeleteFileAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			await _client.DeleteFile(remotePath, cancellationToken);
			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DeleteFileAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> DeleteDirectoryAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			await _client.DeleteDirectory(remotePath, cancellationToken);
			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DeleteDirectoryAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> CreateDirectoryAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			await _client.CreateDirectory(remotePath, cancellationToken);
			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(CreateDirectoryAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> DirectoryExistsAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			return await _client.DirectoryExists(remotePath, cancellationToken);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DirectoryExistsAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> FileExistsAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[FluentFtpClient] Not connected");
			return false;
		}

		try
		{
			return await _client.FileExists(remotePath, cancellationToken);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(FileExistsAsync));
			return false;
		}
	}

	/// <summary>
	/// Disposes the FTP client.
	/// </summary>
	public void Dispose()
	{
		if (!_disposed)
		{
			_client?.Dispose();
			_disposed = true;
		}
	}

	/// <summary>
	/// Logs an exception with line number information.
	/// </summary>
	private static void LogException(Exception ex, string operation)
	{
		var frame = new System.Diagnostics.StackTrace(ex, true).GetFrame(0);
		int line = frame?.GetFileLineNumber() ?? 0;
		Console.WriteLine($"[{line}] FTP {operation} failed: {ex.Message}");
	}
}

using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Interfaces;
using Renci.SshNet;
using Renci.SshNet.Sftp;

namespace P4NTHE0N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// SSH.NET-based implementation for SFTP operations.
/// </summary>
public class SshNetFtpClient : IFtpClient, IDisposable
{
	private readonly FtpConfiguration _configuration;
	private SftpClient? _client;
	private bool _disposed;

	/// <summary>
	/// Initializes a new instance of the SFTP client.
	/// </summary>
	/// <param name="configuration">SFTP connection configuration.</param>
	public SshNetFtpClient(FtpConfiguration configuration)
	{
		_configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
	}

	/// <inheritdoc />
	public bool IsConnected => _client?.IsConnected ?? false;

	/// <inheritdoc />
	public Task<bool> ConnectAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			AuthenticationMethod[] authMethods;

			if (!string.IsNullOrEmpty(_configuration.SshPrivateKeyPath))
			{
				// Key-based authentication
				PrivateKeyFile keyFile = string.IsNullOrEmpty(_configuration.SshPassphrase)
					? new PrivateKeyFile(_configuration.SshPrivateKeyPath)
					: new PrivateKeyFile(_configuration.SshPrivateKeyPath, _configuration.SshPassphrase);

				authMethods = new AuthenticationMethod[] { new PrivateKeyAuthenticationMethod(_configuration.Username, keyFile) };
			}
			else
			{
				// Password authentication
				authMethods = new AuthenticationMethod[] { new PasswordAuthenticationMethod(_configuration.Username, _configuration.Password) };
			}

			ConnectionInfo connectionInfo = new(_configuration.Host, _configuration.Port, _configuration.Username, authMethods);

			_client = new SftpClient(connectionInfo);
			_client.Connect();
			return Task.FromResult(true);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(ConnectAsync));
			return Task.FromResult(false);
		}
	}

	/// <inheritdoc />
	public Task DisconnectAsync(CancellationToken cancellationToken = default)
	{
		if (_client?.IsConnected == true)
		{
			_client.Disconnect();
		}
		return Task.CompletedTask;
	}

	/// <inheritdoc />
	public async Task<bool> UploadFileAsync(string localPath, string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return false;
		}

		try
		{
			await using FileStream fileStream = File.OpenRead(localPath);
			_client.UploadFile(fileStream, remotePath, true);
			return true;
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
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return false;
		}

		try
		{
			await using FileStream fileStream = File.Create(localPath);
			_client.DownloadFile(remotePath, fileStream);
			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DownloadFileAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public Task<bool> UploadDirectoryAsync(string localDirectory, string remoteDirectory, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			UploadDirectoryRecursive(localDirectory, remoteDirectory);
			return Task.FromResult(true);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(UploadDirectoryAsync));
			return Task.FromResult(false);
		}
	}

	/// <summary>
	/// Recursively uploads a directory.
	/// </summary>
	private void UploadDirectoryRecursive(string localDirectory, string remoteDirectory)
	{
		if (!_client!.Exists(remoteDirectory))
		{
			_client.CreateDirectory(remoteDirectory);
		}

		foreach (string file in Directory.GetFiles(localDirectory))
		{
			string remoteFilePath = remoteDirectory + "/" + Path.GetFileName(file);
			using FileStream fileStream = File.OpenRead(file);
			_client.UploadFile(fileStream, remoteFilePath, true);
		}

		foreach (string directory in Directory.GetDirectories(localDirectory))
		{
			string remoteSubDir = remoteDirectory + "/" + Path.GetFileName(directory);
			UploadDirectoryRecursive(directory, remoteSubDir);
		}
	}

	/// <inheritdoc />
	public Task<bool> DownloadDirectoryAsync(string remoteDirectory, string localDirectory, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			DownloadDirectoryRecursive(remoteDirectory, localDirectory);
			return Task.FromResult(true);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DownloadDirectoryAsync));
			return Task.FromResult(false);
		}
	}

	/// <summary>
	/// Recursively downloads a directory.
	/// </summary>
	private void DownloadDirectoryRecursive(string remoteDirectory, string localDirectory)
	{
		if (!Directory.Exists(localDirectory))
		{
			Directory.CreateDirectory(localDirectory);
		}

		IEnumerable<ISftpFile> files = _client!.ListDirectory(remoteDirectory);
		foreach (ISftpFile file in files)
		{
			if (file.IsDirectory)
			{
				if (file.Name != "." && file.Name != "..")
				{
					string localSubDir = Path.Combine(localDirectory, file.Name);
					DownloadDirectoryRecursive(file.FullName, localSubDir);
				}
			}
			else
			{
				string localFilePath = Path.Combine(localDirectory, file.Name);
				using FileStream fileStream = File.Create(localFilePath);
				_client.DownloadFile(file.FullName, fileStream);
			}
		}
	}

	/// <inheritdoc />
	public Task<IReadOnlyList<FtpFileInfo>> ListDirectoryAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult<IReadOnlyList<FtpFileInfo>>(new List<FtpFileInfo>());
		}

		try
		{
			IEnumerable<ISftpFile> files = _client.ListDirectory(remotePath);
			List<FtpFileInfo> result = new();

			foreach (ISftpFile file in files)
			{
				if (file.Name == "." || file.Name == "..")
					continue;

				FtpFileType type = file.IsDirectory ? FtpFileType.Directory : FtpFileType.File;
				result.Add(new FtpFileInfo(file.Name, file.FullName, file.Length, file.LastWriteTime, type));
			}

			return Task.FromResult<IReadOnlyList<FtpFileInfo>>(result);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(ListDirectoryAsync));
			return Task.FromResult<IReadOnlyList<FtpFileInfo>>(new List<FtpFileInfo>());
		}
	}

	/// <inheritdoc />
	public Task<bool> DeleteFileAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			_client.Delete(remotePath);
			return Task.FromResult(true);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DeleteFileAsync));
			return Task.FromResult(false);
		}
	}

	/// <inheritdoc />
	public Task<bool> DeleteDirectoryAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			_client.DeleteDirectory(remotePath);
			return Task.FromResult(true);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DeleteDirectoryAsync));
			return Task.FromResult(false);
		}
	}

	/// <inheritdoc />
	public Task<bool> CreateDirectoryAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			_client.CreateDirectory(remotePath);
			return Task.FromResult(true);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(CreateDirectoryAsync));
			return Task.FromResult(false);
		}
	}

	/// <inheritdoc />
	public Task<bool> DirectoryExistsAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			return Task.FromResult(_client.Exists(remotePath));
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DirectoryExistsAsync));
			return Task.FromResult(false);
		}
	}

	/// <inheritdoc />
	public Task<bool> FileExistsAsync(string remotePath, CancellationToken cancellationToken = default)
	{
		if (_client == null || !_client.IsConnected)
		{
			Console.WriteLine("[SshNetFtpClient] Not connected");
			return Task.FromResult(false);
		}

		try
		{
			SftpFileAttributes? attrs = _client.GetAttributes(remotePath);
			return Task.FromResult(attrs != null && !attrs.IsDirectory);
		}
		catch
		{
			return Task.FromResult(false);
		}
	}

	/// <summary>
	/// Disposes the SFTP client.
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
		Console.WriteLine($"[{line}] SFTP {operation} failed: {ex.Message}");
	}
}

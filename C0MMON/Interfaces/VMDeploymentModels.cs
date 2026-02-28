using System;
using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// Configuration for VM deployment.
/// </summary>
public record VMConfiguration(
	string Name,
	VMProviderType ProviderType,
	int MemoryMB,
	int CpuCount,
	string? SnapshotToRestore = null,
	IReadOnlyList<VMFileTransferTask>? FileTransfers = null,
	IReadOnlyList<VMCommandTask>? PostDeployCommands = null,
	FtpConfiguration? FtpConfiguration = null,
	NetworkConfiguration? NetworkConfiguration = null
);

/// <summary>
/// File transfer task for VM deployment.
/// </summary>
public record VMFileTransferTask(string SourcePath, string DestinationPath, FileTransferType TransferType, bool IsDirectory = false);

/// <summary>
/// Type of file transfer mechanism.
/// </summary>
public enum FileTransferType
{
	ProviderNative,
	Ftp,
	Sftp,
}

/// <summary>
/// Command to execute after VM deployment.
/// </summary>
public record VMCommandTask(string Command, string? WorkingDirectory = null, TimeSpan? Timeout = null, bool FailOnError = true);

/// <summary>
/// FTP connection configuration.
/// </summary>
public record FtpConfiguration(
	string Host,
	int Port,
	string Username,
	string Password,
	FtpProtocol Protocol = FtpProtocol.Ftp,
	bool EnableSsl = false,
	string? SshPrivateKeyPath = null,
	string? SshPassphrase = null
);

/// <summary>
/// FTP protocol types.
/// </summary>
public enum FtpProtocol
{
	Ftp,
	FtpsExplicit,
	FtpsImplicit,
	Sftp,
}

/// <summary>
/// Network configuration for VM.
/// </summary>
public record NetworkConfiguration(
	string? StaticIpAddress = null,
	string? SubnetMask = null,
	string? Gateway = null,
	IReadOnlyList<string>? DnsServers = null,
	bool UseDhcp = true
);

/// <summary>
/// Options for VM deployment.
/// </summary>
public record DeploymentOptions(
	TimeSpan? Timeout = null,
	int RetryCount = 3,
	TimeSpan RetryDelay = default,
	int ParallelExecution = 1,
	bool WaitForNetwork = true,
	TimeSpan? NetworkWaitTimeout = null,
	bool TakeSnapshotOnSuccess = false,
	string? SuccessSnapshotName = null,
	bool RollbackOnFailure = true
)
{
	public static DeploymentOptions Default { get; } =
		new(
			Timeout: TimeSpan.FromMinutes(10),
			RetryCount: 3,
			RetryDelay: TimeSpan.FromSeconds(5),
			ParallelExecution: 1,
			WaitForNetwork: true,
			NetworkWaitTimeout: TimeSpan.FromMinutes(5),
			TakeSnapshotOnSuccess: false,
			SuccessSnapshotName: null,
			RollbackOnFailure: true
		);
}

/// <summary>
/// Result of a VM deployment operation.
/// </summary>
public record VMDeploymentResult(
	bool Success,
	string VMName,
	VMProviderType ProviderType,
	TimeSpan Duration,
	string? Message = null,
	string? ErrorDetails = null,
	IReadOnlyList<VMCommandResult>? CommandResults = null
);

/// <summary>
/// Result of an executed command.
/// </summary>
public record VMCommandResult(string Command, int ExitCode, string StandardOutput, string StandardError, TimeSpan Duration, bool Success);

/// <summary>
/// Health status information for a VM.
/// </summary>
public record VMHealthStatus(
	string VMName,
	VMProviderType ProviderType,
	VMStatus VMStatus,
	VMHealthState HealthState,
	DateTime Timestamp,
	TimeSpan? Uptime = null,
	string? Details = null,
	Exception? LastError = null
);

/// <summary>
/// Health state enumeration.
/// </summary>
public enum VMHealthState
{
	Unknown,
	Healthy,
	Degraded,
	Unhealthy,
	Unreachable,
}

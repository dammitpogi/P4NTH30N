using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Services;

/// <summary>
/// Orchestrates VM deployment operations with comprehensive error handling and rollback support.
/// </summary>
public class VMDeploymentService : IVMDeploymentService
{
	private readonly IVMProviderFactory _providerFactory;
	private readonly IStoreErrors? _errorStore;

	/// <summary>
	/// Initializes a new instance of the deployment service.
	/// </summary>
	/// <param name="providerFactory">Factory for creating VM providers.</param>
	/// <param name="errorStore">Optional error store for logging failures.</param>
	public VMDeploymentService(IVMProviderFactory providerFactory, IStoreErrors? errorStore = null)
	{
		_providerFactory = providerFactory ?? throw new ArgumentNullException(nameof(providerFactory));
		_errorStore = errorStore;
	}

	/// <inheritdoc />
	public async Task<VMDeploymentResult> DeployAsync(VMConfiguration configuration, DeploymentOptions? options = null, CancellationToken cancellationToken = default)
	{
		DateTime startTime = DateTime.UtcNow;
		options ??= DeploymentOptions.Default;

		IVMProvider provider = _providerFactory.CreateProvider(configuration.ProviderType);
		IVMFileTransfer fileTransfer = _providerFactory.CreateFileTransfer(configuration.ProviderType);

		List<VMCommandResult> commandResults = new();
		string? originalSnapshot = null;

		try
		{
			// Step 1: Ensure VM is stopped before restoring snapshot
			LogInfo($"[{configuration.Name}] Checking VM status...");
			VMStatus status = await provider.GetVMStatusAsync(configuration.Name, cancellationToken);

			if (status == VMStatus.Running)
			{
				LogInfo($"[{configuration.Name}] Stopping VM...");
				bool stopped = await provider.StopVMAsync(configuration.Name, force: true, cancellationToken);
				if (!stopped)
				{
					return CreateFailureResult(configuration, startTime, "Failed to stop VM before deployment");
				}
			}

			// Step 2: Restore snapshot if specified
			if (!string.IsNullOrEmpty(configuration.SnapshotToRestore))
			{
				LogInfo($"[{configuration.Name}] Restoring snapshot: {configuration.SnapshotToRestore}");
				bool restored = await provider.RestoreSnapshotAsync(configuration.Name, configuration.SnapshotToRestore, cancellationToken);

				if (!restored)
				{
					return CreateFailureResult(configuration, startTime, $"Failed to restore snapshot: {configuration.SnapshotToRestore}");
				}
			}
			else if (options.RollbackOnFailure)
			{
				// Create a temporary snapshot for rollback
				originalSnapshot = $"pre-deploy-{DateTime.UtcNow:yyyyMMdd-HHmmss}";
				LogInfo($"[{configuration.Name}] Creating rollback snapshot: {originalSnapshot}");
				await provider.CreateSnapshotAsync(configuration.Name, originalSnapshot, "Auto-created before deployment", cancellationToken);
			}

			// Step 3: Start VM
			LogInfo($"[{configuration.Name}] Starting VM...");
			bool started = await provider.StartVMAsync(configuration.Name, cancellationToken);
			if (!started)
			{
				await RollbackIfNeeded(provider, configuration, originalSnapshot, cancellationToken);
				return CreateFailureResult(configuration, startTime, "Failed to start VM");
			}

			// Step 4: Wait for VM to be fully running
			LogInfo($"[{configuration.Name}] Waiting for VM to be ready...");
			bool isRunning = await WaitForStatusAsync(provider, configuration.Name, VMStatus.Running, options.Timeout ?? TimeSpan.FromMinutes(5), cancellationToken);

			if (!isRunning)
			{
				await RollbackIfNeeded(provider, configuration, originalSnapshot, cancellationToken);
				return CreateFailureResult(configuration, startTime, "VM failed to reach running state");
			}

			// Step 5: Execute file transfers
			if (configuration.FileTransfers?.Count > 0)
			{
				LogInfo($"[{configuration.Name}] Transferring {configuration.FileTransfers.Count} file(s)...");
				bool transfersOk = await ExecuteFileTransfersAsync(configuration, fileTransfer, cancellationToken);

				if (!transfersOk)
				{
					await RollbackIfNeeded(provider, configuration, originalSnapshot, cancellationToken);
					return CreateFailureResult(configuration, startTime, "File transfer failed");
				}
			}

			// Step 6: Execute post-deployment commands
			if (configuration.PostDeployCommands?.Count > 0)
			{
				LogInfo($"[{configuration.Name}] Executing {configuration.PostDeployCommands.Count} command(s)...");
				(bool commandsOk, List<VMCommandResult> results) = await ExecuteCommandsAsync(configuration, provider, cancellationToken);

				commandResults = results;

				if (!commandsOk)
				{
					await RollbackIfNeeded(provider, configuration, originalSnapshot, cancellationToken);
					return CreateFailureResult(configuration, startTime, "Post-deployment command failed", null, commandResults);
				}
			}

			// Step 7: Take success snapshot if requested
			if (options.TakeSnapshotOnSuccess && !string.IsNullOrEmpty(options.SuccessSnapshotName))
			{
				LogInfo($"[{configuration.Name}] Creating success snapshot...");
				await provider.CreateSnapshotAsync(configuration.Name, options.SuccessSnapshotName, "Deployment success snapshot", cancellationToken);
			}

			// Step 8: Clean up rollback snapshot if successful
			if (!string.IsNullOrEmpty(originalSnapshot) && !options.RollbackOnFailure)
			{
				await provider.DeleteSnapshotAsync(configuration.Name, originalSnapshot, cancellationToken);
			}

			TimeSpan duration = DateTime.UtcNow - startTime;
			LogInfo($"[{configuration.Name}] Deployment completed successfully in {duration.TotalSeconds:F1}s");

			return new VMDeploymentResult(true, configuration.Name, configuration.ProviderType, duration, "Deployment completed successfully", null, commandResults);
		}
		catch (OperationCanceledException)
		{
			await RollbackIfNeeded(provider, configuration, originalSnapshot, cancellationToken);
			return CreateFailureResult(configuration, startTime, "Deployment was cancelled");
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DeployAsync), configuration.Name);
			await RollbackIfNeeded(provider, configuration, originalSnapshot, cancellationToken);
			return CreateFailureResult(configuration, startTime, $"Deployment failed: {ex.Message}", ex.ToString());
		}
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<VMDeploymentResult>> DeployBatchAsync(
		IEnumerable<VMConfiguration> configurations,
		DeploymentOptions? options = null,
		CancellationToken cancellationToken = default
	)
	{
		options ??= DeploymentOptions.Default;
		VMConfiguration[] configs = configurations.ToArray();

		LogInfo($"Starting batch deployment of {configs.Length} VM(s) with parallelism of {options.ParallelExecution}");

		if (options.ParallelExecution <= 1)
		{
			// Sequential execution
			List<VMDeploymentResult> results = new();
			foreach (VMConfiguration config in configs)
			{
				results.Add(await DeployAsync(config, options, cancellationToken));
			}
			return results;
		}

		// Parallel execution
		SemaphoreSlim semaphore = new(options.ParallelExecution, options.ParallelExecution);
		List<Task<VMDeploymentResult>> tasks = new();

		foreach (VMConfiguration config in configs)
		{
			Task<VMDeploymentResult> task = DeployWithSemaphoreAsync(config, options, semaphore, cancellationToken);
			tasks.Add(task);
		}

		VMDeploymentResult[] batchResults = await Task.WhenAll(tasks);
		return batchResults;
	}

	/// <inheritdoc />
	public async Task<bool> UndeployAsync(string vmName, VMProviderType providerType, bool deleteSnapshots = false, CancellationToken cancellationToken = default)
	{
		try
		{
			IVMProvider provider = _providerFactory.CreateProvider(providerType);

			// Stop the VM
			bool stopped = await provider.StopVMAsync(vmName, force: true, cancellationToken);
			if (!stopped)
			{
				LogError($"Failed to stop VM {vmName}", nameof(UndeployAsync));
				return false;
			}

			// Delete snapshots if requested
			if (deleteSnapshots)
			{
				IReadOnlyList<VMSnapshot> snapshots = await provider.ListSnapshotsAsync(vmName, cancellationToken);
				foreach (VMSnapshot snapshot in snapshots)
				{
					await provider.DeleteSnapshotAsync(vmName, snapshot.Name, cancellationToken);
				}
			}

			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(UndeployAsync), vmName);
			return false;
		}
	}

	/// <inheritdoc />
	public Task<VMStatus> GetStatusAsync(string vmName, VMProviderType providerType, CancellationToken cancellationToken = default)
	{
		IVMProvider provider = _providerFactory.CreateProvider(providerType);
		return provider.GetVMStatusAsync(vmName, cancellationToken);
	}

	/// <summary>
	/// Executes file transfers for a VM configuration.
	/// </summary>
	private static async Task<bool> ExecuteFileTransfersAsync(VMConfiguration configuration, IVMFileTransfer fileTransfer, CancellationToken cancellationToken)
	{
		if (configuration.FileTransfers == null)
			return true;

		foreach (VMFileTransferTask transfer in configuration.FileTransfers)
		{
			bool success = transfer.IsDirectory
				? await fileTransfer.UploadDirectoryAsync(configuration.Name, transfer.SourcePath, transfer.DestinationPath, cancellationToken)
				: await fileTransfer.UploadFileAsync(configuration.Name, transfer.SourcePath, transfer.DestinationPath, cancellationToken);

			if (!success)
			{
				return false;
			}
		}

		return true;
	}

	/// <summary>
	/// Executes post-deployment commands for a VM configuration.
	/// </summary>
	private static async Task<(bool Success, List<VMCommandResult> Results)> ExecuteCommandsAsync(
		VMConfiguration configuration,
		IVMProvider provider,
		CancellationToken cancellationToken
	)
	{
		List<VMCommandResult> results = new();

		if (configuration.PostDeployCommands == null)
			return (true, results);

		foreach (VMCommandTask command in configuration.PostDeployCommands)
		{
			VMExecuteResult result = await provider.ExecuteCommandAsync(
				configuration.Name,
				command.Command,
				command.WorkingDirectory,
				command.Timeout,
				cancellationToken
			);

			VMCommandResult commandResult = new(command.Command, result.ExitCode, result.StandardOutput, result.StandardError, result.Duration, result.ExitCode == 0);

			results.Add(commandResult);

			if (command.FailOnError && result.ExitCode != 0)
			{
				return (false, results);
			}
		}

		return (true, results);
	}

	/// <summary>
	/// Waits for a VM to reach a specific status.
	/// </summary>
	private static async Task<bool> WaitForStatusAsync(IVMProvider provider, string vmName, VMStatus targetStatus, TimeSpan timeout, CancellationToken cancellationToken)
	{
		DateTime deadline = DateTime.UtcNow.Add(timeout);

		while (DateTime.UtcNow < deadline)
		{
			VMStatus status = await provider.GetVMStatusAsync(vmName, cancellationToken);
			if (status == targetStatus)
			{
				return true;
			}

			await Task.Delay(TimeSpan.FromSeconds(2), cancellationToken);
		}

		return false;
	}

	/// <summary>
	/// Rolls back to original snapshot if available.
	/// </summary>
	private static async Task RollbackIfNeeded(IVMProvider provider, VMConfiguration configuration, string? originalSnapshot, CancellationToken cancellationToken)
	{
		if (string.IsNullOrEmpty(originalSnapshot))
			return;

		try
		{
			LogInfo($"[{configuration.Name}] Rolling back to snapshot: {originalSnapshot}");
			await provider.RestoreSnapshotAsync(configuration.Name, originalSnapshot, cancellationToken);
		}
		catch (Exception ex)
		{
			LogError($"[{configuration.Name}] Rollback failed: {ex.Message}", nameof(RollbackIfNeeded));
		}
	}

	/// <summary>
	/// Creates a failure result.
	/// </summary>
	private static VMDeploymentResult CreateFailureResult(
		VMConfiguration configuration,
		DateTime startTime,
		string message,
		string? errorDetails = null,
		IReadOnlyList<VMCommandResult>? commandResults = null
	)
	{
		TimeSpan duration = DateTime.UtcNow - startTime;
		return new VMDeploymentResult(false, configuration.Name, configuration.ProviderType, duration, message, errorDetails, commandResults);
	}

	/// <summary>
	/// Deploys with semaphore for throttling.
	/// </summary>
	private async Task<VMDeploymentResult> DeployWithSemaphoreAsync(
		VMConfiguration config,
		DeploymentOptions options,
		SemaphoreSlim semaphore,
		CancellationToken cancellationToken
	)
	{
		await semaphore.WaitAsync(cancellationToken);
		try
		{
			return await DeployAsync(config, options, cancellationToken);
		}
		finally
		{
			semaphore.Release();
		}
	}

	/// <summary>
	/// Logs an info message.
	/// </summary>
	private static void LogInfo(string message)
	{
		Console.WriteLine($"[VMDeployment] {message}");
	}

	/// <summary>
	/// Logs an error with line number.
	/// </summary>
	private static void LogError(string message, string operation)
	{
		var frame = new StackTrace(1, true).GetFrame(0);
		int line = frame?.GetFileLineNumber() ?? 0;
		Console.WriteLine($"[{line}] [VMDeployment] {operation}: {message}");
	}

	/// <summary>
	/// Logs an exception with line number.
	/// </summary>
	private void LogException(Exception ex, string operation, string context)
	{
		var frame = new StackTrace(ex, true).GetFrame(0);
		int line = frame?.GetFileLineNumber() ?? 0;
		string message = $"[{line}] [VMDeployment] {operation} [{context}]: {ex.Message}";
		Console.WriteLine(message);
		_errorStore?.Insert(
			new ErrorLog
			{
				Message = message,
				Source = "VMDeploymentService",
				StackTrace = ex.StackTrace,
				Timestamp = DateTime.UtcNow,
				Resolved = false,
			}
		);
	}
}

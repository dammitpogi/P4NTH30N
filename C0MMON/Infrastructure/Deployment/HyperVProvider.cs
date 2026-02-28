using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Infrastructure.Deployment;

/// <summary>
/// Hyper-V VM provider implementation using PowerShell cmdlets.
/// </summary>
public class HyperVProvider : IVMProvider
{
	private readonly TimeSpan _defaultTimeout = TimeSpan.FromMinutes(5);

	/// <inheritdoc />
	public VMProviderType ProviderType => VMProviderType.HyperV;

	/// <inheritdoc />
	public async Task<bool> StartVMAsync(string vmName, CancellationToken cancellationToken = default)
	{
		try
		{
			string command = $"Start-VM -Name '{EscapePowerShellString(vmName)}' -Passthru | Select-Object -ExpandProperty State";
			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(StartVMAsync));
				return false;
			}

			return result.StandardOutput.Contains("Running", StringComparison.OrdinalIgnoreCase);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(StartVMAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> StopVMAsync(string vmName, bool force = false, CancellationToken cancellationToken = default)
	{
		try
		{
			string command;
			if (force)
			{
				command = $"Stop-VM -Name '{EscapePowerShellString(vmName)}' -TurnOff -Force -Passthru | Select-Object -ExpandProperty State";
			}
			else
			{
				command =
					$"Shutdown-VMGuest -Name '{EscapePowerShellString(vmName)}' -Force; Start-Sleep -Seconds 30; "
					+ $"$vm = Get-VM -Name '{EscapePowerShellString(vmName)}'; if ($vm.State -ne 'Off') {{ Stop-VM -Name '{EscapePowerShellString(vmName)}' -TurnOff -Force }}; "
					+ $"$vm.State";
			}

			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(StopVMAsync));
				return false;
			}

			return result.StandardOutput.Contains("Off", StringComparison.OrdinalIgnoreCase);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(StopVMAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<VMStatus> GetVMStatusAsync(string vmName, CancellationToken cancellationToken = default)
	{
		try
		{
			string command = $"(Get-VM -Name '{EscapePowerShellString(vmName)}').State.ToString()";
			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(GetVMStatusAsync));
				return VMStatus.Unknown;
			}

			string state = result.StandardOutput.Trim();
			return ParseVMStatus(state);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(GetVMStatusAsync));
			return VMStatus.Unknown;
		}
	}

	/// <inheritdoc />
	public async Task<VMExecuteResult> ExecuteCommandAsync(
		string vmName,
		string command,
		string? workingDirectory = null,
		TimeSpan? timeout = null,
		CancellationToken cancellationToken = default
	)
	{
		TimeSpan effectiveTimeout = timeout ?? _defaultTimeout;
		DateTime startTime = DateTime.UtcNow;

		try
		{
			// Use PowerShell Direct (Invoke-Command -VMName) for guest execution
			string escapedCommand = EscapePowerShellString(command);
			string workingDirParam = workingDirectory != null ? $"-WorkingDirectory '{EscapePowerShellString(workingDirectory)}'" : string.Empty;

			string psCommand =
				$"Invoke-Command -VMName '{EscapePowerShellString(vmName)}' -ScriptBlock {{ "
				+ $"$output = Invoke-Expression '{escapedCommand}' 2>&1; "
				+ $"$exitCode = $LASTEXITCODE; "
				+ $"[PSCustomObject]@{{ Output = ($output -join \"`n\"); ExitCode = $exitCode }} "
				+ $"}} {workingDirParam}";

			using CancellationTokenSource cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
			cts.CancelAfter(effectiveTimeout);

			ProcessResult result = await ExecutePowerShellAsync(psCommand, cts.Token);
			TimeSpan duration = DateTime.UtcNow - startTime;

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(ExecuteCommandAsync));
				return new VMExecuteResult(-1, string.Empty, result.StandardError, duration);
			}

			// Parse the output to extract exit code and stdout
			(string output, int exitCode) = ParseInvokeCommandOutput(result.StandardOutput);
			return new VMExecuteResult(exitCode, output, string.Empty, duration);
		}
		catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
		{
			// Timeout occurred
			TimeSpan duration = DateTime.UtcNow - startTime;
			return new VMExecuteResult(-1, string.Empty, "Command execution timed out", duration);
		}
		catch (Exception ex)
		{
			TimeSpan duration = DateTime.UtcNow - startTime;
			LogException(ex, nameof(ExecuteCommandAsync));
			return new VMExecuteResult(-1, string.Empty, ex.Message, duration);
		}
	}

	/// <inheritdoc />
	public async Task<bool> CreateSnapshotAsync(string vmName, string snapshotName, string? description = null, CancellationToken cancellationToken = default)
	{
		try
		{
			string descParam = description != null ? $"-Notes '{EscapePowerShellString(description)}'" : string.Empty;

			string command = $"Checkpoint-VM -Name '{EscapePowerShellString(vmName)}' -SnapshotName '{EscapePowerShellString(snapshotName)}' {descParam}";
			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(CreateSnapshotAsync));
				return false;
			}

			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(CreateSnapshotAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<bool> RestoreSnapshotAsync(string vmName, string snapshotName, CancellationToken cancellationToken = default)
	{
		try
		{
			// Stop VM first if running
			VMStatus status = await GetVMStatusAsync(vmName, cancellationToken);
			if (status == VMStatus.Running)
			{
				bool stopped = await StopVMAsync(vmName, force: true, cancellationToken);
				if (!stopped)
					return false;
			}

			string command = $"Restore-VMSnapshot -Name '{EscapePowerShellString(snapshotName)}' -VMName '{EscapePowerShellString(vmName)}' -Confirm:$false";
			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(RestoreSnapshotAsync));
				return false;
			}

			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(RestoreSnapshotAsync));
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<VMSnapshot>> ListSnapshotsAsync(string vmName, CancellationToken cancellationToken = default)
	{
		try
		{
			string command =
				$"Get-VMSnapshot -VMName '{EscapePowerShellString(vmName)}' | " + "Select-Object Name, CreationTime, Notes, IsCurrent | ConvertTo-Csv -NoTypeInformation";

			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(ListSnapshotsAsync));
				return Array.Empty<VMSnapshot>();
			}

			return ParseSnapshotsFromCsv(result.StandardOutput, vmName);
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(ListSnapshotsAsync));
			return Array.Empty<VMSnapshot>();
		}
	}

	/// <inheritdoc />
	public async Task<bool> DeleteSnapshotAsync(string vmName, string snapshotName, CancellationToken cancellationToken = default)
	{
		try
		{
			string command = $"Remove-VMSnapshot -Name '{EscapePowerShellString(snapshotName)}' -VMName '{EscapePowerShellString(vmName)}' -Confirm:$false";
			ProcessResult result = await ExecutePowerShellAsync(command, cancellationToken);

			if (result.ExitCode != 0)
			{
				LogError(result, nameof(DeleteSnapshotAsync));
				return false;
			}

			return true;
		}
		catch (Exception ex)
		{
			LogException(ex, nameof(DeleteSnapshotAsync));
			return false;
		}
	}

	/// <summary>
	/// Executes a PowerShell command and returns the result.
	/// </summary>
	private async Task<ProcessResult> ExecutePowerShellAsync(string command, CancellationToken cancellationToken)
	{
		using Process process = new();
		process.StartInfo.FileName = "powershell.exe";
		process.StartInfo.Arguments = $"-NoProfile -NonInteractive -Command \"{command.Replace("\"", "\"\"")}\"";
		process.StartInfo.RedirectStandardOutput = true;
		process.StartInfo.RedirectStandardError = true;
		process.StartInfo.UseShellExecute = false;
		process.StartInfo.CreateNoWindow = true;

		StringBuilder stdout = new();
		StringBuilder stderr = new();

		process.OutputDataReceived += (_, e) =>
		{
			if (e.Data != null)
				stdout.AppendLine(e.Data);
		};
		process.ErrorDataReceived += (_, e) =>
		{
			if (e.Data != null)
				stderr.AppendLine(e.Data);
		};

		process.Start();
		process.BeginOutputReadLine();
		process.BeginErrorReadLine();

		await process.WaitForExitAsync(cancellationToken);

		return new ProcessResult(process.ExitCode, stdout.ToString(), stderr.ToString());
	}

	/// <summary>
	/// Escapes a string for PowerShell.
	/// </summary>
	private static string EscapePowerShellString(string input)
	{
		return input.Replace("'", "''");
	}

	/// <summary>
	/// Parses VM status from PowerShell output.
	/// </summary>
	private static VMStatus ParseVMStatus(string state)
	{
		return state.ToLowerInvariant() switch
		{
			"off" => VMStatus.Stopped,
			"running" => VMStatus.Running,
			"paused" => VMStatus.Paused,
			"saved" => VMStatus.Saved,
			"starting" => VMStatus.Starting,
			_ => VMStatus.Unknown,
		};
	}

	/// <summary>
	/// Parses Invoke-Command output to extract exit code and output.
	/// </summary>
	private static (string Output, int ExitCode) ParseInvokeCommandOutput(string output)
	{
		// The output contains the PSCustomObject serialized
		// Look for ExitCode and Output properties
		string[] lines = output.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
		int exitCode = 0;
		List<string> outputLines = new();

		foreach (string line in lines)
		{
			if (line.StartsWith("ExitCode", StringComparison.OrdinalIgnoreCase))
			{
				string[] parts = line.Split(':');
				if (parts.Length > 1 && int.TryParse(parts[1].Trim(), out int code))
				{
					exitCode = code;
				}
			}
			else if (!line.StartsWith("@{", StringComparison.Ordinal) && !line.StartsWith("}", StringComparison.Ordinal))
			{
				outputLines.Add(line);
			}
		}

		return (string.Join("\n", outputLines), exitCode);
	}

	/// <summary>
	/// Parses snapshot list from CSV output.
	/// </summary>
	private static IReadOnlyList<VMSnapshot> ParseSnapshotsFromCsv(string csv, string vmName)
	{
		List<VMSnapshot> snapshots = new();
		string[] lines = csv.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);

		if (lines.Length < 2) // Header + at least one data row
			return snapshots;

		string[] headers = lines[0].Split(',');

		for (int i = 1; i < lines.Length; i++)
		{
			string[] values = lines[i].Split(',');
			if (values.Length >= 4)
			{
				snapshots.Add(
					new VMSnapshot(
						Name: values[0].Trim('"'),
						CreatedAt: DateTime.TryParse(values[1].Trim('"'), out DateTime created) ? created : DateTime.MinValue,
						Description: values[2].Trim('"'),
						IsCurrent: bool.TryParse(values[3].Trim('"'), out bool isCurrent) && isCurrent
					)
				);
			}
		}

		return snapshots;
	}

	/// <summary>
	/// Logs an error with line number information.
	/// </summary>
	private static void LogError(ProcessResult result, string operation)
	{
		var frame = new StackTrace(1, true).GetFrame(0);
		int line = frame?.GetFileLineNumber() ?? 0;
		Console.WriteLine($"[{line}] Hyper-V {operation} failed: ExitCode={result.ExitCode}, Error={result.StandardError}");
	}

	/// <summary>
	/// Logs an exception with line number information.
	/// </summary>
	private static void LogException(Exception ex, string operation)
	{
		var frame = new StackTrace(ex, true).GetFrame(0);
		int line = frame?.GetFileLineNumber() ?? 0;
		Console.WriteLine($"[{line}] Hyper-V {operation} exception: {ex.Message}");
	}

	/// <summary>
	/// Result of a process execution.
	/// </summary>
	private record ProcessResult(int ExitCode, string StandardOutput, string StandardError);
}

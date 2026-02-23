using System.Diagnostics;
using H0UND.Infrastructure.BootTime;

namespace H0UND.Services.Orchestration;

/// <summary>
/// Service for managing ToolHive workloads.
/// Requires ToolHive CLI (thv) to be installed and in PATH.
/// </summary>
public class ToolHiveWorkloadService : IDisposable
{
    private readonly List<string> _workloads;
    private readonly Process? _toolHiveProcess;
    private bool _disposed;

    public bool IsRunning { get; private set; }
    public IReadOnlyList<string> Workloads => _workloads;

    public event EventHandler<string>? LogMessage;

    public ToolHiveWorkloadService(ToolHiveConfig config)
    {
        _workloads = config.AutoStartWorkloads ?? new List<string>();

        // Try to start ToolHive desktop if enabled and path found
        string? thvPath = ToolHiveConfig.ResolveToolHivePath();
        if (config.Enabled && thvPath != null)
        {
            try
            {
                _toolHiveProcess = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = thvPath,
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true,
                    },
                    EnableRaisingEvents = true,
                };

                _toolHiveProcess.OutputDataReceived += (_, e) =>
                {
                    if (e.Data != null)
                        LogMessage?.Invoke(this, $"[ToolHive] {e.Data}");
                };
                _toolHiveProcess.ErrorDataReceived += (_, e) =>
                {
                    if (e.Data != null)
                        LogMessage?.Invoke(this, $"[ToolHive Error] {e.Data}");
                };

                _toolHiveProcess.Start();
                _toolHiveProcess.BeginOutputReadLine();
                _toolHiveProcess.BeginErrorReadLine();

                IsRunning = true;
                LogMessage?.Invoke(this, "ToolHive Desktop started");
            }
            catch (Exception ex)
            {
                LogMessage?.Invoke(this, $"Failed to start ToolHive: {ex.Message}");
                IsRunning = false;
            }
        }
    }

    /// <summary>
    /// Starts all configured workloads via ToolHive CLI.
    /// Returns list of workloads that were started successfully.
    /// </summary>
    public async Task<List<string>> StartWorkloadsAsync(CancellationToken cancellationToken = default)
    {
        var started = new List<string>();

        foreach (string workload in _workloads)
        {
            try
            {
                var result = await RunThvCommandAsync($"start {workload}", cancellationToken);

                if (result.ExitCode == 0)
                {
                    started.Add(workload);
                    LogMessage?.Invoke(this, $"Started workload: {workload}");
                }
                else
                {
                    LogMessage?.Invoke(this, $"Failed to start {workload}: {result.Output}");
                }
            }
            catch (Exception ex)
            {
                LogMessage?.Invoke(this, $"Error starting {workload}: {ex.Message}");
            }
        }

        return started;
    }

    /// <summary>
    /// Stops all configured workloads via ToolHive CLI.
    /// </summary>
    public async Task StopWorkloadsAsync(CancellationToken cancellationToken = default)
    {
        foreach (string workload in _workloads)
        {
            try
            {
                var result = await RunThvCommandAsync($"stop {workload}", cancellationToken);
                LogMessage?.Invoke(this, $"Stopped workload: {workload}");
            }
            catch (Exception ex)
            {
                LogMessage?.Invoke(this, $"Error stopping {workload}: {ex.Message}");
            }
        }
    }

    /// <summary>
    /// Gets status of all configured workloads.
    /// </summary>
    public async Task<Dictionary<string, bool>> GetWorkloadStatusAsync(CancellationToken cancellationToken = default)
    {
        var status = new Dictionary<string, bool>();

        try
        {
            var result = await RunThvCommandAsync("list", cancellationToken);

            if (result.ExitCode == 0)
            {
                foreach (string workload in _workloads)
                {
                    // Parse output to determine running status
                    status[workload] = result.Output.Contains(workload) && result.Output.Contains("running");
                }
            }
        }
        catch (Exception ex)
        {
            LogMessage?.Invoke(this, $"Error getting workload status: {ex.Message}");
        }

        return status;
    }

    private async Task<(int ExitCode, string Output)> RunThvCommandAsync(string arguments, CancellationToken cancellationToken)
    {
        // Try common thv locations
        string[] thvCandidates =
        [
            "thv",
            @"C:\Program Files\ToolHive\thv.exe",
            @"C:\Program Files (x86)\ToolHive\thv.exe",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "ToolHive", "bin", "thv.exe"),
        ];

        string? thvPath = null;
        foreach (string candidate in thvCandidates)
        {
            try
            {
                var testProcess = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = candidate,
                        Arguments = "--version",
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        CreateNoWindow = true,
                    },
                };
                testProcess.Start();
                await testProcess.WaitForExitAsync(cancellationToken);

                if (testProcess.ExitCode == 0)
                {
                    thvPath = candidate;
                    break;
                }
            }
            catch
            {
                // Try next candidate
            }
        }

        if (thvPath == null)
        {
            return (-1, "thv CLI not found");
        }

        var psi = new ProcessStartInfo
        {
            FileName = thvPath,
            Arguments = arguments,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true,
        };

        using var process = new Process { StartInfo = psi };
        process.Start();

        string output = await process.StandardOutput.ReadToEndAsync(cancellationToken);
        string error = await process.StandardError.ReadToEndAsync(cancellationToken);

        await process.WaitForExitAsync(cancellationToken);

        return (process.ExitCode, string.IsNullOrEmpty(error) ? output : error);
    }

    public void Dispose()
    {
        if (_disposed)
            return;

        _disposed = true;

        if (_toolHiveProcess != null && !_toolHiveProcess.HasExited)
        {
            try
            {
                _toolHiveProcess.Kill();
            }
            catch
            {
                // Ignore
            }
        }
    }
}

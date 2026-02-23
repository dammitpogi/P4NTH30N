using System.Diagnostics;

namespace H0UND.Services.Orchestration;

public class StdioManagedService : ManagedService
{
    private readonly string _executablePath;
    private readonly string _arguments;

    public StdioManagedService(string name, string executablePath, string arguments)
        : base(name)
    {
        _executablePath = executablePath;
        _arguments = arguments;
    }

    public override Task StartAsync(CancellationToken cancellationToken = default)
    {
        if (Process is not null && !Process.HasExited)
        {
            Log("Already running");
            return Task.CompletedTask;
        }

        SetStatus(ServiceStatus.Starting, "Launching process");

        var startInfo = new ProcessStartInfo
        {
            FileName = _executablePath,
            Arguments = _arguments,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            RedirectStandardInput = true,
            CreateNoWindow = true,
        };

        Process = new Process { StartInfo = startInfo };
        Process.EnableRaisingEvents = true;
        Process.Exited += (_, _) =>
        {
            Log("Process exited");
            SetStatus(ServiceStatus.Error, "Process exited unexpectedly");
        };
        Process.OutputDataReceived += (_, e) =>
        {
            if (!string.IsNullOrWhiteSpace(e.Data))
            {
                Log($"[OUT] {e.Data}");
            }
        };
        Process.ErrorDataReceived += (_, e) =>
        {
            if (!string.IsNullOrWhiteSpace(e.Data))
            {
                Log($"[ERR] {e.Data}");
            }
        };
        Process.Start();
        Process.BeginOutputReadLine();
        Process.BeginErrorReadLine();
        SetStatus(ServiceStatus.Running);
        return Task.CompletedTask;
    }

    public override async Task StopAsync(CancellationToken cancellationToken = default)
    {
        if (Process is null || Process.HasExited)
        {
            SetStatus(ServiceStatus.Stopped);
            return;
        }

        SetStatus(ServiceStatus.Stopping);
        Process.Kill();
        await Process.WaitForExitAsync(cancellationToken);
        SetStatus(ServiceStatus.Stopped);
    }

    public override Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default)
    {
        return Task.FromResult(Process is not null && !Process.HasExited);
    }
}

using System.Diagnostics;

namespace H0UND.Services.Orchestration;

public class HttpManagedService : ManagedService
{
    private readonly string _executablePath;
    private readonly string _arguments;
    private readonly string _healthCheckUrl;
    private readonly HttpClient _httpClient;

    public HttpManagedService(
        string name,
        string executablePath,
        string arguments,
        string healthCheckUrl)
        : base(name)
    {
        _executablePath = executablePath;
        _arguments = arguments;
        _healthCheckUrl = healthCheckUrl;
        _httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
    }

    public override async Task StartAsync(CancellationToken cancellationToken = default)
    {
        if (Process is not null && !Process.HasExited)
        {
            Log("Already running");
            return;
        }

        SetStatus(ServiceStatus.Starting, "Launching process");

        var startInfo = new ProcessStartInfo
        {
            FileName = _executablePath,
            Arguments = _arguments,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
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
            if (e.Data is not null)
            {
                Log($"[OUT] {e.Data}");
            }
        };
        Process.ErrorDataReceived += (_, e) =>
        {
            if (e.Data is not null)
            {
                Log($"[ERR] {e.Data}");
            }
        };

        Process.Start();
        Process.BeginOutputReadLine();
        Process.BeginErrorReadLine();

        var healthy = await WaitForHealthyAsync(cancellationToken);
        SetStatus(healthy ? ServiceStatus.Running : ServiceStatus.Error,
            healthy ? null : "Health check failed");

        if (!healthy)
        {
            await StopAsync(cancellationToken);
        }
    }

    private async Task<bool> WaitForHealthyAsync(CancellationToken cancellationToken)
    {
        for (var i = 0; i < 30; i++)
        {
            if (await HealthCheckAsync(cancellationToken))
            {
                return true;
            }

            await Task.Delay(1000, cancellationToken);
        }

        return false;
    }

    public override async Task StopAsync(CancellationToken cancellationToken = default)
    {
        if (Process is null || Process.HasExited)
        {
            SetStatus(ServiceStatus.Stopped);
            return;
        }

        SetStatus(ServiceStatus.Stopping);
        Process.CloseMainWindow();
        await Task.Delay(2000, cancellationToken);

        if (!Process.HasExited)
        {
            Process.Kill();
            await Process.WaitForExitAsync(cancellationToken);
        }

        SetStatus(ServiceStatus.Stopped);
    }

    public override async Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default)
    {
        try
        {
            var response = await _httpClient.GetAsync(_healthCheckUrl, cancellationToken);
            return response.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }

    public override void Dispose()
    {
        base.Dispose();
        _httpClient.Dispose();
    }
}

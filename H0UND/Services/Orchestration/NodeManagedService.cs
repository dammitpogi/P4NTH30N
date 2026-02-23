using System.Diagnostics;

namespace H0UND.Services.Orchestration;

/// <summary>
/// Managed service for Node.js MCP servers with support for:
/// - Working directory configuration
/// - Environment variable injection
/// - Startup delay for dependency ordering
/// - HTTP health checks
/// </summary>
public class NodeManagedService : ManagedService
{
    private readonly string _executablePath;
    private readonly string _arguments;
    private readonly string? _healthCheckUrl;
    private readonly string? _workingDirectory;
    private readonly Dictionary<string, string> _environment;
    private readonly int _startupDelaySeconds;
    private readonly HttpClient _httpClient;

    public NodeManagedService(
        string name,
        string executablePath,
        string arguments,
        string? healthCheckUrl = null,
        string? workingDirectory = null,
        Dictionary<string, string>? environment = null,
        int startupDelaySeconds = 0)
        : base(name)
    {
        _executablePath = executablePath;
        _arguments = arguments;
        _healthCheckUrl = healthCheckUrl;
        _workingDirectory = workingDirectory;
        _environment = environment ?? new Dictionary<string, string>();
        _startupDelaySeconds = startupDelaySeconds;
        _httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
    }

    public override async Task StartAsync(CancellationToken cancellationToken = default)
    {
        if (Process is not null && !Process.HasExited)
        {
            Log("Already running");
            return;
        }

        // Apply startup delay if configured
        if (_startupDelaySeconds > 0)
        {
            SetStatus(ServiceStatus.Starting, $"Waiting {_startupDelaySeconds}s startup delay");
            await Task.Delay(TimeSpan.FromSeconds(_startupDelaySeconds), cancellationToken);
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

        // Set working directory if specified
        if (!string.IsNullOrWhiteSpace(_workingDirectory) && Directory.Exists(_workingDirectory))
        {
            startInfo.WorkingDirectory = _workingDirectory;
        }

        // Inject environment variables
        foreach (var (key, value) in _environment)
        {
            startInfo.Environment[key] = value;
        }

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

        // Wait for health check if URL is provided
        if (!string.IsNullOrWhiteSpace(_healthCheckUrl))
        {
            var healthy = await WaitForHealthyAsync(cancellationToken);
            SetStatus(healthy ? ServiceStatus.Running : ServiceStatus.Error,
                healthy ? null : "Health check failed");

            if (!healthy)
            {
                await StopAsync(cancellationToken);
            }
        }
        else
        {
            // No health check - just verify process started
            await Task.Delay(1000, cancellationToken);
            SetStatus(Process.HasExited ? ServiceStatus.Error : ServiceStatus.Running,
                Process.HasExited ? "Process exited immediately" : null);
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
        if (string.IsNullOrWhiteSpace(_healthCheckUrl))
        {
            return Process is not null && !Process.HasExited;
        }

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

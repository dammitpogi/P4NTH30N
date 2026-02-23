using System.Text.Json;

namespace H0UND.Infrastructure.BootTime;

public sealed class AutostartConfig
{
    public List<ManagedServiceConfig> Services { get; init; } = [];
    public ToolHiveConfig ToolHive { get; init; } = new();
    public StartupConfig Startup { get; init; } = new();

    public static AutostartConfig LoadOrDefault(string path)
    {
        if (!File.Exists(path))
        {
            return new AutostartConfig();
        }

        try
        {
            var json = File.ReadAllText(path);
            var config = JsonSerializer.Deserialize<AutostartConfig>(
                json,
                new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                });
            return config ?? new AutostartConfig();
        }
        catch
        {
            return new AutostartConfig();
        }
    }
}

public sealed class ManagedServiceConfig
{
    public string Name { get; init; } = string.Empty;
    public string Type { get; init; } = string.Empty;
    public string Executable { get; init; } = string.Empty;
    public string Arguments { get; init; } = string.Empty;
    public string? HealthCheckUrl { get; init; }
    public string? WorkingDirectory { get; init; }
    public Dictionary<string, string> Environment { get; init; } = new();
    public int StartupDelay { get; init; }
    public List<string> DependsOn { get; init; } = new();
}

public sealed class ToolHiveConfig
{
    public bool Enabled { get; init; } = true;
    public List<string> AutoStartWorkloads { get; init; } = new();

    /// <summary>
    /// Resolves ToolHive executable path from standard locations.
    /// </summary>
    public static string? ResolveToolHivePath()
    {
        string[] candidates =
        [
            @"C:\Program Files\ToolHive\ToolHive.exe",
            @"C:\Program Files (x86)\ToolHive\ToolHive.exe",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "ToolHive", "ToolHive.exe"),
        ];

        foreach (string candidate in candidates)
        {
            if (File.Exists(candidate))
            {
                return candidate;
            }
        }

        return null;
    }
}

public sealed class StartupConfig
{
    /// <summary>
    /// Global delay before starting any services (seconds).
    /// </summary>
    public int DelaySeconds { get; init; } = 0;

    /// <summary>
    /// Interval between starting each service (seconds).
    /// </summary>
    public int ServiceStartInterval { get; init; } = 0;

    /// <summary>
    /// Whether to stagger service starts.
    /// </summary>
    public bool StaggerEnabled => ServiceStartInterval > 0;
}

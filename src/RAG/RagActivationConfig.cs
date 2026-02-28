using System.Text.Json;

namespace P4NTHE0N.RAG;

/// <summary>
/// Configuration for RAG activation, watching, and bulk ingestion.
/// Loaded from rag-activation.json config file.
/// </summary>
public sealed class RagActivationConfig
{
    public string Version { get; init; } = "1.0.0";
    public string Description { get; init; } = string.Empty;
    public RagHostConfig RagHost { get; init; } = new();
    public FileWatcherOptions FileWatcher { get; init; } = new();
    public BulkIngestionConfig BulkIngestion { get; init; } = new();

    /// <summary>
    /// Loads RAG activation config from the standard location.
    /// Falls back to defaults if file not found.
    /// </summary>
    public static RagActivationConfig LoadOrDefault()
    {
        return LoadOrDefault(ResolveConfigPath());
    }

    /// <summary>
    /// Loads RAG activation config from a specific path.
    /// Falls back to defaults if file not found or invalid.
    /// </summary>
    public static RagActivationConfig LoadOrDefault(string path)
    {
        if (!File.Exists(path))
        {
            Console.WriteLine($"[RagActivationConfig] Config not found at {path}, using defaults");
            return new RagActivationConfig();
        }

        try
        {
            string json = File.ReadAllText(path);
            var config = JsonSerializer.Deserialize<RagActivationConfig>(
                json,
                new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                    ReadCommentHandling = JsonCommentHandling.Skip,
                    AllowTrailingCommas = true,
                });

            if (config == null)
            {
                Console.WriteLine($"[RagActivationConfig] Failed to parse {path}, using defaults");
                return new RagActivationConfig();
            }

            Console.WriteLine($"[RagActivationConfig] Loaded from {path}");
            return config;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[RagActivationConfig] Error loading {path}: {ex.Message}, using defaults");
            return new RagActivationConfig();
        }
    }

    private static string ResolveConfigPath()
    {
        // Check environment variable first
        string? envPath = Environment.GetEnvironmentVariable("P4NTHE0N_RAG_ACTIVATION_CONFIG");
        if (!string.IsNullOrWhiteSpace(envPath) && File.Exists(envPath))
        {
            return envPath;
        }

        // Standard locations
        string[] candidates =
        [
            @"C:\P4NTHE0N\config\rag-activation.json",
            @"C:\P4NTH30N\config\rag-activation.json",
            Path.Combine(AppContext.BaseDirectory, "config", "rag-activation.json"),
            Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "config", "rag-activation.json")),
        ];

        foreach (string candidate in candidates)
        {
            if (File.Exists(candidate))
            {
                return candidate;
            }
        }

        return candidates[0];
    }
}

/// <summary>
/// RAG MCP host configuration.
/// </summary>
public sealed class RagHostConfig
{
    public string Executable { get; init; } = string.Empty;
    public int Port { get; init; } = 5001;
    public List<string> StartupArgs { get; init; } = new();
    public string HealthCheckUrl { get; init; } = string.Empty;
}

/// <summary>
/// File watcher configuration options.
/// </summary>
public sealed class FileWatcherOptions
{
    public bool Enabled { get; init; } = true;
    public int DebounceMinutes { get; init; } = 5;
    public List<string> WatchPaths { get; init; } = new()
    {
        @"C:\P4NTHE0N\docs",
        @"C:\P4NTHE0N\STR4TEG15T\decisions",
        @"C:\P4NTH30N\STR4TEG15T\decisions",
    };
    public List<string> FilePatterns { get; init; } = new() { "*.md", "*.json" };
    public List<string> ExcludeDirectories { get; init; } = new() { "bin", "obj", ".git", "node_modules", "Releases" };
}

/// <summary>
/// Bulk ingestion configuration for initial or periodic index rebuilds.
/// </summary>
public sealed class BulkIngestionConfig
{
    public bool Enabled { get; init; } = false;
    public List<IngestionDirectory> Directories { get; init; } = new();
    public List<string> RootDocuments { get; init; } = new();
}

/// <summary>
/// A directory to bulk ingest with metadata tagging.
/// </summary>
public sealed class IngestionDirectory
{
    public string Path { get; init; } = string.Empty;
    public string Tag { get; init; } = string.Empty;
    public string Priority { get; init; } = "medium";
}

using System.ServiceProcess;

namespace VPN_CLI;

/// <summary>
/// Comprehensive CyberGhost status information
/// </summary>
public class CyberGhostStatus
{
    public bool Success { get; set; }
    public string? Error { get; set; }
    public DateTime Timestamp { get; set; }
    
    // Service status
    public ServiceControllerStatus ServiceStatus { get; set; }
    public bool ServiceRunning { get; set; }
    
    // Process status
    public int ProcessCount { get; set; }
    public bool ProcessesRunning { get; set; }
    
    // Connection status
    public ConnectionStatus? ConnectionStatus { get; set; }
    public bool IsConnected { get; set; }
    
    // Server information
    public ServerInfo? CurrentServer { get; set; }
    public bool IsCompliant { get; set; }
}

/// <summary>
/// VPN connection status details
/// </summary>
public class ConnectionStatus
{
    public bool Connected { get; set; }
    public string? ServerName { get; set; }
    public string? ServerCountry { get; set; }
    public string? ServerCity { get; set; }
    public string? PublicIP { get; set; }
    public string? InternalIP { get; set; }
    public DateTime? ConnectionTime { get; set; }
    public TimeSpan? Duration => ConnectionTime.HasValue ? DateTime.Now - ConnectionTime.Value : null;
    public string? Protocol { get; set; } // WireGuard, OpenVPN, etc.
    public int? Port { get; set; }
    public long BytesReceived { get; set; }
    public long BytesSent { get; set; }
    public double DownloadSpeedMbps { get; set; }
    public double UploadSpeedMbps { get; set; }
}

/// <summary>
/// VPN server information
/// </summary>
public class ServerInfo
{
    public string Id { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public string? State { get; set; }
    public string City { get; set; } = string.Empty;
    public string? CountryCode { get; set; }
    public int Load { get; set; } // 0-100 percentage
    public int Ping { get; set; } // ms
    public bool IsOnline { get; set; } = true;
    public bool SupportsTorrenting { get; set; }
    public bool SupportsStreaming { get; set; }
    public string[] SupportedProtocols { get; set; } = Array.Empty<string>();
    public double Score { get; set; } // Quality score
    public string? Flag { get; set; } // Country flag emoji
    public GeoLocation? Location { get; set; }
}

/// <summary>
/// Geographic location information
/// </summary>
public class GeoLocation
{
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? Region { get; set; }
    public string? Timezone { get; set; }
}

/// <summary>
/// Process information for CyberGhost components
/// </summary>
public class ProcessInfo
{
    public string Name { get; set; } = string.Empty;
    public int Id { get; set; }
    public DateTime StartTime { get; set; }
    public long MemoryUsageMB { get; set; }
    public bool HasMainWindow { get; set; }
    public string? WindowTitle { get; set; }
    public string? ExecutablePath { get; set; }
    public string? CommandLine { get; set; }
    public string? User { get; set; }
}

/// <summary>
/// Result of a VPN operation (connect, disconnect, change server)
/// </summary>
public class VpnOperationResult
{
    public bool Success { get; set; }
    public string? Error { get; set; }
    public string? Message { get; set; }
    public string Operation { get; set; } = string.Empty;
    public DateTime StartTime { get; set; }
    public DateTime? EndTime { get; set; }
    public TimeSpan Duration { get; set; }
    public Dictionary<string, object> Metadata { get; set; } = new();
    
    // Connection-specific results
    public string? NewIP { get; set; }
    public ServerInfo? ConnectedServer { get; set; }
    public ConnectionStatus? ConnectionDetails { get; set; }
}

/// <summary>
/// Result of named pipe communication
/// </summary>
public class PipeOperationResult
{
    public bool Success { get; set; }
    public string? Error { get; set; }
    public string? Response { get; set; }
    public TimeSpan Duration { get; set; }
}

/// <summary>
/// Configuration for direct CyberGhost control
/// </summary>
public class CyberGhostConfig
{
    public string ServiceName { get; set; } = "CyberGhost8Service";
    public string PipeName { get; set; } = "CyberGhost";
    public string InstallPath { get; set; } = @"C:\Program Files\CyberGhost 8";
    public int CommandTimeoutMs { get; set; } = 30000;
    public int ConnectionTimeoutMs { get; set; } = 60000;
    public bool EnableProcessInjection { get; set; } = true;
    public bool EnableRegistryFallback { get; set; } = true;
    public string[] ForbiddenRegions { get; set; } = { "Nevada", "California", "US-NV", "US-CA" };
    public string[] PreferredCountries { get; set; } = { "Netherlands", "Germany", "Switzerland", "Sweden" };
}

/// <summary>
/// Advanced connection metrics and diagnostics
/// </summary>
public class ConnectionDiagnostics
{
    public DateTime TestTime { get; set; }
    public bool DnsLeakDetected { get; set; }
    public bool IpLeakDetected { get; set; }
    public bool WebRtcLeakDetected { get; set; }
    public string? RealIP { get; set; }
    public string? ReportedIP { get; set; }
    public List<string> DnsServers { get; set; } = new();
    public double LatencyMs { get; set; }
    public double DownloadSpeedMbps { get; set; }
    public double UploadSpeedMbps { get; set; }
    public string? IspName { get; set; }
    public bool KillSwitchActive { get; set; }
    public List<string> Warnings { get; set; } = new();
    public List<string> Errors { get; set; } = new();
}

/// <summary>
/// Event log entry for VPN operations
/// </summary>
public class VpnLogEntry
{
    public DateTime Timestamp { get; set; }
    public string Level { get; set; } = "Info"; // Info, Warning, Error, Debug
    public string Source { get; set; } = "VPN_CLI";
    public string Message { get; set; } = string.Empty;
    public string? Operation { get; set; }
    public Dictionary<string, object> Data { get; set; } = new();
    public Exception? Exception { get; set; }
}

/// <summary>
/// VPN automation policy configuration
/// </summary>
public class VpnAutomationPolicy
{
    public bool AutoConnect { get; set; } = true;
    public bool AutoChangeOnDisconnect { get; set; } = true;
    public bool EnforceCompliance { get; set; } = true;
    public int ComplianceCheckIntervalSeconds { get; set; } = 30;
    public int MaxRetryAttempts { get; set; } = 3;
    public int RetryDelayMs { get; set; } = 5000;
    public bool LogOperations { get; set; } = true;
    public string? PreferredCountry { get; set; }
    public ServerSelectionStrategy ServerSelection { get; set; } = ServerSelectionStrategy.LowestLoad;
    public bool AvoidHighLoadServers { get; set; } = true;
    public int MaxAcceptableLoadPercent { get; set; } = 80;
    public bool RequireStreamingSupport { get; set; } = false;
    public bool RequireTorrentingSupport { get; set; } = false;
}

/// <summary>
/// Server selection strategy
/// </summary>
public enum ServerSelectionStrategy
{
    LowestLoad,
    FastestPing,
    HighestScore,
    Random,
    Geographic,
    RoundRobin
}

/// <summary>
/// VPN protocol type
/// </summary>
public enum VpnProtocol
{
    Auto,
    WireGuard,
    OpenVPN_UDP,
    OpenVPN_TCP,
    IKEv2
}
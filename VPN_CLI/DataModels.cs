namespace VPN_CLI;

/// <summary>
/// Detailed information about CyberGhost processes
/// </summary>
public class CyberGhostProcessInfo
{
    public bool IsRunning { get; set; }
    public int CyberGhostProcessCount { get; set; }
    public int DashboardProcessCount { get; set; }
    public int TotalProcessCount { get; set; }
    public List<ProcessDetails> Processes { get; set; } = new();
}

/// <summary>
/// Individual process details
/// </summary>
public class ProcessDetails
{
    public string Name { get; set; } = string.Empty;
    public int ProcessId { get; set; }
    public DateTime StartTime { get; set; }
    public double MemoryUsageMB { get; set; }
    public string WindowTitle { get; set; } = string.Empty;
    public bool HasMainWindow { get; set; }
    public string? Error { get; set; }
}

/// <summary>
/// Result of location change operation
/// </summary>
public class LocationChangeResult
{
    public bool Success { get; set; }
    public int AttemptsUsed { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? Error { get; set; }
    public P4NTH30N.C0MMON.NetworkAddress? OriginalLocation { get; set; }
    public P4NTH30N.C0MMON.NetworkAddress? NewLocation { get; set; }
}

/// <summary>
/// Comprehensive connection health report
/// </summary>
public class ConnectionHealthReport
{
    public bool Success { get; set; }
    public DateTime Timestamp { get; set; }
    public bool ProcessesRunning { get; set; }
    public int ProcessCount { get; set; }
    public string CurrentIP { get; set; } = string.Empty;
    public string HomeIP { get; set; } = string.Empty;
    public bool VpnActive { get; set; }
    public string CurrentLocation { get; set; } = string.Empty;
    public bool IsCompliant { get; set; }
    public double ResponseTimeMs { get; set; }
    public int HealthScore { get; set; } // 0-100
    public string OverallStatus { get; set; } = string.Empty; // Excellent, Good, Fair, Poor, Critical
    public string? Error { get; set; }
}

/// <summary>
/// Result of connection repair operation
/// </summary>
public class RepairResult
{
    public bool Success { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime? EndTime { get; set; }
    public double DurationSeconds { get; set; }
    public List<string> Steps { get; set; } = new();
    public string? Error { get; set; }
}

/// <summary>
/// Configuration for CLI operations
/// </summary>
public class VpnCliConfig
{
    public int DefaultWatchInterval { get; set; } = 5;
    public int DefaultRetryLimit { get; set; } = 3;
    public int DefaultComplianceCheckInterval { get; set; } = 30;
    public bool EnableAutomaticRepair { get; set; } = true;
    public bool EnableVerboseLogging { get; set; } = false;
    public string[] ForbiddenRegions { get; set; } = { "Nevada", "California" };
    
    // UI automation coordinates (can be customized per system)
    public UiCoordinates Coordinates { get; set; } = new();
}

/// <summary>
/// UI coordinates for CyberGhost automation
/// </summary>
public class UiCoordinates
{
    public Point LocationChangeButton { get; set; } = new(1120, 280);
    public Point ConnectButton { get; set; } = new(1000, 400);
    public Point TaskbarIcon { get; set; } = new(749, 697);
    public Point SettingsButton { get; set; } = new(1200, 100);
}

/// <summary>
/// Simple point structure for UI coordinates
/// </summary>
public struct Point
{
    public int X { get; set; }
    public int Y { get; set; }
    
    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
    
    public override string ToString() => $"({X}, {Y})";
}

/// <summary>
/// Performance metrics for VPN operations
/// </summary>
public class VpnPerformanceMetrics
{
    public DateTime Timestamp { get; set; }
    public double ConnectionTimeSeconds { get; set; }
    public double LocationChangeTimeSeconds { get; set; }
    public double IpCheckResponseTimeMs { get; set; }
    public int SuccessfulOperations { get; set; }
    public int FailedOperations { get; set; }
    public double SuccessRate => SuccessfulOperations + FailedOperations > 0 
        ? (double)SuccessfulOperations / (SuccessfulOperations + FailedOperations) * 100 
        : 0;
}
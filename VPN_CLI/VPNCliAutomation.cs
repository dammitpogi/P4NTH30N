using System.Diagnostics;
using System.Runtime.InteropServices;
using P4NTH30N.C0MMON;
using P4NTH30N.Services;

namespace VPN_CLI;

/// <summary>
/// Enhanced VPN automation capabilities specifically for CLI operations
/// This extends the base VPNService with additional automation and monitoring features
/// </summary>
public static class VPNCliAutomation
{
    private static readonly HttpClient _httpClient = new();
    
    // Import Windows API for window manipulation
    [DllImport("user32.dll")]
    private static extern bool SetForegroundWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    private static extern IntPtr FindWindow(string? lpClassName, string lpWindowName);
    
    [DllImport("user32.dll")]
    private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    private const int SW_RESTORE = 9;

    /// <summary>
    /// Advanced CyberGhost process detection with detailed information
    /// </summary>
    public static async Task<CyberGhostProcessInfo> GetDetailedProcessInfo()
    {
        var cyberghostProcesses = Process.GetProcessesByName("CyberGhost");
        var dashboardProcesses = Process.GetProcessesByName("Dashboard");
        var allProcesses = cyberghostProcesses.Concat(dashboardProcesses).ToArray();
        
        var info = new CyberGhostProcessInfo
        {
            IsRunning = allProcesses.Length > 0,
            CyberGhostProcessCount = cyberghostProcesses.Length,
            DashboardProcessCount = dashboardProcesses.Length,
            TotalProcessCount = allProcesses.Length,
            Processes = new List<ProcessDetails>()
        };
        
        foreach (var process in allProcesses)
        {
            try
            {
                var details = new ProcessDetails
                {
                    Name = process.ProcessName,
                    ProcessId = process.Id,
                    StartTime = process.StartTime,
                    MemoryUsageMB = Math.Round(process.WorkingSet64 / 1024.0 / 1024.0, 2),
                    WindowTitle = process.MainWindowTitle,
                    HasMainWindow = process.MainWindowHandle != IntPtr.Zero
                };
                
                info.Processes.Add(details);
            }
            catch (Exception ex)
            {
                // Process might have exited or access denied
                var details = new ProcessDetails
                {
                    Name = process.ProcessName,
                    ProcessId = process.Id,
                    Error = ex.Message
                };
                
                info.Processes.Add(details);
            }
        }
        
        return info;
    }

    /// <summary>
    /// Attempts to bring CyberGhost window to foreground for automation
    /// </summary>
    public static bool BringCyberGhostToForeground()
    {
        try
        {
            // Try to find CyberGhost window
            var windowHandle = FindWindow(null, "CyberGhost");
            if (windowHandle == IntPtr.Zero)
            {
                // Try alternative window titles
                string[] alternativeTitles = {
                    "CyberGhost VPN",
                    "CyberGhost 8",
                    "Dashboard"
                };
                
                foreach (var title in alternativeTitles)
                {
                    windowHandle = FindWindow(null, title);
                    if (windowHandle != IntPtr.Zero)
                        break;
                }
            }
            
            if (windowHandle != IntPtr.Zero)
            {
                ShowWindow(windowHandle, SW_RESTORE);
                SetForegroundWindow(windowHandle);
                return true;
            }
            
            return false;
        }
        catch
        {
            return false;
        }
    }

    /// <summary>
    /// Enhanced location change with multiple retry strategies
    /// </summary>
    public static async Task<LocationChangeResult> ChangeLocationSmart(int maxAttempts = 5)
    {
        var result = new LocationChangeResult
        {
            Success = false,
            AttemptsUsed = 0,
            OriginalLocation = await VPNService.GetCurrentLocation()
        };
        
        for (int attempt = 1; attempt <= maxAttempts; attempt++)
        {
            result.AttemptsUsed = attempt;
            
            try
            {
                // Bring window to foreground first
                BringCyberGhostToForeground();
                await Task.Delay(1000);
                
                // Try the location change button click
                Mouse.Click(1120, 280);
                await Task.Delay(3000); // Wait for UI response
                
                // Verify the location actually changed
                var newLocation = await VPNService.GetCurrentLocation();
                
                if (newLocation?.ip != result.OriginalLocation?.ip)
                {
                    result.Success = true;
                    result.NewLocation = newLocation;
                    result.Message = $"Location changed successfully after {attempt} attempt(s)";
                    break;
                }
                
                if (attempt < maxAttempts)
                {
                    // Try alternative coordinates or methods
                    if (attempt == 2)
                    {
                        // Try different click coordinates
                        Mouse.Click(1200, 300);
                    }
                    else if (attempt == 3)
                    {
                        // Try alternative UI location
                        Mouse.Click(1000, 320);
                    }
                    
                    await Task.Delay(2000);
                }
            }
            catch (Exception ex)
            {
                result.Error = ex.Message;
                if (attempt == maxAttempts)
                {
                    result.Message = $"All {maxAttempts} attempts failed. Last error: {ex.Message}";
                }
            }
        }
        
        if (!result.Success)
        {
            result.Message = result.Error ?? $"Failed to change location after {maxAttempts} attempts";
        }
        
        return result;
    }

    /// <summary>
    /// Comprehensive connection health check
    /// </summary>
    public static async Task<ConnectionHealthReport> CheckConnectionHealth()
    {
        var report = new ConnectionHealthReport
        {
            Timestamp = DateTime.UtcNow
        };
        
        try
        {
            // Check process status
            var processInfo = await GetDetailedProcessInfo();
            report.ProcessesRunning = processInfo.IsRunning;
            report.ProcessCount = processInfo.TotalProcessCount;
            
            // Check IP and location
            var location = await VPNService.GetCurrentLocation();
            var homeIP = await NetworkAddress.MyIP(_httpClient);
            
            report.CurrentIP = location?.ip ?? "Unknown";
            report.HomeIP = homeIP;
            report.VpnActive = location?.ip != homeIP && !string.IsNullOrEmpty(location?.ip);
            
            if (location?.location != null)
            {
                report.CurrentLocation = $"{location.location.city}, {location.location.state_prov}, {location.location.country_name}";
                report.IsCompliant = VPNService.IsLocationCompliant(location);
            }
            
            // Performance metrics
            var startTime = DateTime.UtcNow;
            await NetworkAddress.MyIP(_httpClient); // Test connectivity
            report.ResponseTimeMs = (DateTime.UtcNow - startTime).TotalMilliseconds;
            
            // Overall health score
            int healthScore = 0;
            if (report.ProcessesRunning) healthScore += 25;
            if (report.VpnActive) healthScore += 25;
            if (report.IsCompliant) healthScore += 25;
            if (report.ResponseTimeMs < 5000) healthScore += 25; // Good response time
            
            report.HealthScore = healthScore;
            report.OverallStatus = healthScore switch
            {
                100 => "Excellent",
                >= 75 => "Good",
                >= 50 => "Fair",
                >= 25 => "Poor",
                _ => "Critical"
            };
            
            report.Success = true;
        }
        catch (Exception ex)
        {
            report.Success = false;
            report.Error = ex.Message;
            report.OverallStatus = "Error";
        }
        
        return report;
    }

    /// <summary>
    /// Intelligent connection repair with multiple strategies
    /// </summary>
    public static async Task<RepairResult> RepairConnection()
    {
        var result = new RepairResult
        {
            StartTime = DateTime.UtcNow,
            Steps = new List<string>()
        };
        
        try
        {
            result.Steps.Add("Starting connection repair process");
            
            // Step 1: Check if any processes are running
            var processInfo = await GetDetailedProcessInfo();
            if (!processInfo.IsRunning)
            {
                result.Steps.Add("No CyberGhost processes detected - launching VPN");
                VPNService.LaunchVPN();
                await Task.Delay(10000); // Wait for startup
            }
            else
            {
                result.Steps.Add($"Found {processInfo.TotalProcessCount} CyberGhost processes running");
            }
            
            // Step 2: Try to establish connection
            result.Steps.Add("Attempting to establish compliant connection");
            var connectionSuccess = await VPNService.EnsureCompliantConnection();
            
            if (connectionSuccess)
            {
                result.Steps.Add("✅ Connection established successfully");
                result.Success = true;
            }
            else
            {
                result.Steps.Add("❌ Standard connection method failed - trying repair strategies");
                
                // Step 3: Try reset and reconnect
                result.Steps.Add("Strategy 1: Resetting connection");
                await VPNService.ResetConnection();
                await Task.Delay(5000);
                
                connectionSuccess = await VPNService.EnsureCompliantConnection();
                if (connectionSuccess)
                {
                    result.Steps.Add("✅ Connection repaired after reset");
                    result.Success = true;
                }
                else
                {
                    // Step 4: Try process restart
                    result.Steps.Add("Strategy 2: Restarting CyberGhost processes");
                    var processes = Process.GetProcessesByName("CyberGhost")
                        .Concat(Process.GetProcessesByName("Dashboard"));
                    
                    foreach (var process in processes)
                    {
                        try
                        {
                            process.Kill();
                            result.Steps.Add($"Terminated process: {process.ProcessName}");
                        }
                        catch { }
                    }
                    
                    await Task.Delay(3000);
                    VPNService.LaunchVPN();
                    await Task.Delay(15000); // Longer wait after full restart
                    
                    connectionSuccess = await VPNService.EnsureCompliantConnection();
                    if (connectionSuccess)
                    {
                        result.Steps.Add("✅ Connection repaired after process restart");
                        result.Success = true;
                    }
                    else
                    {
                        result.Steps.Add("❌ All repair strategies failed");
                        result.Success = false;
                    }
                }
            }
            
            result.EndTime = DateTime.UtcNow;
            result.DurationSeconds = (result.EndTime.Value - result.StartTime).TotalSeconds;
            
            if (result.Success)
            {
                var finalLocation = await VPNService.GetCurrentLocation();
                if (finalLocation?.location != null)
                {
                    result.Steps.Add($"Final location: {finalLocation.location.city}, {finalLocation.location.state_prov}");
                    result.Steps.Add($"Final IP: {finalLocation.ip}");
                    result.Steps.Add($"Compliance: {(VPNService.IsLocationCompliant(finalLocation) ? "Compliant" : "Non-Compliant")}");
                }
            }
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Error = ex.Message;
            result.Steps.Add($"❌ Repair failed with exception: {ex.Message}");
            result.EndTime = DateTime.UtcNow;
            result.DurationSeconds = (result.EndTime.Value - result.StartTime).TotalSeconds;
        }
        
        return result;
    }
}
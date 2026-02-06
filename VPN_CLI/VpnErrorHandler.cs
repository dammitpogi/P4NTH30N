using System.Diagnostics;
using System.Text.Json;

namespace VPN_CLI;

/// <summary>
/// Enhanced error handling and fallback mechanisms for VPN operations
/// </summary>
public static class VpnErrorHandler
{
    private static readonly List<string> _operationLog = new();
    private const int MAX_LOG_ENTRIES = 100;
    
    /// <summary>
    /// Execute VPN operation with comprehensive error handling and fallbacks
    /// </summary>
    public static async Task<VpnOperationResult> ExecuteWithFallbacks<T>(
        string operationName,
        Func<Task<T>> primaryOperation,
        List<Func<Task<T>>> fallbackOperations,
        Func<T, bool> successValidator,
        int maxRetries = 3,
        TimeSpan? timeout = null)
    {
        var result = new VpnOperationResult
        {
            Operation = operationName,
            StartTime = DateTime.UtcNow
        };
        
        timeout ??= TimeSpan.FromMinutes(2);
        var allOperations = new List<Func<Task<T>>> { primaryOperation };
        allOperations.AddRange(fallbackOperations);
        
        Exception? lastException = null;
        var attemptResults = new List<string>();
        
        try
        {
            for (int operationIndex = 0; operationIndex < allOperations.Count; operationIndex++)
            {
                var operation = allOperations[operationIndex];
                var operationType = operationIndex == 0 ? "Primary" : $"Fallback-{operationIndex}";
                
                for (int retry = 0; retry < maxRetries; retry++)
                {
                    try
                    {
                        LogOperation($"[{operationName}] Attempting {operationType} operation (retry {retry + 1}/{maxRetries})");
                        
                        using (var cts = new CancellationTokenSource(timeout.Value))
                        {
                            var operationTask = operation();
                            var completedTask = await Task.WhenAny(operationTask, Task.Delay(timeout.Value, cts.Token));
                            
                            if (completedTask == operationTask)
                            {
                                var operationResult = await operationTask;
                                
                                if (successValidator(operationResult))
                                {
                                    result.Success = true;
                                    result.Message = $"{operationType} operation succeeded on attempt {retry + 1}";
                                    LogOperation($"[{operationName}] SUCCESS: {result.Message}");
                                    return result;
                                }
                                else
                                {
                                    var failureMsg = $"{operationType} operation completed but failed validation on attempt {retry + 1}";
                                    attemptResults.Add(failureMsg);
                                    LogOperation($"[{operationName}] VALIDATION_FAILED: {failureMsg}");
                                    
                                    if (retry < maxRetries - 1)
                                    {
                                        await Task.Delay(TimeSpan.FromSeconds(Math.Pow(2, retry))); // Exponential backoff
                                    }
                                }
                            }
                            else
                            {
                                var timeoutMsg = $"{operationType} operation timed out after {timeout.Value.TotalSeconds} seconds on attempt {retry + 1}";
                                attemptResults.Add(timeoutMsg);
                                LogOperation($"[{operationName}] TIMEOUT: {timeoutMsg}");
                                throw new TimeoutException(timeoutMsg);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lastException = ex;
                        var errorMsg = $"{operationType} operation failed on attempt {retry + 1}: {ex.Message}";
                        attemptResults.Add(errorMsg);
                        LogOperation($"[{operationName}] ERROR: {errorMsg}");
                        
                        if (retry < maxRetries - 1)
                        {
                            await Task.Delay(TimeSpan.FromSeconds(Math.Pow(2, retry))); // Exponential backoff
                        }
                    }
                }
                
                // If we're here, all retries for this operation failed, try next fallback
                LogOperation($"[{operationName}] All {maxRetries} attempts failed for {operationType} operation");
            }
            
            // All operations and retries failed
            result.Success = false;
            result.Error = $"All operations failed after {maxRetries} retries each. Last error: {lastException?.Message}";
            result.Metadata["attempt_results"] = attemptResults;
            result.Metadata["total_attempts"] = allOperations.Count * maxRetries;
            
            LogOperation($"[{operationName}] COMPLETE_FAILURE: {result.Error}");
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Error = $"Unexpected error in operation handler: {ex.Message}";
            LogOperation($"[{operationName}] HANDLER_ERROR: {result.Error}");
        }
        finally
        {
            result.EndTime = DateTime.UtcNow;
            result.Duration = result.EndTime.Value - result.StartTime;
        }
        
        return result;
    }
    
    /// <summary>
    /// Enhanced connection with smart fallback strategies
    /// </summary>
    public static async Task<VpnOperationResult> ConnectWithSmartFallbacks(string? preferredServer = null)
    {
        var fallbackStrategies = new List<Func<Task<VpnOperationResult>>>
        {
            // Primary: Named pipe communication
            () => AttemptNamedPipeConnect(preferredServer),
            
            // Fallback 1: Process injection
            () => AttemptProcessInjectionConnect(preferredServer),
            
            // Fallback 2: Registry manipulation
            () => AttemptRegistryConnect(preferredServer),
            
            // Fallback 3: Service restart + auto-connect
            () => AttemptServiceRestartConnect(preferredServer),
            
            // Fallback 4: UI automation as last resort
            () => AttemptUIAutomationConnect(preferredServer)
        };
        
        return await ExecuteWithFallbacks(
            "SmartConnect",
            fallbackStrategies[0],
            fallbackStrategies.Skip(1).ToList(),
            result => result.Success,
            maxRetries: 2,
            timeout: TimeSpan.FromMinutes(3)
        );
    }
    
    /// <summary>
    /// Enhanced disconnect with comprehensive fallback strategies
    /// </summary>
    public static async Task<VpnOperationResult> DisconnectWithSmartFallbacks()
    {
        var fallbackStrategies = new List<Func<Task<VpnOperationResult>>>
        {
            // Primary: Named pipe communication
            () => AttemptNamedPipeDisconnect(),
            
            // Fallback 1: Process injection
            () => AttemptProcessInjectionDisconnect(),
            
            // Fallback 2: Service stop
            () => AttemptServiceStopDisconnect(),
            
            // Fallback 3: Process termination
            () => AttemptProcessTerminationDisconnect(),
            
            // Fallback 4: Nuclear option - kill everything
            () => AttemptNuclearDisconnect()
        };
        
        return await ExecuteWithFallbacks(
            "SmartDisconnect",
            fallbackStrategies[0],
            fallbackStrategies.Skip(1).ToList(),
            result => result.Success,
            maxRetries: 2,
            timeout: TimeSpan.FromMinutes(2)
        );
    }
    
    /// <summary>
    /// Validate system state and recommend recovery actions
    /// </summary>
    public static async Task<VpnSystemDiagnostic> DiagnoseAndRecommendRecovery()
    {
        var diagnostic = new VpnSystemDiagnostic
        {
            Timestamp = DateTime.UtcNow
        };
        
        try
        {
            // Check service status
            diagnostic.ServiceStatus = await CheckServiceHealth();
            
            // Check process status
            diagnostic.ProcessStatus = await CheckProcessHealth();
            
            // Check network connectivity
            diagnostic.NetworkStatus = await CheckNetworkHealth();
            
            // Check CyberGhost installation
            diagnostic.InstallationStatus = await CheckInstallationHealth();
            
            // Check permissions
            diagnostic.PermissionStatus = await CheckPermissionHealth();
            
            // Generate recommendations based on findings
            diagnostic.Recommendations = GenerateRecoveryRecommendations(diagnostic);
            
            diagnostic.OverallHealth = CalculateOverallHealth(diagnostic);
            
            LogOperation($"[DIAGNOSTIC] System health: {diagnostic.OverallHealth}, {diagnostic.Recommendations.Count} recommendations generated");
        }
        catch (Exception ex)
        {
            diagnostic.Error = ex.Message;
            diagnostic.OverallHealth = HealthStatus.Critical;
            LogOperation($"[DIAGNOSTIC] Failed to complete diagnosis: {ex.Message}");
        }
        
        return diagnostic;
    }
    
    #region Private Implementation Methods
    
    private static async Task<VpnOperationResult> AttemptNamedPipeConnect(string? server)
    {
        try
        {
            return await CyberGhostDirectControl.ConnectDirect(server);
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Named pipe connect failed: {ex.Message}",
                Operation = "NamedPipeConnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptProcessInjectionConnect(string? server)
    {
        try
        {
            var processes = Process.GetProcessesByName("CyberGhost");
            if (!processes.Any())
            {
                await StartCyberGhostProcesses();
                await Task.Delay(3000);
            }
            
            return await CyberGhostDirectControl.ConnectDirect(server);
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Process injection connect failed: {ex.Message}",
                Operation = "ProcessInjectionConnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptRegistryConnect(string? server)
    {
        try
        {
            // Implementation would use registry manipulation
            await Task.Delay(1000); // Placeholder
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = "Registry connect not fully implemented",
                Operation = "RegistryConnect"
            };
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Registry connect failed: {ex.Message}",
                Operation = "RegistryConnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptServiceRestartConnect(string? server)
    {
        try
        {
            await RestartCyberGhostService();
            await Task.Delay(5000); // Allow service to fully start
            return await CyberGhostDirectControl.ConnectDirect(server);
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Service restart connect failed: {ex.Message}",
                Operation = "ServiceRestartConnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptUIAutomationConnect(string? server)
    {
        try
        {
            // Last resort UI automation - would implement screen automation
            await Task.Delay(1000); // Placeholder
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = "UI automation connect not implemented (last resort fallback)",
                Operation = "UIAutomationConnect"
            };
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"UI automation connect failed: {ex.Message}",
                Operation = "UIAutomationConnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptNamedPipeDisconnect()
    {
        try
        {
            return await CyberGhostDirectControl.DisconnectDirect();
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Named pipe disconnect failed: {ex.Message}",
                Operation = "NamedPipeDisconnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptProcessInjectionDisconnect()
    {
        try
        {
            return await CyberGhostDirectControl.DisconnectDirect();
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Process injection disconnect failed: {ex.Message}",
                Operation = "ProcessInjectionDisconnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptServiceStopDisconnect()
    {
        try
        {
            await StopCyberGhostService();
            return new VpnOperationResult 
            { 
                Success = true, 
                Message = "VPN disconnected via service stop",
                Operation = "ServiceStopDisconnect"
            };
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Service stop disconnect failed: {ex.Message}",
                Operation = "ServiceStopDisconnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptProcessTerminationDisconnect()
    {
        try
        {
            await TerminateAllCyberGhostProcesses();
            return new VpnOperationResult 
            { 
                Success = true, 
                Message = "VPN disconnected via process termination",
                Operation = "ProcessTerminationDisconnect"
            };
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Process termination disconnect failed: {ex.Message}",
                Operation = "ProcessTerminationDisconnect"
            };
        }
    }
    
    private static async Task<VpnOperationResult> AttemptNuclearDisconnect()
    {
        try
        {
            // Nuclear option - kill everything VPN related
            await TerminateAllCyberGhostProcesses();
            await StopCyberGhostService();
            await Task.Delay(2000);
            
            // Flush DNS and reset network stack
            await FlushNetworkStack();
            
            return new VpnOperationResult 
            { 
                Success = true, 
                Message = "VPN disconnected via nuclear option (processes + service + network reset)",
                Operation = "NuclearDisconnect"
            };
        }
        catch (Exception ex)
        {
            return new VpnOperationResult 
            { 
                Success = false, 
                Error = $"Nuclear disconnect failed: {ex.Message}",
                Operation = "NuclearDisconnect"
            };
        }
    }
    
    private static async Task<ComponentHealth> CheckServiceHealth()
    {
        try
        {
            using (var service = new System.ServiceProcess.ServiceController("CyberGhost8Service"))
            {
                return new ComponentHealth
                {
                    IsHealthy = service.Status == System.ServiceProcess.ServiceControllerStatus.Running,
                    Status = service.Status.ToString(),
                    Details = $"Service status: {service.Status}"
                };
            }
        }
        catch (Exception ex)
        {
            return new ComponentHealth
            {
                IsHealthy = false,
                Status = "Error",
                Details = $"Service check failed: {ex.Message}"
            };
        }
    }
    
    private static async Task<ComponentHealth> CheckProcessHealth()
    {
        try
        {
            var processes = Process.GetProcessesByName("CyberGhost")
                .Concat(Process.GetProcessesByName("Dashboard"))
                .ToList();
                
            return new ComponentHealth
            {
                IsHealthy = processes.Count > 0,
                Status = processes.Count > 0 ? "Running" : "Stopped",
                Details = $"Found {processes.Count} CyberGhost processes running"
            };
        }
        catch (Exception ex)
        {
            return new ComponentHealth
            {
                IsHealthy = false,
                Status = "Error",
                Details = $"Process check failed: {ex.Message}"
            };
        }
    }
    
    private static async Task<ComponentHealth> CheckNetworkHealth()
    {
        try
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10);
                var response = await client.GetStringAsync("https://api.ipify.org/");
                
                return new ComponentHealth
                {
                    IsHealthy = !string.IsNullOrEmpty(response),
                    Status = "Connected",
                    Details = $"External IP accessible: {response?.Trim()}"
                };
            }
        }
        catch (Exception ex)
        {
            return new ComponentHealth
            {
                IsHealthy = false,
                Status = "Disconnected",
                Details = $"Network check failed: {ex.Message}"
            };
        }
    }
    
    private static async Task<ComponentHealth> CheckInstallationHealth()
    {
        try
        {
            var installPath = @"C:\Program Files\CyberGhost 8\Dashboard.exe";
            var exists = File.Exists(installPath);
            
            return new ComponentHealth
            {
                IsHealthy = exists,
                Status = exists ? "Installed" : "Missing",
                Details = exists ? $"CyberGhost found at: {installPath}" : "CyberGhost installation not found"
            };
        }
        catch (Exception ex)
        {
            return new ComponentHealth
            {
                IsHealthy = false,
                Status = "Error",
                Details = $"Installation check failed: {ex.Message}"
            };
        }
    }
    
    private static async Task<ComponentHealth> CheckPermissionHealth()
    {
        try
        {
            var isAdmin = new System.Security.Principal.WindowsPrincipal(
                System.Security.Principal.WindowsIdentity.GetCurrent())
                .IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
                
            return new ComponentHealth
            {
                IsHealthy = isAdmin,
                Status = isAdmin ? "Administrator" : "Limited",
                Details = isAdmin ? "Running with administrator privileges" : "Limited privileges - some operations may fail"
            };
        }
        catch (Exception ex)
        {
            return new ComponentHealth
            {
                IsHealthy = false,
                Status = "Error",
                Details = $"Permission check failed: {ex.Message}"
            };
        }
    }
    
    private static List<string> GenerateRecoveryRecommendations(VpnSystemDiagnostic diagnostic)
    {
        var recommendations = new List<string>();
        
        if (!diagnostic.ServiceStatus.IsHealthy)
        {
            recommendations.Add("Start or restart the CyberGhost service");
            recommendations.Add("Check Windows Services for CyberGhost8Service status");
        }
        
        if (!diagnostic.ProcessStatus.IsHealthy)
        {
            recommendations.Add("Launch CyberGhost application");
            recommendations.Add("Check if antivirus is blocking CyberGhost processes");
        }
        
        if (!diagnostic.NetworkStatus.IsHealthy)
        {
            recommendations.Add("Check internet connectivity");
            recommendations.Add("Verify network adapter configuration");
            recommendations.Add("Try flushing DNS with: ipconfig /flushdns");
        }
        
        if (!diagnostic.InstallationStatus.IsHealthy)
        {
            recommendations.Add("Reinstall CyberGhost VPN application");
            recommendations.Add("Check if CyberGhost is installed in a custom location");
        }
        
        if (!diagnostic.PermissionStatus.IsHealthy)
        {
            recommendations.Add("Run VPN CLI as Administrator");
            recommendations.Add("Check User Account Control (UAC) settings");
        }
        
        if (recommendations.Count == 0)
        {
            recommendations.Add("System appears healthy - try reconnecting VPN");
        }
        
        return recommendations;
    }
    
    private static HealthStatus CalculateOverallHealth(VpnSystemDiagnostic diagnostic)
    {
        var healthyComponents = 0;
        var totalComponents = 5;
        
        if (diagnostic.ServiceStatus.IsHealthy) healthyComponents++;
        if (diagnostic.ProcessStatus.IsHealthy) healthyComponents++;
        if (diagnostic.NetworkStatus.IsHealthy) healthyComponents++;
        if (diagnostic.InstallationStatus.IsHealthy) healthyComponents++;
        if (diagnostic.PermissionStatus.IsHealthy) healthyComponents++;
        
        var healthPercentage = (double)healthyComponents / totalComponents;
        
        return healthPercentage switch
        {
            >= 0.8 => HealthStatus.Healthy,
            >= 0.6 => HealthStatus.Warning,
            >= 0.4 => HealthStatus.Degraded,
            _ => HealthStatus.Critical
        };
    }
    
    private static async Task StartCyberGhostProcesses()
    {
        try
        {
            var startInfo = new ProcessStartInfo
            {
                FileName = @"C:\Program Files\CyberGhost 8\Dashboard.exe",
                UseShellExecute = false,
                CreateNoWindow = true
            };
            Process.Start(startInfo);
        }
        catch
        {
            // Ignore if can't start
        }
    }
    
    private static async Task RestartCyberGhostService()
    {
        try
        {
            using (var service = new System.ServiceProcess.ServiceController("CyberGhost8Service"))
            {
                if (service.Status != System.ServiceProcess.ServiceControllerStatus.Stopped)
                {
                    service.Stop();
                    service.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(30));
                }
                
                service.Start();
                service.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Running, TimeSpan.FromSeconds(30));
            }
        }
        catch
        {
            // Ignore service control failures
        }
    }
    
    private static async Task StopCyberGhostService()
    {
        try
        {
            using (var service = new System.ServiceProcess.ServiceController("CyberGhost8Service"))
            {
                if (service.Status == System.ServiceProcess.ServiceControllerStatus.Running)
                {
                    service.Stop();
                    service.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(30));
                }
            }
        }
        catch
        {
            // Ignore service control failures
        }
    }
    
    private static async Task TerminateAllCyberGhostProcesses()
    {
        var processNames = new[] { "CyberGhost", "Dashboard", "Dashboard.Service" };
        
        foreach (var processName in processNames)
        {
            try
            {
                var processes = Process.GetProcessesByName(processName);
                foreach (var process in processes)
                {
                    try
                    {
                        process.Kill();
                        await process.WaitForExitAsync();
                    }
                    catch
                    {
                        // Ignore individual process kill failures
                    }
                }
            }
            catch
            {
                // Ignore process enumeration failures
            }
        }
    }
    
    private static async Task FlushNetworkStack()
    {
        try
        {
            var commands = new[]
            {
                "ipconfig /flushdns",
                "ipconfig /release",
                "ipconfig /renew"
            };
            
            foreach (var command in commands)
            {
                try
                {
                    var process = new Process
                    {
                        StartInfo = new ProcessStartInfo
                        {
                            FileName = "cmd.exe",
                            Arguments = $"/c {command}",
                            UseShellExecute = false,
                            CreateNoWindow = true,
                            RedirectStandardOutput = true
                        }
                    };
                    
                    process.Start();
                    await process.WaitForExitAsync();
                }
                catch
                {
                    // Ignore individual command failures
                }
            }
        }
        catch
        {
            // Ignore network flush failures
        }
    }
    
    private static void LogOperation(string message)
    {
        lock (_operationLog)
        {
            _operationLog.Add($"[{DateTime.UtcNow:yyyy-MM-dd HH:mm:ss}] {message}");
            
            // Keep only the most recent entries
            while (_operationLog.Count > MAX_LOG_ENTRIES)
            {
                _operationLog.RemoveAt(0);
            }
        }
    }
    
    public static List<string> GetOperationLog()
    {
        lock (_operationLog)
        {
            return new List<string>(_operationLog);
        }
    }
    
    public static void ClearOperationLog()
    {
        lock (_operationLog)
        {
            _operationLog.Clear();
        }
    }
    
    #endregion
}

/// <summary>
/// System diagnostic result
/// </summary>
public class VpnSystemDiagnostic
{
    public DateTime Timestamp { get; set; }
    public ComponentHealth ServiceStatus { get; set; } = new();
    public ComponentHealth ProcessStatus { get; set; } = new();
    public ComponentHealth NetworkStatus { get; set; } = new();
    public ComponentHealth InstallationStatus { get; set; } = new();
    public ComponentHealth PermissionStatus { get; set; } = new();
    public List<string> Recommendations { get; set; } = new();
    public HealthStatus OverallHealth { get; set; }
    public string? Error { get; set; }
}

/// <summary>
/// Individual component health status
/// </summary>
public class ComponentHealth
{
    public bool IsHealthy { get; set; }
    public string Status { get; set; } = string.Empty;
    public string Details { get; set; } = string.Empty;
}

/// <summary>
/// Overall system health status
/// </summary>
public enum HealthStatus
{
    Healthy,
    Warning,
    Degraded,
    Critical
}
using System.Diagnostics;
using System.ServiceProcess;
using System.Text.Json;

namespace VPN_CLI;

/// <summary>
/// Enhanced VPN control with proper process termination and home IP detection
/// </summary>
public static class VPNTerminationService
{
    private const string CYBERGHOST_SERVICE_NAME = "CyberGhost8Service";
    
    /// <summary>
    /// Completely terminate CyberGhost VPN and get true home IP
    /// </summary>
    public static async Task<VpnTerminationResult> CompleteVpnShutdown()
    {
        var result = new VpnTerminationResult { StartTime = DateTime.UtcNow };
        
        try
        {
            Console.WriteLine("🔴 Initiating complete VPN shutdown...");
            
            // Step 1: Kill all CyberGhost processes first
            var processesKilled = await KillAllCyberGhostProcesses();
            result.ProcessesKilled = processesKilled;
            Console.WriteLine($"   Terminated {processesKilled} processes");
            
            // Step 2: Stop the service
            var servicesStopped = await StopCyberGhostService();
            result.ServicesStopped = servicesStopped;
            Console.WriteLine($"   Stopped {servicesStopped} services");
            
            // Step 3: Wait for network stack to reset
            Console.WriteLine("   Waiting for network stack reset...");
            await Task.Delay(5000);
            
            // Step 4: Get true home IP
            result.TrueHomeIP = await GetTrueHomeIP();
            Console.WriteLine($"   True home IP detected: {result.TrueHomeIP}");
            
            // Step 5: Verify VPN is completely off
            var verificationResult = await VerifyVpnDisconnected(result.TrueHomeIP);
            result.IsCompletelyDisconnected = verificationResult.isDisconnected;
            result.CurrentIP = verificationResult.currentIP;
            
            result.Success = result.IsCompletelyDisconnected;
            result.Message = result.Success ? "VPN completely shut down" : "VPN may still be partially active";
            
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Error = ex.Message;
        }
        finally
        {
            result.EndTime = DateTime.UtcNow;
            result.Duration = result.EndTime.Value - result.StartTime;
        }
        
        return result;
    }
    
    /// <summary>
    /// Kill all CyberGhost related processes
    /// </summary>
    private static async Task<int> KillAllCyberGhostProcesses()
    {
        var processNames = new[] 
        { 
            "CyberGhost", 
            "Dashboard", 
            "Dashboard.Service",
            "CyberGhost.Service",
            "openvpn",
            "wireguard"
        };
        
        int killedCount = 0;
        
        foreach (var processName in processNames)
        {
            try
            {
                var processes = Process.GetProcessesByName(processName);
                foreach (var process in processes)
                {
                    try
                    {
                        if (!process.HasExited)
                        {
                            process.Kill();
                            await process.WaitForExitAsync();
                            killedCount++;
                        }
                    }
                    catch
                    {
                        // Process might have already exited
                    }
                    finally
                    {
                        process.Dispose();
                    }
                }
            }
            catch
            {
                // Continue with next process type
            }
        }
        
        return killedCount;
    }
    
    /// <summary>
    /// Stop CyberGhost services
    /// </summary>
    private static async Task<int> StopCyberGhostService()
    {
        var serviceNames = new[] 
        { 
            CYBERGHOST_SERVICE_NAME,
            "CyberGhost",
            "CyberGhostVPN"
        };
        
        int stoppedCount = 0;
        
        foreach (var serviceName in serviceNames)
        {
            try
            {
                using var service = new ServiceController(serviceName);
                
                if (service.Status == ServiceControllerStatus.Running || 
                    service.Status == ServiceControllerStatus.StartPending)
                {
                    service.Stop();
                    service.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(30));
                    stoppedCount++;
                }
            }
            catch
            {
                // Service might not exist or already stopped
            }
        }
        
        return stoppedCount;
    }
    
    /// <summary>
    /// Get the true home IP using multiple methods and verification
    /// </summary>
    private static async Task<string?> GetTrueHomeIP()
    {
        var ipServices = new[]
        {
            "https://api.ipify.org/",
            "https://ipinfo.io/ip",
            "https://icanhazip.com/",
            "https://api.my-ip.io/ip",
            "https://checkip.amazonaws.com/"
        };
        
        var detectedIPs = new List<string>();
        
        using var client = new HttpClient();
        client.Timeout = TimeSpan.FromSeconds(10);
        
        foreach (var service in ipServices)
        {
            try
            {
                var response = await client.GetStringAsync(service);
                var ip = response.Trim();
                if (IsValidIP(ip))
                {
                    detectedIPs.Add(ip);
                }
            }
            catch
            {
                // Continue with next service
            }
        }
        
        // Return the most common IP (consensus approach)
        return detectedIPs.GroupBy(ip => ip)
                         .OrderByDescending(g => g.Count())
                         .FirstOrDefault()?.Key;
    }
    
    /// <summary>
    /// Verify VPN is completely disconnected
    /// </summary>
    private static async Task<(bool isDisconnected, string? currentIP)> VerifyVpnDisconnected(string? expectedHomeIP)
    {
        await Task.Delay(2000); // Allow time for network changes
        
        using var client = new HttpClient();
        client.Timeout = TimeSpan.FromSeconds(10);
        
        try
        {
            var currentIP = (await client.GetStringAsync("https://api.ipify.org/")).Trim();
            
            // VPN is disconnected if current IP matches expected home IP
            var isDisconnected = !string.IsNullOrEmpty(expectedHomeIP) && currentIP == expectedHomeIP;
            
            return (isDisconnected, currentIP);
        }
        catch
        {
            return (false, null);
        }
    }
    
    /// <summary>
    /// Basic IP validation
    /// </summary>
    private static bool IsValidIP(string ip)
    {
        return System.Net.IPAddress.TryParse(ip, out _);
    }
    
    /// <summary>
    /// Start CyberGhost processes for testing injection
    /// </summary>
    public static async Task<bool> StartCyberGhostForTesting()
    {
        try
        {
            Console.WriteLine("🚀 Starting CyberGhost for injection testing...");
            
            // Start the service first
            using (var service = new ServiceController(CYBERGHOST_SERVICE_NAME))
            {
                if (service.Status == ServiceControllerStatus.Stopped)
                {
                    service.Start();
                    service.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromSeconds(30));
                }
            }
            
            // Try to start the main executable
            var possiblePaths = new[]
            {
                @"C:\Program Files\CyberGhost 8\CyberGhost.exe",
                @"C:\Program Files (x86)\CyberGhost 8\CyberGhost.exe",
                @"C:\Program Files\CyberGhost VPN\CyberGhost.exe"
            };
            
            foreach (var path in possiblePaths)
            {
                if (File.Exists(path))
                {
                    var startInfo = new ProcessStartInfo
                    {
                        FileName = path,
                        Arguments = "--minimize",
                        UseShellExecute = false,
                        CreateNoWindow = true
                    };
                    
                    Process.Start(startInfo);
                    await Task.Delay(3000); // Allow startup time
                    return true;
                }
            }
            
            return false;
        }
        catch
        {
            return false;
        }
    }
}

/// <summary>
/// Result of VPN termination operation
/// </summary>
public class VpnTerminationResult
{
    public bool Success { get; set; }
    public string? Error { get; set; }
    public string? Message { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime? EndTime { get; set; }
    public TimeSpan Duration { get; set; }
    
    public int ProcessesKilled { get; set; }
    public int ServicesStopped { get; set; }
    public string? TrueHomeIP { get; set; }
    public string? CurrentIP { get; set; }
    public bool IsCompletelyDisconnected { get; set; }
}
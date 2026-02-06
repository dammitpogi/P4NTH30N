using System.Diagnostics;
using System.Management;
using System.Net.NetworkInformation;
using System.Text.Json;
using Microsoft.Win32;

namespace VPN_CLI;

/// <summary>
/// Advanced CyberGhost API interface for deep system integration
/// </summary>
public static class CyberGhostAPIInterface
{
    private const string CYBERGHOST_INSTALL_KEY = @"SOFTWARE\CyberGhost S.A.\CyberGhost";
    private const string CYBERGHOST_CONFIG_KEY = @"SOFTWARE\CyberGhost S.A.\CyberGhost\Configuration";
    private const string TAP_ADAPTER_NAME = "TAP-Windows Adapter V9";

    /// <summary>
    /// Get detailed CyberGhost installation information
    /// </summary>
    public static CyberGhostInstallInfo GetInstallationInfo()
    {
        var info = new CyberGhostInstallInfo();
        
        try
        {
            using (var key = Registry.LocalMachine.OpenSubKey(CYBERGHOST_INSTALL_KEY))
            {
                if (key != null)
                {
                    info.IsInstalled = true;
                    info.InstallPath = key.GetValue("InstallPath") as string ?? "";
                    info.Version = key.GetValue("Version") as string ?? "Unknown";
                    info.InstallDate = key.GetValue("InstallDate") as string;
                    
                    // Check for executable files
                    if (!string.IsNullOrEmpty(info.InstallPath))
                    {
                        info.ExecutablePath = Path.Combine(info.InstallPath, "CyberGhost.exe");
                        info.ServicePath = Path.Combine(info.InstallPath, "CyberGhost.Service.exe");
                        info.ExecutableExists = File.Exists(info.ExecutablePath);
                        info.ServiceExists = File.Exists(info.ServicePath);
                    }
                }
            }
            
            // Check TAP adapter
            info.TapAdapterInstalled = IsTapAdapterInstalled();
            
            // Check service registration
            info.ServiceRegistered = IsServiceRegistered();
            
        }
        catch (Exception ex)
        {
            info.Error = ex.Message;
        }
        
        return info;
    }

    /// <summary>
    /// Monitor CyberGhost connections using WMI
    /// </summary>
    public static async Task<List<NetworkConnectionInfo>> MonitorConnections()
    {
        var connections = new List<NetworkConnectionInfo>();
        
        try
        {
            using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapter WHERE NetEnabled = TRUE"))
            {
                foreach (ManagementObject adapter in searcher.Get())
                {
                    var adapterName = adapter["Name"]?.ToString() ?? "";
                    var description = adapter["Description"]?.ToString() ?? "";
                    
                    if (adapterName.Contains("TAP", StringComparison.OrdinalIgnoreCase) ||
                        description.Contains("CyberGhost", StringComparison.OrdinalIgnoreCase))
                    {
                        var connection = new NetworkConnectionInfo
                        {
                            AdapterName = adapterName,
                            Description = description,
                            MACAddress = adapter["MACAddress"]?.ToString(),
                            Speed = Convert.ToUInt64(adapter["Speed"] ?? 0),
                            IsConnected = (int)(adapter["NetConnectionStatus"] ?? 0) == 2,
                            AdapterType = adapter["AdapterType"]?.ToString() ?? ""
                        };
                        
                        // Get additional statistics
                        await GetAdapterStatistics(connection, adapter["DeviceID"]?.ToString() ?? "");
                        
                        connections.Add(connection);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Log error but don't fail completely
            connections.Add(new NetworkConnectionInfo 
            { 
                AdapterName = "Error", 
                Description = ex.Message 
            });
        }
        
        return connections;
    }

    /// <summary>
    /// Detect VPN connection leaks (DNS, IP, WebRTC)
    /// </summary>
    public static async Task<VpnLeakDetection> DetectLeaks()
    {
        var detection = new VpnLeakDetection
        {
            TestTime = DateTime.UtcNow
        };
        
        try
        {
            // Test real IP vs reported IP
            var realIpTask = GetRealIPAddress();
            var reportedIpTask = GetReportedIPAddress();
            
            await Task.WhenAll(realIpTask, reportedIpTask);
            
            detection.RealIP = realIpTask.Result;
            detection.ReportedIP = reportedIpTask.Result;
            detection.IPLeakDetected = detection.RealIP != detection.ReportedIP;
            
            // Test DNS leaks
            detection.DnsServers = await GetCurrentDnsServers();
            detection.DnsLeakDetected = await DetectDnsLeak(detection.DnsServers);
            
            // Test WebRTC leaks
            detection.WebRtcLeakDetected = await DetectWebRtcLeak();
            
            // Overall leak status
            detection.HasLeaks = detection.IPLeakDetected || detection.DnsLeakDetected || detection.WebRtcLeakDetected;
            
            if (detection.HasLeaks)
            {
                detection.Recommendations.Add("VPN connection may be compromised");
                if (detection.IPLeakDetected) 
                    detection.Recommendations.Add("IP address leak detected - reconnect VPN");
                if (detection.DnsLeakDetected) 
                    detection.Recommendations.Add("DNS leak detected - check DNS settings");
                if (detection.WebRtcLeakDetected) 
                    detection.Recommendations.Add("WebRTC leak detected - disable WebRTC in browser");
            }
        }
        catch (Exception ex)
        {
            detection.Error = ex.Message;
        }
        
        return detection;
    }

    /// <summary>
    /// Control Windows firewall for kill switch functionality
    /// </summary>
    public static async Task<bool> ConfigureKillSwitch(bool enable)
    {
        try
        {
            var firewallRules = new List<string>();
            
            if (enable)
            {
                // Block all traffic except through VPN adapter
                firewallRules.Add("netsh advfirewall firewall add rule name=\"CyberGhost_KillSwitch_Block_All\" dir=out action=block");
                firewallRules.Add("netsh advfirewall firewall add rule name=\"CyberGhost_KillSwitch_Allow_TAP\" dir=out action=allow localip=10.0.0.0/8");
                firewallRules.Add("netsh advfirewall firewall add rule name=\"CyberGhost_KillSwitch_Allow_Local\" dir=out action=allow localip=192.168.0.0/16");
                firewallRules.Add("netsh advfirewall firewall add rule name=\"CyberGhost_KillSwitch_Allow_CG\" dir=out action=allow program=\"CyberGhost.exe\"");
            }
            else
            {
                // Remove kill switch rules
                firewallRules.Add("netsh advfirewall firewall delete rule name=\"CyberGhost_KillSwitch_Block_All\"");
                firewallRules.Add("netsh advfirewall firewall delete rule name=\"CyberGhost_KillSwitch_Allow_TAP\"");
                firewallRules.Add("netsh advfirewall firewall delete rule name=\"CyberGhost_KillSwitch_Allow_Local\"");
                firewallRules.Add("netsh advfirewall firewall delete rule name=\"CyberGhost_KillSwitch_Allow_CG\"");
            }
            
            foreach (var rule in firewallRules)
            {
                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = $"/c {rule}",
                        UseShellExecute = false,
                        CreateNoWindow = true,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true
                    }
                };
                
                process.Start();
                await process.WaitForExitAsync();
                
                if (process.ExitCode != 0)
                {
                    return false;
                }
            }
            
            return true;
        }
        catch
        {
            return false;
        }
    }

    /// <summary>
    /// Get network routing table information
    /// </summary>
    public static async Task<List<RouteInfo>> GetRoutingTable()
    {
        var routes = new List<RouteInfo>();
        
        try
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "route",
                    Arguments = "print",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    CreateNoWindow = true
                }
            };
            
            process.Start();
            var output = await process.StandardOutput.ReadToEndAsync();
            await process.WaitForExitAsync();
            
            // Parse routing table output
            var lines = output.Split('\n', StringSplitOptions.RemoveEmptyEntries);
            bool inIPv4Section = false;
            
            foreach (var line in lines)
            {
                if (line.Contains("IPv4 Route Table"))
                {
                    inIPv4Section = true;
                    continue;
                }
                
                if (line.Contains("Persistent Routes:"))
                    break;
                    
                if (inIPv4Section && line.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries).Length >= 5)
                {
                    var parts = line.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length >= 5)
                    {
                        routes.Add(new RouteInfo
                        {
                            Destination = parts[0],
                            Netmask = parts[1],
                            Gateway = parts[2],
                            Interface = parts[3],
                            Metric = int.TryParse(parts[4], out var metric) ? metric : 0
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            routes.Add(new RouteInfo { Destination = "Error", Netmask = ex.Message });
        }
        
        return routes;
    }

    #region Private Helper Methods
    
    private static bool IsTapAdapterInstalled()
    {
        try
        {
            return NetworkInterface.GetAllNetworkInterfaces()
                .Any(ni => ni.Description.Contains("TAP", StringComparison.OrdinalIgnoreCase));
        }
        catch
        {
            return false;
        }
    }
    
    private static bool IsServiceRegistered()
    {
        try
        {
            using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_Service WHERE Name = 'CyberGhost8Service'"))
            {
                return searcher.Get().Count > 0;
            }
        }
        catch
        {
            return false;
        }
    }
    
    private static async Task GetAdapterStatistics(NetworkConnectionInfo connection, string deviceId)
    {
        try
        {
            using (var searcher = new ManagementObjectSearcher($"SELECT * FROM Win32_PerfRawData_Tcpip_NetworkInterface WHERE Name LIKE '%{deviceId}%'"))
            {
                foreach (ManagementObject stats in searcher.Get())
                {
                    connection.BytesReceived = Convert.ToUInt64(stats["BytesReceivedPerSec"] ?? 0);
                    connection.BytesSent = Convert.ToUInt64(stats["BytesSentPerSec"] ?? 0);
                    connection.PacketsReceived = Convert.ToUInt64(stats["PacketsReceivedPerSec"] ?? 0);
                    connection.PacketsSent = Convert.ToUInt64(stats["PacketsSentPerSec"] ?? 0);
                    break;
                }
            }
        }
        catch
        {
            // Statistics not available
        }
    }
    
    private static async Task<string?> GetRealIPAddress()
    {
        try
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10);
                return (await client.GetStringAsync("https://ipinfo.io/ip")).Trim();
            }
        }
        catch
        {
            return null;
        }
    }
    
    private static async Task<string?> GetReportedIPAddress()
    {
        try
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10);
                return (await client.GetStringAsync("https://api.ipify.org/")).Trim();
            }
        }
        catch
        {
            return null;
        }
    }
    
    private static async Task<List<string>> GetCurrentDnsServers()
    {
        var dnsServers = new List<string>();
        
        try
        {
            foreach (var ni in NetworkInterface.GetAllNetworkInterfaces())
            {
                if (ni.OperationalStatus == OperationalStatus.Up)
                {
                    var ipProps = ni.GetIPProperties();
                    foreach (var dns in ipProps.DnsAddresses)
                    {
                        dnsServers.Add(dns.ToString());
                    }
                }
            }
        }
        catch
        {
            // DNS detection failed
        }
        
        return dnsServers.Distinct().ToList();
    }
    
    private static async Task<bool> DetectDnsLeak(List<string> dnsServers)
    {
        // Check if any DNS servers belong to ISPs or known leak-prone ranges
        var leakyRanges = new[]
        {
            "8.8.8.", "8.8.4.", // Google DNS
            "1.1.1.", "1.0.0.", // Cloudflare
            "208.67.", "222.222.", // OpenDNS
        };
        
        return dnsServers.Any(dns => 
            leakyRanges.Any(range => dns.StartsWith(range)) ||
            !dns.StartsWith("10.") && !dns.StartsWith("192.168.") && !dns.StartsWith("172.")
        );
    }
    
    private static async Task<bool> DetectWebRtcLeak()
    {
        // WebRTC leak detection would require browser integration
        // For now, return false but this could be enhanced
        return false;
    }
    
    #endregion
}

/// <summary>
/// CyberGhost installation information
/// </summary>
public class CyberGhostInstallInfo
{
    public bool IsInstalled { get; set; }
    public string InstallPath { get; set; } = string.Empty;
    public string Version { get; set; } = string.Empty;
    public string? InstallDate { get; set; }
    public string ExecutablePath { get; set; } = string.Empty;
    public string ServicePath { get; set; } = string.Empty;
    public bool ExecutableExists { get; set; }
    public bool ServiceExists { get; set; }
    public bool TapAdapterInstalled { get; set; }
    public bool ServiceRegistered { get; set; }
    public string? Error { get; set; }
}

/// <summary>
/// Network connection information
/// </summary>
public class NetworkConnectionInfo
{
    public string AdapterName { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string? MACAddress { get; set; }
    public ulong Speed { get; set; }
    public bool IsConnected { get; set; }
    public string AdapterType { get; set; } = string.Empty;
    public ulong BytesReceived { get; set; }
    public ulong BytesSent { get; set; }
    public ulong PacketsReceived { get; set; }
    public ulong PacketsSent { get; set; }
}

/// <summary>
/// VPN leak detection results
/// </summary>
public class VpnLeakDetection
{
    public DateTime TestTime { get; set; }
    public bool HasLeaks { get; set; }
    public bool IPLeakDetected { get; set; }
    public bool DnsLeakDetected { get; set; }
    public bool WebRtcLeakDetected { get; set; }
    public string? RealIP { get; set; }
    public string? ReportedIP { get; set; }
    public List<string> DnsServers { get; set; } = new();
    public List<string> Recommendations { get; set; } = new();
    public string? Error { get; set; }
}

/// <summary>
/// Network route information
/// </summary>
public class RouteInfo
{
    public string Destination { get; set; } = string.Empty;
    public string Netmask { get; set; } = string.Empty;
    public string Gateway { get; set; } = string.Empty;
    public string Interface { get; set; } = string.Empty;
    public int Metric { get; set; }
}
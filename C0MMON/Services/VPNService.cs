using P4NTH30N.C0MMON;
using System.Diagnostics;

namespace P4NTH30N.Services;

public class VPNService {
    private static readonly HttpClient _httpClient = new();
    private static readonly string[] ForbiddenRegions = ["Nevada", "California"];
    private static string? _homeIP;
    
    /// <summary>
    /// Initializes VPN service and detects home IP address
    /// </summary>
    public static async Task Initialize() {
        try {
            _homeIP = await NetworkAddress.MyIP(_httpClient);
            Console.WriteLine($"{DateTime.Now} - VPN Service: Home IP detected: {_homeIP}");
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to detect home IP: {ex.Message}");
            _homeIP = "";
        }
    }
    
    /// <summary>
    /// Ensures VPN is active and location is compliant
    /// </summary>
    public static async Task<bool> EnsureCompliantConnection() {
        try {
            // Self-repair: Ensure CyberGhost is running
            if (Process.GetProcessesByName("CyberGhost").Length == 0) {
                LaunchVPN();
            }

            // Wait for VPN activation (IP change from home IP)
            string currentIP = await NetworkAddress.MyIP(_httpClient);
            int vpnWaitAttempts = 0;
            
            while (new[] { "", _homeIP }.Contains(currentIP) && vpnWaitAttempts < 30) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Waiting for VPN activation... Attempt {++vpnWaitAttempts}");
                
                // Self-repair: If stuck on home IP after 10 attempts (20s), try resetting connection
                if (vpnWaitAttempts == 10 && new[] { "", _homeIP }.Contains(currentIP)) {
                    await ResetConnection();
                    vpnWaitAttempts = 0;
                }

                await Task.Delay(2000); // Wait 2 seconds
                currentIP = await NetworkAddress.MyIP(_httpClient);
            }
            
            if (new[] { "", _homeIP }.Contains(currentIP)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: VPN activation timeout");
                return false;
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: VPN activated - IP changed from {_homeIP} to {currentIP}");
            
            // Validate location compliance
            NetworkAddress network = await NetworkAddress.Get(_httpClient);
            int regionChangeAttempts = 0;
            
            while (ForbiddenRegions.Contains(network.location?.state_prov) && regionChangeAttempts < 10) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Forbidden region detected: {network.location?.state_prov}. Changing VPN location...");
                
                // Click VPN interface to change location (using W4TCHD0G coordinates)
                Mouse.Click(1120, 280); // VPN location change button
                
                // Wait for location change
                await Task.Delay(5000); // Wait 5 seconds for VPN to change location
                
                // Re-validate location
                network = await NetworkAddress.Get(_httpClient);
                Console.WriteLine($"{DateTime.Now} - VPN Service: New location: {network.location?.state_prov}");
                regionChangeAttempts++;
            }
            
            if (ForbiddenRegions.Contains(network.location?.state_prov)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to find compliant location after {regionChangeAttempts} attempts");
                return false;
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: Compliant location established: {network.location?.city}, {network.location?.state_prov} ({network.ip})");
            return true;
            
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error ensuring compliant connection: {ex.Message}");
            return false;
        }
    }
    
    /// <summary>
    /// Gets current network location information
    /// </summary>
    public static async Task<NetworkAddress?> GetCurrentLocation() {
        try {
            return await NetworkAddress.Get(_httpClient);
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error getting location: {ex.Message}");
            return null;
        }
    }
    
    /// <summary>
    /// Validates if current location is compliant
    /// </summary>
    public static bool IsLocationCompliant(NetworkAddress? network) {
        if (network?.location?.state_prov == null) {
            return false;
        }
        
        bool compliant = !ForbiddenRegions.Contains(network.location.state_prov);
        if (!compliant) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Location non-compliant: {network.location.state_prov}");
        }
        
        return compliant;
    }
    
    /// <summary>
    /// Launches CyberGhost VPN if not running
    /// </summary>
    public static void LaunchVPN() {
        try {
            Process[] processes = Process.GetProcessesByName("CyberGhost");
            if (processes.Length == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Launching CyberGhost VPN...");
                Process.Start(new ProcessStartInfo {
                    FileName = "C:\\Program Files\\CyberGhost\\CyberGhost.exe",
                    UseShellExecute = true
                });
                
                // Wait for VPN to initialize
                Thread.Sleep(5000);
                
                // Click CyberGhost taskbar if needed (coordinates from W4TCHD0G)
                Mouse.Click(749, 697); // CyberGhost taskbar
                Thread.Sleep(2000);
            } else {
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost already running");
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error launching VPN: {ex.Message}");
        }
    }
    
    /// <summary>
    /// Resets VPN connection
    /// </summary>
    public static async Task ResetConnection() {
        try {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Resetting VPN connection...");
            Mouse.Click(1120, 280); // Disconnect/reconnect button
            await Task.Delay(3000);
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error resetting connection: {ex.Message}");
        }
    }
}
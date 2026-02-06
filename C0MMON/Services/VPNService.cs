using P4NTH30N.C0MMON;
using System.Diagnostics;

namespace P4NTH30N.Services;

public class VPNService {
    private static readonly HttpClient _httpClient = new();
    private static readonly string[] ForbiddenRegions = ["Nevada", "California"];
    private static string? _homeIP;
    private static string? _cyberGhostPath;
    
    /// <summary>
    /// Initializes VPN service and detects home IP address
    /// </summary>
    public static async Task Initialize() {
        try {
            _homeIP = await NetworkAddress.MyIP(_httpClient);
            Console.WriteLine($"{DateTime.Now} - VPN Service: Home IP detected: {_homeIP}");
            
            // Detect and ensure CyberGhost is installed
            await EnsureCyberGhostInstalled();
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to initialize: {ex.Message}");
            _homeIP = "";
        }
    }
    
    /// <summary>
    /// Ensures VPN is active and location is compliant
    /// </summary>
    public static async Task<bool> EnsureCompliantConnection() {
        try {
            // Check if CyberGhost is installed first
            if (string.IsNullOrEmpty(_cyberGhostPath)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost not installed. Cannot establish VPN connection.");
                return false;
            }

            // Self-repair: Ensure CyberGhost is running
            if (Process.GetProcessesByName("CyberGhost").Length == 0 && 
                Process.GetProcessesByName("Dashboard").Length == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost not running. Attempting to launch...");
                LaunchVPN();
                
                // Wait for process to start
                await Task.Delay(5000);
                
                // Verify it actually started (check both possible process names)
                if (Process.GetProcessesByName("CyberGhost").Length == 0 && 
                    Process.GetProcessesByName("Dashboard").Length == 0) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to launch CyberGhost");
                    return false;
                }
            }

            // Wait for VPN activation (IP change from home IP)
            string currentIP;
            try {
                currentIP = await NetworkAddress.MyIP(_httpClient);
            } catch (Exception ex) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to get current IP: {ex.Message}");
                return false;
            }
            
            int vpnWaitAttempts = 0;
            
            while ((string.IsNullOrEmpty(currentIP) || currentIP == _homeIP) && vpnWaitAttempts < 30) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Waiting for VPN activation... Attempt {++vpnWaitAttempts}");
                
                // Self-repair: If stuck on home IP after 10 attempts (20s), try resetting connection
                if (vpnWaitAttempts == 10 && (string.IsNullOrEmpty(currentIP) || currentIP == _homeIP)) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: VPN appears stuck. Attempting connection reset...");
                    await ResetConnection();
                    vpnWaitAttempts = 0;
                }

                await Task.Delay(2000); // Wait 2 seconds
                
                try {
                    currentIP = await NetworkAddress.MyIP(_httpClient);
                } catch (Exception ex) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Error getting IP on attempt {vpnWaitAttempts}: {ex.Message}");
                    currentIP = "";
                }
            }
            
            if (string.IsNullOrEmpty(currentIP) || currentIP == _homeIP) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: VPN activation timeout after {vpnWaitAttempts} attempts");
                return false;
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: VPN activated - IP changed from {_homeIP} to {currentIP}");
            
            // Validate location compliance
            NetworkAddress? network;
            try {
                network = await NetworkAddress.Get(_httpClient);
            } catch (Exception ex) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to get location information: {ex.Message}");
                return false;
            }
            
            if (network?.location?.state_prov == null) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Unable to determine location. Cannot verify compliance.");
                return false;
            }
            
            int regionChangeAttempts = 0;
            
            while (network?.location?.state_prov != null && ForbiddenRegions.Contains(network.location.state_prov) && regionChangeAttempts < 10) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Forbidden region detected: {network.location.state_prov}. Changing VPN location... (Attempt {regionChangeAttempts + 1}/10)");
                
                // Click VPN interface to change location (using W4TCHD0G coordinates)
                try {
                    Mouse.Click(1120, 280); // VPN location change button
                } catch (Exception ex) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Error clicking location change button: {ex.Message}");
                }
                
                // Wait for location change
                await Task.Delay(5000); // Wait 5 seconds for VPN to change location
                
                // Re-validate location
                try {
                    network = await NetworkAddress.Get(_httpClient);
                    if (network?.location?.state_prov != null) {
                        Console.WriteLine($"{DateTime.Now} - VPN Service: New location: {network.location.state_prov}");
                    } else {
                        Console.WriteLine($"{DateTime.Now} - VPN Service: Unable to determine new location");
                    }
                } catch (Exception ex) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Error getting new location on attempt {regionChangeAttempts + 1}: {ex.Message}");
                }
                
                regionChangeAttempts++;
            }
            
            if (network?.location?.state_prov != null && ForbiddenRegions.Contains(network.location.state_prov)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to find compliant location after {regionChangeAttempts} attempts. Current: {network.location.state_prov}");
                return false;
            }
            
            if (network?.location == null) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Unable to verify location compliance due to network detection failure");
                return false;
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: Compliant location established: {network.location.city}, {network.location.state_prov} ({network.ip})");
            return true;
            
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Unexpected error ensuring compliant connection: {ex.Message}");
            Console.WriteLine($"{DateTime.Now} - VPN Service: Stack trace: {ex.StackTrace}");
            return false;
        }
    }
    
    /// <summary>
    /// Gets current network location information
    /// </summary>
    public static async Task<NetworkAddress?> GetCurrentLocation() {
        try {
            var result = await NetworkAddress.Get(_httpClient);
            if (result == null) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Network location query returned null");
                return null;
            }
            
            if (result.location == null) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Location data is null in network response");
                return result; // Still return the result as it may have IP information
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: Location retrieved: {result.location.city}, {result.location.state_prov} ({result.ip})");
            return result;
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
            Process[] cybGhostProcs = Process.GetProcessesByName("CyberGhost");
            Process[] dashboardProcs = Process.GetProcessesByName("Dashboard");
            
            if (cybGhostProcs.Length == 0 && dashboardProcs.Length == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Launching CyberGhost VPN...");
                
                string? cyberGhostPath = GetCyberGhostPath();
                if (string.IsNullOrEmpty(cyberGhostPath)) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost not found. Cannot launch.");
                    return;
                }
                
                if (!File.Exists(cyberGhostPath)) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost executable not found at: {cyberGhostPath}");
                    return;
                }
                
                try {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Starting CyberGhost from: {cyberGhostPath}");
                    Process.Start(new ProcessStartInfo {
                        FileName = cyberGhostPath,
                        UseShellExecute = true,
                        CreateNoWindow = true
                    });
                    
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost launch command sent successfully");
                } catch (Exception ex) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to start CyberGhost process: {ex.Message}");
                    return;
                }
                
                // Wait for VPN to initialize
                Console.WriteLine($"{DateTime.Now} - VPN Service: Waiting for CyberGhost to initialize...");
                Thread.Sleep(5000);
                
                // Verify the process actually started
                cybGhostProcs = Process.GetProcessesByName("CyberGhost");
                dashboardProcs = Process.GetProcessesByName("Dashboard");
                
                if (cybGhostProcs.Length == 0 && dashboardProcs.Length == 0) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost process not detected after launch attempt");
                    return;
                }
                
                int totalProcs = cybGhostProcs.Length + dashboardProcs.Length;
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost processes detected: CyberGhost({cybGhostProcs.Length}), Dashboard({dashboardProcs.Length})");
                
                // Click CyberGhost taskbar if needed (coordinates from W4TCHD0G)
                try {
                    Mouse.Click(749, 697); // CyberGhost taskbar
                    Thread.Sleep(2000);
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost taskbar interaction completed");
                } catch (Exception ex) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: Warning: Failed to interact with CyberGhost UI: {ex.Message}");
                }
            } else {
                int totalProcs = cybGhostProcs.Length + dashboardProcs.Length;
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost already running - CyberGhost({cybGhostProcs.Length}), Dashboard({dashboardProcs.Length}) processes detected");
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Unexpected error launching VPN: {ex.Message}");
            Console.WriteLine($"{DateTime.Now} - VPN Service: Stack trace: {ex.StackTrace}");
        }
    }
    
    /// <summary>
    /// Resets VPN connection
    /// </summary>
    public static async Task ResetConnection() {
        try {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Resetting VPN connection...");
            
            // Verify CyberGhost is running before attempting reset
            if (Process.GetProcessesByName("CyberGhost").Length == 0 && 
                Process.GetProcessesByName("Dashboard").Length == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Cannot reset connection - CyberGhost is not running");
                return;
            }
            
            // Attempt to reset connection via UI interaction
            try {
                Mouse.Click(1120, 280); // Disconnect/reconnect button
                Console.WriteLine($"{DateTime.Now} - VPN Service: Connection reset command sent");
            } catch (Exception ex) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Warning: Failed to interact with reset button: {ex.Message}");
            }
            
            await Task.Delay(3000);
            Console.WriteLine($"{DateTime.Now} - VPN Service: Connection reset completed");
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Unexpected error resetting connection: {ex.Message}");
        }
    }
    
    /// <summary>
    /// Ensures CyberGhost is installed, installing via winget if necessary
    /// </summary>
    private static async Task EnsureCyberGhostInstalled() {
        try {
            // Check if CyberGhost is already installed
            _cyberGhostPath = GetCyberGhostPath();
            if (!string.IsNullOrEmpty(_cyberGhostPath)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost found at: {_cyberGhostPath}");
                return;
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost not found. Attempting to install via winget...");
            
            // Install CyberGhost via winget
            bool installSuccess = await InstallCyberGhostViaWinget();
            if (installSuccess) {
                // Re-check for installation path after successful install
                _cyberGhostPath = GetCyberGhostPath();
                if (!string.IsNullOrEmpty(_cyberGhostPath)) {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost successfully installed at: {_cyberGhostPath}");
                } else {
                    Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost installed but path not detected. Manual configuration may be required.");
                }
            } else {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Failed to install CyberGhost. Please install manually.");
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error ensuring CyberGhost installation: {ex.Message}");
        }
    }
    
    /// <summary>
    /// Gets the CyberGhost executable path from common installation locations
    /// </summary>
    private static string? GetCyberGhostPath() {
        if (!string.IsNullOrEmpty(_cyberGhostPath) && File.Exists(_cyberGhostPath)) {
            return _cyberGhostPath;
        }
        
        // Common installation paths for CyberGhost
        string[] possiblePaths = [
            @"C:\Program Files\CyberGhost\CyberGhost.exe",
            @"C:\Program Files (x86)\CyberGhost\CyberGhost.exe",
            @"C:\Program Files\CyberGhost 8\Dashboard.exe", // CyberGhost 8 main executable
            @"C:\Program Files\CyberGhost 8\CyberGhost.exe",
            @"C:\Program Files (x86)\CyberGhost 8\Dashboard.exe",
            @"C:\Program Files (x86)\CyberGhost 8\CyberGhost.exe",
            @"C:\Users\" + Environment.UserName + @"\AppData\Local\CyberGhost\CyberGhost.exe",
            @"C:\Users\" + Environment.UserName + @"\AppData\Roaming\CyberGhost\CyberGhost.exe",
            @"C:\Users\" + Environment.UserName + @"\AppData\Local\Programs\CyberGhost\CyberGhost.exe",
            @"C:\Users\" + Environment.UserName + @"\AppData\Local\CyberGhost\Dashboard.exe",
            @"C:\Users\" + Environment.UserName + @"\AppData\Roaming\CyberGhost\Dashboard.exe",
            @"C:\ProgramData\CyberGhost\CyberGhost.exe",
            @"C:\ProgramData\CyberGhost\Dashboard.exe"
        ];
        
        foreach (string path in possiblePaths) {
            if (File.Exists(path)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Found CyberGhost at: {path}");
                _cyberGhostPath = path;
                return path;
            }
        }
        
        // Try to find via Windows Registry (installed programs)
        try {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Checking registry for CyberGhost installation...");
            using Process process = new Process {
                StartInfo = new ProcessStartInfo {
                    FileName = "powershell",
                    Arguments = @"-Command ""Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like '*CyberGhost*'} | Select-Object DisplayName, InstallLocation, UninstallString""",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    CreateNoWindow = true
                }
            };
            
            process.Start();
            string output = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: Registry search output: {output}");
            
            if (!string.IsNullOrWhiteSpace(output)) {
                // Parse the install location from PowerShell output
                string[] lines = output.Split('\n');
                foreach (string line in lines) {
                    if (line.Contains("InstallLocation") && line.Contains(":")) {
                        string installPath = line.Split(':')[1].Trim();
                        if (!string.IsNullOrEmpty(installPath) && Directory.Exists(installPath)) {
                            string exePath = Path.Combine(installPath, "CyberGhost.exe");
                            if (File.Exists(exePath)) {
                                Console.WriteLine($"{DateTime.Now} - VPN Service: Found CyberGhost via registry at: {exePath}");
                                _cyberGhostPath = exePath;
                                return exePath;
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error checking registry for CyberGhost: {ex.Message}");
        }
        
        // Try to find via Windows App Paths registry
        try {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Checking App Paths registry...");
            using Process process = new Process {
                StartInfo = new ProcessStartInfo {
                    FileName = "powershell",
                    Arguments = @"-Command ""Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CyberGhost.exe' -ErrorAction SilentlyContinue | Select-Object '(default)'""",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    CreateNoWindow = true
                }
            };
            
            process.Start();
            string output = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
            
            if (!string.IsNullOrWhiteSpace(output) && output.Contains("C:")) {
                string[] lines = output.Split('\n');
                foreach (string line in lines) {
                    if (line.Contains("C:") && line.Contains("CyberGhost")) {
                        string path = line.Split(':')[1].Trim();
                        if (File.Exists(path)) {
                            Console.WriteLine($"{DateTime.Now} - VPN Service: Found CyberGhost via App Paths at: {path}");
                            _cyberGhostPath = path;
                            return path;
                        }
                    }
                }
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error checking App Paths registry: {ex.Message}");
        }
        
        // Try to find by searching in all drive Program Files directories
        try {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Searching for CyberGhost.exe in system drives...");
            string[] drives = Directory.GetLogicalDrives();
            foreach (string drive in drives) {
                string[] searchPaths = [
                    Path.Combine(drive, "Program Files", "CyberGhost", "CyberGhost.exe"),
                    Path.Combine(drive, "Program Files (x86)", "CyberGhost", "CyberGhost.exe")
                ];
                
                foreach (string searchPath in searchPaths) {
                    if (File.Exists(searchPath)) {
                        Console.WriteLine($"{DateTime.Now} - VPN Service: Found CyberGhost via drive search at: {searchPath}");
                        _cyberGhostPath = searchPath;
                        return searchPath;
                    }
                }
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error during drive search: {ex.Message}");
        }
        
        Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost executable not found in any standard locations");
        return null;
    }
    
    /// <summary>
    /// Installs CyberGhost VPN via winget
    /// </summary>
    private static async Task<bool> InstallCyberGhostViaWinget() {
        try {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Starting CyberGhost installation via winget...");
            
            using Process process = new Process {
                StartInfo = new ProcessStartInfo {
                    FileName = "cmd",
                    Arguments = "/c winget install --id CyberGhost.CyberGhost --accept-package-agreements --accept-source-agreements --silent",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true,
                    Verb = "runas" // Request elevated privileges
                }
            };
            
            process.Start();
            
            string output = await process.StandardOutput.ReadToEndAsync();
            string error = await process.StandardError.ReadToEndAsync();
            
            await process.WaitForExitAsync();
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: Installation output: {output}");
            if (!string.IsNullOrEmpty(error)) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Installation error: {error}");
            }
            
            if (process.ExitCode == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost installation completed successfully");
                return true;
            } else {
                Console.WriteLine($"{DateTime.Now} - VPN Service: CyberGhost installation failed. Exit code: {process.ExitCode}");
                
                // Try alternative installation method if the first one fails
                Console.WriteLine($"{DateTime.Now} - VPN Service: Trying alternative installation method...");
                return await TryAlternativeInstallation();
            }
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error installing CyberGhost via winget: {ex.Message}");
            
            // Try alternative installation if winget fails completely
            Console.WriteLine($"{DateTime.Now} - VPN Service: Attempting alternative installation...");
            return await TryAlternativeInstallation();
        }
    }
    
    /// <summary>
    /// Attempts alternative CyberGhost installation methods
    /// </summary>
    private static async Task<bool> TryAlternativeInstallation() {
        try {
            // Method 1: Try the CyberGhost ID without elevated privileges
            using Process process1 = new Process {
                StartInfo = new ProcessStartInfo {
                    FileName = "winget",
                    Arguments = "install CyberGhost.CyberGhost",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                }
            };
            
            process1.Start();
            await process1.WaitForExitAsync();
            
            if (process1.ExitCode == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Alternative installation method 1 succeeded");
                return true;
            }
            
            // Method 2: Try with different package name
            using Process process2 = new Process {
                StartInfo = new ProcessStartInfo {
                    FileName = "winget",
                    Arguments = "install cyberghost",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                }
            };
            
            process2.Start();
            await process2.WaitForExitAsync();
            
            if (process2.ExitCode == 0) {
                Console.WriteLine($"{DateTime.Now} - VPN Service: Alternative installation method 2 succeeded");
                return true;
            }
            
            Console.WriteLine($"{DateTime.Now} - VPN Service: All alternative installation methods failed");
            Console.WriteLine($"{DateTime.Now} - VPN Service: Please install CyberGhost manually from: https://www.cyberghostvpn.com/");
            return false;
            
        } catch (Exception ex) {
            Console.WriteLine($"{DateTime.Now} - VPN Service: Error in alternative installation: {ex.Message}");
            return false;
        }
    }
}
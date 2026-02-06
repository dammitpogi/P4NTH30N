using System.Diagnostics;
using System.Text.Json;
using P4NTH30N.C0MMON;
using P4NTH30N.Services;

namespace VPN_CLI;

public static partial class CommandHandlers
{
    public static async Task HandleInstallStatus()
    {
        try
        {
            // Check if CyberGhost is installed by looking for executable
            string[] possiblePaths = [
                @"C:\Program Files\CyberGhost\CyberGhost.exe",
                @"C:\Program Files (x86)\CyberGhost\CyberGhost.exe",
                @"C:\Program Files\CyberGhost 8\Dashboard.exe",
                @"C:\Program Files\CyberGhost 8\CyberGhost.exe",
                @"C:\Program Files (x86)\CyberGhost 8\Dashboard.exe",
                @"C:\Program Files (x86)\CyberGhost 8\CyberGhost.exe"
            ];
            
            var installedPaths = possiblePaths.Where(File.Exists).ToList();
            bool isInstalled = installedPaths.Any();
            
            if (Program._jsonOutput)
            {
                var installJson = new
                {
                    installed = isInstalled,
                    installation_paths = installedPaths,
                    searched_paths = possiblePaths,
                    winget_available = await IsWingetAvailable(),
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(installJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine("📦 CyberGhost Installation Status");
                Console.WriteLine("────────────────────────────────────");
                Console.WriteLine($"Status: {(isInstalled ? "✅ INSTALLED" : "❌ NOT INSTALLED")}");
                
                if (isInstalled)
                {
                    Console.WriteLine("Installation paths found:");
                    foreach (var path in installedPaths)
                    {
                        var fileInfo = new FileInfo(path);
                        Console.WriteLine($"  • {path}");
                        if (Program._verboseOutput)
                        {
                            Console.WriteLine($"    Size: {fileInfo.Length / 1024 / 1024:F1} MB");
                            Console.WriteLine($"    Modified: {fileInfo.LastWriteTime}");
                        }
                    }
                }
                else
                {
                    Console.WriteLine();
                    Console.WriteLine("🔧 Installation Options:");
                    if (await IsWingetAvailable())
                    {
                        Console.WriteLine("  1. Automatic: The VPN service can auto-install via winget");
                        Console.WriteLine("  2. Manual: Download from https://www.cyberghostvpn.com/");
                    }
                    else
                    {
                        Console.WriteLine("  • Manual: Download from https://www.cyberghostvpn.com/");
                        Console.WriteLine("  • winget not available for automatic installation");
                    }
                }
                
                if (Program._verboseOutput)
                {
                    Console.WriteLine();
                    Console.WriteLine("Searched paths:");
                    foreach (var path in possiblePaths)
                    {
                        Console.WriteLine($"  {(File.Exists(path) ? "✅" : "❌")} {path}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"Error checking installation: {ex.Message}");
            }
        }
    }

    public static void HandleVersion()
    {
        var version = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;
        
        if (Program._jsonOutput)
        {
            var versionJson = new
            {
                vpn_cli = new
                {
                    version = version?.ToString() ?? "1.0.0",
                    build_date = GetBuildDate(),
                    framework = Environment.Version.ToString(),
                    platform = Environment.OSVersion.ToString()
                },
                dependencies = new
                {
                    dotnet_runtime = Environment.Version.ToString(),
                    system_commandline = "2.0.0-beta4",
                    figgle = "0.5.1",
                    console_tables = "2.6.1"
                },
                system = new
                {
                    os = Environment.OSVersion.ToString(),
                    architecture = Environment.OSVersion.Platform.ToString(),
                    machine_name = Environment.MachineName,
                    user = Environment.UserName
                },
                timestamp = DateTime.UtcNow
            };
            
            Console.WriteLine(JsonSerializer.Serialize(versionJson, new JsonSerializerOptions { WriteIndented = true }));
        }
        else
        {
            Console.WriteLine("🔖 Version Information");
            Console.WriteLine("──────────────────────");
            Console.WriteLine($"VPN CLI: v{version?.ToString() ?? "1.0.0"}");
            Console.WriteLine($"Build Date: {GetBuildDate()}");
            Console.WriteLine($".NET Runtime: {Environment.Version}");
            Console.WriteLine($"Platform: {Environment.OSVersion}");
            Console.WriteLine();
            Console.WriteLine("Dependencies:");
            Console.WriteLine("  • System.CommandLine: 2.0.0-beta4");
            Console.WriteLine("  • Figgle: 0.5.1");
            Console.WriteLine("  • ConsoleTables: 2.6.1");
            Console.WriteLine("  • P4NTH30N.C0MMON: (local reference)");
            
            if (Program._verboseOutput)
            {
                Console.WriteLine();
                Console.WriteLine("System Information:");
                Console.WriteLine($"  Machine: {Environment.MachineName}");
                Console.WriteLine($"  User: {Environment.UserName}");
                Console.WriteLine($"  Working Directory: {Environment.CurrentDirectory}");
                Console.WriteLine($"  Command Line: {Environment.CommandLine}");
            }
        }
    }

    public static async Task HandleWatch(int intervalSeconds, int maxIterations)
    {
        try
        {
            if (!Program._jsonOutput)
            {
                Console.WriteLine($"👁️  Watching VPN Status (refresh every {intervalSeconds}s)");
                Console.WriteLine("Press Ctrl+C to stop");
                Console.WriteLine("═══════════════════════════════════════════════════════");
                Console.WriteLine();
            }
            
            int iteration = 0;
            while (maxIterations == 0 || iteration < maxIterations)
            {
                if (!Program._jsonOutput && iteration > 0)
                {
                    Console.Clear();
                    Console.WriteLine($"👁️  VPN Status Watch - Iteration {iteration + 1}" + 
                                    (maxIterations > 0 ? $"/{maxIterations}" : ""));
                    Console.WriteLine($"Last updated: {DateTime.Now:HH:mm:ss}");
                    Console.WriteLine("─────────────────────────────────────────────");
                    Console.WriteLine();
                }
                
                // Show current status
                await HandleCurrentStatus();
                
                if (!Program._jsonOutput)
                {
                    Console.WriteLine();
                    Console.WriteLine($"Next refresh in {intervalSeconds} seconds...");
                }
                
                iteration++;
                
                if (maxIterations > 0 && iteration >= maxIterations)
                    break;
                
                await Task.Delay(intervalSeconds * 1000);
            }
            
            if (!Program._jsonOutput)
            {
                Console.WriteLine();
                Console.WriteLine($"✅ Watch completed after {iteration} iterations");
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"❌ Watch failed: {ex.Message}");
            }
        }
    }

    public static async Task HandleAutoManagement(int checkIntervalSeconds, int retryLimit)
    {
        try
        {
            if (!Program._jsonOutput)
            {
                Console.WriteLine("🤖 Automated VPN Management Started");
                Console.WriteLine($"Compliance check interval: {checkIntervalSeconds} seconds");
                Console.WriteLine($"Retry limit: {retryLimit} attempts");
                Console.WriteLine("Press Ctrl+C to stop");
                Console.WriteLine("═══════════════════════════════════════════════");
                Console.WriteLine();
            }
            
            await VPNService.Initialize();
            int checkCount = 0;
            
            while (true)
            {
                checkCount++;
                var timestamp = DateTime.Now;
                
                try
                {
                    var location = await VPNService.GetCurrentLocation();
                    var homeIP = await NetworkAddress.MyIP(new HttpClient());
                    bool isCompliant = location != null && VPNService.IsLocationCompliant(location);
                    bool isVpnActive = location?.ip != homeIP;
                    
                    if (Program._jsonOutput)
                    {
                        var statusJson = new
                        {
                            check_number = checkCount,
                            timestamp = timestamp,
                            vpn_active = isVpnActive,
                            compliant = isCompliant,
                            current_ip = location?.ip,
                            location = location?.location?.city + ", " + location?.location?.state_prov,
                            action_taken = "none"
                        };
                        
                        // Take corrective action if needed
                        if (!isCompliant || !isVpnActive)
                        {
                            if (!Program._jsonOutput)
                                Console.WriteLine($"⚠️  Non-compliant state detected. Taking corrective action...");
                            
                            bool fixSuccess = false;
                            for (int retry = 0; retry < retryLimit; retry++)
                            {
                                if (await VPNService.EnsureCompliantConnection())
                                {
                                    fixSuccess = true;
                                    var newLocation = await VPNService.GetCurrentLocation();
                                    statusJson = new
                                    {
                                        check_number = checkCount,
                                        timestamp = timestamp,
                                        vpn_active = true,
                                        compliant = true,
                                        current_ip = newLocation?.ip,
                                        location = newLocation?.location?.city + ", " + newLocation?.location?.state_prov,
                                        action_taken = $"corrected_after_{retry + 1}_attempts"
                                    };
                                    break;
                                }
                                
                                if (retry < retryLimit - 1)
                                    await Task.Delay(5000); // Wait before retry
                            }
                            
                            if (!fixSuccess)
                            {
                                statusJson = new
                                {
                                    check_number = checkCount,
                                    timestamp = timestamp,
                                    vpn_active = isVpnActive,
                                    compliant = false,
                                    current_ip = location?.ip,
                                    location = location?.location?.city + ", " + location?.location?.state_prov,
                                    action_taken = $"correction_failed_after_{retryLimit}_attempts"
                                };
                            }
                        }
                        
                        Console.WriteLine(JsonSerializer.Serialize(statusJson, new JsonSerializerOptions { WriteIndented = true }));
                    }
                    else
                    {
                        Console.WriteLine($"[{timestamp:HH:mm:ss}] Check #{checkCount}");
                        Console.WriteLine($"  VPN Active: {(isVpnActive ? "✅" : "❌")}");
                        Console.WriteLine($"  Compliant: {(isCompliant ? "✅" : "❌")}");
                        Console.WriteLine($"  Location: {location?.location?.city}, {location?.location?.state_prov}");
                        Console.WriteLine($"  IP: {location?.ip}");
                        
                        if (!isCompliant || !isVpnActive)
                        {
                            Console.WriteLine("  🔧 Taking corrective action...");
                            
                            bool fixSuccess = false;
                            for (int retry = 0; retry < retryLimit; retry++)
                            {
                                Console.WriteLine($"    Attempt {retry + 1}/{retryLimit}");
                                if (await VPNService.EnsureCompliantConnection())
                                {
                                    Console.WriteLine("    ✅ Corrective action successful");
                                    fixSuccess = true;
                                    break;
                                }
                                
                                if (retry < retryLimit - 1)
                                    await Task.Delay(5000);
                            }
                            
                            if (!fixSuccess)
                            {
                                Console.WriteLine("    ❌ Corrective action failed after all attempts");
                            }
                        }
                        
                        Console.WriteLine();
                    }
                }
                catch (Exception ex)
                {
                    if (Program._jsonOutput)
                    {
                        var errorJson = new
                        {
                            check_number = checkCount,
                            timestamp = timestamp,
                            error = ex.Message
                        };
                        Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
                    }
                    else
                    {
                        Console.WriteLine($"[{timestamp:HH:mm:ss}] Check #{checkCount} - Error: {ex.Message}");
                    }
                }
                
                await Task.Delay(checkIntervalSeconds * 1000);
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"❌ Auto-management failed: {ex.Message}");
            }
        }
    }

    private static async Task<bool> IsWingetAvailable()
    {
        try
        {
            using var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "winget",
                    Arguments = "--version",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    CreateNoWindow = true
                }
            };
            
            process.Start();
            await process.WaitForExitAsync();
            return process.ExitCode == 0;
        }
        catch
        {
            return false;
        }
    }

    private static string GetBuildDate()
    {
        try
        {
            var baseDir = AppContext.BaseDirectory;
            var assemblyFile = Path.Combine(baseDir, "vpn.exe");
            if (File.Exists(assemblyFile))
            {
                var fileInfo = new FileInfo(assemblyFile);
                return fileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss");
            }
            return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }
        catch
        {
            return "Unknown";
        }
    }
}
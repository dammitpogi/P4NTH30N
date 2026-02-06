using System.Diagnostics;
using System.Text.Json;
using ConsoleTables;
using P4NTH30N.C0MMON;
using P4NTH30N.Services;

namespace VPN_CLI;

public static partial class CommandHandlers
{
    private static readonly HttpClient _httpClient = new();

    public static async Task HandleCurrentStatus()
    {
        try
        {
            // Initialize VPN service
            await VPNService.Initialize();
            
            // Get current location
            var location = await VPNService.GetCurrentLocation();
            var homeIP = await NetworkAddress.MyIP(_httpClient);
            
            if (Program._jsonOutput)
            {
                var statusJson = new
                {
                    current_ip = location?.ip ?? "Unknown",
                    home_ip = homeIP,
                    is_vpn_active = location?.ip != homeIP && !string.IsNullOrEmpty(location?.ip),
                    location = location?.location != null ? new
                    {
                        city = location.location.city,
                        state = location.location.state_prov,
                        country = location.location.country_name,
                        country_code = location.location.country_code2,
                        continent = location.location.continent_name,
                        latitude = location.location.latitude,
                        longitude = location.location.longitude
                    } : null,
                    compliance = location != null ? VPNService.IsLocationCompliant(location) : false,
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(statusJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                var table = new ConsoleTable("Property", "Value");
                table.AddRow("Current IP", location?.ip ?? "Unknown");
                table.AddRow("Home IP", homeIP);
                table.AddRow("VPN Active", location?.ip != homeIP && !string.IsNullOrEmpty(location?.ip) ? "✓ Yes" : "✗ No");
                
                if (location?.location != null)
                {
                    table.AddRow("City", location.location.city ?? "Unknown");
                    table.AddRow("State/Province", location.location.state_prov ?? "Unknown");
                    table.AddRow("Country", location.location.country_name ?? "Unknown");
                    table.AddRow("Country Code", location.location.country_code2 ?? "Unknown");
                    table.AddRow("Continent", location.location.continent_name ?? "Unknown");
                    if (!string.IsNullOrEmpty(location.location.latitude) && !string.IsNullOrEmpty(location.location.longitude))
                    {
                        table.AddRow("Coordinates", $"{location.location.latitude}, {location.location.longitude}");
                    }
                }
                
                bool isCompliant = location != null && VPNService.IsLocationCompliant(location);
                table.AddRow("Compliance", isCompliant ? "✓ Compliant" : "✗ Non-Compliant");
                table.AddRow("Timestamp", DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss UTC"));
                
                Console.WriteLine(table.ToString());
                
                if (Program._verboseOutput && location?.location != null)
                {
                    Console.WriteLine();
                    Console.WriteLine("Additional Location Details:");
                    if (!string.IsNullOrEmpty(location.location.zipcode))
                        Console.WriteLine($"  ZIP/Postal Code: {location.location.zipcode}");
                    if (!string.IsNullOrEmpty(location.location.district))
                        Console.WriteLine($"  District: {location.location.district}");
                    if (location.location.is_eu.HasValue)
                        Console.WriteLine($"  EU Member: {(location.location.is_eu.Value ? "Yes" : "No")}");
                    if (!string.IsNullOrEmpty(location.location.country_emoji))
                        Console.WriteLine($"  Flag: {location.location.country_emoji}");
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
                Console.WriteLine($"Error: {ex.Message}");
                if (Program._verboseOutput)
                    Console.WriteLine($"Details: {ex.StackTrace}");
            }
        }
    }

    public static async Task HandleComplianceCheck()
    {
        try
        {
            await VPNService.Initialize();
            var location = await VPNService.GetCurrentLocation();
            bool isCompliant = location != null && VPNService.IsLocationCompliant(location);
            
            if (Program._jsonOutput)
            {
                var complianceJson = new
                {
                    compliant = isCompliant,
                    location = location?.location?.state_prov,
                    country = location?.location?.country_name,
                    ip = location?.ip,
                    forbidden_regions = new[] { "Nevada", "California" }, // From VPNService
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(complianceJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine("🔍 Compliance Check Results");
                Console.WriteLine("────────────────────────────");
                Console.WriteLine($"Status: {(isCompliant ? "✓ COMPLIANT" : "✗ NON-COMPLIANT")}");
                
                if (location?.location != null)
                {
                    Console.WriteLine($"Current Location: {location.location.city}, {location.location.state_prov}");
                    Console.WriteLine($"Country: {location.location.country_name}");
                }
                
                Console.WriteLine($"IP Address: {location?.ip ?? "Unknown"}");
                Console.WriteLine();
                Console.WriteLine("Forbidden Regions:");
                Console.WriteLine("  • Nevada");
                Console.WriteLine("  • California");
                
                if (!isCompliant)
                {
                    Console.WriteLine();
                    Console.WriteLine("⚠️  To resolve compliance issues:");
                    Console.WriteLine("   1. Use 'vpn control change-location' to switch servers");
                    Console.WriteLine("   2. Or use 'vpn control connect' for automatic compliance");
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
                Console.WriteLine($"Error checking compliance: {ex.Message}");
            }
        }
    }

    public static async Task HandleProcessStatus()
    {
        try
        {
            var status = await CyberGhostDirectControl.GetDetailedStatus();
            
            if (Program._jsonOutput)
            {
                var processJson = new
                {
                    success = status.Success,
                    service_running = status.ServiceRunning,
                    service_status = status.ServiceStatus.ToString(),
                    processes_running = status.ProcessesRunning,
                    process_count = status.ProcessCount,
                    connection_status = status.ConnectionStatus != null ? new
                    {
                        connected = status.ConnectionStatus.Connected,
                        server_name = status.ConnectionStatus.ServerName,
                        duration_minutes = status.ConnectionStatus.Duration?.TotalMinutes,
                        protocol = status.ConnectionStatus.Protocol,
                        bytes_received = status.ConnectionStatus.BytesReceived,
                        bytes_sent = status.ConnectionStatus.BytesSent
                    } : null,
                    current_server = status.CurrentServer != null ? new
                    {
                        country = status.CurrentServer.Country,
                        city = status.CurrentServer.City,
                        load = status.CurrentServer.Load,
                        ping = status.CurrentServer.Ping
                    } : null,
                    is_compliant = status.IsCompliant,
                    error = status.Error,
                    timestamp = status.Timestamp
                };
                
                Console.WriteLine(JsonSerializer.Serialize(processJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine("🔧 CyberGhost System Status");
                Console.WriteLine("──────────────────────────────");
                
                if (status.Success)
                {
                    Console.WriteLine($"Service Status: {(status.ServiceRunning ? "✓ RUNNING" : "✗ STOPPED")} ({status.ServiceStatus})");
                    Console.WriteLine($"Processes: {(status.ProcessesRunning ? "✓ ACTIVE" : "✗ INACTIVE")} ({status.ProcessCount} total)");
                    
                    if (status.ConnectionStatus != null)
                    {
                        Console.WriteLine();
                        Console.WriteLine("Connection Details:");
                        Console.WriteLine($"  Status: {(status.ConnectionStatus.Connected ? "✓ CONNECTED" : "✗ DISCONNECTED")}");
                        
                        if (status.ConnectionStatus.Connected)
                        {
                            Console.WriteLine($"  Server: {status.ConnectionStatus.ServerName}");
                            if (status.ConnectionStatus.Duration.HasValue)
                            {
                                Console.WriteLine($"  Duration: {status.ConnectionStatus.Duration.Value:hh\\:mm\\:ss}");
                            }
                            if (!string.IsNullOrEmpty(status.ConnectionStatus.Protocol))
                            {
                                Console.WriteLine($"  Protocol: {status.ConnectionStatus.Protocol}");
                            }
                            
                            if (status.ConnectionStatus.BytesReceived > 0 || status.ConnectionStatus.BytesSent > 0)
                            {
                                Console.WriteLine($"  Data: ↓{FormatBytes(status.ConnectionStatus.BytesReceived)} ↑{FormatBytes(status.ConnectionStatus.BytesSent)}");
                            }
                        }
                    }
                    
                    if (status.CurrentServer != null)
                    {
                        Console.WriteLine();
                        Console.WriteLine("Server Information:");
                        Console.WriteLine($"  Location: {status.CurrentServer.Country} - {status.CurrentServer.City}");
                        Console.WriteLine($"  Load: {status.CurrentServer.Load}%");
                        Console.WriteLine($"  Ping: {status.CurrentServer.Ping}ms");
                    }
                    
                    Console.WriteLine();
                    Console.WriteLine($"Compliance: {(status.IsCompliant ? "✓ Compliant" : "✗ Non-Compliant")}");
                }
                else
                {
                    Console.WriteLine($"Status: ❌ ERROR");
                    Console.WriteLine($"Error: {status.Error}");
                }
                
                Console.WriteLine($"Last Updated: {status.Timestamp:yyyy-MM-dd HH:mm:ss UTC}");
                
                if (!status.ServiceRunning || !status.ProcessesRunning)
                {
                    Console.WriteLine();
                    Console.WriteLine("💡 To start CyberGhost:");
                    Console.WriteLine("   Use 'vpn control connect' to launch and connect");
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
                Console.WriteLine($"Error checking system status: {ex.Message}");
            }
        }
    }
    
    private static string FormatBytes(long bytes)
    {
        if (bytes < 1024) return $"{bytes} B";
        if (bytes < 1024 * 1024) return $"{bytes / 1024.0:F1} KB";
        if (bytes < 1024 * 1024 * 1024) return $"{bytes / (1024.0 * 1024.0):F1} MB";
        return $"{bytes / (1024.0 * 1024.0 * 1024.0):F1} GB";
    }

    public static async Task HandleConnect()
    {
        try
        {
            if (!Program._jsonOutput)
            {
                Console.WriteLine("🚀 Establishing VPN Connection (Direct Control)...");
                Console.WriteLine("Using CyberGhost service injection for reliable connection.");
                Console.WriteLine();
            }
            
            var result = await CyberGhostDirectControl.ConnectDirect();
            
            if (Program._jsonOutput)
            {
                var resultJson = new
                {
                    success = result.Success,
                    message = result.Message,
                    operation = result.Operation,
                    duration_seconds = result.Duration.TotalSeconds,
                    new_ip = result.NewIP,
                    connected_server = result.ConnectedServer != null ? new
                    {
                        country = result.ConnectedServer.Country,
                        city = result.ConnectedServer.City,
                        load = result.ConnectedServer.Load
                    } : null,
                    error = result.Error,
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(resultJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                if (result.Success)
                {
                    Console.WriteLine("✅ VPN Connection Successful!");
                    Console.WriteLine($"⚡ Method: {result.Message}");
                    Console.WriteLine($"⏱️ Duration: {result.Duration.TotalSeconds:F1} seconds");
                    
                    if (result.ConnectedServer != null)
                    {
                        Console.WriteLine($"📍 Server: {result.ConnectedServer.Country} - {result.ConnectedServer.City}");
                        Console.WriteLine($"📊 Load: {result.ConnectedServer.Load}%");
                    }
                    
                    if (!string.IsNullOrEmpty(result.NewIP))
                    {
                        Console.WriteLine($"🌐 New IP: {result.NewIP}");
                    }
                    
                    // Verify compliance
                    var status = await CyberGhostDirectControl.GetDetailedStatus();
                    if (status.Success)
                    {
                        Console.WriteLine($"✓ Compliance: {(status.IsCompliant ? "Compliant" : "Non-Compliant")}");
                    }
                }
                else
                {
                    Console.WriteLine("❌ VPN Connection Failed");
                    Console.WriteLine($"Error: {result.Error}");
                    Console.WriteLine();
                    Console.WriteLine("Troubleshooting steps:");
                    Console.WriteLine("1. Ensure CyberGhost service is running");
                    Console.WriteLine("2. Check administrative privileges");
                    Console.WriteLine("3. Verify CyberGhost installation");
                    Console.WriteLine("4. Run with --verbose for detailed logs");
                }
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { success = false, error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"❌ Connection failed: {ex.Message}");
                if (Program._verboseOutput)
                    Console.WriteLine($"Details: {ex.StackTrace}");
            }
        }
    }

    public static async Task HandleDisconnect()
    {
        try
        {
            if (!Program._jsonOutput)
                Console.WriteLine("🔌 Disconnecting VPN (Direct Control)...");
            
            var result = await CyberGhostDirectControl.DisconnectDirect();
            
            if (Program._jsonOutput)
            {
                var resultJson = new
                {
                    success = result.Success,
                    message = result.Message,
                    operation = result.Operation,
                    duration_seconds = result.Duration.TotalSeconds,
                    error = result.Error,
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(resultJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                if (result.Success)
                {
                    Console.WriteLine("✅ VPN Disconnected Successfully!");
                    Console.WriteLine($"⚡ Method: {result.Message}");
                    Console.WriteLine($"⏱️ Duration: {result.Duration.TotalSeconds:F1} seconds");
                }
                else
                {
                    Console.WriteLine("❌ Disconnect Failed");
                    Console.WriteLine($"Error: {result.Error}");
                    Console.WriteLine("The VPN may still be connected. Check status with 'vpn status current'");
                }
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { success = false, error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"❌ Disconnect failed: {ex.Message}");
            }
        }
    }

    public static async Task HandleReset()
    {
        try
        {
            if (!Program._jsonOutput)
                Console.WriteLine("🔄 Resetting VPN Connection...");
            
            await VPNService.ResetConnection();
            
            if (Program._jsonOutput)
            {
                var resultJson = new
                {
                    success = true,
                    message = "VPN connection reset completed",
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(resultJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine("✅ VPN Connection Reset Complete");
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { success = false, error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"❌ Reset failed: {ex.Message}");
            }
        }
    }

    public static async Task HandleChangeLocation()
    {
        try
        {
            if (!Program._jsonOutput)
                Console.WriteLine("🌍 Changing VPN Location (Direct Control)...");
            
            var result = await CyberGhostDirectControl.ChangeServerDirect();
            
            if (Program._jsonOutput)
            {
                var resultJson = new
                {
                    success = result.Success,
                    message = result.Message,
                    operation = result.Operation,
                    duration_seconds = result.Duration.TotalSeconds,
                    new_server = result.ConnectedServer != null ? new
                    {
                        country = result.ConnectedServer.Country,
                        city = result.ConnectedServer.City,
                        load = result.ConnectedServer.Load,
                        ping = result.ConnectedServer.Ping
                    } : null,
                    new_ip = result.NewIP,
                    error = result.Error,
                    timestamp = DateTime.UtcNow
                };
                
                Console.WriteLine(JsonSerializer.Serialize(resultJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                if (result.Success)
                {
                    Console.WriteLine("✅ Location Changed Successfully!");
                    Console.WriteLine($"⚡ Method: {result.Message}");
                    Console.WriteLine($"⏱️ Duration: {result.Duration.TotalSeconds:F1} seconds");
                    
                    if (result.ConnectedServer != null)
                    {
                        Console.WriteLine($"📍 New Server: {result.ConnectedServer.Country} - {result.ConnectedServer.City}");
                        Console.WriteLine($"📊 Load: {result.ConnectedServer.Load}%");
                        Console.WriteLine($"⚡ Ping: {result.ConnectedServer.Ping}ms");
                    }
                    
                    if (!string.IsNullOrEmpty(result.NewIP))
                    {
                        Console.WriteLine($"🌐 New IP: {result.NewIP}");
                    }
                    
                    // Verify compliance
                    var status = await CyberGhostDirectControl.GetDetailedStatus();
                    if (status.Success && result.ConnectedServer != null)
                    {
                        Console.WriteLine($"✓ Compliance: {(status.IsCompliant ? "Compliant" : "Non-Compliant")}");
                    }
                }
                else
                {
                    Console.WriteLine("❌ Location Change Failed");
                    Console.WriteLine($"Error: {result.Error}");
                    Console.WriteLine();
                    Console.WriteLine("Try:");
                    Console.WriteLine("1. Check current connection status");
                    Console.WriteLine("2. Disconnect and reconnect");
                    Console.WriteLine("3. Use 'vpn status current' to verify state");
                }
            }
        }
        catch (Exception ex)
        {
            if (Program._jsonOutput)
            {
                var errorJson = new { success = false, error = ex.Message, timestamp = DateTime.UtcNow };
                Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"❌ Location change failed: {ex.Message}");
            }
        }
    }
    
    public static async Task HandleTestInjection()
    {
        try
        {
            if (!Program._jsonOutput)
            {
                Console.WriteLine("🧪 Testing VPN Injection Methods");
                Console.WriteLine("═══════════════════════════════════");
                Console.WriteLine();
            }
            
            // Step 1: Complete VPN shutdown to get true home IP
            Console.WriteLine("Phase 1: Complete VPN Shutdown");
            var shutdownResult = await VPNTerminationService.CompleteVpnShutdown();
            
            if (Program._jsonOutput)
            {
                var shutdownJson = new
                {
                    phase = "shutdown",
                    success = shutdownResult.Success,
                    message = shutdownResult.Message,
                    processes_killed = shutdownResult.ProcessesKilled,
                    services_stopped = shutdownResult.ServicesStopped,
                    true_home_ip = shutdownResult.TrueHomeIP,
                    current_ip = shutdownResult.CurrentIP,
                    completely_disconnected = shutdownResult.IsCompletelyDisconnected,
                    duration_seconds = shutdownResult.Duration.TotalSeconds,
                    error = shutdownResult.Error
                };
                Console.WriteLine(JsonSerializer.Serialize(shutdownJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"   Result: {(shutdownResult.Success ? "✅ SUCCESS" : "❌ FAILED")}");
                Console.WriteLine($"   Processes killed: {shutdownResult.ProcessesKilled}");
                Console.WriteLine($"   Services stopped: {shutdownResult.ServicesStopped}");
                Console.WriteLine($"   True Home IP: {shutdownResult.TrueHomeIP}");
                Console.WriteLine($"   Current IP: {shutdownResult.CurrentIP}");
                Console.WriteLine($"   Completely disconnected: {(shutdownResult.IsCompletelyDisconnected ? "✅ YES" : "❌ NO")}");
                Console.WriteLine($"   Duration: {shutdownResult.Duration.TotalSeconds:F1} seconds");
                if (!string.IsNullOrEmpty(shutdownResult.Error))
                    Console.WriteLine($"   Error: {shutdownResult.Error}");
            }
            
            if (!shutdownResult.Success)
            {
                if (!Program._jsonOutput)
                    Console.WriteLine("\n❌ Cannot continue with injection testing - VPN shutdown failed");
                return;
            }
            
            await Task.Delay(2000);
            
            // Step 2: Restart CyberGhost for injection testing
            if (!Program._jsonOutput)
            {
                Console.WriteLine("\nPhase 2: Restart CyberGhost for Injection Testing");
            }
            
            var startResult = await VPNTerminationService.StartCyberGhostForTesting();
            if (!Program._jsonOutput)
            {
                Console.WriteLine($"   CyberGhost started: {(startResult ? "✅ YES" : "❌ NO")}");
            }
            
            if (!startResult)
            {
                if (!Program._jsonOutput)
                    Console.WriteLine("\n❌ Cannot test injection - CyberGhost failed to start");
                return;
            }
            
            await Task.Delay(3000);
            
            // Step 3: Test injection-based connection
            if (!Program._jsonOutput)
            {
                Console.WriteLine("\nPhase 3: Test Injection-Based Connection");
            }
            
            var connectResult = await CyberGhostDirectControl.ConnectDirect();
            
            if (Program._jsonOutput)
            {
                var connectJson = new
                {
                    phase = "injection_connect",
                    success = connectResult.Success,
                    message = connectResult.Message,
                    operation = connectResult.Operation,
                    duration_seconds = connectResult.Duration.TotalSeconds,
                    new_ip = connectResult.NewIP,
                    connected_server = connectResult.ConnectedServer != null ? new
                    {
                        country = connectResult.ConnectedServer.Country,
                        city = connectResult.ConnectedServer.City,
                        load = connectResult.ConnectedServer.Load
                    } : null,
                    error = connectResult.Error
                };
                Console.WriteLine(JsonSerializer.Serialize(connectJson, new JsonSerializerOptions { WriteIndented = true }));
            }
            else
            {
                Console.WriteLine($"   Result: {(connectResult.Success ? "✅ SUCCESS" : "❌ FAILED")}");
                Console.WriteLine($"   Method: {connectResult.Message}");
                Console.WriteLine($"   Duration: {connectResult.Duration.TotalSeconds:F1} seconds");
                if (connectResult.ConnectedServer != null)
                {
                    Console.WriteLine($"   Server: {connectResult.ConnectedServer.Country} - {connectResult.ConnectedServer.City}");
                }
                if (!string.IsNullOrEmpty(connectResult.NewIP))
                {
                    Console.WriteLine($"   New IP: {connectResult.NewIP}");
                }
                if (!string.IsNullOrEmpty(connectResult.Error))
                    Console.WriteLine($"   Error: {connectResult.Error}");
            }
            
            // Step 4: Verify IP change
            if (connectResult.Success)
            {
                if (!Program._jsonOutput)
                {
                    Console.WriteLine("\nPhase 4: Verify IP Change");
                }
                
                await Task.Delay(3000);
                using var client = new HttpClient();
                try
                {
                    var newCurrentIP = (await client.GetStringAsync("https://api.ipify.org/")).Trim();
                    var ipChanged = newCurrentIP != shutdownResult.TrueHomeIP;
                    
                    if (!Program._jsonOutput)
                    {
                        Console.WriteLine($"   Current IP: {newCurrentIP}");
                        Console.WriteLine($"   Home IP: {shutdownResult.TrueHomeIP}");
                        Console.WriteLine($"   IP Changed: {(ipChanged ? "✅ YES" : "❌ NO")}");
                        
                        if (ipChanged)
                        {
                            Console.WriteLine("\n🎉 INJECTION TEST SUCCESSFUL!");
                            Console.WriteLine("   The VPN injection methods are working properly.");
                        }
                        else
                        {
                            Console.WriteLine("\n⚠️  IP did not change - injection may need refinement.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    if (!Program._jsonOutput)
                        Console.WriteLine($"   IP verification error: {ex.Message}");
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
                Console.WriteLine($"❌ Test failed: {ex.Message}");
                if (Program._verboseOutput)
                    Console.WriteLine($"Details: {ex.StackTrace}");
            }
        }
    }
}
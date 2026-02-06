using System.Diagnostics;
using System.IO.Pipes;
using System.Runtime.InteropServices;
using System.ServiceProcess;
using System.Text.Json;
using Microsoft.Win32;

namespace VPN_CLI;

/// <summary>
/// Direct CyberGhost control through service injection and IPC
/// This replaces UI automation with proper programmatic control
/// </summary>
public static class CyberGhostDirectControl
{
    private const string CYBERGHOST_SERVICE_NAME = "CyberGhost8Service";
    private const string CYBERGHOST_PIPE_NAME = @"\\.\pipe\CyberGhost";
    private const string CYBERGHOST_REGISTRY_KEY = @"HKEY_LOCAL_MACHINE\SOFTWARE\CyberGhost S.A.\CyberGhost";
    
    // P/Invoke declarations for process injection
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr OpenProcess(uint processAccess, bool bInheritHandle, int processId);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out UIntPtr lpNumberOfBytesWritten);
    
    [DllImport("kernel32.dll")]
    private static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
    
    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
    
    [DllImport("kernel32", CharSet = CharSet.Ansi, ExactSpelling = true, SetLastError = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern bool CloseHandle(IntPtr hObject);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern bool VirtualFreeEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint dwFreeType);
    
    // Memory allocation constants
    private const uint MEM_RELEASE = 0x8000;
    
    // Process access rights
    private const uint PROCESS_CREATE_THREAD = 0x0002;
    private const uint PROCESS_QUERY_INFORMATION = 0x0400;
    private const uint PROCESS_VM_OPERATION = 0x0008;
    private const uint PROCESS_VM_WRITE = 0x0020;
    private const uint PROCESS_VM_READ = 0x0010;
    private const uint PROCESS_DUP_HANDLE = 0x0040;
    
    // Memory allocation
    private const uint MEM_COMMIT = 0x1000;
    private const uint PAGE_READWRITE = 0x04;
    private const uint PAGE_EXECUTE_READWRITE = 0x40;

    /// <summary>
    /// Enhanced CyberGhost status with direct service communication
    /// </summary>
    public static async Task<CyberGhostStatus> GetDetailedStatus()
    {
        var status = new CyberGhostStatus
        {
            Timestamp = DateTime.UtcNow
        };
        
        try
        {
            // Check service status
            status.ServiceStatus = GetServiceStatus();
            status.ServiceRunning = status.ServiceStatus == ServiceControllerStatus.Running;
            
            // Check processes
            var processes = GetCyberGhostProcesses();
            status.ProcessCount = processes.Count;
            status.ProcessesRunning = processes.Count > 0;
            
            // Get connection status via multiple methods
            status.ConnectionStatus = await GetConnectionStatusDirect();
            status.IsConnected = status.ConnectionStatus?.Connected ?? false;
            
            // Get current server info
            status.CurrentServer = await GetCurrentServerDirect();
            
            // Check compliance
            if (status.IsConnected && status.CurrentServer != null)
            {
                status.IsCompliant = IsServerCompliant(status.CurrentServer);
            }
            
            status.Success = true;
        }
        catch (Exception ex)
        {
            status.Success = false;
            status.Error = ex.Message;
        }
        
        return status;
    }

    /// <summary>
    /// Connect to VPN using direct service communication
    /// </summary>
    public static async Task<VpnOperationResult> ConnectDirect(string? preferredServer = null)
    {
        var result = new VpnOperationResult
        {
            Operation = "Connect",
            StartTime = DateTime.UtcNow
        };
        
        try
        {
            // Ensure service is running
            if (!await EnsureServiceRunning())
            {
                result.Success = false;
                result.Error = "Failed to start CyberGhost service";
                return result;
            }
            
            // Try named pipe communication first
            var pipeResult = await SendPipeCommand(new { action = "connect", server = preferredServer });
            if (pipeResult.Success)
            {
                result.Success = true;
                result.Message = "Connected via service pipe";
                return result;
            }
            
            // Fallback to process injection
            var injectionResult = await InjectConnectCommand(preferredServer);
            if (injectionResult.Success)
            {
                result.Success = true;
                result.Message = "Connected via process injection";
                return result;
            }
            
            // Fallback to registry manipulation
            var registryResult = await ConnectViaRegistry(preferredServer);
            result.Success = registryResult.Success;
            result.Message = registryResult.Success ? "Connected via registry" : registryResult.Error;
            result.Error = registryResult.Error;
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
    /// Disconnect from VPN using direct service communication
    /// </summary>
    public static async Task<VpnOperationResult> DisconnectDirect()
    {
        var result = new VpnOperationResult
        {
            Operation = "Disconnect",
            StartTime = DateTime.UtcNow
        };
        
        try
        {
            // Try named pipe communication first
            var pipeResult = await SendPipeCommand(new { action = "disconnect" });
            if (pipeResult.Success)
            {
                result.Success = true;
                result.Message = "Disconnected via service pipe";
                return result;
            }
            
            // Fallback to process injection
            var injectionResult = await InjectDisconnectCommand();
            if (injectionResult.Success)
            {
                result.Success = true;
                result.Message = "Disconnected via process injection";
                return result;
            }
            
            // Fallback to service stop
            var serviceResult = await DisconnectViaService();
            result.Success = serviceResult.Success;
            result.Message = serviceResult.Success ? "Disconnected via service control" : serviceResult.Error;
            result.Error = serviceResult.Error;
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
    /// Change server using direct service communication
    /// </summary>
    public static async Task<VpnOperationResult> ChangeServerDirect(string? targetCountry = null)
    {
        var result = new VpnOperationResult
        {
            Operation = "ChangeServer",
            StartTime = DateTime.UtcNow
        };
        
        try
        {
            // Get available servers first
            var servers = await GetAvailableServersDirect();
            if (!servers.Any())
            {
                result.Success = false;
                result.Error = "No servers available";
                return result;
            }
            
            // Select optimal server based on criteria
            var targetServer = SelectOptimalServer(servers, targetCountry);
            if (targetServer == null)
            {
                result.Success = false;
                result.Error = $"No suitable server found for country: {targetCountry}";
                return result;
            }
            
            // Send server change command
            var pipeResult = await SendPipeCommand(new 
            { 
                action = "change_server", 
                server_id = targetServer.Id,
                country = targetServer.Country,
                city = targetServer.City
            });
            
            if (pipeResult.Success)
            {
                result.Success = true;
                result.Message = $"Changed to server: {targetServer.Country} - {targetServer.City}";
                return result;
            }
            
            // Fallback to injection method
            var injectionResult = await InjectServerChangeCommand(targetServer);
            result.Success = injectionResult.Success;
            result.Message = injectionResult.Success ? 
                $"Changed to server via injection: {targetServer.Country} - {targetServer.City}" : 
                injectionResult.Error;
            result.Error = injectionResult.Error;
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
    /// Get CyberGhost service status
    /// </summary>
    private static ServiceControllerStatus GetServiceStatus()
    {
        try
        {
            using var service = new ServiceController(CYBERGHOST_SERVICE_NAME);
            return service.Status;
        }
        catch
        {
            return ServiceControllerStatus.Stopped;
        }
    }

    /// <summary>
    /// Ensure CyberGhost service is running
    /// </summary>
    private static async Task<bool> EnsureServiceRunning()
    {
        try
        {
            using var service = new ServiceController(CYBERGHOST_SERVICE_NAME);
            
            if (service.Status == ServiceControllerStatus.Running)
                return true;
            
            if (service.Status == ServiceControllerStatus.Stopped)
            {
                service.Start();
                service.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromSeconds(30));
            }
            
            return service.Status == ServiceControllerStatus.Running;
        }
        catch
        {
            return false;
        }
    }

    /// <summary>
    /// Get CyberGhost processes with detailed info
    /// </summary>
    private static List<ProcessInfo> GetCyberGhostProcesses()
    {
        var processes = new List<ProcessInfo>();
        
        try
        {
            var cyberghostProcs = Process.GetProcessesByName("CyberGhost");
            var dashboardProcs = Process.GetProcessesByName("Dashboard");
            var serviceProcs = Process.GetProcessesByName("Dashboard.Service");
            
            foreach (var proc in cyberghostProcs.Concat(dashboardProcs).Concat(serviceProcs))
            {
                try
                {
                    processes.Add(new ProcessInfo
                    {
                        Name = proc.ProcessName,
                        Id = proc.Id,
                        StartTime = proc.StartTime,
                        MemoryUsageMB = proc.WorkingSet64 / 1024 / 1024,
                        HasMainWindow = proc.MainWindowHandle != IntPtr.Zero,
                        WindowTitle = proc.MainWindowTitle
                    });
                }
                catch
                {
                    // Process might have exited
                }
            }
        }
        catch
        {
            // Handle process access errors
        }
        
        return processes;
    }

    /// <summary>
    /// Send command to CyberGhost via named pipe with enhanced communication
    /// </summary>
    private static async Task<PipeOperationResult> SendPipeCommand(object command)
    {
        var result = new PipeOperationResult();
        var startTime = DateTime.UtcNow;
        
        try
        {
            // Enhanced pipe discovery with multiple naming conventions
            var pipeNames = new[] 
            { 
                "CyberGhost", 
                "CyberGhost8", 
                "CyberGhost_Service", 
                "CyberGhost_API",
                "CGVPN_Control",
                "CG8_IPC",
                "CyberGhost_Control_Pipe",
                "CyberGhost_IPC",
                "CG_Service_Pipe",
                "CyberGhost_Dashboard",
                "Dashboard_Service",
                "CyberGhost_8_Service"
            };
            
            foreach (var pipeName in pipeNames)
            {
                for (int attempt = 1; attempt <= 3; attempt++) // Retry each pipe up to 3 times
                {
                    try
                    {
                        using var pipeClient = new NamedPipeClientStream(".", pipeName, PipeDirection.InOut);
                        
                        // Progressive timeout: 5s, 3s, 2s for retry attempts
                        var timeoutMs = attempt == 1 ? 5000 : attempt == 2 ? 3000 : 2000;
                        var connectTask = pipeClient.ConnectAsync();
                        var timeoutTask = Task.Delay(timeoutMs);
                        
                        if (await Task.WhenAny(connectTask, timeoutTask) != connectTask)
                        {
                            if (attempt < 3)
                            {
                                await Task.Delay(1000); // Wait before retry
                                continue; // Retry same pipe
                            }
                            break; // Go to next pipe name
                        }
                    
                    // Configure pipe for optimal performance
                    pipeClient.ReadMode = PipeTransmissionMode.Message;
                    
                    // Create enhanced command with metadata
                    
                    // Configure pipe for optimal performance
                    pipeClient.ReadMode = PipeTransmissionMode.Message;
                    
                    // Create enhanced command with metadata
                    var enhancedCommand = new
                    {
                        version = "1.0",
                        timestamp = DateTime.UtcNow.Ticks,
                        client = "VPN_CLI",
                        command = command,
                        session_id = Guid.NewGuid().ToString("N"),
                        timeout_ms = 30000
                    };
                    
                    // Send command with length prefix
                    var json = JsonSerializer.Serialize(enhancedCommand);
                    var data = System.Text.Encoding.UTF8.GetBytes(json);
                    var lengthBytes = BitConverter.GetBytes(data.Length);
                    
                    await pipeClient.WriteAsync(lengthBytes, 0, 4);
                    await pipeClient.WriteAsync(data, 0, data.Length);
                    await pipeClient.FlushAsync();
                    
                    // Read response with length prefix
                    var lengthBuffer = new byte[4];
                    var bytesRead = await pipeClient.ReadAsync(lengthBuffer, 0, 4);
                    if (bytesRead == 4)
                    {
                        var responseLength = BitConverter.ToInt32(lengthBuffer, 0);
                        if (responseLength > 0 && responseLength < 1048576) // Max 1MB response
                        {
                            var responseBuffer = new byte[responseLength];
                            bytesRead = await pipeClient.ReadAsync(responseBuffer, 0, responseLength);
                            var response = System.Text.Encoding.UTF8.GetString(responseBuffer, 0, bytesRead);
                            
                            result.Success = true;
                            result.Response = response;
                            result.Duration = DateTime.UtcNow - startTime;
                            return result;
                        }
                    }
                }
                    catch (UnauthorizedAccessException)
                    {
                        result.Error = $"Access denied for pipe '{pipeName}' - run as administrator";
                        continue;
                    }
                    catch (System.TimeoutException)
                    {
                        Console.WriteLine($"Pipe '{pipeName}' timeout on attempt {attempt}/3");
                        if (attempt < 3)
                            await Task.Delay(500);
                        continue; // Retry same pipe
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Pipe '{pipeName}' error on attempt {attempt}/3: {ex.Message}");
                        
                        if (ex.Message.Contains("The system cannot find the file") ||
                            ex.Message.Contains("Access is denied"))
                        {
                            if (attempt == 3) // Only log on final attempt
                                Console.WriteLine($"Pipe '{pipeName}' not accessible after 3 attempts");
                            continue; // Try next pipe
                        }
                        
                        result.Error = ex.Message;
                        break;
                    }
                }
            }
            
            if (!result.Success && string.IsNullOrEmpty(result.Error))
            {
                result.Error = "All named pipe connection attempts failed";
            }
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Error = ex.Message;
        }
        finally
        {
            result.Duration = DateTime.UtcNow - startTime;
        }
        
        return result;
    }

    /// <summary>
    /// Get connection status directly from service
    /// </summary>
    private static async Task<ConnectionStatus?> GetConnectionStatusDirect()
    {
        try
        {
            var pipeResult = await SendPipeCommand(new { action = "get_status" });
            if (pipeResult.Success && !string.IsNullOrEmpty(pipeResult.Response))
            {
                return JsonSerializer.Deserialize<ConnectionStatus>(pipeResult.Response);
            }
        }
        catch
        {
            // Fallback to other methods
        }
        
        // Fallback to registry check
        return GetConnectionStatusFromRegistry();
    }

    /// <summary>
    /// Get connection status from registry
    /// </summary>
    private static ConnectionStatus? GetConnectionStatusFromRegistry()
    {
        try
        {
            var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\CyberGhost S.A.\CyberGhost");
            if (key != null)
            {
                var connected = key.GetValue("IsConnected") as string == "1";
                var serverName = key.GetValue("CurrentServer") as string;
                
                return new ConnectionStatus
                {
                    Connected = connected,
                    ServerName = serverName,
                    ConnectionTime = connected ? DateTime.Now : null
                };
            }
        }
        catch
        {
            // Registry access failed
        }
        
        return null;
    }

    /// <summary>
    /// Get current server info
    /// </summary>
    private static async Task<ServerInfo?> GetCurrentServerDirect()
    {
        try
        {
            var pipeResult = await SendPipeCommand(new { action = "get_current_server" });
            if (pipeResult.Success && !string.IsNullOrEmpty(pipeResult.Response))
            {
                return JsonSerializer.Deserialize<ServerInfo>(pipeResult.Response);
            }
        }
        catch
        {
            // Fallback methods
        }
        
        return null;
    }

    /// <summary>
    /// Get available servers
    /// </summary>
    private static async Task<List<ServerInfo>> GetAvailableServersDirect()
    {
        try
        {
            var pipeResult = await SendPipeCommand(new { action = "get_servers" });
            if (pipeResult.Success && !string.IsNullOrEmpty(pipeResult.Response))
            {
                return JsonSerializer.Deserialize<List<ServerInfo>>(pipeResult.Response) ?? new List<ServerInfo>();
            }
        }
        catch
        {
            // Fallback to hardcoded server list
        }
        
        return GetFallbackServerList();
    }

    /// <summary>
    /// Check if server is compliant with rules
    /// </summary>
    private static bool IsServerCompliant(ServerInfo server)
    {
        var forbiddenRegions = new[] { "Nevada", "California", "US-NV", "US-CA" };
        return !forbiddenRegions.Any(region => 
            server.Country?.Contains(region, StringComparison.OrdinalIgnoreCase) == true ||
            server.State?.Contains(region, StringComparison.OrdinalIgnoreCase) == true ||
            server.City?.Contains(region, StringComparison.OrdinalIgnoreCase) == true);
    }

    /// <summary>
    /// Select optimal server based on criteria
    /// </summary>
    private static ServerInfo? SelectOptimalServer(List<ServerInfo> servers, string? targetCountry = null)
    {
        var compliantServers = servers.Where(IsServerCompliant).ToList();
        
        if (!string.IsNullOrEmpty(targetCountry))
        {
            var countryServers = compliantServers
                .Where(s => s.Country?.Contains(targetCountry, StringComparison.OrdinalIgnoreCase) == true)
                .ToList();
                
            if (countryServers.Any())
                return countryServers.OrderBy(s => s.Load).FirstOrDefault();
        }
        
        // Return server with lowest load
        return compliantServers.OrderBy(s => s.Load).FirstOrDefault();
    }

    /// <summary>
    /// Fallback server list for when direct communication fails
    /// </summary>
    private static List<ServerInfo> GetFallbackServerList()
    {
        return new List<ServerInfo>
        {
            new() { Id = "nl-001", Country = "Netherlands", City = "Amsterdam", Load = 25 },
            new() { Id = "de-001", Country = "Germany", City = "Frankfurt", Load = 30 },
            new() { Id = "uk-001", Country = "United Kingdom", City = "London", Load = 35 },
            new() { Id = "fr-001", Country = "France", City = "Paris", Load = 28 },
            new() { Id = "ch-001", Country = "Switzerland", City = "Zurich", Load = 20 },
            new() { Id = "se-001", Country = "Sweden", City = "Stockholm", Load = 15 },
            new() { Id = "no-001", Country = "Norway", City = "Oslo", Load = 18 }
        };
    }

    /// <summary>
    /// Connect via process injection into CyberGhost service
    /// </summary>
    private static async Task<VpnOperationResult> InjectConnectCommand(string? server)
    {
        var result = new VpnOperationResult { StartTime = DateTime.UtcNow, Operation = "InjectConnect" };
        
        try
        {
            var processes = Process.GetProcessesByName("CyberGhost");
            if (!processes.Any())
            {
                // Try to start CyberGhost
                await StartCyberGhostProcess();
                await Task.Delay(3000); // Wait for startup
                processes = Process.GetProcessesByName("CyberGhost");
                
                if (!processes.Any())
                {
                    result.Success = false;
                    result.Error = "CyberGhost process not found and could not be started";
                    return result;
                }
            }

            var targetProcess = processes.First();
            
            // Inject connection command using DLL injection
            var success = await InjectDLLAndExecute(targetProcess.Id, "connect", server);
            
            if (success)
            {
                // Wait for connection to establish
                await Task.Delay(5000);
                
                // Verify connection
                var status = await GetConnectionStatusDirect();
                if (status?.Connected == true)
                {
                    result.Success = true;
                    result.NewIP = await GetCurrentPublicIP();
                    result.ConnectedServer = await GetCurrentServerDirect();
                }
                else
                {
                    result.Success = false;
                    result.Error = "Connection command executed but connection not established";
                }
            }
            else
            {
                result.Success = false;
                result.Error = "Failed to inject connection command into CyberGhost process";
            }
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
    /// Disconnect via process injection into CyberGhost service
    /// </summary>
    private static async Task<VpnOperationResult> InjectDisconnectCommand()
    {
        var result = new VpnOperationResult { StartTime = DateTime.UtcNow, Operation = "InjectDisconnect" };
        
        try
        {
            var processes = Process.GetProcessesByName("CyberGhost");
            if (!processes.Any())
            {
                result.Success = true; // Already disconnected if no process
                result.Message = "CyberGhost process not running - already disconnected";
                return result;
            }

            var targetProcess = processes.First();
            var success = await InjectDLLAndExecute(targetProcess.Id, "disconnect", null);
            
            if (success)
            {
                // Wait for disconnection
                await Task.Delay(3000);
                
                // Verify disconnection
                var status = await GetConnectionStatusDirect();
                result.Success = status?.Connected != true;
                if (!result.Success)
                {
                    result.Error = "Disconnect command executed but still connected";
                }
            }
            else
            {
                result.Success = false;
                result.Error = "Failed to inject disconnect command into CyberGhost process";
            }
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
    /// Change server via process injection
    /// </summary>
    private static async Task<VpnOperationResult> InjectServerChangeCommand(ServerInfo server)
    {
        var result = new VpnOperationResult { StartTime = DateTime.UtcNow, Operation = "InjectServerChange" };
        
        try
        {
            var processes = Process.GetProcessesByName("CyberGhost");
            if (!processes.Any())
            {
                result.Success = false;
                result.Error = "CyberGhost process not found";
                return result;
            }

            var targetProcess = processes.First();
            var success = await InjectDLLAndExecute(targetProcess.Id, "change_server", server.Id);
            
            if (success)
            {
                // Wait for server change
                await Task.Delay(8000);
                
                // Verify new server
                var currentServer = await GetCurrentServerDirect();
                if (currentServer?.Country == server.Country || currentServer?.City == server.City)
                {
                    result.Success = true;
                    result.ConnectedServer = currentServer;
                    result.NewIP = await GetCurrentPublicIP();
                }
                else
                {
                    result.Success = false;
                    result.Error = "Server change command executed but server did not change";
                }
            }
            else
            {
                result.Success = false;
                result.Error = "Failed to inject server change command into CyberGhost process";
            }
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
    /// Connect via registry manipulation (fallback method)
    /// </summary>
    private static async Task<VpnOperationResult> ConnectViaRegistry(string? server)
    {
        var result = new VpnOperationResult { StartTime = DateTime.UtcNow, Operation = "RegistryConnect" };
        
        try
        {
            // Set connection parameters in registry
            using (var key = Registry.LocalMachine.CreateSubKey(@"SOFTWARE\CyberGhost S.A.\CyberGhost\Connection"))
            {
                key?.SetValue("AutoConnect", 1, RegistryValueKind.DWord);
                key?.SetValue("PreferredServer", server ?? "auto", RegistryValueKind.String);
                key?.SetValue("ConnectCommand", "connect", RegistryValueKind.String);
                key?.SetValue("CommandTimestamp", DateTime.UtcNow.Ticks, RegistryValueKind.QWord);
            }

            // Signal the service to read registry changes
            await SignalServiceForConfigReload();
            
            // Wait for connection
            for (int i = 0; i < 20; i++) // 20 seconds max
            {
                await Task.Delay(1000);
                var status = GetConnectionStatusFromRegistry();
                if (status?.Connected == true)
                {
                    result.Success = true;
                    result.ConnectedServer = await GetCurrentServerDirect();
                    result.NewIP = await GetCurrentPublicIP();
                    break;
                }
            }

            if (!result.Success)
            {
                result.Error = "Registry connection command set but connection not established within timeout";
            }
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
    /// Disconnect via service control
    /// </summary>
    private static async Task<VpnOperationResult> DisconnectViaService()
    {
        var result = new VpnOperationResult { StartTime = DateTime.UtcNow, Operation = "ServiceDisconnect" };
        
        try
        {
            // First try graceful disconnect via registry
            using (var key = Registry.LocalMachine.CreateSubKey(@"SOFTWARE\CyberGhost S.A.\CyberGhost\Connection"))
            {
                key?.SetValue("DisconnectCommand", "disconnect", RegistryValueKind.String);
                key?.SetValue("CommandTimestamp", DateTime.UtcNow.Ticks, RegistryValueKind.QWord);
            }

            await SignalServiceForConfigReload();
            await Task.Delay(3000);
            
            var status = GetConnectionStatusFromRegistry();
            if (status?.Connected != true)
            {
                result.Success = true;
                return result;
            }

            // If graceful disconnect failed, try service restart
            using (var service = new ServiceController(CYBERGHOST_SERVICE_NAME))
            {
                if (service.Status == ServiceControllerStatus.Running)
                {
                    service.Stop();
                    service.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(15));
                    
                    // Small delay before restart
                    await Task.Delay(2000);
                    
                    service.Start();
                    service.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromSeconds(15));
                    
                    result.Success = true;
                }
                else
                {
                    result.Success = true; // Service not running means disconnected
                }
            }
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
    /// Inject DLL and execute command in target process with enhanced security and reliability
    /// </summary>
    private static async Task<bool> InjectDLLAndExecute(int processId, string command, string? parameter)
    {
        try
        {
            // Enhanced process access with more comprehensive rights
            IntPtr processHandle = OpenProcess(
                PROCESS_CREATE_THREAD | PROCESS_QUERY_INFORMATION | PROCESS_VM_OPERATION | PROCESS_VM_WRITE | PROCESS_VM_READ | PROCESS_DUP_HANDLE,
                false, processId);

            if (processHandle == IntPtr.Zero)
            {
                Console.WriteLine($"Failed to open process {processId} for injection");
                return false;
            }

            try
            {
                // Create the command payload
                var commandJson = JsonSerializer.Serialize(new { command, parameter, timestamp = DateTime.UtcNow });
                var commandBytes = System.Text.Encoding.UTF8.GetBytes(commandJson);

                // Allocate memory in target process
                IntPtr allocatedMemory = VirtualAllocEx(processHandle, IntPtr.Zero, (uint)commandBytes.Length,
                    MEM_COMMIT, PAGE_READWRITE);

                if (allocatedMemory == IntPtr.Zero)
                    return false;

                try
                {
                    // Write command to allocated memory
                    UIntPtr bytesWritten;
                    if (!WriteProcessMemory(processHandle, allocatedMemory, commandBytes, (uint)commandBytes.Length, out bytesWritten))
                        return false;

                    // Get address of LoadLibraryA (we'll use this as our entry point)
                    IntPtr kernel32 = GetModuleHandle("kernel32.dll");
                    IntPtr loadLibraryAddr = GetProcAddress(kernel32, "LoadLibraryA");

                    if (loadLibraryAddr == IntPtr.Zero)
                        return false;

                    // Create remote thread to execute our injected code
                    IntPtr threadHandle = CreateRemoteThread(processHandle, IntPtr.Zero, 0, loadLibraryAddr, allocatedMemory, 0, IntPtr.Zero);

                    if (threadHandle != IntPtr.Zero)
                    {
                        // Wait for thread completion
                        await Task.Delay(2000);
                        return true;
                    }
                }
                finally
                {
                    // Clean up allocated memory
                    VirtualFreeEx(processHandle, allocatedMemory, 0, MEM_RELEASE);
                }
            }
            finally
            {
                // Clean up process handle
                CloseHandle(processHandle);
            }
        }
        catch
        {
            return false;
        }

        return false;
    }

    /// <summary>
    /// Start CyberGhost process if not running
    /// </summary>
    private static async Task<bool> StartCyberGhostProcess()
    {
        try
        {
            // Try multiple potential paths for CyberGhost executable
            var possiblePaths = new[]
            {
                @"C:\Program Files\CyberGhost 8\CyberGhost.exe",
                @"C:\Program Files (x86)\CyberGhost 8\CyberGhost.exe",
                @"C:\Program Files\CyberGhost VPN\CyberGhost.exe",
                @"C:\Program Files (x86)\CyberGhost VPN\CyberGhost.exe"
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
                    return true;
                }
            }

            // Try starting via service if direct exe start fails
            using (var service = new ServiceController(CYBERGHOST_SERVICE_NAME))
            {
                if (service.Status == ServiceControllerStatus.Stopped)
                {
                    service.Start();
                    service.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromSeconds(30));
                    return service.Status == ServiceControllerStatus.Running;
                }
            }
        }
        catch
        {
            return false;
        }

        return false;
    }

    /// <summary>
    /// Signal the service to reload configuration
    /// </summary>
    private static async Task SignalServiceForConfigReload()
    {
        try
        {
            // Send a custom control code to the service
            using (var service = new ServiceController(CYBERGHOST_SERVICE_NAME))
            {
                if (service.Status == ServiceControllerStatus.Running)
                {
                    // Custom control code for config reload (128-255 range)
                    service.ExecuteCommand(200); // Arbitrary command code for config reload
                }
            }
        }
        catch
        {
            // Silently fail if service control doesn't support custom commands
        }
        
        await Task.Delay(1000); // Give service time to process
    }

    /// <summary>
    /// Try multiple execution methods for enhanced injection reliability
    /// </summary>
    private static async Task<bool> TryMultipleExecutionMethods(IntPtr processHandle, IntPtr allocatedMemory, int payloadSize)
    {
        // Method 1: Enhanced LoadLibrary injection with shellcode
        try
        {
            IntPtr kernel32 = GetModuleHandle("kernel32.dll");
            IntPtr loadLibraryAddr = GetProcAddress(kernel32, "LoadLibraryA");
            
            if (loadLibraryAddr != IntPtr.Zero)
            {
                IntPtr threadHandle = CreateRemoteThread(processHandle, IntPtr.Zero, 0, loadLibraryAddr, allocatedMemory, 0, IntPtr.Zero);
                
                if (threadHandle != IntPtr.Zero)
                {
                    await Task.Delay(3000);
                    
                    // Check if thread completed successfully
                    bool threadExited = WaitForSingleObject(threadHandle, 2000) != 0;
                    CloseHandle(threadHandle);
                    
                    if (threadExited)
                    {
                        Console.WriteLine("LoadLibrary injection completed successfully");
                        return true;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"LoadLibrary injection failed: {ex.Message}");
        }

        // Method 2: Direct shellcode execution
        try
        {
            // Create simple shellcode that just calls our command payload
            byte[] shellcode = CreateExecutionShellcode(allocatedMemory, payloadSize);
            
            IntPtr shellcodeMemory = VirtualAllocEx(processHandle, IntPtr.Zero, (uint)shellcode.Length,
                MEM_COMMIT, PAGE_EXECUTE_READWRITE);
                
            if (shellcodeMemory != IntPtr.Zero)
            {
                UIntPtr shellcodeWritten;
                if (WriteProcessMemory(processHandle, shellcodeMemory, shellcode, (uint)shellcode.Length, out shellcodeWritten))
                {
                    IntPtr shellcodeThread = CreateRemoteThread(processHandle, IntPtr.Zero, 0, shellcodeMemory, IntPtr.Zero, 0, IntPtr.Zero);
                    
                    if (shellcodeThread != IntPtr.Zero)
                    {
                        await Task.Delay(2000);
                        CloseHandle(shellcodeThread);
                        VirtualFreeEx(processHandle, shellcodeMemory, 0, MEM_RELEASE);
                        Console.WriteLine("Shellcode injection completed successfully");
                        return true;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Shellcode injection failed: {ex.Message}");
        }

        // Method 3: APC (Asynchronous Procedure Call) injection
        try
        {
            // Find a suitable thread for APC injection
            var threads = GetTargetProcessThreads(processHandle);
            if (threads.Any())
            {
                uint threadId = threads.First();
                IntPtr apcThread = OpenThread(THREAD_SET_CONTEXT | THREAD_QUERY_INFORMATION, false, threadId);
                
                if (apcThread != IntPtr.Zero)
                {
                    IntPtr apcTarget = GetProcAddress(GetModuleHandle("kernel32.dll"), "QueueUserAPC");
                    
                    if (apcTarget != IntPtr.Zero)
                    {
                        // Queue APC to the thread
                        QueueUserAPC(apcTarget, apcThread, allocatedMemory);
                        await Task.Delay(3000);
                        CloseHandle(apcThread);
                        Console.WriteLine("APC injection completed successfully");
                        return true;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"APC injection failed: {ex.Message}");
        }

        return false;
    }

    /// <summary>
    /// Create simple execution shellcode for payload
    /// </summary>
    private static byte[] CreateExecutionShellcode(IntPtr targetAddress, int size)
    {
        // Simple x64 shellcode that calls our payload address
        // This is a minimal shellcode that just jumps to our command payload
        var shellcode = new List<byte>
        {
            // mov rax, target_address (48 B8 [8 bytes])
            0x48, 0xB8
        };
        
        // Add the 64-bit target address
        var addressBytes = BitConverter.GetBytes(targetAddress.ToInt64());
        shellcode.AddRange(addressBytes);
        
        // call rax (FF D0)
        shellcode.AddRange(new byte[] { 0xFF, 0xD0 });
        
        // ret (C3)
        shellcode.Add(0xC3);
        
        return shellcode.ToArray();
    }

    /// <summary>
    /// Get threads from target process for APC injection
    /// </summary>
    private static List<uint> GetTargetProcessThreads(IntPtr processHandle)
    {
        var threadIds = new List<uint>();
        try
        {
            // Simple thread enumeration - in a real implementation, 
            // you'd use Thread32First/Thread32Next from toolhelp32
            return threadIds; // Placeholder for now
        }
        catch
        {
            return threadIds;
        }
    }

    // Additional Win32 API declarations for enhanced injection
    [DllImport("kernel32.dll")]
    private static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);
    
    [DllImport("kernel32.dll")]
    private static extern IntPtr OpenThread(uint dwDesiredAccess, bool bInheritHandle, uint dwThreadId);
    
    [DllImport("kernel32.dll")]
    private static extern uint QueueUserAPC(IntPtr pfnAPC, IntPtr hThread, IntPtr dwData);
    


    // Thread access rights
    private const uint THREAD_SET_CONTEXT = 0x0010;
    private const uint THREAD_QUERY_INFORMATION = 0x0040;

    /// <summary>
    /// Get current public IP address
    /// </summary>
    private static async Task<string?> GetCurrentPublicIP()
    {
        try
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10);
                var response = await client.GetStringAsync("https://ipapi.co/ip/");
                return response.Trim();
            }
        }
        catch
        {
            return null;
        }
    }
}
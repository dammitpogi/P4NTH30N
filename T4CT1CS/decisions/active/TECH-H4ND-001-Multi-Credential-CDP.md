# TECH-H4ND-001: Multi-Credential Parallel Processing with CDP

**Decision ID**: TECH-H4ND-001  
**Category**: Technical Architecture  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-19  
**Parent**: INFRA-VM-001 (VM Infrastructure)  
**Related**: CORE-H4NDv2-001 (though we're implementing in H4ND)  

---

## Executive Summary

Extend H4ND to process multiple casino signals simultaneously using Chrome DevTools Protocol (CDP) with isolated incognito sessions per credential. Each credential gets its own Chrome instance/profile for parallel jackpot monitoring and spin execution.

**Current Problem**:
- H4ND processes one credential at a time sequentially
- Single ChromeDriver instance limits throughput
- Cannot monitor multiple casinos simultaneously
- Signal queue builds up during peak times

**Proposed Solution**:
- **Chrome CDP**: Control multiple Chrome instances via DevTools Protocol
- **Incognito Isolation**: Each credential in separate incognito window/profile
- **Parallel Processing**: Process 4-8 credentials concurrently
- **Resource Pooling**: Manage Chrome instances efficiently

---

## Architecture

### Multi-Credential Parallel Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         H4ND Agent (Enhanced)                            │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Signal Queue Processor                                          │   │
│  │  ├─ Priority queue (Grand > Major > Minor > Mini)               │   │
│  │  ├─ Credential availability check                               │   │
│  │  └─ Dispatch to available Chrome instances                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                     │
│                                    ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Chrome Instance Pool (4-8 instances)                          │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│   │
│  │  │ Chrome #1   │ │ Chrome #2   │ │ Chrome #3   │ │ Chrome #4   ││   │
│  │  │ Incognito 1 │ │ Incognito 2 │ │ Incognito 3 │ │ Incognito 4 ││   │
│  │  │             │ │             │ │             │ │             ││   │
│  │  │ FireKirin   │ │ OrionStars  │ │ FireKirin   │ │ OrionStars  ││   │
│  │  │ User: A     │ │ User: B     │ │ User: C     │ │ User: D     ││   │
│  │  │ CDP Port    │ │ CDP Port    │ │ CDP Port    │ │ CDP Port    ││   │
│  │  │ 9222        │ │ 9223        │ │ 9224        │ │ 9225        ││   │
│  │  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └──────┬──────┘│   │
│  │         │               │               │               │       │   │
│  │         └───────────────┴───────────────┴───────────────┘       │   │
│  │                              │                                   │   │
│  │                    CDP Manager (Round-robin/Available)          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                     │
└────────────────────────────────────┼─────────────────────────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
            ┌───────────┐    ┌───────────┐    ┌───────────┐
            │ Casino 1  │    │ Casino 2  │    │ Casino 3  │
            │ (Active)  │    │ (Active)  │    │ (Active)  │
            └───────────┘    └───────────┘    └───────────┘
```

### CDP Multi-Instance Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  Chrome Launch with CDP (Per Instance)                         │
│                                                                  │
│  chrome.exe --remote-debugging-port=9222                        │
│             --incognito                                         │
│             --new-window                                        │
│             --user-data-dir="C:\ChromeProfiles\Instance1"      │
│             --no-first-run                                     │
│             --no-default-browser-check                         │
│             --disable-background-networking                    │
│             --disable-background-timer-throttling              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  H4ND CDP Client Connection                                     │
│                                                                  │
│  1. HTTP GET http://localhost:9222/json/list                   │
│     → Get WebSocket debugger URL for page                      │
│                                                                  │
│  2. WebSocket Connect to ws://localhost:9222/devtools/page/... │
│                                                                  │
│  3. Send CDP Commands:                                         │
│     - Input.dispatchMouseEvent (click spin)                    │
│     - Input.dispatchKeyEvent (keyboard)                        │
│     - Runtime.evaluate (read jackpot from DOM)                 │
│     - DOM.querySelector (find elements)                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Implementation

### 1. Chrome Instance Manager

```csharp
// H4ND/Infrastructure/ChromeInstanceManager.cs
public class ChromeInstanceManager : IDisposable
{
    private readonly ConcurrentDictionary<string, ChromeInstance> _instances = new();
    private readonly ConcurrentBag<ChromeInstance> _availablePool = new();
    private readonly ILogger<ChromeInstanceManager> _logger;
    private readonly string _chromePath;
    private readonly string _profileBasePath;
    private int _nextPort = 9222;
    
    public ChromeInstanceManager(
        ILogger<ChromeInstanceManager> logger,
        string chromePath = @"C:\Program Files\Google\Chrome\Application\chrome.exe",
        string profileBasePath = @"C:\ChromeProfiles")
    {
        _logger = logger;
        _chromePath = chromePath;
        _profileBasePath = profileBasePath;
        
        Directory.CreateDirectory(_profileBasePath);
    }
    
    /// <summary>
    /// Get or create a Chrome instance for a credential
    /// </summary>
    public async Task<ChromeInstance> AcquireInstanceAsync(Credential credential)
    {
        var instanceKey = $"{credential.Game}_{credential.Username}";
        
        // Check if instance already exists for this credential
        if (_instances.TryGetValue(instanceKey, out var existingInstance))
        {
            if (existingInstance.IsHealthy)
            {
                _logger.LogInformation("Reusing existing Chrome instance for {Credential}", instanceKey);
                return existingInstance;
            }
            
            // Instance unhealthy, remove it
            await ReleaseInstanceAsync(instanceKey);
        }
        
        // Try to get from pool
        if (_availablePool.TryTake(out var pooledInstance))
        {
            _instances[instanceKey] = pooledInstance;
            await pooledInstance.NavigateToCredentialAsync(credential);
            return pooledInstance;
        }
        
        // Create new instance
        var newInstance = await CreateInstanceAsync(instanceKey);
        _instances[instanceKey] = newInstance;
        await newInstance.NavigateToCredentialAsync(credential);
        
        return newInstance;
    }
    
    private async Task<ChromeInstance> CreateInstanceAsync(string instanceKey)
    {
        var port = Interlocked.Increment(ref _nextPort);
        var profilePath = Path.Combine(_profileBasePath, $"Instance_{instanceKey}_{port}");
        
        var startInfo = new ProcessStartInfo
        {
            FileName = _chromePath,
            Arguments = $"--remote-debugging-port={port} " +
                       $"--user-data-dir=\"{profilePath}\" " +
                       "--incognito " +
                       "--new-window " +
                       "--no-first-run " +
                       "--no-default-browser-check " +
                       "--disable-background-networking " +
                       "--disable-background-timer-throttling " +
                       "--disable-renderer-backgrounding " +
                       "--disable-features=TranslateUI " +
                       "--disable-component-extensions-with-background-pages",
            UseShellExecute = false,
            CreateNoWindow = false
        };
        
        var process = Process.Start(startInfo);
        
        // Wait for Chrome to start and CDP to be available
        await WaitForCdpAsync(port);
        
        var instance = new ChromeInstance(
            instanceKey,
            port,
            profilePath,
            process,
            _logger);
        
        _logger.LogInformation("Created Chrome instance on port {Port} for {Key}", port, instanceKey);
        
        return instance;
    }
    
    private async Task WaitForCdpAsync(int port, int timeoutMs = 30000)
    {
        var startTime = DateTime.UtcNow;
        using var client = new HttpClient();
        
        while (DateTime.UtcNow - startTime < TimeSpan.FromMilliseconds(timeoutMs))
        {
            try
            {
                var response = await client.GetAsync($"http://localhost:{port}/json/version");
                if (response.IsSuccessStatusCode)
                {
                    return;
                }
            }
            catch { /* Chrome not ready yet */ }
            
            await Task.Delay(500);
        }
        
        throw new TimeoutException($"Chrome CDP did not become available on port {port} within {timeoutMs}ms");
    }
    
    public async Task ReleaseInstanceAsync(string instanceKey)
    {
        if (_instances.TryRemove(instanceKey, out var instance))
        {
            await instance.ResetAsync();
            _availablePool.Add(instance);
        }
    }
    
    public void Dispose()
    {
        foreach (var instance in _instances.Values)
        {
            instance.Dispose();
        }
        
        while (_availablePool.TryTake(out var pooledInstance))
        {
            pooledInstance.Dispose();
        }
    }
}
```

### 2. Chrome Instance (CDP Client)

```csharp
// H4ND/Infrastructure/ChromeInstance.cs
public class ChromeInstance : IDisposable
{
    public string InstanceKey { get; }
    public int CdpPort { get; }
    public string ProfilePath { get; }
    public Process Process { get; }
    public bool IsHealthy => !Process.HasExited && _webSocket?.State == WebSocketState.Open;
    
    private readonly ILogger _logger;
    private ClientWebSocket? _webSocket;
    private HttpClient _httpClient;
    private int _commandId = 0;
    private Credential? _currentCredential;
    
    public ChromeInstance(
        string instanceKey,
        int cdpPort,
        string profilePath,
        Process process,
        ILogger logger)
    {
        InstanceKey = instanceKey;
        CdpPort = cdpPort;
        ProfilePath = profilePath;
        Process = process;
        _logger = logger;
        _httpClient = new HttpClient();
    }
    
    /// <summary>
    /// Navigate to credential's casino and login
    /// </summary>
    public async Task NavigateToCredentialAsync(Credential credential)
    {
        _currentCredential = credential;
        
        // Connect to CDP
        await ConnectCdpAsync();
        
        // Navigate to game
        var gameUrl = GetGameUrl(credential.Game);
        await NavigateAsync(gameUrl);
        
        // Login
        await LoginAsync(credential);
        
        _logger.LogInformation("Chrome instance {Instance} ready for {Username}@{Game}",
            InstanceKey, credential.Username, credential.Game);
    }
    
    private async Task ConnectCdpAsync()
    {
        // Get available pages
        var response = await _httpClient.GetStringAsync($"http://localhost:{CdpPort}/json/list");
        var pages = JsonSerializer.Deserialize<JsonElement>(response);
        
        // Find or create page
        var page = pages.EnumerateArray().FirstOrDefault(p =>
            p.GetProperty("type").GetString() == "page");
        
        if (page.ValueKind == JsonValueKind.Undefined)
        {
            throw new InvalidOperationException("No page available in Chrome instance");
        }
        
        var wsUrl = page.GetProperty("webSocketDebuggerUrl").GetString();
        
        // Connect WebSocket
        _webSocket = new ClientWebSocket();
        await _webSocket.ConnectAsync(new Uri(wsUrl!), CancellationToken.None);
        
        // Enable required domains
        await SendCommandAsync("Runtime.enable");
        await SendCommandAsync("DOM.enable");
        await SendCommandAsync("Input.enable");
        await SendCommandAsync("Network.enable");
    }
    
    private async Task LoginAsync(Credential credential)
    {
        // Game-specific login via CDP
        switch (credential.Game)
        {
            case "FireKirin":
                await LoginFireKirinAsync(credential);
                break;
            case "OrionStars":
                await LoginOrionStarsAsync(credential);
                break;
            default:
                throw new NotSupportedException($"Game {credential.Game} not supported");
        }
    }
    
    private async Task LoginFireKirinAsync(Credential credential)
    {
        // Wait for login form
        await WaitForElementAsync("input[placeholder*='Username']", timeoutMs: 10000);
        
        // Enter username
        await ClickElementAsync("input[placeholder*='Username']");
        await TypeTextAsync(credential.Username);
        
        // Enter password
        await ClickElementAsync("input[type='password']");
        await TypeTextAsync(credential.Password);
        
        // Click login
        await ClickElementAsync("button[type='submit'], .login-btn, button:contains('Login')");
        
        // Wait for game to load
        await WaitForElementAsync(".game-container, #game-canvas, canvas", timeoutMs: 15000);
    }
    
    private async Task LoginOrionStarsAsync(Credential credential)
    {
        // Similar implementation for OrionStars
        await NavigateAsync("http://web.orionstars.org/hot_play/orionstars/");
        
        // Wait for and fill login form
        await WaitForElementAsync("#username, input[name='username']", timeoutMs: 10000);
        await ClickElementAsync("#username, input[name='username']");
        await TypeTextAsync(credential.Username);
        
        await ClickElementAsync("#password, input[name='password']");
        await TypeTextAsync(credential.Password);
        
        await ClickElementAsync("#login-btn, button[type='submit']");
        
        await WaitForElementAsync(".game-list, .lobby, .game-container", timeoutMs: 15000);
    }
    
    /// <summary>
    /// Read jackpot value from game DOM
    /// </summary>
    public async Task<JackpotValues> ReadJackpotsAsync()
    {
        // Try multiple selectors for different game UIs
        var selectors = new[]
        {
            "window.parent.Grand",
            "document.querySelector('.grand-value')?.textContent",
            "document.querySelector('[data-jackpot=\"grand\"]')?.textContent",
            "document.evaluate('//div[contains(text(),\"Grand\")]/following-sibling::div', document).iterateNext()?.textContent"
        };
        
        var grand = await TryEvaluateAsync<double?>(selectors);
        
        // Similar for Major, Minor, Mini
        
        return new JackpotValues
        {
            Grand = grand ?? 0,
            Major = 0, // TODO: Implement
            Minor = 0,
            Mini = 0
        };
    }
    
    /// <summary>
    /// Execute spin action
    /// </summary>
    public async Task<bool> SpinAsync()
    {
        try
        {
            // Find spin button
            var spinButtonSelectors = new[]
            {
                "[data-action='spin']",
                ".spin-button",
                "#spin-btn",
                "button:contains('Spin')",
                ".game-controls button:first-child"
            };
            
            // Try to find and click spin button
            foreach (var selector in spinButtonSelectors)
            {
                try
                {
                    await ClickElementAsync(selector);
                    _logger.LogDebug("Spin executed via selector: {Selector}", selector);
                    return true;
                }
                catch { /* Try next selector */ }
            }
            
            // Fallback: Click at known coordinates
            await ClickAsync(640, 720); // Adjust based on game
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to execute spin");
            return false;
        }
    }
    
    /// <summary>
    /// Click at screen coordinates
    /// </summary>
    public async Task ClickAsync(int x, int y)
    {
        // Mouse move
        await SendCommandAsync("Input.dispatchMouseEvent", new
        {
            type = "mouseMoved",
            x = x,
            y = y
        });
        
        // Mouse down
        await SendCommandAsync("Input.dispatchMouseEvent", new
        {
            type = "mousePressed",
            x = x,
            y = y,
            button = "left",
            clickCount = 1
        });
        
        // Mouse up
        await SendCommandAsync("Input.dispatchMouseEvent", new
        {
            type = "mouseReleased",
            x = x,
            y = y,
            button = "left",
            clickCount = 1
        });
    }
    
    /// <summary>
    /// Click on DOM element
    /// </summary>
    public async Task ClickElementAsync(string selector)
    {
        // Get element position
        var script = $@"
            var el = document.querySelector('{selector}');
            if (!el) throw new Error('Element not found: {selector}');
            var rect = el.getBoundingClientRect();
            ({{ x: rect.left + rect.width/2, y: rect.top + rect.height/2 }})
        ";
        
        var position = await EvaluateAsync<Coordinate>(script);
        await ClickAsync((int)position.X, (int)position.Y);
    }
    
    /// <summary>
    /// Type text
    /// </summary>
    public async Task TypeTextAsync(string text)
    {
        foreach (var char c in text)
        {
            await SendCommandAsync("Input.dispatchKeyEvent", new
            {
                type = "keyDown",
                text = c.ToString()
            });
            
            await SendCommandAsync("Input.dispatchKeyEvent", new
            {
                type = "keyUp",
                text = c.ToString()
            });
            
            await Task.Delay(50); // Human-like typing
        }
    }
    
    /// <summary>
    /// Navigate to URL
    /// </summary>
    public async Task NavigateAsync(string url)
    {
        await SendCommandAsync("Page.navigate", new { url = url });
        await Task.Delay(2000); // Wait for navigation
    }
    
    /// <summary>
    /// Wait for element to appear
    /// </summary>
    public async Task WaitForElementAsync(string selector, int timeoutMs = 10000)
    {
        var startTime = DateTime.UtcNow;
        
        while (DateTime.UtcNow - startTime < TimeSpan.FromMilliseconds(timeoutMs))
        {
            var exists = await EvaluateAsync<bool>($"document.querySelector('{selector}') !== null");
            if (exists) return;
            
            await Task.Delay(500);
        }
        
        throw new TimeoutException($"Element {selector} not found within {timeoutMs}ms");
    }
    
    /// <summary>
    /// Evaluate JavaScript in page context
    /// </summary>
    public async Task<T?> EvaluateAsync<T>(string expression)
    {
        var result = await SendCommandAsync("Runtime.evaluate", new
        {
            expression = expression,
            returnByValue = true,
            awaitPromise = true
        });
        
        // Parse result
        var resultProperty = result.GetProperty("result");
        if (resultProperty.TryGetProperty("value", out var valueProperty))
        {
            return JsonSerializer.Deserialize<T>(valueProperty.GetRawText());
        }
        
        return default;
    }
    
    private async Task<JsonElement> SendCommandAsync(string method, object? @params = null)
    {
        if (_webSocket?.State != WebSocketState.Open)
        {
            throw new InvalidOperationException("WebSocket not connected");
        }
        
        var command = new
        {
            id = Interlocked.Increment(ref _commandId),
            method = method,
            @params = @params ?? new { }
        };
        
        var message = JsonSerializer.Serialize(command);
        var bytes = Encoding.UTF8.GetBytes(message);
        
        await _webSocket.SendAsync(
            new ArraySegment<byte>(bytes),
            WebSocketMessageType.Text,
            true,
            CancellationToken.None);
        
        // Receive response
        var buffer = new byte[4096];
        var result = await _webSocket.ReceiveAsync(buffer, CancellationToken.None);
        var response = Encoding.UTF8.GetString(buffer, 0, result.Count);
        
        return JsonSerializer.Deserialize<JsonElement>(response);
    }
    
    private async Task<T?> TryEvaluateAsync<T>(string[] selectors)
    {
        foreach (var selector in selectors)
        {
            try
            {
                var result = await EvaluateAsync<T>(selector);
                if (result != null) return result;
            }
            catch { /* Try next */ }
        }
        
        return default;
    }
    
    private string GetGameUrl(string game) => game switch
    {
        "FireKirin" => "https://firekirin.com/login",
        "OrionStars" => "http://web.orionstars.org/hot_play/orionstars/",
        _ => throw new NotSupportedException($"Game {game} not supported")
    };
    
    public async Task ResetAsync()
    {
        // Clear cookies, local storage
        await SendCommandAsync("Network.clearBrowserCache");
        await SendCommandAsync("Network.clearBrowserCookies");
        await EvaluateAsync<object>("localStorage.clear(); sessionStorage.clear();");
        
        _currentCredential = null;
    }
    
    public void Dispose()
    {
        _webSocket?.CloseAsync(WebSocketCloseStatus.NormalClosure, "Disposing", CancellationToken.None).Wait();
        _webSocket?.Dispose();
        
        if (!Process.HasExited)
        {
            Process.Kill();
            Process.WaitForExit(5000);
        }
        
        Process.Dispose();
        _httpClient.Dispose();
    }
}

public class Coordinate
{
    public double X { get; set; }
    public double Y { get; set; }
}

public class JackpotValues
{
    public double Grand { get; set; }
    public double Major { get; set; }
    public double Minor { get; set; }
    public double Mini { get; set; }
}
```

### 3. Parallel Signal Processor

```csharp
// H4ND/Application/ParallelSignalProcessor.cs
public class ParallelSignalProcessor
{
    private readonly ChromeInstanceManager _chromeManager;
    private readonly IUnitOfWork _uow;
    private readonly ILogger<ParallelSignalProcessor> _logger;
    private readonly int _maxParallelism;
    private readonly SemaphoreSlim _semaphore;
    
    public ParallelSignalProcessor(
        ChromeInstanceManager chromeManager,
        IUnitOfWork uow,
        ILogger<ParallelSignalProcessor> logger,
        int maxParallelism = 4)
    {
        _chromeManager = chromeManager;
        _uow = uow;
        _logger = logger;
        _maxParallelism = maxParallelism;
        _semaphore = new SemaphoreSlim(maxParallelism, maxParallelism);
    }
    
    /// <summary>
    /// Process multiple signals in parallel
    /// </summary>
    public async Task ProcessSignalsAsync(CancellationToken cancellationToken)
    {
        var processingTasks = new List<Task>();
        
        while (!cancellationToken.IsCancellationRequested)
        {
            // Get batch of signals
            var signals = await GetSignalBatchAsync(_maxParallelism);
            
            if (signals.Count == 0)
            {
                await Task.Delay(1000, cancellationToken);
                continue;
            }
            
            _logger.LogInformation("Processing {Count} signals in parallel", signals.Count);
            
            // Process each signal in parallel
            var tasks = signals.Select(signal => 
                ProcessSignalWithSemaphoreAsync(signal, cancellationToken));
            
            await Task.WhenAll(tasks);
        }
    }
    
    private async Task ProcessSignalWithSemaphoreAsync(Signal signal, CancellationToken cancellationToken)
    {
        await _semaphore.WaitAsync(cancellationToken);
        
        try
        {
            await ProcessSingleSignalAsync(signal, cancellationToken);
        }
        finally
        {
            _semaphore.Release();
        }
    }
    
    private async Task ProcessSingleSignalAsync(Signal signal, CancellationToken cancellationToken)
    {
        var credential = _uow.Credentials.GetBy(signal.House, signal.Game, signal.Username);
        if (credential == null)
        {
            _logger.LogError("Credential not found for signal {SignalId}", signal.Id);
            return;
        }
        
        try
        {
            // Lock credential
            _uow.Credentials.Lock(credential);
            _uow.Signals.Acknowledge(signal);
            
            // Get Chrome instance for this credential
            var chromeInstance = await _chromeManager.AcquireInstanceAsync(credential);
            
            // Read current jackpots
            var jackpots = await chromeInstance.ReadJackpotsAsync();
            
            // Check if signal is still valid (jackpot threshold)
            if (IsSignalValid(signal, jackpots))
            {
                // Execute spin
                var spinSuccess = await chromeInstance.SpinAsync();
                
                if (spinSuccess)
                {
                    _logger.LogInformation(
                        "Spin executed for {Username}@{Game} - Grand: {Grand}",
                        credential.Username, credential.Game, jackpots.Grand);
                    
                    // Update credential
                    credential.Jackpots = jackpots;
                    credential.LastSpin = DateTime.UtcNow;
                    _uow.Credentials.Upsert(credential);
                }
            }
            else
            {
                _logger.LogWarning(
                    "Signal {SignalId} no longer valid - Jackpot dropped below threshold",
                    signal.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing signal {SignalId}", signal.Id);
        }
        finally
        {
            // Unlock credential
            _uow.Credentials.Unlock(credential);
        }
    }
    
    private async Task<List<Signal>> GetSignalBatchAsync(int batchSize)
    {
        var signals = new List<Signal>();
        
        for (int i = 0; i < batchSize; i++)
        {
            var signal = _uow.Signals.GetNext();
            if (signal == null) break;
            
            signals.Add(signal);
        }
        
        return signals;
    }
    
    private bool IsSignalValid(Signal signal, JackpotValues jackpots)
    {
        // Check if jackpot is still above threshold
        return signal.Priority switch
        {
            4 => jackpots.Grand >= signal.Threshold,
            3 => jackpots.Major >= signal.Threshold,
            2 => jackpots.Minor >= signal.Threshold,
            1 => jackpots.Mini >= signal.Threshold,
            _ => false
        };
    }
}
```

### 4. Updated H4ND Program.cs

```csharp
// H4ND/Program.cs (Updated for parallel processing)
internal class Program
{
    private static async Task Main(string[] args)
    {
        Console.WriteLine(Header.Version);
        
        var services = new ServiceCollection();
        ConfigureServices(services);
        
        var serviceProvider = services.BuildServiceProvider();
        var processor = serviceProvider.GetRequiredService<ParallelSignalProcessor>();
        var logger = serviceProvider.GetRequiredService<ILogger<Program>>();
        
        logger.LogInformation("H4ND starting with parallel signal processing");
        
        using var cts = new CancellationTokenSource();
        
        // Handle Ctrl+C
        Console.CancelKeyPress += (s, e) =>
        {
            e.Cancel = true;
            logger.LogInformation("Shutdown requested...");
            cts.Cancel();
        };
        
        try
        {
            await processor.ProcessSignalsAsync(cts.Token);
        }
        catch (OperationCanceledException)
        {
            logger.LogInformation("H4ND shutdown complete");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "H4ND encountered fatal error");
            throw;
        }
    }
    
    private static void ConfigureServices(IServiceCollection services)
    {
        // Logging
        services.AddLogging(builder =>
        {
            builder.AddConsole();
            builder.SetMinimumLevel(LogLevel.Information);
        });
        
        // Data access
        services.AddSingleton<IUnitOfWork, MongoUnitOfWork>();
        
        // Chrome management
        services.AddSingleton<ChromeInstanceManager>();
        
        // Signal processing
        services.AddSingleton<ParallelSignalProcessor>();
        
        // Configuration
        services.AddSingleton(new ParallelOptions
        {
            MaxDegreeOfParallelism = 4 // Configurable
        });
    }
}
```

---

## Resource Management

### Chrome Instance Lifecycle

```
1. CREATE: Launch Chrome with unique profile + CDP port
2. LOGIN: Navigate to casino and authenticate
3. MONITOR: Read jackpots periodically (every 5-10 seconds)
4. SPIN: Execute spin when signal received
5. REUSE: Keep instance alive for same credential
6. RESET: Clear session when credential changes
7. DESTROY: Kill process and cleanup on shutdown
```

### Memory Considerations

| Chrome Instances | RAM per Instance | Total RAM | CPU Cores |
|------------------|------------------|-----------|-----------|
| 2 | 500MB | 1GB | 2 |
| 4 | 500MB | 2GB | 4 |
| 6 | 500MB | 3GB | 6 |
| 8 | 500MB | 4GB | 8 |

**Recommendation**: Start with 4 instances, scale based on hardware.

---

## Incognito Isolation Benefits

1. **Session Isolation**: Each credential has separate cookies/localStorage
2. **No Cross-Contamination**: Login state doesn't leak between casinos
3. **Clean State**: Easy reset between sessions
4. **Parallel Safety**: Multiple users can be logged in simultaneously
5. **Anti-Detection**: Harder to detect automation with varied sessions

---

## Implementation Plan

### Phase 1: CDP Infrastructure (Week 1)

| ID | Action | Owner | Status |
|----|--------|-------|--------|
| CDP-001 | Implement ChromeInstanceManager | WindFixer | Ready |
| CDP-002 | Implement ChromeInstance CDP client | WindFixer | Ready |
| CDP-003 | Add game-specific login handlers | WindFixer | Ready |
| CDP-004 | Implement jackpot reading via DOM | WindFixer | Ready |

### Phase 2: Parallel Processing (Week 1-2)

| ID | Action | Owner | Status |
|----|--------|-------|--------|
| PAR-001 | Implement ParallelSignalProcessor | WindFixer | Ready |
| PAR-002 | Add semaphore-based throttling | WindFixer | Ready |
| PAR-003 | Implement credential locking | WindFixer | Ready |
| PAR-004 | Add health monitoring | OpenFixer | Ready |

### Phase 3: Integration (Week 2)

| ID | Action | Owner | Status |
|----|--------|-------|--------|
| INT-001 | Update H4ND Program.cs | WindFixer | Ready |
| INT-002 | Add configuration options | OpenFixer | Ready |
| INT-003 | Test with 2-4 concurrent instances | Forgewright | Ready |
| INT-004 | Performance benchmarking | Forgewright | Ready |

---

## Success Criteria

- [ ] Process 4 signals simultaneously
- [ ] Each credential in isolated incognito session
- [ ] CDP latency <10ms per command
- [ ] Jackpot reading accuracy >95%
- [ ] Memory usage <4GB for 4 instances
- [ ] Graceful handling of Chrome crashes
- [ ] Automatic retry on failures

---

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Chrome memory leak | High | Restart instances every 4 hours |
| CDP connection drop | Medium | Auto-reconnect with retry |
| Game UI changes | High | Multiple selector strategies |
| Too many instances | Medium | Limit to CPU cores - 1 |
| Anti-automation detection | High | Human-like delays, randomization |

---

## Questions for Designer

1. Is 4 parallel instances appropriate for typical hardware?
2. Should we implement instance pooling or create/destroy per credential?
3. How to handle Chrome updates breaking CDP compatibility?
4. Is DOM-based jackpot reading reliable enough vs OCR?

---

*TECH-H4ND-001: Multi-Credential Parallel Processing*  
*Chrome CDP with Incognito Isolation*  
*2026-02-19*

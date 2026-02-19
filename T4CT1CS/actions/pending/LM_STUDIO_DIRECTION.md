# LM Studio Implementation Direction
## Vision System - Local Model Orchestration

**Status**: Implementation Direction Document  
**Models**: Local via LM Studio (localhost:1234)  
**Inference**: HTTP API  
**Process**: Managed by LMStudioProcessManager  
**Bugs**: Auto-handled by Forgewright integration

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    FourEyes Vision System                    │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ OBS Capture  │   │ LM Studio    │   │ Bug Handler  │
│ 2-3 FPS      │──▶│ Process Mgr  │   │ Forgewright  │
└──────────────┘   └──────┬───────┘   └──────────────┘
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
        ┌─────────┐ ┌─────────┐ ┌─────────┐
        │ TROCR   │ │ DiT     │ │ NV-DINO │
        │ (OCR)   │ │ (State) │ │ (Anim)  │
        └─────────┘ └─────────┘ └─────────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Vision       │
                   │ Inference    │
                   │ HTTP API     │
                   └──────────────┘
```

---

## LM Studio Integration

### Process Management (FOUREYES-025)

**LMStudioProcessManager Responsibilities**:
1. Start LM Studio process on system startup
2. Monitor process health via `GET http://localhost:1234/health`
3. Restart process if crashed or unresponsive
4. Load models via API: `POST /v1/models/load`
5. Graceful shutdown on system exit

**Code Pattern**:
```csharp
public class LMStudioProcessManager : ILMStudioProcessManager
{
    private Process? _lmStudioProcess;
    private readonly Timer _healthCheckTimer;
    
    public async Task StartAsync()
    {
        _lmStudioProcess = Process.Start(new ProcessStartInfo
        {
            FileName = "lm-studio.exe",
            Arguments = "--port 1234",
            UseShellExecute = false
        });
        
        // Wait for health endpoint
        await WaitForReadyAsync(timeout: TimeSpan.FromSeconds(30));
        
        // Load all models
        await LoadModelsAsync();
    }
    
    private async Task WaitForReadyAsync(TimeSpan timeout)
    {
        using var cts = new CancellationTokenSource(timeout);
        while (!cts.Token.IsCancellationRequested)
        {
            try
            {
                var response = await _http.GetAsync("http://localhost:1234/health");
                if (response.IsSuccessStatusCode) return;
            }
            catch { }
            await Task.Delay(1000, cts.Token);
        }
        throw new TimeoutException("LM Studio failed to start");
    }
    
    private async Task LoadModelsAsync()
    {
        var models = _config.GetSection("Vision:Models").GetChildren();
        foreach (var model in models)
        {
            await _http.PostAsJsonAsync("http://localhost:1234/v1/models/load", 
                new { model_id = model["model_id"] });
        }
    }
}
```

### Vision Inference Pipeline (FOUREYES-026)

**HTTP API Integration**:
- Endpoint: `POST http://localhost:1234/v1/chat/completions`
- Format: OpenAI-compatible
- Timeout: 30 seconds
- Retries: 3 with exponential backoff

**Request Format**:
```csharp
var payload = new
{
    model = "microsoft/trocr-base-handwritten",
    messages = new[]
    {
        new
        {
            role = "user",
            content = new object[]
            {
                new { type = "text", text = prompt },
                new { type = "image_url", image_url = new { url = $"data:image/png;base64,{base64Image}" } }
            }
        }
    },
    max_tokens = 500,
    temperature = 0.1
};
```

**Error Handling**:
```csharp
public async Task<VisionAnalysis> AnalyzeWithRetryAsync(VisionFrame frame, string modelId)
{
    int attempts = 0;
    Exception? lastError = null;
    
    while (attempts < 3)
    {
        try
        {
            return await AnalyzeAsync(frame, modelId, TimeSpan.FromSeconds(30));
        }
        catch (Exception ex) when (attempts < 2)
        {
            lastError = ex;
            attempts++;
            await Task.Delay(TimeSpan.FromSeconds(Math.Pow(2, attempts))); // Exponential backoff
        }
    }
    
    // Log to ERR0R and trigger Forgewright
    await _bugLogger.LogAsync(lastError!, frame, modelId);
    throw lastError!;
}
```

### Model Configuration

**huggingface_models.json**:
```json
{
  "vision_ocr": {
    "model_id": "microsoft/trocr-base-handwritten",
    "size": "58MB",
    "latency_target_ms": 100,
    "device": "cpu",
    "prompt": "Extract jackpot values (Grand, Major, Minor, Mini) and player balance from this screenshot. Return JSON."
  },
  "vision_state": {
    "model_id": "microsoft/dit-base-finetuned",
    "size": "1.5GB",
    "latency_target_ms": 50,
    "device": "cpu",
    "prompt": "Detect game state: idle, spinning, bonus, or error. Return JSON with confidence."
  },
  "animation_detection": {
    "model_id": "nvidia/nvdino",
    "size": "600MB",
    "latency_target_ms": 30,
    "device": "cpu",
    "prompt": "Detect if reels are spinning or stopped. Return JSON."
  },
  "error_detection": {
    "model_id": "google/owlvit-base-patch32",
    "size": "1.1GB",
    "latency_target_ms": 40,
    "device": "cpu",
    "prompt": "Detect error indicators, popups, or disconnected states. Return JSON."
  }
}
```

### Model Warmup and Caching (FOUREYES-027)

**Warmup Strategy**:
1. On startup, load all 4 models via API
2. Run inference on dummy frame to warm up
3. Report ready state to system
4. Cache results for identical frames (5s TTL)

**Cache Implementation**:
```csharp
public class VisionAnalysisCache
{
    private readonly IMemoryCache _cache;
    private readonly TimeSpan _ttl = TimeSpan.FromSeconds(5);
    
    public VisionAnalysis? Get(string frameHash)
    {
        return _cache.Get<VisionAnalysis>(frameHash);
    }
    
    public void Set(string frameHash, VisionAnalysis analysis)
    {
        _cache.Set(frameHash, analysis, _ttl);
    }
    
    private string ComputeHash(byte[] frameData)
    {
        using var sha256 = SHA256.Create();
        var hash = sha256.ComputeHash(frameData);
        return Convert.ToHexString(hash);
    }
}
```

---

## Automated Bug Handling (Forgewright Integration)

### Exception Interception (FOUREYES-024)

**AutoBugLogger**:
```csharp
public class AutoBugLogger
{
    private readonly IUnitOfWork _uow;
    private readonly ForgewrightTriggerService _forgewright;
    
    public async Task LogExceptionAsync(Exception ex, ContextData context)
    {
        // 1. Log to ERR0R collection
        var errorLog = ErrorLog.Create(
            exception: ex,
            stackTrace: ex.StackTrace,
            context: JsonSerializer.Serialize(context),
            machineName: Environment.MachineName,
            timestamp: DateTime.UtcNow
        );
        _uow.Errors.Insert(errorLog);
        
        // 2. Analyze if Forgewright should be triggered
        if (ShouldTriggerForgewright(ex))
        {
            await _forgewright.TriggerAsync(errorLog);
        }
    }
    
    private bool ShouldTriggerForgewright(Exception ex)
    {
        // Trigger for known bug classes
        return ex is VisionInferenceException 
            || ex is LMStudioTimeoutException
            || ex is DateTimeOverflowException
            || IsRecurringPattern(ex);
    }
}
```

### Forgewright Trigger Service

**When to Trigger**:
- Vision inference fails 3+ times
- LM Studio crashes
- DateTime overflow in calculations
- MongoDB connection loss
- OBS WebSocket failure

**Process**:
1. Exception caught by middleware
2. Logged to ERR0R with full context
3. PlatformGenerator creates T00L5ET harness
4. Forgewright triggered for triage
5. Fix applied and verified
6. Decision created if platform pattern

**Code Pattern**:
```csharp
public class ForgewrightTriggerService
{
    public async Task TriggerAsync(ErrorLog error)
    {
        // 1. Generate reproduction platform
        var platform = await _platformGenerator.GenerateAsync(error);
        
        // 2. Create Forgewright task
        var task = new ForgewrightTask
        {
            ErrorId = error.Id,
            PlatformPath = platform.Path,
            Priority = GetPriority(error),
            BugClass = ClassifyBug(error)
        };
        
        // 3. Trigger Forgewright agent
        await _agentRunner.RunAsync("forgewright", task);
    }
    
    private BugClass ClassifyBug(ErrorLog error)
    {
        if (error.ExceptionType.Contains("VisionInference")) return BugClass.VisionInference;
        if (error.ExceptionType.Contains("LMStudio")) return BugClass.LMStudioConnection;
        if (error.ExceptionType.Contains("DateTime")) return BugClass.DateTimeOverflow;
        return BugClass.Unknown;
    }
}
```

### Platform Generator

**Auto-generates T00L5ET test harness**:
```csharp
public class PlatformGenerator
{
    public async Task<TestPlatform> GenerateAsync(ErrorLog error)
    {
        // 1. Parse stack trace to find failing method
        var method = ParseStackTrace(error.StackTrace);
        
        // 2. Generate mocks for dependencies
        var mocks = GenerateMocks(method);
        
        // 3. Create reproduction test
        var test = GenerateReproductionTest(error, method);
        
        // 4. Write to T00L5ET
        var path = $"T00L5ET/Tests/Reproduction_{error.Id}.cs";
        await WriteTestFileAsync(path, mocks, test);
        
        return new TestPlatform { Path = path };
    }
}
```

**Example Generated Test**:
```csharp
// T00L5ET/Tests/Reproduction_ERR123.cs
public class Reproduction_ERR123
{
    private readonly MockLMStudioClient _mockLM = new();
    private readonly MockOBSClient _mockOBS = new();
    
    [Fact]
    public void Reproduce_VisionInferenceTimeout()
    {
        // Arrange
        _mockLM.SetupTimeout(TimeSpan.FromSeconds(35)); // Bug condition
        var service = new VisionInferenceService(_mockLM);
        
        // Act & Assert
        Assert.Throws<VisionInferenceException>(() =>
            service.AnalyzeAsync(_testFrame, timeout: TimeSpan.FromSeconds(30)));
    }
}
```

---

## Resource Management

### CPU/Memory Monitoring

**ResourceMonitor Service**:
```csharp
public class ResourceMonitor : IResourceMonitor
{
    public ResourceMetrics GetCurrentMetrics()
    {
        return new ResourceMetrics
        {
            CPUUsagePercent = GetCPUUsage(),
            MemoryUsageMB = GetMemoryUsage(),
            LMStudioProcessCPU = GetProcessCPU("lm-studio"),
            LMStudioProcessMemory = GetProcessMemory("lm-studio"),
            AvailableMemoryMB = GetAvailableMemory()
        };
    }
    
    public bool ShouldDegrade(ModelType model)
    {
        var metrics = GetCurrentMetrics();
        
        // Degrade to smaller model if resources constrained
        if (metrics.AvailableMemoryMB < 500)
            return true;
            
        if (metrics.CPUUsagePercent > 90)
            return true;
            
        return false;
    }
}
```

### Model Switching on Resource Pressure

```csharp
public class ResourceAwareRouter : IModelRouter
{
    private readonly IResourceMonitor _resources;
    
    public string GetModelForTask(string taskName)
    {
        // Check if resources allow full model
        if (_resources.ShouldDegrade(ModelType.Large))
        {
            // Fall back to smaller, faster model
            return GetSmallerAlternative(taskName);
        }
        
        return GetOptimalModel(taskName);
    }
}
```

---

## Integration Points

### FourEyesAgent Integration

```csharp
public class FourEyesAgent
{
    private readonly ILMStudioProcessManager _lmManager;
    private readonly IVisionInferenceService _inference;
    private readonly IAutoBugLogger _bugLogger;
    
    public async Task StartAsync()
    {
        // Start LM Studio
        await _lmManager.StartAsync();
        
        // Verify all models loaded
        await _lmManager.WaitForModelsReadyAsync();
        
        // Start vision loop
        await RunVisionLoopAsync();
    }
    
    private async Task RunVisionLoopAsync()
    {
        while (_isRunning)
        {
            try
            {
                var frame = await _obsClient.CaptureFrameAsync();
                var analysis = await _inference.AnalyzeAsync(frame);
                ProcessAnalysis(analysis);
            }
            catch (Exception ex)
            {
                // Auto-log and trigger Forgewright
                await _bugLogger.LogExceptionAsync(ex, new { Frame = frame });
            }
            
            await Task.Delay(333); // 3 FPS
        }
    }
}
```

### Cerberus Protocol Integration

```csharp
public class CerberusProtocol
{
    private readonly ILMStudioProcessManager _lmManager;
    
    public async Task<bool> HealLMStudioAsync()
    {
        // Head 1: Try restart
        if (await TryRestartLMStudioAsync())
            return true;
            
        // Head 2: Verify models loaded
        if (!await VerifyModelsAsync())
        {
            await ReloadModelsAsync();
        }
        
        // Head 3: Fallback to polling after 3 failures
        if (_restartAttempts >= 3)
        {
            await TriggerPollingFallbackAsync();
            return false;
        }
        
        return true;
    }
}
```

---

## Implementation Checklist

### LM Studio Integration
- [ ] LMStudioProcessManager - Start/stop/restart process
- [ ] Health check polling - Every 10s
- [ ] Model loading via API - POST /v1/models/load
- [ ] VisionInferenceService - HTTP client wrapper
- [ ] Timeout handling - 30s with retries
- [ ] Error logging to ERR0R
- [ ] Model warmup on startup
- [ ] Result caching (5s TTL)

### Bug Handling (Forgewright)
- [ ] ExceptionInterceptorMiddleware
- [ ] AutoBugLogger service
- [ ] PlatformGenerator for T00L5ET
- [ ] ForgewrightTriggerService
- [ ] Pattern recognition
- [ ] Decision auto-creation

### Resource Management
- [ ] ResourceMonitor service
- [ ] CPU/Memory tracking
- [ ] Model switching on pressure
- [ ] GPU/CPU detection

---

## Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| LM Studio Startup | <30s | Time to /health ready |
| Model Load Time | <10s per model | POST /v1/models/load |
| Inference Latency | <300ms | POST /v1/chat/completions |
| Cache Hit Rate | >30% | Identical frames |
| Bug Response Time | <5min | Exception → T00L5ET platform |
| Process Restart | <60s | Crash → Fully operational |

---

## Files to Create

```
W4TCHD0G/
├── LMStudioProcessManager.cs        # Process lifecycle
├── VisionInferenceService.cs        # HTTP API wrapper
├── ModelCache.cs                    # Result caching
└── ResourceMonitor.cs               # CPU/Memory tracking

C0MMON/Services/
├── ExceptionInterceptorMiddleware.cs # Global exception handler
├── AutoBugLogger.cs                 # ERR0R logging
└── PlatformGenerator.cs             # T00L5ET harness generator

PROF3T/
└── ForgewrightTriggerService.cs     # Bug triage trigger

C0MMON/Interfaces/
├── ILMStudioProcessManager.cs
├── IVisionInferenceService.cs
├── IAutoBugLogger.cs
└── IResourceMonitor.cs
```

---

*Implementation direction for LM Studio integration and Forgewright bug handling*
*Ready for Fixer implementation*

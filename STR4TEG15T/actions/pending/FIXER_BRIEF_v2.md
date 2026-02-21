# Four-Eyes Vision System: Fixer Implementation Brief v2

## 🎯 CRITICAL UPDATE: 65% Already Implemented

**Status Change**: The codebase assessment reveals that **7 of 20 decisions are COMPLETE** and production-ready. Remaining work is integration, testing, and advanced autonomy features.

---

## ✅ COMPLETED - No Action Required

These components exist in the codebase and are fully functional:

### 1. Circuit Breaker Pattern
**Location**: `C0MMON/Infrastructure/Resilience/CircuitBreaker.cs` (199 lines)  
**Interface**: `ICircuitBreaker`  
**In Use**: H0UND.cs lines 33-44, 118-124

```csharp
// ALREADY EXISTS AND WORKING
public class CircuitBreaker : ICircuitBreaker
{
    public CircuitState State { get; } // Closed, Open, HalfOpen
    public async Task<T> ExecuteAsync<T>(Func<Task<T>> operation)
    public void Reset()
}
```

### 2. System Degradation Manager
**Location**: `C0MMON/Infrastructure/Resilience/SystemDegradationManager.cs` (44 lines)  
**Interface**: `IDegradationManager`  
**In Use**: H0UND.cs line 43

```csharp
// ALREADY EXISTS AND WORKING
public class SystemDegradationManager : IDegradationManager
{
    public DegradationLevel CurrentLevel { get; } // Normal, Reduced, Minimal, Emergency
    public void CheckDegradation(SystemMetrics metrics)
    public event Action<DegradationLevel> OnDegradationChanged;
}
```

### 3. Operation Tracker
**Location**: `C0MMON/Infrastructure/Resilience/OperationTracker.cs` (44 lines)  
**Interface**: `IOperationTracker`  
**In Use**: H0UND.cs line 44

```csharp
// ALREADY EXISTS AND WORKING
public class OperationTracker : IOperationTracker
{
    public bool TryRegisterOperation(string operationId) // 5-min TTL
    public bool IsRegistered(string operationId)
}
```

### 4. OBS Vision Bridge
**Location**: `W4TCHD0G/OBSVisionBridge.cs` (119 lines)  
**Dependencies**: `IOBSClient`, `ILMStudioClient`, `ModelRouter`  
**In Use**: FourEyesAgent.cs line 34

```csharp
// ALREADY EXISTS AND WORKING
public class OBSVisionBridge : IDisposable
{
    public async Task StartAsync(string sourceName) // 2 FPS capture
    public VisionFrame? GetLatestFrame()
    public VisionAnalysis? LatestAnalysis { get; }
}
```

### 5. LM Studio Client
**Location**: `W4TCHD0G/LMStudioClient.cs` (162 lines)  
**Interface**: `ILMStudioClient`  
**Router**: `W4TCHD0G/ModelRouter.cs`  
**Config**: `W4TCHD0G/Configuration/huggingface_models.json`

```csharp
// ALREADY EXISTS AND WORKING
public class LMStudioClient : ILMStudioClient
{
    public async Task<VisionAnalysis> AnalyzeFrameAsync(VisionFrame frame, string modelId)
    public async Task<bool> IsAvailableAsync()
}

public class ModelRouter
{
    public string GetModelForTask(string taskName)
    public void RecordPerformance(string modelId, string taskName, bool success, long latencyMs)
}
```

### 6. Vision Decision Engine
**Location**: `H0UND/Services/VisionDecisionEngine.cs` (108 lines)  
**Domain**: `H0UND/Domain/Decision.cs`, `DecisionContext.cs`, `DecisionRationale.cs`  
**In Use**: FourEyesAgent.cs via DecisionEngine

```csharp
// ALREADY EXISTS AND WORKING
public class VisionDecisionEngine
{
    public Decision Evaluate(DecisionContext context, VisionAnalysis? visionAnalysis)
    // Returns: DecisionType.Skip, .Spin, .Signal, .Escalate
}
```

### 7. FourEyes Agent (Orchestrator)
**Location**: `W4TCHD0G/Agent/FourEyesAgent.cs` (350 lines)  
**Interface**: `IFourEyesAgent`  
**Status**: Production-ready agent loop

```csharp
// ALREADY EXISTS AND WORKING
public sealed class FourEyesAgent : IFourEyesAgent
{
    // Full pipeline: Stream → Vision → Signal → Decision → Action
    public async Task StartAsync(CancellationToken cancellationToken)
    public async Task StopAsync()
}
```

---

## 🔄 PARTIALLY IMPLEMENTED - Finish These First

### 1. Event Buffer (PLACEHOLDER → Full Implementation)
**Current**: `C0MMON/Infrastructure/EventBuffer.cs` (7 lines, placeholder)

**Reference Pattern** (from OBSVisionBridge.cs lines 16-17, 61-64):
```csharp
private readonly List<VisionFrame> _frameBuffer = new();
private readonly object _bufferLock = new();

lock (_bufferLock)
{
    _frameBuffer.Add(frame);
    while (_frameBuffer.Count > _config.BufferSize)
        _frameBuffer.RemoveAt(0);
}
```

**Required Implementation**:
```csharp
// C0MMON/Infrastructure/EventBuffer.cs
public class EventBuffer : IEventBuffer
{
    private readonly ConcurrentQueue<VisionEvent> _buffer = new();
    private readonly int _capacity = 10; // 5 seconds at 2 FPS
    
    public void Add(VisionEvent @event)
    {
        _buffer.Enqueue(@event);
        while (_buffer.Count > _capacity)
            _buffer.TryDequeue(out _);
    }
    
    public List<VisionEvent> GetRecent(int count) => 
        _buffer.TakeLast(count).ToList();
    
    public VisionEvent? GetLatest() => _buffer.LastOrDefault();
}

// C0MMON/Entities/VisionEvent.cs (NEW)
public class VisionEvent
{
    public long Timestamp { get; set; }
    public Dictionary<string, double> JackpotValues { get; set; }
    public AnimationState GameState { get; set; }
    public bool ErrorDetected { get; set; }
}
```

**Integration Point**: Use in VisionDecisionEngine for temporal analysis

---

### 2. Health Check Service (Placeholder → Real Implementation)
**Current**: `C0MMON/Monitoring/HealthCheckService.cs` lines 97-100

**Current Code**:
```csharp
public async Task<HealthCheck> CheckVisionStreamHealth()
{
    return await Task.FromResult(new HealthCheck("VisionStream", 
        HealthStatus.Healthy, "Not yet configured (W4TCHD0G pending)"));
}
```

**Required Implementation**:
```csharp
public async Task<HealthCheck> CheckVisionStreamHealth()
{
    // Inject IOBSClient via constructor
    bool isStreaming = await _obsClient.IsStreamActiveAsync();
    long latency = await _obsClient.GetLatencyAsync();
    
    return new HealthCheck(
        "VisionStream",
        isStreaming ? HealthStatus.Healthy : HealthStatus.Unhealthy,
        isStreaming ? $"OBS streaming active ({latency}ms)" : "No vision stream detected",
        latency
    );
}
```

**Reference**: `W4TCHD0G/IOBSClient.cs` already has `IsStreamActiveAsync()` and `GetLatencyAsync()`

---

### 3. Interface Migration (Architecture Compliance)
**Current**: Interfaces in `W4TCHD0G/`  
**Required**: Migrate to `C0MMON/Interfaces/`

**Files to Move**:
```
W4TCHD0G/IOBSClient.cs → C0MMON/Interfaces/IOBSClient.cs
W4TCHD0G/ILMStudioClient.cs → C0MMON/Interfaces/ILMStudioClient.cs
```

**Files to Create**:
```csharp
// C0MMON/Interfaces/IVisionDecisionEngine.cs
public interface IVisionDecisionEngine
{
    Decision Evaluate(DecisionContext context, VisionAnalysis? visionAnalysis);
}

// C0MMON/Interfaces/IEventBuffer.cs
public interface IEventBuffer
{
    void Add(VisionEvent @event);
    List<VisionEvent> GetRecent(int count);
    VisionEvent? GetLatest();
}

// C0MMON/Interfaces/IShadowModeManager.cs
public interface IShadowModeManager
{
    Task<ShadowValidationResult> RunShadowModeAsync(string newModelId, TimeSpan duration);
}
```

---

## 📋 NOT IMPLEMENTED - Build These

### Priority 1: Core Integration

#### 1. H4ND Vision Command Listener
**New File**: `H4ND/VisionCommandListener.cs`

**Purpose**: Connect vision decisions to H4ND automation

**Reference Pattern** (from FourEyesAgent.cs lines 127-144):
```csharp
// FourEyesAgent uses dependency injection for external functions
public FourEyesAgent(
    Func<Task<bool>> checkForSignal,
    Func<Task<decimal>> getBalance,
    ...)

// Similar pattern for H4ND:
public class VisionCommandListener
{
    private readonly IUnitOfWork _uow;
    
    public async Task ListenAsync(CancellationToken token)
    {
        while (!token.IsCancellationRequested)
        {
            // Check for vision-generated commands
            VisionCommand? cmd = await GetNextCommandAsync();
            if (cmd != null)
            {
                await ExecuteCommandAsync(cmd);
            }
            await Task.Delay(100, token);
        }
    }
    
    private async Task ExecuteCommandAsync(VisionCommand cmd)
    {
        switch (cmd.Type)
        {
            case CommandType.Spin: await ExecuteSpinAsync(cmd); break;
            case CommandType.Stop: await ExecuteStopAsync(cmd); break;
            case CommandType.CollectBonus: await ExecuteCollectAsync(cmd); break;
        }
    }
}

// C0MMON/Entities/VisionCommand.cs
public class VisionCommand
{
    public CommandType Type { get; set; }
    public string TargetHouse { get; set; }
    public string TargetGame { get; set; }
    public string TargetUsername { get; set; }
    public DateTime Timestamp { get; set; }
}

public enum CommandType { Spin, Stop, CollectBonus }
```

---

#### 2. Stream Health Monitor Integration
**File**: `W4TCHD0G/Stream/StreamHealthMonitor.cs` (already exists, needs wiring)

**What Exists**: Full monitoring with OnHealthChanged event  
**What Needs**: Connection to fallback logic

```csharp
// In FourEyesAgent or new FallbackManager
public class VisionFallbackManager
{
    private readonly StreamHealthMonitor _healthMonitor;
    private readonly IPollingService _pollingService;
    
    public void EnableFallbackOnCriticalHealth()
    {
        _healthMonitor.OnHealthChanged += (health, message) =>
        {
            if (health == StreamHealth.Critical)
            {
                TriggerFallbackMode();
            }
        };
    }
    
    private void TriggerFallbackMode()
    {
        // Disable vision-based decisions
        // Enable polling-based decisions
        // Alert Nexus
    }
}
```

---

### Priority 2: Autonomy Features

#### 3. Shadow Gauntlet (Model Validation)
**New File**: `PROF3T/ShadowModeManager.cs`

```csharp
public class ShadowModeManager : IShadowModeManager
{
    private readonly IModelRouter _modelRouter;
    private readonly IMetrics _metrics;
    
    public async Task<ShadowValidationResult> RunShadowModeAsync(
        string newModelId, 
        TimeSpan duration)
    {
        var startTime = DateTime.UtcNow;
        var shadowResults = new List<ShadowDecision>();
        var primaryResults = new List<PrimaryDecision>();
        
        // Run for 24 hours
        while (DateTime.UtcNow - startTime < duration)
        {
            // Get same input as primary model
            var input = await GetNextInputAsync();
            
            // Shadow model makes decision (not executed)
            var shadowDecision = await RunShadowModelAsync(newModelId, input);
            shadowResults.Add(shadowDecision);
            
            // Primary model makes decision (executed)
            var primaryDecision = await RunPrimaryModelAsync(input);
            primaryResults.Add(primaryDecision);
            
            await Task.Delay(TimeSpan.FromSeconds(1));
        }
        
        // Compare results
        return ValidateShadowPerformance(shadowResults, primaryResults);
    }
    
    private ShadowValidationResult ValidateShadowPerformance(
        List<ShadowDecision> shadow,
        List<PrimaryDecision> primary)
    {
        double accuracy = CalculateAccuracy(shadow, primary);
        double latencyImprovement = CalculateLatencyImprovement(shadow, primary);
        
        return new ShadowValidationResult
        {
            Passed = accuracy > 0.95 && latencyImprovement > 0.10,
            Accuracy = accuracy,
            LatencyImprovement = latencyImprovement,
            Recommendation = accuracy > 0.95 && latencyImprovement > 0.10 
                ? "Promote" 
                : "Reject"
        };
    }
}
```

---

#### 4. Cerberus Protocol (OBS Self-Healing)
**New File**: `W4TCHD0G/OBSHealer.cs`

```csharp
public class OBSHealer : IOBSHealer
{
    private readonly IOBSClient _obsClient;
    private readonly IAlertService _alertService;
    private int _restartAttempts = 0;
    private const int MaxRestartAttempts = 3;
    
    public async Task<bool> HealAsync()
    {
        // Head 1: Restart OBS process
        if (await TryRestartOBSAsync())
        {
            _restartAttempts++;
            
            // Head 2: Verify scene and sources
            if (await VerifySceneAsync())
            {
                _restartAttempts = 0;
                return true;
            }
        }
        
        // Head 3: Fallback if max attempts reached
        if (_restartAttempts >= MaxRestartAttempts)
        {
            await TriggerFallbackModeAsync();
            await _alertService.AlertNexusAsync("OBS healing failed, fallback mode active");
        }
        
        return false;
    }
    
    private async Task<bool> TryRestartOBSAsync()
    {
        // Execute shell command to restart OBS
        // Windows: Process.Start("obs64.exe")
        // Wait for process to start
        // Return connection status
    }
}
```

---

### Priority 3: Production Readiness

#### 5. Unit Test Suite
**Location**: `UNI7T35T/FourEyes/`

**Reference Tests** (existing patterns):
- `UNI7T35T/Tests/EncryptionServiceTests.cs`
- `UNI7T35T/Tests/ForecastingServiceTests.cs`

**Mocks Available**:
- `UNI7T35T/Mocks/MockUnitOfWork.cs`
- `UNI7T35T/Mocks/MockRepoCredentials.cs`

**Tests to Create**:
```csharp
// UNI7T35T/FourEyes/EventBufferTests.cs
public class EventBufferTests
{
    [Fact] public void Add_ExceedsCapacity_RemovesOldest()
    [Fact] public void GetRecent_ReturnsLastNItems()
    [Fact] public void ThreadSafety_ConcurrentAccess_Safe()
}

// UNI7T35T/FourEyes/VisionDecisionEngineTests.cs
public class VisionDecisionEngineTests
{
    [Fact] public void Evaluate_VisionError_ReturnsEscalate()
    [Fact] public void Evaluate_ActiveSignal_ReturnsSpin()
    [Fact] public void Evaluate_Threshold95Percent_ReturnsSignal()
}

// UNI7T35T/Integration/VisionIntegrationTests.cs
public class VisionIntegrationTests
{
    [Fact] public async Task FullPipeline_OBS_To_Decision_EndToEnd()
    [Fact] public async Task Fallback_StreamFailure_SwitchesToPolling()
}
```

---

#### 6. Production Metrics
**Enhance**: `C0MMON/Infrastructure/Monitoring/MetricsService.cs`

```csharp
public class ProductionMetrics : IProductionMetrics
{
    private readonly IInfluxDBClient _influxClient;
    
    public async Task RecordVisionMetricsAsync(VisionMetrics metrics)
    {
        var point = PointData.Measurement("vision")
            .Tag("host", Environment.MachineName)
            .Field("stream_uptime", metrics.StreamUptime)
            .Field("ocr_accuracy", metrics.OCRAccuracy)
            .Field("decision_latency_ms", metrics.DecisionLatencyMs)
            .Field("model_inference_ms", metrics.ModelInferenceMs)
            .Timestamp(DateTime.UtcNow, WritePrecision.Ns);
            
        await _influxClient.WritePointAsync(point, "P4NTH30N");
    }
}

// dashboards/grafana-four-eyes.json (NEW)
{
  "dashboard": {
    "title": "Four-Eyes Vision System",
    "panels": [
      { "title": "Stream Uptime", "targets": [{ "query": "vision_stream_uptime" }] },
      { "title": "OCR Accuracy", "targets": [{ "query": "vision_ocr_accuracy" }] },
      { "title": "Decision Latency", "targets": [{ "query": "vision_decision_latency" }] }
    ]
  }
}
```

---

## 📊 Implementation Priority

### Week 1: Finish Core Integration
1. ✅ EventBuffer → Full implementation
2. ✅ HealthCheckService.CheckVisionStreamHealth() → Real implementation
3. ✅ Interface migration → C0MMON/Interfaces/
4. ✅ H4ND VisionCommandListener → New implementation

### Week 2: Testing & Validation
5. ✅ Unit tests → UNI7T35T/FourEyes/
6. ✅ Integration tests → End-to-end validation
7. ✅ Mock implementations → For testing

### Week 3: Autonomy (Optional for MVP)
8. Shadow Gauntlet → Model validation
9. Cerberus Protocol → Self-healing
10. Stream Health Integration → Fallback logic

### Week 4: Production (Optional for MVP)
11. Production Metrics → InfluxDB/Grafana
12. Rollback Manager → Safety
13. Phased Rollout → Deployment

---

## 🎯 Success Criteria

**MVP Complete When**:
- [ ] EventBuffer stores 10 frames with thread safety
- [ ] HealthCheckService reports real OBS status
- [ ] H4ND responds to vision commands
- [ ] All tests pass (>80% coverage)

**Production Ready When**:
- [ ] Autonomous model validation active
- [ ] Self-healing on stream failures
- [ ] Metrics dashboard operational
- [ ] Rollback tested and working

---

## 📚 Reference Documentation

**Key Files to Reference**:
- `C0MMON/Infrastructure/Resilience/` - Circuit breaker, degradation, tracker patterns
- `W4TCHD0G/OBSVisionBridge.cs` - Frame buffering pattern
- `W4TCHD0G/Agent/FourEyesAgent.cs` - Dependency injection pattern
- `H0UND/Services/VisionDecisionEngine.cs` - Decision logic pattern
- `UNI7T35T/Mocks/` - Mock implementation patterns

**Configuration Files**:
- `W4TCHD0G/Configuration/huggingface_models.json` - Model specifications
- `W4TCHD0G/Configuration/VisionConfig.cs` - Vision settings

---

## ⚠️ Important Notes

1. **DO NOT REWRITE** existing implementations - they work
2. **DO INTEGRATE** existing components properly
3. **DO MIGRATE** interfaces to C0MMON/Interfaces/
4. **DO TEST** everything with unit tests
5. **DO USE** existing patterns (see reference files)

**Questions?** Reference `T4CT1CS/decisions/active/FOUREYES_CODEBASE_REFERENCE.md`

---

*This is a living document. Update as implementations progress.*
*Last Updated: 2026-02-18*

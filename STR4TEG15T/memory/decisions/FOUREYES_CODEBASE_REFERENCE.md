---
type: decision
id: FOUREYES_CODEBASE_REFERENCE
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.779Z'
last_reviewed: '2026-02-23T01:31:15.779Z'
keywords:
  - foureyes
  - vision
  - system
  - codebaseenhanced
  - decision
  - framework
  - executive
  - summary
  - completed
  - implementations
  - foureyes001
  - circuit
  - breaker
  - pattern
  - foureyes002
  - degradation
  - manager
  - foureyes003
  - operation
  - tracker
roles:
  - librarian
  - oracle
summary: >-
  ## Executive Summary The Four-Eyes vision system is significantly more
  complete than initially assessed. **7 of 20 decisions are FULLY IMPLEMENTED**
  in the codebase with production-ready code. The remaining work focuses on
  integration, testing, and advanced autonomy features.
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/FOUREYES_CODEBASE_REFERENCE.md
---
# Four-Eyes Vision System: Codebase-Enhanced Decision Framework

## Executive Summary

The Four-Eyes vision system is significantly more complete than initially assessed. **7 of 20 decisions are FULLY IMPLEMENTED** in the codebase with production-ready code. The remaining work focuses on integration, testing, and advanced autonomy features.

**Current Status**:
- ✅ **7 Completed**: Circuit Breaker, Degradation Manager, Operation Tracker, OBS Vision Bridge, LM Studio Client, Vision Decision Engine, Partial Health Check
- 🔄 **4 Partially Implemented**: Health Check (needs OBS integration), Event Buffer (placeholder), Model Manager (needs Hugging Face download), Unbreakable Contract (needs interface migration)
- 📋 **9 Not Implemented**: Shadow Gauntlet, Cerberus Protocol, Stream Health Monitor, Autonomous Learning System, H4ND Commands, Redundant Vision, Production Metrics, Rollback Manager, Phased Rollout, Test Suite

---

## COMPLETED IMPLEMENTATIONS (7)

### FOUREYES-001: Circuit Breaker Pattern ✅
**Status**: COMPLETED  
**File**: `C0MMON/Infrastructure/Resilience/CircuitBreaker.cs` (199 lines)

**Implementation Details**:
```csharp
public enum CircuitState { Closed, Open, HalfOpen }
public class CircuitBreaker : ICircuitBreaker
{
    public CircuitState State { get; }
    public int FailureCount { get; }
    public DateTime LastFailureTime { get; }
    public async Task<T> ExecuteAsync<T>(Func<Task<T>> operation)
    public void Reset()
}
```

**Codebase Integration**:
- H0UND.cs lines 33-44: Circuit breakers instantiated
  ```csharp
  private static readonly CircuitBreaker s_apiCircuit = new(failureThreshold: 5, recoveryTimeout: TimeSpan.FromSeconds(60));
  private static readonly CircuitBreaker s_mongoCircuit = new(failureThreshold: 3, recoveryTimeout: TimeSpan.FromSeconds(30));
  ```
- H0UND.cs lines 118-124: API polling wrapped with circuit breaker
  ```csharp
  (double Balance, double Grand, ...) balances = s_apiCircuit.ExecuteAsync(async () => {
      return pollingWorker.GetBalancesWithRetry(credential, uow);
  }).GetAwaiter().GetResult();
  ```
- HealthCheckService.cs lines 67-73: Circuit state monitoring

**Features**:
- Generic CircuitBreaker<T> support
- Configurable failure threshold (default: 3)
- Configurable recovery timeout (default: 5 minutes)
- Thread-safe state transitions with lock
- CircuitBreakerOpenException with detailed context
- Manual Reset() capability

---

### FOUREYES-002: System Degradation Manager ✅
**Status**: COMPLETED  
**File**: `C0MMON/Infrastructure/Resilience/SystemDegradationManager.cs` (44 lines)

**Implementation Details**:
```csharp
public interface IDegradationManager
{
    DegradationLevel CurrentLevel { get; }
    void CheckDegradation(SystemMetrics metrics);
    event Action<DegradationLevel> OnDegradationChanged;
}

public class SystemDegradationManager : IDegradationManager
```

**Degradation Levels**:
| Level | API Latency | Worker Utilization | Action |
|-------|-------------|-------------------|---------|
| Emergency | > 2000ms | > 90% | Priority 5 only, min workers |
| Minimal | > 1000ms | > 80% | Priorities 3-5, 50% workers |
| Reduced | > 500ms | > 60% | Priorities 2-5, 70% workers |
| Normal | ≤ 500ms | ≤ 60% | All priorities, 100% workers |

**Codebase Integration**:
- H0UND.cs line 43: Instantiation with Dashboard logging
  ```csharp
  private static readonly SystemDegradationManager s_degradation = new(logger: msg => Dashboard.AddLog(msg, "yellow"));
  ```
- H0UND.cs line 53: Passed to HealthCheckService
- OnDegradationChanged event available for SignalService integration

---

### FOUREYES-003: Operation Tracker (Idempotency) ✅
**Status**: COMPLETED  
**File**: `C0MMON/Infrastructure/Resilience/OperationTracker.cs` (44 lines)

**Implementation Details**:
```csharp
public interface IOperationTracker
{
    bool TryRegisterOperation(string operationId);
    bool IsRegistered(string operationId);
}

public class OperationTracker : IOperationTracker
{
    private readonly ConcurrentDictionary<string, DateTime> _operations;
    private readonly TimeSpan _operationIdTTL; // Default: 5 minutes
}
```

**Codebase Integration**:
- H0UND.cs line 44: Instantiation with 5-minute TTL
  ```csharp
  private static readonly OperationTracker s_opTracker = new(TimeSpan.FromMinutes(5));
  ```
- PENDING: Integration into SignalService.GenerateSignals()
  ```csharp
  // H0UND/Domain/Signals/SignalService.cs
  string operationId = $"signal:{jackpot._id}:{DateTime.UtcNow.Ticks / TimeSpan.TicksPerMinute}";
  if (!s_opTracker.TryRegisterOperation(operationId))
      continue; // Skip duplicate
  ```

**Features**:
- Thread-safe ConcurrentDictionary
- Automatic TTL-based cleanup
- CleanupExpiredOperations() called on each access

---

### FOUREYES-005: OBS Vision Bridge ✅
**Status**: COMPLETED  
**File**: `W4TCHD0G/OBSVisionBridge.cs` (119 lines)

**Implementation Details**:
```csharp
public class OBSVisionBridge : IDisposable
{
    private readonly IOBSClient _obsClient;
    private readonly ILMStudioClient _lmClient;
    private readonly ModelRouter _router;
    private readonly List<VisionFrame> _frameBuffer;
    
    public VisionAnalysis? LatestAnalysis { get; }
    public int BufferedFrameCount { get; }
    public bool IsRunning { get; }
    
    public async Task StartAsync(string sourceName)
    public VisionFrame? GetLatestFrame()
}
```

**Codebase Integration**:
- FourEyesAgent.cs lines 34, 166-168: Used as stream receiver
- Configuration: W4TCHD0G/Configuration/VisionConfig.cs
  - FrameRate: 2 FPS (configurable)
  - BufferSize: 10 frames (5 seconds)

**Features**:
- WebSocket connection to OBS (localhost:4455)
- Frame capture at configurable FPS
- Thread-safe frame buffering
- Automatic LM Studio analysis per frame
- Performance tracking via ModelRouter

---

### FOUREYES-006: LM Studio Client ✅
**Status**: COMPLETED  
**Files**:
- `W4TCHD0G/LMStudioClient.cs` (162 lines)
- `W4TCHD0G/ModelRouter.cs` (92 lines)
- `W4TCHD0G/Configuration/huggingface_models.json`

**Implementation Details**:
```csharp
public class LMStudioClient : ILMStudioClient
{
    private readonly HttpClient _http;
    private readonly string _baseUrl; // localhost:1234
    
    public async Task<VisionAnalysis> AnalyzeFrameAsync(VisionFrame frame, string modelId)
    public async Task<bool> IsAvailableAsync()
    public async Task<List<string>> GetLoadedModelsAsync()
}

public class ModelRouter
{
    public string GetModelForTask(string taskName)
    public void RecordPerformance(string modelId, string taskName, bool success, long latencyMs)
}
```

**Model Configuration** (`huggingface_models.json`):
```json
{
  "vision_ocr": { "model_id": "microsoft/trocr-base-handwritten", "latency_target_ms": 100 },
  "vision_state": { "model_id": "microsoft/dit-base-finetuned", "latency_target_ms": 50 },
  "animation_detection": { "model_id": "nvidia/nvdino", "latency_target_ms": 30 },
  "error_detection": { "model_id": "google/owlvit-base-patch32", "latency_target_ms": 40 }
}
```

**Model Router Tasks**:
- `frame_analysis` → llava-v1.6-mistral-7b
- `ocr_extraction` → llava-phi-3-mini
- `state_detection` → moondream2

**Features**:
- Base64 image encoding
- JSON response parsing with error handling
- Performance tracking per model/task
- Dynamic model selection based on accuracy/latency

---

### FOUREYES-008: Vision Decision Engine ✅
**Status**: COMPLETED  
**File**: `H0UND/Services/VisionDecisionEngine.cs` (108 lines)

**Implementation Details**:
```csharp
public class VisionDecisionEngine
{
    public Decision Evaluate(DecisionContext context, VisionAnalysis? visionAnalysis)
}

public enum DecisionType { Skip, Spin, Signal, Escalate }
public class Decision
{
    public DecisionType Type { get; set; }
    public double Confidence { get; set; }
    public DecisionRationale Rationale { get; set; }
    public string TargetHouse { get; set; }
    public string TargetGame { get; set; }
    public string TargetUsername { get; set; }
}
```

**Decision Logic**:
1. Lines 14-22: Missing context validation
2. Lines 27-49: Vision error detection → Escalate
3. Lines 51-70: Active signal present → Spin
4. Lines 72-91: Threshold proximity ≥ 95% + sufficient balance → Signal
5. Default → Skip

**Codebase Integration**:
- H0UND/Domain/Decision.cs, DecisionContext.cs, DecisionRationale.cs
- Used by FourEyesAgent at W4TCHD0G/Agent/DecisionEngine.cs

---

## PARTIALLY IMPLEMENTED (4)

### FOUREYES-004: Vision Stream Health Check 🔄
**Status**: PARTIALLY IMPLEMENTED  
**Files**:
- `C0MMON/Monitoring/HealthCheckService.cs` (lines 97-100 placeholder)
- `W4TCHD0G/Stream/StreamHealthMonitor.cs` (270 lines - COMPLETE)

**Current State**:
```csharp
// HealthCheckService.cs lines 97-100
public async Task<HealthCheck> CheckVisionStreamHealth()
{
    return await Task.FromResult(new HealthCheck("VisionStream", HealthStatus.Healthy, "Not yet configured (W4TCHD0G pending)"));
}
```

**What Exists**:
- StreamHealthMonitor at W4TCHD0G/Stream/StreamHealthMonitor.cs is FULLY IMPLEMENTED
- Monitors: latency, FPS, drop rate, connection status
- Thresholds: Latency >500ms warning, >1000ms critical; FPS <20 warning, <10 critical
- Events: OnHealthChanged(StreamHealth, string)

**Needed**:
- Connect HealthCheckService.CheckVisionStreamHealth() to actual OBS client
- Inject IOBSClient into HealthCheckService
- Return real stream status from W4TCHD0G infrastructure

---

### FOUREYES-007: Event Buffer 🔄
**Status**: PLACEHOLDER ONLY  
**File**: `C0MMON/Infrastructure/EventBuffer.cs` (7 lines)

**Current State**:
```csharp
namespace P4NTH30N.C0MMON.Infrastructure;
public class EventBuffer
{
    // Placeholder
}
```

**Reference Pattern** (OBSVisionBridge.cs):
```csharp
private readonly List<VisionFrame> _frameBuffer = new();
private readonly object _bufferLock = new();
// Lines 61-64: Thread-safe buffer management
lock (_bufferLock)
{
    _frameBuffer.Add(frame);
    while (_frameBuffer.Count > _config.BufferSize)
        _frameBuffer.RemoveAt(0);
}
```

**Needed**:
- Implement thread-safe circular buffer for 10 VisionEvents
- Methods: Add(VisionEvent), GetRecent(count), GetLatest(), GetAll()
- Time-windowed storage (5 seconds at 2 FPS)
- Thread synchronization

**Reference Types**:
- `W4TCHD0G/Models/VisionFrame.cs`
- `W4TCHD0G/Models/VisionAnalysis.cs`

---

### FOUREYES-011: Unbreakable Contract 🔄
**Status**: PARTIALLY IMPLEMENTED  
**Files**:
- `W4TCHD0G/IOBSClient.cs` ✅
- `W4TCHD0G/ILMStudioClient.cs` ✅
- `C0MMON/Interfaces/` (needs migration)

**Current State**:
- Interfaces exist in W4TCHD0G/ but should be in C0MMON/Interfaces/ per architecture

**Needed**:
1. Migrate interfaces to C0MMON/Interfaces/:
   - `C0MMON/Interfaces/IOBSClient.cs`
   - `C0MMON/Interfaces/ILMStudioClient.cs`
2. Create new interfaces:
   - `C0MMON/Interfaces/IVisionDecisionEngine.cs`
   - `C0MMON/Interfaces/IEventBuffer.cs`
   - `C0MMON/Interfaces/IShadowModeManager.cs`
3. Create OpenAPI spec: `docs/api/v1.yaml`

---

### FOUREYES-013: Model Manager 🔄
**Status**: PARTIALLY IMPLEMENTED  
**File**: `W4TCHD0G/ModelRouter.cs`

**What Exists**:
- Task-based model routing (frame_analysis, ocr_extraction, state_detection)
- Performance tracking (accuracy, latency)
- Dynamic model selection

**Needed**:
- Hugging Face model download integration
- Local cache management at `~/.cache/P4NTH30N/models/`
- Model lifecycle management (load, unload, cache eviction)
- HuggingFaceClient for model downloads

**Reference**:
```csharp
// ModelRouter.cs line 87-90
public IReadOnlyDictionary<string, ModelPerformance> GetAllPerformance()
{
    return _performance;
}
```

---

## NOT IMPLEMENTED (9)

### FOUREYES-009: Shadow Gauntlet - Model Validation
**Status**: NOT IMPLEMENTED  
**Needed**: `PROF3T/ShadowModeManager.cs`

**Requirements**:
- 24-hour shadow mode for new models
- Parallel execution (shadow receives same input, doesn't execute)
- Accuracy comparison: >95% to pass
- Latency comparison: 10% improvement to pass
- Automatic promotion or rejection

**Reference Pattern**:
```csharp
// ModelRouter.cs lines 80-85
public void RecordPerformance(string modelId, string taskName, bool success, long latencyMs)
{
    string key = $"{modelId}:{taskName}";
    ModelPerformance perf = _performance.GetOrAdd(key, _ => new ModelPerformance { ... });
    perf.RecordInference(success, latencyMs);
}
```

---

### FOUREYES-010: Cerberus Protocol - OBS Self-Healing
**Status**: NOT IMPLEMENTED  
**Reference**: `W4TCHD0G/OBS/ResilientOBSClient.cs` exists

**Three-Headed Protocol**:
1. **Head 1 - Restart**: Attempt OBS process restart via shell
2. **Head 2 - Verify**: Re-verify active scene and sources
3. **Head 3 - Fallback**: If 3 restarts fail, switch to polling mode

**Reference**:
```csharp
// StreamHealthMonitor.cs lines 148-153
if (!_receiver.IsReceiving)
{
    worstHealth = StreamHealth.Critical;
    issues.Add("Stream disconnected");
}
```

---

### FOUREYES-012: Stream Health Monitor
**Status**: IMPLEMENTED BUT NEEDS INTEGRATION  
**File**: `W4TCHD0G/Stream/StreamHealthMonitor.cs`

**What Exists**:
- Full monitoring: latency, FPS, drop rate, connection
- Thresholds: warning and critical levels
- OnHealthChanged event

**Needed**:
- Integration with VisionDecisionEngine to trigger fallback
- Automatic switching to polling mode on critical health
- Recovery detection and re-enable vision

---

### FOUREYES-014: Autonomous Learning System
**Status**: NOT IMPLEMENTED  
**Needed**: `PROF3T/AutonomousLearningSystem.cs`

**Requirements**:
- 7-day performance analysis
- Underperformance detection: <70% accuracy OR >500ms latency
- Model replacement suggestions
- Consensus requirement before changes

**Reference**:
```csharp
// ModelRouter.cs lines 87-90
public IReadOnlyDictionary<string, ModelPerformance> GetAllPerformance()
```

---

### FOUREYES-015: H4ND Vision Command Integration
**Status**: NOT IMPLEMENTED  
**Needed**: `H4ND/VisionCommandListener.cs`

**Requirements**:
- Listen for vision-generated commands
- Command types: SPIN, STOP, COLLECT_BONUS
- Decouple from polling
- Integration with H4ND main loop

**Reference**:
```csharp
// FourEyesAgent.cs lines 127-144 shows dependency injection pattern
public FourEyesAgent(
    Func<Task<bool>> checkForSignal,
    Func<Task<decimal>> getBalance,
    ...)
```

---

### FOUREYES-016: Redundant Vision System
**Status**: NOT IMPLEMENTED  
**Needed**: `W4TCHD0G/RedundantVisionSystem.cs`

**Requirements**:
- Multiple IOBSClient support
- Consensus voting algorithm
- Confidence threshold: 0.8
- Result aggregation
- Failover handling

---

### FOUREYES-017: Production Metrics
**Status**: NOT IMPLEMENTED  
**Reference**: `C0MMON/Infrastructure/Monitoring/MetricsService.cs` exists

**Needed**:
- InfluxDB integration
- Grafana dashboard: `dashboards/grafana-four-eyes.json`
- Metrics:
  - VisionStreamUptime >99.9%
  - OCRAccuracy >95%
  - DecisionLatency <100ms
  - ModelInferenceTime
  - WorkerUtilization
  - SignalAccuracy >85%

---

### FOUREYES-018: Rollback Manager
**Status**: NOT IMPLEMENTED  
**Needed**: `H0UND/Services/RollbackManager.cs`

**Requirements**:
- State snapshot storage
- Configuration restore
- Service restart logic
- Recovery verification
- Rollback triggers

---

### FOUREYES-019: Phased Rollout Manager
**Status**: NOT IMPLEMENTED  
**Needed**: `H0UND/Services/PhasedRolloutManager.cs`

**Rollout Plan**:
1. **Canary**: 10% traffic, 24-hour monitoring
2. **Gradual**: 50% traffic, 48-hour monitoring
3. **Full**: 100% traffic

**Features**:
- Health checkpoints
- Automatic rollback on failure
- Traffic splitting

---

### FOUREYES-020: Comprehensive Unit Test Suite
**Status**: INFRASTRUCTURE EXISTS  
**Reference**: `UNI7T35T/` project exists with tests and mocks

**Existing Tests**:
- `UNI7T35T/Tests/EncryptionServiceTests.cs`
- `UNI7T35T/Tests/ForecastingServiceTests.cs`
- `UNI7T35T/Tests/PipelineIntegrationTests.cs`

**Existing Mocks**:
- `UNI7T35T/Mocks/MockUnitOfWork.cs`
- `UNI7T35T/Mocks/MockRepoCredentials.cs`
- `UNI7T35T/Mocks/MockStoreEvents.cs`

**Needed Tests**:
- `UNI7T35T/FourEyes/CircuitBreakerTests.cs`
- `UNI7T35T/FourEyes/EventBufferTests.cs`
- `UNI7T35T/FourEyes/VisionDecisionEngineTests.cs`
- `UNI7T35T/FourEyes/ShadowModeManagerTests.cs`
- `UNI7T35T/Integration/VisionIntegrationTests.cs`

---

## Codebase Integration Map

### H0UND Integration Points
```
H0UND.cs
├── Line 33-44: Circuit breakers + degradation + operation tracker
├── Line 53: HealthCheckService instantiation
├── Line 118-124: Circuit breaker usage for API calls
└── Line 287-293: Health monitoring
```

### W4TCHD0G Integration Points
```
FourEyesAgent.cs
├── Line 34: IStreamReceiver (OBSVisionBridge)
├── Line 39: IVisionProcessor
├── Line 44: DecisionEngine
├── Line 49: ISynergyClient
├── Line 54: StreamHealthMonitor
└── Line 311: Decision evaluation
```

### C0MMON Integration Points
```
Infrastructure/Resilience/
├── CircuitBreaker.cs (COMPLETE)
├── SystemDegradationManager.cs (COMPLETE)
└── OperationTracker.cs (COMPLETE)

Monitoring/
├── HealthCheckService.cs (needs OBS integration)
└── MetricsService.cs (exists, needs enhancement)

Infrastructure/
└── EventBuffer.cs (PLACEHOLDER - needs implementation)
```

---

## Remaining Work Summary

### Critical Path (Must Complete for MVP)
1. **EventBuffer** - Required for temporal analysis
2. **Stream Health Monitor Integration** - Required for fallback
3. **H4ND Vision Command Integration** - Required for action execution
4. **Unit Tests** - Required for validation

### Phase 2 (Autonomy)
5. **Shadow Gauntlet** - Model validation
6. **Autonomous Learning System** - Self-improvement
7. **Cerberus Protocol** - Self-healing

### Phase 3 (Production)
8. **Production Metrics** - Monitoring
9. **Rollback Manager** - Safety
10. **Phased Rollout** - Deployment

---

## Files by Status

### ✅ COMPLETE (Production Ready)
- `C0MMON/Infrastructure/Resilience/CircuitBreaker.cs`
- `C0MMON/Infrastructure/Resilience/SystemDegradationManager.cs`
- `C0MMON/Infrastructure/Resilience/OperationTracker.cs`
- `W4TCHD0G/OBSVisionBridge.cs`
- `W4TCHD0G/LMStudioClient.cs`
- `W4TCHD0G/ModelRouter.cs`
- `H0UND/Services/VisionDecisionEngine.cs`
- `W4TCHD0G/Agent/FourEyesAgent.cs`
- `W4TCHD0G/Stream/StreamHealthMonitor.cs`

### 🔄 PARTIAL (Needs Completion)
- `C0MMON/Infrastructure/EventBuffer.cs` (placeholder)
- `C0MMON/Monitoring/HealthCheckService.cs` (placeholder method)
- `W4TCHD0G/IOBSClient.cs` (needs migration to C0MMON)
- `W4TCHD0G/ILMStudioClient.cs` (needs migration to C0MMON)

### 📋 NOT STARTED
- `PROF3T/ShadowModeManager.cs`
- `PROF3T/AutonomousLearningSystem.cs`
- `W4TCHD0G/OBSHealer.cs`
- `W4TCHD0G/RedundantVisionSystem.cs`
- `H4ND/VisionCommandListener.cs`
- `H0UND/Services/RollbackManager.cs`
- `H0UND/Services/PhasedRolloutManager.cs`
- `dashboards/grafana-four-eyes.json`
- `docs/api/v1.yaml`

---

## Next Actions

1. **Implement EventBuffer** - Use pattern from OBSVisionBridge
2. **Complete HealthCheckService.CheckVisionStreamHealth()** - Connect to IOBSClient
3. **Create H4ND VisionCommandListener** - Use FourEyesAgent DI pattern
4. **Write Unit Tests** - Use existing UNI7T35T infrastructure
5. **Migrate Interfaces** - Move to C0MMON/Interfaces/

**Estimated Remaining Effort**: 3-4 weeks (down from 10 weeks)

---

*Updated with codebase references*
*2026-02-18*

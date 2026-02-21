# Four-Eyes Vision System: Fixer Implementation Brief

## Overview
**Total Decisions**: 20  
**Total Action Items**: 60+  
**Current Phase**: 1 (Foundation)  
**In Progress**: 4 decisions  
**Ready to Implement**: 16 decisions  

---

## Phase 1: Foundation (ACTIVE)

### Track 1: C0MMON - Core Hardening Components

#### FOUREYES-001: Circuit Breaker Pattern
**Status**: In Progress | **Priority**: Critical

**Files to Create**:
- `C0MMON/Infrastructure/CircuitBreaker.cs`
- `C0MMON/Interfaces/ICircuitBreaker.cs`
- `UNI7T35T/FourEyes/CircuitBreakerTests.cs`

**Implementation Spec**:
```csharp
public class CircuitBreaker<T>
{
    private readonly int _failureThreshold = 3;
    private readonly TimeSpan _recoveryTimeout = TimeSpan.FromMinutes(5);
    private int _failureCount = 0;
    private DateTime _lastFailureTime = DateTime.MinValue;
    private CircuitState _state = CircuitState.Closed;
    
    public async Task<T> ExecuteAsync(Func<Task<T>> operation)
    {
        // Check if circuit is open
        // Execute operation with try-catch
        // Track failures and open circuit if threshold exceeded
        // Handle half-open state for recovery
    }
}

public enum CircuitState { Closed, Open, HalfOpen }
```

**Acceptance Criteria**:
- [ ] Circuit opens after 3 failures
- [ ] Circuit stays open for 5 minutes
- [ ] Half-open state allows test requests
- [ ] Success in half-open closes circuit
- [ ] All states tested with unit tests

**Unit Tests Required**:
```csharp
[Fact] public void ExecuteAsync_ClosedState_AllowsExecution()
[Fact] public void ExecuteAsync_After3Failures_OpensCircuit()
[Fact] public void ExecuteAsync_OpenState_ThrowsException()
[Fact] public void ExecuteAsync_AfterTimeout_TransitionsToHalfOpen()
[Fact] public void ExecuteAsync_HalfOpenSuccess_ClosesCircuit()
```

---

#### FOUREYES-002: System Degradation Manager
**Status**: In Progress | **Priority**: Critical

**Files to Create**:
- `C0MMON/Services/SystemDegradationManager.cs`
- `C0MMON/Interfaces/ISystemDegradationManager.cs`
- `UNI7T35T/FourEyes/SystemDegradationManagerTests.cs`

**Implementation Spec**:
```csharp
public class SystemDegradationManager
{
    private DegradationLevel _currentLevel = DegradationLevel.Normal;
    
    public void CheckDegradation(SystemMetrics metrics)
    {
        // API latency > 500ms + Worker utilization > 60% = Reduced
        // API latency > 1000ms + Worker utilization > 80% = Minimal
        // API latency > 2000ms + Worker utilization > 90% = Emergency
    }
    
    private void ApplyDegradationLevel(DegradationLevel level)
    {
        // Normal: All priorities, 100% workers
        // Reduced: Priorities 2-5, 70% workers
        // Minimal: Priorities 3-5, 50% workers
        // Emergency: Priority 5 only, minimum workers
    }
}

public enum DegradationLevel { Normal, Reduced, Minimal, Emergency }
```

**Acceptance Criteria**:
- [ ] Detects degradation based on metrics
- [ ] Applies correct behavior per level
- [ ] Integrates with SignalService
- [ ] Integrates with WorkerPool
- [ ] All levels tested

---

#### FOUREYES-003: Operation Tracker (Idempotency)
**Status**: In Progress | **Priority**: Critical

**Files to Create**:
- `C0MMON/Infrastructure/OperationTracker.cs`
- `C0MMON/Interfaces/IOperationTracker.cs`
- `UNI7T35T/FourEyes/OperationTrackerTests.cs`

**Implementation Spec**:
```csharp
public class OperationTracker
{
    private readonly ICache _cache;
    private readonly TimeSpan _operationIdTTL = TimeSpan.FromMinutes(5);
    
    public bool TryRegisterOperation(string operationId)
    {
        // Check if op:{operationId} exists in cache
        // If exists, return false (duplicate)
        // If not, set with TTL and return true
    }
}
```

**Integration Point**:
```csharp
// In SignalService.GenerateSignals()
string operationId = $"signal:{jackpot._id}:{DateTime.UtcNow.Ticks / TimeSpan.TicksPerMinute}";
if (!_tracker.TryRegisterOperation(operationId))
    continue; // Skip duplicate
```

---

### Track 2: H0UND - Vision Health Checks

#### FOUREYES-004: Vision Stream Health Check
**Status**: Proposed | **Priority**: High

**Files to Create**:
- Update `H0UND/Services/HealthCheckService.cs`
- `C0MMON/Interfaces/IOBSClient.cs`

**Implementation Spec**:
```csharp
public async Task<HealthCheck> CheckVisionStreamHealth()
{
    bool isStreaming = await _obsClient.IsStreamActiveAsync();
    return new HealthCheck
    {
        Component = "VisionStream",
        Status = isStreaming ? HealthStatus.Healthy : HealthStatus.Unhealthy,
        Message = isStreaming ? "OBS streaming active" : "No vision stream detected",
        ResponseTimeMs = await _obsClient.GetLatencyAsync()
    };
}
```

---

### Track 3: W4TCHD0G - Vision Infrastructure

#### FOUREYES-005: OBS Vision Bridge
**Status**: In Progress | **Priority**: Critical

**Files to Create**:
- `W4TCHD0G/OBSVisionBridge.cs`
- `C0MMON/Interfaces/IOBSClient.cs`
- `UNI7T35T/FourEyes/OBSVisionBridgeTests.cs`
- `huggingface_models.json`

**Implementation Spec**:
```csharp
public class OBSVisionBridge : IOBSClient
{
    private readonly WebSocket _ws;
    private readonly List<VisionEvent> _eventHistory = new();
    
    public async Task ConnectAsync()
    {
        // Connect to ws://localhost:4455
        // Subscribe to scene changes
        // Start frame capture at 2 FPS
    }
    
    private void ProcessFrame(List<Source> sources, long timestamp)
    {
        var frame = new VisionEvent
        {
            Timestamp = timestamp,
            JackpotValues = ExtractJackpotValues(sources),
            UIState = DetectUIState(sources),
            AnimationState = DetectAnimation(sources),
            ErrorIndicators = DetectErrors(sources)
        };
        
        _eventHistory.Add(frame);
        if (_eventHistory.Count > 20) // 10 seconds at 2 FPS
            _eventHistory.RemoveAt(0);
    }
}
```

**Acceptance Criteria**:
- [ ] Connects to OBS WebSocket
- [ ] Captures frames at 2 FPS
- [ ] Extracts jackpot values
- [ ] Maintains 10-second buffer
- [ ] Thread-safe operations

---

#### FOUREYES-006: LM Studio Client
**Status**: Proposed | **Priority**: Critical

**Files to Create**:
- `W4TCHD0G/LMStudioClient.cs`
- `W4TCHD0G/ModelRouter.cs`
- `UNI7T35T/FourEyes/LMStudioClientTests.cs`

**Implementation Spec**:
```csharp
public class LMStudioClient : ILMStudioClient
{
    private readonly HttpClient _httpClient;
    private readonly ModelRoutingConfig _routing;
    
    public async Task<TResponse> ExecuteAsync<TRequest>(string taskType, TRequest request)
    {
        // Route to appropriate model based on taskType
        // vision_ocr -> TROCR
        // vision_state -> DiT
        // animation -> NV-DINO
        // error -> OWL-ViT
    }
}
```

**Configuration** (`huggingface_models.json`):
```json
{
  "vision_ocr": "microsoft/trocr-base-handwritten",
  "vision_state": "microsoft/dit-base-finetuned",
  "animation": "nvidia/nvdino",
  "error": "google/owlvit-base-patch32"
}
```

---

## Phase 2: Vision Brain (Ready to Start)

#### FOUREYES-007: Event Buffer
**Status**: Proposed | **Priority**: High

**Files to Create**:
- `C0MMON/Infrastructure/EventBuffer.cs`
- `C0MMON/Interfaces/IEventBuffer.cs`
- `C0MMON/Entities/VisionEvent.cs`
- `UNI7T35T/FourEyes/EventBufferTests.cs`

**Implementation Spec**:
```csharp
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
}
```

---

#### FOUREYES-008: Vision Decision Engine
**Status**: Proposed | **Priority**: Critical

**Files to Create**:
- `H0UND/Services/VisionDecisionEngine.cs`
- `C0MMON/Interfaces/IVisionDecisionEngine.cs`
- `C0MMON/Entities/Decision.cs`
- `UNI7T35T/FourEyes/VisionDecisionEngineTests.cs`

**Implementation Spec**:
```csharp
public class VisionDecisionEngine : IVisionDecisionEngine
{
    private readonly ILMStudioClient _hfClient;
    private readonly IOBSClient _obsClient;
    private readonly IEventBuffer _eventBuffer;
    
    public async Task AnalyzeStreamAsync(CancellationToken token)
    {
        while (!token.IsCancellationRequested)
        {
            var frame = await _obsClient.GetLatestFrameAsync();
            var analysis = await _hfClient.AnalyzeAsync(frame);
            _eventBuffer.Add(analysis);
            
            if (_eventBuffer.Count >= 10)
            {
                var decision = await MakeVisionDecisionAsync();
                if (decision != null)
                    await _signalService.QueueSignalAsync(decision.Signal);
            }
            
            await Task.Delay(500, token); // 2 FPS
        }
    }
    
    private async Task<Decision?> MakeVisionDecisionAsync()
    {
        var recent = _eventBuffer.GetRecent(10);
        
        // Detect patterns
        bool jackpotIncrementing = recent.Any(e => e.JackpotIncrease > 0);
        bool isSpinning = recent.All(e => e.AnimationState == AnimationType.Spinning);
        bool jackpotPopped = recent.Any(e => e.JackpotResetDetected);
        
        // Make decision based on patterns
    }
}
```

---

## Phase 3: Risk Mitigation (Ready to Start)

#### FOUREYES-009: Shadow Gauntlet
**Status**: Proposed | **Priority**: High

**Files to Create**:
- `PROF3T/ShadowModeManager.cs`
- `C0MMON/Interfaces/IShadowModeManager.cs`
- `C0MMON/Entities/ShadowValidationResult.cs`
- `UNI7T35T/FourEyes/ShadowModeManagerTests.cs`

**Implementation Spec**:
```csharp
public class ShadowModeManager : IShadowModeManager
{
    public async Task<ShadowValidationResult> RunShadowModeAsync(
        string newModelId, 
        TimeSpan duration)
    {
        // Run new model in parallel with primary for 24 hours
        // Log all decisions but don't execute
        // Compare accuracy and latency
        // Promote if >95% accuracy AND 10% lower latency
    }
}
```

---

#### FOUREYES-010: Cerberus Protocol
**Status**: Proposed | **Priority**: High

**Files to Create**:
- `W4TCHD0G/OBSHealer.cs`
- `C0MMON/Interfaces/IOBSHealer.cs`
- `UNI7T35T/FourEyes/OBSHealerTests.cs`

**Three-Headed Response**:
```csharp
public async Task<bool> HealAsync()
{
    // Head 1: Restart OBS process
    var restartSuccess = await RestartOBSAsync();
    if (!restartSuccess) return false;
    
    // Head 2: Verify scene and sources
    var verifySuccess = await VerifySceneAsync();
    if (!verifySuccess) return false;
    
    // Head 3: Test stream (implicit in verification)
    return true;
}
```

---

## Phase 4: Autonomous Learning (Ready to Start)

#### FOUREYES-013: Model Manager
**Status**: Proposed | **Priority**: High

**Files to Create**:
- `PROF3T/ModelManager.cs`
- `C0MMON/Interfaces/IModelManager.cs`
- `C0MMON/Entities/ModelInstance.cs`

#### FOUREYES-014: Autonomous Learning System
**Status**: Proposed | **Priority**: High

**Files to Create**:
- `PROF3T/AutonomousLearningSystem.cs`
- `C0MMON/Interfaces/IAutonomousLearningSystem.cs`
- `C0MMON/Entities/ModelPerformance.cs`

**Learning Loop**:
```csharp
public async Task ImproveModelsAsync()
{
    // Analyze 7 days of decisions
    // Find models with accuracy <70% or latency >500ms
    // Trigger Shadow Gauntlet for replacements
    // Request consensus before applying changes
}
```

---

## Phase 5: Deployment (Ready to Start)

#### FOUREYES-017: Production Metrics
**Status**: Proposed | **Priority**: High

**Metrics to Track**:
- Vision Stream Uptime >99.9%
- OCR Accuracy >95%
- Decision Latency <100ms
- Worker Utilization 60-80%
- Signal Accuracy >85%

#### FOUREYES-018: Rollback Manager
**Status**: Proposed | **Priority**: High

**Rollback Triggers**:
- Vision stream down >5 min
- OCR accuracy <80%
- Model hallucinations detected
- Decision latency >1s

#### FOUREYES-019: Phased Rollout
**Status**: Proposed | **Priority**: High

**Rollout Plan**:
1. **Canary (10%)**: 24 hours monitoring
2. **Gradual (50%)**: 48 hours monitoring
3. **Full (100%)**: Complete deployment

---

## Testing Strategy

### Unit Tests (Per Decision)
Each decision MUST have corresponding unit tests:

```csharp
// Example pattern for all tests
public class {DecisionName}Tests
{
    [Fact] public void {Method}_{Condition}_{ExpectedResult}()
    [Fact] public void {Method}_{EdgeCase}_{ExpectedResult}()
    [Fact] public void {Method}_{FailureMode}_{ExpectedResult}()
}
```

### Integration Tests
```csharp
public class VisionIntegrationTests
{
    [Fact] public async Task FullPipeline_VisionToSignal_EndToEnd()
    [Fact] public async Task Fallback_StreamFailure_SwitchesToPolling()
    [Fact] public async Task Redundancy_MultipleStreams_Consensus()
}
```

---

## Implementation Order

### Week 1-2: Phase 1 Foundation
1. FOUREYES-001: Circuit Breaker (Day 1-2)
2. FOUREYES-002: System Degradation (Day 1-2)
3. FOUREYES-003: Operation Tracker (Day 1-2)
4. FOUREYES-005: OBS Vision Bridge (Day 3-5)
5. FOUREYES-006: LM Studio Client (Day 3-5)
6. Unit tests for all above

### Week 3-4: Phase 2 Brain
7. FOUREYES-007: Event Buffer (Day 1-2)
8. FOUREYES-008: Vision Decision Engine (Day 3-6)
9. Unit tests and integration tests

### Week 5-6: Phase 3 Risk Mitigation
10. FOUREYES-009: Shadow Gauntlet (Day 1-3)
11. FOUREYES-010: Cerberus Protocol (Day 1-3)
12. FOUREYES-011: Unbreakable Contract (Day 3-4)
13. FOUREYES-012: Stream Health Monitor (Day 3-4)
14. Unit tests

### Week 7-8: Phase 4 Autonomy
15. FOUREYES-013: Model Manager (Day 1-3)
16. FOUREYES-014: Autonomous Learning (Day 1-3)
17. FOUREYES-015: H4ND Commands (Day 3-4)
18. FOUREYES-016: Redundant Vision (Day 3-5)
19. Unit tests

### Week 9-10: Phase 5 Deployment
20. FOUREYES-017: Production Metrics (Day 1-3)
21. FOUREYES-018: Rollback Manager (Day 1-3)
22. FOUREYES-019: Phased Rollout (Day 3-4)
23. FOUREYES-020: Test Suite Finalization (Ongoing)
24. Full system integration tests

---

## Critical Success Factors

1. **Unit Tests First**: Every component tested before integration
2. **Interface Contracts**: All communication through C0MMON interfaces
3. **Parallel Tracks**: Maximize velocity with parallel implementation
4. **Early Integration**: Integrate components as they complete
5. **Monitoring**: Metrics from day one
6. **Rollback Ready**: Rollback capability at every phase

---

## Contact

For questions or clarifications:
- Strategic oversight: @strategist
- Architecture review: @designer
- Risk assessment: @oracle
- Implementation: @fixer

---

*Ready for Fixer implementation*
*All decisions have detailed specifications*
*Unit test requirements defined*

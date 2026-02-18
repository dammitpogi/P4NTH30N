# P4NTH30N Implementation Plan: Four-Eyes Vision System

**Status:** Planning Phase  
**Source:** D3CISI0NS Collection (DECISION_001 - DECISION_012)  
**Reference:** KIMI_signalPlan.md, DESIGNER_BUILD_GUIDE.md

---

## Overview

This document provides actionable implementation plans for all 12 approved decisions. Each decision includes:
- **Target Location**: Where to create/modify files
- **Dependencies**: What must exist first
- **Implementation Steps**: Sequential tasks
- **Integration Points**: How to connect to existing code

---

## Phase 1: Production Hardening (DECISION_001 - DECISION_004)

### DECISION_001: Circuit Breaker Pattern Implementation

**Description:** Circuit breakers with 3-failure threshold, 5-minute recovery, Closed/Open/HalfOpen states.

**Target Files:**
```
C0MMON/
├── Infrastructure/
│   └── Resilience/
│       ├── CircuitBreaker.cs          [NEW]
│       ├── ICircuitBreaker.cs         [NEW]
│       └── CircuitBreakerOpenException.cs [NEW - can be in CircuitBreaker.cs]
```

**Implementation Steps:**
1. Create `C0MMON/Infrastructure/Resilience/` directory
2. Implement `CircuitBreaker<T>` generic class with:
   - `CircuitState` enum (Closed, Open, HalfOpen)
   - `ExecuteAsync(Func<Task<T>>)` method
   - Thread-safe state management with `lock`
   - Configurable threshold and timeout
3. Create `ICircuitBreaker` interface for DI
4. Add `CircuitBreakerOpenException` for caller handling

**Integration Points:**
- `H0UND/H0UND.cs` - Wrap API calls in circuit breaker
- `H4ND/H4ND.cs` - Wrap Selenium automation
- `C0MMON/Infrastructure/Persistence/` - Wrap MongoDB operations

**Code Pattern:**
```csharp
// Registration in DI
services.AddSingleton<CircuitBreaker<HttpResponseMessage>>(_ => 
    new CircuitBreaker<HttpResponseMessage>(
        failureThreshold: 3,
        recoveryTimeout: TimeSpan.FromMinutes(5),
        logger: msg => Console.WriteLine(msg)
    ));

// Usage
var apiBreaker = serviceProvider.GetRequiredService<CircuitBreaker<HttpResponseMessage>>();
var response = await apiBreaker.ExecuteAsync(() => httpClient.GetAsync(url));
```

---

### DECISION_002: Graceful Degradation Strategies

**Description:** 4-level degradation (Normal/Reduced/Minimal/Emergency) with automatic triggers.

**Target Files:**
```
C0MMON/
├── Infrastructure/
│   └── Resilience/
│       ├── DegradationLevel.cs        [NEW]
│       ├── SystemMetrics.cs           [NEW]
│       ├── SystemDegradationManager.cs [NEW]
│       └── IDegradationManager.cs     [NEW]
```

**Implementation Steps:**
1. Create `DegradationLevel` enum
2. Create `SystemMetrics` record to capture:
   - `APILatency` (ms)
   - `WorkerUtilization` (0-100%)
   - `ErrorRate` (0-100%)
3. Implement `SystemDegradationManager`:
   - `CheckDegradation(SystemMetrics)` - evaluate and transition
   - `ApplyDegradationLevel(DegradationLevel)` - execute level changes
   - Event `OnDegradationChanged` for subscribers

**Degradation Triggers (from D3CISI0NS):**
| Level | API Latency | Worker Util | Behavior |
|-------|-------------|-------------|----------|
| Normal | < 500ms | < 60% | Full signal generation |
| Reduced | > 500ms | > 60% | Batch signals, 70% capacity |
| Minimal | > 1000ms | > 80% | Priority 3-5 only, 50% capacity |
| Emergency | > 2000ms | > 90% | Halt automation |

**Integration Points:**
- `H0UND/H0UND.cs` - Call `CheckDegradation()` in main loop
- `H4ND/H4ND.cs` - Listen to `OnDegradationChanged` for capacity scaling

---

### DECISION_003: Idempotency Guarantees (OperationTracker)

**Description:** 5-minute TTL deduplication to prevent duplicate operations.

**Target Files:**
```
C0MMON/
├── Infrastructure/
│   └── Resilience/
│       ├── OperationTracker.cs        [NEW]
│       └── IOperationTracker.cs       [NEW]
```

**Implementation Steps:**
1. Create `IOperationTracker` interface:
   - `bool TryRegisterOperation(string operationId)`
   - `bool IsRegistered(string operationId)`
2. Implement `OperationTracker` using:
   - In-memory `ConcurrentDictionary` with expiration
   - Or Redis if available (for distributed systems)
3. Generate operation IDs using pattern: `signal:{jackpot_id}:{timestamp_minute}`

**Code Pattern:**
```csharp
// Usage in SignalService
string operationId = $"signal:{jackpot._id}:{DateTime.UtcNow.Ticks / TimeSpan.TicksPerMinute}";
if (!_tracker.TryRegisterOperation(operationId))
{
    continue; // Skip duplicate
}
```

**Integration Points:**
- `H0UND/Services/SignalService.cs` - Wrap signal generation
- Any operation that must not be duplicated

---

### DECISION_004: Health Check Framework

**Description:** Comprehensive health monitoring for MongoDB, APIs, WorkerPool, DecisionBuffer, VisionStream.

**Target Files:**
```
C0MMON/
├── Monitoring/
│   ├── HealthCheckService.cs          [NEW - extends existing]
│   ├── IHealthCheckService.cs         [NEW]
│   ├── HealthCheck.cs                 [NEW]
│   ├── SystemHealth.cs                [NEW]
│   └── HealthStatus.cs                [NEW]
```

**Existing Code to Integrate:**
- `C0MMON/Monitoring/DataCorruptionMonitor.cs` - has `PerformHealthCheck`
- `H4ND/H4ND.cs:49` - has `lastHealthCheck` timer
- `H0UND/H0UND.cs:58` - has `lastHealthCheck` timer

**Implementation Steps:**
1. Create unified `HealthStatus` enum (Healthy, Degraded, Unhealthy)
2. Create `HealthCheck` and `SystemHealth` records
3. Implement `IHealthCheckService` with methods:
   - `Task<SystemHealth> GetSystemHealthAsync()`
   - `Task<HealthCheck> CheckMongoDBHealth()`
   - `Task<HealthCheck> CheckExternalAPIHealth()`
   - `Task<HealthCheck> CheckWorkerPoolHealth()`
   - `Task<HealthCheck> CheckVisionStreamHealth()` (NEW)
4. Refactor existing health check code to use new service

**VisionStream Health Check:**
```csharp
private async Task<HealthCheck> CheckVisionStreamHealth()
{
    bool isStreaming = await _obsClient.IsStreamActiveAsync();
    return new HealthCheck
    {
        Component = "VisionStream",
        Status = isStreaming ? HealthStatus.Healthy : HealthStatus.Unhealthy,
        Message = isStreaming ? "OBS streaming active" : "No vision stream detected"
    };
}
```

---

## Phase 2: Vision Infrastructure (DECISION_005 - DECISION_007)

### DECISION_005: Vision-Based Automation Strategy

**Description:** Use OBS video streams for continuous temporal monitoring instead of static screenshots.

**Target Files:**
```
W4TCHD0G/                              [NEW PROJECT]
├── W4TCHD0G.csproj
├── IOBSClient.cs
├── ILMStudioClient.cs
├── Models/
│   ├── VisionFrame.cs
│   ├── VisionAnalysis.cs
│   └── AnimationState.cs
└── Configuration/
    └── VisionConfig.cs
```

**Implementation Steps:**
1. Create new `W4TCHD0G` project (class library)
2. Define interfaces `IOBSClient` and `ILMStudioClient`
3. Create model classes for vision data
4. Configure 2 FPS frame capture rate
5. Implement frame buffering (10 frames = 5 seconds)

**Key Design Decisions:**
- Frame rate: 2 FPS (500ms interval)
- Buffer size: 10 frames (5 seconds of history)
- No video files - real-time processing only

---

### DECISION_006: OBS Integration Architecture

**Description:** H0UND orchestrator with Vision Processing Layer connecting OBS → LM Studio → Decision Engine.

**Target Files:**
```
W4TCHD0G/
├── OBSVisionBridge.cs                 [NEW]
├── OBSClient.cs                       [NEW]
└── Configuration/
    └── OBSConfig.cs                   [NEW]
```

**Implementation Steps:**
1. Add WebSocketSharp or System.Net.WebSockets dependency
2. Implement `OBSClient`:
   - Connect to `ws://localhost:4455`
   - Subscribe to scene changes
   - Capture frames at 2 FPS
3. Implement `OBSVisionBridge`:
   - `processFrame(sources, timestamp)`
   - `extractJackpotValues(sources)`
   - `detectUIState(sources)`
   - `detectAnimation(sources)`
4. Add fallback mode trigger after 10 consecutive failures

**WebSocket Protocol:**
```javascript
// Connection
await ws.connect('ws://localhost:4455');
await ws.send('GetSceneList');
await ws.send('GetSourceList');

// Frame capture interval
setInterval(() => processFrame(...), 500); // 2 FPS
```

---

### DECISION_007: Vision Model Selection - Hugging Face

**Description:** Lightweight models - TROCR (OCR), DiT (UI State), NV-DINO (Animation), OWL-ViT (Error Detection).

**Target Files:**
```
W4TCHD0G/
├── LMStudioClient.cs                  [NEW]
├── ModelRouter.cs                     [NEW]
├── Configuration/
│   └── huggingface_models.json        [NEW]
└── Models/
    ├── ModelAssignment.cs
    └── ModelPerformance.cs
```

**Model Configuration:**
```json
{
  "vision_ocr": {
    "model_id": "microsoft/trocr-base-handwritten",
    "size": "58MB",
    "latency_target_ms": 100,
    "device": "cpu"
  },
  "vision_state": {
    "model_id": "microsoft/dit-base-finetuned",
    "size": "1.5GB",
    "latency_target_ms": 50,
    "device": "cpu"
  },
  "animation_detection": {
    "model_id": "nvidia/nvdino",
    "size": "600MB",
    "latency_target_ms": 30,
    "device": "cpu"
  },
  "error_detection": {
    "model_id": "google/owlvit-base-patch32",
    "size": "1.1GB",
    "latency_target_ms": 40,
    "device": "cpu"
  }
}
```

**Implementation Steps:**
1. Create `huggingface_models.json` config
2. Implement `LMStudioClient` with HTTP API calls
3. Implement `ModelRouter` for task-based model selection
4. Add model caching and download logic

---

## Phase 3: Autonomy (DECISION_008 - DECISION_011)

### DECISION_008: LM Studio + Hugging Face Autonomous Architecture

**Description:** Model cascade routing - vision tasks → TROCR/NV-DINO, simple decisions → phi-2-mini, complex → Mistral-7B.

**Target Files:**
```
C0MMON/
├── Services/
│   └── AI/
│       ├── IModelRouter.cs            [NEW]
│       ├── ModelRouter.cs             [NEW]
│       └── ModelRoutingConfig.cs      [NEW]
```

**Routing Configuration:**
```json
{
  "strategy": "model_cascade",
  "rules": [
    { "condition": "vision_analysis_required", "route_to": "vision_ocr" },
    { "condition": "ui_state_detection", "route_to": "vision_state" },
    { "condition": "simple_decision_required", "route_to": "decision_simple" },
    { "condition": "complex_decision_required", "route_to": "decision_complex" }
  ],
  "models": {
    "decision_simple": "microsoft/phi-2-mini",
    "decision_complex": "mistralai/Mistral-7B-Instruct-v0.2"
  }
}
```

---

### DECISION_009: Autonomous Decision Flow

**Description:** Model Router → Consensus Engine → Confidence Calculator → Action Router.

**Target Files:**
```
H0UND/
├── Services/
│   ├── VisionDecisionEngine.cs        [NEW]
│   ├── ConsensusEngine.cs             [NEW]
│   ├── DecisionConfidenceCalculator.cs [NEW]
│   └── ActionRouter.cs                [NEW]
├── Domain/
│   ├── Decision.cs                    [NEW]
│   ├── DecisionContext.cs             [NEW]
│   └── DecisionRationale.cs           [NEW]
C0MMON/
├── Infrastructure/
│   └── EventBuffer.cs                 [NEW]
```

**Implementation Steps:**
1. Create `EventBuffer` in C0MMON (thread-safe, 10-second window)
2. Implement `VisionDecisionEngine`:
   - `AnalyzeStreamAsync(CancellationToken)`
   - `MakeVisionDecisionAsync()`
   - `HandleJackpotPopAsync()`
3. Implement `ConsensusEngine` for weighted voting
4. Implement `ActionRouter` (Execute/Queue/Fallback)

---

### DECISION_010: Model Management System

**Description:** On-demand loading, caching, usage tracking, auto-download from Hugging Face.

**Target Files:**
```
PROF3T/                                [NEW PROJECT - "Prophet"]
├── PROF3T.csproj
├── ModelManager.cs                    [NEW]
├── IModelManager.cs                   [NEW]
├── ModelInstance.cs                   [NEW]
└── Configuration/
    └── ModelCacheConfig.cs            [NEW]
```

**Implementation Steps:**
1. Create `PROF3T` project
2. Implement `ModelManager`:
   - `ExecuteAsync<TRequest>(taskType, request)`
   - `LoadModelAsync(modelId)` - with Hugging Face download
   - `TrackModelUsageAsync(modelId, request, response)`
3. Configure cache path: `AppConfig.ModelCachePath`

---

### DECISION_011: Autonomous Learning Loop

**Description:** 7-day analysis window, 70% accuracy threshold, 500ms latency threshold, consensus required for replacement.

**Target Files:**
```
PROF3T/
├── AutonomousLearningSystem.cs        [NEW]
├── ShadowModeManager.cs               [NEW]
├── ModelPerformanceTracker.cs         [NEW]
└── IModelRegistry.cs                  [NEW]
```

**Performance Thresholds:**
- Accuracy: < 70% triggers review
- Latency: > 500ms triggers review
- Analysis window: 7 days
- Consensus required before model replacement

**Implementation Steps:**
1. Implement `ModelPerformanceTracker` to collect metrics
2. Implement `AutonomousLearningSystem`:
   - `ImproveModelsAsync()` - analyze and suggest
   - `UpdateModelRouteAsync(oldModel, newModel)` - with consensus
3. Implement `ShadowModeManager`:
   - Run new models in parallel (no execution)
   - Compare shadow vs primary decisions
   - Promote after 24h if > 95% accuracy AND 10% faster

---

## Phase 4: Deployment (DECISION_012)

### DECISION_012: Phased Rollout Plan

**Description:** 4-phase deployment over 8 weeks.

**Timeline:**

| Phase | Timeline | Focus | Key Deliverables |
|-------|----------|-------|------------------|
| 1 | Week 1-2 | Vision Infrastructure | OBS + LM Studio, HuggingFace models |
| 2 | Week 3-4 | Vision Decision Engine | Decision logic, fallback mechanisms |
| 3 | Week 5-6 | Full Autonomy | Learning loop, model replacement |
| 4 | Week 7-8 | Optimization | Fine-tuning, scaling, monitoring |

**Rollback Procedures:**

| Condition | Action | Recovery Time |
|-----------|--------|---------------|
| Vision stream down > 5 min | Disable vision, enable polling | < 1 min |
| OCR accuracy < 80% | Switch to backup OCR model | < 30 sec |
| Model hallucinations | Rollback to previous model | < 2 min |
| Decision latency > 1s | Switch to CPU model | < 10 sec |

---

## File Creation Summary

### New Files Required

```
C0MMON/
├── Infrastructure/
│   └── Resilience/
│       ├── CircuitBreaker.cs          ✓ CREATED
│       ├── DegradationLevel.cs
│       ├── SystemMetrics.cs
│       ├── SystemDegradationManager.cs
│       ├── OperationTracker.cs
│       └── IOperationTracker.cs
├── Monitoring/
│   ├── HealthCheckService.cs
│   ├── HealthCheck.cs
│   ├── SystemHealth.cs
│   └── HealthStatus.cs
├── Services/
│   └── AI/
│       ├── ModelRouter.cs
│       └── ModelRoutingConfig.cs
└── Infrastructure/
    └── EventBuffer.cs

W4TCHD0G/                              [NEW PROJECT]
├── IOBSClient.cs
├── ILMStudioClient.cs
├── OBSClient.cs
├── OBSVisionBridge.cs
├── LMStudioClient.cs
├── ModelRouter.cs
├── Models/
│   ├── VisionFrame.cs
│   ├── VisionAnalysis.cs
│   └── AnimationState.cs
└── Configuration/
    ├── OBSConfig.cs
    └── huggingface_models.json

PROF3T/                                [NEW PROJECT]
├── ModelManager.cs
├── AutonomousLearningSystem.cs
├── ShadowModeManager.cs
└── ModelPerformanceTracker.cs

H0UND/
├── Services/
│   ├── VisionDecisionEngine.cs
│   ├── ConsensusEngine.cs
│   └── ActionRouter.cs
└── Domain/
    ├── Decision.cs
    ├── DecisionContext.cs
    └── DecisionRationale.cs
```

---

## Next Actions

1. **Review this plan** with Nexus
2. **Approve** to begin implementation
3. **Start Phase 1** - Production Hardening (DECISION_001-004)
4. **Create W4TCHD0G project** for Vision Infrastructure
5. **Create PROF3T project** for Autonomy/AI

---

*Generated from D3CISI0NS collection - All 12 decisions mapped*

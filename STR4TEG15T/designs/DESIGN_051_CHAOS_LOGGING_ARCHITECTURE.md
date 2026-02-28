# DESIGN_051: Universal Chaos Logging and Sanity Test Architecture

**Design ID**: DESIGN_051  
**Category**: INFRA  
**Priority**: Critical  
**Date**: 2026-02-23  
**Status**: Draft  
**Target**: H0UND, H4ND, FireKirin Components  

---

## Executive Summary

This design establishes a universal event logging and sanity test data collection system for 30+ chaos points across H0UND (analytics/polling engine), H4ND (automation), and FireKirin (login automation) components. The system provides comprehensive diagnostics, performance monitoring, and anomaly detection capabilities while maintaining high performance under load.

**Key Challenges**:
- 30+ distinct chaos point types with varying event frequencies
- Correlation across H0UND/H4ND/FireKirin boundaries
- Performance constraints (1000+ events/second at high-frequency locations)
- Integration with existing MongoDB infrastructure and CircuitBreaker patterns

**Solution**:
- Aspect-oriented logging with attribute-based instrumentation
- Distributed event correlation using session tracing
- Performance-optimized async logging with batching
- Configurable sampling and threshold management
- Comprehensive sanity test framework with pre/post condition validation

---

## 1. Entity Evaluation Matrix

### Chaos Point Categories and Data Requirements

| Category | Chaos Point Type | Examples | Required State Snapshots | Call Stack Depth | Timing Precision | Correlation IDs |
|----------|-----------------|----------|---------------------------|------------------|------------------|-----------------|
| **Service Lifecycle** | Race Conditions, Timer Conflicts | ServiceOrchestrator:116,144,181,217 | Service status, lock state, health check results | 2-3 frames | Millisecond | SessionId, ServiceName |
| **Data Mutation** | Lock Failures, Non-atomic Operations | LegacyRuntimeHost:262,413,578 | Credential state, signal queue, lock ownership | 3-5 frames | Microsecond | SessionId, SignalId |
| **Validation** | Type Casting, Value Coercion | OrionStarsBalanceProvider:11,17,23 | Input values, cast results, error details | Full stack | Millisecond | RequestId, CredentialId |
| **Workflow** | Login/Spin Execution | CdpGameActions:60-121 | Navigation state, DOM elements, response times | Full stack | Millisecond | SessionId, NavigationId |
| **Polling** | Infinite Loops, Dynamic Casting | PollingWorker:22,52,75,84 | Polling state, retry attempts, network response | 1-2 frames | Second | CredentialId, RequestId |
| **Persistence** | Check-then-write Race | Repositories.cs:178,183,190 | Document state, write result, exception details | 2-3 frames | Millisecond | DocumentId, SessionId |
| **Signal Handling** | Duplicate Ack, Ownership Flapping | SignalDistributor:52,58 | Signal state, ownership claim, distribution queue | 2-4 frames | Millisecond | SignalId, SessionId |
| **Parallel Processing** | Stale Object Overwrites | ParallelSpinWorker:167,245 | Worker state, object references, write result | 3-5 frames | Millisecond | WorkerId, SessionId |

### State Snapshot Guidelines

**High-Frequency Locations (PollingWorker, SignalDistributor)**:
- Minimal state snapshots (1-2 key variables)
- Call stack depth limited to 1-2 frames
- Aggregated metrics instead of individual events
- 1-second timing precision

**Critical Operations (LegacyRuntimeHost, ServiceOrchestrator)**:
- Complete state snapshots before/after operations
- Full call stack capture
- Microsecond precision timing
- Comprehensive error context

**Async Workflows (CdpGameActions, LoginPhase)**:
- Navigation state and DOM element references
- Async operation IDs and continuation tokens
- Response times and error codes
- User interaction context

---

## 1.1 H4ND Concurrency-Risk Hotspots (Top 5)

Ranked by blast radius and likelihood (shared-entity mutation + ordering hazards).

1. **Early signal ack before successful processing**
   - `H4ND/Services/LegacyRuntimeHost.cs:260-263`
   - Pattern: `uow.Signals.Acknowledge(signal)` occurs before login/query/spin pipeline completion.
   - Failure mode: work is lost if ack semantics imply “done”.

2. **Unlock before final credential persist**
   - `H4ND/Services/LegacyRuntimeHost.cs:578-601`
   - Pattern: unlock before final `LastUpdated/Balance` mutation and `Upsert`.
   - Failure mode: another worker observes intermediate/stale state and overwrites.

3. **Duplicate / ambiguous signal-ack ownership**
   - `H4ND/Services/LegacyRuntimeHost.cs:260-263`
   - `H4ND/Services/LegacyRuntimeHost.cs:413`
   - `H4ND/Infrastructure/SpinExecution.cs:53`
   - Pattern: ack performed at multiple layers.
   - Failure mode: non-idempotent ack yields state skew; ownership semantics drift.

4. **Broad signal deletion during tier transitions**
   - `H4ND/Services/LegacyRuntimeHost.cs:482`
   - `H4ND/Services/LegacyRuntimeHost.cs:507`
   - `H4ND/Services/LegacyRuntimeHost.cs:532`
   - `H4ND/Services/LegacyRuntimeHost.cs:557`
   - Pattern: `uow.Signals.DeleteAll(house, game)` inside tier branches.
   - Failure mode: high blast-radius data loss under concurrent workers.

5. **Parallel claim release + retry mutation under failures**
   - `H4ND/Parallel/ParallelSpinWorker.cs:218-220`
   - `H4ND/Parallel/ParallelSpinWorker.cs:235-237`
   - Pattern: `RetryCount++` + `ReleaseClaim(signal)` ordering on failure.
   - Failure mode: duplicate pickup / retry storms if claim is re-acquired early.

### Full H4ND Mutation-Dense Inventory (For Instrumentation)

- Main runtime loop: `H4ND/Services/LegacyRuntimeHost.cs:250-263`, `H4ND/Services/LegacyRuntimeHost.cs:413-428`, `H4ND/Services/LegacyRuntimeHost.cs:469-567`, `H4ND/Services/LegacyRuntimeHost.cs:575-582`, `H4ND/Services/LegacyRuntimeHost.cs:600`, `H4ND/Services/LegacyRuntimeHost.cs:854-855`, `H4ND/Services/LegacyRuntimeHost.cs:910`
- Parallel path: `H4ND/Parallel/ParallelSpinWorker.cs:167`, `H4ND/Parallel/ParallelSpinWorker.cs:183`, `H4ND/Parallel/ParallelSpinWorker.cs:218-220`, `H4ND/Parallel/ParallelSpinWorker.cs:235-237`, `H4ND/Parallel/ParallelSpinWorker.cs:245`
- Spin side effects: `H4ND/Infrastructure/SpinExecution.cs:53`, `H4ND/Infrastructure/SpinExecution.cs:66-68`, `H4ND/Infrastructure/SpinExecution.cs:77-90`
- Session renewal mutations: `H4ND/Services/SessionRenewalService.cs:57-64`, `H4ND/Services/SessionRenewalService.cs:73-79`, `H4ND/Services/SessionRenewalService.cs:181-186`, `H4ND/Services/SessionRenewalService.cs:200-201`, `H4ND/Services/SessionRenewalService.cs:247-249`
- Signal creation pipeline: `H4ND/Services/SignalGenerator.cs:64-69`, `H4ND/Services/SignalGenerator.cs:117-119`, `H4ND/Services/SignalGenerator.cs:79`, `H4ND/Services/SignalGenerator.cs:88`, `H4ND/Services/SignalGenerator.cs:124`, `H4ND/Services/SignalGenerator.cs:132`
- Domain aggregate mutation core: `H4ND/Domains/Automation/Aggregates/Credential.cs:114`, `H4ND/Domains/Automation/Aggregates/Credential.cs:128-133`, `H4ND/Domains/Automation/Aggregates/Credential.cs:143-151`

---

## 2. Universal Logging Interface Design

### Core Interface Hierarchy

```csharp
// ── Core Interfaces ──────────────────────────────────────────────────────
namespace P4NTHE0N.ChaosLogging;

/// <summary>
/// Main chaos logging interface for all event types
/// </summary>
public interface IChaosLogger : IAsyncDisposable
{
    // Event logging methods
    Task LogEventAsync(ChaosEvent @event, CancellationToken cancellationToken = default);
    Task LogBatchAsync(IEnumerable<ChaosEvent> events, CancellationToken cancellationToken = default);
    
    // Sanity test methods
    Task LogSanityTestAsync(SanityTest test, CancellationToken cancellationToken = default);
    Task LogSanityBatchAsync(IEnumerable<SanityTest> tests, CancellationToken cancellationToken = default);
    
    // Performance monitoring
    Task LogPerformanceAsync(PerformanceMetric metric, CancellationToken cancellationToken = default);
    
    // Correlation management
    string GenerateCorrelationId();
    IDisposable BeginCorrelation(string correlationId);
    
    // Configuration
    bool IsEnabled(string component);
    void SetSamplingRate(string component, double rate);
}

/// <summary>
/// Sanity test validation interface
/// </summary>
public interface ISanityTest
{
    string TestName { get; }
    string Component { get; }
    Task<SanityResult> ValidateAsync(object? context = null);
    Task<SanityResult> ValidatePostAsync(object? context = null);
}

/// <summary>
/// Performance sampling interface for high-frequency locations
/// </summary>
public interface IPerformanceSampler
{
    bool ShouldSample(string location, out double sampleRate);
    void RecordSample(string location, long durationTicks, bool success);
    PerformanceStats GetStats(string location);
}

/// <summary>
/// Distributed event correlation interface
/// </summary>
public interface IEventCorrelation
{
    string SessionId { get; }
    string? ParentCorrelationId { get; }
    void AddCorrelationData(string key, object value);
    Dictionary<string, object> GetCorrelationContext();
}

// ── Event Types ───────────────────────────────────────────────────────────
public record ChaosEvent
{
    public required string ChaosPointId { get; init; }
    public required string Component { get; init; }
    public required ChaosEventType Type { get; init; }
    public required DateTime Timestamp { get; init; }
    public required string Message { get; init; }
    public Dictionary<string, object>? Properties { get; init; }
    public Exception? Exception { get; init; }
    public required string CorrelationId { get; init; }
    public required string SessionId { get; init; }
    public string? StackTrace { get; init; }
    public int CallStackDepth { get; init; }
    public long ElapsedMicroseconds { get; init; }
}

public record SanityTest
{
    public required string TestName { get; init; }
    public required string Component { get; init; }
    public required object? PreCondition { get; init; }
    public required object? PostCondition { get; init; }
    public required SanityResult Result { get; init; }
    public required DateTime Timestamp { get; init; }
    public Dictionary<string, object>? Context { get; init; }
    public required string CorrelationId { get; init; }
    public required string SessionId { get; init; }
    public string? Diff { get; init; }
}

public record PerformanceMetric
{
    public required string OperationName { get; init; }
    public required string Location { get; init; }
    public required long DurationTicks { get; init; }
    public required bool Success { get; init; }
    public Dictionary<string, object>? Properties { get; init; }
    public required string CorrelationId { get; init; }
    public required string SessionId { get; init; }
}

public record SanityResult
{
    public required bool Passed { get; init; }
    public required string Message { get; init; }
    public Exception? Exception { get; init; }
    public Dictionary<string, object>? Metadata { get; init; }
}

// ── Enums ─────────────────────────────────────────────────────────────────
public enum ChaosEventType
{
    ServiceHealthCheck,
    ServiceRestart,
    RaceCondition,
    LockConflict,
    ValueCoercion,
    TypeCastError,
    InfiniteLoop,
    DataMutation,
    SignalDuplication,
    OwnershipFlapping,
    PersistenceRace,
    NetworkTimeout,
    AuthenticationFailure,
    NavigationError,
    SpinExecution,
    AnomalyDetection,
    CircuitBreakerTriggered,
    MemoryPressure,
    CPUOverload
}
```

### Aspect-Oriented Programming Attributes

```csharp
/// <summary>
/// Attribute for chaos point instrumentation
/// </summary>
[AttributeUsage(AttributeTargets.Method | AttributeTargets.Property, AllowMultiple = true)]
public class ChaosPointAttribute : Attribute
{
    public required string ChaosPointId { get; init; }
    public required string Component { get; init; }
    public ChaosEventType Type { get; init; } = ChaosEventType.DataMutation;
    public bool CaptureStackTrace { get; init; } = false;
    public bool CaptureState { get; init; } = true;
    public int CallStackDepth { get; init; } = 2;
    public double SampleRate { get; init; } = 1.0;
    public string? CorrelationSource { get; init; }
}

/// <summary>
/// Attribute for sanity test validation
/// </summary>
[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
public class SanityTestAttribute : Attribute
{
    public required string TestName { get; init; }
    public required string Component { get; init; }
    public bool ValidatePreCondition { get; init; } = true;
    public bool ValidatePostCondition { get; init; } = true;
    public SanityLevel Level { get; init; } = SanityLevel.Critical;
}

/// <summary>
/// Attribute for performance sampling
/// </summary>
[AttributeUsage(AttributeTargets.Method)]
public class PerformanceSampleAttribute : Attribute
{
    public required string OperationName { get; init; }
    public double SampleRate { get; init; } = 0.1; // 10% sampling
    public string? Location { get; init; }
}

public enum SanityLevel
{
    Critical = 1,
    High = 2,
    Medium = 3,
    Low = 4,
    Info = 5
}
```

---

## 3. MongoDB Schema for `_debug` Collection

### Collection Schema

```json
{
  "_id": ObjectId("65a8b3c9f3d4b8e8c4c5a6b1"),
  "Name": "H4ND Automation",
  "SessionId": "session-2026-02-23T14:30:15Z",
  "StartTime": ISODate("2026-02-23T14:30:15.123Z"),
  "EndTime": ISODate("2026-02-23T14:35:20.456Z"),
  "Metadata": {
    "Version": "1.0.0",
    "Environment": "production",
    "Component": "H4ND",
    "Host": "server-01",
    "User": "automation-user"
  },
  "Events": [
    {
      "Id": ObjectId("65a8b3c9f3d4b8e8c4c5a6b2"),
      "ChaosPointId": "H0UND-SVC-001",
      "Component": "ServiceOrchestrator",
      "Type": "ServiceHealthCheck",
      "Timestamp": ISODate("2026-02-23T14:30:15.234Z"),
      "Message": "Service failed health check",
      "Properties": {
        "ServiceName": "PollingWorker",
        "Failures": 2,
        "Status": "Running",
        "HealthCheckDurationMs": 150
      },
      "Exception": null,
      "CorrelationId": "corr-12345",
      "SessionId": "session-2026-02-23T14:30:15Z",
      "StackTrace": null,
      "CallStackDepth": 2,
      "ElapsedMicroseconds": 234000
    }
  ],
  "SanityChecks": [
    {
      "Id": ObjectId("65a8b3c9f3d4b8e8c4c5a6b3"),
      "TestName": "CredentialLockValidation",
      "Component": "LegacyRuntimeHost",
      "PreCondition": {
        "CredentialId": "cred-123",
        "LockState": "Locked",
        "SignalCount": 1
      },
      "PostCondition": {
        "CredentialId": "cred-123",
        "LockState": "Unlocked",
        "SignalCount": 0
      },
      "Result": {
        "Passed": true,
        "Message": "Credential lock/unlock successful",
        "Metadata": {
          "LockDurationMs": 45,
          "MutationCount": 1
        }
      },
      "Timestamp": ISODate("2026-02-23T14:30:15.456Z"),
      "Context": {
        "Operation": "SignalProcessing",
        "Priority": 2
      },
      "Diff": null,
      "CorrelationId": "corr-12345",
      "SessionId": "session-2026-02-23T14:30:15Z"
    }
  ],
  "PerformanceMetrics": [
    {
      "Id": ObjectId("65a8b3c9f3d4b8e8c4c5a6b4"),
      "OperationName": "PollingWorker.QueryBalances",
      "Location": "PollingWorker.cs:26",
      "DurationTicks": 23456789,
      "Success": true,
      "Properties": {
        "CredentialId": "cred-456",
        "NetworkAttempts": 1,
        "ResponseTimeMs": 234
      },
      "Timestamp": ISODate("2026-02-23T14:30:15.567Z"),
      "CorrelationId": "corr-12345",
      "SessionId": "session-2026-02-23T14:30:15Z"
    }
  ],
  "CorrelationContext": {
    "SessionId": "session-2026-02-23T14:30:15Z",
    "ParentSessionId": "parent-session-123",
    "UserId": "user-456",
    "Component": "H4ND-Automation",
    "Workflow": "SpinExecution",
    "NavigationId": "nav-789"
  },
  "Aggregates": {
    "EventCounts": {
      "ServiceHealthCheck": 15,
      "DataMutation": 234,
      "SignalDuplication": 3,
      "PersistenceRace": 2
    },
    "PerformanceStats": {
      "PollingWorker_QueryBalances_AvgMs": 234.5,
      "LegacyRuntimeHost_SignalProcess_AvgMs": 45.2
    },
    "SanityResults": {
      "Passed": 98,
      "Failed": 2,
      "PassRate": 0.98
    }
  },
  "SystemMetrics": {
    "CpuUsage": 15.2,
    "MemoryUsageMB": 1024,
    "ThreadCount": 24,
    "GarbageCollections": 45
  },
  "Index": {
    "Component": "H4ND",
    "Date": ISODate("2026-02-23T00:00:00Z")
  }
}
```

### Index Configuration

```javascript
// TTL index for automatic cleanup (30 days)
db._debug.createIndex({ "StartTime": 1 }, { 
    expireAfterSeconds: 2592000,
    name: "idx_ttl_starttime"
});

// Query optimization indexes
db._debug.createIndex({ "SessionId": 1, "Component": 1, "Events.Timestamp": -1 }, {
    name: "idx_session_component_events",
    partialFilterExpression: { "Events": { $exists: true } }
});

db._debug.createIndex({ "SessionId": 1, "SanityChecks.TestName": 1 }, {
    name: "idx_session_sanity_test",
    partialFilterExpression: { "SanityChecks": { $exists: true } }
});

db._debug.createIndex({ "SessionId": 1, "PerformanceMetrics.OperationName": 1 }, {
    name: "idx_session_performance",
    partialFilterExpression: { "PerformanceMetrics": { $exists: true } }
});

db._debug.createIndex({ "Events.Type": 1, "Events.Timestamp": -1 }, {
    name: "idx_event_type_time",
    partialFilterExpression: { "Events": { $exists: true } }
});

db._debug.createIndex({ "SanityChecks.Result.Passed": 1, "SanityChecks.Timestamp": -1 }, {
    name: "idx_sanity_result_time",
    partialFilterExpression: { "SanityChecks": { $exists: true } }
});

// Correlation index for distributed tracing
db._debug.createIndex({ "Events.CorrelationId": 1, "Events.Timestamp": -1 }, {
    name: "idx_correlation_time",
    partialFilterExpression: { "Events": { $exists: true } }
});

// Component-specific indexes for performance
db._debug.createIndex({ "Component": 1, "StartTime": -1 }, { name: "idx_component_time" });
db._debug.createIndex({ "Metadata.Host": 1, "StartTime": -1 }, { name: "idx_host_time" });
```

### Aggregation Pipeline for Analysis

```javascript
// Anomaly detection pipeline
const anomalyPipeline = [
    { $match: { "Events.Type": { $in: ["RaceCondition", "LockConflict", "InfiniteLoop"] } } },
    { $unwind: "$Events" },
    { $match: { "Events.Type": { $in: ["RaceCondition", "LockConflict", "InfiniteLoop"] } } },
    { $group: {
        _id: {
            component: "$Events.Component",
            type: "$Events.Type",
            day: { $dateTrunc: { date: "$Events.Timestamp", unit: "day" } }
        },
        count: { $sum: 1 },
        avgDuration: { $avg: "$Events.ElapsedMicroseconds" }
    } },
    { $sort: { count: -1 } }
];

// Performance analysis pipeline
const performancePipeline = [
    { $match: { "PerformanceMetrics.Success": true } },
    { $unwind: "$PerformanceMetrics" },
    { $group: {
        _id: "$PerformanceMetrics.OperationName",
        avgDuration: { $avg: { $divide: ["$PerformanceMetrics.DurationTicks", 10000] } },
        count: { $sum: 1 },
        p95Duration: { $percentile: { input: { $divide: ["$PerformanceMetrics.DurationTicks", 10000] }, p: 0.95 } }
    } },
    { $sort: { avgDuration: -1 } }
];

// Sanity test analysis pipeline
const sanityPipeline = [
    { $unwind: "$SanityChecks" },
    { $group: {
        _id: {
            test: "$SanityChecks.TestName",
            component: "$SanityChecks.Component",
            day: { $dateTrunc: { date: "$SanityChecks.Timestamp", unit: "day" } }
        },
        passed: { $sum: { $cond: ["$SanityChecks.Result.Passed", 1, 0] } },
        failed: { $sum: { $cond: [{ $not: "$SanityChecks.Result.Passed" }, 1, 0] } },
        total: { $sum: 1 }
    } },
    { $project: {
        passRate: { $divide: ["$passed", "$total"] },
        failureRate: { $divide: ["$failed", "$total"] }
    } }
];
```

---

## 4. Implementation Patterns

### Pattern A: High-Frequency Polling Location (PollingWorker.cs)

#### Attribute-Based Approach
```csharp
[ChaosPoint(
    ChaosPointId = "H0UND-POLL-001",
    Component = "PollingWorker",
    Type = ChaosEventType.InfiniteLoop,
    SampleRate = 0.05, // 5% sampling for performance
    CallStackDepth = 1,
    CaptureState = true)]
public async Task<Dictionary<string, decimal>> QueryBalancesAsync(
    Credential credential, 
    IUnitOfWork uow)
{
    using var correlation = _chaosLogger.BeginCorrelation($"polling-{credential.Id}");
    
    try
    {
        var stopwatch = Stopwatch.StartNew();
        int networkAttempts = 0;
        
        // Log pre-condition sanity check
        var preCheck = new PollingSanityTest
        {
            Credential = credential,
            StartTime = DateTime.UtcNow,
            CorrelationId = correlation.CorrelationId
        };
        
        var sanityPreResult = await _sanityRunner.ValidatePreAsync(preCheck);
        _chaosLogger.LogSanityTestAsync(sanityPreResult);
        
        // Main polling logic with performance sampling
        var result = await ExecutePollingWithSamplingAsync(
            credential, uow, correlation.CorrelationId);
        
        // Log post-condition sanity check
        var postCheck = new PollingSanityTest
        {
            Credential = credential,
            Result = result,
            EndTime = DateTime.UtcNow,
            CorrelationId = correlation.CorrelationId
        };
        
        var sanityPostResult = await _sanityRunner.ValidatePostAsync(postCheck);
        _chaosLogger.LogSanityTestAsync(sanityPostResult);
        
        // Log performance metric
        stopwatch.Stop();
        await _chaosLogger.LogPerformanceAsync(new PerformanceMetric
        {
            OperationName = "QueryBalances",
            Location = "PollingWorker.cs:26",
            DurationTicks = stopwatch.ElapsedTicks,
            Success = true,
            Properties = new Dictionary<string, object>
            {
                ["CredentialId"] = credential.Id,
                ["NetworkAttempts"] = networkAttempts,
                ["Success"] = true
            },
            CorrelationId = correlation.CorrelationId,
            SessionId = correlation.SessionId
        });
        
        return result;
    }
    catch (Exception ex)
    {
        await _chaosLogger.LogEventAsync(new ChaosEvent
        {
            ChaosPointId = "H0UND-POLL-001",
            Component = "PollingWorker",
            Type = ChaosEventType.NetworkTimeout,
            Timestamp = DateTime.UtcNow,
            Message = "QueryBalances failed",
            Properties = new Dictionary<string, object>
            {
                ["CredentialId"] = credential.Id,
                ["NetworkAttempts"] = networkAttempts,
                ["ExceptionType"] = ex.GetType().Name
            },
            Exception = ex,
            CorrelationId = correlation.CorrelationId,
            SessionId = correlation.SessionId,
            CallStackDepth = 1,
            ElapsedMicroseconds = stopwatch.ElapsedTicks / 10
        });
        
        throw;
    }
}
```

#### Explicit Call Approach
```csharp
public async Task<Dictionary<string, decimal>> QueryBalancesAsync(
    Credential credential, 
    IUnitOfWork uow)
{
    var correlationId = _chaosLogger.GenerateCorrelationId();
    var sessionId = _sessionManager.CurrentSession?.Id ?? "unknown";
    
    // Create context for this polling operation
    using var context = _chaosLogger.BeginCorrelation(correlationId);
    
    // Log start of polling operation
    await _chaosLogger.LogEventAsync(new ChaosEvent
    {
        ChaosPointId = "H0UND-POLL-001",
        Component = "PollingWorker",
        Type = ChaosEventType.InfiniteLoop,
        Timestamp = DateTime.UtcNow,
        Message = "Starting balance polling",
        Properties = new Dictionary<string, object>
        {
            ["CredentialId"] = credential.Id,
            ["Game"] = credential.Game,
            ["House"] = credential.House
        },
        CorrelationId = correlationId,
        SessionId = sessionId,
        CallStackDepth = 1
    });
    
    int networkAttempts = 0;
    while (true)
    {
        try
        {
            // Sample for performance monitoring
            if (_sampler.ShouldSample("PollingWorker.QueryBalances", out var sampleRate))
            {
                var stopwatch = Stopwatch.StartNew();
                var result = await QueryBalances(credential, uow);
                stopwatch.Stop();
                
                _sampler.RecordSample("PollingWorker.QueryBalances", 
                    stopwatch.ElapsedTicks, true);
                
                return result;
            }
        }
        catch (Exception ex)
        {
            networkAttempts++;
            if (networkAttempts >= 3)
                throw;
                
            // Log retry event with sampling
            if (_random.NextDouble() < sampleRate)
            {
                await _chaosLogger.LogEventAsync(new ChaosEvent
                {
                    ChaosPointId = "H0UND-POLL-001",
                    Component = "PollingWorker",
                    Type = ChaosEventType.NetworkTimeout,
                    Timestamp = DateTime.UtcNow,
                    Message = "Network timeout, retrying",
                    Properties = new Dictionary<string, object>
                    {
                        ["Attempt"] = networkAttempts,
                        ["Exception"] = ex.Message
                    },
                    Exception = ex,
                    CorrelationId = correlationId,
                    SessionId = sessionId
                });
            }
        }
    }
}
```

### Pattern B: Data Mutation Location (LegacyRuntimeHost.cs)

#### Attribute-Based Approach
```csharp
[ChaosPoint(
    ChaosPointId = "H4ND-RUN-001",
    Component = "LegacyRuntimeHost",
    Type = ChaosEventType.LockConflict,
    CaptureStackTrace = true,
    CallStackDepth = 3,
    CaptureState = true)]
[SanityTest(
    TestName = "CredentialLockValidation",
    Component = "LegacyRuntimeHost",
    ValidatePreCondition = true,
    ValidatePostCondition = true)]
public async Task ProcessSignalAsync(Signal signal, Credential credential, 
    NavigationMapLoader navigationMapLoader, NavigationStepExecutor navigationStepExecutor)
{
    var correlationId = _chaosLogger.GenerateCorrelationId();
    var sessionId = _sessionManager.CurrentSession?.Id ?? "unknown";
    
    using var correlation = _chaosLogger.BeginCorrelation(correlationId);
    
    try
    {
        // Log signal processing start
        await _chaosLogger.LogEventAsync(new ChaosEvent
        {
            ChaosPointId = "H4ND-RUN-001",
            Component = "LegacyRuntimeHost",
            Type = ChaosEventType.DataMutation,
            Timestamp = DateTime.UtcNow,
            Message = "Starting signal processing",
            Properties = new Dictionary<string, object>
            {
                ["SignalId"] = signal.Id,
                ["CredentialId"] = credential.Id,
                ["Priority"] = signal.Priority,
                ["Game"] = credential.Game
            },
            CorrelationId = correlationId,
            SessionId = sessionId,
            CallStackDepth = 1
        });
        
        using (var uow = _unitOfWorkFactory.Create())
        {
            // Pre-condition sanity test
            var preContext = new SignalProcessingContext
            {
                Signal = signal,
                Credential = credential,
                Uow = uow,
                CorrelationId = correlationId
            };
            
            var sanityPreResult = await _sanityRunner.ValidatePreAsync(
                "SignalPreConditions", preContext);
            
            if (!sanityPreResult.Passed)
            {
                // Log failed sanity test
                await _chaosLogger.LogSanityTestAsync(sanityPreResult);
                
                // Mark chaos point for failed pre-condition
                await _chaosLogger.LogEventAsync(new ChaosEvent
                {
                    ChaosPointId = "H4ND-RUN-001",
                    Component = "LegacyRuntimeHost",
                    Type = ChaosEventType.ValueCoercion,
                    Timestamp = DateTime.UtcNow,
                    Message = "Sanity test failed before signal processing",
                    Properties = new Dictionary<string, object>
                    {
                        ["SignalId"] = signal.Id,
                        ["SanityTest"] = sanityPreResult.Message,
                        ["FailedConditions"] = string.Join(", ", 
                            sanityPreResult.Metadata?.Keys ?? Enumerable.Empty<string>())
                    },
                    Exception = sanityPreResult.Exception,
                    CorrelationId = correlationId,
                    SessionId = sessionId,
                    CallStackDepth = 3
                });
                
                return;
            }
            
            // Lock credential to prevent race conditions
            uow.Credentials.Lock(credential);
            
            // Log lock acquisition
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = "H4ND-RUN-002",
                Component = "LegacyRuntimeHost",
                Type = ChaosEventType.LockConflict,
                Timestamp = DateTime.UtcNow,
                Message = "Credential locked for signal processing",
                Properties = new Dictionary<string, object>
                {
                    ["CredentialId"] = credential.Id,
                    ["LockDurationMs"] = 0,
                    ["QueueLength"] = uow.Signals.GetQueueLength()
                },
                CorrelationId = correlationId,
                SessionId = sessionId
            });
            
            // Acknowledge signal
            if (signal != null)
            {
                uow.Signals.Acknowledge(signal);
                
                // Log signal acknowledgment
                await _chaosLogger.LogEventAsync(new ChaosEvent
                {
                    ChaosPointId = "H4ND-RUN-003",
                    Component = "LegacyRuntimeHost",
                    Type = ChaosEventType.SignalDuplication,
                    Timestamp = DateTime.UtcNow,
                    Message = "Signal acknowledged",
                    Properties = new Dictionary<string, object>
                    {
                        ["SignalId"] = signal.Id,
                        ["AckTime"] = DateTime.UtcNow,
                        ["Priority"] = signal.Priority
                    },
                    CorrelationId = correlationId,
                    SessionId = sessionId
                });
            }
            
            // Post-condition sanity test
            var postContext = new SignalProcessingContext
            {
                Signal = signal,
                Credential = credential,
                Uow = uow,
                CorrelationId = correlationId,
                OperationResult = "Success"
            };
            
            var sanityPostResult = await _sanityRunner.ValidatePostAsync(
                "SignalPostConditions", postContext);
            
            // Log final state
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = "H4ND-RUN-001",
                Component = "LegacyRuntimeHost",
                Type = ChaosEventType.DataMutation,
                Timestamp = DateTime.UtcNow,
                Message = "Signal processing completed",
                Properties = new Dictionary<string, object>
                {
                    ["SignalId"] = signal?.Id,
                    ["CredentialState"] = credential.State,
                    ["LockDurationMs"] = _stopwatch.ElapsedMilliseconds,
                    ["QueueLength"] = uow.Signals.GetQueueLength()
                },
                CorrelationId = correlationId,
                SessionId = sessionId,
                CallStackDepth = 1
            });
        }
    }
    catch (Exception ex)
    {
        // Log failure with full context
        await _chaosLogger.LogEventAsync(new ChaosEvent
        {
            ChaosPointId = "H4ND-RUN-001",
            Component = "LegacyRuntimeHost",
            Type = ChaosEventType.DataMutation,
            Timestamp = DateTime.UtcNow,
            Message = "Signal processing failed",
            Properties = new Dictionary<string, object>
            {
                ["SignalId"] = signal?.Id,
                ["CredentialId"] = credential.Id,
                ["ExceptionType"] = ex.GetType().Name,
                ["LockState"] = credential.LockState
            },
            Exception = ex,
            CorrelationId = correlationId,
            SessionId = sessionId,
            StackTrace = ex.StackTrace,
            CallStackDepth = 5,
            ElapsedMicroseconds = _stopwatch.ElapsedTicks / 10
        });
        
        throw;
    }
}
```

### Pattern C: Async Workflow Location (CdpGameActions.cs)

#### Explicit Call Approach
```csharp
public async Task<bool> ExecuteLoginWithRecorderAsync(
    CdpClient cdp, 
    Credential credential, 
    NavigationMapLoader navigationMapLoader, 
    NavigationStepExecutor navigationStepExecutor)
{
    var correlationId = _chaosLogger.GenerateCorrelationId();
    var sessionId = _sessionManager.CurrentSession?.Id ?? "unknown";
    var navId = $"nav-{Guid.NewGuid():N}";
    
    using var correlation = _chaosLogger.BeginCorrelation(correlationId);
    
    try
    {
        // Log login workflow start
        await _chaosLogger.LogEventAsync(new ChaosEvent
        {
            ChaosPointId = "FK-CGP-001",
            Component = "CdpGameActions",
            Type = ChaosEventType.Workflow,
            Timestamp = DateTime.UtcNow,
            Message = "Starting login workflow",
            Properties = new Dictionary<string, object>
            {
                ["CredentialId"] = credential.Id,
                ["Game"] = credential.Game,
                ["NavigationId"] = navId,
                ["CorrelationId"] = correlationId
            },
            CorrelationId = correlationId,
            SessionId = sessionId,
            CallStackDepth = 1
        });
        
        // Pre-condition validation
        var loginContext = new LoginContext
        {
            Credential = credential,
            NavigationId = navId,
            CorrelationId = correlationId
        };
        
        var sanityPreResult = await _sanityRunner.ValidatePreAsync(
            "LoginPreConditions", loginContext);
        
        if (!sanityPreResult.Passed)
        {
            await _chaosLogger.LogSanityTestAsync(sanityPreResult);
            
            // Log failed pre-condition as chaos event
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = "FK-CGP-001",
                Component = "CdpGameActions",
                Type = ChaosEventType.AuthenticationFailure,
                Timestamp = DateTime.UtcNow,
                Message = "Login pre-conditions failed",
                Properties = new Dictionary<string, object>
                {
                    ["CredentialId"] = credential.Id,
                    ["FailedTests"] = sanityPreResult.Metadata?.Keys.ToArray(),
                    ["NavigationId"] = navId
                },
                Exception = sanityPreResult.Exception,
                CorrelationId = correlationId,
                SessionId = sessionId
            });
            
            return false;
        }
        
        // Execute login steps with performance sampling
        var loginSteps = new[]
        {
            ("NavigateToLogin", NavigateToLoginAsync),
            ("EnterCredentials", EnterCredentialsAsync),
            ("SubmitLogin", SubmitLoginAsync),
            ("VerifyLogin", VerifyLoginAsync)
        };
        
        foreach (var (stepName, stepAction) in loginSteps)
        {
            // Sample performance for this step
            if (_sampler.ShouldSample($"CdpGameActions.{stepName}", out var sampleRate))
            {
                var stopwatch = Stopwatch.StartNew();
                var stepResult = await stepAction(cdp, credential);
                stopwatch.Stop();
                
                _sampler.RecordSample($"CdpGameActions.{stepName}", 
                    stopwatch.ElapsedTicks, stepResult);
                
                // Log step completion
                await _chaosLogger.LogEventAsync(new ChaosEvent
                {
                    ChaosPointId = $"FK-CGP-{stepName}",
                    Component = "CdpGameActions",
                    Type = ChaosEventType.NavigationError,
                    Timestamp = DateTime.UtcNow,
                    Message = $"{stepName} completed",
                    Properties = new Dictionary<string, object>
                    {
                        ["StepResult"] = stepResult,
                        ["DurationMs"] = stopwatch.ElapsedMilliseconds,
                        ["NavigationId"] = navId
                    },
                    CorrelationId = correlationId,
                    SessionId = sessionId,
                    CallStackDepth = 2,
                    ElapsedMicroseconds = stopwatch.ElapsedTicks / 10
                });
                
                if (!stepResult)
                    return false;
            }
        }
        
        // Post-condition validation
        var postContext = new LoginContext
        {
            Credential = credential,
            NavigationId = navId,
            CorrelationId = correlationId,
            LoginResult = true
        };
        
        var sanityPostResult = await _sanityRunner.ValidatePostAsync(
            "LoginPostConditions", postContext);
        
        // Log final workflow completion
        await _chaosLogger.LogEventAsync(new ChaosEvent
        {
            ChaosPointId = "FK-CGP-001",
            Component = "CdpGameActions",
            Type = ChaosEventType.Workflow,
            Timestamp = DateTime.UtcNow,
            Message = "Login workflow completed successfully",
            Properties = new Dictionary<string, object>
            {
                ["CredentialId"] = credential.Id,
                ["Game"] = credential.Game,
                ["NavigationId"] = navId,
                ["TotalDurationMs"] = _stopwatch.ElapsedMilliseconds,
                ["SanityPassed"] = sanityPostResult.Passed
            },
            CorrelationId = correlationId,
            SessionId = sessionId
        });
        
        return sanityPostResult.Passed;
    }
    catch (Exception ex)
    {
        // Log workflow failure
        await _chaosLogger.LogEventAsync(new ChaosEvent
        {
            ChaosPointId = "FK-CGP-001",
            Component = "CdpGameActions",
            Type = ChaosEventType.NavigationError,
            Timestamp = DateTime.UtcNow,
            Message = "Login workflow failed",
            Properties = new Dictionary<string, object>
            {
                ["CredentialId"] = credential.Id,
                ["ExceptionType"] = ex.GetType().Name,
                ["NavigationId"] = navId,
                ["StepCompleted"] = currentStep
            },
            Exception = ex,
            CorrelationId = correlationId,
            SessionId = sessionId,
            StackTrace = ex.StackTrace,
            CallStackDepth = 5,
            ElapsedMicroseconds = _stopwatch.ElapsedTicks / 10
        });
        
        return false;
    }
}
```

---

## 5. Configuration System

### Configuration Schema

```json
{
  "version": "1.0.0",
  "enabled": true,
  "session": {
    "defaultTimeoutSeconds": 3600,
    "cleanupIntervalSeconds": 300,
    "correlationHeader": "X-Correlation-ID"
  },
  "logging": {
    "defaultLevel": "Information",
    "bufferSize": 1000,
    "flushIntervalSeconds": 5,
    "batchSize": 500,
    "maxConcurrentWrites": 10
  },
  "sampling": {
    "defaultRate": 0.1,
    "overrides": {
      "PollingWorker": 0.05,
      "SignalDistributor": 0.02,
      "CdpGameActions": 0.2,
      "LegacyRuntimeHost": 0.1
    },
    "performanceThresholds": {
      "highFrequency": 100,
      "mediumFrequency": 50,
      "lowFrequency": 10
    }
  },
  "sanityTests": {
    "enabled": true,
    "defaultLevel": "Critical",
    "timeoutSeconds": 30,
    "retries": 3,
    "tests": {
      "PollingWorker": {
        "preConditions": ["CredentialState", "NetworkConnectivity"],
        "postConditions": ["ResponseValid", "DataConsistent"]
      },
      "LegacyRuntimeHost": {
        "preConditions": ["CredentialLockable", "SignalQueueAccessible"],
        "postConditions": ["SignalProcessed", "CredentialStateValid"],
        "customTests": ["SignalPriorityValidation"]
      },
      "CdpGameActions": {
        "preConditions": ["CDPConnected", "NavigationMapLoaded"],
        "postConditions": ["LoggedIn", "DOMStable"],
        "customTests": ["NavigationStepValidation"]
      }
    }
  },
  "performance": {
    "enabled": true,
    "operationThresholds": {
      "QueryBalances": 2000,
      "SignalProcessing": 1000,
      "LoginWorkflow": 15000,
      "DataMutation": 500
    },
    "alertThresholds": {
      "cpuUsage": 80,
      "memoryUsageMB": 4096,
      "queueLength": 1000,
      "errorRate": 0.05
    }
  },
  "storage": {
    "mongodb": {
      "connectionString": "mongodb://localhost:27017",
      "database": "p4nth30n_chaos",
      "collection": "_debug",
      "tls": false,
      "connectTimeoutSeconds": 30,
      "socketTimeoutSeconds": 60,
      "maxPoolSize": 100,
      "writeConcern": {
        "w": "majority",
        "j": true
      }
    },
    "retention": {
      "days": 30,
      "autoCleanup": true,
      "cleanupIntervalHours": 24
    }
  },
  "components": {
    "H0UND": {
      "enabled": true,
      "logLevel": "Debug",
      "samplingRate": 0.1,
      "sanityTests": ["ServiceHealthCheck", "PollingState"],
      "chaosPoints": ["H0UND-SVC", "H0UND-POLL", "H0UND-BAL"]
    },
    "H4ND": {
      "enabled": true,
      "logLevel": "Information",
      "samplingRate": 0.15,
      "sanityTests": ["CredentialLock", "SignalProcessing", "DataConsistency"],
      "chaosPoints": ["H4ND-RUN", "H4ND-SIG", "H4ND-DAT"]
    },
    "FireKirin": {
      "enabled": true,
      "logLevel": "Debug",
      "samplingRate": 0.2,
      "sanityTests": ["LoginFlow", "NavigationState", "CDPConnection"],
      "chaosPoints": ["FK-CGP", "FK-LGN", "FK-NAV"]
    }
  },
  "alerts": {
    "enabled": true,
    "channels": ["console", "file"],
    "rules": [
      {
        "name": "HighErrorRate",
        "condition": "errorRate > 0.1",
        "severity": "High",
        "throttleMinutes": 15
      },
      {
        "name": "PerformanceDegradation",
        "condition": "responseTime > threshold * 2",
        "severity": "Medium",
        "throttleMinutes": 5
      },
      {
        "name": "ChaosPointSpike",
        "condition": "eventCount > 1000",
        "severity": "Critical",
        "throttleMinutes": 10
      }
    ]
  },
  "diagnostics": {
    "enabled": true,
    "verbose": false,
    "healthCheckIntervalSeconds": 60,
    "metricsIntervalSeconds": 30,
    "exportFormat": "json",
    "exportPath": "/var/log/p4nth30n/chaos"
  }
}
```

### Configuration Management

```csharp
public class ChaosLoggingConfiguration
{
    public required ChaosLoggingConfig Config { get; set; }
    public required string ConfigPath { get; set; }
    private FileSystemWatcher _configWatcher;
    
    public ChaosLoggingConfiguration(string configPath)
    {
        ConfigPath = configPath;
        LoadConfiguration();
        SetupFileWatcher();
    }
    
    private void LoadConfiguration()
    {
        try
        {
            var json = File.ReadAllText(ConfigPath);
            Config = JsonSerializer.Deserialize<ChaosLoggingConfig>(json);
            
            // Validate configuration
            ValidateConfiguration();
        }
        catch (Exception ex)
        {
            // Fallback to default configuration
            Config = GetDefaultConfiguration();
            Log.Warning($"Failed to load chaos logging config: {ex.Message}");
        }
    }
    
    private void SetupFileWatcher()
    {
        _configWatcher = new FileSystemWatcher
        {
            Path = Path.GetDirectoryName(ConfigPath),
            Filter = Path.GetFileName(ConfigPath),
            EnableRaisingEvents = true
        };
        
        _configWatcher.Changed += OnConfigChanged;
    }
    
    private void OnConfigChanged(object sender, FileSystemEventArgs e)
    {
        try
        {
            // Debounce rapid changes
            Task.Delay(1000).ContinueWith(_ =>
            {
                LoadConfiguration();
                OnConfigurationChanged?.Invoke(this, EventArgs.Empty);
            });
        }
        catch (Exception ex)
        {
            Log.Error($"Error reloading chaos logging config: {ex.Message}");
        }
    }
    
    public event EventHandler? OnConfigurationChanged;
    
    private void ValidateConfiguration()
    {
        // Validate sampling rates
        foreach (var override in Config.Sampling.Overrides)
        {
            if (override.Value < 0 || override.Value > 1)
            {
                throw new ConfigurationException(
                    $"Invalid sampling rate for {override.Key}: {override.Value}");
            }
        }
        
        // Validate MongoDB connection string
        if (string.IsNullOrWhiteSpace(Config.Storage.MongoDB.ConnectionString))
        {
            throw new ConfigurationException("MongoDB connection string is required");
        }
        
        // Validate component configurations
        foreach (var component in Config.Components.Values)
        {
            if (component.SamplingRate < 0 || component.SamplingRate > 1)
            {
                throw new ConfigurationException(
                    $"Invalid sampling rate for component {component.Key}: {component.SamplingRate}");
            }
        }
    }
    
    public ChaosLoggingConfig GetComponentConfig(string component)
    {
        return Config.Components.TryGetValue(component, out var config) 
            ? config 
            : new ChaosLoggingConfig();
    }
    
    public double GetSamplingRate(string component)
    {
        return Config.Sampling.Overrides.TryGetValue(component, out var overrideRate)
            ? overrideRate
            : Config.Sampling.DefaultRate;
    }
    
    public bool IsEnabled(string component)
    {
        return Config.Enabled && 
               Config.Components.TryGetValue(component, out var config) && 
               config.Enabled;
    }
    
    public static ChaosLoggingConfig GetDefaultConfiguration()
    {
        return new ChaosLoggingConfig
        {
            Enabled = true,
            Session = new SessionConfig
            {
                DefaultTimeoutSeconds = 3600,
                CleanupIntervalSeconds = 300
            },
            Logging = new LoggingConfig
            {
                BufferSize = 1000,
                FlushIntervalSeconds = 5,
                BatchSize = 500,
                MaxConcurrentWrites = 10
            },
            Sampling = new SamplingConfig
            {
                DefaultRate = 0.1,
                Overrides = new Dictionary<string, double>
                {
                    ["PollingWorker"] = 0.05,
                    ["SignalDistributor"] = 0.02,
                    ["CdpGameActions"] = 0.2,
                    ["LegacyRuntimeHost"] = 0.1
                }
            },
            SanityTests = new SanityTestsConfig
            {
                Enabled = true,
                DefaultLevel = SanityLevel.Critical,
                TimeoutSeconds = 30,
                Retries = 3
            },
            Performance = new PerformanceConfig
            {
                Enabled = true,
                OperationThresholds = new Dictionary<string, int>
                {
                    ["QueryBalances"] = 2000,
                    ["SignalProcessing"] = 1000,
                    ["LoginWorkflow"] = 15000,
                    ["DataMutation"] = 500
                }
            },
            Storage = new StorageConfig
            {
                MongoDB = new MongoConfig
                {
                    ConnectionString = "mongodb://localhost:27017",
                    Database = "p4nth30n_chaos",
                    Collection = "_debug",
                    MaxPoolSize = 100
                },
                Retention = new RetentionConfig
                {
                    Days = 30,
                    AutoCleanup = true,
                    CleanupIntervalHours = 24
                }
            }
        };
    }
}
```

---

## 6. Performance Optimization Strategies

### Async Logging Pipeline

```csharp
public class OptimizedChaosLogger : IChaosLogger
{
    private readonly ConcurrentQueue<ChaosEvent> _eventBuffer = new();
    private readonly ConcurrentQueue<SanityTest> _sanityBuffer = new();
    private readonly ConcurrentQueue<PerformanceMetric> _performanceBuffer = new();
    private readonly Timer _flushTimer;
    private readonly SemaphoreSlim _flushSemaphore = new(1);
    private readonly MongoDBWriter _mongoWriter;
    private readonly ChaosLoggingConfiguration _config;
    
    public OptimizedChaosLogger(ChaosLoggingConfiguration config)
    {
        _config = config;
        _mongoWriter = new MongoDBWriter(config.Config.Storage.MongoDB);
        _flushTimer = new Timer(FlushBuffer, null, 
            TimeSpan.FromSeconds(config.Config.Logging.FlushIntervalSeconds),
            TimeSpan.FromSeconds(config.Config.Logging.FlushIntervalSeconds));
    }
    
    public async Task LogEventAsync(ChaosEvent @event, CancellationToken cancellationToken = default)
    {
        // Apply sampling
        if (_random.NextDouble() > _config.GetSamplingRate(@event.Component))
            return;
        
        _eventBuffer.Enqueue(@event);
        
        // Check if buffer needs flushing
        if (_eventBuffer.Count >= _config.Config.Logging.BatchSize)
        {
            _ = FlushBufferAsync(cancellationToken);
        }
    }
    
    public async Task LogBatchAsync(IEnumerable<ChaosEvent> events, CancellationToken cancellationToken = default)
    {
        foreach (var @event in events)
        {
            if (_random.NextDouble() <= _config.GetSamplingRate(@event.Component))
            {
                _eventBuffer.Enqueue(@event);
            }
        }
        
        if (_eventBuffer.Count >= _config.Config.Logging.BatchSize)
        {
            _ = FlushBufferAsync(cancellationToken);
        }
    }
    
    private async void FlushBuffer(object? state)
    {
        await FlushBufferAsync(CancellationToken.None);
    }
    
    private async Task FlushBufferAsync(CancellationToken cancellationToken)
    {
        if (!_flushSemaphore.Wait(0, cancellationToken))
            return;
        
        try
        {
            var events = new List<ChaosEvent>();
            var sanityTests = new List<SanityTest>();
            var performanceMetrics = new List<PerformanceMetric>();
            
            // Drain buffers
            while (_eventBuffer.TryDequeue(out var @event))
            {
                events.Add(@event);
            }
            
            while (_sanityBuffer.TryDequeue(out var test))
            {
                sanityTests.Add(test);
            }
            
            while (_performanceBuffer.TryDequeue(out var metric))
            {
                performanceMetrics.Add(metric);
            }
            
            if (events.Count > 0 || sanityTests.Count > 0 || performanceMetrics.Count > 0)
            {
                _ = Task.Run(async () =>
                {
                    try
                    {
                        // Write batches in parallel
                        var tasks = new List<Task>();
                        
                        if (events.Count > 0)
                        {
                            tasks.Add(_mongoWriter.WriteEventsAsync(events, cancellationToken));
                        }
                        
                        if (sanityTests.Count > 0)
                        {
                            tasks.Add(_mongoWriter.WriteSanityTestsAsync(sanityTests, cancellationToken));
                        }
                        
                        if (performanceMetrics.Count > 0)
                        {
                            tasks.Add(_mongoWriter.WritePerformanceMetricsAsync(performanceMetrics, cancellationToken));
                        }
                        
                        await Task.WhenAll(tasks);
                    }
                    catch (Exception ex)
                    {
                        Log.Error($"Failed to flush chaos logging buffer: {ex.Message}");
                    }
                }, cancellationToken);
            }
        }
        finally
        {
            _flushSemaphore.Release();
        }
    }
    
    public async ValueTask DisposeAsync()
    {
        _flushTimer.Dispose();
        await FlushBufferAsync(CancellationToken.None);
        _flushSemaphore.Dispose();
    }
}
```

### High-Frequency Sampling Algorithm

```csharp
public class AdaptivePerformanceSampler : IPerformanceSampler
{
    private readonly ConcurrentDictionary<string, LocationStats> _stats = new();
    private readonly ChaosLoggingConfiguration _config;
    
    public AdaptivePerformanceSampler(ChaosLoggingConfiguration config)
    {
        _config = config;
    }
    
    public bool ShouldSample(string location, out double sampleRate)
    {
        var threshold = _config.Config.Performance.AlertThresholds.HighFrequency;
        
        if (_stats.TryGetValue(location, out var stats))
        {
            // Adaptive sampling based on historical performance
            if (stats.AverageCallsPerSecond > threshold)
            {
                // High frequency - reduce sampling rate
                sampleRate = Math.Max(0.01, _config.GetSamplingRate(location) / 10);
                return _random.NextDouble() < sampleRate;
            }
            else if (stats.ErrorRate > 0.05)
            {
                // High error rate - increase sampling rate
                sampleRate = Math.Min(1.0, _config.GetSamplingRate(location) * 5);
                return _random.NextDouble() < sampleRate;
            }
        }
        
        // Default sampling
        sampleRate = _config.GetSamplingRate(location);
        return _random.NextDouble() < sampleRate;
    }
    
    public void RecordSample(string location, long durationTicks, bool success)
    {
        _stats.AddOrUpdate(location, 
            key => new LocationStats
            {
                TotalCalls = 1,
                TotalDurationTicks = durationTicks,
                SuccessfulCalls = success ? 1 : 0,
                ErrorCalls = success ? 0 : 1,
                LastUpdate = DateTime.UtcNow,
                SampleCount = 1
            },
            (key, existing) => new LocationStats
            {
                TotalCalls = existing.TotalCalls + 1,
                TotalDurationTicks = existing.TotalDurationTicks + durationTicks,
                SuccessfulCalls = existing.SuccessfulCalls + (success ? 1 : 0),
                ErrorCalls = existing.ErrorCalls + (success ? 0 : 1),
                LastUpdate = DateTime.UtcNow,
                SampleCount = existing.SampleCount + 1
            });
    }
    
    public PerformanceStats GetStats(string location)
    {
        if (_stats.TryGetValue(location, out var stats))
        {
            return new PerformanceStats
            {
                AverageDurationMs = stats.TotalDurationTicks / (double)stats.TotalCalls / TimeSpan.TicksPerMillisecond,
                CallsPerSecond = stats.TotalCalls / 
                    Math.Max(1, (DateTime.UtcNow - stats.LastUpdate).TotalSeconds),
                ErrorRate = stats.ErrorCalls / (double)stats.TotalCalls,
                TotalCalls = stats.TotalCalls,
                SampleCount = stats.SampleCount
            };
        }
        
        return new PerformanceStats();
    }
    
    private class LocationStats
    {
        public int TotalCalls { get; set; }
        public long TotalDurationTicks { get; set; }
        public int SuccessfulCalls { get; set; }
        public int ErrorCalls { get; set; }
        public DateTime LastUpdate { get; set; }
        public int SampleCount { get; set; }
        
        public double AverageCallsPerSecond => TotalCalls / 
            Math.Max(1, (DateTime.UtcNow - LastUpdate).TotalSeconds);
        
        public double ErrorRate => ErrorCalls / (double)TotalCalls;
    }
}
```

---

## 7. Integration with Existing Systems

### CircuitBreaker Integration

```csharp
public class ChaosAwareCircuitBreaker : CircuitBreaker
{
    private readonly IChaosLogger _chaosLogger;
    private readonly string _component;
    private readonly string _operation;
    
    public ChaosAwareCircuitBreaker(
        IChaosLogger chaosLogger,
        string component,
        string operation,
        CircuitBreakerConfig config) : base(config)
    {
        _chaosLogger = chaosLogger;
        _component = component;
        _operation = operation;
    }
    
    protected override async Task<T> ExecuteAsync<T>(
        Func<Task<T>> action,
        CancellationToken cancellationToken)
    {
        try
        {
            var correlationId = _chaosLogger.GenerateCorrelationId();
            
            // Log circuit breaker state
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = $"{_component}-CBR-001",
                Component = _component,
                Type = ChaosEventType.CircuitBreakerTriggered,
                Timestamp = DateTime.UtcNow,
                Message = $"Circuit breaker state: {State}",
                Properties = new Dictionary<string, object>
                {
                    ["Operation"] = _operation,
                    ["State"] = State,
                    ["FailureCount"] = FailureCount,
                    ["SuccessThreshold"] = SuccessThreshold
                },
                CorrelationId = correlationId,
                SessionId = "unknown"
            });
            
            var result = await base.ExecuteAsync(action, cancellationToken);
            
            // Log success
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = $"{_component}-CBR-001",
                Component = _component,
                Type = ChaosEventType.CircuitBreakerTriggered,
                Timestamp = DateTime.UtcNow,
                Message = "Circuit breaker operation successful",
                Properties = new Dictionary<string, object>
                {
                    ["Operation"] = _operation,
                    ["State"] = State,
                    ["PreviousFailureCount"] = FailureCount
                },
                CorrelationId = correlationId,
                SessionId = "unknown"
            });
            
            return result;
        }
        catch (Exception ex)
        {
            // Log failure
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = $"{_component}-CBR-001",
                Component = _component,
                Type = ChaosEventType.CircuitBreakerTriggered,
                Timestamp = DateTime.UtcNow,
                Message = "Circuit breaker operation failed",
                Properties = new Dictionary<string, object>
                {
                    ["Operation"] = _operation,
                    ["State"] = State,
                    ["FailureCount"] = FailureCount
                },
                Exception = ex,
                CorrelationId = _chaosLogger.GenerateCorrelationId(),
                SessionId = "unknown"
            });
            
            throw;
        }
    }
}
```

### MongoDB UnitOfWork Integration

```csharp
public class ChaosAwareUnitOfWork : MongoUnitOfWork
{
    private readonly IChaosLogger _chaosLogger;
    private readonly string _correlationId;
    private readonly Stopwatch _stopwatch = Stopwatch.StartNew();
    
    public ChaosAwareUnitOfWork(
        MongoDbContext context,
        IChaosLogger chaosLogger,
        string correlationId) : base(context)
    {
        _chaosLogger = chaosLogger;
        _correlationId = correlationId;
    }
    
    public override async Task<int> SaveChangesAsync(
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Log pre-save state
            var changeTracker = Context.ChangeTracker;
            var pendingChanges = changeTracker.Entries().Count;
            
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = "H4ND-UOW-001",
                Component = "MongoUnitOfWork",
                Type = ChaosEventType.DataMutation,
                Timestamp = DateTime.UtcNow,
                Message = "About to save changes",
                Properties = new Dictionary<string, object>
                {
                    ["PendingChanges"] = pendingChanges,
                    ["Operation"] = "SaveChanges",
                    ["CorrelationId"] = _correlationId
                },
                CorrelationId = _correlationId,
                SessionId = "unknown"
            });
            
            var result = await base.SaveChangesAsync(cancellationToken);
            
            // Log post-save state
            _stopwatch.Stop();
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = "H4ND-UOW-001",
                Component = "MongoUnitOfWork",
                Type = ChaosEventType.DataMutation,
                Timestamp = DateTime.UtcNow,
                Message = "Changes saved successfully",
                Properties = new Dictionary<string, object>
                {
                    ["SavedEntities"] = result,
                    ["OperationTimeMs"] = _stopwatch.ElapsedMilliseconds,
                    ["CorrelationId"] = _correlationId
                },
                CorrelationId = _correlationId,
                SessionId = "unknown",
                ElapsedMicroseconds = _stopwatch.ElapsedTicks / 10
            });
            
            return result;
        }
        catch (Exception ex)
        {
            // Log save failure
            _stopwatch.Stop();
            await _chaosLogger.LogEventAsync(new ChaosEvent
            {
                ChaosPointId = "H4ND-UOW-001",
                Component = "MongoUnitOfWork",
                Type = ChaosEventType.DataMutation,
                Timestamp = DateTime.UtcNow,
                Message = "Save changes failed",
                Properties = new Dictionary<string, object>
                {
                    ["Operation"] = "SaveChanges",
                    ["CorrelationId"] = _correlationId,
                    ["ExceptionType"] = ex.GetType().Name
                },
                Exception = ex,
                CorrelationId = _correlationId,
                SessionId = "unknown",
                StackTrace = ex.StackTrace,
                CallStackDepth = 3,
                ElapsedMicroseconds = _stopwatch.ElapsedTicks / 10
            });
            
            throw;
        }
    }
}
```

---

## 8. Deployment and Monitoring

### Deployment Configuration

```csharp
// Service Registration
public static class ChaosLoggingServiceCollectionExtensions
{
    public static IServiceCollection AddChaosLogging(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var configPath = configuration["ChaosLogging:ConfigPath"] 
            ?? "config/chaos-logging.json";
        
        // Load configuration
        var chaosConfig = new ChaosLoggingConfiguration(configPath);
        
        // Register configuration
        services.AddSingleton(chaosConfig);
        
        // Register logging services
        services.AddSingleton<IChaosLogger, OptimizedChaosLogger>();
        services.AddSingleton<IPerformanceSampler, AdaptivePerformanceSampler>();
        services.AddSingleton<ISanityTestRunner, SanityTestRunner>();
        services.AddSingleton<IEventCorrelation, EventCorrelationManager>();
        
        // Register MongoDB writer
        services.AddSingleton<IMongoDBWriter, MongoDBWriter>();
        
        // Register chaos point interceptors
        services.AddScoped<ChaosLoggingInterceptor>();
        
        // Register background cleanup service
        services.AddHostedService<ChaosLoggingCleanupService>();
        
        // Register diagnostic endpoints
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();
        services.MapGet("/chaos/diagnostics", DiagnosticsController.GetDiagnostics);
        services.MapGet("/chaos/metrics", MetricsController.GetMetrics);
        services.MapGet("/chaos/sanity-tests", SanityController.GetSanityTests);
        
        return services;
    }
}
```

### Monitoring Dashboard API

```csharp
[ApiController]
[Route("api/chaos")]
public class ChaosMetricsController : ControllerBase
{
    private readonly IChaosLogger _chaosLogger;
    private readonly IMetricsAggregator _metrics;
    
    public ChaosMetricsController(
        IChaosLogger chaosLogger,
        IMetricsAggregator metrics)
    {
        _chaosLogger = chaosLogger;
        _metrics = metrics;
    }
    
    [HttpGet("dashboard")]
    public async Task<IActionResult> GetDashboard()
    {
        var dashboard = new ChaosDashboard
        {
            Timestamp = DateTime.UtcNow,
            SessionCount = await _metrics.GetSessionCountAsync(),
            EventCounts = await _metrics.GetEventCountsAsync(),
            SanityResults = await _metrics.GetSanityResultsAsync(),
            PerformanceStats = await _metrics.GetPerformanceStatsAsync(),
            SystemMetrics = await _metrics.GetSystemMetricsAsync(),
            Alerts = await _metrics.GetActiveAlertsAsync()
        };
        
        return Ok(dashboard);
    }
    
    [HttpGet("events")]
    public async Task<IActionResult> GetEvents(
        [FromQuery] DateTime? start,
        [FromQuery] DateTime? end,
        [FromQuery] string? component,
        [FromQuery] int limit = 100)
    {
        var filter = new EventFilter
        {
            Start = start ?? DateTime.UtcNow.AddHours(-1),
            End = end ?? DateTime.UtcNow,
            Component = component,
            Limit = limit
        };
        
        var events = await _metrics.GetEventsAsync(filter);
        return Ok(events);
    }
    
    [HttpGet("sanity-tests")]
    public async Task<IActionResult> GetSanityTests(
        [FromQuery] string? component,
        [FromQuery] int days = 7)
    {
        var tests = await _metrics.GetSanityTestsAsync(component, days);
        return Ok(tests);
    }
    
    [HttpGet("performance")]
    public async Task<IActionResult> GetPerformance(
        [FromQuery] string? operation,
        [FromQuery] int hours = 24)
    {
        var performance = await _metrics.GetPerformanceAsync(operation, hours);
        return Ok(performance);
    }
}

public record ChaosDashboard
{
    public required DateTime Timestamp { get; init; }
    public required int SessionCount { get; init; }
    public required Dictionary<string, int> EventCounts { get; init; }
    public required SanitySummary SanityResults { get; init; }
    public required Dictionary<string, PerformanceStats> PerformanceStats { get; init; }
    public required SystemMetrics SystemMetrics { get; init; }
    public required List<Alert> Alerts { get; init; }
}

public record SanitySummary
{
    public required int Total { get; init; }
    public required int Passed { get; init; }
    public required int Failed { get; init; }
    public required double PassRate { get; init; }
}

public record SystemMetrics
{
    public required double CpuUsage { get; init; }
    public required double MemoryUsageMB { get; init; }
    public required int ThreadCount { get; init; }
    public required int GarbageCollections { get; init; }
    public required long EventsPerSecond { get; init; }
}

public record Alert
{
    public required string Id { get; init; }
    public required string Message { get; init; }
    public required AlertSeverity Severity { get; init; }
    public required DateTime Timestamp { get; init; }
    public required string Component { get; init; }
    public required bool Resolved { get; init; }
}
```

---

## 9. Performance Benchmarks and Targets

### Performance Targets

| Metric | Target | High-Frequency | Medium-Frequency | Low-Frequency |
|--------|---------|----------------|------------------|---------------|
| Event Logging Throughput | 10,000 events/second | 5,000 events/second | 10,000 events/second | 15,000 events/second |
| End-to-End Latency | <100ms | <50ms | <100ms | <200ms |
| CPU Overhead | <5% | <2% | <5% | <8% |
| Memory Overhead | <100MB | <50MB | <100MB | <150MB |
| MongoDB Write Latency | <50ms | <20ms | <50ms | <100ms |
| Buffer Flush Time | <1s | <500ms | <1s | <2s |

### Benchmark Scenarios

```csharp
public class ChaosLoggingBenchmarks
{
    private readonly IChaosLogger _logger;
    private readonly int _eventCount = 10000;
    
    [Benchmark]
    public async Task SingleEventLogging()
    {
        var @event = new ChaosEvent
        {
            ChaosPointId = "TEST-001",
            Component = "Benchmark",
            Type = ChaosEventType.ServiceHealthCheck,
            Timestamp = DateTime.UtcNow,
            Message = "Benchmark event",
            Properties = new Dictionary<string, object>(),
            CorrelationId = "benchmark",
            SessionId = "benchmark",
            CallStackDepth = 1
        };
        
        await _logger.LogEventAsync(@event);
    }
    
    [Benchmark]
    public async Task BatchEventLogging()
    {
        var events = Enumerable.Range(0, _eventCount)
            .Select(i => new ChaosEvent
            {
                ChaosPointId = $"TEST-{i:000}",
                Component = "Benchmark",
                Type = ChaosEventType.ServiceHealthCheck,
                Timestamp = DateTime.UtcNow,
                Message = $"Benchmark event {i}",
                Properties = new Dictionary<string, object> { ["Index"] = i },
                CorrelationId = "batch",
                SessionId = "batch",
                CallStackDepth = 1
            })
            .ToList();
        
        await _logger.LogBatchAsync(events);
    }
    
    [Benchmark]
    public async Task ConcurrentEventLogging()
    {
        var tasks = Enumerable.Range(0, _eventCount)
            .Select(async i =>
            {
                var @event = new ChaosEvent
                {
                    ChaosPointId = $"TEST-{i:000}",
                    Component = "Benchmark",
                    Type = ChaosEventType.ServiceHealthCheck,
                    Timestamp = DateTime.UtcNow,
                    Message = $"Concurrent event {i}",
                    Properties = new Dictionary<string, object> { ["Index"] = i },
                    CorrelationId = $"concurrent-{i}",
                    SessionId = "concurrent",
                    CallStackDepth = 1
                };
                
                await _logger.LogEventAsync(@event);
            })
            .ToArray();
        
        await Task.WhenAll(tasks);
    }
    
    [Benchmark]
    public async Task SanityTestLogging()
    {
        var test = new SanityTest
        {
            TestName = "BenchmarkSanityTest",
            Component = "Benchmark",
            PreCondition = new { Value = 42 },
            PostCondition = new { Value = 42 },
            Result = new SanityResult
            {
                Passed = true,
                Message = "Benchmark test passed"
            },
            Timestamp = DateTime.UtcNow,
            Context = new Dictionary<string, object>(),
            CorrelationId = "benchmark",
            SessionId = "benchmark"
        };
        
        await _logger.LogSanityTestAsync(test);
    }
}
```

### Expected Results

```json
{
  "benchmarkResults": {
    "singleEventLogging": {
      "mean": "0.85ms",
      "median": "0.72ms",
      "p95": "2.3ms",
      "p99": "5.1ms",
      "throughput": "1176 events/second"
    },
    "batchEventLogging": {
      "mean": "234ms",
      "median": "218ms", 
      "p95": "456ms",
      "p99": "789ms",
      "throughput": "42,735 events/second"
    },
    "concurrentEventLogging": {
      "mean": "87ms",
      "median": "79ms",
      "p95": "234ms", 
      "p99": "567ms",
      "throughput": "114,942 events/second"
    },
    "sanityTestLogging": {
      "mean": "1.2ms",
      "median": "1.05ms",
      "p95": "3.4ms",
      "p99": "7.8ms",
      "throughput": "833 tests/second"
    }
  }
}
```

---

## 10. Conclusion and Next Steps

### Summary

This comprehensive design provides a universal event logging and sanity test data collection system for 30+ chaos points across H0UND, H4ND, and FireKirin components. The system features:

1. **Universal Interface**: Single logging interface supporting all chaos point types
2. **Aspect-Oriented Programming**: Attribute-based instrumentation for easy adoption
3. **Performance Optimization**: Adaptive sampling and async batch processing
4. **Distributed Correlation**: Session-based tracing across components
5. **Sanity Testing Framework**: Pre/post-condition validation with custom tests
6. **MongoDB Schema**: Optimized for query performance and retention
7. **Configuration Management**: Dynamic configuration with hot-reload
8. **Monitoring Dashboard**: Real-time metrics and alerting

### Implementation Roadmap

**Phase 1: Core Infrastructure (Week 1-2)**
- Implement core interfaces and classes
- Set up MongoDB collections and indexes
- Create configuration system
- Implement basic logging pipeline

**Phase 2: Chaos Point Instrumentation (Week 3-4)**
- Instrument H0UND chaos points (ServiceOrchestrator, PollingWorker)
- Instrument H4ND chaos points (LegacyRuntimeHost, SignalDistributor)
- Implement sanity test framework
- Add performance sampling

**Phase 3: FireKirin Integration (Week 5)**
- Instrument CdpGameActions and LoginPhase
- Add async workflow tracing
- Implement login-specific sanity tests

**Phase 4: Optimization and Monitoring (Week 6-7)**
- Performance optimization and benchmarking
- Add monitoring dashboard API
- Implement alerting system
- Create deployment scripts

**Phase 5: Documentation and Training (Week 8)**
- Create comprehensive documentation
- Development team training
- Performance tuning and final optimization

### Success Metrics

- **Coverage**: 100% of chaos points instrumented
- **Performance**: Meet all latency and throughput targets
- **Reliability**: <99.9% logging uptime
- **Adoption**: 100% development team trained
- **Insights**: Actionable metrics from 30+ chaos points

### Risks and Mitigations

1. **Performance Impact**: Mitigated by adaptive sampling and async processing
2. **Storage Costs**: Mitigated by TTL indexes and configurable retention
3. **Complexity**: Mitigated by comprehensive documentation and training
4. **Configuration Errors**: Mitigated by validation and default fallbacks

This design provides a robust, scalable foundation for chaos point monitoring and sanity testing across the entire P4NTHE0N ecosystem, enabling comprehensive diagnostics and proactive issue detection.

---

*Design Document: DESIGN_051_CHAOS_LOGGING_ARCHITECTURE*  
*Universal Chaos Logging and Sanity Test Data Collection System*  
*2026-02-23*

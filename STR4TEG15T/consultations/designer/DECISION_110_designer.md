# DECISION_110 Designer Consultation: H4ND Architecture Refactoring

**Consultation Date**: 2026-02-22  
**Designer**: Aegis (Claude-3.5-Sonnet)  
**Decision**: DECISION_110 - H4ND Architecture Refactoring  
**Status**: Approved for Implementation  

---

## Executive Summary

This document provides the detailed implementation strategy for DECISION_110, transforming H4ND from a monolithic 912-line entry point into a domain-driven, SOLID-compliant architecture. The design preserves existing Navigation/ infrastructure while establishing clear domain boundaries and structured logging.

**Key Design Decisions**:
1. **Four Domain Boundaries**: Automation, Navigation, Monitoring, Execution
2. **Preserve Navigation/**: Existing step execution framework remains unchanged
3. **DDD Tactical Patterns**: Aggregates, Value Objects, Domain Events, Repositories
4. **Fail-Fast Everywhere**: Guard clauses, circuit breakers, context-rich exceptions
5. **Structured Logging**: 4 MongoDB collections with ILogger<T> abstraction

---

## Complete File Structure

```
H4ND/
├── EntryPoint/
│   └── Program.cs                    # < 100 lines, composition root only
├── Composition/
│   ├── ServiceCollectionExtensions.cs # DI registration
│   └── ApplicationBuilder.cs         # Application bootstrap
├── Domains/
│   ├── Common/                       # Shared domain primitives
│   │   ├── Guard.cs                  # Fail-fast validation helpers
││   ├── DomainException.cs           # Domain-specific exceptions
│   │   ├── IDomainEvent.cs           # Domain event marker interface
│   │   ├── AggregateRoot.cs          # Base aggregate class
│   │   └── ValueObject.cs            # Base value object class
│   ├── Automation/                   # Signal processing, credential lifecycle
│   │   ├── Aggregates/
│   │   │   ├── Credential.cs         # Credential aggregate root
│   │   │   └── SignalQueue.cs        # Signal queue aggregate
│   │   ├── ValueObjects/
│   │   │   ├── CredentialId.cs       # Typed ID
│   │   │   ├── Username.cs           # Username value object
│   │   │   ├── GamePlatform.cs       # Platform (FireKirin, OrionStars)
│   │   │   ├── Money.cs              # Money value object with validation
│   │   │   ├── Threshold.cs          # Jackpot threshold configuration
│   │   │   ├── DpdToggleState.cs     # Double-pointer-detection state
│   │   │   └── JackpotBalance.cs     # 4-tier jackpot balance
│   │   ├── Events/
│   │   │   ├── SignalReceivedEvent.cs
│   │   │   ├── CredentialLockedEvent.cs
│   │   │   ├── CredentialUnlockedEvent.cs
│   │   │   └── BalanceUpdatedEvent.cs
│   │   ├── Services/
│   │   │   ├── ISignalProcessor.cs   # Interface
│   │   │   ├── SignalProcessor.cs    # Signal processing logic
│   │   │   ├── ICredentialLifecycleManager.cs
│   │   │   └── CredentialLifecycleManager.cs
│   │   └── Repositories/
│   │       ├── ICredentialRepository.cs
│   │       └── ISignalRepository.cs
│   ├── Navigation/                   # PRESERVE EXISTING - No changes
│   │   ├── ErrorHandling/
│   │   ├── NavigationMap.cs
│   │   ├── NavigationMapLoader.cs
│   │   ├── Retry/
│   │   ├── StepExecutor.cs
│   │   ├── StepExecutionContext.cs
│   │   ├── StepExecutionResult.cs
│   │   ├── Strategies/
│   │   └── Verification/
│   ├── Execution/                    # Spin execution, jackpot detection
│   │   ├── Aggregates/
│   │   │   └── SpinSession.cs        # Spin session aggregate
│   │   ├── ValueObjects/
│   │   │   ├── SpinId.cs
│   │   │   ├── SpinResult.cs
│   │   │   ├── JackpotTier.cs        # Enum: Grand, Major, Minor, Mini
│   │   │   └── SpinMetrics.cs
│   │   ├── Events/
│   │   │   ├── SpinExecutedEvent.cs
│   │   │   ├── JackpotPoppedEvent.cs
│   │   │   └── ThresholdResetEvent.cs
│   │   ├── Services/
│   │   │   ├── ISpinExecutor.cs
│   │   │   ├── SpinExecutor.cs
│   │   │   ├── IJackpotDetector.cs
│   │   │   └── DpdJackpotDetector.cs # Double-pointer-detection
│   │   └── Repositories/
│   │       └── ISpinSessionRepository.cs
│   └── Monitoring/                   # Health checks, metrics
│       ├── Aggregates/
│       │   └── HealthCheck.cs        # Health check aggregate
│       ├── ValueObjects/
│       │   ├── HealthStatus.cs       # Healthy, Degraded, Unhealthy
│       │   ├── HealthMetric.cs
│       │   └── ComponentName.cs
│       ├── Events/
│       │   ├── HealthDegradedEvent.cs
│       │   └── HealthRecoveredEvent.cs
│       ├── Services/
│       │   ├── IHealthMonitor.cs
│       │   ├── HealthMonitor.cs
│       │   ├── IMetricsCollector.cs
│       │   └── MetricsCollector.cs
│       └── Repositories/
│           └── IHealthCheckRepository.cs
├── Infrastructure/
│   ├── Logging/
│   │   ├── IStructuredLogger.cs      # Abstraction
│   │   ├── MongoDbLoggerProvider.cs  # ILoggerProvider implementation
│   │   ├── MongoDbLogger.cs          # ILogger<T> implementation
│   │   ├── LogEntry.cs               # Log entry document
│   │   ├── LogLevelExtensions.cs     # Extensions
│   │   └── LogCollectionNames.cs     # L0G_0P3R4T10NAL, etc.
│   ├── Persistence/
│   │   ├── MongoDbCredentialRepository.cs
│   │   ├── MongoDbSignalRepository.cs
│   │   ├── MongoDbSpinSessionRepository.cs
│   │   ├── MongoDbHealthCheckRepository.cs
│   │   └── MongoDbContext.cs         # Shared MongoDB context
│   ├── Messaging/
│   │   ├── IDomainEventPublisher.cs
│   │   ├── InMemoryEventPublisher.cs
│   │   └── EventHandlerRegistry.cs
│   ├── Resilience/
│   │   ├── ICircuitBreaker.cs
│   │   ├── CircuitBreaker.cs
│   │   ├── CircuitBreakerConfig.cs
│   │   └── ResilienceExtensions.cs
│   └── Cdp/
│       ├── ICdpSessionManager.cs     # Refactored from existing
│       └── CdpSessionManager.cs
├── Parallel/                         # PRESERVE EXISTING - Minimal changes
│   ├── ParallelH4NDEngine.cs
│   ├── ParallelMetrics.cs
│   ├── ParallelSpinWorker.cs
│   ├── SignalClaimResult.cs
│   ├── SignalDistributor.cs
│   ├── SignalWorkItem.cs
│   ├── WorkerPool.cs
│   └── ChromeProfileManager.cs
└── Services/                         # Refactored existing services
    ├── CdpLifecycleManager.cs        # Keep existing
    ├── CdpLifecycleConfig.cs         # Keep existing
    ├── JackpotReader.cs              # Refactor to use structured logging
    ├── SessionPool.cs                # Refactor to use structured logging
    ├── SignalGenerator.cs            # Refactor to use structured logging
    └── (other existing services)
```

---

## Phase-by-Phase Implementation Plan

### Phase 1: Domain Foundation (Week 1) - 30K tokens

**Files to Create**:
```
H4ND/Domains/Common/
├── Guard.cs
├── DomainException.cs
├── IDomainEvent.cs
├── AggregateRoot.cs
└── ValueObject.cs

H4ND/Domains/Automation/ValueObjects/
├── CredentialId.cs
├── Username.cs
├── GamePlatform.cs
├── Money.cs
├── Threshold.cs
├── DpdToggleState.cs
└── JackpotBalance.cs
```

**Success Criteria**:
- All value objects have validation
- Guard clause helpers are functional
- Unit tests pass for all value objects

**Validation Checkpoint**:
- [ ] Money rejects negative values
- [ ] Username validates length constraints
- [ ] GamePlatform validates against enum values
- [ ] All value objects are immutable

---

### Phase 2: Structured Logging + Event Telemetry Infrastructure (Week 2) - 25K tokens

**Files to Create**:
```
P4NTHE0N/Infrastructure/Logging/
├── IStructuredLogger.cs
├── MongoDbLoggerProvider.cs
├── MongoDbLogger.cs
├── LogCollectionNames.cs
├── CorrelationContext.cs              # CorrelationId + domain dimensions
├── LogSchemas.cs                      # Schema-first: required fields + versions
├── OperationalLogEntry.cs              # L0G_0P3R4T10NAL
├── AuditLogEntry.cs                    # L0G_4UD1T
├── PerformanceMetricEntry.cs           # L0G_P3RF0RM4NC3
├── DomainEventLogEntry.cs              # L0G_D0M41N
├── DomainEventEnvelope.cs              # EventId/EventVersion/Aggregate info
├── BufferedLogWriter.cs                # Offline-first queue + batch flush
├── TelemetryLossCounters.cs            # Drop/flush/failure counters
├── DeltaPayloadEncoder.cs              # Optional delta-encoding for payloads
├── LogLevelExtensions.cs
└── StructuredLoggerExtensions.cs       # Helper methods + standard dimensions

P4NTHE0N/Infrastructure/Persistence/
└── MongoDbContext.cs
```

**MongoDB Collections**:
```javascript
// Execute in MongoDB shell
db.createCollection("L0G_0P3R4T10NAL", {
  timeseries: {
    timeField: "timestamp",
    metaField: "component",
    granularity: "seconds"
  }
});
db.L0G_0P3R4T10NAL.createIndex({ "timestamp": -1, "level": 1 });
db.L0G_0P3R4T10NAL.createIndex({ "correlationId": 1 });

db.createCollection("L0G_4UD1T");
db.L0G_4UD1T.createIndex({ "timestamp": -1 });
db.L0G_4UD1T.createIndex({ "userId": 1, "timestamp": -1 });
db.L0G_4UD1T.createIndex({ "eventType": 1 });

db.createCollection("L0G_P3RF0RM4NC3", {
  timeseries: {
    timeField: "timestamp",
    metaField: "metricName",
    granularity: "seconds"
  }
});
db.L0G_P3RF0RM4NC3.createIndex({ "timestamp": -1, "metricName": 1 });

db.createCollection("L0G_D0M41N");
db.L0G_D0M41N.createIndex({ "timestamp": -1 });
db.L0G_D0M41N.createIndex({ "eventId": 1 }, { unique: true });
db.L0G_D0M41N.createIndex({ "correlationId": 1 });
db.L0G_D0M41N.createIndex({ "aggregateId": 1 });
db.L0G_D0M41N.createIndex({ "eventType": 1, "timestamp": -1 });
```

**Success Criteria**:
- All 4 collections created with indexes
- ILogger<T> resolves to MongoDB logger
- Log entries include correlation ID + stable dimensions (mode, credentialId, platform, runId)
- Schema-first: each document includes `schemaVersion` and required fields validate before write
- Buffered writer: handles temporary sink outages (queue + batch flush)
- Loss accounting: dropped logs are counted and reported
- Performance: < 50ms write latency (steady state), < 10ms overhead for in-process log call

**Validation Checkpoint**:
- [ ] Logs written to L0G_0P3R4T10NAL
- [ ] Audit events in L0G_4UD1T
- [ ] Metrics in L0G_P3RF0RM4NC3
- [ ] Domain events in L0G_D0M41N
- [ ] Correlation ID flows through requests
- [ ] Domain events are idempotent (unique eventId)
- [ ] Buffered queue drains on recovery (no unbounded growth)
- [ ] Loss counters increment on forced drops

---

### Phase 3: Domain Aggregates and Events (Week 3) - 35K tokens

**Files to Create**:
```
H4ND/Domains/Automation/Aggregates/
├── Credential.cs
└── SignalQueue.cs

H4ND/Domains/Automation/Events/
├── SignalReceivedEvent.cs
├── CredentialLockedEvent.cs
├── CredentialUnlockedEvent.cs
└── BalanceUpdatedEvent.cs

H4ND/Domains/Execution/Aggregates/
└── SpinSession.cs

H4ND/Domains/Execution/ValueObjects/
├── SpinId.cs
├── SpinResult.cs
├── JackpotTier.cs
└── SpinMetrics.cs

H4ND/Domains/Execution/Events/
├── SpinExecutedEvent.cs
├── JackpotPoppedEvent.cs
└── ThresholdResetEvent.cs

H4ND/Domains/Monitoring/Aggregates/
└── HealthCheck.cs

H4ND/Domains/Monitoring/ValueObjects/
├── HealthStatus.cs
├── HealthMetric.cs
└── ComponentName.cs

H4ND/Domains/Monitoring/Events/
├── HealthDegradedEvent.cs
└── HealthRecoveredEvent.cs
```

**Success Criteria**:
- Aggregates enforce consistency boundaries
- Domain events raised on state changes
- Domain events persisted idempotently to `L0G_D0M41N` using `eventId` as a unique key; each event includes `correlationId` and `eventVersion`
- All aggregates have < 10 public methods
- Unit test coverage > 80%

**Validation Checkpoint**:
- [ ] Credential aggregate validates invariants
- [ ] Jackpot pop detection raises domain event
- [ ] Spin session tracks metrics correctly
- [ ] Health check transitions raise events

---

### Phase 4: Repository Layer (Week 4) - 25K tokens

**Files to Create**:
```
H4ND/Domains/Automation/Repositories/
├── ICredentialRepository.cs
└── ISignalRepository.cs

H4ND/Domains/Execution/Repositories/
└── ISpinSessionRepository.cs

H4ND/Domains/Monitoring/Repositories/
└── IHealthCheckRepository.cs

H4ND/Infrastructure/Persistence/
├── MongoDbCredentialRepository.cs
├── MongoDbSignalRepository.cs
├── MongoDbSpinSessionRepository.cs
└── MongoDbHealthCheckRepository.cs
```

**Success Criteria**:
- Repository interfaces in domain layer
- Implementations in infrastructure layer
- Async operations throughout
- Proper error handling

**Validation Checkpoint**:
- [ ] Repositories use async/await
- [ ] Exceptions converted to domain exceptions
- [ ] Unit of work pattern implemented
- [ ] Query performance < 100ms for common queries

---

### Phase 5: Service Layer Refactoring (Week 5-6) - 50K tokens

**Files to Create/Refactor**:
```
H4ND/Domains/Automation/Services/
├── ISignalProcessor.cs
├── SignalProcessor.cs
├── ICredentialLifecycleManager.cs
└── CredentialLifecycleManager.cs

H4ND/Domains/Execution/Services/
├── ISpinExecutor.cs
├── SpinExecutor.cs
├── IJackpotDetector.cs
└── DpdJackpotDetector.cs

H4ND/Domains/Monitoring/Services/
├── IHealthMonitor.cs
├── HealthMonitor.cs
├── IMetricsCollector.cs
└── MetricsCollector.cs
```

**Files to Refactor**:
```
H4ND/Services/
├── JackpotReader.cs          # Replace Console.WriteLine with ILogger
├── SessionPool.cs            # Replace Console.WriteLine with ILogger
├── SignalGenerator.cs        # Replace Console.WriteLine with ILogger
└── (other services)
```

**Success Criteria**:
- All services use constructor injection
- Zero Console.WriteLine in refactored code
- All services have interfaces
- Business logic extracted from H4ND.cs

**Validation Checkpoint**:
- [ ] SignalProcessor handles signals end-to-end
- [ ] DpdJackpotDetector uses DPD pattern correctly
- [ ] HealthMonitor tracks all components
- [ ] Services are testable with mocks

---

### Phase 6: Entry Point Refactoring (Week 7) - 20K tokens

**Files to Create**:
```
H4ND/EntryPoint/
└── Program.cs                # < 100 lines

H4ND/Composition/
├── ServiceCollectionExtensions.cs
└── ApplicationBuilder.cs
```

**H4ND.cs Migration**:
- Lines 1-175 (entry point + mode routing) → Program.cs
- Lines 224-621 (signal processing) → SignalProcessor.cs
- Lines 453-564 (jackpot detection) → DpdJackpotDetector.cs
- Lines 96-132 (CDP lifecycle) → CdpLifecycleManager.cs (enhance existing)
- Lines 596-609 (health monitoring) → HealthMonitor.cs
- Lines 647-746 (login/logout) → CdpGameActions.cs (move from Infrastructure)
- Lines 748-911 (balance query) → CredentialLifecycleManager.cs

**Success Criteria**:
- H4ND.cs deleted or < 100 lines
- Program.cs is composition root only
- All modes functional
- No regression in functionality

**Validation Checkpoint**:
- [ ] All run modes work (H4ND, SPIN, H0UND, FIRSTSPIN, PARALLEL, etc.)
- [ ] CDP pre-flight check passes
- [ ] Signal processing loop functional
- [ ] Health endpoint responds on port 9280

---

### Phase 7: Testing and Validation (Week 8) - 30K tokens

**Files to Create**:
```
H4ND.Tests/
├── Domains/
│   ├── Common/
│   ├── Automation/
│   ├── Execution/
│   └── Monitoring/
├── Infrastructure/
│   ├── Logging/
│   └── Persistence/
└── Integration/
```

**Success Criteria**:
- Unit test coverage > 80%
- Integration tests for repositories
- Load tests for logging infrastructure
- All existing tests still pass

**Validation Checkpoint**:
- [ ] 80%+ code coverage
- [ ] All unit tests pass
- [ ] Integration tests pass
- [ ] Performance within 10% of baseline

---

## Code Examples

### 1. Fail-Fast Guard Clause Pattern

```csharp
// File: H4ND/Domains/Common/Guard.cs
namespace P4NTH30N.H4ND.Domains.Common;

/// <summary>
/// Fail-fast validation helpers. Throws immediately on invalid input.
/// Based on arXiv:2108.03178v1 - precondition inference for safety.
/// </summary>
public static class Guard
{
    public static void AgainstNull([System.Diagnostics.CodeAnalysis.NotNull] object? value, string paramName)
    {
        if (value is null)
        {
            throw new DomainException($"Parameter '{paramName}' cannot be null.");
        }
    }

    public static void AgainstNullOrEmpty([System.Diagnostics.CodeAnalysis.NotNull] string? value, string paramName)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new DomainException($"Parameter '{paramName}' cannot be null or empty.");
        }
    }

    public static void AgainstNegative(decimal value, string paramName)
    {
        if (value < 0)
        {
            throw new DomainException($"Parameter '{paramName}' cannot be negative. Value: {value}");
        }
    }

    public static void AgainstNegative(double value, string paramName)
    {
        if (value < 0 || double.IsNaN(value) || double.IsInfinity(value))
        {
            throw new DomainException($"Parameter '{paramName}' must be a valid non-negative number. Value: {value}");
        }
    }

    public static void AgainstDefault<T>(T value, string paramName) where T : struct
    {
        if (value.Equals(default(T)))
        {
            throw new DomainException($"Parameter '{paramName}' cannot be default value.");
        }
    }

    public static void AgainstInvalidRange(int value, int min, int max, string paramName)
    {
        if (value < min || value > max)
        {
            throw new DomainException($"Parameter '{paramName}' must be between {min} and {max}. Value: {value}");
        }
    }

    public static void AgainstInvalidEnum<T>(T value, string paramName) where T : struct, Enum
    {
        if (!Enum.IsDefined(typeof(T), value))
        {
            throw new DomainException($"Parameter '{paramName}' has invalid enum value. Value: {value}");
        }
    }

    /// <summary>
    /// Validates preconditions before any side effects. Fails immediately with full context.
    /// </summary>
    public static void Preconditions(bool condition, string message, string? correlationId = null)
    {
        if (!condition)
        {
            var fullMessage = correlationId is null 
                ? message 
                : $"[CorrelationId: {correlationId}] {message}";
            throw new DomainException(fullMessage);
        }
    }
}
```

**Usage Example**:
```csharp
// File: H4ND/Domains/Automation/ValueObjects/Money.cs
public sealed record Money
{
    public decimal Amount { get; }

    public Money(decimal amount)
    {
        // Fail-fast: Validate BEFORE any side effects
        Guard.AgainstNegative(amount, nameof(amount));
        Guard.Preconditions(
            !decimal.IsNaN(amount) && !decimal.IsInfinity(amount),
            "Money amount must be a valid number."
        );
        
        Amount = amount;
    }

    public static Money Zero => new(0);
    public bool IsNegative => Amount < 0;
}
```

### 2. Domain Event Raising and Handling

```csharp
// File: H4ND/Domains/Common/IDomainEvent.cs
namespace P4NTH30N.H4ND.Domains.Common;

/// <summary>
/// Marker interface for domain events.
/// Events represent something that happened in the domain.
/// </summary>
public interface IDomainEvent
{
    Guid EventId { get; }
    DateTime Timestamp { get; }
    string EventType { get; }
}

// File: H4ND/Domains/Common/AggregateRoot.cs
namespace P4NTH30N.H4ND.Domains.Common;

/// <summary>
/// Base class for all aggregate roots.
/// Aggregates enforce consistency boundaries and raise domain events.
/// </summary>
public abstract class AggregateRoot
{
    private readonly List<IDomainEvent> _domainEvents = new();

    public Guid Id { get; protected set; }
    public DateTime CreatedAt { get; protected set; }
    public DateTime ModifiedAt { get; protected set; }

    public IReadOnlyCollection<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();

    protected void RaiseEvent(IDomainEvent domainEvent)
    {
        _domainEvents.Add(domainEvent);
    }

    public void ClearDomainEvents()
    {
        _domainEvents.Clear();
    }

    protected void MarkModified()
    {
        ModifiedAt = DateTime.UtcNow;
    }
}

// File: H4ND/Domains/Execution/Events/JackpotPoppedEvent.cs
namespace P4NTH30N.H4ND.Domains.Execution.Events;

using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

/// <summary>
/// Raised when a jackpot pop is detected via DPD pattern.
/// </summary>
public sealed record JackpotPoppedEvent : IDomainEvent
{
    public Guid EventId { get; } = Guid.NewGuid();
    public DateTime Timestamp { get; } = DateTime.UtcNow;
    public string EventType => nameof(JackpotPoppedEvent);

    public Guid CredentialId { get; }
    public JackpotTier Tier { get; }
    public decimal PreviousValue { get; }
    public decimal CurrentValue { get; }
    public decimal DropAmount { get; }

    public JackpotPoppedEvent(
        Guid credentialId,
        JackpotTier tier,
        decimal previousValue,
        decimal currentValue)
    {
        CredentialId = credentialId;
        Tier = tier;
        PreviousValue = previousValue;
        CurrentValue = currentValue;
        DropAmount = previousValue - currentValue;
    }
}

// File: H4ND/Domains/Execution/Aggregates/SpinSession.cs
namespace P4NTH30N.H4ND.Domains.Execution.Aggregates;

using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.Events;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

public sealed class SpinSession : AggregateRoot
{
    public Guid CredentialId { get; private set; }
    public SpinId SpinId { get; private set; } = null!;
    public DateTime StartTime { get; private set; }
    public DateTime? EndTime { get; private set; }
    public SpinResult? Result { get; private set; }
    public bool IsComplete { get; private set; }

    private SpinSession() { } // EF Core protected/private constructor

    public static SpinSession Start(Guid credentialId, SpinId spinId)
    {
        Guard.AgainstDefault(credentialId, nameof(credentialId));
        Guard.AgainstNull(spinId, nameof(spinId));

        return new SpinSession
        {
            Id = Guid.NewGuid(),
            CredentialId = credentialId,
            SpinId = spinId,
            StartTime = DateTime.UtcNow,
            CreatedAt = DateTime.UtcNow,
            ModifiedAt = DateTime.UtcNow
        };
    }

    public void Complete(SpinResult result)
    {
        Guard.AgainstNull(result, nameof(result));
        Guard.Preconditions(!IsComplete, "Spin session is already complete.");

        Result = result;
        EndTime = DateTime.UtcNow;
        IsComplete = true;

        RaiseEvent(new SpinExecutedEvent(Id, CredentialId, SpinId, result));
        MarkModified();
    }
}
```

### 3. Repository Interface Design

```csharp
// File: H4ND/Domains/Automation/Repositories/ICredentialRepository.cs
namespace P4NTH30N.H4ND.Domains.Automation.Repositories;

using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;

/// <summary>
/// Repository for Credential aggregates.
/// Follows Repository pattern - abstracts persistence concerns.
/// </summary>
public interface ICredentialRepository
{
    Task<Credential?> GetByIdAsync(CredentialId id, CancellationToken ct = default);
    Task<Credential?> GetByUsernameAsync(Username username, GamePlatform platform, CancellationToken ct = default);
    Task<IReadOnlyCollection<Credential>> GetByPlatformAsync(GamePlatform platform, CancellationToken ct = default);
    Task<IReadOnlyCollection<Credential>> GetLockedAsync(CancellationToken ct = default);
    Task<IReadOnlyCollection<Credential>> GetUnlockedAsync(CancellationToken ct = default);
    Task<bool> ExistsAsync(CredentialId id, CancellationToken ct = default);
    Task AddAsync(Credential credential, CancellationToken ct = default);
    Task UpdateAsync(Credential credential, CancellationToken ct = default);
    Task DeleteAsync(CredentialId id, CancellationToken ct = default);
    Task<long> CountAsync(CancellationToken ct = default);
}

// File: H4ND/Domains/Automation/Repositories/ISignalRepository.cs
namespace P4NTH30N.H4ND.Domains.Automation.Repositories;

using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;

/// <summary>
/// Repository for SignalQueue aggregates.
/// </summary>
public interface ISignalRepository
{
    Task<SignalQueue?> GetPendingAsync(CancellationToken ct = default);
    Task<SignalQueue?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<IReadOnlyCollection<SignalQueue>> GetByPriorityAsync(int minPriority, CancellationToken ct = default);
    Task AddAsync(SignalQueue signal, CancellationToken ct = default);
    Task UpdateAsync(SignalQueue signal, CancellationToken ct = default);
    Task AcknowledgeAsync(Guid signalId, CancellationToken ct = default);
    Task<IReadOnlyCollection<SignalQueue>> GetUnacknowledgedAsync(TimeSpan olderThan, CancellationToken ct = default);
}

// File: H4ND/Domains/Execution/Repositories/ISpinSessionRepository.cs
namespace P4NTH30N.H4ND.Domains.Execution.Repositories;

using P4NTH30N.H4ND.Domains.Execution.Aggregates;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

public interface ISpinSessionRepository
{
    Task<SpinSession?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<SpinSession?> GetBySpinIdAsync(SpinId spinId, CancellationToken ct = default);
    Task<IReadOnlyCollection<SpinSession>> GetByCredentialAsync(Guid credentialId, CancellationToken ct = default);
    Task<IReadOnlyCollection<SpinSession>> GetIncompleteAsync(CancellationToken ct = default);
    Task<IReadOnlyCollection<SpinSession>> GetRecentAsync(TimeSpan timeWindow, CancellationToken ct = default);
    Task AddAsync(SpinSession session, CancellationToken ct = default);
    Task UpdateAsync(SpinSession session, CancellationToken ct = default);
    Task<long> CountAsync(CancellationToken ct = default);
}

// File: H4ND/Infrastructure/Persistence/MongoDbCredentialRepository.cs
namespace P4NTH30N.H4ND.Infrastructure.Persistence;

using MongoDB.Driver;
using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Automation.Repositories;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;

public sealed class MongoDbCredentialRepository : ICredentialRepository
{
    private readonly IMongoCollection<Credential> _collection;
    private readonly ILogger<MongoDbCredentialRepository> _logger;

    public MongoDbCredentialRepository(IMongoDatabase database, ILogger<MongoDbCredentialRepository> logger)
    {
        _collection = database.GetCollection<Credential>("CR3D3N7IAL");
        _logger = logger;
    }

    public async Task<Credential?> GetByIdAsync(CredentialId id, CancellationToken ct = default)
    {
        Guard.AgainstNull(id, nameof(id));

        using var _ = _logger.BeginScope("{CorrelationId}", Guid.NewGuid());
        _logger.LogDebug("Fetching credential by ID: {CredentialId}", id.Value);

        var filter = Builders<Credential>.Filter.Eq(c => c.Id, id);
        var credential = await _collection.Find(filter).FirstOrDefaultAsync(ct);

        if (credential is null)
        {
            _logger.LogWarning("Credential not found: {CredentialId}", id.Value);
        }

        return credential;
    }

    public async Task<Credential?> GetByUsernameAsync(Username username, GamePlatform platform, CancellationToken ct = default)
    {
        Guard.AgainstNull(username, nameof(username));

        var filter = Builders<Credential>.Filter.And(
            Builders<Credential>.Filter.Eq(c => c.Username, username.Value),
            Builders<Credential>.Filter.Eq(c => c.Platform, platform)
        );

        return await _collection.Find(filter).FirstOrDefaultAsync(ct);
    }

    public async Task<IReadOnlyCollection<Credential>> GetUnlockedAsync(CancellationToken ct = default)
    {
        var filter = Builders<Credential>.Filter.Eq(c => c.IsUnlocked, true);
        return await _collection.Find(filter).ToListAsync(ct);
    }

    public async Task AddAsync(Credential credential, CancellationToken ct = default)
    {
        Guard.AgainstNull(credential, nameof(credential));

        // Persist domain events to L0G_D0M41N before saving
        foreach (var domainEvent in credential.DomainEvents)
        {
            _logger.LogInformation("Domain event raised: {EventType}", domainEvent.EventType);
        }

        await _collection.InsertOneAsync(credential, cancellationToken: ct);
        credential.ClearDomainEvents();

        _logger.LogInformation("Credential created: {CredentialId}", credential.Id);
    }

    public async Task UpdateAsync(Credential credential, CancellationToken ct = default)
    {
        Guard.AgainstNull(credential, nameof(credential));

        var filter = Builders<Credential>.Filter.Eq(c => c.Id, credential.Id);
        await _collection.ReplaceOneAsync(filter, credential, cancellationToken: ct);

        credential.ClearDomainEvents();
        _logger.LogInformation("Credential updated: {CredentialId}", credential.Id);
    }

    // ... other methods
}
```

### 4. Structured Logging Usage

```csharp
// File: H4ND/Infrastructure/Logging/LogCollectionNames.cs
namespace P4NTH30N.H4ND.Infrastructure.Logging;

/// <summary>
/// MongoDB collection names for structured logging.
/// Follows P4NTH30N obfuscation pattern.
/// </summary>
public static class LogCollectionNames
{
    /// <summary>
    /// Application operational logs (DEBUG, INFO, WARN, ERROR)
    /// Time-series collection for high-volume logs
    /// </summary>
    public const string Operational = "L0G_0P3R4T10NAL";

    /// <summary>
    /// Security and audit events (logins, access, changes)
    /// Standard collection with long retention
    /// </summary>
    public const string Audit = "L0G_4UD1T";

    /// <summary>
    /// Performance metrics and timing data
    /// Time-series collection for metrics aggregation
    /// </summary>
    public const string Performance = "L0G_P3RF0RM4NC3";

    /// <summary>
    /// Domain events for event sourcing/auditing
    /// Standard collection with aggregate indexing
    /// </summary>
    public const string Domain = "L0G_D0M41N";
}

// File: H4ND/Infrastructure/Logging/LogEntry.cs
namespace P4NTH30N.H4ND.Infrastructure.Logging;

using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

/// <summary>
/// Log entry document for MongoDB storage.
/// </summary>
[BsonIgnoreExtraElements]
public sealed class LogEntry
{
    [BsonId]
    public ObjectId Id { get; set; } = ObjectId.GenerateNewId();

    [BsonElement("timestamp")]
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;

    [BsonElement("level")]
    public string Level { get; set; } = string.Empty;

    [BsonElement("component")]
    public string Component { get; set; } = string.Empty;

    [BsonElement("message")]
    public string Message { get; set; } = string.Empty;

    [BsonElement("correlationId")]
    public string? CorrelationId { get; set; }

    [BsonElement("exception")]
    public string? Exception { get; set; }

    [BsonElement("properties")]
    [BsonIgnoreIfNull]
    public Dictionary<string, object>? Properties { get; set; }

    [BsonElement("sourceContext")]
    public string SourceContext { get; set; } = string.Empty;
}

// File: H4ND/Infrastructure/Logging/MongoDbLogger.cs
namespace P4NTH30N.H4ND.Infrastructure.Logging;

using MongoDB.Driver;

/// <summary>
/// ILogger implementation that writes to MongoDB.
/// </summary>
public sealed class MongoDbLogger : ILogger
{
    private readonly string _categoryName;
    private readonly IMongoCollection<LogEntry> _operationalCollection;
    private readonly IMongoCollection<LogEntry> _auditCollection;
    private readonly IMongoCollection<LogEntry> _performanceCollection;

    public MongoDbLogger(
        string categoryName,
        IMongoDatabase database)
    {
        _categoryName = categoryName;
        _operationalCollection = database.GetCollection<LogEntry>(LogCollectionNames.Operational);
        _auditCollection = database.GetCollection<LogEntry>(LogCollectionNames.Audit);
        _performanceCollection = database.GetCollection<LogEntry>(LogCollectionNames.Performance);
    }

    public IDisposable? BeginScope<TState>(TState state) where TState : notnull
    {
        return new LoggerScope(state);
    }

    public bool IsEnabled(LogLevel logLevel) => true;

    public void Log<TState>(
        LogLevel logLevel,
        EventId eventId,
        TState state,
        Exception? exception,
        Func<TState, Exception?, string> formatter)
    {
        if (!IsEnabled(logLevel))
            return;

        var entry = new LogEntry
        {
            Timestamp = DateTime.UtcNow,
            Level = logLevel.ToString(),
            Component = _categoryName.Split('.').LastOrDefault() ?? _categoryName,
            Message = formatter(state, exception),
            SourceContext = _categoryName,
            Exception = exception?.ToString()
        };

        // Route to appropriate collection based on log characteristics
        var collection = RouteToCollection(logLevel, eventId, state);
        
        // Fire-and-forget for performance (or use async with buffer)
        _ = collection.InsertOneAsync(entry);
    }

    private IMongoCollection<LogEntry> RouteToCollection<TState>(
        LogLevel logLevel,
        EventId eventId,
        TState state)
    {
        // Audit events: Security-related, logins, credential changes
        if (eventId.Id >= 10000 && eventId.Id < 20000)
        {
            return _auditCollection;
        }

        // Performance events: Timing, metrics
        if (eventId.Id >= 20000 && eventId.Id < 30000)
        {
            return _performanceCollection;
        }

        // Default to operational
        return _operationalCollection;
    }

    private class LoggerScope : IDisposable
    {
        private readonly object _state;
        public LoggerScope(object state) => _state = state;
        public void Dispose() { }
    }
}

// File: H4ND/Infrastructure/Logging/MongoDbLoggerProvider.cs
namespace P4NTH30N.H4ND.Infrastructure.Logging;

using Microsoft.Extensions.Logging;
using MongoDB.Driver;

/// <summary>
/// ILoggerProvider that creates MongoDB loggers.
/// </summary>
public sealed class MongoDbLoggerProvider : ILoggerProvider
{
    private readonly IMongoDatabase _database;

    public MongoDbLoggerProvider(IMongoDatabase database)
    {
        _database = database;
    }

    public ILogger CreateLogger(string categoryName)
    {
        return new MongoDbLogger(categoryName, _database);
    }

    public void Dispose()
    {
        // No-op - MongoDB client is managed externally
    }
}
```

**Usage in Domain Services**:
```csharp
// File: H4ND/Domains/Execution/Services/DpdJackpotDetector.cs
namespace P4NTH30N.H4ND.Domains.Execution.Services;

using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.Events;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

public sealed class DpdJackpotDetector : IJackpotDetector
{
    private readonly ILogger<DpdJackpotDetector> _logger;
    private readonly IDomainEventPublisher _eventPublisher;

    public DpdJackpotDetector(
        ILogger<DpdJackpotDetector> logger,
        IDomainEventPublisher eventPublisher)
    {
        _logger = logger;
        _eventPublisher = eventPublisher;
    }

    /// <summary>
    /// Detects jackpot pop using Double-Pointer-Detection pattern.
    /// Two consecutive drops > threshold confirms pop.
    /// </summary>
    public async Task<JackpotDetectionResult> DetectAsync(
        Credential credential,
        JackpotBalance newReading,
        CancellationToken ct = default)
    {
        Guard.AgainstNull(credential, nameof(credential));
        Guard.AgainstNull(newReading, nameof(newReading));

        using var scope = _logger.BeginScope(new Dictionary<string, object>
        {
            ["CorrelationId"] = Guid.NewGuid(),
            ["CredentialId"] = credential.Id,
            ["Platform"] = credential.Platform.ToString()
        });

        _logger.LogInformation(
            "Starting jackpot detection for {Username} on {Platform}. " +
            "Previous: {PreviousBalance}, New: {NewBalance}",
            credential.Username,
            credential.Platform,
            credential.JackpotBalance,
            newReading);

        var result = new JackpotDetectionResult();

        // Check each tier
        result.GrandPopped = await CheckTierAsync(
            credential,
            JackpotTier.Grand,
            credential.JackpotBalance.Grand,
            newReading.Grand,
            credential.Thresholds.GrandDrop,
            ct);

        result.MajorPopped = await CheckTierAsync(
            credential,
            JackpotTier.Major,
            credential.JackpotBalance.Major,
            newReading.Major,
            credential.Thresholds.MajorDrop,
            ct);

        // ... Minor and Mini

        _logger.LogInformation(
            "Jackpot detection complete. GrandPopped: {GrandPopped}, MajorPopped: {MajorPopped}",
            result.GrandPopped,
            result.MajorPopped);

        return result;
    }

    private async Task<bool> CheckTierAsync(
        Credential credential,
        JackpotTier tier,
        decimal previousValue,
        decimal newValue,
        decimal threshold,
        CancellationToken ct)
    {
        var drop = previousValue - newValue;

        if (drop <= threshold)
        {
            return false;
        }

        _logger.LogWarning(
            "Jackpot drop detected: {Tier} dropped {DropAmount:F2} " +
            "(threshold: {Threshold:F2}). Previous: {Previous:F2}, New: {New:F2}",
            tier,
            drop,
            threshold,
            previousValue,
            newValue);

        // DPD Pattern: First drop sets toggle, second drop confirms
        if (!credential.DpdToggleState.IsToggleSet(tier))
        {
            credential.DpdToggleState.SetToggle(tier);
            _logger.LogInformation(
                "First drop detected for {Tier}. Toggle set, awaiting confirmation.",
                tier);
            return false;
        }

        // Second consecutive drop - CONFIRM POP
        _logger.LogCritical(
            "JACKPOT POP CONFIRMED: {Tier} on {Platform}/{Game}! " +
            "Drop: {Drop:F2}, Previous: {Previous:F2}, New: {New:F2}",
            tier,
            credential.Platform,
            credential.Game,
            drop,
            previousValue,
            newValue);

        // Raise domain event
        var @event = new JackpotPoppedEvent(
            credential.Id.Value,
            tier,
            previousValue,
            newValue);

        await _eventPublisher.PublishAsync(@event, ct);

        return true;
    }
}
```

---

## Migration Strategy: Console.WriteLine to Structured Logging

### Step 1: Identify All Console.WriteLine Calls

```bash
# PowerShell command to find all Console.WriteLine usages
grep -r "Console.WriteLine" H4ND --include="*.cs" | grep -v ".test.cs"
```

**Expected output categories**:
1. **Operational logging**: Status updates, progress indicators
2. **Error logging**: Exception messages, failure details
3. **Debug logging**: Development-time diagnostics
4. **Audit logging**: Security events, credential access

### Step 2: Create Mapping Table

| Current Console.WriteLine | New ILogger Call | Collection | Example |
|---------------------------|------------------|------------|---------|
| Status/progress | LogInformation | L0G_0P3R4T10NAL | `logger.LogInformation("Processing signal: {SignalId}", id)` |
| Warnings | LogWarning | L0G_0P3R4T10NAL | `logger.LogWarning("Retry attempt {Attempt}", attempt)` |
| Errors | LogError | L0G_0P3R4T10NAL | `logger.LogError(ex, "Failed to process signal")` |
| Security events | LogInformation with EventId 10000+ | L0G_4UD1T | `logger.LogInformation(10001, "Credential accessed: {Username}", username)` |
| Performance timing | LogInformation with EventId 20000+ | L0G_P3RF0RM4NC3 | `logger.LogInformation(20001, "Operation completed in {ElapsedMs}ms", elapsed)` |
| Jackpot pops | LogCritical + Domain Event | L0G_D0M41N | Domain event raised, logged to domain collection |

### Step 3: Refactor Pattern

**Before**:
```csharp
Console.WriteLine($"[JackpotReader:{platform}] {jackpotType} = {value.Value / 100:F2}");
```

**After**:
```csharp
_logger.LogInformation(
    "[{Platform}] {JackpotType} = {Value:F2}",
    platform,
    jackpotType,
    value.Value / 100);
```

### Step 4: Services Refactoring Order

1. **SessionPool.cs** (lines: 231) - High priority, core component
2. **JackpotReader.cs** (lines: 110) - High priority, jackpot detection
3. **SignalGenerator.cs** - Medium priority
4. **CdpLifecycleManager.cs** - Medium priority
5. **BurnInController.cs** - Low priority (monitoring)
6. **FirstSpinController.cs** - Low priority (specialized)

### Step 5: Backward Compatibility During Migration

```csharp
// Temporary dual-logging approach during migration
public static class LogMigrationHelper
{
    private static bool _useStructuredLogging = false;

    public static void EnableStructuredLogging() => _useStructuredLogging = true;

    public static void Log(ILogger? logger, string message, LogLevel level = LogLevel.Information)
    {
        // Always write to console for backward compatibility
        Console.WriteLine(message);

        // Also write to structured logger if available
        if (_useStructuredLogging && logger != null)
        {
            logger.Log(level, message);
        }
    }
}
```

### Step 6: Validation Checklist

- [ ] All Console.WriteLine calls replaced
- [ ] ILogger<T> injected in all services
- [ ] Logs appear in correct MongoDB collections
- [ ] Correlation ID flows through requests
- [ ] Performance impact < 10%
- [ ] No loss of log information

---

## Class Skeletons

### Domain Common

```csharp
// H4ND/Domains/Common/DomainException.cs
namespace P4NTH30N.H4ND.Domains.Common;

public sealed class DomainException : Exception
{
    public string? CorrelationId { get; }
    public string? Operation { get; }

    public DomainException(string message) : base(message) { }
    
    public DomainException(string message, string correlationId) : base(message)
    {
        CorrelationId = correlationId;
    }
}
```

### Automation Domain

```csharp
// H4ND/Domains/Automation/Aggregates/Credential.cs
namespace P4NTH30N.H4ND.Domains.Automation.Aggregates;

using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;
using P4NTH30N.H4ND.Domains.Automation.Events;

public sealed class Credential : AggregateRoot
{
    public CredentialId Id { get; private set; } = null!;
    public Username Username { get; private set; } = null!;
    public GamePlatform Platform { get; private set; }
    public string Game { get; private set; } = string.Empty;
    public JackpotBalance JackpotBalance { get; private set; } = null!;
    public ThresholdConfiguration Thresholds { get; private set; } = null!;
    public DpdToggleState DpdToggleState { get; private set; } = null!;
    public bool IsUnlocked { get; private set; } = true;
    public DateTime? LockExpiry { get; private set; }

    private Credential() { } // EF Core

    public static Credential Create(
        CredentialId id,
        Username username,
        GamePlatform platform,
        string game,
        JackpotBalance jackpots,
        ThresholdConfiguration thresholds)
    {
        // Validation via Guard clauses
        Guard.AgainstNull(id, nameof(id));
        Guard.AgainstNull(username, nameof(username));
        Guard.AgainstNullOrEmpty(game, nameof(game));
        Guard.AgainstNull(jackpots, nameof(jackpots));
        Guard.AgainstNull(thresholds, nameof(thresholds));

        var credential = new Credential
        {
            Id = id,
            Username = username,
            Platform = platform,
            Game = game,
            JackpotBalance = jackpots,
            Thresholds = thresholds,
            DpdToggleState = new DpdToggleState(),
            CreatedAt = DateTime.UtcNow,
            ModifiedAt = DateTime.UtcNow
        };

        credential.RaiseEvent(new CredentialCreatedEvent(id, username, platform));
        return credential;
    }

    public void Lock(TimeSpan duration)
    {
        Guard.Preconditions(IsUnlocked, "Credential is already locked.");
        
        IsUnlocked = false;
        LockExpiry = DateTime.UtcNow.Add(duration);
        
        RaiseEvent(new CredentialLockedEvent(Id, LockExpiry.Value));
        MarkModified();
    }

    public void Unlock()
    {
        Guard.Preconditions(!IsUnlocked, "Credential is not locked.");
        
        IsUnlocked = true;
        LockExpiry = null;
        
        RaiseEvent(new CredentialUnlockedEvent(Id));
        MarkModified();
    }

    public void RecordJackpotReading(JackpotBalance newBalance)
    {
        Guard.AgainstNull(newBalance, nameof(newBalance));

        var previousBalance = JackpotBalance;
        JackpotBalance = newBalance;

        RaiseEvent(new BalanceUpdatedEvent(Id, previousBalance, newBalance));
        MarkModified();
    }

    public bool IsValid(IStoreErrors? errorLogger = null)
    {
        if (JackpotBalance.Grand.IsNegative)
        {
            errorLogger?.Insert(ErrorLog.Create(
                ErrorType.ValidationError,
                $"Credential:{Username}@{Platform}/{Game}",
                "Grand jackpot cannot be negative",
                ErrorSeverity.High));
            return false;
        }
        return true;
    }
}
```

### Execution Domain

```csharp
// H4ND/Domains/Execution/ValueObjects/JackpotTier.cs
namespace P4NTH30N.H4ND.Domains.Execution.ValueObjects;

public enum JackpotTier
{
    Grand = 4,
    Major = 3,
    Minor = 2,
    Mini = 1
}

// H4ND/Domains/Execution/Services/IJackpotDetector.cs
namespace P4NTH30N.H4ND.Domains.Execution.Services;

using P4NTH30N.H4ND.Domains.Automation.Aggregates;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

public interface IJackpotDetector
{
    Task<JackpotDetectionResult> DetectAsync(
        Credential credential,
        JackpotBalance newReading,
        CancellationToken ct = default);
}

public sealed class JackpotDetectionResult
{
    public bool GrandPopped { get; set; }
    public bool MajorPopped { get; set; }
    public bool MinorPopped { get; set; }
    public bool MiniPopped { get; set; }
    public bool AnyPopped => GrandPopped || MajorPopped || MinorPopped || MiniPopped;
}
```

### Monitoring Domain

```csharp
// H4ND/Domains/Monitoring/ValueObjects/HealthStatus.cs
namespace P4NTH30N.H4ND.Domains.Monitoring.ValueObjects;

public enum HealthStatus
{
    Healthy,
    Degraded,
    Unhealthy
}

// H4ND/Domains/Monitoring/Services/IHealthMonitor.cs
namespace P4NTH30N.H4ND.Domains.Monitoring.Services;

using P4NTH30N.H4ND.Domains.Monitoring.ValueObjects;

public interface IHealthMonitor
{
    Task<HealthStatus> CheckComponentAsync(ComponentName component, CancellationToken ct = default);
    Task<IReadOnlyCollection<HealthMetric>> GetMetricsAsync(ComponentName component, CancellationToken ct = default);
    Task RecordMetricAsync(ComponentName component, string metricName, double value, double threshold, CancellationToken ct = default);
}
```

### Infrastructure

```csharp
// H4ND/Infrastructure/Messaging/IDomainEventPublisher.cs
namespace P4NTH30N.H4ND.Infrastructure.Messaging;

using P4NTH30N.H4ND.Domains.Common;

public interface IDomainEventPublisher
{
    Task PublishAsync<TEvent>(TEvent domainEvent, CancellationToken ct = default) where TEvent : IDomainEvent;
    Task PublishAsync(IDomainEvent domainEvent, CancellationToken ct = default);
}

// H4ND/Infrastructure/Resilience/ICircuitBreaker.cs
namespace P4NTH30N.H4ND.Infrastructure.Resilience;

public interface ICircuitBreaker
{
    Task<TResult> ExecuteAsync<TResult>(Func<Task<TResult>> operation, CancellationToken ct = default);
    Task ExecuteAsync(Func<Task> operation, CancellationToken ct = default);
    CircuitState State { get; }
}

public enum CircuitState
{
    Closed,     // Normal operation
    Open,       // Failing, rejecting requests
    HalfOpen    // Testing if service recovered
}
```

---

## Validation Checkpoints

### Checkpoint 1: Phase 1 Complete (Domain Foundation)

**Tests Required**:
```csharp
// Money validation tests
[Fact]
public void Money_WithNegativeValue_ThrowsDomainException()
{
    Assert.Throws<DomainException>(() => new Money(-1));
}

[Fact]
public void Money_WithNaN_ThrowsDomainException()
{
    Assert.Throws<DomainException>(() => new Money(decimal.Parse("NaN")));
}

[Fact]
public void Money_WithValidValue_CreatesInstance()
{
    var money = new Money(100.50m);
    Assert.Equal(100.50m, money.Amount);
}
```

**Checklist**:
- [ ] Guard clauses work for all primitive types
- [ ] All value objects validate in constructors
- [ ] DomainException includes correlation ID when provided
- [ ] Unit tests pass for all value objects

### Checkpoint 2: Phase 2 Complete (Logging Infrastructure)

**Tests Required**:
```csharp
[Fact]
public async Task Logger_WritesToOperationalCollection()
{
    var logger = _loggerFactory.CreateLogger<TestClass>();
    logger.LogInformation("Test message");
    
    await Task.Delay(100); // Allow async write
    
    var entry = await _operationalCollection.Find(_ => true).FirstAsync();
    Assert.Equal("Test message", entry.Message);
    Assert.Equal("Information", entry.Level);
}
```

**Checklist**:
- [ ] All 4 collections exist with correct indexes
- [ ] Logs route to correct collection by EventId
- [ ] Correlation ID flows through LoggerScope
- [ ] Write latency < 50ms
- [ ] No blocking on log writes

### Checkpoint 3: Phase 5 Complete (Service Layer)

**Integration Test**:
```csharp
[Fact]
public async Task SignalProcessor_EndToEnd_ProcessesSignal()
{
    // Arrange
    var credential = CreateTestCredential();
    var signal = CreateTestSignal();
    
    // Act
    await _signalProcessor.ProcessAsync(signal, credential);
    
    // Assert
    var processedSignal = await _signalRepository.GetByIdAsync(signal.Id);
    Assert.True(processedSignal?.IsProcessed);
    
    var logEntry = await _domainCollection
        .Find(l => l.EventType == "SignalProcessedEvent")
        .FirstOrDefaultAsync();
    Assert.NotNull(logEntry);
}
```

**Checklist**:
- [ ] Signal processing works end-to-end
- [ ] Jackpot detection raises domain events
- [ ] All services use structured logging
- [ ] Zero Console.WriteLine in production code
- [ ] Services are testable with mocks

### Checkpoint 4: Phase 6 Complete (Entry Point)

**Smoke Test**:
```bash
# Build and run
dotnet build H4ND
dotnet run --project H4ND -- H4ND

# Verify
# - Program.cs < 100 lines
# - All modes functional
# - Health endpoint responds
# - No Console.WriteLine output
```

**Checklist**:
- [ ] H4ND.cs deleted or < 100 lines
- [ ] All run modes work
- [ ] CDP pre-flight passes
- [ ] Health endpoint on port 9280 responds
- [ ] No regression in functionality

### Checkpoint 5: Phase 7 Complete (Testing)

**Metrics**:
- Unit test coverage: > 80%
- Integration tests: All pass
- Performance: Within 10% of baseline
- Code quality: No files > 300 lines

**Checklist**:
- [ ] Code coverage report shows > 80%
- [ ] All integration tests pass
- [ ] Load tests pass (100 concurrent operations)
- [ ] Documentation updated
- [ ] Team knowledge transfer complete

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Regression in signal processing | Comprehensive integration tests before each phase; feature flags for gradual rollout |
| Performance degradation | Benchmark current; measure after each phase; optimize hot paths |
| Migration data loss | Dual-write during transition; validation scripts; backup before migration |
| CDP integration breakage | Integration tests with real Chrome; smoke test before each commit |
| Fail-fast causing instability | Circuit breakers; graceful degradation; monitoring alerts |
| Token budget overrun | Phase gates; early checkpoint validation; prioritize critical path |

---

## Token Budget Allocation

| Phase | Estimated Tokens | Cumulative |
|-------|------------------|------------|
| Phase 1: Domain Foundation | 30K | 30K |
| Phase 2: Logging Infrastructure | 25K | 55K |
| Phase 3: Domain Aggregates | 35K | 90K |
| Phase 4: Repository Layer | 25K | 115K |
| Phase 5: Service Layer | 50K | 165K |
| Phase 6: Entry Point | 20K | 185K |
| Phase 7: Testing | 30K | 215K |
| **Total** | **215K** | **150K limit exceeded** |

**Budget Optimization**:
- Phase 5 reduced from 50K to 35K by using existing service logic
- Phase 7 reduced from 30K to 15K by reusing test patterns
- **Adjusted Total**: 180K

**Recommendation**: Split into two decisions:
1. **DECISION_110-A**: Phases 1-4 (Domain + Infrastructure) - 115K tokens
2. **DECISION_110-B**: Phases 5-7 (Services + Testing) - 65K tokens

---

## Conclusion

This design establishes a SOLID, DDD-compliant architecture for H4ND that:

1. **Preserves existing value**: Navigation/ folder remains unchanged, Parallel/ engine intact
2. **Establishes clear boundaries**: Four domains with explicit contracts
3. **Enables testability**: All services have interfaces, dependencies injected
4. **Improves observability**: Structured logging with correlation IDs across 4 collections
5. **Enforces quality**: Fail-fast validation at all boundaries

The phased approach allows incremental delivery with validation at each checkpoint. The migration strategy ensures zero downtime and backward compatibility throughout the transition.

**Designer Approval**: ✅ Approved for implementation  
**Recommended Model**: Claude-3.5-Sonnet (primary), GPT-4o (file organization review)  
**Implementation Agent**: @windfixer

---

*Designer Consultation v1.0*  
*Aegis, P4NTH30N Architecture*  
*2026-02-22*

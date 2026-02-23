# DECISION_098: Comprehensive Implementation Specifications

**Decision**: Implement Recorder Navigation Map to H4ND Parallel Workers  
**Date**: 2026-02-22  
**Designer**: Claude 3.5 Sonnet + Kimi K2.5  
**Status**: Approved for Implementation

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [File Structure](#file-structure)
3. [Class Specifications](#class-specifications)
4. [Design Patterns](#design-patterns)
5. [Thread Safety](#thread-safety)
6. [Integration Guide](#integration-guide)
7. [Testing Strategy](#testing-strategy)
8. [Deployment Checklist](#deployment-checklist)

---

## Architecture Overview

### System Context

```
┌─────────────────────────────────────────────────────────────────┐
│                        ParallelSpinWorker                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  ProcessSignalAsync()                                     │   │
│  │  ┌────────────────┐    ┌────────────────┐               │   │
│  │  │ Load Map       │───▶│ Execute Phase  │               │   │
│  │  │ (cached)       │    │ (Login/Spin)   │               │   │
│  │  └────────────────┘    └────────────────┘               │   │
│  └──────────────────────────────────────────────────────────┘   │
└───────────────────────────┬─────────────────────────────────────┘
                            │ uses
┌───────────────────────────▼─────────────────────────────────────┐
│                    NavigationMapLoader                           │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  ConcurrentDictionary<string, NavigationMap> _cache      │   │
│  │  ┌────────────────┐    ┌────────────────┐               │   │
│  │  │ Check Cache    │───▶│ Parse JSON     │               │   │
│  │  │ (thread-safe)  │    │ (if miss)      │               │   │
│  │  └────────────────┘    └────────────────┘               │   │
│  └──────────────────────────────────────────────────────────┘   │
└───────────────────────────┬─────────────────────────────────────┘
                            │ loads
┌───────────────────────────▼─────────────────────────────────────┐
│                      StepExecutor                                │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  RetryStepDecorator                                       │   │
│  │  ┌────────────────┐    ┌────────────────┐               │   │
│  │  │ Retry Logic    │───▶│ StepExecutor   │               │   │
│  │  │ (decorator)    │    │ (core)         │               │   │
│  │  └────────────────┘    └───────┬────────┘               │   │
│  └────────────────────────────────┼────────────────────────┘   │
└───────────────────────────────────┼─────────────────────────────┘
                                    │ uses
┌───────────────────────────────────▼─────────────────────────────┐
│                    IStepStrategy Implementations                 │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │ Click    │ │ Type     │ │ Wait     │ │ Navigate │          │
│  │ Strategy │ │ Strategy │ │ Strategy │ │ Strategy │          │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
Signal Received
    ↓
[ParallelSpinWorker] Load NavigationMap for platform
    ↓
[NavigationMapLoader] Check cache → Parse JSON if miss → Return map
    ↓
[ParallelSpinWorker] Create StepExecutionContext
    ↓
[StepExecutor] ExecutePhaseAsync("Login")
    ↓
For each step in phase:
    ├─▶ [RetryStepDecorator] Execute with retry
    │       ↓
    │   [StepExecutor] ExecuteStepAsync
    │       ↓
    │   [IVerificationStrategy] Verify entry gate
    │       ↓
    │   [IStepStrategy] Execute action (click/type/wait/navigate)
    │       ↓
    │   [IVerificationStrategy] Verify exit gate
    │       ↓
    │   [On Failure] IErrorHandler chain
    ↓
[ParallelSpinWorker] Verify login success (balance > 0)
    ↓
Continue to Game Selection phase...
```

---

## File Structure

```
H4ND/
├── Navigation/
│   ├── NavigationMapLoader.cs          # JSON parsing + caching
│   ├── NavigationMap.cs                # Domain model for map
│   ├── StepExecutor.cs                 # Core executor (strategy pattern)
│   ├── StepExecutionContext.cs         # Per-execution state
│   ├── StepExecutionResult.cs          # Result with diagnostics
│   │
│   ├── Strategies/                     # IStepStrategy implementations
│   │   ├── IStepStrategy.cs
│   │   ├── ClickStepStrategy.cs
│   │   ├── TypeStepStrategy.cs
│   │   ├── WaitStepStrategy.cs
│   │   ├── NavigateStepStrategy.cs
│   │   └── LongPressStepStrategy.cs
│   │
│   ├── Verification/                   # Verification gates
│   │   ├── IVerificationStrategy.cs
│   │   ├── JavaScriptVerificationStrategy.cs
│   │   └── ScreenshotVerificationStrategy.cs
│   │
│   ├── Retry/                          # Retry decorators
│   │   ├── IStepExecutor.cs
│   │   ├── RetryStepDecorator.cs
│   │   └── ExponentialBackoffPolicy.cs
│   │
│   └── ErrorHandling/                  # Error recovery
│       ├── IErrorHandler.cs
│       ├── ErrorHandlerChain.cs
│       ├── ScreenshotErrorHandler.cs
│       └── GotoRecoveryHandler.cs
│
├── Parallel/
│   └── ParallelSpinWorker.cs           # MODIFIED: Use NavigationMap
│
└── Infrastructure/
    └── CdpGameActions.cs               # MODIFIED: Expose helper methods
```

---

## Class Specifications

### NavigationMap (Domain Model)

```csharp
public sealed class NavigationMap
{
    public string Platform { get; init; } = string.Empty;
    public string Decision { get; init; } = string.Empty;
    public string SessionNotes { get; init; } = string.Empty;
    public IReadOnlyList<NavigationStep> Steps { get; init; } = Array.Empty<NavigationStep>();
    public NavigationMetadata Metadata { get; init; } = new();
    
    public IEnumerable<NavigationStep> GetStepsForPhase(string phase) =>
        Steps.Where(s => s.Phase.Equals(phase, StringComparison.OrdinalIgnoreCase));
    
    public NavigationStep? GetStepById(int stepId) =>
        Steps.FirstOrDefault(s => s.StepId == stepId);
}
```

**Key Points**:
- Immutable after construction
- Thread-safe for concurrent readonly access
- Supports phase-based step retrieval
- Step lookup by ID for goto operations

---

### NavigationMapLoader

```csharp
public sealed class NavigationMapLoader
{
    private readonly ConcurrentDictionary<string, NavigationMap> _cache = new();
    private readonly string _mapsDirectory;
    
    public async Task<NavigationMap?> LoadAsync(string platform, CancellationToken ct = default)
    {
        return _cache.GetOrAdd(platform.ToLowerInvariant(), _ => LoadFromDisk(platform));
    }
    
    private NavigationMap LoadFromDisk(string platform)
    {
        // Try platform-specific first, fallback to generic
        string fileName = $"step-config-{platform}.json";
        string filePath = Path.Combine(_mapsDirectory, fileName);
        
        if (!File.Exists(filePath))
            filePath = Path.Combine(_mapsDirectory, "step-config.json");
        
        string json = File.ReadAllText(filePath);
        return ParseMap(json);
    }
}
```

**Key Points**:
- Thread-safe via ConcurrentDictionary
- Lazy loading with caching
- Cache invalidation support
- Fallback to generic config

---

### StepExecutor

```csharp
public sealed class StepExecutor : IStepExecutor
{
    private readonly IReadOnlyDictionary<string, IStepStrategy> _strategies;
    private readonly IVerificationStrategy _verificationStrategy;
    private readonly IErrorHandler _errorHandler;
    
    public async Task<StepExecutionResult> ExecuteStepAsync(
        NavigationStep step,
        StepExecutionContext context,
        CancellationToken ct = default)
    {
        // Entry gate verification
        if (!await _verificationStrategy.VerifyAsync(step.Verification.EntryGate, context, ct))
            return await HandleFailureAsync(step, context, diagnostics, ct);
        
        // Execute step
        var strategy = _strategies[step.Action.ToLowerInvariant()];
        var result = await strategy.ExecuteAsync(step, context, ct);
        
        // Exit gate verification
        if (!await _verificationStrategy.VerifyAsync(step.Verification.ExitGate, context, ct))
            return await HandleFailureAsync(step, context, diagnostics, ct);
        
        return StepExecutionResult.Success(step.StepId, diagnostics);
    }
}
```

**Key Points**:
- Strategy lookup by action type
- Entry/exit gate verification
- Error handling delegation
- Diagnostic capture

---

### RetryStepDecorator

```csharp
public sealed class RetryStepDecorator : IStepExecutor
{
    private readonly IStepExecutor _inner;
    private readonly IRetryPolicy _retryPolicy;
    
    public async Task<StepExecutionResult> ExecuteStepAsync(...)
    {
        int attempt = 0;
        TimeSpan delay = _retryPolicy.InitialDelay;
        
        while (true)
        {
            attempt++;
            var result = await _inner.ExecuteStepAsync(step, context, ct);
            
            if (result.Success || attempt >= _retryPolicy.MaxRetries)
                return result;
            
            delay = _retryPolicy.CalculateNextDelay(attempt, delay);
            await Task.Delay(delay, ct);
        }
    }
}
```

**Key Points**:
- Decorator pattern adds retry without modifying core
- Exponential backoff with jitter
- Configurable max retries
- Preserves original result after max retries

---

## Design Patterns

### 1. Strategy Pattern

**Purpose**: Encapsulate different step action types (click, type, wait, etc.)

```csharp
public interface IStepStrategy
{
    string ActionType { get; }
    Task<StepResult> ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct);
}

public class ClickStepStrategy : IStepStrategy
{
    public string ActionType => "click";
    public async Task<StepResult> ExecuteAsync(...)
    {
        var (x, y) = step.Coordinates.ToAbsolute(bounds);
        await context.CdpClient.ClickAtAsync(x, y, ct);
        return StepResult.Success();
    }
}
```

**Benefits**:
- Open/closed principle: add new actions without modifying executor
- Easy unit testing with mocked strategies
- Clear separation of concerns

---

### 2. Decorator Pattern

**Purpose**: Add retry logic cross-cutting concern

```csharp
// Core executor
IStepExecutor core = new StepExecutor(strategies, verification, errorHandler);

// Wrap with retry
IStepExecutor withRetry = new RetryStepDecorator(core, retryPolicy);

// Usage - retry is transparent
var result = await withRetry.ExecuteStepAsync(step, context, ct);
```

**Benefits**:
- Retry logic reusable across different executors
- Core executor remains simple
- Can stack decorators (retry → logging → metrics)

---

### 3. Lazy Loading with Cache

**Purpose**: Avoid repeated JSON parsing

```csharp
private readonly ConcurrentDictionary<string, NavigationMap> _cache = new();

public Task<NavigationMap> LoadAsync(string platform)
{
    return _cache.GetOrAdd(platform, _ => ParseFromDisk(platform));
}
```

**Benefits**:
- Parse once, use many times
- Thread-safe concurrent access
- Configurable cache duration

---

## Thread Safety

### Component Analysis

| Component | Thread Safety | Mechanism |
|-----------|--------------|-----------|
| NavigationMapLoader | ✅ | ConcurrentDictionary |
| NavigationMap | ✅ | Immutable after construction |
| StepExecutor | ✅ | Stateless, local variables only |
| StepExecutionContext | ❌ | Create new per execution |
| CdpClient | ❌ | Per-worker instance |
| IStepStrategy | ✅ | Stateless implementations |

### Parallel Execution Model

```
Worker 0 (Port 9222)          Worker 1 (Port 9223)
├─ CdpClient (isolated)       ├─ CdpClient (isolated)
├─ StepExecutionContext       ├─ StepExecutionContext
├─ Chrome Profile 0           ├─ Chrome Profile 1
└─ Uses shared NavigationMap   └─ Uses shared NavigationMap
   (readonly, safe)              (readonly, safe)
```

**Safety Guarantees**:
- No shared mutable state between workers
- NavigationMap is readonly after load
- CdpClient is per-worker (DECISION_081)
- Context is created per execution

---

## Integration Guide

### Step 1: Create Directory Structure

```powershell
mkdir H4ND\Navigation
mkdir H4ND\Navigation\Strategies
mkdir H4ND\Navigation\Verification
mkdir H4ND\Navigation\Retry
mkdir H4ND\Navigation\ErrorHandling
```

### Step 2: Implement Core Classes

Order of implementation:
1. `NavigationMap.cs` - Domain model
2. `NavigationMapLoader.cs` - JSON parsing
3. `IStepStrategy.cs` + implementations - Action strategies
4. `StepExecutor.cs` - Core executor
5. `RetryStepDecorator.cs` - Retry logic
6. `ParallelSpinWorker.cs` modifications

### Step 3: Dependency Injection

```csharp
// In H4ND service configuration
services.AddSingleton<NavigationMapLoader>();
services.AddSingleton<IStepExecutor>(sp =>
{
    var strategies = new IStepStrategy[]
    {
        new ClickStepStrategy(),
        new TypeStepStrategy(),
        new WaitStepStrategy(),
        new NavigateStepStrategy(),
        new LongPressStepStrategy()
    };
    
    var core = new StepExecutor(
        strategies,
        new JavaScriptVerificationStrategy(),
        new ErrorHandlerChain()
    );
    
    return new RetryStepDecorator(core, new ExponentialBackoffPolicy());
});
```

### Step 4: Modify ParallelSpinWorker

```csharp
public class ParallelSpinWorker
{
    private readonly NavigationMapLoader _mapLoader;
    private readonly IStepExecutor _stepExecutor;
    
    public ParallelSpinWorker(..., NavigationMapLoader mapLoader, IStepExecutor stepExecutor)
    {
        _mapLoader = mapLoader;
        _stepExecutor = stepExecutor;
    }
    
    private async Task<bool> ExecuteLoginAsync(ICdpClient cdp, Credential credential, CancellationToken ct)
    {
        // Try navigation map first
        var map = await _mapLoader.LoadAsync(credential.Game, ct);
        if (map != null)
        {
            var context = new StepExecutionContext
            {
                CdpClient = cdp,
                Platform = credential.Game,
                Username = credential.Username,
                Variables = new() { ["username"] = credential.Username, ["password"] = credential.Password }
            };
            
            var result = await _stepExecutor.ExecutePhaseAsync(map, "Login", context, ct);
            if (result.Success)
                return await CdpGameActions.VerifyLoginSuccessAsync(cdp, credential.Username, credential.Game, ct);
        }
        
        // Fallback to hardcoded implementation
        return await ExecuteHardcodedLoginAsync(cdp, credential, ct);
    }
}
```

---

## Testing Strategy

### Unit Tests

```csharp
[Fact]
public async Task ClickStepStrategy_ExecutesClick()
{
    // Arrange
    var step = new NavigationStep { Action = "click", Coordinates = new() { X = 100, Y = 200 } };
    var cdp = new Mock<ICdpClient>();
    var context = new StepExecutionContext { CdpClient = cdp.Object };
    var strategy = new ClickStepStrategy();
    
    // Act
    var result = await strategy.ExecuteAsync(step, context, CancellationToken.None);
    
    // Assert
    cdp.Verify(x => x.ClickAtAsync(100, 200, It.IsAny<CancellationToken>()), Times.Once);
}
```

### Integration Tests

```csharp
[Fact]
public async Task NavigationMapLoader_LoadsFireKirinMap()
{
    // Arrange
    var loader = new NavigationMapLoader();
    
    // Act
    var map = await loader.LoadAsync("firekirin");
    
    // Assert
    Assert.NotNull(map);
    Assert.Equal("firekirin", map.Platform);
    Assert.True(map.Steps.Count > 0);
}
```

### End-to-End Tests

```csharp
[Fact]
public async Task ParallelSpinWorker_ExecutesFireKirinLogin()
{
    // Full integration test with real Chrome
    // Requires: Chrome running on port 9222
}
```

---

## Deployment Checklist

- [ ] Create H4ND/Navigation directory structure
- [ ] Implement NavigationMap domain model
- [ ] Implement NavigationMapLoader with caching
- [ ] Implement all IStepStrategy implementations
- [ ] Implement StepExecutor with verification
- [ ] Implement RetryStepDecorator
- [ ] Implement error handling chain
- [ ] Modify ParallelSpinWorker to use NavigationMap
- [ ] Update CdpGameActions to expose helper methods
- [ ] Add dependency injection configuration
- [ ] Write unit tests for strategies
- [ ] Write integration tests for loader
- [ ] Test with FireKirin navigation map
- [ ] Verify parallel execution (5 workers)
- [ ] Verify fallback to hardcoded methods
- [ ] Update documentation

---

## Performance Considerations

| Metric | Expected Value | Notes |
|--------|---------------|-------|
| Map Load Time | <10ms (cached) | ~100ms first load |
| Memory per Map | ~50KB | Negligible |
| Step Execution | ~500ms average | Includes delays |
| Retry Overhead | +1-4s per retry | Exponential backoff |
| Concurrent Maps | Unlimited | Readonly, thread-safe |

---

## Error Handling Matrix

| Error Type | Handler | Action |
|------------|---------|--------|
| JSON Parse Error | NavigationMapLoader | Log error, return null (fallback) |
| Step Execution Exception | RetryStepDecorator | Retry 3x, then fail |
| Verification Gate Fail | StepExecutor | Capture screenshot, consult error handler |
| CDP Connection Lost | ParallelSpinWorker | Restart Chrome profile, retry |
| Map Not Found | ParallelSpinWorker | Fallback to hardcoded methods |

---

*Implementation Specifications*  
*DECISION_098*  
*2026-02-22*

# CORE-H4NDv2-001: H4ND Version 2 Architecture

**Decision ID**: CORE-H4NDv2-001  
**Category**: Core Architecture  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-19  
**Parent**: INFRA-VM-001 (VM Infrastructure)  
**Related**: FOUREYES-015 (Vision Command Integration)  
**Oracle Approval**: Pending  
**Designer Approval**: Pending  

---

## Executive Summary

Redesign H4ND from a polling-based signal processor to a vision-command-driven automation agent. H4NDv2 receives commands from the FourEyes vision system (W4TCHD0G) via the `VisionCommandListener`, enabling autonomous jackpot detection and spin execution without polling delays.

**Current Problem**:
- H4ND polls MongoDB every iteration (inefficient)
- No integration with FourEyes vision system
- Signal-driven only (no autonomous vision capability)
- Browser automation tightly coupled to main loop

**Proposed Solution**:
- Event-driven architecture via `VisionCommandListener`
- Decoupled command processing from browser automation
- FourEyes integration for vision-based commands
- Parallel credential processing
- Circuit breaker protection for all external calls

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        H4NDv2 Architecture                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                 Vision Command Listener                   │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Receives commands from W4TCHD0G/FourEyes          │  │  │
│  │  │  ├─ Spin (confidence: 0.95, target: username@game) │  │  │
│  │  │  ├─ Stop (timeout or error detected)              │  │  │
│  │  │  ├─ SwitchGame (vision detected game change)      │  │  │
│  │  │  └─ AdjustBet (based on balance/vision)           │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └────────────────────────┬───────────────────────────────────┘  │
│                           │                                      │
│                           ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                 Command Queue Processor                   │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  ┌──────────────┐  ┌──────────────┐  ┌──────────┐  │  │  │
│  │  │  │   SpinCmd    │  │   StopCmd    │  │ SwitchCmd│  │  │  │
│  │  │  │   Handler    │  │   Handler    │  │ Handler  │  │  │  │
│  │  │  └──────┬───────┘  └──────┬───────┘  └────┬─────┘  │  │  │
│  │  └─────────┼─────────────────┼───────────────┼────────┘  │  │
│  └────────────┼─────────────────┼───────────────┼───────────┘  │
│               │                 │               │              │
│               ▼                 ▼               ▼              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Browser Automation Pool                      │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │  │
│  │  │ ChromeDriver│ │ ChromeDriver│ │ ChromeDriver│ ...    │  │
│  │  │  Instance 1 │ │  Instance 2 │ │  Instance N │        │  │
│  │  │ (FireKirin) │ │(OrionStars) │ │  (Spare)    │        │  │
│  │  └─────────────┘ └─────────────┘ └─────────────┘        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                 Resilience Layer                          │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │  │
│  │  │   Circuit   │ │ Degradation │ │  Operation  │        │  │
│  │  │   Breaker   │ │   Manager   │ │   Tracker   │        │  │
│  │  └─────────────┘ └─────────────┘ └─────────────┘        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Components

### 1. VisionCommandListener (Existing - Needs Enhancement)

**Current State**: Basic implementation exists at `H4ND/VisionCommandListener.cs`

**Enhancements Needed**:
- Integration with actual W4TCHD0G event source
- Command validation and deduplication
- Priority queue for urgent commands (e.g., Stop)
- Circuit breaker for command processing

```csharp
// H4ND/VisionCommandListener.cs (enhanced)
public class VisionCommandListener : IVisionCommandListener {
    private readonly IOperationTracker _operationTracker;
    private readonly CircuitBreaker _circuitBreaker;
    private readonly PriorityQueue<VisionCommand, int> _priorityQueue;
    
    public async Task ProcessCommandAsync(VisionCommand command) {
        // Deduplication check
        if (!_operationTracker.TryRegisterOperation(command.Id))
            return; // Duplicate command
            
        // Circuit breaker protection
        await _circuitBreaker.ExecuteAsync(async () => {
            switch (command.CommandType) {
                case VisionCommandType.Spin:
                    await _spinHandler.HandleAsync(command);
                    break;
                case VisionCommandType.Stop:
                    await _stopHandler.HandleAsync(command); // High priority
                    break;
                // ... etc
            }
        });
    }
}
```

### 2. Command Handlers

#### SpinCommandHandler
```csharp
public class SpinCommandHandler : IVisionCommandHandler {
    private readonly IBrowserAutomationPool _browserPool;
    private readonly IUnitOfWork _uow;
    
    public async Task<CommandResult> HandleAsync(VisionCommand command) {
        // Get or create browser instance for credential
        var browser = await _browserPool.AcquireAsync(command.TargetGame);
        
        try {
            // Login if needed
            var credential = _uow.Credentials.GetBy(
                command.TargetHouse, 
                command.TargetGame, 
                command.TargetUsername
            );
            
            await browser.LoginAsync(credential);
            
            // Execute spin based on game type
            var result = command.TargetGame switch {
                "FireKirin" => await browser.ExecuteFireKirinSpinAsync(credential, command),
                "OrionStars" => await browser.ExecuteOrionStarsSpinAsync(credential, command),
                _ => throw new NotSupportedException($"Game {command.TargetGame} not supported")
            };
            
            // Update credential with results
            credential.Balance = result.NewBalance;
            credential.Jackpots = result.Jackpots;
            _uow.Credentials.Upsert(credential);
            
            return CommandResult.Success(result);
        }
        finally {
            await _browserPool.ReleaseAsync(browser);
        }
    }
}
```

#### StopCommandHandler (High Priority)
```csharp
public class StopCommandHandler : IVisionCommandHandler {
    public async Task<CommandResult> HandleAsync(VisionCommand command) {
        // Immediately stop any active spins for this credential
        var activeSession = _sessionManager.GetActiveSession(command.TargetUsername);
        
        if (activeSession != null) {
            activeSession.RequestCancellation();
            await activeSession.WaitForStopAsync(TimeSpan.FromSeconds(5));
        }
        
        return CommandResult.Stopped();
    }
}
```

### 3. Browser Automation Pool

Manages ChromeDriver instances for parallel credential processing:

```csharp
public interface IBrowserAutomationPool {
    Task<IBrowserInstance> AcquireAsync(string game);
    Task ReleaseAsync(IBrowserInstance instance);
    Task<int> GetAvailableCountAsync();
}

public class BrowserAutomationPool : IBrowserAutomationPool {
    private readonly ConcurrentDictionary<string, ConcurrentBag<IBrowserInstance>> _pools;
    private readonly int _maxInstancesPerGame;
    
    public async Task<IBrowserInstance> AcquireAsync(string game) {
        var pool = _pools.GetOrAdd(game, _ => new ConcurrentBag<IBrowserInstance>());
        
        // Try to get existing available instance
        if (pool.TryTake(out var instance) && instance.IsHealthy) {
            return instance;
        }
        
        // Create new instance if under limit
        if (pool.Count < _maxInstancesPerGame) {
            return await CreateInstanceAsync(game);
        }
        
        // Wait for available instance
        return await WaitForAvailableAsync(game, TimeSpan.FromSeconds(30));
    }
}
```

### 4. H4NDv2 Main Loop

```csharp
// H4NDv2/Program.cs
internal class Program {
    private static async Task Main(string[] args) {
        var services = ConfigureServices();
        var listener = services.GetRequiredService<VisionCommandListener>();
        var healthCheck = services.GetRequiredService<HealthCheckService>();
        
        // Start vision command listener
        await listener.StartAsync();
        
        // Start health monitoring
        _ = Task.Run(() => healthCheck.RunAsync());
        
        // Keep running until cancellation
        await Task.Delay(Timeout.Infinite, CancellationToken.None);
    }
    
    private static IServiceProvider ConfigureServices() {
        var services = new ServiceCollection();
        
        // Resilience components (from FOUREYES)
        services.AddSingleton<IOperationTracker>(
            _ => new OperationTracker(TimeSpan.FromMinutes(5)));
        services.AddSingleton<ICircuitBreaker>(
            _ => new CircuitBreaker(failureThreshold: 5, recoveryTimeout: TimeSpan.FromSeconds(60)));
        services.AddSingleton<IDegradationManager>(
            _ => new SystemDegradationManager());
            
        // H4NDv2 components
        services.AddSingleton<VisionCommandListener>();
        services.AddSingleton<IBrowserAutomationPool, BrowserAutomationPool>();
        services.AddSingleton<ISessionManager, SessionManager>();
        
        // Command handlers
        services.AddTransient<IVisionCommandHandler<SpinCommand>, SpinCommandHandler>();
        services.AddTransient<IVisionCommandHandler<StopCommand>, StopCommandHandler>();
        services.AddTransient<IVisionCommandHandler<SwitchGameCommand>, SwitchGameCommandHandler>();
        
        // Data access
        services.AddSingleton<IUnitOfWork, MongoUnitOfWork>();
        
        return services.BuildServiceProvider();
    }
}
```

---

## FourEyes Integration

### Vision Command Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  OBS Stream │────▶│ LM Studio   │────▶│   Vision    │────▶│   H4NDv2    │
│  (Game Feed)│     │  Analysis   │     │   Decision  │     │   Command   │
└─────────────┘     └─────────────┘     │   Engine    │     │   Listener  │
                                        └──────┬──────┘     └──────┬──────┘
                                               │                    │
                                               ▼                    ▼
                                        ┌─────────────┐     ┌─────────────┐
                                        │  Decision:  │────▶│  Execute:   │
                                        │  SPIN       │     │  SpinSlots  │
                                        │  (conf:0.95)│     │  (FireKirin)│
                                        └─────────────┘     └─────────────┘
```

### Command Types

| Command | Source | Priority | Description |
|---------|--------|----------|-------------|
| **Spin** | Vision Decision Engine | Normal | Execute spin on target game |
| **Stop** | Vision Error Detection | Critical | Immediately stop all activity |
| **SwitchGame** | Vision State Change | High | Switch to different game |
| **AdjustBet** | Balance/Vision Analysis | Normal | Modify bet amount |
| **CaptureScreenshot** | Manual/Debug | Low | Capture current state |
| **Escalate** | Low Confidence | High | Hand off to human/Nexus |

### Integration Points

```csharp
// W4TCHD0G publishes commands to event bus
public class VisionDecisionEngine {
    private readonly IEventBus _eventBus;
    
    public void Evaluate(VisionAnalysis analysis) {
        var decision = MakeDecision(analysis);
        
        if (decision.Type == DecisionType.Spin && decision.Confidence > 0.90) {
            _eventBus.Publish(new VisionCommand {
                CommandType = VisionCommandType.Spin,
                TargetHouse = decision.TargetHouse,
                TargetGame = decision.TargetGame,
                TargetUsername = decision.TargetUsername,
                Confidence = decision.Confidence,
                Timestamp = DateTime.UtcNow
            });
        }
    }
}

// H4NDv2 subscribes to event bus
public class VisionCommandListener {
    private readonly IEventBus _eventBus;
    
    public async Task StartAsync() {
        await _eventBus.SubscribeAsync<VisionCommand>(async cmd => {
            EnqueueCommand(cmd);
        });
    }
}
```

---

## Resilience Patterns

### Circuit Breaker Integration

```csharp
public class ResilientCommandHandler<T> : IVisionCommandHandler<T> {
    private readonly IVisionCommandHandler<T> _inner;
    private readonly ICircuitBreaker _circuitBreaker;
    
    public async Task<CommandResult> HandleAsync(T command) {
        return await _circuitBreaker.ExecuteAsync(async () => {
            return await _inner.HandleAsync(command);
        });
    }
}
```

### Degradation Levels

| Level | Trigger | Behavior |
|-------|---------|----------|
| **Normal** | Latency < 500ms | Full vision command processing |
| **Reduced** | Latency 500-1000ms | Process only high-confidence (>0.95) commands |
| **Minimal** | Latency > 1000ms | Vision commands only, no polling fallback |
| **Emergency** | Circuit breaker open | Stop all processing, alert operators |

### Idempotency

```csharp
public class IdempotentCommandHandler<T> : IVisionCommandHandler<T> {
    private readonly IOperationTracker _tracker;
    
    public async Task<CommandResult> HandleAsync(T command) {
        var operationId = $"{command.GetType().Name}:{command.TargetUsername}:{command.Timestamp:yyyyMMddHHmm}";
        
        if (!_tracker.TryRegisterOperation(operationId)) {
            _logger.LogInformation("Duplicate command detected: {OperationId}", operationId);
            return CommandResult.Duplicate();
        }
        
        return await _inner.HandleAsync(command);
    }
}
```

---

## Implementation Plan

### Phase 1: Foundation (Week 1)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| H4NDv2-001 | Create H4NDv2 project structure | WindFixer | Ready | Critical |
| H4NDv2-002 | Implement VisionCommandListener enhancements | WindFixer | Ready | Critical |
| H4NDv2-003 | Create command handler interfaces | WindFixer | Ready | Critical |
| H4NDv2-004 | Implement BrowserAutomationPool | WindFixer | Ready | High |
| H4NDv2-005 | Add circuit breaker integration | OpenFixer | Ready | High |

### Phase 2: Command Handlers (Week 1-2)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| H4NDv2-006 | Implement SpinCommandHandler | WindFixer | Ready | Critical |
| H4NDv2-007 | Implement StopCommandHandler | WindFixer | Ready | Critical |
| H4NDv2-008 | Implement SwitchGameCommandHandler | WindFixer | Ready | High |
| H4NDv2-009 | Implement AdjustBetCommandHandler | WindFixer | Ready | Medium |
| H4NDv2-010 | Add idempotency to all handlers | OpenFixer | Ready | High |

### Phase 3: FourEyes Integration (Week 2)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| H4NDv2-011 | Create event bus abstraction | OpenFixer | Ready | Critical |
| H4NDv2-012 | Integrate with W4TCHD0G event source | OpenFixer | Ready | Critical |
| H4NDv2-013 | Implement command validation | WindFixer | Ready | High |
| H4NDv2-014 | Add command metrics collection | OpenFixer | Ready | Medium |

### Phase 4: Testing & Deployment (Week 2-3)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| H4NDv2-015 | Unit tests for command handlers | Forgewright | Ready | Critical |
| H4NDv2-016 | Integration tests with W4TCHD0G | Forgewright | Ready | Critical |
| H4NDv2-017 | Performance testing | Forgewright | Ready | High |
| H4NDv2-018 | Deploy to VM | WindFixer | Ready | Critical |

---

## Migration from H4ND v1

### Backward Compatibility

```csharp
// H4NDv2 supports both vision commands AND legacy signals
public class HybridCommandListener {
    private readonly VisionCommandListener _visionListener;
    private readonly LegacySignalPoller _signalPoller;
    
    public async Task StartAsync() {
        // Start vision command processing (primary)
        await _visionListener.StartAsync();
        
        // Start legacy signal polling (fallback)
        await _signalPoller.StartAsync();
    }
}
```

### Gradual Migration Path

1. **Phase 1**: Deploy H4NDv2 alongside H4ND v1
2. **Phase 2**: Route 10% of traffic to H4NDv2
3. **Phase 3**: Monitor metrics, increase to 50%
4. **Phase 4**: Full cutover to H4NDv2
5. **Phase 5**: Decommission H4ND v1

---

## Success Criteria

### Technical Metrics
- [ ] Vision command latency < 100ms (95th percentile)
- [ ] Spin execution success rate > 99%
- [ ] Zero duplicate spins (idempotency working)
- [ ] Circuit breaker triggers < 1% of commands
- [ ] Browser pool utilization < 80%

### Operational Metrics
- [ ] Vision commands processed: > 1000/day
- [ ] Average command processing time < 500ms
- [ ] Error rate < 0.1%
- [ ] Uptime > 99.9%

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Vision command flooding | High | Medium | Rate limiting + priority queue |
| Browser instance exhaustion | High | Low | Pool sizing + auto-scaling |
| Circuit breaker thrashing | Medium | Low | Exponential backoff |
| Legacy signal conflicts | Medium | Medium | Clear priority: vision > signals |
| VM resource constraints | High | Low | Monitor + alert at 80% usage |

---

## Questions for Oracle

1. Should H4NDv2 completely replace v1, or run in parallel during transition?
2. What is the acceptable latency for vision command processing?
3. How should we handle conflicting commands (vision says Spin, signal says Stop)?

## Questions for Designer

1. Is the browser pool pattern appropriate for ChromeDriver instances?
2. Should we use MediatR or custom event bus for command routing?
3. What is the optimal pool size for browser instances per game?

---

## Consultation Requests

### Oracle Review Required

**Status**: 🟡 **PENDING**

Oracle is requested to review and provide approval rating using the 10-dimension framework:

1. **Clarity** - Is the event-driven architecture clear?
2. **Completeness** - Are all components and interfaces specified?
3. **Feasibility** - Is the 3-week implementation timeline realistic?
4. **Risk Assessment** - Are command conflicts and failures addressed?
5. **Consultation Quality** - Are the right integration points identified?
6. **Testability** - Can success criteria be validated?
7. **Maintainability** - Is the architecture sustainable long-term?
8. **Alignment** - Does this align with FourEyes vision system?
9. **Actionability** - Are implementation steps clear for Fixer agents?
10. **Documentation** - Are interfaces and patterns well-documented?

**Specific Questions for Oracle**:
1. Should H4NDv2 completely replace v1, or run in parallel during transition?
2. What is the acceptable latency for vision command processing?
3. How should we handle conflicting commands (vision says Spin, signal says Stop)?
4. Is the risk of command flooding properly mitigated?
5. What is the approval rating for this architecture?

### Designer Review Required

**Status**: 🟡 **PENDING**

Designer is requested to review technical implementation approach:

**Specific Questions for Designer**:
1. Is the browser pool pattern appropriate for ChromeDriver instances?
2. Should we use MediatR or custom event bus for command routing?
3. What is the optimal pool size for browser instances per game?
4. Is the middleware pipeline pattern suitable for command processing?
5. Should we implement CQRS for command/query separation?

---

## Consultation Log

| Date | Agent | Action | Status |
|------|-------|--------|--------|
| 2026-02-19 | Strategist | Created decision document | ✅ Complete |
| 2026-02-19 | Strategist | Requested Oracle review | 🟡 Pending |
| 2026-02-19 | Strategist | Requested Designer review | 🟡 Pending |

---

## Next Steps

1. **Await Oracle approval** on architecture decisions
2. **Await Designer approval** on implementation patterns
3. **Delegate to WindFixer** for command handler implementation
4. **Delegate to OpenFixer** for event bus and integration
5. **Delegate to Forgewright** for testing infrastructure

---

*CORE-H4NDv2-001: H4ND Version 2 Architecture*  
*Status: Proposed | Awaiting Consultation*  
*2026-02-19*

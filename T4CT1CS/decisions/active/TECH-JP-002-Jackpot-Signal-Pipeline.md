# TECH-JP-002: Jackpot Signal-to-Spin Pipeline

**Decision ID**: TECH-JP-002  
**Category**: Technical Implementation  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-20  

---

## Executive Summary

Connect H0UND jackpot signals to H4ND spin execution through the event bus. When H0UND detects a jackpot approaching threshold, it emits a signal that flows through the event bus into H4ND, which executes the spin via CDP.

**Current State**:
- H0UND generates signals in MongoDB SIGN4L collection
- Event bus exists and is wired into H4ND
- CDP client can execute spins

**Target State**:
- Signal flows: H0UND → MongoDB → H4ND EventBus → CDP Spin
- End-to-end latency < 5 seconds from signal to spin execution
- Automatic acknowledgment of processed signals

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SIGNAL FLOW                                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  H0UND (Analytics Agent)                                                │
│  │                                                                       │
│  │ 1. Monitors jackpots in CR3D3N7IAL                                   │
│  │ 2. Detects jackpot approaching threshold                               │
│  │ 3. Inserts Signal into MongoDB SIGN4L                                 │
│  │                                                                       │
│  └───────────────────────┬───────────────────────────────────────────┘ │
│                          │                                               │
│                          ▼                                               │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  Event Bus (InMemoryEventBus)                                     │   │
│  │  - FourEyes subscribes to SIGN4L changes                          │   │
│  │  - Publishes VisionCommand to H4ND                                │   │
│  └───────────────────────┬───────────────────────────────────────────┘   │
│                          │                                               │
│                          ▼                                               │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  Command Pipeline (Validation → Idempotency → CircuitBreaker)     │   │
│  │  - Validates command                                              │   │
│  │  - Prevents duplicate spins                                       │   │
│  │  - Protects against cascade failures                               │   │
│  └───────────────────────┬───────────────────────────────────────────┘   │
│                          │                                               │
│                          ▼                                               │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  H4ND Spin Execution                                              │   │
│  │  - Receives VisionCommand (Spin)                                 │   │
│  │  - Uses CDP client to click spin button                          │   │
│  │  - Updates credential balance                                     │   │
│  │  - Acknowledges signal in MongoDB                                │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Implementation

### Step 1: Signal to VisionCommand Mapping

When H4ND retrieves a signal from MongoDB, convert it to VisionCommand:

```csharp
// In H4ND signal processing loop
Signal signal = uow.Signals.GetNext();
if (signal != null)
{
    var command = new VisionCommand
    {
        CommandType = VisionCommandType.Spin,
        TargetUsername = signal.Username,
        TargetGame = signal.Game,
        TargetHouse = signal.House,
        Confidence = 1.0f, // Signal is high-confidence by definition
        Reason = $"Jackpot {signal.Priority} detected for {signal.Username}"
    };
    
    // Publish to event bus
    await _eventBus.PublishAsync(command);
}
```

### Step 2: Event Bus Subscription

In H4ND, subscribe to VisionCommands:

```csharp
await _eventBus.SubscribeAsync<VisionCommand>(async command =>
{
    if (command.CommandType == VisionCommandType.Spin)
    {
        await ExecuteSpinAsync(command);
    }
});
```

### Step 3: Spin Execution Handler

```csharp
private async Task<bool> ExecuteSpinAsync(VisionCommand command)
{
    var credential = _uow.Credentials.GetBy(
        command.TargetHouse, 
        command.TargetGame, 
        command.TargetUsername);
    
    if (credential == null)
    {
        Console.WriteLine($"[H4ND] Credential not found: {command.TargetUsername}");
        return false;
    }
    
    // Use CDP to execute spin
    await _cdp.ClickSelectorAsync(".spin-btn, [data-action='spin']");
    
    // Update balance after spin
    var balances = await _cdp.ReadBalancesAsync();
    credential.Balance = balances.Balance;
    _uow.Credentials.Upsert(credential);
    
    // Acknowledge signal
    var signal = _uow.Signals.Get(command.TargetHouse, command.TargetGame, command.TargetUsername);
    if (signal != null)
    {
        _uow.Signals.Acknowledge(signal);
    }
    
    return true;
}
```

### Step 4: Idempotency Protection

The command pipeline already has idempotency middleware. Configure it for spin commands:

```csharp
// Duplicate spin within 5 seconds for same credential = reject
// This prevents accidental double-spins
```

---

## Latency Requirements

| Stage | Target Latency |
|-------|----------------|
| H0UND detection | Continuous |
| Signal insertion to MongoDB | < 100ms |
| Event bus publish | < 50ms |
| Command pipeline | < 100ms |
| CDP spin execution | < 500ms |
| **Total end-to-end** | **< 5 seconds** |

---

## Success Criteria

- [ ] Signal generated by H0UND flows through event bus
- [ ] H4ND executes spin via CDP
- [ ] End-to-end latency < 5 seconds
- [ ] Signal acknowledged in MongoDB after spin
- [ ] Idempotency prevents duplicate spins

---

## Risks

| Risk | Mitigation |
|------|------------|
| Signal lost if H4ND down | Signal persists in MongoDB, processed on restart |
| Duplicate spins | Idempotency middleware with 5s window |
| CDP connection drops during spin | Retry logic with exponential backoff |
| Spin fails silently | Log to ERR0R, alert operator |

---

*TECH-JP-002: Jackpot Signal-to-Spin Pipeline*  
*Status: Proposed*  
*2026-02-20*

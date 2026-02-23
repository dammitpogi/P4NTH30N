# DECISION_113_RACE_CONDITION_ANALYSIS.md

**Decision**: DECISION_113 - Universal Chaos Logging and Sanity Test System  
**Analysis Type**: Race Condition & Ordering Hazards  
**Analysis Date**: 2026-02-23  
**Status**: Critical Timing Vulnerabilities Identified

---

## Race Condition Taxonomy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RACE CONDITION PATTERNS                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PATTERN A: ACK-WORK-INVERSION                                              │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐                            │
│  │  ACK     │────▶│   WORK   │────▶│  RESULT  │                            │
│  │  (early) │     │  (fails) │     │  (lost)  │                            │
│  └──────────┘     └──────────┘     └──────────┘                            │
│       ▲                                                                     │
│       └── Signal marked done before work confirmed                         │
│                                                                             │
│  PATTERN B: DOUBLE-ACK                                                      │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐                            │
│  │  ACK 1   │────▶│  WORK    │────▶│  ACK 2   │                            │
│  │  (early) │     │          │     │  (late)  │                            │
│  └──────────┘     └──────────┘     └──────────┘                            │
│       │                               │                                     │
│       └─────── Same signal ───────────┘                                     │
│              Non-idempotent state                                          │
│                                                                             │
│  PATTERN C: UNLOCK-WINDOW                                                   │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐           │
│  │  UNLOCK  │────▶│  WORKER B│────▶│  READ    │────▶│  MUTATE  │           │
│  │          │     │  acquires│     │  STALE   │     │  STOMP   │           │
│  └──────────┘     └──────────┘     └──────────┘     └──────────┘           │
│       │                                                    │                │
│       └── Mutations still pending                          │                │
│                                                            ▼                │
│                                                     ┌──────────┐           │
│                                                     │  WORKER A│           │
│                                                     │  commits │           │
│                                                     │  (late)  │           │
│                                                     └──────────┘           │
│                                                                             │
│  PATTERN D: INTERLEAVED-CLAIMS                                              │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐                            │
│  │  CLAIM   │────▶│  WORK    │────▶│  RELEASE │                            │
│  │  Worker A│     │          │     │  (early) │                            │
│  └──────────┘     └──────────┘     └──────────┘                            │
│       │                                  │                                  │
│       │  ┌──────────┐     ┌──────────┐   │                                  │
│       └──│  CLAIM   │◀────│  WORK    │◀──┘                                  │
│          │  Worker B│     │          │                                      │
│          └──────────┘     └──────────┘                                      │
│           Duplicate pickup                                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Critical Race Conditions

### RACE-001: Ack-Work-Inversion (LegacyRuntimeHost.cs:250-263)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:260-263`  
**Pattern**: ACK-WORK-INVERSION  
**Risk Level**: 🔴 **CRITICAL**

```csharp
// Line 260: Lock credential
uow.Credentials.Lock(credential);

// Line 262-263: ACKNOWLEDGE immediately (before work!)
if (signal != null)
    uow.Signals.Acknowledge(signal);  // ⚠️ ACK HERE

// Later: Login and spin happen AFTER ack
if (!ExecuteLoginWithRecorderAsync(...))  // Work happens here
{
    // If this fails, signal already acked!
    uow.Credentials.Lock(credential);  // CHAOS-003: Lock on failure
    continue;  // Signal lost forever
}
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

T0: Worker A locks credential
T1: Worker A acknowledges signal S1          ← ACK HERE
T2: Worker A attempts login...
T3: Login fails!
T4: Worker A continues loop                  ← Signal S1 lost

Result: Signal S1 marked "done" but work never completed
```

**Impact**: Work loss - signal disappears from queue without completion

**Sanity Test**:
```csharp
// INVARIANT: Signal.acknowledged == true ⟹ outcome != null
Invariant: signal.Acknowledged == true → signal.Outcome != null

// DETECT: Ack without outcome within timeout
Violation: signal.Acknowledged && signal.Outcome == null && 
           (Now - signal.AcknowledgedAt) > Timeout
```

**Logging Requirements**:
```json
{
  "ChaosPointId": "RACE-001.AckWorkInversion",
  "Timestamp": "T1",
  "Events": [
    { "Time": "T0", "Action": "Lock", "CredentialId": "C1" },
    { "Time": "T1", "Action": "Ack", "SignalId": "S1" },
    { "Time": "T3", "Action": "LoginFailed" },
    { "Time": "T4", "Action": "ContinueWithoutSignal" }
  ],
  "Violation": "Signal S1 acknowledged but never completed"
}
```

---

### RACE-002: Double-Ack Non-Idempotency (LegacyRuntimeHost.cs:260-263 + 413)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:260-263` AND `:413`  
**Pattern**: DOUBLE-ACK  
**Risk Level**: 🔴 **CRITICAL**

```csharp
// Location 1: Line 260-263 (early ack)
if (signal != null)
    uow.Signals.Acknowledge(signal);  // First ack

// ... login processing ...

// Location 2: Line 413 (late ack - SAME SIGNAL!)
if (signal != null)
{
    uow.Signals.Acknowledge(signal);  // Second ack!
    // ...
}
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

T0: Worker A acks signal S1 (first ack)
T1: Worker A processing...
T2: ??? (concurrent event) ???
T3: Worker A acks signal S1 again (second ack)

Questions:
- Was first ack lost/rolled back?
- Did another worker process S1 between T1-T3?
- Is ack implementation idempotent?
```

**Impact**: State skew - ack count non-monotonic, hard to reason about signal state

**Sanity Test**:
```csharp
// INVARIANT: Ack count should be 0 or 1 per workflow
Invariant: AckCount <= 1

// DETECT: Multiple acks with different timestamps
Violation: Signal.AckHistory.Count > 1 && 
           All acks from same workflow
```

**Logging Requirements**:
```json
{
  "ChaosPointId": "RACE-002.DoubleAck",
  "SignalId": "S1",
  "AckEvents": [
    { "Timestamp": "T0", "Line": 262, "Source": "Early" },
    { "Timestamp": "T3", "Line": 413, "Source": "Late" }
  ],
  "Violation": "Signal acknowledged twice in same workflow"
}
```

---

### RACE-003: Lock Asymmetry on Failure (LegacyRuntimeHost.cs:291-292)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:291-292`  
**Pattern**: ASYMMETRIC-LOCK  
**Risk Level**: 🔴 **CRITICAL**

```csharp
// Login failure path
if (!ExecuteLoginWithRecorderAsync(...))
{
    Console.WriteLine($"... login failed ...");
    uow.Credentials.Lock(credential);  // ⚠️ LOCK AGAIN (not unlock!)
    continue;
}
```

**Race Scenario**:
```
Scenario A: Normal flow
  Lock → Work → Unlock  (1 lock, 1 unlock) ✓

Scenario B: Login failure
  Lock → Fail → Lock → Continue  (2 locks, 0 unlocks) ✗
  
Result: Credential remains locked forever
```

**Branch Analysis**:
```
┌─────────────────┐
│   Lock Cred     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Ack Signal    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Login Success? │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐  ┌────────┐
│  YES  │  │   NO   │
└───┬───┘  └───┬────┘
    │          │
    ▼          ▼
┌───────┐  ┌────────┐
│ Spin  │  │  Lock  │  ← WRONG! Should be Unlock
└───┬───┘  │  Again │
    │      └────┬───┘
    ▼           │
┌───────┐       │
│Unlock │       │
└───────┘       ▼
           ┌────────┐
           │Continue│
           │(locked)│
           └────────┘
```

**Impact**: Permanent credential lock - requires manual intervention

**Sanity Test**:
```csharp
// INVARIANT: LockCount == UnlockCount per workflow
Invariant: Workflow.LockCount == Workflow.UnlockCount

// DETECT: Workflow ends with LockCount > UnlockCount
Violation: Workflow.Ended && (LockCount - UnlockCount) > 0
```

---

### RACE-004: Unlock-Window Persistence Gap (LegacyRuntimeHost.cs:578-601)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:578-601`  
**Pattern**: UNLOCK-WINDOW  
**Risk Level**: 🔴 **CRITICAL**

```csharp
// Line 578: UNLOCK (persists current state)
uow.Credentials.Unlock(credential);  // ⚠️ PERSISTENCE POINT 1

// Lines 580-581: Mutations happen AFTER unlock
credential.LastUpdated = DateTime.UtcNow;  // ⚠️ MUTATION
credential.Balance = validatedBalance;      // ⚠️ MUTATION

// Line 600: Final persistence
uow.Credentials.Upsert(credential);  // ⚠️ PERSISTENCE POINT 2
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

Worker A                                    Worker B
────────────────────────────────────────────────────────────
T0: Unlock credential
    (persists V1 of state)
                            
                            T1: GetNext() gets same credential
                            T2: Lock credential
                            T3: Read state (gets V1)
                            T4: Mutate field X
                            T5: Upsert (writes V2)
                            
T6: Mutate Balance (V1 + changes)
T7: Upsert (writes V3 - overwrites V2!)

Result: Worker B's changes (V2) lost!
```

**Impact**: Lost updates - Worker B's mutations overwritten by Worker A

**Sanity Test**:
```csharp
// INVARIANT: No mutations after unlock
Invariant: LastMutationTime <= UnlockTime

// DETECT: Document version not increasing monotonically
Violation: NewVersion <= OldVersion
```

**Logging Requirements**:
```json
{
  "ChaosPointId": "RACE-004.UnlockWindow",
  "Events": [
    { "Worker": "A", "Time": "T0", "Action": "Unlock", "Version": 1 },
    { "Worker": "B", "Time": "T2", "Action": "Lock", "VersionRead": 1 },
    { "Worker": "B", "Time": "T5", "Action": "Upsert", "VersionWritten": 2 },
    { "Worker": "A", "Time": "T7", "Action": "Upsert", "VersionWritten": 3 }
  ],
  "Violation": "Version 2 overwritten by Version 3 (Worker B changes lost)"
}
```

---

### RACE-005: Broad Signal Delete Under Contention (LegacyRuntimeHost.cs:482, 507, 532, 557)

**Location**: Multiple lines in jackpot processing block  
**Pattern**: BROAD-DELETE  
**Risk Level**: 🟠 **HIGH**

```csharp
// Triggered from tier branches when jackpot pops
if (gameSignal != null && gameSignal.Priority.Equals(4))
    uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);  // ⚠️ BROAD DELETE
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

Worker A (Grand pop)                        Worker B (has signal for same game)
────────────────────────────────────────────────────────────
T0: Process Grand pop
T1: DeleteAll(House="A", Game="G1")
    (deletes ALL signals for this game)
                            
                            T2: Reading signal S2 for House A, Game G1
                            T3: Signal S2 not found! (deleted by Worker A)
                            
Result: Worker B's legitimate signal deleted by Worker A's broad operation
```

**Impact**: Work deletion - legitimate signals deleted by jackpot processing

**Sanity Test**:
```csharp
// INVARIANT: DeleteAll should only affect completed signals
Invariant: DeletedSignals.All(s => s.IsCompleted)

// DETECT: Signal deleted while in progress
Violation: Signal.State == InProgress && Signal.Deleted == true
```

---

### RACE-006: Async Worker Ack Ambiguity (ParallelSpinWorker.cs:167, 183, 245)

**Location**: `H4ND/Parallel/ParallelSpinWorker.cs` lifecycle  
**Pattern**: ACK-AMBIGUITY  
**Risk Level**: 🔴 **CRITICAL**

```csharp
// Line 167: Lock
_uow.Credentials.Lock(credential);  // Lock

// Line 183: Ack
_uow.Signals.Acknowledge(signal);    // Ack

// External calls happen here (CDP, network, etc.)
await _spinExecution.ExecuteSpinAsync(...);  // Can fail!

// Line 245: Unlock in finally
_uow.Credentials.Unlock(credential);  // Always unlocks
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

ParallelSpinWorker                          LegacyRuntimeHost
────────────────────────────────────────────────────────────
T0: Lock credential
T1: Ack signal S1
T2: Start ExecuteSpinAsync...
                            
                            T3: Sees signal S1 acked
                            T4: Assumes work complete
                            T5: Releases signal resources
                            
T6: ExecuteSpinAsync fails!
T7: Exception handler runs
T8: Unlock credential
T9: Signal S1 lost (no retry)

Result: Ack semantics ambiguous - does "ack" mean "claimed" or "done"?
```

**Impact**: Work loss - signal released while work in progress

**Sanity Test**:
```csharp
// INVARIANT: Ack should only happen when work guaranteed to complete
Invariant: Signal.Acknowledged == true → WorkCompleted || WorkGuaranteed

// DETECT: Ack followed by failure without retry
Violation: Signal.Acknowledged && FailureOccurred && !RetryScheduled
```

---

### RACE-007: Triple-Ack Ownership Ambiguity (SpinExecution.cs:53)

**Location**: `H4ND/Infrastructure/SpinExecution.cs:53`  
**Pattern**: MULTIPLE-ACK-OWNERSHIP  
**Risk Level**: 🔴 **CRITICAL**

```csharp
// LegacyRuntimeHost.cs:262 - First ack
if (signal != null)
    uow.Signals.Acknowledge(signal);  // Caller acks

// Later...

// SpinExecution.cs:53 - Second ack INSIDE executor
public async Task<bool> ExecuteSpinAsync(...)
{
    // ...
    _uow.Signals.Acknowledge(signal);  // ⚠️ EXECUTOR ALSO ACKS!
    // ...
}

// LegacyRuntimeHost.cs:413 - Third ack
if (signal != null)
    uow.Signals.Acknowledge(signal);  // Caller acks again
```

**Ack Ownership Matrix**:
```
Who should ack?        When?                   Current behavior
────────────────────────────────────────────────────────────────
Caller                 On work start?          YES (line 262)
Caller                 On work complete?       YES (line 413)
Executor               During execution?       YES (line 53)
────────────────────────────────────────────────────────────────
Result: 3 acks for same signal!
```

**Impact**: Ownership ambiguity - unclear who is responsible for signal lifecycle

**Sanity Test**:
```csharp
// INVARIANT: Single responsibility - one component owns ack
Invariant: AckOwner == "Caller" XOR AckOwner == "Executor"

// DETECT: Multiple components acking same signal
Violation: UniqueAckSources.Count > 1
```

---

### RACE-008: Retry-Claim Ordering Under Contention (ParallelSpinWorker.cs:218-220, 235-237)

**Location**: `H4ND/Parallel/ParallelSpinWorker.cs:218-220` and `:235-237`  
**Pattern**: INTERLEAVED-CLAIMS  
**Risk Level**: 🟠 **HIGH**

```csharp
// Lines 218-220: Retry path A
workItem.RetryCount++;              // Mutation 1
_uow.Signals.ReleaseClaim(signal);  // Mutation 2

// Lines 235-237: Retry path B (same pattern!)
workItem.RetryCount++;              // Same mutation
_uow.Signals.ReleaseClaim(signal);  // Same mutation
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

Worker A                                    Worker B
────────────────────────────────────────────────────────────
T0: Work fails
T1: RetryCount++ (now 1)
T2: ReleaseClaim
                            
                            T3: Claims signal S1
                            T4: Starts work
                            
T5: (delayed) ReleaseClaim processes
    (releases signal S1 again!)
                            
                            T6: Signal S1 released while Worker B processing!
                            T7: Worker C claims S1
                            T8: Now TWO workers have S1!
```

**Impact**: Duplicate work - same signal processed by multiple workers

**Sanity Test**:
```csharp
// INVARIANT: Signal should have exactly one active claim
Invariant: Signal.ClaimCount == 1

// DETECT: Multiple concurrent claims
Violation: Signal.ClaimHistory.Where(c => c.Active).Count() > 1
```

---

### RACE-009: Concurrent Ban Mutation (SessionRenewalService.cs:200-201)

**Location**: `H4ND/Services/SessionRenewalService.cs:200-201`  
**Pattern**: STATUS-CLASH  
**Risk Level**: 🟠 **HIGH**

```csharp
// Lines 200-201: Ban during renewal
cred.Banned = true;  // ⚠️ MUTATION
uow.Credentials.Upsert(cred);  // ⚠️ PERSISTENCE
```

**Race Scenario**:
```
Time ───────────────────────────────────────────────────────▶

LegacyRuntimeHost                           SessionRenewalService
────────────────────────────────────────────────────────────
T0: GetNext() returns cred C1
T1: Lock cred C1
T2: Processing...
                            
                            T3: Renewal fails for cred C1
                            T4: cred.Banned = true
                            T5: Upsert cred C1
                            
T6: (still processing banned cred!)
T7: Try to use cred C1
T8: Account suspended error
T9: Mark banned (again)

Result: Double ban, wasted work on banned credential
```

**Impact**: Wasted work - processing banned credentials

**Sanity Test**:
```csharp
// INVARIANT: Banned credentials should not be processed
Invariant: !credential.Banned → WorkStarted

// DETECT: Work started on banned credential
Violation: WorkStarted && credential.Banned
```

---

## Race Detection Strategy

### Real-Time Race Detection

```csharp
public class RaceDetector
{
    private readonly ConcurrentDictionary<string, OperationLog> _inFlight = new();
    
    public void RecordOperation(string entityId, OperationType op, string workerId)
    {
        var log = new OperationLog
        {
            EntityId = entityId,
            Operation = op,
            WorkerId = workerId,
            Timestamp = DateTime.UtcNow
        };
        
        // Check for conflicting operations
        if (_inFlight.TryGetValue(entityId, out var existing))
        {
            if (IsConflict(existing, op))
            {
                AlertRaceCondition(existing, log);
            }
        }
        
        _inFlight[entityId] = log;
    }
    
    private bool IsConflict(OperationLog existing, OperationType newOp)
    {
        return (existing.Operation, newOp) switch
        {
            (OperationType.Unlock, OperationType.Lock) => true,  // RACE-004
            (OperationType.Ack, OperationType.Ack) => true,       // RACE-002
            (OperationType.DeleteAll, OperationType.Read) => true, // RACE-005
            _ => false
        };
    }
}
```

### Post-Hoc Race Analysis

Query MongoDB `_debug` collection for:

```javascript
// Find unlock-window races
db._debug.aggregate([
  { $match: { "Event.ChaosPointId": "*.Unlock" } },
  { $lookup: {
      from: "_debug",
      let: { cid: "$Event.Context.CredentialId", unlockTime: "$Event.Timestamp" },
      pipeline: [
        { $match: { 
          "Event.ChaosPointId": "*.Lock",
          $expr: { 
            $and: [
              { $eq: ["$Event.Context.CredentialId", "$$cid"] },
              { $gt: ["$Event.Timestamp", "$$unlockTime"] },
              { $lt: [{ $subtract: ["$Event.Timestamp", "$$unlockTime"] }, 1000] }
            ]
          }
        }}
      ],
      as: "subsequentLocks"
  }},
  { $match: { "subsequentLocks.0": { $exists: true } } }
])
```

---

## Summary Matrix

| Race ID | Pattern | Location | Impact | Detection Difficulty |
|---------|---------|----------|--------|---------------------|
| RACE-001 | ACK-WORK-INVERSION | LegacyRuntimeHost:260-263 | Work loss | Hard |
| RACE-002 | DOUBLE-ACK | LegacyRuntimeHost:260-263 + 413 | State skew | Medium |
| RACE-003 | ASYMMETRIC-LOCK | LegacyRuntimeHost:291-292 | Permanent locks | Easy |
| RACE-004 | UNLOCK-WINDOW | LegacyRuntimeHost:578-601 | Lost updates | Hard |
| RACE-005 | BROAD-DELETE | LegacyRuntimeHost:482, 507, 532, 557 | Work deletion | Medium |
| RACE-006 | ACK-AMBIGUITY | ParallelSpinWorker:167, 183, 245 | Work loss | Hard |
| RACE-007 | MULTIPLE-ACK-OWNERSHIP | SpinExecution.cs:53 + callers | Ownership ambiguity | Easy |
| RACE-008 | INTERLEAVED-CLAIMS | ParallelSpinWorker:218-220, 235-237 | Duplicate work | Medium |
| RACE-009 | STATUS-CLASH | SessionRenewalService:200-201 | Wasted work | Easy |

---

*Race Condition Analysis Complete*
*Ready for WindFixer Implementation with Race Detection*

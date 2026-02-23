# DECISION_113_CRITICAL_CHAOS_POINTS.md

**Decision**: DECISION_113 - Implement Universal Chaos Logging and Sanity Test System  
**Trace Date**: 2026-02-23  
**Source**: H4ND Entrypoint Trace (LegacyRuntimeHost + ParallelH4NDEngine)  
**Status**: Critical Risk Points Identified

---

## Executive Summary

Trace analysis from H4ND entrypoint through entity mutation/persistence path reveals **11 critical chaos points** with highest risk for data mangling. These points represent race conditions, non-atomic operations, premature persistence, and silent data corruption patterns.

---

## Entry Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           H4ND ENTRY FLOW                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  H4ND/H4ND.cs:8                                                              │
│       │                                                                      │
│       ▼                                                                      │
│  H4ND/Composition/RuntimeCompositionRoot.cs:19                               │
│       │                                                                      │
│       ▼                                                                      │
│  H4ND/Services/LegacyRuntimeHost.cs:53 (mode parse)                          │
│       │                                                                      │
│       ├── Sequential Path ──────────────────────────────┐                    │
│       │                                                  │                    │
│       ▼                                                  │                    │
│  H4ND/Services/LegacyRuntimeHost.cs:233                 │                    │
│  (sequential loop starts)                               │                    │
│       │                                                  │                    │
│       │  [CHAOS POINTS 1-5]                              │                    │
│       │                                                  │                    │
│       └── Signal Processing                              │                    │
│            ├── Lock Credential (291) ⚠️                 │                    │
│            ├── Ack Signal (262, 413) ⚠️⚠️               │                    │
│            ├── Unlock (578) ⚠️                          │                    │
│            └── Value Coercion (779-795) ⚠️              │                    │
│                                                          │                    │
│       └── Parallel Path ────────────────────────────────┘                    │
│                                                          │                    │
│  H4ND/EntryPoint/UnifiedEntryPoint.cs:257                                    │
│       │                                                                      │
│       ▼                                                                      │
│  H4ND/Parallel/ParallelH4NDEngine.cs:64                                     │
│       │                                                                      │
│       │  [CHAOS POINTS 10-11]                                                │
│       │                                                                      │
│       ├── SignalDistributor.cs:52, 58 (claim flapping) ⚠️                   │
│       └── ParallelSpinWorker.cs:167, 245 (stale overwrite) ⚠️               │
│                                                                              │
│  Shared Infrastructure:                                                      │
│       │                                                                      │
│       ├── C0MMON/Entities/Credential.cs:45 (silent rejection) ⚠️            │
│       ├── C0MMON/Infrastructure/Persistence/Repositories.cs:178 ⚠️          │
│       ├── C0MMON/Infrastructure/Persistence/Repositories.cs:183, 190 ⚠️     │
│       └── C0MMON/Infrastructure/Persistence/Repositories.cs:255-263 ⚠️      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Critical Chaos Points Detail

### CHAOS-001: Signal Acknowledged Before Success (LegacyRuntimeHost.cs:262)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:262`  
**Risk Level**: 🔴 **CRITICAL**  
**Pattern**: Acknowledge-then-fail

**Code Pattern**:
```csharp
// Line 262: Signal acknowledged BEFORE login/spin succeeds
if (signal != null)
    uow.Signals.Acknowledge(signal);  // ⚠️ ACK HERE

// Login attempt happens AFTER ack
if (!ExecuteLoginWithRecorderAsync(cdp, credential, ...).GetAwaiter().GetResult())
{
    Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
    uow.Credentials.Lock(credential);  // CHAOS-002: Locks on failure!
    continue;  // Signal already acked, but login failed
}
```

**Problem**:
- Signal is marked as consumed/acknowledged before login success is confirmed
- If login fails or later steps (spin) fail, signal is lost
- No mechanism to reclaim acknowledged-but-failed signals
- Creates "ghost consumed" signals

**Sanity Test Requirements**:
```csharp
// Pre-condition: Signal should be unacknowledged
PreCheck: signal.Acknowledged == false

// Post-condition: If login fails, signal should NOT be acknowledged
PostCheck: If login failed, signal should be reclaimable

// INVARIANT BROKEN: Signal can be acknowledged without corresponding outcome
InvariantViolation: signal.Acknowledged == true && outcome == null
```

**Logging Requirements**:
- Capture signal state before and after ack
- Capture login result
- Log if ack happened but login failed
- Track signal ID for orphan detection

---

### CHAOS-002: Duplicate Signal Acknowledgment (LegacyRuntimeHost.cs:413)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:413`  
**Risk Level**: 🔴 **CRITICAL**  
**Pattern**: Double-acknowledge

**Code Pattern**:
```csharp
// Line 262: First acknowledgment
if (signal != null)
    uow.Signals.Acknowledge(signal);

// ... login processing ...

// Line 413: Second acknowledgment (duplicate!)
if (signal != null)
{
    uow.Signals.Acknowledge(signal);  // ⚠️ ACK AGAIN!
    File.WriteAllText(Path.Combine(Path.GetTempPath(), "S1GNAL.json"), JsonSerializer.Serialize(true));
    // ... spin execution ...
}
```

**Problem**:
- Same signal acknowledged twice in single workflow
- Duplicate lifecycle transitions make state harder to reason about
- Can mask earlier failures (second ack overwrites first)
- Signal state transitions are not idempotent

**Sanity Test Requirements**:
```csharp
// INVARIANT: Signal should only be acknowledged once per workflow
Invariant: workflow.SignalAckCount <= 1

// Detect duplicate acks
Violation: Signal.AcknowledgedAt changes within same workflow
```

**Logging Requirements**:
- Track all ack calls with timestamp and line number
- Capture signal state after each ack
- Detect and alert on duplicate acks

---

### CHAOS-003: Lock on Failure Instead of Unlock (LegacyRuntimeHost.cs:291)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:291`  
**Risk Level**: 🔴 **CRITICAL**  
**Pattern**: Lock-amplification on error

**Code Pattern**:
```csharp
if (!ExecuteLoginWithRecorderAsync(cdp, credential, ...).GetAwaiter().GetResult())
{
    Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
    uow.Credentials.Lock(credential);  // ⚠️ LOCKS AGAIN ON FAILURE!
    continue;
}
```

**Problem**:
- On login failure, credential is locked AGAIN instead of unlocked
- Increases risk of stale lock state persisting in database
- If credential was already locked, this extends the lock
- Creates lock imbalance (more locks than unlocks)
- Can lead to permanent credential lockage

**Sanity Test Requirements**:
```csharp
// Pre-condition: Lock should not be held by this worker
PreCheck: credential.LockedBy != currentWorkerId

// Post-condition on failure: Credential should be unlocked, not re-locked
ExpectedPostFailure: credential.LockedBy == null
ActualPostFailure: credential.LockedBy == currentWorkerId  // WRONG!

// INVARIANT: Lock count should equal unlock count per workflow
Invariant: LockCount == UnlockCount
```

**Logging Requirements**:
- Capture lock/unlock operations with worker ID
- Track lock count per credential per workflow
- Alert when LockCount != UnlockCount at workflow end
- Capture stack trace of lock operations

---

### CHAOS-004: Unlock Before Post-Processing (LegacyRuntimeHost.cs:578)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:578`  
**Risk Level**: 🔴 **CRITICAL**  
**Pattern**: Premature persistence

**Code Context**:
```csharp
// Line 578: Unlock happens HERE
uow.Credentials.Unlock(credential);  // ⚠️ UNLOCKED!

// Lines 580-581: Post-processing mutations happen AFTER unlock
credential.LastUpdated = DateTime.UtcNow;  // Modified after unlock
credential.Balance = validatedBalance;      // Modified after unlock

// Later: Upsert the modified credential
uow.Credentials.Upsert(credential);  // Race condition window!
```

**Problem**:
- Unlock persists credential state to database
- Then post-processing mutations modify the in-memory object
- Finally upsert writes modified state
- Creates intermediate persisted state that can be overwritten/raced
- If another worker acquires credential between unlock and upsert, they get stale data

**Sanity Test Requirements**:
```csharp
// INVARIANT: Mutations should happen before unlock
Invariant: All mutations complete before Unlock() called

// Detect premature unlock
Violation: Unlock() called while pendingMutations > 0
```

**Logging Requirements**:
- Capture state snapshot before unlock
- Capture state snapshot after mutations
- Compute diff between unlock-state and final-state
- Track timing: unlock timestamp vs mutation timestamps

---

### CHAOS-005: Value Coercion to 0 (LegacyRuntimeHost.cs:779, 783, 787, 791, 795)

**Location**: `H4ND/Services/LegacyRuntimeHost.cs:779, 783, 787, 791, 795`  
**Risk Level**: 🟠 **HIGH**  
**Pattern**: Silent corruption normalization

**Code Pattern**:
```csharp
// Lines 779, 783, 787, 791, 795
// Check for invalid values and clamp to 0 if invalid
if (double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0)
{
    validatedBalance = 0;  // ⚠️ COERCION!
}
// Same pattern for Grand, Major, Minor, Mini
```

**Problem**:
- Converts corruption (NaN, Infinity, negative) into plausible-looking 0
- 0 is a valid business value (empty balance, no jackpot)
- Silent transformation hides data corruption root cause
- Downstream code operates on "clean" but wrong data
- Makes debugging extremely difficult

**Sanity Test Requirements**:
```csharp
// INVARIANT: Invalid values should be rejected, not coerced
Invariant: If (IsNaN(value) || IsInfinity(value) || value < 0) 
           then throw ValidationException
           else use value

// Detect coercions
Violation: OriginalValue != ValidatedValue && ValidatedValue == 0
```

**Logging Requirements**:
- Capture ORIGINAL value before any validation
- Capture coerced value
- Log coercion as Warning or Error (not silently)
- Include validation failure reason

---

### CHAOS-006: Silent Rejection Keeping Stale Values (Credential.cs:45)

**Location**: `C0MMON/Entities/Credential.cs:45`  
**Risk Level**: 🟠 **HIGH**  
**Pattern**: Silent setter rejection

**Code Pattern** (inferred):
```csharp
public double Balance 
{ 
    get => _balance;
    set 
    {
        if (value < 0)  // ⚠️ SILENT REJECTION!
        {
            // Do nothing - keep prior value
            return;
        }
        _balance = value;
    }
}
```

**Problem**:
- Invalid/negative balance assignments are silently ignored
- Prior (stale) value is retained
- Downstream code may persist stale balance while assuming fresh data
- Assignment appears to succeed but has no effect
- No indication that data was rejected

**Sanity Test Requirements**:
```csharp
// Post-condition: If assignment attempted, value should change
PostCondition: After credential.Balance = newValue, 
               credential.Balance == newValue

// Detect silent rejection
Violation: newValue != oldValue && credential.Balance == oldValue
```

**Logging Requirements**:
- Capture attempted assignment value
- Capture actual value after assignment
- Log rejection events
- Track property name and rejection reason

---

### CHAOS-007: Full-Document ReplaceOne (Repositories.cs:178)

**Location**: `C0MMON/Infrastructure/Persistence/Repositories.cs:178`  
**Risk Level**: 🟠 **HIGH**  
**Pattern**: Last-write-wins overwrite

**Code Pattern**:
```csharp
// Full-document ReplaceOne for credentials
_collection.ReplaceOne(
    filter: Builders<Credential>.Filter.Eq(x => x.Id, credential.Id),
    replacement: credential,  // ⚠️ FULL DOCUMENT REPLACE!
    options: new ReplaceOptions { IsUpsert = true }
);
```

**Problem**:
- Replaces entire document with in-memory object
- Combined with mutable in-memory objects, prone to last-write-wins
- Worker A reads credential, Worker B reads same credential
- Worker A modifies field X, Worker B modifies field Y
- Last one to write overwrites all changes from other
- No field-level concurrency control

**Sanity Test Requirements**:
```csharp
// INVARIANT: Document version should increment monotonically
Invariant: newDocument.Version == oldDocument.Version + 1

// Detect write conflicts
Violation: ReplaceOne result shows modifiedCount == 0 
           (someone else wrote between read and write)
```

**Logging Requirements**:
- Capture document version before and after
- Capture which fields were modified
- Track worker/thread ID performing write
- Log write conflicts

---

### CHAOS-008: Lock/Unlock Full-Document Upsert (Repositories.cs:183, 190)

**Location**: `C0MMON/Infrastructure/Persistence/Repositories.cs:183, 190`  
**Risk Level**: 🟠 **HIGH**  
**Pattern**: Lock amplification with full replace

**Code Pattern**:
```csharp
// Lock method
public void Lock(Credential credential)
{
    credential.LockedBy = _workerId;
    credential.LockedAt = DateTime.UtcNow;
    Upsert(credential);  // ⚠️ FULL DOCUMENT UPSERT!
}

// Unlock method
public void Unlock(Credential credential)
{
    credential.LockedBy = null;
    credential.LockedAt = null;
    Upsert(credential);  // ⚠️ FULL DOCUMENT UPSERT!
}
```

**Problem**:
- Lock/unlock mutate and immediately upsert full documents
- Amplifies race/overwrite risk under concurrency
- Only changing LockedBy field, but writing entire document
- Concurrent modifications to other fields can be lost
- No atomic compare-and-swap for lock field only

**Sanity Test Requirements**:
```csharp
// INVARIANT: Lock should only modify LockedBy and LockedAt
Invariant: Lock() only affects credential.LockedBy and credential.LockedAt

// Detect unintended field changes
Violation: Other fields modified during Lock()/Unlock()
```

**Logging Requirements**:
- Capture only the fields being modified (LockedBy, LockedAt)
- Capture full document state before/after
- Compute diff to detect unintended changes

---

### CHAOS-009: Non-Atomic Check-Then-Write (Repositories.cs:255-263)

**Location**: `C0MMON/Infrastructure/Persistence/Repositories.cs:255-263`  
**Risk Level**: 🔴 **CRITICAL**  
**Pattern**: TOCTOU (Time-of-check to time-of-use) race

**Code Pattern**:
```csharp
public void UpsertSignal(Signal signal)
{
    // Line 255: Check
    var existing = _signals.Find(x => x.Id == signal.Id).FirstOrDefault();
    
    if (existing == null)
    {
        // Line 263: Insert
        _signals.InsertOne(signal);
    }
    else
    {
        // Line 260: Update
        _signals.ReplaceOne(x => x.Id == signal.Id, signal);
    }
}
```

**Problem**:
- Signal upsert is check-then-write (non-atomic)
- Concurrent writers can duplicate or stomp signal state
- Window between check (line 255) and write (line 260/263)
- Two workers can both see existing == null and both insert
- Or both see existing != null and one overwrites the other's changes

**Sanity Test Requirements**:
```csharp
// INVARIANT: Signal operations should be idempotent
Invariant: Multiple UpsertSignal() calls with same ID produce same final state

// Detect duplicates
Violation: Multiple signals with same ID exist in collection
```

**Logging Requirements**:
- Log check result (existing == null or not)
- Log write operation (Insert or Replace)
- Capture timing between check and write
- Track concurrent operations on same signal ID

---

### CHAOS-010: Claim Ownership Flapping (SignalDistributor.cs:52, 58)

**Location**: `H4ND/Parallel/SignalDistributor.cs:52, 58`  
**Risk Level**: 🟡 **MEDIUM**  
**Pattern**: Stale claim reclamation with timing races

**Code Pattern**:
```csharp
// Line 52: Scan all signals and reclaim stale claims in-process
var allSignals = _signals.GetAll();
foreach (var stale in allSignals.Where(s =>
    s.ClaimedBy != null &&
    !s.Acknowledged &&
    s.ClaimedAt.HasValue &&
    (DateTime.UtcNow - s.ClaimedAt.Value).TotalMinutes > defaultReclaimMinutes))
{
    Console.WriteLine($"[SignalDistributor] Reclaiming stale signal {stale._id}");
    _signals.ReleaseClaim(stale);  // ⚠️ RECLAIM!
    _metrics.IncrementStaleClaims();
}

// Line 58: Timing-based reclaim
if ((DateTime.UtcNow - s.ClaimedAt.Value).TotalMinutes > 
    (s.Timeout > DateTime.MinValue ? (s.Timeout - s.ClaimedAt.Value).TotalMinutes : defaultReclaimMinutes))
```

**Problem**:
- Scans all signals and reclaims stale claims in-process
- Timing-based reclaim at line 58
- Claim ownership can flap under load
- Signal reclaimed while worker is still processing
- Reorder work unexpectedly
- No coordination between reclaim and active processing

**Sanity Test Requirements**:
```csharp
// INVARIANT: Signal should not be reclaimed while being processed
Invariant: If worker processing signal, ClaimedBy should remain that worker

// Detect flapping
Violation: Signal.ClaimedBy changes multiple times within short window
```

**Logging Requirements**:
- Capture ClaimedBy before and after reclaim
- Capture worker ID reclaiming
- Log timing: ClaimedAt vs reclaim time
- Track signal state transitions

---

### CHAOS-011: Stale Object Overwrite (ParallelSpinWorker.cs:167, 245)

**Location**: `H4ND/Parallel/ParallelSpinWorker.cs:167, 245`  
**Risk Level**: 🔴 **CRITICAL**  
**Pattern**: Last-write-wins in parallel workers

**Code Pattern**:
```csharp
// Line 167: Lock credential
_uow.Credentials.Lock(credential);

// ... worker-local processing ...
// Worker may have stale version of credential object

// Line 245: Unlock via repository full-replace
_uow.Credentials.Unlock(credential);
// Upserts entire credential object
```

**Problem**:
- Worker-local stale objects can overwrite fresher fields
- Lock/unlock via repository full-replace semantics
- Worker A locks and reads credential (version 1)
- Worker B updates credential in DB (version 2)
- Worker A unlocks, writes version 1 back, overwriting version 2
- Classic lost update problem

**Sanity Test Requirements**:
```csharp
// INVARIANT: Worker should only modify fields it owns
Invariant: Unlock() only affects Lock-related fields

// Detect stale overwrites
Violation: Document version decreases or unchanged after unlock
```

**Logging Requirements**:
- Capture credential version at lock time
- Capture credential version at unlock time
- Alert if version mismatch detected
- Track worker-local object age

---

## Implementation Priority Matrix

| Chaos Point | Risk Level | Impact | Detection Difficulty | Implementation Priority |
|-------------|------------|--------|---------------------|------------------------|
| CHAOS-001: Signal Ack Before Success | 🔴 CRITICAL | Signal loss | Hard | P0 - Must implement first |
| CHAOS-002: Duplicate Signal Ack | 🔴 CRITICAL | State confusion | Medium | P0 |
| CHAOS-003: Lock on Failure | 🔴 CRITICAL | Permanent locks | Medium | P0 |
| CHAOS-004: Unlock Before Processing | 🔴 CRITICAL | Race conditions | Hard | P0 |
| CHAOS-009: Non-Atomic Check-Then-Write | 🔴 CRITICAL | Data loss | Hard | P0 |
| CHAOS-011: Stale Object Overwrite | 🔴 CRITICAL | Lost updates | Hard | P0 |
| CHAOS-005: Value Coercion | 🟠 HIGH | Hidden corruption | Very Hard | P1 |
| CHAOS-006: Silent Rejection | 🟠 HIGH | Stale data | Very Hard | P1 |
| CHAOS-007: Full-Document ReplaceOne | 🟠 HIGH | Last-write-wins | Medium | P1 |
| CHAOS-008: Lock/Unlock Full Replace | 🟠 HIGH | Lock amplification | Medium | P1 |
| CHAOS-010: Claim Ownership Flapping | 🟡 MEDIUM | Work reordering | Easy | P2 |

---

## Recommended Sanity Test Suite

### Critical Invariants (Must Always Hold)

```csharp
public static class ChaosInvariants
{
    // CHAOS-001, CHAOS-002
    public static bool SignalAcknowledgedOnlyAfterSuccess(Signal signal, WorkflowResult result)
        => !signal.Acknowledged || result.Success;
    
    public static bool SignalAcknowledgedOnlyOnce(WorkflowContext ctx)
        => ctx.SignalAckCount <= 1;
    
    // CHAOS-003
    public static bool LockCountEqualsUnlockCount(WorkflowContext ctx)
        => ctx.LockCount == ctx.UnlockCount;
    
    public static bool CredentialUnlockedOnFailure(Credential cred, bool success)
        => success || cred.LockedBy == null;
    
    // CHAOS-004
    public static bool NoMutationsAfterUnlock(Credential cred, DateTime unlockTime)
        => cred.LastUpdated <= unlockTime;
    
    // CHAOS-005
    public static bool NoValueCoercion(double original, double validated)
        => original == validated || !(double.IsNaN(original) || double.IsInfinity(original));
    
    // CHAOS-006
    public static bool AssignmentSucceeded<T>(T original, T attempted, T actual)
        => EqualityComparer<T>.Default.Equals(attempted, actual);
    
    // CHAOS-007, CHAOS-008, CHAOS-011
    public static bool DocumentVersionMonotonic(long oldVersion, long newVersion)
        => newVersion > oldVersion;
    
    // CHAOS-009
    public static bool SignalUpsertIdempotent(Signal original, Signal updated)
        => original.Id == updated.Id;
    
    // CHAOS-010
    public static bool NoOwnershipFlapping(Signal signal, TimeSpan window)
        => signal.OwnershipChangeCount <= 1;
}
```

---

## Logging Configuration

### Per-Chaos-Point Sampling Strategy

```json
{
  "ChaosPoints": {
    "CHAOS-001": { "SamplingRate": 1.0, "Level": "Error" },
    "CHAOS-002": { "SamplingRate": 1.0, "Level": "Warning" },
    "CHAOS-003": { "SamplingRate": 1.0, "Level": "Critical" },
    "CHAOS-004": { "SamplingRate": 1.0, "Level": "Warning" },
    "CHAOS-005": { "SamplingRate": 1.0, "Level": "Warning" },
    "CHAOS-006": { "SamplingRate": 0.1, "Level": "Warning" },
    "CHAOS-007": { "SamplingRate": 0.01, "Level": "Debug" },
    "CHAOS-008": { "SamplingRate": 1.0, "Level": "Info" },
    "CHAOS-009": { "SamplingRate": 1.0, "Level": "Error" },
    "CHAOS-010": { "SamplingRate": 0.5, "Level": "Debug" },
    "CHAOS-011": { "SamplingRate": 1.0, "Level": "Warning" }
  }
}
```

---

## Files to Instrument

### High Priority (P0)
1. `H4ND/Services/LegacyRuntimeHost.cs` (lines 262, 291, 413, 578, 779-795)
2. `H4ND/Parallel/ParallelSpinWorker.cs` (lines 167, 245)
3. `C0MMON/Infrastructure/Persistence/Repositories.cs` (lines 178, 183, 190, 255-263)

### Medium Priority (P1)
4. `C0MMON/Entities/Credential.cs` (line 45)
5. `H4ND/Parallel/SignalDistributor.cs` (lines 52, 58)

---

*End of Critical Chaos Points Documentation*

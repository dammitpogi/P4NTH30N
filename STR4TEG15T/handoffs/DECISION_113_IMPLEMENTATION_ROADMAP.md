# DECISION_113_IMPLEMENTATION_ROADMAP.md

**Decision**: DECISION_113 - Universal Chaos Logging and Sanity Test System  
**Priority Method**: Mutation Density (state changes × persistence frequency)  
**Analysis Date**: 2026-02-23  
**Status**: Ready for Implementation

---

## Implementation Priority by Mutation Density

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MUTATION DENSITY PYRAMID                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                              ▲                                              │
│                             ╱ ╲                                             │
│                            ╱   ╲                                            │
│                           ╱ P0  ╲     Highest mutation density              │
│                          ╱  (6)   ╲    Main runtime loop                    │
│                         ╱───────────╲   LegacyRuntimeHost.cs                │
│                        ╱             ╲                                      │
│                       ╱    P1         ╲   High mutation density             │
│                      ╱    (5-6)        ╲  Parallel workers, Session         │
│                     ╱─────────────────────╲ renewal, Signal pipeline        │
│                    ╱                       ╲                                │
│                   ╱         P2              ╲  Medium mutation              │
│                  ╱         (3-4)             ╲ Spin execution, Domain        │
│                 ╱─────────────────────────────╲ aggregates                   │
│                ╱                               ╲                            │
│               ╱              P3                 ╲ Low mutation               │
│              ╱            (1-2)                  ╲ Telemetry, Logging        │
│             ╱─────────────────────────────────────╲                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## P0: Main Runtime Loop (Highest Mutation Density)

**Zone**: `H4ND/Services/LegacyRuntimeHost.cs`  
**Characteristics**: Sequential credential processing, jackpot/DPD mutations, signal lifecycle  
**Estimated Mutations**: ~15-20 state fields per credential iteration  
**Persistence Frequency**: Every credential (hundreds per minute)

### Chaos Points

#### P0.1: Signal/Credential Acquisition & Lock (Lines 250-263)

```csharp
// Line 250: Signal acquisition
Signal? signal = listenForSignals ? (overrideSignal ?? uow.Signals.GetNext()) : null;

// Line 251: Credential resolution  
Credential? credential = (signal == null) ? uow.Credentials.GetNext(false) : uow.Credentials.GetBy(signal.House, signal.Game, signal.Username);

// Line 260: LOCK MUTATION
uow.Credentials.Lock(credential);

// Line 262: CHAOS-001 - Signal acknowledged BEFORE success
if (signal != null)
    uow.Signals.Acknowledge(signal);
```

**State Mutations**:
- `credential.LockedBy` (from null → workerId)
- `credential.LockedAt` (from null → DateTime.UtcNow)
- `signal.Acknowledged` (from false → true)
- `signal.AcknowledgedAt` (set)

**Sanity Tests**:
```csharp
// Pre-condition: Credential should not be locked
Pre: credential.LockedBy == null

// Post-condition: Credential should be locked by this worker
Post: credential.LockedBy == CurrentWorkerId

// INVARIANT CHAOS-001: Signal should not be acked before success confirmation
Invariant: signal.Acknowledged == false || loginResult.Success == true
```

**Logging Configuration**:
```json
{
  "ChaosPointId": "H4ND.LegacyRuntimeHost.AcquireAndLock",
  "SamplingRate": 1.0,
  "LogLevel": "Info",
  "CaptureStateBefore": ["LockedBy", "LockedAt", "Balance", "Jackpots"],
  "CaptureStateAfter": ["LockedBy", "LockedAt", "Acknowledged"],
  "ComputeDiff": true
}
```

---

#### P0.2: Signal Receive & Outcome Mutation (Lines 413-428)

```csharp
// Line 413: CHAOS-002 - DUPLICATE ACK
if (signal != null)
{
    uow.Signals.Acknowledge(signal);  // Acknowledged AGAIN!
    
    // Line 417-428: Signal outcome mutation
    switch (signal.Priority)
    {
        case 1: signal.Receive(currentMini, uow.Received); break;    // Mutates signal
        case 2: signal.Receive(currentMinor, uow.Received); break;
        case 3: signal.Receive(currentMajor, uow.Received); break;
        case 4: signal.Receive(currentGrand, uow.Received); break;
    }
}
```

**State Mutations**:
- `signal.Acknowledged` (duplicate ack - idempotent but logged)
- `signal.ReceivedValue` (set to current jackpot value)
- `signal.ReceivedAt` (set)
- `signal.OutcomeRecorded` (true)
- `uow.Received` collection (insert)

**Sanity Tests**:
```csharp
// INVARIANT CHAOS-002: Only one ack per workflow
Invariant: SignalAckCount <= 1

// Post-condition: Signal should have outcome after Receive()
Post: signal.ReceivedValue > 0 && signal.OutcomeRecorded == true
```

---

#### P0.3: Jackpot/DPD/Threshold Mutation Block (Lines 469-567)

**This is the highest-density mutation zone in the entire codebase.**

```csharp
// Lines 313-340: Grand jackpot mutation
if (currentGrand < credential.Jackpots.Grand && credential.Jackpots.Grand - currentGrand > 0.1)
{
    var grandJackpot = uow.Jackpots.Get("Grand", credential.House!, credential.Game!);
    if (grandJackpot != null && grandJackpot.DPD!.Toggles.GrandPopped == true)
    {
        // MUTATION 1: Jackpot value
        if (currentGrand >= 0 && currentGrand <= 10000)
        {
            credential.Jackpots.Grand = currentGrand;  // ⚠️ MUTATION
        }
        
        // MUTATION 2: DPD toggle
        grandJackpot.DPD!.Toggles.GrandPopped = false;  // ⚠️ MUTATION
        
        // MUTATION 3: Threshold recalculation
        credential.Thresholds.NewGrand(credential.Jackpots.Grand);  // ⚠️ MUTATION
        
        // MUTATION 4: Signal deletion
        if (gameSignal != null && gameSignal.Priority.Equals(4))
            uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);  // ⚠️ MUTATION
    }
    else if (grandJackpot?.DPD != null)
        grandJackpot.DPD.Toggles.GrandPopped = true;  // ⚠️ MUTATION
}
```

**Similar patterns for Major (342-368), Minor (370-396), Mini (398-424)**

**State Mutations per Tier** (×4 tiers = up to 16 mutations):
Per tier:
- `credential.Jackpots.{Tier}` (value update)
- `jackpot.DPD.Toggles.{Tier}Popped` (boolean toggle)
- `credential.Thresholds.{Tier}` (threshold object)
- `uow.Signals` (conditional deletion)

**Total Mutations in Block**: Up to 16 credential/jackpot mutations + 4 potential signal deletions

**Sanity Tests**:
```csharp
// Pre-condition: Jackpot values should be valid
Pre: !double.IsNaN(currentGrand) && !double.IsInfinity(currentGrand)

// Post-condition: If jackpot dropped > 0.1, DPD should be reset
Post: (oldGrand - newGrand > 0.1) == (DPD.Toggles.GrandPopped == false)

// Post-condition: Threshold should be recalculated after jackpot pop
Post: credential.Thresholds.Grand != oldThreshold

// INVARIANT: Threshold should always be > current jackpot
Invariant: credential.Thresholds.Grand > credential.Jackpots.Grand
```

**Logging Configuration**:
```json
{
  "ChaosPointId": "H4ND.LegacyRuntimeHost.JackpotMutation",
  "SamplingRate": 1.0,
  "LogLevel": "Debug",
  "CaptureStateBefore": [
    "Jackpots.Grand", "Jackpots.Major", "Jackpots.Minor", "Jackpots.Mini",
    "Thresholds.Grand", "Thresholds.Major", "Thresholds.Minor", "Thresholds.Mini"
  ],
  "CaptureDPDState": true,
  "ComputeDiff": true,
  "BatchRelatedMutations": true
}
```

---

#### P0.4: Credential Metadata Mutation (Lines 575-582)

```csharp
// Line 575-576: Settings mutation
if (credential.Settings.Gold777 == null)
    credential.Settings.Gold777 = new Gold777_Settings();  // ⚠️ MUTATION

// Line 577: Updated flag
credential.Updated = true;  // ⚠️ MUTATION

// Line 578: CHAOS-004 - Unlock BEFORE final mutations
uow.Credentials.Unlock(credential);  // ⚠️ CRITICAL: Unlock here!

// Lines 580-581: Post-unlock mutations (RACE CONDITION!)
credential.LastUpdated = DateTime.UtcNow;  // ⚠️ MUTATION AFTER UNLOCK
credential.Balance = validatedBalance;      // ⚠️ MUTATION AFTER UNLOCK
```

**State Mutations**:
- `credential.Settings.Gold777` (lazy init)
- `credential.Updated` (boolean)
- `credential.LockedBy` → null (unlock)
- `credential.LockedAt` → null (unlock)
- `credential.LastUpdated` (timestamp)
- `credential.Balance` (double)

**Sanity Tests**:
```csharp
// INVARIANT CHAOS-004: No mutations after unlock
Invariant: credential.LastModifiedTimestamp <= unlockTimestamp

// Post-condition: Credential should be unlocked
Post: credential.LockedBy == null && credential.LockedAt == null

// Post-condition: Balance should be updated
Post: credential.Balance == validatedBalance
```

---

#### P0.5: Credential Persistence (Line 600)

```csharp
// Line 600: Full-document upsert
uow.Credentials.Upsert(credential);  // ⚠️ PERSISTS ALL MUTATIONS
```

**State Mutations**: Persists entire credential object (CHAOS-007)

**Sanity Tests**:
```csharp
// Pre-condition: Credential should be valid
Pre: credential.IsValid()

// Post-condition: Document version should increment
Post: persistedCredential.Version == oldVersion + 1
```

---

#### P0.6: Ban and Persistence (Lines 854-855)

```csharp
// Line 854: Ban mutation
credential.Banned = true;  // ⚠️ MUTATION

// Line 855: Immediate persistence
uow.Credentials.Upsert(credential);  // ⚠️ PERSISTENCE
```

**State Mutations**:
- `credential.Banned` (true)

---

#### P0.7: Process Event Insertion (Line 910)

```csharp
// Line 910: Side-effect persistence
uow.ProcessEvents.Insert(alert.Record(credential));  // ⚠️ SIDE-EFFECT
```

**State Mutations**: Inserts to separate collection (audit trail)

---

## P1: Parallel Worker Execution Path

**Zone**: `H4ND/Parallel/ParallelSpinWorker.cs`  
**Characteristics**: Concurrent execution, work redistribution, retry logic  
**Estimated Mutations**: ~8-12 state fields per signal  
**Persistence Frequency**: Per signal (hundreds per minute under load)

### Chaos Points

#### P1.1: Credential Lock (Line 167)

```csharp
// Line 167: Lock within parallel worker context
_uow.Credentials.Lock(credential);  // ⚠️ MUTATION
```

**State Mutations**:
- `credential.LockedBy` → WorkerId
- `credential.LockedAt` → DateTime.UtcNow

**Sanity Tests**:
```csharp
// Pre-condition: Credential not locked by another worker
Pre: credential.LockedBy == null || credential.LockedBy == CurrentWorkerId
```

---

#### P1.2: Signal Acknowledge (Line 183)

```csharp
// Line 183: Ack in parallel context
_uow.Signals.Acknowledge(signal);  // ⚠️ MUTATION
```

---

#### P1.3: Retry Count & Claim Release (Lines 218-220)

```csharp
// Lines 218-220: Work redistribution mutation
workItem.RetryCount++;  // ⚠️ MUTATION
_uow.Signals.ReleaseClaim(signal);  // ⚠️ MUTATION
```

**State Mutations**:
- `workItem.RetryCount` (increment)
- `signal.ClaimedBy` → null
- `signal.ClaimedAt` → null

---

#### P1.4: Exception Path Retry & Release (Lines 235-237)

```csharp
// Lines 235-237: Exception path mutations
workItem.RetryCount++;  // ⚠️ MUTATION
_uow.Signals.ReleaseClaim(signal);  // ⚠️ MUTATION
```

Same mutations as P1.3 but on exception path.

---

#### P1.5: Unlock in Finally (Line 245)

```csharp
// Line 245: CHAOS-011 - Unlock in finally (critical state transition)
_uow.Credentials.Unlock(credential);  // ⚠️ CRITICAL MUTATION
```

**State Mutations**:
- `credential.LockedBy` → null
- `credential.LockedAt` → null

**Sanity Tests**:
```csharp
// INVARIANT CHAOS-011: Stale object overwrite prevention
Invariant: DocumentVersion increases monotonically

// Post-condition: Always unlocked in finally
Post: credential.LockedBy == null
```

---

## P2: Session Renewal / Auth Recovery

**Zone**: `H4ND/Services/SessionRenewalService.cs`  
**Characteristics**: Platform health, failure tracking, ban decisions  
**Estimated Mutations**: ~5-8 state fields per renewal  
**Persistence Frequency**: On auth failures (lower frequency, high impact)

### Chaos Points

#### P2.1: Platform Health Mutation (Lines 57-64)

```csharp
// Lines 57-64: Health state mutations
platformHealth.IsHealthy = true;  // ⚠️ MUTATION
platformHealth.ConsecutiveFailures = 0;  // ⚠️ MUTATION
platformHealth.LastSuccessAt = DateTime.UtcNow;  // ⚠️ MUTATION
platformHealth.Status = PlatformStatus.Healthy;  // ⚠️ MUTATION
```

#### P2.2: Failure Health Path (Lines 73-79)

```csharp
// Lines 73-79: Failure tracking mutations
platformHealth.ConsecutiveFailures++;  // ⚠️ MUTATION
platformHealth.LastFailureAt = DateTime.UtcNow;  // ⚠️ MUTATION
platformHealth.IsHealthy = false;  // ⚠️ MUTATION
```

#### P2.3: Health Recovery (Lines 181-186)

```csharp
// Lines 181-186: Recovery mutations
platformHealth.IsHealthy = true;  // ⚠️ MUTATION
platformHealth.ConsecutiveFailures = 0;  // ⚠️ MUTATION
```

#### P2.4: Ban and Persist (Lines 200-201)

```csharp
// Lines 200-201: Critical ban mutation
cred.Banned = true;  // ⚠️ CRITICAL MUTATION
uow.Credentials.Upsert(cred);  // ⚠️ PERSISTENCE
```

#### P2.5: Critical Error Insertion (Lines 247-249)

```csharp
// Lines 247-249: Error logging side-effect
uow.Errors.Insert(ErrorLog.Create(...));  // ⚠️ SIDE-EFFECT
```

---

## P3: Signal Creation Pipeline

**Zone**: `H4ND/Services/SignalGenerator.cs`  
**Characteristics**: Control-plane mutations, new work introduction  
**Estimated Mutations**: ~3-5 state fields per generation  
**Persistence Frequency**: On jackpot threshold breach

### Chaos Points

#### P3.1: Probe Signal Creation (Lines 64-69)

```csharp
// Lines 64-69: Probe signal creation
var probeSignal = new Signal { ... };  // ⚠️ NEW OBJECT
```

#### P3.2: Signal Upsert (Lines 117-119)

```csharp
// Lines 117-119: Signal persistence (new work introduction)
uow.Signals.Upsert(signal);  // ⚠️ PERSISTENCE
```

#### P3.3: Generation Result Counters (Lines 79, 88, 124, 132)

```csharp
// Control-plane mutation
result.SignalsGenerated++;  // ⚠️ MUTATION
result.TierCounts[tier]++;  // ⚠️ MUTATION
```

---

## P4: Domain Aggregate Mutation Core

**Zone**: `H4ND/Domains/Automation/Aggregates/Credential.cs`  
**Characteristics**: Domain-layer state transitions, event sourcing  
**Estimated Mutations**: ~3-5 state fields per operation  
**Persistence Frequency**: Intermediate (called by higher layers)

### Chaos Points

#### P4.1: Jackpot Snapshot Replacement (Line 114)

```csharp
// Line 114: Replaces jackpot snapshot
Jackpots = new JackpotSnapshot(...);  // ⚠️ MUTATION
```

#### P4.2: DPD/Threshold Mutation (Lines 128-133)

```csharp
// Lines 128-133: Tier evaluation mutations
DPD.Toggles.EvaluateTier(tier);  // ⚠️ MUTATION
Thresholds.UpdateForTier(tier, value);  // ⚠️ MUTATION
```

#### P4.3: Event-Apply State Mutation (Lines 143-151)

```csharp
// Lines 143-151: Event-sourced mutations
IsLocked = true;  // ⚠️ MUTATION
LockExpiresAtUtc = expiresAt;  // ⚠️ MUTATION
Thresholds = new Thresholds(...);  // ⚠️ MUTATION
```

---

## Implementation Order

### Phase 1: P0 Core (Week 1)
**Goal**: Instrument highest mutation density zone

| Priority | File | Lines | Chaos Point ID | Focus |
|----------|------|-------|----------------|-------|
| P0.1 | LegacyRuntimeHost.cs | 250-263 | H4ND.LegacyRuntimeHost.AcquireAndLock | Lock + Ack |
| P0.3 | LegacyRuntimeHost.cs | 469-567 | H4ND.LegacyRuntimeHost.JackpotMutation | Jackpot/DPD |
| P0.4 | LegacyRuntimeHost.cs | 575-582 | H4ND.LegacyRuntimeHost.MetadataMutation | Unlock timing |
| P0.5 | LegacyRuntimeHost.cs | 600 | H4ND.LegacyRuntimeHost.Persist | Upsert |

### Phase 2: P0 Signal Lifecycle (Week 1-2)
**Goal**: Capture signal state transitions

| Priority | File | Lines | Chaos Point ID | Focus |
|----------|------|-------|----------------|-------|
| P0.2 | LegacyRuntimeHost.cs | 413-428 | H4ND.LegacyRuntimeHost.SignalOutcome | Receive() |
| P0.6 | LegacyRuntimeHost.cs | 854-855 | H4ND.LegacyRuntimeHost.Ban | Ban path |

### Phase 3: P1 Parallel Workers (Week 2)
**Goal**: Concurrent execution tracking

| Priority | File | Lines | Chaos Point ID | Focus |
|----------|------|-------|----------------|-------|
| P1.1 | ParallelSpinWorker.cs | 167 | H4ND.ParallelSpinWorker.Lock | Worker lock |
| P1.3 | ParallelSpinWorker.cs | 218-220 | H4ND.ParallelSpinWorker.RetryRelease | Retry path |
| P1.5 | ParallelSpinWorker.cs | 245 | H4ND.ParallelSpinWorker.Unlock | Finally unlock |

### Phase 4: P2 Session/Auth (Week 3)
**Goal**: Health and recovery tracking

| Priority | File | Lines | Chaos Point ID | Focus |
|----------|------|-------|----------------|-------|
| P2.1 | SessionRenewalService.cs | 57-64 | H4ND.SessionRenewal.HealthSuccess | Health OK |
| P2.2 | SessionRenewalService.cs | 73-79 | H4ND.SessionRenewal.HealthFailure | Health fail |
| P2.4 | SessionRenewalService.cs | 200-201 | H4ND.SessionRenewal.Ban | Ban decision |

### Phase 5: P3/P4 Signal/Domain (Week 3-4)
**Goal**: Control-plane and domain layer

| Priority | File | Lines | Chaos Point ID | Focus |
|----------|------|-------|----------------|-------|
| P3.2 | SignalGenerator.cs | 117-119 | H4ND.SignalGenerator.Upsert | New work |
| P4.2 | Credential.cs (Domain) | 128-133 | H4ND.Domain.Credential.EvaluateTier | DPD logic |

---

## Sanity Test Inventory

### Critical Invariants (Must Always Pass)

```csharp
public static class MutationInvariants
{
    // P0.1, P0.2: Signal lifecycle
    public static bool SignalAckedOnlyAfterSuccess(Signal s, bool loginOk)
        => !s.Acknowledged || loginOk;
    
    // P0.3: Jackpot consistency
    public static bool JackpotDropCorrelatesWithDPDReset(
        double oldJackpot, double newJackpot, DPDToggles toggles)
        => (oldJackpot - newJackpot <= 0.1) || (toggles.Popped == false);
    
    // P0.4: Timing
    public static bool NoMutationAfterUnlock(DateTime lastModified, DateTime unlockedAt)
        => lastModified <= unlockedAt;
    
    // P0.5: Version monotonicity
    public static bool VersionIncreases(long oldVersion, long newVersion)
        => newVersion > oldVersion;
    
    // P1.5: Stale object prevention
    public static bool WorkerLocalVersionCurrent(long workerVersion, long dbVersion)
        => workerVersion >= dbVersion;
    
    // P2.4: Ban persistence
    public static bool BanImmediatelyPersisted(Credential c, bool wasBanned)
        => !wasBanned || c.Banned;
}
```

---

## Performance Targets by Zone

| Zone | Events/Sec Target | Sampling Strategy | Max Latency |
|------|-------------------|-------------------|-------------|
| P0 Main Loop | 500 | 100% (never sample) | 1ms |
| P1 Parallel | 2000 | 100% (never sample) | 1ms |
| P2 Session | 50 | 100% | 5ms |
| P3 Signal Gen | 100 | 100% | 2ms |
| P4 Domain | 200 | 100% | 1ms |

---

*Implementation Roadmap Complete - Ready for WindFixer Deployment*

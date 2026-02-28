# ADR-002: Thread-Safe Idempotent Signal Generation

## Status
**Accepted** — 2026-02-18

## Context

### Problem
H0UND analytics agent generates duplicate signals during high-load jackpot forecasting when multiple instances poll the same credentials simultaneously. The `SignalService.GenerateSignals()` method performs a read-check-write pattern (`Exists` → `Upsert`) that is **not atomic** in MongoDB. Under concurrent load:

1. Instance A reads `existingSignals` (empty for credential X)
2. Instance B reads `existingSignals` (still empty — A hasn't written yet)
3. Both A and B call `uow.Signals.Upsert(sig)` for the same credential
4. Result: duplicate signals, H4ND processes both, double-billing the account

### Impact
- **Revenue loss**: Double-billing casino accounts erodes operator trust
- **Data corruption**: Duplicate signals pollute the SIGN4L collection
- **H4ND confusion**: Two signals for the same credential cause conflicting automation

## Decision Drivers
- Must resolve race conditions with zero breaking changes to H4ND
- Must add <100ms latency to the signal pipeline
- Must work with existing MongoDB infrastructure (no Redis/external dependencies)
- Must follow P4NTHE0N patterns (IStoreErrors, IsValid, etc.)

## Options Considered

### Option 1: MongoDB Unique Index (Rejected)
Add a unique compound index on `{House, Game, Username}` in SIGN4L collection.
- **Pro**: Simple, zero code changes, MongoDB enforces uniqueness
- **Con**: Doesn't prevent the race window — both writes succeed if timed right with `ReplaceOne`. Upsert with `IsUpsert=true` could work but the existing `Signals.Upsert()` does find-then-replace, not findAndModify. Also doesn't address the higher-level problem of two H0UND instances doing redundant analytics work on the same game.

### Option 2: Application-Level Distributed Locks (Selected)
Implement MongoDB-based distributed locks using a dedicated `L0CK` collection with TTL expiry. Before generating signals for a `(House, Game)` pair, acquire a lock. Only the lock holder generates signals.
- **Pro**: Prevents all redundant work, not just duplicate writes. Composable. Uses existing MongoDB. TTL auto-expires stale locks.
- **Con**: Adds ~5-15ms per lock acquire (one MongoDB round-trip). Requires lock cleanup on crash.

### Option 3: Optimistic Concurrency with Version Field (Rejected)
Add a `Version` field to Signal and use conditional updates.
- **Pro**: No locking overhead
- **Con**: Requires retry loops, doesn't prevent redundant analytics computation, complex to retrofit into existing Upsert pattern

## Architecture

### Components

```
AnalyticsWorker.RunAnalytics(uow)
  └─ IdempotentSignalGenerator.GenerateSignals(uow, groups, jackpots, signals)
       ├─ DistributedLockService.TryAcquire("signal:{House}:{Game}")
       │    └─ MongoDB L0CK collection with TTL index
       ├─ SignalDeduplicationCache.IsProcessed(signalKey)
       │    └─ In-memory LRU cache (ConcurrentDictionary + timestamp)
       ├─ CircuitBreaker (existing s_mongoCircuit)
       │    └─ Fail-fast if MongoDB unavailable
       ├─ RetryPolicy.ExecuteAsync(operation)
       │    └─ Exponential backoff: 100ms, 200ms, 400ms (3 retries max)
       ├─ SignalService.GenerateSignals() [UNCHANGED - backward compat]
       ├─ DeadLetterQueue.Enqueue(failedSignal)
       │    └─ D34DL3TT3R MongoDB collection
       └─ SignalMetrics.Record(duration, outcome)
            └─ In-memory counters + periodic logging
```

### Key Design Decisions

1. **Wrapper pattern**: `IdempotentSignalGenerator` wraps the existing `SignalService` rather than modifying it. This preserves backward compatibility — if the new system is disabled, the old path works unchanged.

2. **Lock granularity**: Per `(House, Game)` pair, not per credential. This matches the analytics grouping in `AnalyticsWorker` and prevents the common case where multiple H0UND instances process the same game simultaneously.

3. **Lock TTL**: 30 seconds. Analytics for one game group typically completes in <5s. The 30s TTL provides safety margin while ensuring crashed instances don't hold locks indefinitely.

4. **Deduplication cache**: In-memory with 5-minute TTL. Signals for the same `(House, Game, Username)` within 5 minutes are deduplicated without hitting MongoDB. This is the cheapest check and runs first.

5. **Dead letter queue**: Failed signals go to `D34DL3TT3R` collection for manual review rather than being silently dropped. Enables reconciliation.

## Performance Analysis

| Operation | Latency | When |
|-----------|---------|------|
| Dedup cache check | <0.01ms | Every signal |
| Lock acquire | 5-15ms | Per (House, Game) group |
| Lock release | 5-10ms | Per (House, Game) group |
| Signal generation | Existing | Unchanged |
| **Total overhead** | **10-25ms** | Per group (not per signal) |

The lock overhead is amortized across all credentials in a game group (typically 5-20 credentials). Per-signal overhead is <2ms.

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Lock contention under high load | Medium | Low | 30s TTL, non-blocking TryAcquire returns false |
| MongoDB L0CK collection unavailable | Low | Medium | Circuit breaker falls through to unprotected path |
| Stale locks after crash | Low | Low | TTL index auto-cleans; manual cleanup via CLEANUP tools |
| Memory pressure from dedup cache | Very Low | Low | Bounded to 10,000 entries with LRU eviction |

## Backward Compatibility

- **H4ND**: Zero changes. H4ND reads signals via `IRepoSignals.GetNext()` which is unchanged. Signal entity format is identical.
- **IRepoSignals**: Interface unchanged. No new methods required.
- **SignalService**: Static methods unchanged. `IdempotentSignalGenerator` calls them internally.
- **IUnitOfWork**: Unchanged. New services receive `IMongoDatabaseProvider` directly for lock collection access.

## Rollback Procedure

1. In `H0UND/H0UND.cs`, change `useIdempotentSignals: true` to `false`
2. Rebuild: `dotnet build H0UND/H0UND.csproj`
3. Drop lock collection: `db.L0CK.drop()` in MongoDB shell
4. Drop dead letter collection: `db.D34DL3TT3R.drop()`
5. Verify H4ND continues consuming signals normally

## Monitoring Runbook

### Key Metrics (logged every 60s by SignalMetrics)
- `signals.generated` — Total signals generated
- `signals.deduplicated` — Signals caught by dedup cache
- `signals.lock_acquired` — Lock acquisitions
- `signals.lock_contention` — Lock acquire failures (contention)
- `signals.dead_lettered` — Signals sent to dead letter queue
- `signals.latency_ms` — P50/P99 signal generation latency

### Alerts
- `signals.dead_lettered > 0` → Investigate failed signals
- `signals.lock_contention > 50%` → Lock TTL may need tuning
- Circuit breaker open → MongoDB connectivity issue

## Deployment Guide

1. Build: `dotnet build P4NTHE0N.slnx`
2. Run tests: `dotnet test UNI7T35T/UNI7T35T.csproj`
3. Deploy H0UND with `useIdempotentSignals: true` (default)
4. MongoDB TTL index is created automatically on first lock acquire
5. Monitor `SignalMetrics` output in H0UND dashboard logs for 30 minutes
6. Verify H4ND signal consumption is normal

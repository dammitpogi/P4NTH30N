# H0UND Agent Manifest

> **Staleness**: 30 days (runbook-tier)
> **Last Reviewed**: 2026-02-18
> **Owner**: Oracle

---

## Purpose

H0UND is the **polling and analytics loop** — it reads credentials, computes DPD (Dollars Per Day), forecasts jackpots, and emits signals for H4ND to execute.

## Entry Point

`H0UND/H0UND.cs` — static `Main()` with continuous polling loop.

## Behavior Specification

### Startup Sequence
1. Initialize MongoDB connection via `Database.Connect()`
2. Create `IUnitOfWork` from `MongoUnitOfWork`
3. Initialize circuit breakers: `s_apiCircuit` (threshold: 5, recovery: 60s), `s_mongoCircuit` (threshold: 3, recovery: 30s)
4. Enter main polling loop

### Main Loop (per credential)
1. Lock credential via `uow.Credentials.Lock(credential)`
2. Poll balances via `s_apiCircuit.ExecuteAsync()` → `pollingWorker.GetBalancesWithRetry()`
3. Update credential with new balance/jackpot values
4. Compute DPD from historical data points
5. Generate jackpot predictions via `ForecastingService.GeneratePredictions()`
6. Generate signals via `IdempotentSignalGenerator.GenerateSignals()`
7. Unlock credential in `finally` block
8. Sleep with jitter (3–5s normal, 5s on circuit open)

### Circuit Breaker States
| State | Behavior |
|-------|----------|
| **Closed** | Normal polling — all API calls proceed |
| **Open** | Skip credential, log warning, increment failed poll, sleep 5s |
| **HalfOpen** | Allow one probe call — success → Closed, failure → Open |

### Signal Generation Flow
```
Credentials grouped by (House, Game)
  → IdempotentSignalGenerator acquires distributed lock
  → SignalService.GenerateSignals evaluates isDue logic
  → Deduplication cache prevents duplicate signals
  → Qualified signals upserted to SIGN4L collection
```

### isDue Logic (SignalService)
| Priority | Condition |
|----------|-----------|
| ≥2 | ETA within 6h AND threshold met AND avgBalance ≥ $6 |
| ≥2 | ETA within 4h AND threshold met AND avgBalance ≥ $4 |
| ≥2 | ETA within 2h (no balance/threshold requirement) |
| 1 (Mini) | ETA within 1h |

## Dependencies

| Dependency | Type | Notes |
|------------|------|-------|
| C0MMON | Project | Entities, interfaces, DB access |
| MongoDB | External | CRED3N7IAL, G4ME, SIGN4L, J4CKP0T collections |
| CircuitBreaker | Internal | `C0MMON/Infrastructure/Resilience/CircuitBreaker.cs` |
| IdempotentSignalGenerator | Internal | `H0UND/Domain/Signals/IdempotentSignalGenerator.cs` |
| ForecastingService | Internal | `H0UND/Domain/Forecasting/ForecastingService.cs` |

## Error Handling

- **API failures**: Circuit breaker trips after threshold, falls back to skip
- **Invalid DPD/jackpot data**: Validated via `IsValid(IStoreErrors)`, logged to ERR0R, not mutated
- **Lock contention**: Skipped with metric recorded
- **Signal generation failure**: Dead-lettered via `InMemoryDeadLetterQueue`

## Health Indicators

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Poll success rate | >95% | 80-95% | <80% |
| Circuit breaker state | Closed | HalfOpen | Open |
| Signal generation latency | <100ms | 100-500ms | >500ms |
| ERR0R count (last 1h) | 0 | 1-5 | >5 |

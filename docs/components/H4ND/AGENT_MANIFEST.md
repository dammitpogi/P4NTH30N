# H4ND Agent Manifest

> **Staleness**: 30 days (runbook-tier)
> **Last Reviewed**: 2026-02-18
> **Owner**: Oracle

---

## Purpose

H4ND is the **automation execution loop** — it pulls signals (or N3XT queue entries), logs into game portals via Selenium + input simulation, reads jackpot/balance values, and executes spins.

## Entry Point

`H4ND/H4ND.cs` — static `Main()` with signal-driven automation loop.

## Behavior Specification

### Startup Sequence
1. Initialize MongoDB connection via `Database.Connect()`
2. Create `IUnitOfWork` from `MongoUnitOfWork`
3. Initialize browser driver (ChromeDriver via Selenium)
4. Enter main signal consumption loop

### Main Loop
1. **Pull signal**: Check `SIGN4L` collection for unacknowledged signals (priority-ordered)
2. **Fallback**: If no signal, pull from `N3XT` queue for non-signal polling
3. **Acknowledge**: Mark signal as acknowledged before execution
4. **Login**: Navigate to portal URL, authenticate via `Login.Execute()`
5. **Read state**: Extract balance + jackpot values via JavaScript injection
6. **Validate**: Check balance/jackpot values via `IsValid(IStoreErrors)`
7. **Execute**: Run spin automation via `Spin.Execute()`
8. **Update**: Write updated balance/jackpot to `CRED3N7IAL` collection
9. **Cleanup**: Release credential lock, update `G4ME` data

### Signal Processing Rules
| Condition | Action |
|-----------|--------|
| Signal available, not acknowledged | Acknowledge → Execute |
| Signal acknowledged by other instance | Skip |
| Signal timed out | Delete, pull next |
| No signal, N3XT available | Execute N3XT entry |
| No signal, no N3XT | Sleep with backoff |

### Browser Automation Stack
```
Selenium WebDriver (ChromeDriver)
  → Page navigation (URL from CRED3N7IAL)
  → Login via form fill + submit
  → JavaScript execution for value reads
  → Input simulation for spin actions
  → RUL3S resource overrides (Chrome extension)
```

## Dependencies

| Dependency | Type | Notes |
|------------|------|-------|
| C0MMON | Project | Entities, interfaces, DB access, Actions/ |
| MongoDB | External | CRED3N7IAL, SIGN4L, N3XT, G4ME collections |
| Selenium.WebDriver | NuGet | Browser automation |
| ChromeDriver | Binary | `PROF3T/drivers/chromedriver.exe` |
| RUL3S | Extension | Resource override rules for portal manipulation |

## Error Handling

- **Login failure**: Retry up to 10 iterations, log line number on exception
- **Stale element**: Retry JavaScript reads with backoff
- **Balance validation failure**: Log to ERR0R, skip credential update
- **Browser crash**: Dispose driver, reinitialize, continue loop
- **Signal timeout**: Delete stale signal, continue to next

## Safety Constraints

- **MUST** validate all balance reads before persisting (reject NaN, Infinity, negative)
- **MUST** acknowledge signal before starting execution (prevent double-execution)
- **MUST** release credential locks in `finally` blocks
- **MUST NOT** execute without valid signal or N3XT entry
- **MUST NOT** log passwords to console or ERR0R collection
- **MUST NOT** exceed configured spin rate limits

## Health Indicators

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Signal ack latency | <1s | 1-5s | >5s |
| Login success rate | >90% | 70-90% | <70% |
| Balance read validity | >99% | 95-99% | <95% |
| Browser restart count (1h) | 0 | 1-2 | >2 |

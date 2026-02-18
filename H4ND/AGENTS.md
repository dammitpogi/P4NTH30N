# H4ND

## Responsibility

H4ND is the automation execution agent that manages game platform interactions through browser automation. It orchestrates credential management, signal processing, and automated gameplay operations across supported platforms (FireKirin, OrionStars).

## When Working Here

- **Signal-driven design**: Main loop processes signals from MongoDB queue
- **Resilient architecture**: Infinite while-loop with try/catch for exception recovery
- **Credential lifecycle**: Lock → Validate → Process → Unlock
- **Jackpot monitoring**: Track 4-tier system (Grand/Major/Minor/Mini)
- **Validation first**: Extensive validation before any operations (NaN, Infinity, negative checks)
- **Browser automation**: Use Selenium ChromeDriver responsibly with proper cleanup

## Core Functions

- **Signal-driven automation**: Processes signals from MongoDB queue to trigger game spins
- **Credential lifecycle**: Locks, validates, updates, and unlocks user credentials atomically
- **Jackpot monitoring**: Tracks 4-tier jackpot system and resets thresholds when jackpots pop
- **Browser automation**: Uses Selenium ChromeDriver to interact with game platforms
- **Health monitoring**: Logs validation errors and processing failures to ERR0R collection

## Main Processing Loop

```
Initialize (display header, MongoDB UoW)
Outer while (true) - Exception recovery
└── Inner while (true) - Signal processing
    ├── Get signal (optional) → Get credential → Lock credential
    ├── If signal: Login to platform (OrionStars)
    │   └── Launch ChromeDriver (reuse)
    ├── Check extension Grand value (JS execution)
    │   └── Validate Grand > 0 (40 retries, 500ms)
    ├── Query balances (GetBalancesWithRetry)
    │   ├── 3 network attempts with exponential backoff
    │   └── Validate Grand > 0 (40 retries)
    ├── Validate raw values (NaN, Infinity, negative)
    ├── If signal:
    │   ├── Receive signal values (store to EV3NT)
    │   ├── Spin game (FireKirin or FortunePiggy)
    │   └── Acknowledge signal
    ├── Update credential jackpots:
    │   ├── Detect drops via DPD toggles
    │   ├── Reset thresholds if jackpot popped
    │   └── Clear signals for dropped priority
    ├── Validate credential → Upsert to CRED3N7IAL
    ├── Periodic health check (every 5 min)
    └── Logout
```

## Jackpot Detection Logic

**DPD (Double-Pointer-Detection) Pattern:**
- First drop detected: Set toggle to true (wait for confirmation)
- Second consecutive drop: Confirm jackpot pop, reset toggle, recalculate threshold
- Two consecutive drops required for confirmation (> 0.1 threshold)

## Key Patterns

1. **Signal Processing Loop**: Infinite while-loop with try/catch resilience
2. **Platform Abstraction**: Game-specific logic for FireKirin and OrionStars
3. **Jackpot Reset Detection**: DPD toggle pattern for reliable detection
4. **Validation-First Approach**: Extensive validation, invalid data logged to ERR0R (no auto-repair)
5. **Retry with Exponential Backoff**: 3 network attempts (2s to 30s max), 40 retries for Grand check

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: MongoDB operations
- `Credential` entity: User credentials, jackpots, thresholds, DPD toggles
- `Signal` entity: Priority (1=Mini, 2=Minor, 3=Major, 4=Grand)
- `Actions`: `Launch()` for browser initialization
- `Games`: `FireKirin`, `OrionStars`, `Games.FortunePiggy`
- `Services`: `Dashboard` for logging
- `Monitoring`: `ErrorLog.Create()` for validation errors

**External:**
- Selenium WebDriver (ChromeDriver): Browser automation
- Figgle: ASCII art for version display
- System.Text.Json: Signal file serialization

## Data Collections

- **EV3NT**: Received signals and processing events
- **CR3D3N7IAL**: User credentials with jackpots and thresholds
- **ERR0R**: Validation errors and processing failures

## Platform Support

- **FireKirin**: Login/Logout, SpinSlots, QueryBalances
- **OrionStars**: Login/Logout, QueryBalances, FortunePiggy.Spin

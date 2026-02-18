# H4ND/

## Responsibility

H4ND is the automation execution agent that manages game platform interactions through browser automation. It orchestrates credential management, signal processing, and automated gameplay operations across supported platforms (FireKirin, OrionStars).

**Core Functions:**
- Signal-driven automation: Processes signals from MongoDB queue to trigger game spins
- Credential lifecycle: Locks, validates, updates, and unlocks user credentials
- Jackpot monitoring: Tracks 4-tier jackpot system (Grand/Major/Minor/Mini) and resets thresholds when jackpots pop
- Browser automation: Uses Selenium ChromeDriver to interact with game platforms
- Health monitoring: Logs validation errors and processing failures to ERR0R collection

## Design

**Key Patterns:**

1. **Signal Processing Loop**
   - Infinite while-loop with try/catch for resilience
   - Fetches next signal from queue (if `listenForSignals` is true)
   - Retrieves credentials via signal (House/Game/Username) or rounds-robin without signal

2. **Platform Abstraction**
   - Game-specific logic for FireKirin and OrionStars
   - Login/Logout actions per platform
   - Game spin handlers: `FireKirin.SpinSlots()`, `Games.FortunePiggy.Spin()`

3. **Jackpot Reset Detection**
   - Compares current jackpot values to stored values
   - Uses DPD (Double-Pointer-Detection) toggle pattern: two consecutive drops = jackpot pop
   - Calls `Thresholds.NewGrand()/NewMajor()/NewMinor()/NewMini()` to recalculate thresholds

4. **Validation-First Approach**
   - Extensive validation for balance/jackpot values (NaN, Infinity, negative)
   - `Credential.IsValid()` validates entities before upsert
   - Invalid data logged to ERR0R, processing continues (no auto-repair)

5. **Retry with Exponential Backoff**
   - `GetBalancesWithRetry()`: 3 network attempts with exponential delay (2s to 30s max)
   - Grand check: up to 40 retries with 500ms intervals
   - Extension failure detection via JavaScript execution

## Flow

```
Main Loop
├── Initialize (display header, MongoDB UoW)
├── Outer while (true) - Exception recovery
│   └── Inner while (true) - Signal processing
│       ├── Get signal (optional) → Get credential → Lock credential
│       ├── If signal: Login to platform (OrionStars)
│       │   └── Launch ChromeDriver (reuse)
│       ├── Check extension Grand value (JS execution)
│       │   └── Validate Grand > 0 (40 retries, 500ms)
│       ├── Query balances (GetBalancesWithRetry)
│       │   ├── 3 network attempts with exponential backoff
│       │   └── Validate Grand > 0 (40 retries)
│       ├── Validate raw values (NaN, Infinity, negative)
│       ├── If signal:
│       │   ├── Receive signal values (store to EV3NT via uow.Received)
│       │   ├── Spin game (FireKirin or FortunePiggy)
│       │   └── Acknowledge signal
│       │
│       ├── Update credential jackpots:
│       │   ├── Detect drops via DPD toggles
│       │   ├── Reset thresholds if jackpot popped
│       │   └── Clear signals for dropped priority
│       │
│       ├── Validate credential → Upsert to CRED3N7IAL
│       ├── Periodic health check (every 5 min) - query ERR0R for recent errors
│       └── Logout
│
└── Catch: Log exception, quit driver, sleep 5s, continue
```

**Jackpot Reset Detection Logic:**
```
If current < stored AND drop > 0.1:
    If DPD.Toggles.GrandPopped == true:
        It's a reset (pop already detected)
        Store new value
        Reset toggle to false
        Recalculate threshold
    Else:
        First drop detected
        Set toggle to true (wait for confirmation)
Else:
    Value increased or stable
    Store new value
```

## Integration

**Dependencies (from C0MMON):**
- `MongoUnitOfWork`: MongoDB operations (Signals, Credentials, Received, Errors, ProcessEvents)
- `Credential` entity: User credentials, jackpots, thresholds, DPD toggles
- `Signal` entity: Priority (1=Mini, 2=Minor, 3=Major, 4=Grand), house, game, username
- `Actions`: `Launch()` for browser initialization
- `Games`: `FireKirin`, `OrionStars`, `Games.FortunePiggy`
- `Services`: `Dashboard` for logging
- `Monitoring`: `ErrorLog.Create()` for validation errors

**External Dependencies:**
- Selenium WebDriver (ChromeDriver): Browser automation
- Figgle: ASCII art for version display
- System.Text.Json: Signal file serialization (`D:\S1GNAL.json`)

**Data Collections (MongoDB - P4NTH30N):**
- `EV3NT` → Received signals (via `uow.Received`)
- `CR3D3N7IAL` → User credentials (via `uow.Credentials`)
- `ERR0R` → Validation errors (via `uow.Errors`)
- `EV3NT` (ProcessEvents) → Processing alerts

**Platform Support:**
- **FireKirin**: Login/Logout, SpinSlots, QueryBalances
- **OrionStars**: Login/Logout, QueryBalances, FortunePiggy.Spin

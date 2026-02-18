# H4ND/

## Responsibility

H4ND is the automation execution agent ("The Hands") that manages game platform interactions through browser automation. It orchestrates credential management, signal processing, automated gameplay operations, jackpot monitoring with threshold resets, and health monitoring across supported platforms (FireKirin, OrionStars, Gold777).

**Core Functions:**
- **Signal-Driven Automation**: Processes signals from MongoDB queue to trigger game spins
- **Credential Lifecycle**: Locks, validates, updates, and unlocks user credentials atomically
- **Jackpot Monitoring**: Tracks 4-tier jackpot system (Grand/Major/Minor/Mini) and resets thresholds when jackpots pop
- **Browser Automation**: Uses Selenium ChromeDriver to interact with game platforms
- **Health Monitoring**: Logs validation errors and processing failures to ERR0R collection
- **DPD Toggle Tracking**: Double-drop detection pattern for reliable jackpot pop detection

## Design

**Architecture Pattern**: Resilient infinite loop with comprehensive validation

### Key Patterns

1. **Signal Processing Loop**
   - Infinite while-loop with try/catch for exception recovery
   - Fetches next signal from queue (if `listenForSignals` is true)
   - Retrieves credentials via signal (House/Game/Username) or round-robin without signal
   - Processes signal, spins game, acknowledges completion

2. **Credential Lifecycle**
   - **Lock**: Mark credential as in-use to prevent concurrent access
   - **Validate**: Check credential validity before processing
   - **Process**: Execute login, spin, logout sequence
   - **Unlock**: Release credential for next use
   - Atomic operations via MongoDB updates

3. **Platform Abstraction**
   - Game-specific logic for FireKirin, OrionStars, and Gold777
   - Login/Logout actions per platform via C0MMON.Actions
   - Game spin handlers: `FireKirin.SpinSlots()`, `Games.FortunePiggy.Spin()`

4. **Jackpot Reset Detection (DPD Pattern)**
   - Compares current jackpot values to stored values
   - **DPD (Double-Pointer-Detection) Toggle Pattern**: Two consecutive drops = jackpot pop
   - First drop: Set toggle to true (wait for confirmation)
   - Second consecutive drop > 0.1 threshold: Confirm pop, reset toggle, recalculate threshold
   - Calls `Thresholds.NewGrand()/NewMajor()/NewMinor()/NewMini()` to recalculate thresholds

5. **Validation-First Approach**
   - Extensive validation for balance/jackpot values (NaN, Infinity, negative)
   - `Credential.IsValid()` validates entities before upsert
   - Invalid data logged to ERR0R, processing continues (no auto-repair)

6. **Retry with Exponential Backoff**
   - `GetBalancesWithRetry()`: 3 network attempts with exponential delay (2s to 30s max)
   - Grand check: Up to 40 retries with 500ms intervals
   - Extension failure detection via JavaScript execution

## Flow

### Main Processing Loop
```
Initialize (display header, MongoDB UoW)
Outer while (true) - Exception recovery
└── Inner while (true) - Signal processing
    ├── Get signal (optional) → Get credential → Lock credential
    ├── If signal: Login to platform (OrionStars/FireKirin)
    │   └── Launch ChromeDriver (reuse if available)
    ├── Check extension Grand value (JS execution)
    │   └── Validate Grand > 0 (40 retries, 500ms interval)
    ├── GetBalancesWithRetry()
    │   ├── 3 network attempts with exponential backoff (2s-30s)
    │   └── Validate Grand > 0 (40 retries)
    ├── Validate raw values (NaN, Infinity, negative checks)
    ├── If signal:
    │   ├── Receive signal values (store to EV3NT via IReceiveSignals)
    │   ├── Spin game (FireKirin.SpinSlots or FortunePiggy.Spin)
    │   └── Acknowledge signal
    ├── Update credential jackpots:
    │   ├── Detect drops via DPD toggles (2 consecutive drops)
    │   ├── Reset thresholds if jackpot popped (NewGrand/NewMajor/etc)
    │   └── Clear signals for dropped priority
    ├── Validate credential → Upsert to CRED3N7IAL
    ├── Periodic health check (every 5 min) - query ERR0R collection
    └── Logout (FireKirin.Logout or OrionStars.Logout)
```

### Jackpot Reset Detection Logic
```
If current < stored AND drop > 0.1:
    If DPD.Toggles.GrandPopped == true:
        // Second drop - CONFIRMED POP
        Store new value
        Reset toggle to false
        Recalculate threshold (Thresholds.NewGrand())
        Log jackpot pop event
    Else:
        // First drop - WAIT FOR CONFIRMATION
        Set toggle to true (wait for second drop)
        Store current value
Else:
    // Value increased or stable
    Reset toggle to false (cancel any pending detection)
    Store new value
```

### Signal Processing Detail
```
Fetch Signal from Queue (if listenForSignals)
    ↓
Parse House, Game, Username from Signal
    ↓
Retrieve Credential from CRED3N7IAL
    ↓
Lock Credential (atomic update)
    ↓
Login to Platform (OrionStars/FireKirin)
    ↓
Query Current Jackpots
    ↓
Compare to Thresholds
    ↓
If Signal Priority Matches Jackpot:
    ├── Spin Game
    ├── Wait for Result
    └── Update Balance
    ↓
Acknowledge Signal (remove from queue)
    ↓
Unlock Credential
```

### Error Handling Flow
```
Exception Thrown
    ↓
Catch in Outer Loop
    ↓
Log Exception with Line Number (StackTrace)
    ↓
Quit ChromeDriver (cleanup)
    ↓
Sleep 5 seconds
    ↓
Continue Outer Loop (retry)
```

## Integration

### Dependencies (from C0MMON)
- **MongoUnitOfWork**: MongoDB operations (Signals, Credentials, Received, Errors, ProcessEvents)
- **Credential Entity**: User credentials, jackpots, thresholds, DPD toggles
- **Signal Entity**: Priority (1=Mini, 2=Minor, 3=Major, 4=Grand), house, game, username
- **Actions**: `Launch()` for browser initialization, `Login()`, `Logout()`
- **Games**: `FireKirin`, `OrionStars`, `Games.FortunePiggy`
- **Services**: `Dashboard` for logging
- **Monitoring**: `ErrorLog.Create()` for validation errors
- **RUL3S**: Chrome extension for resource overrides

### External Dependencies
- **Selenium WebDriver** (ChromeDriver): Browser automation
- **Figgle**: ASCII art for version display
- **System.Text.Json**: Signal file serialization (`D:\S1GNAL.json`)
- **Chrome**: Browser with RUL3S extension

### Data Collections (MongoDB - P4NTH30N)
- `EV3NT` → Received signals (via `uow.Received`)
- `CR3D3N7IAL` → User credentials (via `uow.Credentials`)
- `ERR0R` → Validation errors (via `uow.Errors`)
- `EV3NT` (ProcessEvents) → Processing alerts

### Interface Contracts
```
IMongoUnitOfWork      : Data access coordinator
IReceiveSignals       : Signal processing pipeline
IStoreEvents          : Event logging
IStoreErrors          : Error logging
ICredential           : User credential operations
ISignal               : Signal entity operations
```

### Platform Support
- **FireKirin**: Login/Logout, SpinSlots, QueryBalances
- **OrionStars**: Login/Logout, QueryBalances, FortunePiggy.Spin
- **Gold777**: Supported via FortunePiggy game loader
- **FortunePiggy**: LoadSuccessfully + Spin for OrionStars platform

## Key Components

### Main Entry Point
- **H4ND.cs**: Main entry point with signal-driven processing loop

### Platform Actions
- **Login**: Authenticate to platform (platform-specific)
- **Logout**: Clean session termination
- **Launch**: Initialize ChromeDriver with RUL3S extension
- **Overwrite**: Resource override management

### Game Handlers
- **FireKirin.SpinSlots()**: FireKirin slot game automation
- **FortunePiggy.Spin()**: Fortune Piggy game automation
- **QueryBalances()**: Retrieve current jackpot values

## Configuration

### Retry Configuration
```csharp
// Network Retries
MaxRetries: 3
BaseDelay: 2000ms (2 seconds)
MaxDelay: 30000ms (30 seconds)
BackoffStrategy: Exponential with jitter

// Grand Value Validation
GrandCheckRetries: 40
GrandCheckInterval: 500ms
```

### Signal File
- **Location**: `D:\S1GNAL.json`
- **Purpose**: Inter-process communication with W4TCHD0G
- **Format**: JSON with boolean flag

### DPD Toggle Threshold
- **Drop Threshold**: 0.1 (10% drop)
- **Confirmation**: 2 consecutive drops required
- **Reset**: Automatic threshold recalculation on confirmed pop

## Critical Notes

### Validation Requirements
- All jackpot values validated for NaN, Infinity, negative
- All balance values validated before storage
- Credentials validated via `IsValid()` before upsert
- Validation failures logged to ERR0R collection

### Thread Safety
- Credentials locked during processing (atomic MongoDB updates)
- ChromeDriver reused across credentials when possible
- Signal queue prevents duplicate processing

### Error Recovery
- Outer while-loop catches all exceptions
- ChromeDriver always cleaned up on error
- 5-second sleep before retry
- Line number logging for debugging

### ChromeDriver Management
- Single instance reused across credentials
- Proper disposal on errors
- Headless/visible mode configurable
- RUL3S extension automatically loaded

## Testing

Integration with UNI7T35T test suite:
- Signal processing validation
- DPD toggle behavior tests
- Retry logic tests
- Validation error handling

## Recent Additions (This Session)

**Integration with W4TCHD0G Safety System**
- Reports spends to ISafetyMonitor for limit tracking
- Respects kill switch commands

**Enhanced Error Logging**
- Line number extraction from StackTrace
- Detailed context in error messages

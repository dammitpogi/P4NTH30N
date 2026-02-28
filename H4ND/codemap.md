# H4ND/
UpdateOn: 2026-02-23T12:02 AM

## Responsibility

H4ND is the automation execution agent ("The Hands") that manages game platform interactions through **Chrome DevTools Protocol (CDP)**. It orchestrates credential management, signal processing, automated gameplay operations, jackpot monitoring with threshold resets, and health monitoring across supported platforms (FireKirin, OrionStars, Gold777).

**Core Functions:**
- **Signal-Driven Automation**: Processes signals from MongoDB queue to trigger game spins
- **Credential Lifecycle**: Locks, validates, updates, and unlocks user credentials atomically
- **Jackpot Monitoring**: Tracks 4-tier jackpot system (Grand/Major/Minor/Mini) and resets thresholds when jackpots pop
- **CDP Browser Automation**: Uses Chrome DevTools Protocol for reliable browser interaction (replaces Selenium)
- **Health Monitoring**: CDP connectivity validation and ERR0R collection logging
- **Operational Monitoring**: Spin metrics collection with HTTP health endpoint (port 9280)
- **DPD Toggle Tracking**: Double-drop detection pattern for reliable jackpot pop detection

## Design

**Architecture Pattern**: CDP-first resilient automation with comprehensive validation

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

3. **CDP-First Architecture**
   - Chrome DevTools Protocol for all browser interactions
   - CSS selector-based element interaction (no hardcoded coordinates)
   - WebSocket communication for reliable browser control
   - Configurable timeouts and retry logic

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

### VM Deployment Architecture (2026-02-19)

**H4ND VM Deployment Pattern**:
- **VM**: H4NDv2-Production (Windows 11, 192.168.56.10)
- **Host**: Chrome CDP (192.168.56.1:9222) + MongoDB (192.168.56.1:27017)
- **Network**: Hyper-V H4ND-Switch (192.168.56.0/24) with NAT
- **Chrome**: Runs on host in incognito mode, **no extension loaded**
- **Jackpot Reading**: Direct JavaScript evaluation via CDP (reads from page, not extension)

**Key Configuration**:
```bash
# MongoDB connection string (VM side)
mongodb://192.168.56.1:27017/?directConnection=true

# Chrome startup (host side)
chrome.exe --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0 --incognito

# Port proxy (host side)
netsh interface portproxy add v4tov4 listenaddress=192.168.56.1 listenport=9222 connectaddress=127.0.0.1 connectport=9222
```

**Infrastructure Fixes Applied**:
- MongoDB `?directConnection=true` prevents replica set redirect to localhost
- CDP WebSocket URL rewriting (localhost→HostIp) for remote connections
- Command ID matching to handle CDP event message interleaving
- Non-single-file publish for correct `AppContext.BaseDirectory`

## Flow

### Main Processing Loop
```
Initialize (display header, MongoDB UoW)
├── CDP Health Check (pre-flight validation)
│   ├── HTTP /json/version check
│   ├── WebSocket handshake validation
│   ├── Round-trip latency test (eval 1+1)
│   └── Login flow simulation
├── Initialize SpinMetrics + SpinHealthEndpoint (port 9280)
└── Outer while (true) - Exception recovery
    └── Inner while (true) - Signal processing
        ├── Get signal (optional) → Get credential → Lock credential
        ├── If signal: Login to platform via CDP (OrionStars, FireKirin)
        │   └── Initialize CdpClient (reuse if available)
        ├── Check extension Grand value via CDP: window.parent.Grand
        │   └── Validate Grand > 0 (40 retries, 500ms interval)
        ├── GetBalancesWithRetry() (unchanged)
        │   ├── 3 network attempts with exponential backoff (2s-30s)
        │   └── Validate Grand > 0 (40 retries)
        ├── Validate raw values (NaN, Infinity, negative checks)
        ├── If signal:
        │   ├── Map Signal → VisionCommand
        │   ├── Publish to InMemoryEventBus
        │   ├── Execute spin via SpinExecution (CDP + metrics)
        │   └── Acknowledge signal
        ├── Update credential jackpots:
        │   ├── Detect drops via DPD toggles (2 consecutive drops)
        │   ├── Reset thresholds if jackpot popped (NewGrand/NewMajor/etc)
        │   └── Clear signals for dropped priority
        ├── Validate credential → Upsert to CRED3N7IAL
        ├── Periodic health check (every 5 min) - query ERR0R collection
        ├── Periodic metrics summary (every 10 min) - console + HTTP endpoint
        └── Logout via CDP (CdpGameActions.Logout*)
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
Login to Platform (OrionStars/FireKirin) via CDP
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
Dispose CdpClient (cleanup)
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
- **Infrastructure/Cdp**: `ICdpClient`, `CdpClient`, `CdpConfig` for browser automation
- **Infrastructure/EventBus**: `InMemoryEventBus` for command publishing
- **Infrastructure/Resilience**: `CircuitBreaker` for fault tolerance
- **Games**: `FireKirin`, `OrionStars` (now CDP-based)
- **Services**: `Dashboard` for logging
- **Monitoring**: `ErrorLog.Create()` for validation errors

### H4ND Infrastructure Components
- **CdpHealthCheck**: Pre-flight CDP connectivity validation
- **CdpGameActions**: CDP-based login/logout/spin operations
- **SpinExecution**: Signal-to-spin pipeline with metrics
- **SpinMetrics**: Operational monitoring and statistics
- **SpinHealthEndpoint**: HTTP health endpoint (port 9280)
- **CommandPipeline**: Middleware-based command processing

### External Dependencies
- **Chrome DevTools Protocol**: Browser automation (replaces Selenium)
- **Figgle**: ASCII art for version display
- **System.Text.Json**: Signal file serialization
- **Microsoft.Extensions.Configuration**: appsettings.json loading

### Data Collections (MongoDB - P4NTHE0N)
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
ICdpClient            : Chrome DevTools Protocol client
```

### Platform Support
- **FireKirin**: CDP-based Login/Logout, Spin, QueryBalances via CSS selectors
- **OrionStars**: CDP-based Login/Logout, Spin, QueryBalances via CSS selectors
- **Gold777**: Supported via FortunePiggy game loader (CDP-compatible)
- **FortunePiggy**: LoadSuccessfully + Spin for OrionStars platform (CDP-compatible)

## Key Components

### Main Entry Point
- **H4ND.cs**: Main entry point with signal-driven processing loop

### Infrastructure Components
- **CdpHealthCheck.cs**: Pre-flight CDP connectivity validation
- **CdpGameActions.cs**: CDP-based login/logout/spin operations
- **SpinExecution.cs**: Signal-to-spin pipeline with metrics tracking
- **SpinMetrics.cs**: Operational monitoring (success rate, latency, balance changes)
- **SpinHealthEndpoint.cs**: HTTP health endpoint (port 9280)
- **CommandPipeline.cs**: Middleware-based command processing
- **VisionCommandListener.cs**: FourEyes integration command listener

### Platform Actions (CDP-Based)
- **LoginFireKirinAsync**: Authenticate to FireKirin via CDP selectors
- **LoginOrionStarsAsync**: Authenticate to OrionStars via CDP selectors
- **LogoutFireKirinAsync**: Clean session termination via CDP
- **LogoutOrionStarsAsync**: Clean session termination via CDP
- **SpinFireKirinAsync**: Execute spin via CDP selectors
- **SpinOrionStarsAsync**: Execute spin via CDP selectors

### Game Handlers
- **FireKirin.SpinSlots()**: FireKirin slot game automation
- **FortunePiggy.Spin()**: Fortune Piggy game automation
- **QueryBalances()**: Retrieve current jackpot values via WebSocket

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

### CDP Configuration (appsettings.json)
```json
{
  "P4NTHE0N:H4ND:Cdp": {
    "HostIp": "192.168.56.1",
    "Port": 9222,
    "TimeoutMs": 30000,
    "RetryAttempts": 3
  }
}
```

### DPD Toggle Threshold
- **Drop Threshold**: 0.1 (10% drop)
- **Confirmation**: 2 consecutive drops required
- **Reset**: Automatic threshold recalculation on confirmed pop

## Critical Notes

### CDP-First Migration (2026-02-19)
- **Replaced**: Selenium WebDriver with Chrome DevTools Protocol
- **New**: CSS selector-based element interaction (no hardcoded pixels)
- **Improved**: WebSocket communication for reliable browser control
- **Maintained**: Direct WebSocket balance queries (unchanged for performance)

### VM Deployment Notes
- Chrome runs on **host** (192.168.56.1:9222), not VM
- H4ND VM (192.168.56.10) connects to host Chrome via port proxy
- MongoDB on host requires `?directConnection=true`
- No extension loaded - jackpot values read directly from page JavaScript
- Extension-free operation requires direct page variable access

### Validation Requirements
- All jackpot values validated for NaN, Infinity, negative
- All balance values validated before storage
- Credentials validated via `IsValid()` before upsert
- Validation failures logged to ERR0R collection

### Thread Safety
- Credentials locked during processing (atomic MongoDB updates)
- CdpClient reused across credentials when possible
- Signal queue prevents duplicate processing

### Error Recovery
- Outer while-loop catches all exceptions
- CdpClient always disposed on error
- 5-second sleep before retry
- Line number logging for debugging

## Testing

Integration with UNI7T35T test suite:
- Signal processing validation
- DPD toggle behavior tests
- Retry logic tests
- Validation error handling
- CDP connectivity tests

## Recent Updates (2026-02-19)

### CDP Migration Complete
- Replaced Selenium WebDriver with Chrome DevTools Protocol
- CSS selector-based element interaction (no hardcoded coordinates)
- WebSocket communication for reliable browser control
- Configurable timeouts and retry logic

### Signal Pipeline Integration
- Signal → VisionCommand mapping for FourEyes coordination
- InMemoryEventBus for decoupled command processing
- SpinExecution handles CDP spin operations with metrics

### Operational Monitoring
- SpinMetrics tracks success rate, latency, balance changes
- HTTP health endpoint on port 9280 (GET /health)
- Periodic console summaries every 10 minutes

### VM Deployment Architecture
- H4ND deployed to Hyper-V VM (H4NDv2-Production, 192.168.56.10)
- Chrome runs on host (192.168.56.1:9222) in incognito mode
- MongoDB on host (192.168.56.1:27017) with directConnection=true
- Port proxy forwards VM CDP connections to host Chrome
- Extension-free operation: jackpot values read directly from page JavaScript

### Infrastructure Components
- **CdpHealthCheck**: Validates HTTP, WebSocket, round-trip latency before operations
- **MongoConnectionOptions**: Supports mongodb.uri file + env var override
- **CdpClient**: WebSocket URL rewriting for remote connections (localhost→HostIp)
- **Command Pipeline**: Logging, validation, idempotency, circuit breaker middleware
- **CdpLifecycleConfig.cs**: CDP lifecycle configuration
- **CdpLifecycleManager.cs**: CDP lifecycle management, (connection pooling session reuse)

### New Monitoring Components (2026-02-20)
- **Monitoring/AlertNotificationDispatcher.cs**: Alert notification dispatching
- **Monitoring/AlertSeverity.cs**: Alert severity levels
- **Monitoring/BurnInAlertConfig.cs**: Burn-in alert configuration
- **Monitoring/BurnInAlertEvaluator.cs**: Burn-in alert evaluation
- **Monitoring/BurnInCompletionAnalyzer.cs**: Burn-in completion analysis
- **Monitoring/BurnInDashboardServer.cs**: Burn-in dashboard HTTP server
- **Monitoring/BurnInHaltDiagnostics.cs**: Burn-in halt diagnostics
- **Monitoring/BurnInMonitor.cs**: Burn-in monitoring
- **Monitoring/BurnInProgressCalculator.cs**: Burn-in progress calculation
- **Monitoring/DecisionPromoter.cs**: Decision promotion logic
- **Monitoring/Models/BurnInStatus.cs**: Burn-in status model
- **Monitoring/OperationalConfig.cs**: Operational configuration

### Recent Modifications (2026-02-20)
- **H4ND.cs**: Added RunMode.GenerateSignals support, ARCH-055, TECH-H4ND-001, TECH-FE-015, TECH-JP-001, TECH-JP-002, OPS-JP-001 documentation
- **UnifiedEntryPoint.cs**: ParseMode support for different run modes

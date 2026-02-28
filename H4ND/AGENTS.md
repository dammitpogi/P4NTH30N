# H4ND

## Responsibility

H4ND is the automation execution agent that manages game platform interactions through Chrome DevTools Protocol (CDP). It orchestrates credential management, signal processing, and automated gameplay operations across supported platforms (FireKirin, OrionStars) with operational monitoring and health checks.

## When Working Here

- **Signal-driven design**: Main loop processes signals from MongoDB queue
- **CDP-first architecture**: Chrome DevTools Protocol replaces Selenium for browser automation
- **Resilient architecture**: Infinite while-loop with try/catch for exception recovery
- **Credential lifecycle**: Lock → Validate → Process → Unlock
- **Jackpot monitoring**: Track 4-tier system (Grand/Major/Minor/Mini)
- **Validation first**: Extensive validation before any operations (NaN, Infinity, negative checks)
- **Health checks**: CDP connectivity validation at startup
- **Operational monitoring**: Spin metrics collection and HTTP health endpoint
- **Vision-first UI control**: Use multimodal state checks before and after clicks to prevent blind navigation loops
- **Decision recall required**: Query prior decisions before changing click-path or selector logic

## Core Functions

- **Signal-driven automation**: Processes signals from MongoDB queue to trigger game spins
- **Credential lifecycle**: Locks, validates, updates, and unlocks user credentials atomically
- **Jackpot monitoring**: Tracks 4-tier jackpot system and resets thresholds when jackpots pop
- **CDP browser automation**: Uses Chrome DevTools Protocol for reliable browser interaction
- **Health monitoring**: CDP connectivity validation and ERR0R collection logging
- **Operational monitoring**: Spin metrics collection with HTTP health endpoint

## Main Processing Loop

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

## Jackpot Detection Logic

**DPD (Double-Pointer-Detection) Pattern:**
- First drop detected: Set toggle to true (wait for confirmation)
- Second consecutive drop: Confirm jackpot pop, reset toggle, recalculate threshold
- Two consecutive drops required for confirmation (> 0.1 threshold)

## Key Patterns

1. **Signal Processing Loop**: Infinite while-loop with try/catch resilience
2. **CDP-First Architecture**: Chrome DevTools Protocol for all browser interactions
3. **Platform Abstraction**: Game-specific logic for FireKirin and OrionStars via CDP
4. **Jackpot Reset Detection**: DPD toggle pattern for reliable detection (2 consecutive drops > 0.1)
5. **Validation-First Approach**: Extensive validation, invalid data logged to ERR0R (no auto-repair)
6. **Retry with Exponential Backoff**: 3 network attempts (2s base, 30s max + jitter), 40 retries for Grand check
7. **Event Bus Integration**: Signal → VisionCommand → EventBus → SpinExecution pipeline
8. **Health Monitoring**: CDP pre-flight checks + periodic ERR0R collection queries
9. **Operational Monitoring**: Spin metrics with HTTP endpoint (port 9280)

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: MongoDB operations
- `Credential` entity: User credentials, jackpots, thresholds, DPD toggles
- `Signal` entity: Priority (1=Mini, 2=Minor, 3=Major, 4=Grand)
- `VisionCommand` entity: FourEyes integration commands
- `Infrastructure/Cdp`: `ICdpClient`, `CdpClient`, `CdpConfig` for browser automation
- `Infrastructure/EventBus`: `InMemoryEventBus` for command publishing
- `Infrastructure/Resilience`: `CircuitBreaker` for fault tolerance
- `Games`: `FireKirin`, `OrionStars` (now CDP-based)
- `Services`: `Dashboard` for logging
- `Monitoring`: `ErrorLog.Create()` for validation errors

**H4ND Infrastructure:**
- `CdpHealthCheck`: Pre-flight CDP connectivity validation
- `CdpGameActions`: CDP-based login/logout/spin operations
- `SpinExecution`: Signal-to-spin pipeline with metrics
- `SpinMetrics`: Operational monitoring and statistics
- `SpinHealthEndpoint`: HTTP health endpoint (port 9280)
- `CommandPipeline`: Middleware-based command processing

**External:**
- Chrome DevTools Protocol: Browser automation (replaces Selenium)
- Figgle: ASCII art for version display
- System.Text.Json: Signal file serialization
- Microsoft.Extensions.Configuration: appsettings.json loading

## Data Collections

- **EV3NT**: Received signals and processing events
- **CR3D3N7IAL**: User credentials with jackpots and thresholds
- **ERR0R**: Validation errors and processing failures
- **SIGN4L**: Signal requests (via IRepoSignals)

## Platform Support

- **FireKirin**: CDP-based Login/Logout, Spin, QueryBalances via CSS selectors
- **OrionStars**: CDP-based Login/Logout, Spin, QueryBalances via CSS selectors
- **Gold777**: Supported via FortunePiggy game loader (CDP-compatible)
- **FortunePiggy**: LoadSuccessfully + Spin for OrionStars platform (CDP-compatible)

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

### VM Deployment Architecture (2026-02-19)
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
- **CdpLifecycleConfig**: CDP lifecycle configuration
- **CdpLifecycleManager**: CDP lifecycle management (connection pooling, session reuse)

### New Components (2026-02-20)
- **Parallel/ParallelH4NDEngine.cs**: Parallel execution engine
- **Parallel/ParallelMetrics.cs**: Metrics tracking for parallel operations
- **Parallel/ParallelSpinWorker.cs**: Worker for parallel spin execution
- **Parallel/SignalClaimResult.cs**: Result container for claimed signals
- **Parallel/SignalDistributor.cs**: Distributes signals across workers
- **Parallel/SignalWorkItem.cs**: Work item for signal processing
- **Parallel/WorkerPool.cs**: Worker pool management
- **Services/JackpotReader.cs**: Jackpot reading via CDP
- **Services/SessionPool.cs**: Session pool management
- **Services/SessionRenewalService.cs**: Automatic session renewal
- **Services/SignalGenerator.cs**: Signal generation logic
- **Services/SystemHealthReport.cs**: System health reporting
- **Services/BurnInController.cs**: Burn-in controller
- **Services/FirstSpinController.cs**: First spin controller
- **Vision/VisionCommandHandler.cs**: Vision command handler
- **Vision/VisionCommandPublisher.cs**: Vision command publisher
- **Vision/VisionExecutionTracker.cs**: Vision execution tracking
- **Agents/ExecutorAgent.cs**: Execution agent
- **Agents/MonitorAgent.cs**: Monitoring agent
- **EntryPoint/UnifiedEntryPoint.cs**: Unified entry point
- **Infrastructure/ChromeSessionManager.cs**: Chrome session management
- **Infrastructure/VmHealthMonitor.cs**: VM health monitoring
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

(End of file)

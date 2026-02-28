# Repository Atlas: P4NTHE0N Platform
UpdateOn: 2026-02-23T12:02 AM

## Project Responsibility
Multi-agent automation platform for online casino game portals (FireKirin and OrionStars). Event-driven system with two primary agents (H0UND polling+analytics and H4ND automation) communicating asynchronously via MongoDB to discover jackpots, generate signals, and automate gameplay. Includes comprehensive W4TCHD0G vision system, safety monitoring, and enterprise-grade infrastructure.

## System Entry Points
- `H4ND/`: Automation agent (H4ND.Main → H4ND())
- `H0UND/`: Polling + analytics agent (H0UND.Main → H0UND())
- `W4TCHD0G/`: Vision system with OBS integration, safety monitoring, and win detection
- `T00L5ET/`: Manual utilities for database operations and one-off tasks
- `UNI7T35T/`: Testing platform with 27 passing tests, including 16 integration tests
- `C0MMON/`: Shared library for all components with LLM, RAG, caching, and security
- `P4NTHE0N.slnx`: .NET solution file
- `HunterConfig.json`: Configuration for prize tiers, rate limits, watchdog

## Repository Directory Map

| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `C0MMON/` | Core shared library with LLM client, RAG system, caching, security, and MongoDB persistence. Repository pattern, Unit of Work, validation infrastructure. | [View Map](C0MMON/codemap.md) |
| `H4ND/` | Automation agent with signal-driven gameplay, jackpot monitoring, and browser automation via CDP (Chrome DevTools Protocol). | [View Map](H4ND/codemap.md) |
| `H0UND/` | Polling + analytics agent with DPD forecasting, circuit breakers, and adaptive throttling. | [View Map](H0UND/codemap.md) |
| `W4TCHD0G/` | Vision system with OBS integration, safety monitoring (spend/loss limits, kill switch), win detection (balance+OCR), and health monitoring. | [View Map](W4TCHD0G/codemap.md) |
| `T00L5ET/` | Manual tools including MockFactory for test data, DPD migration utilities, and database operations. | [View Map](T00L5ET/codemap.md) |
| `DECISION_077/` | Navigation Workflow session recordings for systematic Canvas typing investigation. | [View Map](DECISION_077/codemap.md) |
| `UNI7T35T/` | Test suite with 27 passing tests including 16 integration tests for FrameBuffer, ScreenMapper, ActionQueue, DecisionEngine, SafetyMonitor, WinDetector, InputAction, and encryption/forecasting tests. | [View Map](UNI7T35T/codemap.md) |
| `RUL3S/` | Resource override system with Chrome extension for JavaScript injection, header manipulation, and asset overrides. | [View Map](RUL3S/codemap.md) |
| `docs/` | Comprehensive documentation: architecture specs, migration guides, modernization roadmap, runbooks, ADRs, and security documentation. | [View Map](docs/codemap.md) |
| `PROF3T/` | Administrative console for maintenance, diagnostics, and analytics. | [View Map](PROF3T/codemap.md) |
| `CLEANUP/` | Data cleanup utilities and MongoDB corruption prevention services. | [View Map](CLEANUP/codemap.md) |
| `MONITOR/` | System monitoring and health check services. | [View Map](MONITOR/codemap.md) |
| `publish/` | Published binaries and test utilities. | — |
| `.github/` | CI/CD workflows: PR validation and release build automation. | — |

## Architecture Overview

### Multi-Agent System
```
┌─────────────┐     MongoDB Collections     ┌─────────────┐
│  H0UND      │ ◄───── CRED3N7IAL ────────► │    H4ND     │
│ (Analytics) │ ◄───── SIGN4L ────────────► │ (Automation)│
│   "Brain"   │ ◄───── EV3NT ─────────────► │   "Hands"   │
└─────────────┘                             └─────────────┘
       ▲                                           ▲
       │ Uses for data access                      │ Uses for automation
       │                                           │
┌─────────────┐                             ┌─────────────┐
│   C0MMON    │                             │   RUL3S     │
│   Library   │                             │   (Chrome   │
│             │                             │  Extension) │
└─────────────┘                             └─────────────┘
       │                                           │
       ▼                                           ▼
┌─────────────────────────────────────────────────────┐
│  W4TCHD0G (Vision & Safety)                         │
│  - OBS WebSocket integration                          │
│  - Safety monitoring (spend limits, kill switch)      │
│  - Win detection (balance + OCR)                      │
│  - Health monitoring                                  │
└─────────────────────────────────────────────────────┘
```

### Key Technologies
- **Language**: C# .NET 10.0
- **Database**: MongoDB (primary), EF Core (analytics)
- **UI**: Spectre.Console (Dashboard)
- **Automation**: Chrome DevTools Protocol (CDP), HTTP/WebSocket APIs (Selenium deprecated)
- **Vision**: OBS WebSocket, computer vision, OCR
- **ML**: LM Studio local inference, LLM client
- **Browser**: Chrome with CDP remote debugging (incognito, no extension)
- **Architecture**: Event-driven, asynchronous, circuit breaker pattern

## Dependency Flow

### Core Dependencies
```
C0MMON (Shared Library)
├── Interfaces (IReceiveSignals, IStoreEvents, IStoreErrors, IRepoCredentials, etc.)
│   └── Defines contracts for data access and agent coordination
├── Infrastructure/
│   ├── Persistence/ - MongoDB implementation
│   │   ├── MongoDatabaseProvider.cs - Connection management
│   │   ├── MongoUnitOfWork.cs - Unit of Work pattern
│   │   ├── Repositories.cs - Collection repositories
│   │   └── ValidatedMongoRepository.cs - Base repository with validation
│   ├── Caching/ - CacheService for distributed caching
│   ├── Configuration/ - P4NTHE0NOptions, SecretsProvider, validation
│   ├── Monitoring/ - HealthChecks, MetricsService
│   └── LLM/ - ILlmClient, LlmClient for external LLM APIs
├── RAG/ - Retrieval-Augmented Generation system
│   ├── IContextBuilder, ContextBuilder - Context assembly
│   ├── IEmbeddingService, EmbeddingService - Vector embeddings
│   ├── IVectorStore, FaissVectorStore - Vector storage
│   └── IHybridSearch, HybridSearch - Semantic + keyword search
├── Security/ - Encryption and key management
│   ├── IEncryptionService, EncryptionService - AES-256 encryption
│   ├── IKeyManagement, KeyManagement - Key lifecycle
│   └── EncryptedValue - Encrypted value wrapper
├── Actions/ - Automation primitives (Login, Launch, Logout, Overwrite)
├── Games/ - Platform parsers (FireKirin, OrionStars, etc.)
├── Entities/ - Domain entities (Credential, Jackpot, Signal, etc.)
├── Support/ - Value objects (DPD, Jackpots, Thresholds, GameSettings)
├── Services/ - Dashboard (monitoring UI)
├── EF/ - Entity Framework (analytics)
├── Monitoring/ - Health monitoring
└── Utilities/ - SafeDateTime (overflow-safe arithmetic)

All other projects reference C0MMON as their primary dependency
```

### Agent Dependencies and Coordination
```
H0UND (Polling + Analytics - "The Brain")
├── References: C0MMON
├── Depends on: MongoDB (credentials, signals, jackpots collections)
├── Uses: IMongoUnitOfWork for data persistence
├── Features: CircuitBreaker, SystemDegradationManager, HealthCheckService
├── Produces: SIGN4L records written to EV3NT collection
└── Model: DPD forecasting with Thresholds validation

H4ND (Automation - "The Hands")
├── References: C0MMON
├── Depends on: MongoDB (signals from EV3NT, credentials from CRED3N7IAL)
├── Consumes: SIGN4L records (read via Signals repository)
├── Produces: Event logs (written via IStoreEvents)
├── CDP Infrastructure: CdpClient, CdpHealthCheck, CdpGameActions
├── VM Deployment: H4NDv2-Production VM (192.168.56.10) → Host Chrome (192.168.56.1:9222)
├── Navigation Workflow (DECISION_077): Session recording and Canvas typing investigation
│   ├── tools/recorder/ - TypeScript CLI for screenshot-guided navigation
│   │   ├── recorder.ts - Main CLI with --init, --step, --diag, --login
│   │   ├── session-manager.ts - Session initialization, dual logging (NDJSON + Markdown)
│   │   ├── t00l5et-bridge.ts - T00L5ET execution and output parsing
│   │   ├── screenshot-processor.ts - Phase analysis and coordinate lookup
│   │   └── types.ts - TypeScript definitions for session recording
│   └── config/firekirin/phase-definitions.json - UI element coordinates per platform
└── Parallel Execution (DECISION_047): Worker pool for concurrent signal processing
    ├── Parallel/SignalDistributor.cs - Atomic signal claiming from MongoDB
    ├── Parallel/ParallelSpinWorker.cs - Per-worker signal lifecycle
    ├── Parallel/WorkerPool.cs - Channel-based worker orchestration
    └── Parallel/UnifiedEntryPoint.cs - Router for sequential/parallel modes

W4TCHD0G (Vision + Safety System)
├── References: C0MMON
├── OBS Integration: ResilientOBSClient, OBS WebSocket protocol
├── Safety: ISafetyMonitor, SafetyMonitor (spend/loss limits, kill switch)
├── Win Detection: WinDetector, JackpotAlertService (balance + OCR)
├── Vision: VisionProcessor, IJackpotDetector, IStateClassifier, IButtonDetector
├── Streaming: FrameBuffer, RTMPStreamReceiver, StreamHealthMonitor
├── Agent: FourEyesAgent, DecisionEngine, SignalPoller
└── Input: ActionQueue, ScreenMapper, InputAction, SynergyClient
```

### Project Dependency Graph (Topological Order)
1. **C0MMON** (base layer - no dependencies on other projects)
2. **H4ND**, **H0UND**, **W4TCHD0G** (depend on C0MMON)
3. **T00L5ET**, **UNI7T35T**, **PROF3T** (utility and test projects)
4. **CLEANUP**, **MONITOR** (specialized maintenance tools)

### External Dependencies
- **MongoDB**: Primary data store (database: `P4NTHE0N`)
- **Collections**: `CRED3N7IAL`, `EV3NT`, `ERR0R`, `JACKPOTS`, `H0U53`
- **NuGet Packages**:
  - `MongoDB.Driver` (3.6.0) - Direct MongoDB access
  - `MongoDB.EntityFrameworkCore` (9.0.4) - EF Core integration
  - `Selenium.WebDriver` (4.40.0) - Browser automation (deprecated, use CDP)
  - `Spectre.Console` (0.54.0) - Dashboard UI
  - `Microsoft.EntityFrameworkCore` (9.0.12) - Analytics data access
  - `H.InputSimulator` (1.5.0) - Input simulation
- **Environment Variables**:
  - `MONGODB_CONNECTION_STRING` (required)
  - `MONGODB_DATABASE_NAME` (optional, default: P4NTHE0N)
  - `P4NTHE0N_MONGODB_URI` (optional, overrides connection string)
- **Browser**: Chrome with CDP remote debugging (incognito, no extension)

### Data Flow and MongoDB Collections
```
┌─────────────────────────────────────────────────────────────┐
│                      MongoDB Database (P4NTHE0N)            │
├─────────────────┬─────────────────┬─────────────────────────┤
│ CRED3N7IAL      │ EV3NT           │ ERR0R                   │
│ - username      │ - agent         │ - entity                │
│ - Password      │ - action        │ - field                 │
│ - Thresholds    │ - timestamp     │ - error                 │
│ - settings      │ - metadata      │ - user                  │
│                 │                 │ - stack trace           │
├─────────────────┼─────────────────┼─────────────────────────┤
│ JACKPOTS        │ H0U53           │ SIGN4L (derived)        │
│ - Grand         │ - Platform      │ - Priority 1-4          │
│ - Major         │ - URL           │ - House/Game/User       │
│ - Minor         │ - configuration │ - Timestamp             │
│ - Mini          │                 │                         │
└─────────────────┴─────────────────┴─────────────────────────┘

Flow:
1. H0UND reads CRED3N7IAL, updates telemetry, writes JACKPOTS
2. H0UND analyzes thresholds and writes SIGN4L records
3. H4ND reads signals and credentials from CRED3N7IAL
4. H4ND performs automation and writes logs to EV3NT
5. Validation failures logged to ERR0R via IStoreErrors
6. W4TCHD0G monitors streams, detects wins, enforces safety limits
```

### Interface Contracts (Key Abstractions)
```
IRepoCredentials     : CRUD operations on user credentials
IRepoSignals         : Signal ingestion and retrieval (WriteOnceReadMany)
IRepoJackpots        : Jackpot threshold and historical data
IRepoHouses          : Platform configuration and endpoints
IReceiveSignals      : Signal processing pipeline (ReceivedRepository)
IStoreEvents         : Event logging (ProcessEventRepository)
IStoreErrors         : Error logging (ErrorLogRepository) - writes to ERR0R
ISafetyMonitor       : Spend/loss limits, kill switch, circuit breaker
IJackpotDetector     : Vision-based jackpot detection
IStateClassifier     : Game state classification via ML
IButtonDetector      : UI button detection for automation

IMongoUnitOfWork     : Aggregates all repositories, transaction boundary
IMongoDatabaseProvider : Factory for database connections (FromEnvironment())
```

### Safety and Monitoring (W4TCHD0G)
```
SafetyMonitor (ISafetyMonitor)
├── Daily Spend Limits - configurable per-credential
├── Loss Circuit Breaker - stops after N consecutive losses
├── Kill Switch - immediate halt with override code
└── Integration with H4ND for real-time spend tracking

WinDetector + JackpotAlertService
├── Balance Detection - monitors account balance changes
├── OCR Detection - vision-based jackpot recognition
├── Alert Channels - console, file, webhook notifications
└── FrameTimestamp correlation for latency metrics

HealthMonitor
├── Process health checks
├── Stream health monitoring
├── Error rate monitoring (ERR0R collection queries)
└── Metrics aggregation via MetricsService
```

### Testing Infrastructure (UNI7T35T)
```
27 Total Tests (All Passing)
├── PipelineIntegrationTests (16 tests)
│   ├── FrameBuffer tests
│   ├── ScreenMapper tests
│   ├── ActionQueue tests
│   ├── DecisionEngine tests
│   ├── SafetyMonitor tests
│   ├── WinDetector tests
│   └── InputAction tests
├── EncryptionServiceTests
├── ForecastingServiceTests
└── Mock Infrastructure (MockFactory, MockUnitOfWork, etc.)
```

### Timing Constraints
- **Signal Generation**: H0UND processes credentials continuously; analytics phase runs on configurable interval
- **Signal Consumption**: H4ND polls EV3NT every 2-5 seconds for new signals
- **Vision Processing**: Frame capture at 1280x720, latency tracking per frame
- **Safety Checks**: Real-time spend monitoring during gameplay
- **Validation**: synchronous, must complete <100ms (benchmarked)
- **Database Writes**: async acknowledgment required; batch size <100 documents

## Configuration

**Environment Variables**:
- `MONGODB_CONNECTION_STRING`: MongoDB connection
- `MONGODB_DATABASE_NAME`: Database name (default: P4NTHE0N)

**Key Configuration Files**:
- `HunterConfig.json`: Prize tiers, rate limits, watchdog settings
- `RUL3S/resource_override_rules.json`: Chrome extension rules (9.2MB)

**Database Collections**:
- `CRED3N7IAL`: Player accounts and game data
- `SIGN4L`: Generated automation triggers
- `EV3NT`: System audit trail
- `JACKPOTS`: Historical records
- `H0U53`: Platform definitions
- `ERR0R`: Validation and processing failures

## Development

### Build Commands
```bash
# Build entire solution (Debug - currently clean)
dotnet build P4NTHE0N.slnx

# Run H0UND polling+analytics agent
dotnet run --project ./H0UND/H0UND.csproj

# Run H4ND automation agent
dotnet run --project ./H4ND/H4ND.csproj

# Run W4TCHD0G vision system
dotnet run --project ./W4TCHD0G/W4TCHD0G.csproj

# Run T00L5ET tools
dotnet run --project ./T00L5ET/T00L5ET.csproj

# Run tests (27 passing)
dotnet test ./UNI7T35T/UNI7T35T.csproj

# Format code
dotnet csharpier .

# Check formatting
dotnet csharpier check
```

### Running the Platform
Requires multiple terminals:
- **Terminal 1**: `dotnet run --project ./H0UND/H0UND.csproj` (polling+analytics)
- **Terminal 2**: `dotnet run --project ./H4ND/H4ND.csproj` (automation)
- **Terminal 3**: `dotnet run --project ./W4TCHD0G/W4TCHD0G.csproj` (vision+safety)

### Documentation
- Architecture: `docs/architecture/ADR-001-Core-Systems.md`
- Runbooks: `docs/runbooks/DEPLOYMENT.md`, `INCIDENT_RESPONSE.md`, `TROUBLESHOOTING.md`
- Security: `docs/SECURITY.md`
- Procedures: `docs/procedures/FIRST_JACKPOT_ATTEMPT.md`, `EMERGENCY_RESPONSE.md`

## Critical Notes

### Data Validation
Entities use `IsValid(IStoreErrors?)` pattern - validates but does NOT mutate. Invalid data is logged to ERR0R MongoDB collection for monitoring. P4NTHE0NSanityChecker (auto-repair) has been removed. All services must check `IsValid()` before processing.

### DPD System
Dollars-Per-Day analysis requires minimum 25 data points for statistical reliability when DPD > 10. Thresholds are stored in CRED3N7IAL collection per user.

### Safety System (W4TCHD0G)
- **Daily Spend Limits**: Configurable per-credential, enforced in real-time
- **Consecutive Loss Circuit Breaker**: Halts after N losses
- **Kill Switch**: Immediate halt capability with override code
- **Win Detection**: Dual detection (balance change + OCR) with alerting

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

### Security
- Chrome runs incognito without extension; jackpot values read directly from page JavaScript
- EncryptionService provides AES-256 encryption for sensitive data
- KeyManagement handles encryption key lifecycle
- Current priority: Automation first - credentials stored in plain text acceptable for now
- Future hardening: Full credential encryption, credential vault, access controls

### Build Status (Current - Post Session)
- **Build**: `dotnet build P4NTHE0N.slnx` - **CLEAN**
- **Tests**: `dotnet test UNI7T35T/UNI7T35T.csproj` - **27/27 PASSING**
- **Formatting**: `dotnet csharpier check` - **PASSES**
- **Coverage**: 16 integration tests covering FrameBuffer, ScreenMapper, ActionQueue, DecisionEngine, SafetyMonitor, WinDetector, InputAction

### DECISION_077: Navigation Workflow Architecture (2026-02-21)
**Status**: In Progress - FireKirin navigation walkthrough active  
**Purpose**: Systematic Canvas typing investigation via screenshot-guided navigation  
**Platform Sequence**: FireKirin (Canvas works) → OrionStars (Canvas broken, investigate alternatives)

**Infrastructure Created**:
- `H4ND/tools/recorder/` - TypeScript CLI tool for session recording
  - 6 TypeScript files: recorder.ts, session-manager.ts, t00l5et-bridge.ts, screenshot-processor.ts, types.ts
  - Dual logging: NDJSON (machine-readable) + Markdown (human-readable)
  - T00L5ET integration: diag, login, nav, credcheck tool invocation
- `H4ND/config/firekirin/phase-definitions.json` - UI element coordinates
  - Login phase: Account {460, 367}, Password {460, 437}, Login {553, 567}
  - GameSelection phase: Category buttons, paging controls
  - Spin phase: Spin button {860, 655}
- `DECISION_077/sessions/` - Per-session data storage
  - Session ID format: `{platform}-{timestamp}`
  - Screenshots, NDJSON logs, Markdown reports

**Execution Flow**:
1. Initialize: `bun run recorder.ts --init --platform=firekirin`
2. Record step: `bun run recorder.ts --step --phase=Login --screenshot=001.png --run-tool=diag`
3. Nexus provides screenshots → WindFixer executes tools → Records results
4. Output: Verified navigation map for FireKirin, then OrionStars investigation

**Canvas Typing Investigation** (Oracle Priority Order):
1. WebSocket Auth Bypass - Direct WebSocket authentication
2. Cocos2d-x EditBox Direct Manipulation - JavaScript cc.EditBox access
3. Popup Keyboard Dialog Navigation - OrionStars-specific approach
4. Session Token Reuse - Manual auth + token capture
5. Native OS Input (H.InputSimulator) - Windows-level simulation

---

### Completed This Session (37/39 Decisions)
**Phase 3 — WIN Decisions (8):**
- WIN-004: W4TCHD0G/Safety/ISafetyMonitor.cs + SafetyMonitor.cs
- WIN-003: W4TCHD0G/Monitoring/WinDetector.cs + JackpotAlertService.cs
- WIN-001: UNI7T35T/Tests/PipelineIntegrationTests.cs (16 tests)
- WIN-005/006/007/002/008: Documentation suite

**Phase 4 — Infrastructure (12):**
- FORGE-2024-001/002: SafeDateTime, MockFactory
- INFRA-003/004/005/006/007/008: CI/CD, HealthChecks, Backups, Security, Caching, Runbooks
- CORE-001/ACT-001/FOUR-003/FOUR-008/FEAT-001: ADR docs, SignalPoller, HealthMonitor, FrameTimestamp, LLM client

**New Components (2026-02-20):**
- C0MMON: AnomalyEvent, AutomationTrace, TestResult, GameSelectorConfig, AgentRegistry, IAgent, IRepoTestResults, AtypicalityScore, WagerFeatures
- H0UND: PredictorAgent, AnomalyDetector, WagerOptimizer
- H4ND: ParallelH4NDEngine, ParallelMetrics, ParallelSpinWorker, SignalClaimResult, SignalDistributor, SignalWorkItem, WorkerPool, BurnInConfig, BurnInController, FirstSpinConfig, FirstSpinController, JackpotReader, NetworkInterceptor, SessionPool, SessionRenewalService, SignalGenerationResult, SignalGenerator, SystemHealthReport, VisionCommandHandler, VisionCommandPublisher, VisionExecutionTracker, ExecutorAgent, MonitorAgent, UnifiedEntryPoint, ChromeSessionManager, VmHealthMonitor, CdpLifecycleConfig, CdpLifecycleManager
- H4ND Monitoring: AlertNotificationDispatcher, AlertSeverity, BurnInAlertConfig, BurnInAlertEvaluator, BurnInCompletionAnalyzer, BurnInDashboardServer, BurnInHaltDiagnostics, BurnInMonitor, BurnInProgressCalculator, DecisionPromoter, BurnInStatus, OperationalConfig
- H4ND Recent Modifications: H4ND.cs (RunMode.GenerateSignals), UnifiedEntryPoint.cs (ParseMode)

**Recent Modifications:**
- H0UND.cs: Version 0.8.6.3, AnalyticsIntervalSeconds = 10
- H4ND.cs: Added RunMode.GenerateSignals, ARCH-055, TECH-H4ND-001, TECH-FE-015, TECH-JP-001, TECH-JP-002, OPS-JP-001

**Remaining (2 — Deferred):**
- TECH-005/TECH-006: OpenCode plugin fallback system (outside P4NTHE0N workspace)

### Verification Steps
1. **Build**: `dotnet build P4NTHE0N.slnx` - Clean build expected
2. **Tests**: `dotnet test UNI7T35T/UNI7T35T.csproj` - 27 tests passing
3. **Formatting**: `dotnet csharpier check` - Should pass
4. **Runtime**: Requires MongoDB connection for full initialization
5. **Database**: Connect via `toolhive_call_tool` with `mongodb://localhost:27017/`

### Platform Requirements
- **OS**: Windows (Windows Forms support required)
- **.NET**: 10.0 or later
- **MongoDB**: Running instance (localhost:27017 default)
- **Browser**: Chrome for automation
- **OBS**: For W4TCHD0G vision system (optional)
- **Memory**: Minimum 4GB (recommended 8GB for analytics + vision)

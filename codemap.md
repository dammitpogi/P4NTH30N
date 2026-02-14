# Repository Atlas: P4NTH30N Platform

## Project Responsibility
Multi-agent automation platform for online casino game portals (FireKirin and OrionStars). Event-driven system with two primary agents (HUN7ER analytics and H4ND automation) communicating asynchronously via MongoDB to discover jackpots, generate signals, and automate gameplay.

## System Entry Points
- `HUN7ER/HUN7ER.cs`: Analytics agent entry point (PROF3T.Main → HUN7ER())
- `H4ND/`: Automation agent (H4ND.Main → H4ND())
- `H0UND/`: Monitoring/credential polling service (H0UND.Main → H0UND())
- `T00L5ET/`: Manual utilities for database operations and one-off tasks
- `UNI7T35T/`: Testing platform for features and bug simulation
- `C0MMON/`: Shared library for all components
- `P4NTH30N.slnx`: .NET solution file
- `HunterConfig.json`: Configuration for prize tiers, rate limits, watchdog

## Repository Directory Map

| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `C0MMON/` | Core shared library providing data persistence, validation, services, and utilities. Repository pattern, Unit of Work, ValidatedMongoRepository for data integrity. | [View Map](C0MMON/codemap.md) |
| `HUN7ER/` | Analytics agent ("The Brain") that processes game data, builds DPD forecasting models, and generates SIGN4L records for automation. | [View Map](HUN7ER/codemap.md) |
| `H4ND/` | Automation agent ("The Hands") that consumes signals and performs automated gameplay. | [View Map](H4ND/codemap.md) |
| `H0UND/` | Watchdog/monitoring service for system health tracking and credential polling. | [View Map](H0UND/codemap.md) |
| `T00L5ET/` | Manual use tools for database operations, data cleanup, and one-off utilities. | — |
| `UNI7T35T/` | Testing platform for new features, bug simulation, and regression testing. | — |
| `RUL3S/` | Resource override system with Chrome extension for JavaScript injection, header manipulation, and asset overrides to enable browser automation. | [View Map](RUL3S/codemap.md) |
| `docs/` | Comprehensive documentation: architecture specs (CODEX), migration guides, modernization roadmap, and system overviews. | [View Map](docs/codemap.md) |
| `PROF3T/` | Profit analysis tools and utilities for performance tracking. | [View Map](PROF3T/codemap.md) |
| `CLEANUP/` | Data cleanup utilities and MongoDB corruption prevention services. | — |
| `MONITOR/` | System monitoring and health check services. | — |
| `W4TCHD0G/` | Hunter watchdog for monitoring automation agent status. | [View Map](W4TCHD0G/codemap.md) |
| `C0RR3CT/` | Correction utilities for data repair and system fixes. | — |

## Architecture Overview

### Multi-Agent System
```
┌─────────────┐     MongoDB Collections     ┌─────────────┐
│  HUN7ER     │ ◄───── credentials ───────► │    H4ND     │
│ (Analytics) │ ◄───── signals ──────────► │ (Automation)│
│   "Brain"   │ ◄───── eventlogs ───────► │   "Hands"   │
└─────────────┘                             └─────────────┘
       ▲                                           ▲
       │ Uses for data access                      │ Uses for automation
       │                                           │
┌─────────────┐                             ┌─────────────┐
│   C0MMON    │                             │   RUL3S     │
│   Library   │                             │   (Chrome   │
│             │                             │  Extension) │
└─────────────┘                             └─────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────┐
│  T00L5ET (Manual Tools)  │  UNI7T35T (Testing)     │
│  - Database cleanup       │  - Feature testing      │
│  - One-off operations    │  - Bug simulation       │
└─────────────────────────────────────────────────────┘
```
┌─────────────┐     MongoDB Collections     ┌─────────────┐
│  HUN7ER     │ ◄───── credentials ───────► │    H4ND     │
│ (Analytics) │ ◄───── signals ──────────► │ (Automation)│
│   "Brain"   │ ◄───── eventlogs ────────► │   "Hands"   │
└─────────────┘                             └─────────────┘
       ▲                                           ▲
       │ Uses for data access                      │ Uses for automation
       │                                           │
┌─────────────┐                             ┌─────────────┐
│   C0MMON    │                             │   RUL3S     │
│   Library   │                             │   (Chrome   │
│             │                             │  Extension) │
└─────────────┘                             └─────────────┘
```

### Key Technologies
- **Language**: C# .NET 10.0
- **Database**: MongoDB (primary), EF Core (some analytics)
- **UI**: Spectre.Console (Dashboard)
- **Automation**: Selenium WebDriver, HTTP/WebSocket APIs
- **Browser**: Chrome with resource overrides
- **Architecture**: Event-driven, asynchronous

## Dependency Flow

### Core Dependencies
```
C0MMON (Shared Library)
├── Interfaces (IReceiveSignals, IStoreEvents, IStoreErrors, IRpoCredentials, etc.)
│   └── Defines contracts for data access and agent coordination
├── Infrastructure/Persistence (MongoDB implementation)
│   ├── MongoDatabaseProvider.cs - Connection management
│   ├── MongoUnitOfWork.cs - Unit of Work pattern
│   ├── Repositories.cs - Collection repositories (Credentials, Signals, Jackpots, etc.)
│   └── ValidatedMongoRepository.cs - Base repository with validation
├── Entities (Credential, Jackpot, Signal, etc.)
│   └── Business objects with IsValid() validation pattern
├── Games (FireKirin, OrionStars parsers)
│   └── Platform-specific HTTP/WebSocket parsing logic
└── Support (DPD, Thresholds, GameSettings)
    └── Domain value objects and configuration structures

All other projects reference C0MMON as their primary dependency
```

### Agent Dependencies and Coordination
```
HUN7ER (Analytics - "The Brain")
├── References: C0MMON
├── Depends on: MongoDB (credentials, signals, jackpots collections)
├── Uses: IMongoUnitOfWork for data persistence
├── Produces: SIGN4L records written to EV3NT collection
└── Model: DPD forecasting with Thresholds validation

H4ND (Automation - "The Hands")
├── References: C0MMON, RUL3S (Chrome extension)
├── Depends on: MongoDB (signals from EV3NT, credentials from CRED3N7IAL)
├── Consumes: SIGN4L records (read via Signals repository)
├── Produces: Event logs (written via IStoreEvents)
└── Actions: Login, Launch, Overwrite, Logout (via Actions namespace)

H0UND (Watchdog)
├── References: C0MMON
├── Depends on: MongoDB (health queries, error logs)
├── Monitors: Agent status, credential polling cycles, ERR0R collection health
└── Produces: Alert records, health metrics

W4TCHD0G (Hunter Watchdog)
├── References: C0MMON
├── Monitors: HUN7ER/H4ND process health
└── Produces: Process-level metrics and restarts
```

### Project Dependency Graph (Topological Order)
1. **C0MMON** (base layer - no dependencies on other projects)
2. **HUN7ER**, **H4ND**, **H0UND**, **W4TCHD0G** (depend on C0MMON)
3. **T00L5ET**, **UNI7T35T**, **PROF3T** (utility and test projects)
4. **CLEANUP**, **C0RR3CT** (specialized maintenance tools)

### External Dependencies
- **MongoDB**: Primary data store (database: `P4NTH30N`)
- **Collections**: `CRED3N7IAL` (credentials), `EV3NT` (signals/events), `ERR0R` (validation failures), `JACKPOTS` (historical)
- **NuGet Packages**:
  - `MongoDB.Driver` (3.6.0) - Direct MongoDB access
  - `MongoDB.EntityFrameworkCore` (9.0.4) - EF Core integration (hybrid)
  - `Selenium.WebDriver` (4.40.0) - Browser automation
  - `Spectre.Console` (0.54.0) - Dashboard UI
  - `Microsoft.EntityFrameworkCore` (9.0.12) - Analytics data access
  - `H.InputSimulator` (1.5.0) - Input simulation
- **Environment Variables**:
  - `MONGODB_CONNECTION_STRING` (required, currently not set)
  - `MONGODB_DATABASE_NAME` (optional, default: P4NTH30N)
- **Browser**: Chrome with RUL3S extension for resource overrides

### Data Flow and MongoDB Collections
```
┌─────────────────────────────────────────────────────────────┐
│                      MongoDB Database (P4NTH30N)            │
├─────────────────┬─────────────────┬─────────────────────────┤
│ CRED3N7IAL      │ EV3NT           │ ERR0R                    │
│ - username      │ - agent         │ - entity                 │
│ - Password      │ - action        │ - field                  │
│ - Thresholds    │ - timestamp     │ - error                  │
│ - settings      │ - metadata      │ - user                   │
│                 │                 │ - stack trace            │
├─────────────────┼─────────────────┼─────────────────────────┤
│ JACKPOTS        │ HOUSES          │ SIGNALS (derived)        │
│ - Grand         │ - Platform      │ - computed from EV3NT    │
│ - Major         │ - URL           │                         │
│ - Minor         │ - configuration │                         │
│ - Mini          │                 │                         │
└─────────────────┴─────────────────┴─────────────────────────┘

Flow:
1. HUN7ER reads CRED3N7IAL (credentials) and writes JACKPOTS
2. HUN7ER analyzes thresholds and writes SIGN4L to EV3NT (agent: "HUN7ER", action: "SignalGenerated")
3. H4ND reads EV3NT (filter: agent="HUN7ER", action="SignalGenerated") and credentials from CRED3N7IAL
4. H4ND performs automation and writes logs to EV3NT (agent: "H4ND", action: "Login", "Launch", etc.)
5. Validation failures (IsValid) are written to ERR0R by H4ND/HUN7ER via IStoreErrors
6. H0UND queries ERR0R for health monitoring: count errors in last 24h, alert if >200/hr
```

### Interface Contracts (Key Abstractions)
```
IRepoCredentials    : CRUD operations on user credentials
IRepoSignals        : Signal ingestion and retrieval (WriteOnceReadMany)
IRepoJackpots       : Jackpot threshold and historical data
IRepoHouses         : Platform configuration and endpoints
IReceiveSignals     : Signal processing pipeline (ReceivedRepository)
IStoreEvents        : Event logging (ProcessEventRepository)
IStoreErrors        : Error logging (ErrorLogRepository) - writes to ERR0R

IMongoUnitOfWork    : Aggregates all repositories, provides transaction boundary
IMongoDatabaseProvider : Factory for database connections (FromEnvironment())
```

### Timing Constraints
- **Signal Generation**: HUN7ER processes credentials every 5-15 minutes (configurable)
- **Signal Consumption**: H4ND polls EV3NT every 2-5 seconds for new signals
- **Validation**: synchronous, must complete <100ms (benchmarked)
- **Database Writes**: async acknowledgment required; batch size <100 documents

## Configuration

**Environment Variables**:
- `MONGODB_CONNECTION_STRING`: MongoDB connection
- `MONGODB_DATABASE_NAME`: Database name (default: P4NTH30N)

**Key Configuration Files**:
- `HunterConfig.json`: Prize tiers, rate limits, watchdog settings
- `RUL3S/resource_override_rules.json`: 9.2MB Chrome extension rules

**Database Collections**:
- `credentials`: Player accounts and game data
- `signals`: Generated automation triggers
- `eventlogs`: System audit trail
- `jackpots`: Historical records
- `houses`: Platform definitions

## Development

### Build Commands
```bash
# Build entire solution
dotnet build P4NTH30N.slnx

# Run HUN7ER analytics agent
dotnet run --project ./HUN7ER/HUN7ER.csproj

# Run H4ND automation agent
dotnet run --project ./H4ND/H4ND.csproj

# Run H0UND monitoring service
dotnet run --project ./H0UND/H0UND.csproj

# Run T00L5ET tools (specific tool via args)
dotnet run --project ./T00L5ET/T00L5ET.csproj

# Run UNI7T35T tests
dotnet test ./UNI7T35T/UNI7T35T.csproj
```

### Running the Platform
Requires two terminals:
- **Terminal 1**: `dotnet run --project ./HUN7ER/HUN7ER.csproj` (analytics)
- **Terminal 2**: `dotnet run --project ./H4ND/H4ND.csproj` (automation)

### Documentation
- Start with `docs/overview.md` for system context
- Reference `docs/architecture/CODEX_of_Provenance_v1.0.3.json` for technical details
- See `docs/modernization.md` for roadmap and technical debt

## Critical Notes

### Data Validation
Entities use `IsValid(IStoreErrors?)` pattern - validates but does NOT mutate. Invalid data is logged to ERR0R MongoDB collection for monitoring. P4NTH30NSanityChecker (auto-repair) has been removed. All services must check `IsValid()` before processing.

### DPD System
Dollars-Per-Day analysis requires minimum 25 data points for statistical reliability when DPD > 10. Thresholds are stored in CRED3N7IAL collection per user.

### Security Considerations
- RUL3S uses Chrome extension with resource overrides for automation. Risk of detection by game platforms.
- Current priority: Automation first - credentials stored in plain text in EV3NT/CRED3N7IAL is acceptable for now.
- Future hardening: Password encryption, credential vault, access controls.

### Build Status (Current)
- Build Command: `dotnet build P4NTH30N.slnx`
- **Known Issues**:
  - `MongoUnitOfWork.cs(28,18)`: CS1729 - `Jackpots` does not contain a constructor that takes 1 argument
  - `Repositories.cs(314,7)`: CS8073 - ObjectId comparison always false warning
- Formatting: `dotnet csharpier check` - currently passes
- Test Framework: Not implemented (UNI7T35T project exists but no tests present)
- MongoDB Connectivity: Requires `MONGODB_CONNECTION_STRING` environment variable

### Verification Steps
1. **Build**: `dotnet build P4NTH30N.slnx --no-restore` (currently failing)
2. **Formatting**: `dotnet csharpier check` (passes)
3. **Dependencies**: `dotnet restore P4NTH30N.slnx` (succeeds)
4. **Runtime**: Requires MongoDB connection to test agent initialization
5. **Database**: Must connect via `toolhive_call_tool` with `mongodb://localhost:27017/`

### Platform Requirements
- **OS**: Windows (Windows Forms support required)
- **.NET**: 10.0 or later
- **MongoDB**: Running instance (localhost:27017 default)
- **Browser**: Chrome for automation
- **Memory**: Minimum 4GB (recommended 8GB for analytics)

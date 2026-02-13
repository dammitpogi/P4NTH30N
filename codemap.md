# Repository Atlas: P4NTH30N Platform

## Project Responsibility
Multi-agent automation platform for online casino game portals (FireKirin and OrionStars). Event-driven system with two primary agents (HUN7ER analytics and H4ND automation) communicating asynchronously via MongoDB to discover jackpots, generate signals, and automate gameplay.

## System Entry Points
- `HUN7ER/HUN7ER.cs`: Analytics agent entry point (PROF3T.Main → HUN7ER())
- `H4ND/`: Automation agent (referenced in docs, not in repository root)
- `C0MMON/`: Shared library for all components
- `P4NTH30N.slnx`: .NET solution file
- `HunterConfig.json`: Configuration for prize tiers, rate limits, watchdog

## Repository Directory Map

| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `C0MMON/` | Core shared library providing data persistence, validation, services, and utilities. Repository pattern, Unit of Work, ValidatedMongoRepository for data integrity. | [View Map](C0MMON/codemap.md) |
| `HUN7ER/` | Analytics agent ("The Brain") that processes game data, builds DPD forecasting models, and generates SIGN4L records for automation. | [View Map](HUN7ER/codemap.md) |
| `RUL3S/` | Resource override system with Chrome extension for JavaScript injection, header manipulation, and asset overrides to enable browser automation. | [View Map](RUL3S/codemap.md) |
| `docs/` | Comprehensive documentation: architecture specs (CODEX), migration guides, modernization roadmap, and system overviews. | [View Map](docs/codemap.md) |
| `H0UND/` | Watchdog monitoring service for system health tracking and error detection. | [View Map](H0UND/codemap.md) |
| `H4ND/` | Automation agent ("The Hands") that consumes signals and performs automated gameplay. | [View Map](H4ND/codemap.md) |
| `PROF3T/` | Profit analysis tools and utilities for performance tracking. | [View Map](PROF3T/codemap.md) |
| `CLEANUP/` | Data cleanup utilities and MongoDB corruption prevention services. | [View Map](CLEANUP/codemap.md) |
| `MONITOR/` | System monitoring and health check services. | [View Map](MONITOR/codemap.md) |
| `W4TCHD0G/` | Hunter watchdog for monitoring automation agent status. | [View Map](W4TCHD0G/codemap.md) |
| `C0RR3CT/` | Correction utilities for data repair and system fixes. | [View Map](C0RR3CT/codemap.md) |

## Architecture Overview

### Multi-Agent System
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

### Data Flow
1. **HUN7ER** polls MongoDB for credential data
2. Analyzes DPD (Dollars-Per-Day) growth rates
3. Generates **SIGN4L** records when jackpots likely to hit
4. **H4ND** consumes signals from MongoDB
5. Uses **RUL3S** Chrome extension to inject automation scripts
6. Performs automated spins via exposed game APIs

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

# Run H4ND automation agent (if available)
dotnet run --project ./H4ND/H4ND.csproj
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

**BUG_001**: Subagent delegation system is non-functional. All `task()` calls return task IDs but subagents never execute. Workaround: Direct manual exploration and codemap creation.

**Data Validation**: All writes go through `ValidatedMongoRepository` which performs sanity checks and auto-repair to prevent corruption.

**DPD System**: Dollars-Per-Day analysis requires minimum 25 data points for statistical reliability when DPD > 10.

**Security**: RUL3S uses Chrome extension with resource overrides for automation. Risk of detection by game platforms.

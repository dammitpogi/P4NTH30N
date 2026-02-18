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
```

### Key Technologies
- **Language**: C# .NET 10.0
- **Database**: MongoDB (primary), EF Core (some analytics)
- **UI**: Spectre.Console (Dashboard)
- **Automation**: Selenium WebDriver, HTTP/WebSocket APIs
- **Browser**: Chrome with resource overrides
- **Architecture**: Event-driven, asynchronous

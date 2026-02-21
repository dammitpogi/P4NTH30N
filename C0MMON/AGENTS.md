# C0MMON Project Structure

## Responsibility

C0MMON provides shared infrastructure, domain logic, and cross-cutting concerns for the P4NTH30N ecosystem. This project contains reusable components that enable automation, analytics, and monitoring across all agents.

## When Working in C0MMON

- **Maintain SOLID principles**: Single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion
- **Follow DDD patterns**: Entities are in root namespace, interfaces define contracts, infrastructure implements persistence
- **Use explicit types**: Avoid `var`, use predefined types (`int` not `Int32`)
- **Enable nullable reference types**: Always check for null on reference types
- **Prefer primary constructors** and file-scoped namespaces
- **Validation first**: Use `IsValid(IStoreErrors?)` pattern, log errors to ERR0R collection, never auto-repair

## Code Style

- **Line endings**: CRLF (Windows)
- **Indentation**: Tabs (width 4)
- **Line length**: Maximum 170 characters
- **Braces**: Same line (K&R style)
- **Naming**: PascalCase for public members, _camelCase for private fields

## Key Patterns

- **Repository Pattern**: IRepo<Entity> interfaces with MongoDB implementations
- **Unit of Work**: MongoUnitOfWork for atomic operations
- **Validation**: Entities implement IsValid with optional error logging
- **Error Handling**: Always log line numbers for debugging using StackTrace

## MongoDB Collections

- **EV3NT**: Event data (signals, game events)
- **CR3D3N7IAL**: User credentials and settings
- **ERR0R**: Validation errors and processing failures
- **H0U53**: House/location organization data

## Integration Points

- Used by H4ND (automation agent)
- Used by H0UND (analytics agent)
- Shared infrastructure for all P4NTH30N agents
- Provides domain entities, repositories, and services

## Architecture Overview

### Core Domain
- **Entities**: `Credential`, `Signal`, `VisionCommand`, `ErrorLog`, `Jackpot`, `House`
- **New Entities (2026-02-20)**: `AnomalyEvent`, `AutomationTrace`, `TestResult`
- **Interfaces**: `IRepo*`, `IUnitOfWork`, `IStoreErrors`, `IReceiveSignals`, `IStoreEvents`
- **New Interfaces (2026-02-20)**: `IAgent`, `IRepoTestResults`
- **Services**: `Dashboard`, validation patterns, error handling

### Infrastructure
- **Persistence**: MongoDB repositories, `MongoUnitOfWork`, database provider
- **New Infrastructure (2026-02-20)**: `GameSelectorConfig`, `AgentRegistry`
- **CDP**: Chrome DevTools Protocol client (`ICdpClient`, `CdpClient`, `CdpConfig`)
- **Event Bus**: In-memory pub/sub (`IEventBus`, `InMemoryEventBus`)
- **Resilience**: Circuit breaker pattern, retry policies
- **Monitoring**: Error logging, health checks
- **Support**: New support classes (`AtypicalityScore`, `WagerFeatures`)

### Actions & Games
- **Actions**: `Launch`, `Login` extensions for browser automation
- **Games**: Platform-specific logic (`FireKirin`, `OrionStars`) with balance queries

## Recent Updates (2026-02-19)

### H4ND Integration Components
- **CdpHealthCheck**: Pre-flight CDP connectivity validation (HTTP version, WebSocket handshake, round-trip latency, login flow)
- **SpinExecution**: CDP-based spin execution with metrics tracking
- **SpinMetrics**: Operational monitoring (success rate, latency, balance changes)
- **CommandPipeline**: Middleware-based command processing with validation, idempotency, circuit breaking
- **EventBus Integration**: VisionCommand publishing/subscription for FourEyes-H4ND coordination

### CDP Infrastructure
- Replaces Selenium for browser UI interaction
- CSS selector-based element interaction (no hardcoded pixels)
- WebSocket communication with Chrome DevTools Protocol
- Configurable timeouts and retry logic

### VM Deployment Infrastructure
- **MongoConnectionOptions**: Added mongodb.uri file override with env var fallback (P4NTH30N_MONGODB_URI)
- **CdpClient**: WebSocket URL rewriting (localhost→HostIp) for remote CDP connections
- **Command ID Matching**: Fixed CDP event message interleaving in SendCommandAsync
- **Port Proxy**: netsh interface portproxy for 192.168.56.1:9222 → 127.0.0.1:9222

### Key Discoveries
- MongoDB replica set requires `?directConnection=true` to prevent localhost redirect
- Chrome `--remote-debugging-address=0.0.0.0` still binds to 127.0.0.1; port proxy required
- CDP `/json/list` returns localhost URLs; must rewrite to configured HostIp
- Single-file publish breaks `AppContext.BaseDirectory`; use non-single-file for VM

## Important Notes

- Credentials currently stored in plain text (automation priority)
- Future hardening planned: encryption, credential vault, access controls
- Never delete AGENTS.md files or .slim/cartography.json
- Run Cartography update after structural changes: `python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update --root ./`

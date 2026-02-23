# C0MMON/
UpdateOn: 2026-02-23T12:02 AM

## Responsibility

Core shared library providing enterprise-grade infrastructure, domain logic, and cross-cutting concerns for the P4NTH30N ecosystem. Contains reusable components enabling automation, analytics, monitoring, LLM integration, RAG systems, caching, security, and data persistence across all agents.

## Design

**Architecture**: Clean Architecture with SOLID and DDD principles
- **Domain Layer**: Entities, value objects, and domain services (partially migrated to root)
- **Interface Layer**: Contracts and abstractions (Repository pattern, Store interfaces)
- **Infrastructure Layer**: MongoDB persistence, CDP client, caching, configuration, monitoring, LLM, RAG, security
- **Application Layer**: Actions, Games platform parsers, Services (Dashboard)

### Key Patterns
- **Repository Pattern**: `IRepo<T>` interfaces with MongoDB implementations
- **Unit of Work**: `MongoUnitOfWork` for atomic operations and transaction boundaries
- **Validation**: `IsValid(IStoreErrors?)` pattern - validates but never auto-repairs
- **Options Pattern**: `P4NTH30NOptions` for strongly-typed configuration
- **Dependency Injection**: Service registration via `ConfigurationExtensions`
- **CDP-First**: Chrome DevTools Protocol for browser automation (replaces Selenium)

### Project Structure

```
C0MMON/
├── Actions/              # Automation primitives (Login, Launch, Logout, Overwrite)
├── DomainServices/       # Domain business logic services
├── EF/                   # Entity Framework analytics context
├── Entities/             # Domain entities (Credential, Jackpot, Signal, ErrorLog, etc.)
├── Games/                # Platform parsers (FireKirin, OrionStars, Gold777) - now CDP-based
├── Infrastructure/
│   ├── Caching/          # CacheService for distributed caching
│   ├── Configuration/    # P4NTH30NOptions, SecretsProvider, validation
│   ├── Cdp/              # Chrome DevTools Protocol client (ICdpClient, CdpClient, CdpConfig)
│   ├── Monitoring/       # HealthChecks, MetricsService
│   └── Persistence/      # MongoDB implementation
│       ├── MongoDatabaseProvider.cs
│       ├── MongoUnitOfWork.cs
│       ├── Repositories.cs
│       └── ValidatedMongoRepository.cs
├── Interfaces/           # Contracts - IRepo<Entity>, IStoreErrors, etc.
├── LLM/                  # LLM client for external AI APIs
├── Monitoring/           # Health monitoring infrastructure
│   └── HealthChecks.cs   # CDP health validation
├── RAG/                  # Retrieval-Augmented Generation system
├── Security/             # Encryption and key management
├── Services/             # Dashboard UI service (Spectre.Console)
├── Support/              # Value objects (DPD, Thresholds, GameSettings)
├── Utilities/            # SafeDateTime (overflow-safe arithmetic)
└── Versioning/           # Application versioning
```

## Flow

### Data Access Flow
```
Agent (H0UND/H4ND/W4TCHD0G)
    ↓
IMongoUnitOfWork (MongoUnitOfWork)
    ↓
IRepoCredentials / IRepoSignals / IRepoJackpots
    ↓
ValidatedMongoRepository<T>
    ↓
MongoDB.Driver (Collections: CRED3N7IAL, EV3NT, ERR0R, etc.)
```

### CDP Communication Flow
```
H4ND (VM: 192.168.56.10)
    ↓
CdpClient.ConnectAsync()
    ↓
HTTP GET http://192.168.56.1:9222/json/version
    ↓
WebSocket ws://192.168.56.1:9222/devtools/page/{id}
    ↓
CDP Commands (Runtime.evaluate, Input.dispatchMouseEvent, etc.)
    ↓
Chrome on Host (192.168.56.1:9222)
```

### RAG System Flow
```
Document Ingestion
    ↓
IEmbeddingService.GenerateEmbeddings()
    ↓
IVectorStore.Store() (FaissVectorStore)
    ↓
Query → IHybridSearch.Search() (semantic + keyword)
    ↓
IContextBuilder.BuildContext()
    ↓
ILlmClient.Complete() → Response
```

### Security Flow
```
Sensitive Data
    ↓
IEncryptionService.Encrypt() (AES-256)
    ↓
EncryptedValue (stored)
    ↓
IKeyManagement.DecryptKey()
    ↓
Plaintext (in memory only)
```

### Configuration Flow
```
appsettings.json / Environment Variables
    ↓
ConfigurationExtensions.AddP4NTH30NConfiguration()
    ↓
ConfigurationValidator.Validate()
    ↓
P4NTH30NOptions (injected via IOptions<T>)
```

## Integration

### Internal Dependencies
- **Used by**: H4ND, H0UND, W4TCHD0G, T00L5ET, UNI7T35T, PROF3T
- **Data Access**: All agents consume via IMongoUnitOfWork and repository interfaces
- **CDP Infrastructure**: H4ND uses CdpClient for browser automation
- **Configuration**: Centralized via P4NTH30NOptions
- **Caching**: Distributed caching via CacheService
- **Security**: Encryption via EncryptionService

### External Dependencies
- **MongoDB.Driver** (3.6.0): Direct MongoDB access
- **MongoDB.EntityFrameworkCore** (9.0.4): EF Core integration
- **Microsoft.Extensions.Caching**: Caching abstractions
- **Microsoft.Extensions.Options**: Options pattern
- **Spectre.Console** (0.54.0): Dashboard UI
- **Selenium.WebDriver** (4.40.0): Browser automation (deprecated, use CDP)
- **H.InputSimulator** (1.5.0): Input simulation

### MongoDB Collections
- `CRED3N7IAL`: User credentials, jackpots, thresholds, DPD
- `EV3NT`: Signals, events, processing logs
- `ERR0R`: Validation errors, processing failures
- `JACKPOTS`: Historical jackpot data
- `H0U53`: Platform/house definitions
- `SIGN4L`: Signal queue (derived from EV3NT)

### Namespace Patterns
- Interfaces: `P4NTH30N.C0MMON.Interfaces`
- Infrastructure: `P4NTH30N.C0MMON.Infrastructure.*`
- Entities: `P4NTH30N.C0MMON` (root - migration to Domain/ pending)
- RAG: `P4NTH30N.C0MMON.RAG`
- Security: `P4NTH30N.C0MMON.Security`
- LLM: `P4NTH30N.C0MMON.LLM`

### Global Usings
```csharp
global using P4NTH30N.C0MMON.Interfaces;
global using P4NTH30N.C0MMON.Infrastructure.Persistence;
```

## Key Components

### Infrastructure/Cdp/
- **ICdpClient.cs**: Interface for Chrome DevTools Protocol client
- **CdpClient.cs**: CDP implementation with WebSocket communication
  - WebSocket URL rewriting (localhost→HostIp) for remote connections
  - Command ID matching to handle event message interleaving
  - CSS selector-based element interaction
- **CdpConfig.cs**: Configuration for CDP connection (HostIp, Port, Timeout)

### Infrastructure/Persistence/
- **MongoDatabaseProvider.cs**: Connection factory with environment-based configuration
  - Supports mongodb.uri file override
  - Environment variable fallback (P4NTH30N_MONGODB_URI)
- **MongoUnitOfWork.cs**: Aggregates all repositories, implements Unit of Work pattern
- **Repositories.cs**: Concrete implementations of IRepoCredentials, IRepoSignals, etc.
- **ValidatedMongoRepository.cs**: Base repository with validation before write operations

### Infrastructure/Persistence/Analytics/
- **AnalyticsDbContext.cs**: EF Core context for analytics queries

### Infrastructure/Caching/
- **CacheService.cs**: Distributed caching with TTL support

### Infrastructure/Configuration/
- **P4NTH30NOptions.cs**: Strongly-typed configuration options
- **ConfigurationExtensions.cs**: DI registration extensions
- **ConfigurationValidator.cs**: Startup validation
- **SecretsProvider.cs**: Secure secret retrieval

### Infrastructure/Monitoring/
- **HealthChecks.cs**: Health check endpoints and probes
- **MetricsService.cs**: Metrics collection and aggregation

### LLM/
- **ILlmClient.cs**: Interface for LLM API clients
- **LlmClient.cs**: Implementation for external LLM APIs

### RAG/
- **IContextBuilder.cs / ContextBuilder.cs**: Assembles context from search results
- **IEmbeddingService.cs / EmbeddingService.cs**: Generates vector embeddings
- **IVectorStore.cs / FaissVectorStore.cs**: Vector storage and similarity search
- **IHybridSearch.cs / HybridSearch.cs**: Combines semantic + keyword search
- **RagDocument.cs**: Document model for RAG
- **SearchResult.cs**: Search result container

### Security/
- **IEncryptionService.cs / EncryptionService.cs**: AES-256 encryption/decryption
- **IKeyManagement.cs / KeyManagement.cs**: Encryption key lifecycle
- **EncryptedValue.cs**: Encrypted value wrapper type

### Utilities/
- **SafeDateTime.cs**: Overflow-safe DateTime arithmetic operations

### Entities/
- **Credential.cs**: User credentials with jackpot tracking, thresholds, DPD
- **Jackpot.cs**: 4-tier jackpot values (Grand, Major, Minor, Mini)
- **Signal.cs**: Automation trigger with priority, house, game, username
- **ErrorLog.cs**: Validation and processing error records
- **DPD.cs**: Dollars-Per-Day calculation and toggle tracking
- **Thresholds.cs**: Jackpot threshold configuration

### Actions/
- **Login.cs**: Platform authentication actions (now CDP-based)
- **Launch.cs**: Browser/game launch automation (now CDP-based)
- **Logout.cs**: Clean session termination (now CDP-based)
- **Overwrite.cs**: Resource override management

### Games/
- **FireKirin.cs**: FireKirin platform parser with CDP support
  - WebSocket-based balance queries (unchanged)
  - CDP-based login/logout/spin operations
- **OrionStars.cs**: OrionStars platform parser with CDP support
  - WebSocket-based balance queries (unchanged)
  - CDP-based login/logout/spin operations
- **Gold777.cs**: Gold777 platform support

### Services/
- **Dashboard.cs**: Spectre.Console-based monitoring UI

## Critical Notes

### VM Deployment Infrastructure (2026-02-19)

**MongoDB Connection**:
- Replica set configured with `replSetName: rs0`
- Driver redirects to `localhost:27017` without `?directConnection=true`
- **Fix**: Append `?directConnection=true` to connection string
- **File override**: `mongodb.uri` file in app directory
- **Env var**: `P4NTH30N_MONGODB_URI`

**CDP Remote Debugging**:
- Chrome `--remote-debugging-address=0.0.0.0` still binds to `127.0.0.1`
- **Fix**: `netsh interface portproxy` to forward VM connections
- **Command**: `netsh interface portproxy add v4tov4 listenaddress=192.168.56.1 listenport=9222 connectaddress=127.0.0.1 connectport=9222`

**CDP WebSocket URL Rewriting**:
- Chrome `/json/list` returns `ws://localhost:9222/` URLs
- **Fix**: `CdpClient.FetchDebuggerUrlAsync()` rewrites localhost to configured HostIp
- Required for VM→Host CDP connections

**CDP Command ID Matching**:
- Events interleave with command responses on WebSocket
- **Fix**: Loop in `SendCommandAsync` until matching command `id` found
- Prevents reading event notifications as command responses

**Single-File Publish Issue**:
- `AppContext.BaseDirectory` resolves to temp extraction dir for single-file
- **Fix**: Use non-single-file publish for correct base directory
- Required for `appsettings.json` loading

### CDP Migration Notes (2026-02-19)
- **Replaced**: Selenium WebDriver with Chrome DevTools Protocol
- **New**: CSS selector-based element interaction (no hardcoded pixels)
- **Improved**: WebSocket communication for reliable browser control
- **Maintained**: Direct WebSocket balance queries (unchanged for performance)
- **Files Modified**:
  - `C0MMON/Infrastructure/Cdp/CdpClient.cs` - WebSocket URL rewriting, command ID matching
  - `C0MMON/Infrastructure/Persistence/MongoConnectionOptions.cs` - mongodb.uri file override

### Validation Philosophy
- Validate but do NOT mutate - invalid data is logged to ERR0R collection
- Use `entity.IsValid(errorStore)` pattern throughout
- Never auto-repair data (P4NTH30NSanityChecker removed)

### Security
- Credentials currently stored in plain text (automation priority)
- EncryptionService available for future hardening
- KeyManagement handles encryption lifecycle

### Code Style
- Line endings: CRLF (Windows)
- Indentation: Tabs (width 4)
- Line length: Maximum 170 characters
- Braces: Same line (K&R style)
- Naming: PascalCase public, _camelCase private fields
- Use explicit types (avoid var)
- Prefer primary constructors and file-scoped namespaces

### Recent Additions (This Session)
- LLM client infrastructure
- RAG system (embeddings, vector store, hybrid search)
- Encryption and key management
- Distributed caching
- Health checks and metrics
- Configuration validation
- SafeDateTime utility
- Global usings for cleaner code
- CDP Infrastructure (ICdpClient, CdpClient, CdpConfig)
- MongoConnectionOptions with file/env var override

### New Entities (2026-02-20)
- **AnomalyEvent.cs**: Event data for anomaly detection patterns
- **AutomationTrace.cs**: Trace logging for automation operations
- **TestResult.cs**: Test execution results container

### New Infrastructure (2026-02-20)
- **Infrastructure/Cdp/GameSelectorConfig.cs**: CDP game selection configuration
- **Infrastructure/EventBus/AgentRegistry.cs**: Agent registration for event coordination

### New Interfaces (2026-02-20)
- **Interfaces/IAgent.cs**: Base agent interface
- **Interfaces/IRepoTestResults.cs**: Repository interface for test results

### New Support Classes (2026-02-20)
- **Support/AtypicalityScore.cs**: Atypicality scoring for pattern detection
- **Support/WagerFeatures.cs**: Wager feature configuration and tracking

### VM Deployment Configuration
**Network**: H4ND-Switch (192.168.56.0/24) with NAT
- VM: 192.168.56.10 (H4NDv2-Production)
- Host: 192.168.56.1 (Chrome CDP + MongoDB)
- Port Proxy: 192.168.56.1:9222 → 127.0.0.1:9222

**Chrome on Host**:
```bash
chrome.exe --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0 --incognito
```

**MongoDB Connection String (VM)**:
```
mongodb://192.168.56.1:27017/?directConnection=true
```

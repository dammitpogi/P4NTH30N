# C0MMON/

## Responsibility

Core shared library providing enterprise-grade infrastructure, domain logic, and cross-cutting concerns for the P4NTH30N ecosystem. Contains reusable components enabling automation, analytics, monitoring, LLM integration, RAG systems, caching, security, and data persistence across all agents.

## Design

**Architecture**: Clean Architecture with SOLID and DDD principles
- **Domain Layer**: Entities, value objects, and domain services (partially migrated to root)
- **Interface Layer**: Contracts and abstractions (Repository pattern, Store interfaces)
- **Infrastructure Layer**: MongoDB persistence, caching, configuration, monitoring, LLM, RAG, security
- **Application Layer**: Actions, Games platform parsers, Services (Dashboard)

### Key Patterns
- **Repository Pattern**: `IRepo<T>` interfaces with MongoDB implementations
- **Unit of Work**: `MongoUnitOfWork` for atomic operations and transaction boundaries
- **Validation**: `IsValid(IStoreErrors?)` pattern - validates but never auto-repairs
- **Options Pattern**: `P4NTH30NOptions` for strongly-typed configuration
- **Dependency Injection**: Service registration via `ConfigurationExtensions`

### Project Structure

```
C0MMON/
├── Actions/              # Automation primitives (Login, Launch, Logout, Overwrite)
├── DomainServices/       # Domain business logic services
├── EF/                   # Entity Framework analytics context
├── Entities/             # Domain entities (Credential, Jackpot, Signal, ErrorLog, etc.)
├── Games/                # Platform parsers (FireKirin, OrionStars, Gold777)
├── Infrastructure/
│   ├── Caching/          # CacheService for distributed caching
│   ├── Configuration/    # P4NTH30NOptions, SecretsProvider, validation
│   ├── Monitoring/       # HealthChecks, MetricsService
│   └── Persistence/      # MongoDB implementation
│       ├── MongoDatabaseProvider.cs
│       ├── MongoUnitOfWork.cs
│       ├── Repositories.cs
│       └── ValidatedMongoRepository.cs
├── Interfaces/           # Contracts - IRepo<Entity>, IStoreErrors, etc.
├── LLM/                  # LLM client for external AI APIs
├── Monitoring/           # Health monitoring infrastructure
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
- **Configuration**: Centralized via P4NTH30NOptions
- **Caching**: Distributed caching via CacheService
- **Security**: Encryption via EncryptionService

### External Dependencies
- **MongoDB.Driver** (3.6.0): Direct MongoDB access
- **MongoDB.EntityFrameworkCore** (9.0.4): EF Core integration
- **Microsoft.Extensions.Caching**: Caching abstractions
- **Microsoft.Extensions.Options**: Options pattern
- **Spectre.Console** (0.54.0): Dashboard UI
- **Selenium.WebDriver** (4.40.0): Browser automation (via Actions)
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

### Infrastructure/Persistence/
- **MongoDatabaseProvider.cs**: Connection factory with environment-based configuration
- **MongoUnitOfWork.cs**: Aggregates all repositories, implements Unit of Work pattern
- **Repositories.cs**: Concrete implementations of IRepoCredentials, IRepoSignals, etc.
- **ValidatedMongoRepository.cs**: Base repository with validation before write operations

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
- **Login.cs**: Platform authentication actions
- **Launch.cs**: Browser/game launch automation
- **Logout.cs**: Clean session termination
- **Overwrite.cs**: Resource override management

### Games/
- **FireKirin.cs**: FireKirin platform parser
- **OrionStars.cs**: OrionStars platform parser
- **Gold777.cs**: Gold777 platform support

### Services/
- **Dashboard.cs**: Spectre.Console-based monitoring UI

## Critical Notes

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

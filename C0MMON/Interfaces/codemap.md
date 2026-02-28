# C0MMON/Interfaces/

## Responsibility

C0MMON/Interfaces defines the contracts and abstractions that enable loose coupling between system components. These interfaces establish the architectural boundaries and dependency inversion principles that allow different implementations (MongoDB, EF Core, in-memory) to be swapped without affecting business logic.

**Core Interface Categories:**
- **Repository Pattern**: IRepo* interfaces for data access abstraction
- **Storage Contracts**: IStore* interfaces for event and error logging
- **Unit of Work**: IUnitOfWork for transaction management
- **Service Contracts**: Business logic abstractions for cross-cutting concerns

## Design

**Key Patterns:**

1. **Repository Pattern**
   - `IRepoCredentials`, `IRepoSignals`, `IRepoJackpots`, `IRepoHouses`
   - Generic CRUD operations with domain-specific methods
   - Consistent interface naming: `GetBy*`, `Upsert`, `Delete`

2. **Storage Abstraction**
   - `IStoreEvents`: Event logging and signal management
   - `IStoreErrors`: Error logging with context and line numbers
   - `IReceiveSignals`: Signal processing and acknowledgment

3. **Dependency Inversion**
   - High-level modules depend on abstractions, not implementations
   - MongoDB and EF Core implementations hidden behind interfaces
   - Testability through interface mocking

4. **Interface Naming Convention**
   - I<Verb><Noun> pattern for operations (IReceiveSignals, IStoreEvents)
   - IRepo<Entity> pattern for data access
   - Descriptive method names that reveal intent

## Flow

```
Interface Usage Flow:
├── Business Logic (H4ND/H0UND)
│   ├── Depends on IUnitOfWork interface
│   ├── Uses IRepo* interfaces for data access
│   └── Uses IStore* interfaces for logging
├── Dependency Injection
│   ├── Concrete implementations registered at startup
│   ├── MongoDB repositories implement IRepo* interfaces
│   └── EF Core repositories implement same interfaces
├── Runtime Execution
│   ├── Interface calls routed to concrete implementations
│   ├── MongoDB operations via MongoUnitOfWork
│   └── EF Core operations via AnalyticsDbContext
└── Testing
    ├── Mock implementations of interfaces
    ├── In-memory test doubles
    └── Isolated unit testing
```

## Integration

**Interface Implementations:**

**MongoDB Implementation (C0MMON/Infrastructure/Persistence):**
- `MongoUnitOfWork` implements `IUnitOfWork`
- `Repositories` class implements all `IRepo*` interfaces
- `MongoDatabaseProvider` handles connection management
- `ValidatedMongoRepository` adds validation layer

**EF Core Implementation (C0MMON/EF):**
- `P4NTHE0NDbContext` implements repository patterns
- `AnalyticsRepositories` provide analytics-specific implementations
- `AnalyticsServices` use EF Core for complex queries

**Key Interfaces:**

**Data Access:**
- `IRepoCredentials`: Credential CRUD and query operations
- `IRepoSignals`: Signal management and priority handling
- `IRepoJackpots`: Jackpot data tracking and history
- `IRepoHouses`: House/location management

**Storage & Logging:**
- `IStoreEvents`: Event logging, signal acknowledgment
- `IStoreErrors`: Error logging with context and stack traces
- `IReceiveSignals`: Signal processing workflow

**Transaction Management:**
- `IUnitOfWork`: Atomic operations across repositories
- Commit/rollback pattern for data consistency

**Used By:**
- **H4ND**: Primary consumer (all interfaces for automation)
- **H0UND**: Analytics consumer (repository interfaces)
- **C0MMON/Services**: Dashboard and monitoring services
- **C0MMON/Actions**: Indirect use via UnitOfWork

**Benefits:**
- **Testability**: Easy mocking for unit tests
- **Flexibility**: Implementation swapping without code changes
- **Maintainability**: Clear contracts between components
- **Scalability**: Different storage backends for different use cases

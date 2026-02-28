# C0MMON/Interfaces

## Responsibility

Defines contracts and abstractions that enable loose coupling between system components. These interfaces establish architectural boundaries and dependency inversion principles.

## When Working Here

- **Repository pattern**: IRepo<Entity> interfaces for data access abstraction
- **Storage contracts**: IStore* interfaces for event and error logging
- **Dependency inversion**: High-level modules depend on abstractions, not implementations
- **Testability**: Design for interface mocking
- **Naming convention**: I<Verb><Noun> for operations (IReceiveSignals), IRepo<Entity> for data access

## Core Interface Categories

### Repository Pattern

| Interface | File | Description |
|-----------|------|-------------|
| **IRepoCredentials** | `IRepoCredentials.cs` | Credential CRUD: GetAll, GetBy, GetAllEnabledFor, GetNext, Upsert, Lock, Unlock |
| **IRepoSignals** | `IRepoSignals.cs` | Signal CRUD: Get, GetOne, GetNext, DeleteAll, Exists, Acknowledge, Upsert, Delete |
| **IRepoJackpots** | `IRepoJackpots.cs` | Jackpot operations: Get, GetAll, GetEstimations, GetMini, Upsert |
| **IRepoHouses** | `IRepoHouses.cs` | House operations: GetAll, GetOrCreate, Upsert, Delete |

### Storage Contracts

| Interface | File | Description |
|-----------|------|-------------|
| **IStoreEvents** | `IStoreEvents.cs` | Event logging: Insert(ProcessEvent) |
| **IStoreErrors** | `IStoreErrors.cs` | Error logging: Insert, GetAll, GetBySource, GetUnresolved, MarkResolved |
| **IReceiveSignals** | `IReceiveSignals.cs` | Signal acknowledgment: GetAll, GetOpen, Upsert |

### Event Bus & Communication

| Interface | File | Description |
|-----------|------|-------------|
| **IEventBus** | `IEventBus.cs` | In-memory pub/sub: PublishAsync, SubscribeAsync for decoupled communication |

### CDP Infrastructure

| Interface | File | Description |
|-----------|------|-------------|
| **ICdpClient** | `ICdpClient.cs` | Chrome DevTools Protocol: Connect, Navigate, Click, Evaluate, SendCommand |

### Unit of Work

| Interface | File | Description |
|-----------|------|-------------|
| **IUnitOfWork** | `IUnitOfWork.cs` | Unified access: Credentials, Signals, Jackpots, ProcessEvents, Errors, Received, Houses |

### New Interfaces (2026-02-20)
- **IAgent.cs**: Base agent interface
- **IRepoTestResults.cs**: Repository interface for test results

### Legacy/Stage Interfaces

| Interface | File | Description |
|-----------|------|-------------|
| **ISignalRepository** | `ISignalRepository.cs` | Legacy signal persistence (different namespace: `C0MMON.Interfaces`) |
| **ICredentialRepository** | `ICredentialRepository.cs` | Legacy credential persistence (different namespace: `C0MMON.Interfaces`) |

## Key Patterns

1. **Repository Pattern**
   - Generic CRUD operations with domain-specific methods
   - Consistent naming: GetBy*, Upsert, Delete
   - Interface-based design for implementation swapping

2. **Dependency Inversion**
   - MongoDB and EF Core implementations hidden behind interfaces
   - High-level modules depend on abstractions only
   - Enables testability through mocking

3. **Storage Abstraction**
   - IStoreEvents: Event logging and signal management
   - IStoreErrors: Error logging with context and line numbers
   - IReceiveSignals: Signal processing and acknowledgment

## Interface Implementations

**MongoDB (C0MMON/Infrastructure/Persistence):**
- MongoUnitOfWork implements IUnitOfWork
- Repositories class implements all IRepo* interfaces
- MongoDatabaseProvider handles connection management

**EF Core (C0MMON/EF):**
- P4NTHE0NDbContext implements repository patterns
- AnalyticsRepositories provide analytics-specific implementations

## Used By

- H4ND (primary consumer for all interfaces)
- H0UND (analytics consumer for repository interfaces)
- C0MMON/Services (dashboard and monitoring services)
- C0MMON/Actions (indirect use via UnitOfWork)

## Benefits

- **Testability**: Easy mocking for unit tests
- **Flexibility**: Implementation swapping without code changes
- **Maintainability**: Clear contracts between components
- **Scalability**: Different storage backends for different use cases

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

- **Repository Pattern**: IRepoCredentials, IRepoSignals, IRepoJackpots, IRepoHouses
- **Storage Contracts**: IStoreEvents, IStoreErrors, IReceiveSignals
- **Unit of Work**: IUnitOfWork for transaction management

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
- P4NTH30NDbContext implements repository patterns
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

# C0MMON/Infrastructure

## Responsibility

Provides persistence, resilience, and cross-cutting infrastructure concerns. Implements repository patterns, database connectivity, and system resilience mechanisms.

## When Working Here

- **Repository pattern**: Implement IRepo* interfaces with MongoDB
- **Resilience patterns**: Circuit breakers, retry logic, degradation management
- **Connection management**: Proper disposal and pooling
- **Error handling**: Graceful failures with logging
- **Thread safety**: Ensure concurrent access safety

## Subdirectories

### Persistence/

MongoDB data access layer implementing repository pattern:

- **MongoDatabaseProvider.cs**: Connection management and client initialization
- **MongoUnitOfWork.cs**: Transaction boundary and repository aggregation
- **Repositories.cs**: Implementation of all IRepo* interfaces
- **ValidatedMongoRepository.cs**: Repository base with validation hooks
- **MongoCollectionNames.cs**: Collection name constants
- **MongoConnectionOptions.cs**: Connection string and timeout configuration
- **Analytics/**: EF Core analytics repositories (AnalyticsRepository.cs, AnalyticsEntities.cs)

### Resilience/

System resilience and fault tolerance:

- **CircuitBreaker.cs**: Failure threshold-based circuit breaker pattern
- **SystemDegradationManager.cs**: Graceful degradation coordination
- **OperationTracker.cs**: Track operation timing and health
- **SystemMetrics.cs**: Performance and health metrics collection
- **DegradationLevel.cs**: Enumeration of degradation states

### EventBuffer.cs

Event buffering for batch operations:
- Placeholder for event batching (currently empty)

## Key Patterns

1. **Unit of Work**: MongoUnitOfWork aggregates all repositories
2. **Repository Pattern**: Clean separation between domain and persistence
3. **Circuit Breaker**: Prevent cascade failures in external services
4. **Validation**: ValidatedMongoRepository ensures data integrity

## MongoDB Collections

- **CR3D3N7IAL**: Credentials
- **EV3NT**: Events, signals
- **ERR0R**: Error logs
- **H0U53**: House/location data
- **J4CKP0T**: Jackpot forecasts

## Dependencies

- MongoDB.Driver: Core MongoDB operations
- EF Core: Analytics queries
- C0MMON/Interfaces: Repository contracts
- C0MMON/Entities: Domain models

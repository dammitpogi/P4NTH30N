# C0MMON/Infrastructure

## Responsibility

Provides persistence, resilience, browser automation, and cross-cutting infrastructure concerns. Implements repository patterns, database connectivity, Chrome DevTools Protocol, event bus, and system resilience mechanisms.

## When Working Here

- **Repository pattern**: Implement IRepo* interfaces with MongoDB
- **CDP architecture**: Chrome DevTools Protocol for browser automation
- **Event-driven design**: In-memory event bus for decoupled communication
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

### Cdp/

Chrome DevTools Protocol infrastructure for browser automation:

- **ICdpClient.cs**: Interface for CDP operations (Connect, Navigate, Click, Evaluate)
- **CdpClient.cs**: WebSocket-based CDP implementation with HTTP handshake
- **CdpConfig.cs**: Configuration (HostIp, Port, timeouts, retry settings)
- Replaces Selenium WebDriver for reliable browser interaction
- CSS selector-based element interaction (no hardcoded coordinates)

### EventBus/

In-memory event bus for decoupled component communication:

- **IEventBus.cs**: Publish/Subscribe interface for event-driven architecture
- **InMemoryEventBus.cs**: Thread-safe in-memory implementation
- Used for VisionCommand publishing from H4ND to FourEyes integration
- Supports generic event types with concurrent handler registration

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

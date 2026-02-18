# C0MMON/Infrastructure/Persistence

## Responsibility

MongoDB data access implementations following the repository pattern. Provides concrete implementations of all repository interfaces with validation, connection management, and transaction support.

## When Working Here

- **Repository pattern**: Implement IRepo* interfaces
- **Validation**: Always validate before persistence
- **Connection management**: Proper disposal and pooling
- **Error handling**: Graceful failures with logging
- **Thread safety**: Ensure concurrent access safety

## Core Components

### Repositories.cs
Main repository implementations:
- CredentialRepository: CRUD and query operations
- SignalRepository: Signal queue management
- JackpotRepository: Jackpot data access
- HouseRepository: House/location operations
- ErrorRepository: Error logging
- EventRepository: Event storage

### ValidatedMongoRepository.cs
Base repository with validation:
- Pre-save validation hooks
- Error logging integration
- Generic CRUD operations
- Batch operation support

### MongoUnitOfWork.cs
Transaction boundary:
- Aggregates all repositories
- Manages database transactions
- Connection lifecycle
- Repository factory

### MongoDatabaseProvider.cs
Connection management:
- Client initialization
- Connection pooling
- Database instance management
- Configuration loading

### MongoCollectionNames.cs
Collection name constants:
- Centralized collection naming
- Environment-specific overrides
- Naming convention enforcement

### MongoConnectionOptions.cs
Connection configuration:
- Connection strings
- Timeout settings
- Pool configuration
- Retry policies

### Analytics/ Subdirectory
EF Core analytics repositories:
- AnalyticsRepository.cs: Complex query operations
- AnalyticsEntities.cs: EF entity configurations

## Key Patterns

1. **Unit of Work**: MongoUnitOfWork for transaction boundaries
2. **Repository Pattern**: Interface-based data access
3. **Validation**: Pre-persistence validation in ValidatedMongoRepository
4. **Connection Pooling**: Efficient connection reuse

## Repository Implementation Example

```csharp
public class CredentialRepository : IRepoCredentials
{
    private readonly IMongoCollection<Credential> _collection;
    
    public List<Credential> GetBy(string house, string game)
    {
        return _collection.Find(c => c.House == house && c.Game == game)
            .ToList();
    }
    
    public void Upsert(Credential credential)
    {
        if (!credential.IsValid()) return;
        
        var filter = Builders<Credential>.Filter.Eq(c => c._id, credential._id);
        _collection.ReplaceOne(filter, credential, new ReplaceOptions { IsUpsert = true });
    }
}
```

## MongoDB Collections

- **CR3D3N7IAL**: Credential entities
- **EV3NT**: Events and signals
- **ERR0R**: Error logs
- **H0U53**: House/location data
- **J4CKP0T**: Jackpot forecasts

## Dependencies

- MongoDB.Driver: Core MongoDB operations
- C0MMON/Interfaces: Repository contracts
- C0MMON/Entities: Domain models
- C0MMON/Monitoring: Error logging

## Configuration

```csharp
// appsettings.json
{
  "MongoDB": {
    "ConnectionString": "mongodb://localhost:27017",
    "DatabaseName": "P4NTH30N",
    "MaxConnectionPoolSize": 100
  }
}
```

## Usage

```csharp
using var uow = new MongoUnitOfWork();
var credential = uow.Credentials.GetBy("FireKirin", "Game", "User");
credential.Balance = 1000.0;
uow.Credentials.Upsert(credential);
```

## Error Handling

- Connection failures logged to ERR0R
- Validation errors before persistence
- Retry logic for transient failures
- Graceful degradation

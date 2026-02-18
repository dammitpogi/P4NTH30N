## C0MMON Project Structure

Following SOLID and DDD principles:

```
C0MMON/
├── Domain/           # FUTURE: Entities & ValueObjects (not yet migrated)
├── Interfaces/       # Contracts - IRepo<Entity>, IStoreErrors, etc.
│   ├── IRepoCredentials.cs
│   ├── IRepoSignals.cs
│   ├── IRepoJackpots.cs
│   ├── IRepoHouses.cs
│   ├── IReceiveSignals.cs
│   ├── IStoreEvents.cs
│   └── IStoreErrors.cs
├── Infrastructure/
│   └── Persistence/  # MongoDB implementation
│       ├── MongoDatabaseProvider.cs
│       ├── MongoUnitOfWork.cs
│       ├── Repositories.cs
│       └── ValidatedMongoRepository.cs
└── [Root]           # Actions, Games, Services, etc.
    ├── Actions/      # Automation (Login, Launch, Logout, Overwrite)
    ├── Games/        # Platform parsers (FireKirin, OrionStars, etc.)
    ├── Entities/     # Domain entities (Credential, Jackpot, Signal, etc.)
    ├── Support/      # Value objects (DPD, Jackpots, Thresholds, GameSettings)
    ├── Services/     # Dashboard (monitoring UI)
    ├── EF/           # Entity Framework (analytics)
    ├── Monitoring/   # Health monitoring
    └── Versioning/   # App version
```

**Namespace Patterns:**
- Interfaces: `P4NTH30N.C0MMON.Interfaces`
- Infrastructure: `P4NTH30N.C0MMON.Infrastructure.Persistence`
- Entities: `P4NTH30N.C0MMON` (root - not yet migrated to Domain/)

**Global Usings** (in C0MMON/GlobalUsings.cs):
```csharp
global using P4NTH30N.C0MMON.Interfaces;
global using P4NTH30N.C0MMON.Infrastructure.Persistence;
```
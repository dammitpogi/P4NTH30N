# H0UND EF Hybrid (MongoDB)

## Goal
Refactor H0UND toward SOLID/DDD boundaries while adopting Entity Framework for analytics reads without changing write/locking semantics.

## Current Hybrid Split

### Stays Mongo (write model)
- Writes, locking, and operational semantics stay on `IMongoUnitOfWork` / repositories.
- Error logging and process events remain Mongo-backed.

### Uses EF (read model)
- Analytics reads can use `P4NTHE0N.C0MMON.EF.P4NTHE0NDbContext` (MongoDB EF Core provider).
- H0UND analytics reads are routed through `H0UND/Application/Analytics/AnalyticsWorker.cs`.

## Runtime Switches

### Mongo connection
- `P4NTHE0N_MONGODB_URI` (default: `mongodb://localhost:27017/`)
- `P4NTHE0N_MONGODB_DB` (default: `P4NTHE0N`)

### H0UND analytics read store
- `H0UND_ANALYTICS_STORE=EF|MONGO`
- Default: `EF`
- `EF`: analytics reads use EF DbContext with `AsNoTracking()` then in-memory grouping where needed.
- `MONGO`: analytics reads use `uow.Credentials.GetAll()`, `uow.Signals.GetAll()`, `uow.Jackpots.GetAll()`.

## Code Landmarks
- `C0MMON/EF/P4NTHE0NDbContext.cs`: EF DbContext configured from environment.
- `C0MMON/EF/AnalyticsServices.cs`: analytics service with proper DbContext injection.
- `H0UND/Application/Analytics/AnalyticsWorker.cs`: hybrid analytics read path + writes via `IMongoUnitOfWork`.
- `H0UND/Application/Polling/PollingWorker.cs`: balance query + retry extracted from host.
- `H0UND/Domain/`: Pure domain logic (Forecasting, Signals, DPD).
- `H0UND/Infrastructure/`: Infrastructure implementations (Balance Providers).

## Next Refactor Steps
- Consider moving `H0UND/Domain` to `C0MMON/Domain` if logic needs to be shared with other agents.
- Add unit tests for the new Domain services.

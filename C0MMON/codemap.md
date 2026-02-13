# C0MMON/

## Responsibility
Core shared library providing data persistence, validation, services, and utilities for the P4NTH30N platform. Acts as the foundation layer that all other components depend on for database access, entity definitions, and common functionality.

## Design

### Architecture Patterns
- **Repository Pattern**: Abstracts data access through `IRepository<T>` and `MongoRepository<T>`
- **Unit of Work**: `MongoUnitOfWork` coordinates multiple repositories and transactions
- **Validation Pipeline**: `ValidatedMongoRepository` intercepts all writes for data integrity checks
- **Provider Pattern**: `IMongoDatabaseProvider` abstracts database connection management
- **Service Layer**: `Dashboard`, `Analytics` services provide business logic

### Key Components

**Persistence Layer** (`Persistence/`):
- `MongoDatabaseProvider`: Database connection factory with environment variable support
- `MongoUnitOfWork`: Coordinates repositories and manages shared database context
- `ValidatedMongoRepository`: Operation interceptor that validates all data before persistence
- `MongoCollectionNames`: Centralized collection name constants
- `MongoConnectionOptions`: Configuration from environment variables

**Entities** (`Entities/`):
- `Credential`: Player account information, balances, jackpots, DPD data
- `Signal`: Generated predictions for automated gameplay triggers
- `EventLog`: Audit trail of system events and actions
- `House`: Casino platform definitions
- `Jackpot`: Historical jackpot records
- `NetworkAddress`: IP/network tracking

**Support Classes** (`Support/`):
- `DPD`: Dollars-Per-Day data structure for jackpot forecasting (Average, Data[], History[], Toggles)
- `DPD_Toggles`: Tracks which jackpot tiers have "popped" (GrandPopped, MajorPopped, MinorPopped, MiniPopped)
- `GameSettings`: Per-game configuration parameters
- `Jackpots`: Current jackpot values (Grand, Major, Minor, Mini)
- `Thresholds`: Target values for jackpot prediction

**Services** (`Services/`):
- `Dashboard`: Spectre.Console-based real-time monitoring UI with health status, event logs, and system metrics

**Sanity Checking** (`SanityCheck/`):
- `P4NTH30NSanityChecker`: Comprehensive data validation and auto-repair system
- Validates balances, jackpots, DPD data arrays for corruption
- Automatic repair of decimal point errors, threshold normalization, rate clamping
- Prevents extreme values and corrupted data from entering database

**Actions** (`Actions/`):
- `Launch`: Game launch automation
- `Login`: Authentication handling
- `Logout`: Session cleanup
- `Overwrite`: Data override utilities

**Games** (`Games/`):
- Platform-specific implementations: `FireKirin`, `OrionStars`, `FortunePiggy`, `Gold777`, `Quintuple5X`

## Flow

### Data Persistence Flow
1. Consumer calls `MongoUnitOfWork` to get repository
2. Repository operations go through `ValidatedMongoRepository` interceptor
3. Validation checks: balance ranges, jackpot values, DPD data integrity
4. If validation fails: log error, optionally repair, prevent write
5. If validation passes: proceed with MongoDB write
6. `MongoUnitOfWork` can coordinate multiple repository operations

### DPD Data Flow
1. HUN7ER agent collects jackpot data over time
2. DPD entries stored in `Credential.DPD.Data[]` with timestamp and Grand value
3. DPD.Average calculated from historical data
4. DPD.Toggles track when jackpots hit (GrandPopped, MajorPopped, etc.)
5. DPD.History maintains snapshots for trend analysis

### Dashboard Flow
1. Dashboard service polls system health every 30 seconds
2. Calls `P4NTH30NSanityChecker.GetSystemHealth()`
3. Renders Spectre.Console UI with real-time metrics
4. Displays recent events, current task, user, game, health status

## Integration

**Consumed By**:
- `HUN7ER`: Analytics agent, uses repositories for data access, DPD for predictions
- `H4ND`: Automation agent, uses credentials and signals
- `PROF3T`: Profit analysis tools
- `C0RR3CT`: Correction utilities
- `CLEANUP`: Data cleanup and repair utilities

**Dependencies**:
- MongoDB.Driver: Data persistence
- MongoDB.Bson: Document serialization
- EF Core (in some analytics components): Alternative ORM
- Spectre.Console: Dashboard UI

**Database Collections**:
- `credentials`: Player accounts and game data
- `signals`: Generated automation triggers
- `eventlogs`: System audit trail
- `jackpots`: Historical jackpot records
- `houses`: Platform definitions

## Configuration

**Environment Variables**:
- `MONGODB_CONNECTION_STRING`: Database connection
- `MONGODB_DATABASE_NAME`: Database name (default: P4NTH30N)

**HunterConfig.json Integration**:
- Prize tier limits (MINOR, MAJOR, GRAND)
- Rate limits for DPD calculations
- Watchdog settings for monitoring
- Auto-repair configuration

# API Reference

Complete reference for all public interfaces, entities, and services in P4NTHE0N.

## Overview

P4NTHE0N uses interface-based design for testability and loose coupling. All major components communicate through well-defined interfaces.

### Interface Categories

| Category | Purpose | Location |
|----------|---------|----------|
| **Repositories** | Data access abstraction | `C0MMON/Interfaces/` |
| **Stores** | Event and error logging | `C0MMON/Interfaces/` |
| **Services** | Business logic | Component-specific |
| **Safety** | Spend limits and monitoring | `W4TCHD0G/Safety/` |

## Quick Reference

### Repository Interfaces
- [`IRepoCredentials`](interfaces/irepo-credentials.md) - Credential CRUD operations
- [`IRepoSignals`](interfaces/irepo-signals.md) - Signal queue management
- [`IRepoJackpots`](interfaces/irepo-jackpots.md) - Jackpot data access
- [`IRepoHouses`](interfaces/irepo-houses.md) - Platform configuration

### Store Interfaces
- [`IStoreEvents`](interfaces/istore-events.md) - Event logging
- [`IStoreErrors`](interfaces/istore-errors.md) - Error logging
- [`IReceiveSignals`](interfaces/ireceive-signals.md) - Signal processing

### Safety Interfaces
- [`ISafetyMonitor`](interfaces/isafety-monitor.md) - Spend/loss monitoring
- [`IJackpotDetector`](interfaces/ijackpot-detector.md) - Win detection
- [`IStateClassifier`](interfaces/istate-classifier.md) - Game state detection

### Service Interfaces
- [`IEncryptionService`](interfaces/iencryption-service.md) - AES-256 encryption
- [`IUnitOfWork`](interfaces/iunit-of-work.md) - Transaction boundaries

## Usage Patterns

### Repository Pattern
```csharp
// Inject via constructor
public class MyService
{
    private readonly IRepoCredentials _credentials;
    
    public MyService(IRepoCredentials credentials)
    {
        _credentials = credentials;
    }
    
    public async Task<Credential> GetUser(string username)
    {
        return await _credentials.GetByUsernameAsync(username);
    }
}
```

### Unit of Work Pattern
```csharp
// Atomic operations across multiple repositories
using (var uow = _unitOfWorkFactory.Create())
{
    var credential = await uow.Credentials.GetAsync(id);
    credential.Balance += amount;
    await uow.Credentials.UpdateAsync(credential);
    await uow.SaveChangesAsync();
}
```

### Validation Pattern
```csharp
// Validate before processing
if (!credential.IsValid(_errorStore))
{
    // Errors logged to ERR0R collection
    return false;
}
```

## Entity Documentation

Domain entities with validation and business logic:

- [`Credential`](entities/credential.md) - User credentials and balance
- [`Signal`](entities/signal.md) - Automation triggers
- [`Jackpot`](entities/jackpot.md) - Jackpot values and history
- [`DPD`](entities/dpd.md) - Dollars Per Day calculations
- [`Thresholds`](entities/thresholds.md) - Jackpot thresholds

## Service Documentation

Business logic services:

- [`EncryptionService`](services/encryption-service.md) - Data encryption
- [`ForecastingService`](services/forecasting-service.md) - DPD forecasting
- [`DecisionEngine`](services/decision-engine.md) - Vision-based decisions
- [`WinDetector`](services/win-detector.md) - Win detection logic

## Integration Points

### MongoDB Collections
All repositories operate on MongoDB collections:
- `CRED3N7IAL` - Credentials
- `EV3NT` - Events and signals
- `ERR0R` - Errors
- `JACKP0T` - Jackpot history

### External Services
- **OBS WebSocket** - Vision stream (W4TCHD0G)
- **LM Studio** - Model inference (PROF3T)
- **Casino APIs** - FireKirin, OrionStars (H0UND/H4ND)

## Versioning

APIs follow semantic versioning:
- **Breaking changes** - New major version
- **New features** - New minor version
- **Bug fixes** - Patch version

Current version: **2.0.0**

## Deprecation Policy

- Deprecated interfaces marked with `[Obsolete]`
- 90-day migration period
- Migration guide provided

---

**Related**: [Data Models](../data-models/) | [Component Guides](../components/) | [Testing](../development/testing/)

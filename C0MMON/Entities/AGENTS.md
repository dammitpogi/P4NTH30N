# C0MMON/Entities

## Responsibility

Defines core domain models and data structures for the P4NTHE0N system. These entities represent fundamental business objects that persist in MongoDB and flow through all agents.

## When Working Here

- **Validation first**: All entities must implement IsValid(IStoreErrors?) method
- **Log validation errors**: Errors go to ERR0R collection, never auto-repair
- **BSON serialization aware**: Private field deserialization bypasses setters
- **Immutable core + mutable state**: Identity fields immutable, state fields mutable
- **Encapsulate domain logic**: Business methods within entities (e.g., Thresholds.NewGrand())

## Core Entities

| Entity | File | Description |
|--------|------|-------------|
| **Credential** | `Credential.cs` | User auth data, jackpot tracking, thresholds, DPD. Has `IsValid()` method. |
| **Signal** | `Signal.cs` | Priority-based automation triggers (1=Mini, 2=Minor, 3=Major, 4=Grand). Implements `ICloneable`. |
| **VisionCommand** | `VisionCommand.cs` | FourEyes integration commands with types (Spin, Stop, SwitchGame) and status tracking |
| **Jackpot** | `Jackpot.cs` | 4-tier jackpot system with DPD calculations, thresholds, ETA forecasting. Has `IsValid()` method. |
| **House** | `House.cs` | Physical location/grouping for credential organization |
| **Received** | `Received.cs` | Signal acknowledgment and processing tracking. Includes `ReceivedExt` extension methods. |
| **ErrorLog** | `ErrorLog.cs` | Validation failures and system errors. Has factory methods `Create()` and `FromException()`. |
| **ProcessEvent** | `EventLog.cs` | System events and processing milestones (named ProcessEvent to avoid conflict) |
| **NetworkAddress** | `NetworkAddress.cs` | IP/geolocation data with fallback services, includes `NetworkDiagnostics` |

### New Entities (2026-02-20)
- **AnomalyEvent.cs**: Event data for anomaly detection patterns
- **AutomationTrace.cs**: Trace logging for automation operations
- **TestResult.cs**: Test execution results container

## Entity Lifecycle

```
Creation → Validation → Persistence → Retrieval → Modification → Re-validation → Persistence
```

## Key Relationships

- Credential → House: Many-to-one relationship
- Signal → Credential: Targets specific credentials via House/Game/Username
- Jackpot → Credential: Embedded within credentials, uses DPD data for forecasting
- ErrorLog → Any Entity: References failing entities with context

## MongoDB Collections

- **CR3D3N7IAL**: Credential entities (user data, jackpots, thresholds)
- **EV3NT**: Signal, Received, ProcessEvent entities
- **ERR0R**: ErrorLog entities (validation failures)
- **H0U53**: House entities

## Validation Pattern

```csharp
// Entity with validation
public bool IsValid(IStoreErrors? errorLog = null)
{
    bool isValid = true;
    if (double.IsNaN(Current) || double.IsInfinity(Current))
    {
        errorLog?.Insert(ErrorLog.Create(ErrorType.ValidationError, $"Jackpot:{Game}/{Category}", 
            $"Invalid jackpot value: {Current}", ErrorSeverity.High));
        return false;
    }
    return isValid;
}
```

**Factory Methods (ErrorLog):**
```csharp
// Create validation error
ErrorLog.Create(ErrorType.ValidationError, source, message, ErrorSeverity.High)

// Create from exception
ErrorLog.FromException(ex, source, ErrorType.SystemError)
```

## Used By

- H4ND (credentials, signals, jackpots, errors)
- H0UND (signals, credentials for forecasting)
- C0MMON/Infrastructure (repository implementations)
- C0MMON/Services (dashboard and monitoring)

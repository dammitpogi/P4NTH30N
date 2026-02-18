# C0MMON/Entities

## Responsibility

Defines core domain models and data structures for the P4NTH30N system. These entities represent fundamental business objects that persist in MongoDB and flow through all agents.

## When Working Here

- **Validation first**: All entities must implement IsValid(IStoreErrors?) method
- **Log validation errors**: Errors go to ERR0R collection, never auto-repair
- **BSON serialization aware**: Private field deserialization bypasses setters
- **Immutable core + mutable state**: Identity fields immutable, state fields mutable
- **Encapsulate domain logic**: Business methods within entities (e.g., Thresholds.NewGrand())

## Core Entities

- **Credential**: User auth data, jackpot tracking, thresholds, DPD toggles
- **Signal**: Priority-based automation triggers (1=Mini, 2=Minor, 3=Major, 4=Grand)
- **Jackpot**: 4-tier jackpot system with current values and historical tracking
- **House**: Physical location/grouping for credential organization
- **Received**: Signal acknowledgment and processing tracking
- **ErrorLog**: Validation failures and system errors with context
- **EventLog**: System events and processing milestones

## Entity Lifecycle

```
Creation → Validation → Persistence → Retrieval → Modification → Re-validation → Persistence
```

## Key Relationships

- Credential → House: Many-to-one relationship
- Signal → Credential: Targets specific credentials via House/Game/Username
- Jackpot → Credential: Embedded within credentials
- ErrorLog → Any Entity: References failing entities with context

## MongoDB Collections

- **CR3D3N7IAL**: Credential entities (user data, jackpots, thresholds)
- **EV3NT**: Signal, Received, EventLog entities
- **ERR0R**: ErrorLog entities (validation failures)
- **H0U53**: House entities

## Validation Pattern

```csharp
public bool IsValid(IStoreErrors? errorLog = null)
{
    bool isValid = true;
    if (string.IsNullOrEmpty(RequiredField))
    {
        errorLog?.LogError($"[{nameof(Entity)}] Validation failed: RequiredField is null");
        isValid = false;
    }
    return isValid;
}
```

## Used By

- H4ND (credentials, signals, jackpots, errors)
- H0UND (signals, credentials for forecasting)
- C0MMON/Infrastructure (repository implementations)
- C0MMON/Services (dashboard and monitoring)

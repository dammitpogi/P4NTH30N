# C0MMON/Entities/
UpdateOn: 2026-02-23T12:02 AM

## Responsibility

C0MMON/Entities defines the core domain models and data structures for the P4NTH30N system. These entities represent the fundamental business objects that persist in MongoDB and flow through all agents, providing the data model foundation for automation, analytics, and monitoring.

**Core Entities:**
- **Credential**: User authentication data, jackpot tracking, thresholds, and DPD toggles
- **Signal**: Priority-based automation triggers (Mini/Minor/Major/Grand priorities)
- **Jackpot**: 4-tier jackpot system with current values and historical tracking
- **House**: Physical location/grouping for credential organization
- **Received**: Signal acknowledgment and processing tracking
- **NetworkAddress**: IP address and network configuration data
- **ErrorLog**: Validation failures and system errors with context
- **EventLog**: System events and processing milestones

## Design

**Key Patterns:**

1. **Validation-First Design**
   - All entities implement `IsValid(IStoreErrors?)` method
   - Validation errors logged to ERR0R collection, not auto-repaired
   - Null checks, range validation, and business rule enforcement

2. **MongoDB BSON Serialization**
   - Private field deserialization bypasses setters (BSON behavior)
   - Constructor initialization for required fields
   - Optional properties with default values

3. **Immutable Core + Mutable State**
   - Core identity fields (Ids, names) are immutable
   - State fields (balances, jackpots) are mutable with validation
   - Timestamp tracking for audit trails

4. **Domain Logic Encapsulation**
   - Business logic methods within entities (e.g., Thresholds.NewGrand())
   - State change operations with validation
   - Relationship management between entities

## Flow

```
Entity Lifecycle:
├── Creation (constructor with required fields)
├── Validation (IsValid method)
├── Persistence (MongoDB via repositories)
├── Retrieval (BSON deserialization)
├── Modification (business logic methods)
├── Re-validation (IsValid check)
└── Persistence (update back to database)

Credential Entity Flow:
├── Initialize with House/Game/Username
├── Set jackpots and thresholds
├── Validate all fields (IsValid)
├── Lock for processing (atomic operation)
├── Update balances/jackpots during automation
├── Detect jackpot drops (DPD toggles)
├── Reset thresholds when jackpots pop
├── Unlock and save state
└── Log validation errors if any
```

## Integration

**MongoDB Collections:**
- **CR3D3N7IAL**: Credential entities (user data, jackpots, thresholds)
- **EV3NT**: Signal, Received, EventLog entities (automation events)
- **ERR0R**: ErrorLog entities (validation failures, system errors)
- **H0U53**: House entities (location/grouping data)

**Key Relationships:**
- **Credential → House**: Many-to-one relationship for organization
- **Signal → Credential**: Signals target specific credentials via House/Game/Username
- **Jackpot → Credential**: Jackpot values embedded within credentials
- **ErrorLog → Any Entity**: Error context references failing entities

**Used By:**
- **H4ND**: Primary consumer (credentials, signals, jackpots, errors)
- **H0UND**: Analytics consumer (signals, credentials for forecasting)
- **C0MMON/Infrastructure**: Repository pattern implementations
- **C0MMON/Services**: Dashboard and monitoring services

**Validation Integration:**
- All entities validate via `IsValid(IStoreErrors?)` pattern
- Errors logged to ERR0R collection with line numbers and context
- Invalid entities are logged but not auto-repaired (data integrity)

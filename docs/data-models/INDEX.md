# Data Models

Complete documentation of MongoDB collections, document schemas, and entity relationships.

## Overview

P4NTH30N uses MongoDB as its primary data store. Data is organized into collections representing different domains:

```
MongoDB (P4NTH30N database)
├── CRED3N7IAL    - User credentials and settings
├── EV3NT         - Events, signals, and audit log
├── ERR0R         - Validation and processing errors
├── JACKP0T       - Jackpot historical data
├── G4ME          - Game configurations and thresholds
└── H0U53         - Platform/house definitions
```

## Collection Reference

| Collection | Purpose | Size Estimate | TTL |
|------------|---------|---------------|-----|
| **CRED3N7IAL** | Credential storage | Small (< 1MB) | No |
| **EV3NT** | Event log | Large (GBs) | 90 days |
| **ERR0R** | Error tracking | Medium | 30 days |
| **JACKP0T** | Historical data | Large | 1 year |
| **G4ME** | Game config | Small | No |
| **H0U53** | Platform config | Small | No |

## Document Schemas

### CRED3N7IAL Collection

User credentials, balances, and jackpot tracking.

**Key Fields:**
- `_id` (string) - Username (primary key)
- `Password` (string) - Encrypted password
- `House` (string) - Platform name
- `Balance` (double) - Current balance
- `Enabled` (bool) - Active status
- `Thresholds` (object) - Jackpot thresholds
- `DPD` (object) - Dollars Per Day data

📖 **[Full Schema →](schemas/CRED3N7IAL.md)**

### EV3NT Collection

Event log for audit trail and signal tracking.

**Key Fields:**
- `_id` (ObjectId) - Event ID
- `Agent` (string) - Source agent (H0UND/H4ND/W4TCHD0G)
- `Action` (string) - Event type
- `Timestamp` (DateTime) - Event time
- `Metadata` (object) - Event-specific data

📖 **[Full Schema →](schemas/EV3NT.md)**

### ERR0R Collection

Validation and processing errors.

**Key Fields:**
- `_id` (ObjectId) - Error ID
- `Entity` (string) - Entity type
- `Field` (string) - Field with error
- `Error` (string) - Error message
- `User` (string) - Related user
- `StackTrace` (string) - Stack trace
- `Timestamp` (DateTime) - Error time

📖 **[Full Schema →](schemas/ERR0R.md)**

### JACKP0T Collection

Historical jackpot data for forecasting.

**Key Fields:**
- `_id` (ObjectId) - Record ID
- `CredentialId` (string) - Related credential
- `Grand`, `Major`, `Minor`, `Mini` (double) - Tier values
- `Timestamp` (DateTime) - Sample time

📖 **[Full Schema →](schemas/JACKP0T.md)**

### G4ME Collection

Game configurations and thresholds.

**Key Fields:**
- `_id` (string) - Game ID
- `Game` (string) - Game name
- `House` (string) - Platform name
- `Thresholds` (object) - Jackpot thresholds
- `Settings` (object) - Game-specific settings

📖 **[Full Schema →](schemas/G4ME.md)**

### H0U53 Collection

Platform (house) definitions.

**Key Fields:**
- `_id` (string) - Platform ID
- `Name` (string) - Display name
- `Platform` (string) - Platform type (FireKirin/OrionStars)
- `Url` (string) - Platform URL
- `Configuration` (object) - Connection settings

📖 **[Full Schema →](schemas/H0U53.md)**

## Entity Relationships

```
┌─────────────┐     1:N     ┌─────────────┐
│   H0U53     │─────────────│  CRED3N7IAL │
│  (Platform) │             │ (Credential)│
└─────────────┘             └──────┬──────┘
                                   │
                                   │ 1:N
                                   ▼
                            ┌─────────────┐
                            │   JACKP0T   │
                            │   (History) │
                            └─────────────┘
                                   │
                                   │ 1:N
                                   ▼
                            ┌─────────────┐
                            │    EV3NT    │
                            │   (Events)  │
                            └─────────────┘

┌─────────────┐     N:1     ┌─────────────┐
│    G4ME     │─────────────│   H0U53     │
│   (Games)   │             │  (Platform) │
└─────────────┘             └─────────────┘
```

## Data Flow

### Write Operations
1. **H0UND** writes jackpot data → `JACKP0T`
2. **H0UND** writes signals → `EV3NT` (as SIGN4L)
3. **H4ND** writes events → `EV3NT`
4. **H4ND** updates balances → `CRED3N7IAL`
5. All agents write errors → `ERR0R`

### Read Operations
1. **H0UND** reads credentials → `CRED3N7IAL`
2. **H4ND** reads signals → `EV3NT` (SIGN4L view)
3. **H4ND** reads credentials → `CRED3N7IAL`
4. **All** read thresholds → `G4ME`

## Indexing Strategy

### CRED3N7IAL
```javascript
{ _id: 1 }                           // Primary key
db.CRED3N7IAL.createIndex({ "House": 1 })
db.CRED3N7IAL.createIndex({ "Enabled": 1 })
```

### EV3NT
```javascript
{ _id: 1 }                           // Primary key
db.EV3NT.createIndex({ "Agent": 1, "Timestamp": -1 })
db.EV3NT.createIndex({ "Action": 1, "Timestamp": -1 })
db.EV3NT.createIndex({ "Timestamp": 1 }, { expireAfterSeconds: 7776000 })  // 90 days TTL
```

### ERR0R
```javascript
{ _id: 1 }                           // Primary key
db.ERR0R.createIndex({ "Entity": 1, "Timestamp": -1 })
db.ERR0R.createIndex({ "Timestamp": 1 }, { expireAfterSeconds: 2592000 })  // 30 days TTL
```

### JACKP0T
```javascript
{ _id: 1 }                           // Primary key
db.JACKP0T.createIndex({ "CredentialId": 1, "Timestamp": -1 })
db.JACKP0T.createIndex({ "Timestamp": 1 }, { expireAfterSeconds: 31536000 })  // 1 year TTL
```

## Data Retention

| Collection | Retention | Cleanup |
|------------|-----------|---------|
| CRED3N7IAL | Forever | Manual |
| EV3NT | 90 days | MongoDB TTL |
| ERR0R | 30 days | MongoDB TTL |
| JACKP0T | 1 year | MongoDB TTL |
| G4ME | Forever | Manual |
| H0U53 | Forever | Manual |

## Validation Rules

### CRED3N7IAL Validation
```javascript
{
  $jsonSchema: {
    bsonType: "object",
    required: ["_id", "Password", "House"],
    properties: {
      Balance: {
        bsonType: "double",
        minimum: 0
      },
      Enabled: {
        bsonType: "bool"
      }
    }
  }
}
```

## Backup Considerations

### Critical Data (Daily Backup)
- `CRED3N7IAL` - Cannot be recreated
- `G4ME` - Configuration
- `H0U53` - Platform settings

### Historical Data (Weekly Backup)
- `JACKP0T` - Can be regenerated by polling

### Transient Data (No Backup)
- `EV3NT` - Audit logs only
- `ERR0R` - Debug information

📖 **[Backup Procedures →](../operations/procedures/backup-restore.md)**

## Migration History

### v1 → v2 (Current)
- Credential-centric architecture
- Added encryption
- New DPD structure

📖 **[Migration Guide →](../reference/migration/)**

---

**Related**: [API Reference](../api-reference/) | [Entities](../api-reference/entities/) | [MongoDB Docs](https://docs.mongodb.com/)

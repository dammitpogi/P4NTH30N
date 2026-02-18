# EV3NT Collection Schema

Event log and audit trail for all system activities.

## Purpose

EV3NT serves as the central audit log for P4NTH30N. All agents (H0UND, H4ND, W4TCHD0G) write events here for:
- Signal generation and processing
- Automation actions
- Win detection
- Error recovery
- Health status

## Document Structure

```json
{
  "_id": ObjectId("..."),
  "Agent": "H4ND",
  "Action": "Spin",
  "Username": "casino_user",
  "House": "FireKirin",
  "Timestamp": "2026-01-15T10:30:00Z",
  "Metadata": {
    "BalanceChange": 25.50,
    "Tier": 4,
    "Game": "Slots"
  },
  "Severity": "Info",
  "CorrelationId": "abc-123-def"
}
```

## Field Reference

### Core Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `_id` | ObjectId | Yes | MongoDB primary key |
| `Agent` | string | Yes | Source agent (H0UND, H4ND, W4TCHD0G) |
| `Action` | string | Yes | Event type/action |
| `Username` | string | No | Related credential username |
| `House` | string | No | Related platform/house |
| `Timestamp` | DateTime | Yes | Event occurrence time |
| `Metadata` | object | No | Event-specific data |
| `Severity` | string | Yes | Event severity level |
| `CorrelationId` | string | No | Cross-event correlation ID |

### Agent Values

| Value | Description |
|-------|-------------|
| `H0UND` | Analytics and polling agent |
| `H4ND` | Automation agent |
| `W4TCHD0G` | Vision and safety agent |
| `SYSTEM` | System-level events |

### Action Types

#### H0UND Actions

| Action | Description | Metadata Fields |
|--------|-------------|-----------------|
| `PollingComplete` | Polling cycle finished | `CredentialsPolled`, `DurationMs` |
| `AnalyticsComplete` | Analytics run completed | `SignalsGenerated`, `DurationMs` |
| `SignalGenerated` | New signal created | `Priority`, `Threshold`, `CurrentValue` |
| `DPDCalculated` | DPD values updated | `GrandDPD`, `MajorDPD`, etc. |
| `ThresholdAdjusted` | Thresholds modified | `OldValue`, `NewValue`, `Reason` |

#### H4ND Actions

| Action | Description | Metadata Fields |
|--------|-------------|-----------------|
| `Login` | Successfully logged in | `DurationMs` |
| `Logout` | Session ended | `DurationMs`, `FinalBalance` |
| `Spin` | Slot spin executed | `BalanceChange`, `Tier`, `Result` |
| `JackpotPopDetected` | Jackpot reset detected | `Tier`, `OldValue`, `NewValue` |
| `CredentialLocked` | Credential acquired lock | - |
| `CredentialUnlocked` | Credential released lock | - |

#### W4TCHD0G Actions

| Action | Description | Metadata Fields |
|--------|-------------|-----------------|
| `WinDetected` | Win confirmed | `Amount`, `Tier`, `Confidence` |
| `KillSwitchActivated` | Safety kill switch triggered | `Reason`, `DailySpent` |
| `SafetyAlert` | Safety threshold approached | `Metric`, `Value`, `Threshold` |
| `FrameProcessed` | Vision frame analyzed | `LatencyMs`, `Detections` |
| `StreamConnected` | OBS stream established | `Source` |
| `StreamDisconnected` | OBS stream lost | `Reason` |

#### System Actions

| Action | Description | Metadata Fields |
|--------|-------------|-----------------|
| `Startup` | Agent started | `Version`, `Environment` |
| `Shutdown` | Agent stopped | `Reason`, `UptimeSeconds` |
| `HealthCheck` | Health check executed | `Status`, `Components` |
| `Error` | Error occurred | `Error`, `StackTrace` |

### Severity Levels

| Level | Description | Example |
|-------|-------------|---------|
| `Critical` | System failure | Kill switch activated |
| `Error` | Operational error | Login failed |
| `Warning` | Attention needed | High error rate |
| `Info` | Normal operation | Spin completed |
| `Debug` | Detailed info | Frame processed |

## Validation Rules

### Required Fields
```javascript
{
  $jsonSchema: {
    bsonType: "object",
    required: ["Agent", "Action", "Timestamp", "Severity"],
    properties: {
      Agent: {
        enum: ["H0UND", "H4ND", "W4TCHD0G", "SYSTEM"]
      },
      Timestamp: {
        bsonType: "date"
      },
      Severity: {
        enum: ["Critical", "Error", "Warning", "Info", "Debug"]
      }
    }
  }
}
```

## Indexes

```javascript
// Primary key (automatic)
{ _id: 1 }

// Agent queries
db.EV3NT.createIndex({ "Agent": 1, "Timestamp": -1 })

// Action queries
db.EV3NT.createIndex({ "Action": 1, "Timestamp": -1 })

// User activity
db.EV3NT.createIndex({ "Username": 1, "Timestamp": -1 })

// Time-based queries (supports TTL)
db.EV3NT.createIndex({ "Timestamp": 1 })

// Correlation tracking
db.EV3NT.createIndex({ "CorrelationId": 1 })
```

## Common Queries

### Get Recent Events
```javascript
// Last 100 events
db.EV3NT.find()
  .sort({ "Timestamp": -1 })
  .limit(100)

// Last hour
db.EV3NT.find({
  "Timestamp": { 
    $gte: new Date(Date.now() - 60 * 60 * 1000) 
  }
})
```

### Get Events by Agent
```javascript
// All H4ND events
db.EV3NT.find({
  "Agent": "H4ND"
}).sort({ "Timestamp": -1 })

// H4ND spin events
db.EV3NT.find({
  "Agent": "H4ND",
  "Action": "Spin"
}).sort({ "Timestamp": -1 })
```

### Get User Activity
```javascript
// All activity for user
db.EV3NT.find({
  "Username": "myuser"
}).sort({ "Timestamp": -1 })

// User wins
db.EV3NT.find({
  "Username": "myuser",
  "Action": "WinDetected"
})
```

### Get Safety Events
```javascript
// All kill switch activations
db.EV3NT.find({
  "Action": "KillSwitchActivated"
}).sort({ "Timestamp": -1 })

// Recent safety alerts
db.EV3NT.find({
  "Action": "SafetyAlert",
  "Timestamp": { $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) }
})
```

### Aggregation Examples

#### Event Count by Hour
```javascript
db.EV3NT.aggregate([
  {
    $match: {
      "Timestamp": { $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) }
    }
  },
  {
    $group: {
      _id: {
        $hour: "$Timestamp"
      },
      count: { $sum: 1 }
    }
  },
  { $sort: { _id: 1 } }
])
```

#### Win Summary by User
```javascript
db.EV3NT.aggregate([
  {
    $match: {
      "Action": "WinDetected"
    }
  },
  {
    $group: {
      _id: "$Username",
      totalWins: { $sum: 1 },
      totalAmount: { $sum: "$Metadata.Amount" },
      lastWin: { $max: "$Timestamp" }
    }
  }
])
```

#### Error Rate by Agent
```javascript
db.EV3NT.aggregate([
  {
    $match: {
      "Timestamp": { $gte: new Date(Date.now() - 60 * 60 * 1000) },
      "Severity": { $in: ["Critical", "Error"] }
    }
  },
  {
    $group: {
      _id: "$Agent",
      errorCount: { $sum: 1 }
    }
  }
])
```

## Data Retention

| Aspect | Value |
|--------|-------|
| **Retention Period** | 90 days |
| **Cleanup Method** | MongoDB TTL index |
| **Archive Strategy** | Export to cold storage before deletion |

### TTL Configuration
```javascript
db.EV3NT.createIndex(
  { "Timestamp": 1 },
  { expireAfterSeconds: 7776000 }  // 90 days
)
```

## Code Examples

### Writing Events (C#)
```csharp
// Simple event
await eventStore.StoreEventAsync(new Event
{
    Agent = "H4ND",
    Action = "Spin",
    Username = credential.Id,
    House = credential.House,
    Timestamp = DateTime.UtcNow,
    Severity = "Info",
    Metadata = new
    {
        BalanceChange = change,
        Tier = signal.Priority,
        Game = "Slots"
    }
});

// Event with correlation
var correlationId = Guid.NewGuid().ToString();

await eventStore.StoreEventAsync(new Event
{
    Agent = "H4ND",
    Action = "Login",
    CorrelationId = correlationId,
    // ...
});

await eventStore.StoreEventAsync(new Event
{
    Agent = "H4ND",
    Action = "Spin",
    CorrelationId = correlationId,
    // ...
});
```

### Querying Events (C#)
```csharp
// Recent events
var recent = await eventRepo.GetRecentAsync(TimeSpan.FromHours(1));

// By agent
var h4ndEvents = await eventRepo.GetByAgentAsync("H4ND", limit: 100);

// By user
var userActivity = await eventRepo.GetByUserAsync("myuser", 
    DateTime.UtcNow.AddDays(-7));

// Wins only
var wins = await eventRepo.FindAsync(e => 
    e.Action == "WinDetected" && 
    e.Timestamp >= DateTime.UtcNow.AddDays(-1));
```

## Event Sourcing Pattern

EV3NT can be used for event sourcing to reconstruct state:

```csharp
public class CredentialStateRebuilder
{
    public async Task<CredentialState> RebuildAsync(string username, 
        DateTime upTo)
    {
        var events = await eventRepo.GetByUserAsync(username, upTo);
        
        var state = new CredentialState();
        
        foreach (var evt in events.OrderBy(e => e.Timestamp))
        {
            ApplyEvent(state, evt);
        }
        
        return state;
    }
    
    private void ApplyEvent(CredentialState state, Event evt)
    {
        switch (evt.Action)
        {
            case "Login":
                state.LastLogin = evt.Timestamp;
                break;
            case "Spin":
                state.Balance += evt.Metadata.BalanceChange;
                state.TotalSpins++;
                break;
            case "WinDetected":
                state.TotalWins++;
                state.TotalWinAmount += evt.Metadata.Amount;
                break;
        }
    }
}
```

## Integration Points

### Written By
- **H0UND**: Polling events, analytics, signals
- **H4ND**: Automation actions, spins, logins
- **W4TCHD0G**: Safety events, win detections
- **All Agents**: Errors, health checks

### Read By
- **Dashboard**: Real-time activity display
- **Monitoring**: Health and alerting
- **Analytics**: Historical analysis
- **Debugging**: Troubleshooting

## Best Practices

1. **Always Set Timestamp**: Use UTC to avoid timezone issues
2. **Include Context**: Add relevant metadata for debugging
3. **Use Correlation IDs**: Track related events across time
4. **Appropriate Severity**: Don't spam with Debug in production
5. **Clean Metadata**: Don't include sensitive data (passwords)

## Troubleshooting

### Missing Events
1. Check agent logging configuration
2. Verify MongoDB connectivity
3. Check for validation errors
4. Review agent logs

### Too Many Events
1. Adjust log levels (reduce Debug)
2. Increase batching
3. Review retention policy
4. Archive older events

### Query Performance
1. Ensure indexes exist
2. Use time-based filters
3. Limit result sets
4. Consider aggregation pipeline

---

**Related**: [Data Models Overview](../INDEX.md) | [ERR0R Collection](ERR0R.md) | [CRED3N7IAL Collection](CRED3N7IAL.md)

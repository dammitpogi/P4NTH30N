# ERR0R Collection Schema

Validation errors and processing failures tracking.

## Purpose

ERR0R captures all validation failures and processing errors across the system. Unlike EV3NT (which tracks normal operations), ERR0R specifically tracks things that went wrong for monitoring and debugging purposes.

## Document Structure

```json
{
  "_id": ObjectId("..."),
  "Entity": "Credential",
  "Field": "Balance",
  "Error": "Balance is negative: -50.00",
  "User": "casino_user",
  "Agent": "H4ND",
  "StackTrace": "at P4NTHE0N.C0MMON.Entities.Credential.IsValid...",
  "Severity": "Warning",
  "Timestamp": "2026-01-15T10:30:00Z",
  "CorrelationId": "abc-123-def"
}
```

## Field Reference

### Core Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `_id` | ObjectId | Yes | MongoDB primary key |
| `Entity` | string | Yes | Entity type that failed validation |
| `Field` | string | No | Specific field with error (if applicable) |
| `Error` | string | Yes | Human-readable error message |
| `User` | string | No | Related credential username |
| `Agent` | string | No | Agent where error occurred |
| `StackTrace` | string | No | Exception stack trace (if exception) |
| `Severity` | string | Yes | Error severity |
| `Timestamp` | DateTime | Yes | Error occurrence time |
| `CorrelationId` | string | No | Cross-event correlation ID |

### Entity Types

| Value | Description |
|-------|-------------|
| `Credential` | User credential entity |
| `Signal` | Automation signal entity |
| `Jackpot` | Jackpot value entity |
| `DPD` | Dollars Per Day data |
| `Thresholds` | Threshold configuration |
| `System` | System-level error |

### Severity Levels

| Level | Description | Action Required |
|-------|-------------|-----------------|
| `Critical` | Data corruption, system failure | Immediate investigation |
| `Error` | Validation failed, processing error | Review and fix |
| `Warning` | Suspicious data, edge case | Monitor |
| `Info` | Minor issue, already handled | Log only |

## Common Error Patterns

### Validation Errors

| Entity | Field | Error Pattern | Cause |
|--------|-------|---------------|-------|
| `Credential` | `Balance` | "Balance is NaN or Infinity" | API returned invalid value |
| `Credential` | `Balance` | "Balance is negative: X" | Data corruption |
| `Credential` | `Password` | "Password is null or empty" | Encryption failure |
| `Credential` | `Jackpots.Grand` | "Grand jackpot invalid" | Game not loaded |
| `Signal` | `Priority` | "Invalid priority: X" | Corrupted signal |

### Processing Errors

| Entity | Error Pattern | Cause |
|--------|---------------|-------|
| `Credential` | "Failed to decrypt password" | Wrong master key |
| `Credential` | "Login failed after 3 retries" | Wrong password |
| `System` | "MongoDB connection failed" | Database down |
| `System` | "ChromeDriver not found" | Driver missing |

## Validation Rules

```javascript
{
  $jsonSchema: {
    bsonType: "object",
    required: ["Entity", "Error", "Timestamp", "Severity"],
    properties: {
      Entity: {
        enum: ["Credential", "Signal", "Jackpot", "DPD", "Thresholds", "System"]
      },
      Timestamp: {
        bsonType: "date"
      },
      Severity: {
        enum: ["Critical", "Error", "Warning", "Info"]
      }
    }
  }
}
```

## Indexes

```javascript
// Primary key (automatic)
{ _id: 1 }

// Entity queries
db.ERR0R.createIndex({ "Entity": 1, "Timestamp": -1 })

// User errors
db.ERR0R.createIndex({ "User": 1, "Timestamp": -1 })

// Agent errors
db.ERR0R.createIndex({ "Agent": 1, "Timestamp": -1 })

// Time-based (supports TTL)
db.ERR0R.createIndex({ "Timestamp": 1 })

// Severity queries
db.ERR0R.createIndex({ "Severity": 1, "Timestamp": -1 })
```

## Common Queries

### Recent Errors
```javascript
// Last 50 errors
db.ERR0R.find()
  .sort({ "Timestamp": -1 })
  .limit(50)

// Last hour
db.ERR0R.find({
  "Timestamp": { 
    $gte: new Date(Date.now() - 60 * 60 * 1000) 
  }
})
```

### Errors by Entity
```javascript
// All Credential validation errors
db.ERR0R.find({
  "Entity": "Credential"
}).sort({ "Timestamp": -1 })

// Specific field errors
db.ERR0R.find({
  "Entity": "Credential",
  "Field": "Balance"
})
```

### Critical Errors
```javascript
// All critical errors
db.ERR0R.find({
  "Severity": "Critical"
}).sort({ "Timestamp": -1 })

// Recent critical
db.ERR0R.find({
  "Severity": "Critical",
  "Timestamp": { $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) }
})
```

### User Errors
```javascript
// All errors for user
db.ERR0R.find({
  "User": "myuser"
}).sort({ "Timestamp": -1 })

// User balance errors
db.ERR0R.find({
  "User": "myuser",
  "Field": "Balance"
})
```

### Error Rate Analysis
```javascript
// Error count by hour
db.ERR0R.aggregate([
  {
    $match: {
      "Timestamp": { $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) }
    }
  },
  {
    $group: {
      _id: {
        hour: { $hour: "$Timestamp" },
        severity: "$Severity"
      },
      count: { $sum: 1 }
    }
  },
  { $sort: { "_id.hour": 1 } }
])
```

### Most Common Errors
```javascript
// Top 10 error patterns
db.ERR0R.aggregate([
  {
    $match: {
      "Timestamp": { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) }
    }
  },
  {
    $group: {
      _id: "$Error",
      count: { $sum: 1 },
      lastOccurrence: { $max: "$Timestamp" }
    }
  },
  { $sort: { count: -1 } },
  { $limit: 10 }
])
```

## Data Retention

| Aspect | Value |
|--------|-------|
| **Retention Period** | 30 days |
| **Cleanup Method** | MongoDB TTL index |
| **Critical Retention** | 90 days (separate archive) |

### TTL Configuration
```javascript
db.ERR0R.createIndex(
  { "Timestamp": 1 },
  { expireAfterSeconds: 2592000 }  // 30 days
)
```

## Code Examples

### Logging Errors (C#)
```csharp
// Via IStoreErrors interface
await errorStore.LogErrorAsync(new ErrorLog
{
    Entity = nameof(Credential),
    Field = nameof(Credential.Balance),
    Error = $"Balance is negative: {credential.Balance}",
    User = credential.Id,
    Agent = "H4ND",
    Severity = "Warning",
    Timestamp = DateTime.UtcNow
});

// With exception
await errorStore.LogErrorAsync(new ErrorLog
{
    Entity = "System",
    Error = "MongoDB connection failed",
    StackTrace = ex.ToString(),
    Agent = "H0UND",
    Severity = "Critical",
    Timestamp = DateTime.UtcNow
});

// During validation
if (!credential.IsValid(errorStore))
{
    // Error automatically logged via errorStore
    return false;
}
```

### Error Repository Implementation
```csharp
public class ErrorLogRepository : IStoreErrors
{
    private readonly IMongoCollection<ErrorLog> _collection;
    
    public async Task LogErrorAsync(ErrorLog error)
    {
        await _collection.InsertOneAsync(error);
    }
    
    public async Task LogError(string message)
    {
        await _collection.InsertOneAsync(new ErrorLog
        {
            Entity = "System",
            Error = message,
            Severity = "Error",
            Timestamp = DateTime.UtcNow
        });
    }
    
    public async Task<IEnumerable<ErrorLog>> GetRecentAsync(TimeSpan timeSpan)
    {
        return await _collection
            .Find(e => e.Timestamp >= DateTime.UtcNow.Subtract(timeSpan))
            .SortByDescending(e => e.Timestamp)
            .ToListAsync();
    }
    
    public async Task<IEnumerable<ErrorLog>> GetByUserAsync(string username, 
        TimeSpan? timeSpan = null)
    {
        var filter = Builders<ErrorLog>.Filter.Eq(e => e.User, username);
        
        if (timeSpan.HasValue)
        {
            filter = filter & Builders<ErrorLog>.Filter.Gte(
                e => e.Timestamp, 
                DateTime.UtcNow.Subtract(timeSpan.Value));
        }
        
        return await _collection
            .Find(filter)
            .SortByDescending(e => e.Timestamp)
            .ToListAsync();
    }
    
    public async Task<long> GetErrorCountAsync(TimeSpan timeSpan, 
        string? severity = null)
    {
        var filter = Builders<ErrorLog>.Filter.Gte(
            e => e.Timestamp, 
            DateTime.UtcNow.Subtract(timeSpan));
        
        if (!string.IsNullOrEmpty(severity))
        {
            filter = filter & Builders<ErrorLog>.Filter.Eq(
                e => e.Severity, severity);
        }
        
        return await _collection.CountDocumentsAsync(filter);
    }
}
```

### Health Check Using Errors
```csharp
public class HealthCheckService
{
    private readonly IStoreErrors _errorStore;
    
    public async Task<HealthStatus> CheckErrorRateAsync()
    {
        // Count errors in last 5 minutes
        var recentErrors = await _errorStore.GetErrorCountAsync(
            TimeSpan.FromMinutes(5));
        
        // Count critical errors
        var criticalErrors = await _errorStore.GetErrorCountAsync(
            TimeSpan.FromMinutes(5), 
            "Critical");
        
        if (criticalErrors > 0)
        {
            return HealthStatus.Critical;
        }
        
        if (recentErrors > 20)
        {
            return HealthStatus.Degraded;
        }
        
        if (recentErrors > 10)
        {
            return HealthStatus.Warning;
        }
        
        return HealthStatus.Healthy;
    }
}
```

## Error Monitoring Dashboard

### Key Metrics

```javascript
// Current error rate (per hour)
db.ERR0R.aggregate([
  { $match: { "Timestamp": { $gte: new Date(Date.now() - 60 * 60 * 1000) } } },
  { $group: { _id: null, count: { $sum: 1 } } }
])

// Error rate by entity
db.ERR0R.aggregate([
  { $match: { "Timestamp": { $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) } } },
  { $group: { _id: "$Entity", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])

// Error trend (last 7 days)
db.ERR0R.aggregate([
  { $match: { "Timestamp": { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) } } },
  {
    $group: {
      _id: { $dateToString: { format: "%Y-%m-%d", date: "$Timestamp" } },
      count: { $sum: 1 }
    }
  },
  { $sort: { _id: 1 } }
])
```

## Integration Points

### Written By
- **All Validated Repositories**: Validation failures
- **H0UND**: API errors, processing failures
- **H4ND**: Automation errors, browser failures
- **W4TCHD0G**: Vision processing errors
- **C0MMON**: Encryption errors, infrastructure failures

### Read By
- **Health Monitoring**: Error rate tracking
- **Dashboards**: Error displays
- **Alerting**: Critical error notifications
- **Debugging**: Troubleshooting support

## Best Practices

1. **Always Log Validation Failures**: Don't silently drop invalid data
2. **Include Context**: Username, agent, correlation ID for tracing
3. **Use Appropriate Severity**: Reserve Critical for system failures
4. **Don't Log Sensitive Data**: No passwords, tokens, keys
5. **Monitor Error Rates**: Alert on spikes
6. **Review Regularly**: Weekly error analysis

## Troubleshooting

### High Error Rate
1. Check for recent deployments
2. Review error patterns
3. Check external dependencies
4. Verify data sources

### Missing Errors
1. Check logging configuration
2. Verify MongoDB connectivity
3. Review error filter settings
4. Check agent status

### Storage Issues
1. Monitor collection size
2. Verify TTL working
3. Check index performance
4. Archive old errors

---

**Related**: [Data Models Overview](../INDEX.md) | [EV3NT Collection](EV3NT.md) | [CRED3N7IAL Collection](CRED3N7IAL.md)

# JACKP0T Collection Schema

Historical jackpot data for forecasting and analytics.

## Purpose

JACKP0T stores time-series data of jackpot values across all tiers. This historical data enables DPD (Dollars Per Day) calculations, trend analysis, and predictive forecasting.

## Document Structure

```json
{
  "_id": ObjectId("..."),
  "CredentialId": "casino_user",
  "House": "FireKirin",
  "Grand": 1500.00,
  "Major": 400.00,
  "Minor": 80.00,
  "Mini": 15.00,
  "Timestamp": "2026-01-15T10:30:00Z",
  "DPD": {
    "Grand": 150.5,
    "Major": 45.2,
    "Minor": 12.8,
    "Mini": 3.5
  }
}
```

## Field Reference

### Core Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `_id` | ObjectId | Yes | MongoDB primary key |
| `CredentialId` | string | Yes | Reference to CRED3N7IAL |
| `House` | string | Yes | Platform/house name |
| `Grand` | double | Yes | Grand jackpot value |
| `Major` | double | Yes | Major jackpot value |
| `Minor` | double | Yes | Minor jackpot value |
| `Mini` | double | Yes | Mini jackpot value |
| `Timestamp` | DateTime | Yes | Sample timestamp |
| `DPD` | object | No | Calculated DPD values |

### DPD Sub-Document

| Field | Type | Description |
|-------|------|-------------|
| `DPD.Grand` | double | Grand tier DPD rate |
| `DPD.Major` | double | Major tier DPD rate |
| `DPD.Minor` | double | Minor tier DPD rate |
| `DPD.Mini` | double | Mini tier DPD rate |

## Validation Rules

```javascript
{
  $jsonSchema: {
    bsonType: "object",
    required: ["CredentialId", "House", "Grand", "Major", "Minor", "Mini", "Timestamp"],
    properties: {
      CredentialId: { bsonType: "string" },
      House: { bsonType: "string" },
      Grand: { bsonType: "double", minimum: 0 },
      Major: { bsonType: "double", minimum: 0 },
      Minor: { bsonType: "double", minimum: 0 },
      Mini: { bsonType: "double", minimum: 0 },
      Timestamp: { bsonType: "date" }
    }
  }
}
```

## Indexes

```javascript
// Primary key (automatic)
{ _id: 1 }

// Time-series queries
db.JACKP0T.createIndex({ "CredentialId": 1, "Timestamp": -1 })

// Platform analysis
db.JACKP0T.createIndex({ "House": 1, "Timestamp": -1 })

// Recent data
db.JACKP0T.createIndex({ "Timestamp": -1 })

// TTL (old data cleanup)
db.JACKP0T.createIndex({ "Timestamp": 1 })
```

## Common Queries

### Recent History
```javascript
// Last 7 days for user
db.JACKP0T.find({
  "CredentialId": "myuser",
  "Timestamp": { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) }
}).sort({ "Timestamp": -1 })

// Last 100 samples
db.JACKP0T.find({
  "CredentialId": "myuser"
}).sort({ "Timestamp": -1 }).limit(100)
```

### Aggregations

#### Average Jackpot Values
```javascript
db.JACKP0T.aggregate([
  {
    $match: {
      "CredentialId": "myuser",
      "Timestamp": { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) }
    }
  },
  {
    $group: {
      _id: null,
      avgGrand: { $avg: "$Grand" },
      avgMajor: { $avg: "$Major" },
      avgMinor: { $avg: "$Minor" },
      avgMini: { $avg: "$Mini" }
    }
  }
])
```

#### Daily Trends
```javascript
db.JACKP0T.aggregate([
  {
    $match: {
      "Timestamp": { $gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) }
    }
  },
  {
    $group: {
      _id: {
        date: { $dateToString: { format: "%Y-%m-%d", date: "$Timestamp" } },
        user: "$CredentialId"
      },
      maxGrand: { $max: "$Grand" },
      minGrand: { $min: "$Grand" }
    }
  },
  { $sort: { "_id.date": 1 } }
])
```

#### DPD Calculation
```javascript
// Calculate DPD for last 7 days
db.JACKP0T.aggregate([
  {
    $match: {
      "CredentialId": "myuser",
      "Timestamp": { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) }
    }
  },
  {
    $sort: { "Timestamp": 1 }
  },
  {
    $group: {
      _id: "$CredentialId",
      firstGrand: { $first: "$Grand" },
      lastGrand: { $last: "$Grand" },
      days: { 
        $avg: {
          $divide: [
            { $subtract: [{ $max: "$Timestamp" }, { $min: "$Timestamp" }] },
            1000 * 60 * 60 * 24
          ]
        }
      }
    }
  },
  {
    $project: {
      grandDPD: {
        $divide: [
          { $subtract: ["$lastGrand", "$firstGrand"] },
          "$days"
        ]
      }
    }
  }
])
```

## Data Retention

| Aspect | Value |
|--------|-------|
| **Retention Period** | 1 year |
| **Cleanup Method** | MongoDB TTL index |
| **Sampling Rate** | Every 30-60 seconds (configurable) |
| **Estimated Size** | ~10MB per user per year |

### TTL Configuration
```javascript
db.JACKP0T.createIndex(
  { "Timestamp": 1 },
  { expireAfterSeconds: 31536000 }  // 1 year
)
```

## Code Examples

### Recording Jackpot Data (C#)
```csharp
public async Task RecordJackpotAsync(Credential credential)
{
    var jackpot = new Jackpot
    {
        CredentialId = credential.Id,
        House = credential.House,
        Grand = credential.Jackpots.Grand,
        Major = credential.Jackpots.Major,
        Minor = credential.Jackpots.Minor,
        Mini = credential.Jackpots.Mini,
        Timestamp = DateTime.UtcNow,
        DPD = new DPDValues
        {
            Grand = credential.DPD.GrandDPD,
            Major = credential.DPD.MajorDPD,
            Minor = credential.DPD.MinorDPD,
            Mini = credential.DPD.MiniDPD
        }
    };
    
    await jackpotRepo.AddAsync(jackpot);
}
```

### Calculating DPD (C#)
```csharp
public async Task<DPD> CalculateDPDAsync(string credentialId, int days = 7)
{
    var history = await jackpotRepo.GetHistoryAsync(
        credentialId, 
        DateTime.UtcNow.AddDays(-days));
    
    if (history.Count() < 2)
    {
        return new DPD(); // Not enough data
    }
    
    var ordered = history.OrderBy(h => h.Timestamp).ToList();
    var first = ordered.First();
    var last = ordered.Last();
    var actualDays = (last.Timestamp - first.Timestamp).TotalDays;
    
    if (actualDays < 1) actualDays = 1;
    
    return new DPD
    {
        GrandDPD = (last.Grand - first.Grand) / actualDays,
        MajorDPD = (last.Major - first.Major) / actualDays,
        MinorDPD = (last.Minor - first.Minor) / actualDays,
        MiniDPD = (last.Mini - first.Mini) / actualDays
    };
}
```

### Detecting Jackpot Pops
```csharp
public async Task DetectJackpotPopAsync(string credentialId)
{
    // Get last 2 samples
    var recent = await jackpotRepo.GetRecentAsync(credentialId, 2);
    
    if (recent.Count() < 2) return;
    
    var current = recent.First();
    var previous = recent.Skip(1).First();
    
    // Check for Grand pop
    if (current.Grand < previous.Grand * 0.9) // 10% drop
    {
        await eventStore.StoreEventAsync(new Event
        {
            Agent = "H0UND",
            Action = "JackpotPopDetected",
            Username = credentialId,
            Metadata = new
            {
                Tier = "Grand",
                PreviousValue = previous.Grand,
                CurrentValue = current.Grand
            }
        });
    }
}
```

## Integration Points

### Written By
- **H0UND**: Polling results
- **H4ND**: Automation snapshots

### Read By
- **H0UND**: DPD calculations, forecasting
- **Analytics**: Historical analysis
- **Dashboards**: Trend visualization

## Best Practices

1. **Consistent Sampling**: Regular intervals for accurate DPD
2. **Data Validation**: Always validate before insert
3. **Efficient Queries**: Use indexes, limit time ranges
4. **Archival Strategy**: Export before TTL deletion
5. **Backup Important Data**: Historical data has value

## Troubleshooting

### Missing Data
1. Check polling intervals
2. Verify H0UND running
3. Check for errors in ERR0R
4. Validate credentials active

### Incorrect DPD
1. Verify sufficient data points (min 25 for accuracy)
2. Check timestamp accuracy
3. Look for gaps in data
4. Validate calculation formula

### Performance Issues
1. Ensure indexes exist
2. Limit query time ranges
3. Use aggregation efficiently
4. Consider sharding for scale

---

**Related**: [Data Models Overview](../INDEX.md) | [CRED3N7IAL Collection](CRED3N7IAL.md) | [DPD Entity](../../api-reference/entities/dpd.md)

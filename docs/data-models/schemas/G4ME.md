# G4ME Collection Schema

Game configurations and jackpot thresholds.

## Purpose

G4ME stores configuration data for each game/platform combination, including jackpot thresholds, game settings, and platform-specific parameters.

## Document Structure

```json
{
  "_id": "FireKirin_Slots",
  "Game": "Slots",
  "House": "FireKirin",
  "Platform": "FireKirin",
  "Url": "https://play.firekirin.in/web_mobile/hallfirekirin",
  "Category": "slots",
  "Enabled": true,
  "Thresholds": {
    "Grand": 1785,
    "Major": 565,
    "Minor": 117,
    "Mini": 23
  },
  "Settings": {
    "MinBet": 0.01,
    "MaxBet": 10.00,
    "DefaultBet": 0.50,
    "SpinDelayMs": 3000
  },
  "Coordinates": {
    "SpinButton": { "X": 640, "Y": 700 },
    "BetIncrease": { "X": 800, "Y": 600 },
    "BetDecrease": { "X": 480, "Y": 600 }
  },
  "LastUpdated": "2026-01-15T10:30:00Z"
}
```

## Field Reference

### Core Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `_id` | string | Yes | Unique identifier (format: House_Game) |
| `Game` | string | Yes | Game name |
| `House` | string | Yes | Platform/house name |
| `Platform` | string | Yes | Platform type (FireKirin/OrionStars) |
| `Url` | string | No | Game URL |
| `Category` | string | No | Game category (slots, fish) |
| `Enabled` | bool | Yes | Active status |
| `Thresholds` | object | Yes | Jackpot thresholds |
| `Settings` | object | No | Game-specific settings |
| `Coordinates` | object | No | UI element coordinates |
| `LastUpdated` | DateTime | No | Last modification time |

### Thresholds Sub-Document

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Thresholds.Grand` | double | 1785 | Grand jackpot threshold |
| `Thresholds.Major` | double | 565 | Major jackpot threshold |
| `Thresholds.Minor` | double | 117 | Minor jackpot threshold |
| `Thresholds.Mini` | double | 23 | Mini jackpot threshold |

### Settings Sub-Document

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Settings.MinBet` | double | 0.01 | Minimum bet amount |
| `Settings.MaxBet` | double | 10.00 | Maximum bet amount |
| `Settings.DefaultBet` | double | 0.50 | Default bet amount |
| `Settings.SpinDelayMs` | int | 3000 | Delay between spins (ms) |

### Coordinates Sub-Document

| Field | Type | Description |
|-------|------|-------------|
| `Coordinates.SpinButton` | object | Spin button position |
| `Coordinates.BetIncrease` | object | Bet increase button |
| `Coordinates.BetDecrease` | object | Bet decrease button |

## Validation Rules

```javascript
{
  $jsonSchema: {
    bsonType: "object",
    required: ["_id", "Game", "House", "Thresholds"],
    properties: {
      _id: { bsonType: "string" },
      Game: { bsonType: "string" },
      House: { bsonType: "string" },
      Enabled: { bsonType: "bool" },
      Thresholds: {
        bsonType: "object",
        properties: {
          Grand: { bsonType: "double", minimum: 0 },
          Major: { bsonType: "double", minimum: 0 },
          Minor: { bsonType: "double", minimum: 0 },
          Mini: { bsonType: "double", minimum: 0 }
        }
      }
    }
  }
}
```

## Indexes

```javascript
// Primary key (automatic)
{ _id: 1 }

// Platform queries
db.G4ME.createIndex({ "House": 1 })

// Category queries
db.G4ME.createIndex({ "Category": 1 })

// Active games
db.G4ME.createIndex({ "Enabled": 1 })

// Platform type
db.G4ME.createIndex({ "Platform": 1 })
```

## Common Queries

### Get Game Configuration
```javascript
// By ID
db.G4ME.findOne({ "_id": "FireKirin_Slots" })

// By platform
db.G4ME.find({ "House": "FireKirin" })

// Active games
db.G4ME.find({ "Enabled": true })
```

### Update Thresholds
```javascript
db.G4ME.updateOne(
  { "_id": "FireKirin_Slots" },
  {
    $set: {
      "Thresholds.Grand": 1800,
      "Thresholds.Major": 570,
      "LastUpdated": new Date()
    }
  }
)
```

### List All Configurations
```javascript
// All games with thresholds
db.G4ME.find({}, {
  "Game": 1,
  "House": 1,
  "Thresholds": 1
})

// Count by platform
db.G4ME.aggregate([
  { $group: { _id: "$House", count: { $sum: 1 } } }
])
```

## Code Examples

### Reading Configuration (C#)
```csharp
public async Task<GameConfig> GetGameConfigAsync(string gameId)
{
    return await gameRepo.GetAsync(gameId);
}

public async Task<IEnumerable<GameConfig>> GetActiveGamesAsync()
{
    return await gameRepo.FindAsync(g => g.Enabled);
}
```

### Updating Thresholds (C#)
```csharp
public async Task UpdateThresholdsAsync(string gameId, Thresholds newThresholds)
{
    var game = await gameRepo.GetAsync(gameId);
    
    game.Thresholds = newThresholds;
    game.LastUpdated = DateTime.UtcNow;
    
    await gameRepo.UpdateAsync(game);
    
    // Log the change
    await eventStore.StoreEventAsync(new Event
    {
        Agent = "SYSTEM",
        Action = "ThresholdAdjusted",
        Metadata = new
        {
            GameId = gameId,
            OldThresholds = game.Thresholds,
            NewThresholds = newThresholds
        }
    });
}
```

### Calibrating Thresholds (C#)
```csharp
public async Task CalibrateThresholdsAsync(string gameId, double percentile = 0.75)
{
    // Get historical jackpot data
    var history = await jackpotRepo.GetHistoryForGameAsync(gameId, 
        DateTime.UtcNow.AddDays(-30));
    
    if (!history.Any()) return;
    
    // Calculate percentiles
    var grandValues = history.Select(h => h.Grand).OrderBy(v => v).ToList();
    var majorValues = history.Select(h => h.Major).OrderBy(v => v).ToList();
    
    var grandThreshold = grandValues[(int)(grandValues.Count * percentile)];
    var majorThreshold = majorValues[(int)(majorValues.Count * percentile)];
    
    // Update game config
    var game = await gameRepo.GetAsync(gameId);
    game.Thresholds.Grand = grandThreshold;
    game.Thresholds.Major = majorThreshold;
    game.LastUpdated = DateTime.UtcNow;
    
    await gameRepo.UpdateAsync(game);
}
```

## Integration Points

### Written By
- **Setup Scripts**: Initial configuration
- **Admin Tools**: Threshold updates
- **Calibration Process**: Automated adjustment

### Read By
- **H0UND**: Threshold checking
- **H4ND**: Game-specific automation
- **Dashboard**: Configuration display

## Best Practices

1. **ID Format**: Use `{House}_{Game}` format for consistency
2. **Threshold Review**: Monthly review and adjustment
3. **Backup Config**: Export before major changes
4. **Version Control**: Track threshold changes
5. **Documentation**: Comment on threshold rationale

## Troubleshooting

### Missing Configuration
1. Check game ID format
2. Verify initialization script ran
3. Check for migration issues
4. Review setup logs

### Incorrect Thresholds
1. Review historical data
2. Check calibration settings
3. Verify percentile calculations
4. Consider game changes

---

**Related**: [Data Models Overview](../INDEX.md) | [H0U53 Collection](H0U53.md) | [Threshold Calibration](../../strategy/THRESHOLD_CALIBRATION.md)

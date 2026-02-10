# HUN7ER DPD Validation Implementation

## Summary

Added validation logic to exclude credentials from HUN7ER when they have:
1. **DPD (Daily Profit per Day) > 10** 
2. **AND data points count < 25**

This ensures statistical reliability for predictions by filtering out credentials with insufficient historical data.

## Changes Made

### 1. Added Validation Methods

**Location**: `HUN7ER\HUN7ER.cs` (lines 19-36)

```csharp
/// <summary>
/// Validates if a credential has sufficient data points for reliable DPD-based predictions
/// </summary>
private static bool IsCredentialStatisticallyReliable(Credential credential) {
    // High DPD values require more data points for statistical reliability
    // DPD > 10 requires at least 25 data points for statistical significance
    if (credential.DPD.Average > 10 && credential.DPD.Data.Count < 25) {
        return false;
    }
    return true;
}

/// <summary>
/// Gets validation details for a credential's DPD reliability
/// </summary>
private static (bool IsReliable, string Reason) GetCredentialReliabilityDetails(Credential credential) {
    if (credential.DPD.Average > 10 && credential.DPD.Data.Count < 25) {
        return (false, $"DPD={credential.DPD.Average:F2} > 10 but only {credential.DPD.Data.Count} data points (minimum 25 required)");
    }
    return (true, "Statistically reliable for predictions");
}
```

### 2. Added Early Filtering (Line 49-67)

Added validation after credentials are retrieved but before main processing:

```csharp
// Filter out credentials with insufficient data for high DPD values
var representatives = credentials
    .GroupBy(c => (c.House, c.Game))
    .Select(g => g.OrderByDescending(c => c.LastUpdated).First()) // Get representative for each game
    .ToList();

var excludedGames = representatives
    .Where(rep => !IsCredentialStatisticallyReliable(rep))
    .Select(rep => (rep.House, rep.Game))
    .ToHashSet();

if (excludedGames.Any()) {
    Console.WriteLine($"🚫 Excluding {excludedGames.Count} games from HUN7ER due to insufficient data points for high DPD values:");
    foreach (var (house, game) in excludedGames) {
        var rep = representatives.First(r => r.House == house && r.Game == game);
        var (_, reason) = GetCredentialReliabilityDetails(rep);
        Console.WriteLine($"   - {game} at {house}: {reason}");
    }
}

credentials = [.. credentials.Where(x => !excludedGames.Contains((x.House, x.Game)))];
```

### 3. Added Processing Warning (Line 108-112)

Added validation check during DPD processing with warning message:

```csharp
// VALIDATION: Check DPD reliability before processing
if (!IsCredentialStatisticallyReliable(representative)) {
    var (_, reason) = GetCredentialReliabilityDetails(representative);
    Console.WriteLine($"⚠️  {representative.Game}: {reason} (processing for data collection only)");
    // Still allow processing for data collection but mark as statistically unreliable
}
```

### 4. Added Prediction Exclusion (Line 382-386)

Added strict validation before adding credentials to predictions:

```csharp
// VALIDATION: Exclude credentials with high DPD but insufficient data points
// This ensures statistical reliability for predictions
if (!IsCredentialStatisticallyReliable(representative)) {
    var (_, reason) = GetCredentialReliabilityDetails(representative);
    Console.WriteLine($"🚫 Excluding {representative.Game} from HUN7ER: {reason}");
    continue;
}
```

### 5. Added Required Using Statement (Line 2)

```csharp
using System.Linq;
```

## Validation Logic

### Criteria
- **High DPD Threshold**: 10.0 DPD
- **Minimum Data Points**: 25 data points
- **Validation Point**: Both criteria must be true to exclude a credential

### Behavior
- **DPD ≤ 10**: Always included (no minimum data points required)
- **DPD > 10 + Data Points ≥ 25**: Included (statistically reliable)
- **DPD > 10 + Data Points < 25**: **Excluded** from predictions

### Logging Levels
- 🚫 **Exclusion messages**: When credentials are excluded from predictions
- ⚠️ **Warning messages**: When credentials have insufficient data but are still processed for data collection

## Impact

### Performance
- **Early filtering** reduces processing overhead by excluding unreliable credentials upfront
- **Predictions filtering** ensures only statistically reliable data is used for forecasting

### Reliability
- **Statistical significance**: Ensures predictions are based on sufficient historical data
- **Data quality**: Prevents outliers from skewing prediction models

### Monitoring
- **Detailed logging**: Provides clear visibility into which credentials are excluded and why
- **Transparent validation**: Makes the filtering criteria obvious to operators

## Testing

The implementation has been verified to compile successfully. The validation logic follows the statistical principle that higher variance indicators (high DPD) require larger sample sizes for reliable predictions.

The 25-data-point minimum provides a reasonable balance between:
- **Statistical reliability**: Sufficient sample size for meaningful analysis
- **Practical usability**: Allows newer credentials to accumulate data while filtering out unreliable high-DPD outliers
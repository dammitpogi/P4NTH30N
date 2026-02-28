# H0UND Component Guide

Analytics and polling agent — "The Brain" of P4NTHE0N.

## Overview

H0UND continuously polls casino platforms for jackpot and balance data, calculates DPD (Dollars Per Day) forecasts, and generates automation signals when thresholds are met.

### Responsibilities

- **Polling**: Query casino APIs for current jackpot values
- **Analytics**: Calculate DPD growth rates and forecasts
- **Forecasting**: Predict when jackpots will hit
- **Signal Generation**: Create SIGN4L records for H4ND
- **Dashboard**: Display real-time analytics

## Architecture

```
H0UND/
├── H0UND.cs                    # Entry point and main loop
├── Domain/
│   ├── Forecasting/
│   │   ├── DpdCalculator.cs    # DPD calculations
│   │   └── ForecastingService.cs # Forecasting logic
│   └── SignalService.cs        # Signal generation
├── Application/
│   ├── AnalyticsWorker.cs      # Analytics background service
│   └── PollingWorker.cs        # Polling background service
└── Infrastructure/
    └── BalanceProviders/       # Platform-specific polling
        ├── FireKirinBalanceProvider.cs
        └── OrionStarsBalanceProvider.cs
```

## Data Flow

```
┌─────────────────────────────────────────────────────────┐
│                        H0UND                            │
│                                                         │
│  ┌──────────────┐      ┌──────────────┐                │
│  │ PollingWorker│──────▶│ BalanceProvider              │
│  │   (Timer)    │      │   (HTTP/WS)  │                │
│  └──────────────┘      └──────────────┘                │
│         │                       │                       │
│         ▼                       ▼                       │
│  ┌──────────────────────────────────────────┐          │
│  │        MongoDB Collections               │          │
│  │  ┌──────────┐  ┌──────────┐  ┌────────┐ │          │
│  │  │CRED3N7IAL│  │ JACKP0T  │  │ EV3NT  │ │          │
│  │  └──────────┘  └──────────┘  └────────┘ │          │
│  └──────────────────────────────────────────┘          │
│         │                       ▲                       │
│         ▼                       │                       │
│  ┌──────────────┐      ┌──────────────┐                │
│  │AnalyticsWorker│──────▶│ SignalService                │
│  │  (Timer)     │      │              │                │
│  └──────────────┘      └──────────────┘                │
│                               │                         │
│                               ▼                         │
│                        ┌──────────────┐                │
│                        │   SIGN4L     │                │
│                        │  (in EV3NT)  │                │
│                        └──────────────┘                │
└─────────────────────────────────────────────────────────┘
```

## Main Loop

```csharp
// H0UND.cs main loop structure
while (!cancellationToken.IsCancellationRequested)
{
    try
    {
        // 1. Poll credentials for jackpot data
        await pollingWorker.ExecuteAsync();
        
        // 2. Run analytics (throttled to every 10s)
        if (timeSinceLastAnalytics >= TimeSpan.FromSeconds(10))
        {
            await analyticsWorker.ExecuteAsync();
        }
        
        // 3. Sleep before next cycle
        await Task.Delay(TimeSpan.FromSeconds(3), cancellationToken);
    }
    catch (Exception ex)
    {
        // Log error and continue
        errorStore.LogError($"[H0UND] Main loop error: {ex.Message}");
        await Task.Delay(TimeSpan.FromSeconds(5), cancellationToken);
    }
}
```

## Polling Worker

### Purpose
Queries casino platforms for current jackpot values.

### Flow
```csharp
public async Task ExecuteAsync()
{
    // 1. Get active credentials
    var credentials = await credentialRepo.GetActiveAsync();
    
    // 2. Group by platform
    var byPlatform = credentials.GroupBy(c => c.House);
    
    // 3. Poll each platform
    foreach (var group in byPlatform)
    {
        var provider = balanceProviderFactory.Create(group.Key);
        
        foreach (var credential in group)
        {
            try
            {
                // 4. Query jackpot values
                var jackpots = await provider.GetBalancesAsync(credential);
                
                // 5. Update credential
                credential.Jackpots = jackpots;
                credential.LastUpdated = DateTime.UtcNow;
                
                // 6. Save to database
                await credentialRepo.UpdateAsync(credential);
                
                // 7. Record history
                await jackpotRepo.AddAsync(new Jackpot
                {
                    CredentialId = credential.Id,
                    ...jackpots,
                    Timestamp = DateTime.UtcNow
                });
            }
            catch (Exception ex)
            {
                errorStore.LogError($"[{credential.Id}] Polling failed: {ex.Message}");
            }
        }
    }
}
```

### Balance Providers

**FireKirinBalanceProvider**
- Uses HTTP API
- Returns all 4 jackpot tiers
- Authentication via session cookie

**OrionStarsBalanceProvider**
- Uses WebSocket connection
- Real-time updates
- Authentication via token

## Analytics Worker

### Purpose
Calculate DPD and generate signals.

### Flow
```csharp
public async Task ExecuteAsync()
{
    // 1. Get all active credentials
    var credentials = await credentialRepo.GetActiveAsync();
    
    foreach (var credential in credentials)
    {
        // 2. Get historical data (last 7 days)
        var history = await jackpotRepo.GetHistoryAsync(
            credential.Id, 
            DateTime.UtcNow.AddDays(-7)
        );
        
        // 3. Calculate DPD for each tier
        var dpd = dpdCalculator.Calculate(history);
        credential.DPD = dpd;
        
        // 4. Check for jackpot pops (toggle detection)
        DetectJackpotPops(credential, history);
        
        // 5. Generate signals if thresholds met
        var signals = signalService.GenerateSignals(credential);
        
        foreach (var signal in signals)
        {
            await signalRepo.AddAsync(signal);
        }
        
        // 6. Update credential
        await credentialRepo.UpdateAsync(credential);
    }
}
```

## DPD Calculation

### Formula
```
DPD = (CurrentValue - Value7DaysAgo) / 7

Or if less than 7 days:
DPD = (CurrentValue - ValueNDaysAgo) / N
```

### Minimum Data Requirement
- DPD > 10 requires minimum 25 data points
- DPD ≤ 10 requires minimum 10 data points
- Less data = less reliable forecast

### Example
```csharp
// Historical data (daily snapshots)
var values = [100, 110, 125, 140, 155, 170, 185];  // 7 days

// DPD calculation
double dpd = (185 - 100) / 7;  // = 12.14 per day

// Forecast: when will it reach 300?
double daysToTarget = (300 - 185) / 12.14;  // ~9.5 days
```

## Signal Generation

### Threshold Check
```csharp
public List<Signal> GenerateSignals(Credential credential)
{
    var signals = new List<Signal>();
    
    // Check each tier
    if (credential.Settings.SpinGrand && 
        credential.Jackpots.Grand >= credential.Thresholds.Grand)
    {
        signals.Add(new Signal
        {
            Priority = 4,  // Grand = highest
            House = credential.House,
            Username = credential.Id,
            Timestamp = DateTime.UtcNow
        });
    }
    
    // Similar checks for Major (3), Minor (2), Mini (1)
    
    return signals;
}
```

### Priority Levels

| Priority | Tier | Description |
|----------|------|-------------|
| 4 | Grand | Highest value, lowest frequency |
| 3 | Major | High value |
| 2 | Minor | Medium value |
| 1 | Mini | Lowest value, highest frequency |

## Jackpot Pop Detection

### DPD Toggle Pattern
```csharp
// Detect 2 consecutive drops > 0.1 threshold
if (current < previous && drop > 0.1)
{
    if (credential.DPD.Toggles.GrandPopped)
    {
        // Second drop - CONFIRMED POP
        ResetThreshold(credential, Tier.Grand);
        credential.DPD.Toggles.GrandPopped = false;
    }
    else
    {
        // First drop - SET TOGGLE
        credential.DPD.Toggles.GrandPopped = true;
    }
}
else
{
    // Value increased - RESET TOGGLE
    credential.DPD.Toggles.GrandPopped = false;
}
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `H0UND_POLLING_INTERVAL` | 30s | Seconds between polls |
| `H0UND_ANALYTICS_INTERVAL` | 10s | Seconds between analytics runs |
| `H0UND_DPD_MINIMUM_DAYS` | 1 | Minimum days for DPD calc |
| `H0UND_DPD_HIGH_THRESHOLD` | 10 | High DPD threshold (needs 25 pts) |

### appsettings.json
```json
{
  "H0UND": {
    "Polling": {
      "IntervalSeconds": 30,
      "RetryAttempts": 3,
      "TimeoutSeconds": 10
    },
    "Analytics": {
      "IntervalSeconds": 10,
      "DpdMinimumPoints": 25,
      "DpdHighThreshold": 10
    },
    "Dashboard": {
      "Enabled": true,
      "RefreshRate": 1000
    }
  }
}
```

## Resilience Features

### Circuit Breaker
- 5 failures in 60 seconds = Open circuit
- 5-minute timeout before HalfOpen
- Protects against API degradation

### Retry Logic
- 3 retry attempts per API call
- Exponential backoff (2s, 4s, 8s)
- Jitter to prevent thundering herd

### Degradation
- High latency → Batch operations
- API errors → Reduce polling frequency
- Critical errors → Halt analytics

## Monitoring

### Health Checks
```csharp
public async Task<HealthCheck> CheckHealthAsync()
{
    var checks = new[]
    {
        CheckMongoDBConnectivity(),
        CheckLastPollTime(),
        CheckSignalGenerationRate(),
        CheckErrorRate()
    };
    
    return AggregateHealth(checks);
}
```

### Key Metrics
- Polling latency (p50, p95, p99)
- Signals generated per hour
- DPD calculation accuracy
- Error rate by platform

## Troubleshooting

### Not Generating Signals
1. Check credentials are enabled
2. Verify jackpot values > thresholds
3. Check `Settings.Spin*` flags
4. Review EV3NT collection for errors

### High Error Rate
1. Check platform API status
2. Verify credentials not banned
3. Review circuit breaker state
4. Check network connectivity

### DPD Calculations Wrong
1. Verify historical data exists
2. Check minimum data points
3. Review calculation formula
4. Validate timestamp accuracy

## Autostart/Boot-Time

H0UND supports automatic startup via Windows Task Scheduler:

```powershell
# Register to start on boot (Admin PowerShell)
.\scripts\Register-AutoStart.ps1
```

See [Autostart Guide](AUTOSTART.md) for full setup and troubleshooting.

## Integration Points

### Consumes
- **MongoDB**: CRED3N7IAL, JACKP0T
- **Casino APIs**: FireKirin, OrionStars

### Produces
- **MongoDB**: JACKP0T, EV3NT (as SIGN4L)
- **Dashboard**: Real-time display

### Communicates With
- **H4ND**: Via SIGN4L collection
- **W4TCHD0G**: Health status

## Code Examples

### Custom Balance Provider
```csharp
public class MyPlatformProvider : IBalanceProvider
{
    public async Task<JackpotValues> GetBalancesAsync(Credential credential)
    {
        // Implement platform-specific logic
        var response = await _httpClient.GetAsync(
            $"{credential.Platform.Url}/api/balance"
        );
        
        var data = await response.Content.ReadAsJsonAsync();
        
        return new JackpotValues
        {
            Grand = data.GrandJackpot,
            Major = data.MajorJackpot,
            Minor = data.MinorJackpot,
            Mini = data.MiniJackpot
        };
    }
}
```

### Custom Analytics
```csharp
public class CustomAnalytics
{
    public async Task AnalyzeAsync(Credential credential)
    {
        var history = await _jackpotRepo.GetHistoryAsync(credential.Id);
        
        // Custom analysis logic
        var trend = CalculateTrend(history);
        
        if (trend.IsAccelerating)
        {
            // Lower threshold for faster response
            credential.Thresholds.Grand *= 0.9;
        }
        
        await _credentialRepo.UpdateAsync(credential);
    }
}
```

---

**Related**: [H4ND Component](H4ND/) | [Data Models](../data-models/) | [API Reference](../api-reference/)

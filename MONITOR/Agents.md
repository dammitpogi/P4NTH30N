# MONITOR

## Responsibility

Standalone monitoring service for data corruption detection and system health. Can be run independently or integrated into main applications. Wraps C0MMON/Monitoring components.

## When Working Here

- **Real-time monitoring**: Low-latency metric collection
- **Alerting**: Configurable thresholds and notifications
- **Dashboards**: Visual representation of system state
- **Historical data**: Trend analysis and capacity planning
- **Proactive detection**: Identify issues before they impact users

## Core Components

### MonitoringService.cs
Main monitoring orchestrator that wraps DataCorruptionMonitor:
- Connects to MongoDB (default: `mongodb://localhost:27017`, database: `P4NTHE0N`)
- Runs initial health check on startup
- Performs initial data cleaning via `ValidatedMongoRepository.CleanCorruptedData()`
- Starts continuous DataCorruptionMonitor (2-minute intervals)
- Periodic health checks every 10 minutes
- Graceful shutdown via Ctrl+C

## Architecture

```
MONITOR
  └─ MonitoringService
       ├─ DataCorruptionMonitor (from C0MMON/Monitoring)
       │    ├─ CheckCredentialExtremes()
       │    ├─ CheckDPDDataCorruption()
       │    └─ CheckJackpotExtremes()
       └─ ValidatedMongoRepository
            └─ CleanCorruptedData()
```

## Data Corruption Checks

### Credential Extremes
- Grand jackpot >10,000
- Major jackpot >1,000
- Minor jackpot >200
- Mini jackpot >50
- Balance >50,000

### DPD Data Corruption
- Grand DPD >10,000 or <0

### Jackpot Collection
- Current >10,000
- Threshold >2,000
- DPM <0

## Startup Behavior

1. Trigger immediate data corruption check
2. Perform initial data validation and cleaning
3. Start continuous monitoring (2-minute intervals)
4. Every 10 minutes: trigger additional health check

## Usage

```csharp
// Create monitoring service
var monitoringService = new MonitoringService(
    connectionString: "mongodb://localhost:27017",
    databaseName: "P4NTHE0N"
);

// Start monitoring
monitoringService.Start();

// Manual health check trigger
monitoringService.TriggerHealthCheck();

// Stop monitoring
monitoringService.Stop();
```

## Program Entry Point

```csharp
public class Program
{
    public static void Main(string[] args)
    {
        var monitoringService = new MonitoringService();
        monitoringService.Start();
        
        // Keep running
        while (true)
        {
            Thread.Sleep(60000);
            if (DateTime.Now.Minute % 10 == 0)
            {
                monitoringService.TriggerHealthCheck();
            }
        }
    }
}
```

## Dependencies

- C0MMON: Entity access
- C0MMON/Infrastructure: ValidatedMongoRepository
- C0MMON/Monitoring: DataCorruptionMonitor
- MongoDB.Driver

## Integration

- Sends alerts to console (🚨 DATA CORRUPTION ALERT)
- Logs to EV3NT collection
- Performs automatic data cleaning on startup
- Can trigger automated responses via health check results

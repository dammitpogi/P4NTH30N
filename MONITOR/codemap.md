# MONITOR/

## Responsibility

Standalone monitoring service for data corruption detection and system health monitoring. Can be run independently or integrated into main applications. Wraps C0MMON/Monitoring components to provide real-time monitoring, alerting, dashboards, and proactive detection of issues before they impact users.

**Core Functions:**
- **Real-time Monitoring**: Low-latency metric collection
- **Data Corruption Detection**: Automated checks for data inconsistencies
- **Health Monitoring**: Periodic system health checks
- **Alerting**: Configurable thresholds and notifications
- **Automatic Cleanup**: Data validation and cleaning on startup

## Design

**Architecture Pattern**: Service wrapper with continuous monitoring loop
- **MonitoringService**: Main orchestrator wrapping DataCorruptionMonitor
- **Continuous Loop**: 2-minute intervals for corruption checks
- **Periodic Health**: 10-minute intervals for full health checks
- **Event-driven**: Alerts on detection of issues

### Key Components

#### MonitoringService.cs
Main monitoring orchestrator:
- Connects to MongoDB (default: `mongodb://localhost:27017`, database: `P4NTHE0N`)
- Runs initial health check on startup
- Performs initial data cleaning via `ValidatedMongoRepository.CleanCorruptedData()`
- Starts continuous DataCorruptionMonitor (2-minute intervals)
- Periodic health checks every 10 minutes
- Graceful shutdown via Ctrl+C

#### Data Corruption Checks (via C0MMON)
```
DataCorruptionMonitor (from C0MMON/Monitoring)
    ├── CheckCredentialExtremes()
    │   ├── Grand jackpot > 10,000
    │   ├── Major jackpot > 1,000
    │   ├── Minor jackpot > 200
    │   ├── Mini jackpot > 50
    │   └── Balance > 50,000
    ├── CheckDPDDataCorruption()
    │   └── Grand DPD > 10,000 or < 0
    └── CheckJackpotExtremes()
        ├── Current > 10,000
        ├── Threshold > 2,000
        └── DPM < 0
```

#### ValidatedMongoRepository (from C0MMON)
- `CleanCorruptedData()`: Automatic data validation and repair
- Called on startup to ensure clean baseline

## Flow

### Startup Flow
```
Initialize MonitoringService
    ↓
Connect to MongoDB
    ↓
Trigger Immediate Data Corruption Check
    ↓
Perform Initial Data Validation and Cleaning
    ↓
Start Continuous Monitoring (2-minute intervals)
    ↓
Every 10 Minutes: Trigger Additional Health Check
    ↓
Run Until Shutdown (Ctrl+C)
```

### Monitoring Loop Flow
```
[Every 2 Minutes]
    ↓
DataCorruptionMonitor.CheckAll()
    ↓
[Check Credential Extremes]
    ├── Grand > 10,000? → ALERT
    ├── Major > 1,000? → ALERT
    ├── Minor > 200? → ALERT
    ├── Mini > 50? → ALERT
    └── Balance > 50,000? → ALERT
    ↓
[Check DPD Corruption]
    └── Grand DPD > 10,000 or < 0? → ALERT
    ↓
[Check Jackpot Extremes]
    ├── Current > 10,000? → ALERT
    ├── Threshold > 2,000? → ALERT
    └── DPM < 0? → ALERT
    ↓
Log Results
    ↓
[Every 10 Minutes]
    ↓
Trigger Health Check
    ↓
Report System Status
```

### Alert Flow
```
Anomaly Detected
    ↓
Log to Console (🚨 DATA CORRUPTION ALERT)
    ↓
Write to EV3NT Collection
    ↓
[Optional] Trigger Automated Response
    ↓
Continue Monitoring
```

## Integration

### Dependencies
- **C0MMON**: Entity access, DataCorruptionMonitor
- **C0MMON/Infrastructure**: ValidatedMongoRepository
- **MongoDB.Driver**: Direct database access

### Data Access
- MongoDB connection via connection string
- Database: `P4NTHE0N` (configurable)
- Collections monitored: `CRED3N7IAL`, `JACKPOTS`, `DPD` data

### Consumed By
- Standalone execution: `dotnet run --project MONITOR/MONITOR.csproj`
- Integration: Can be embedded in other services
- CI/CD: Health check validation in pipelines

### Alerts
- **Console**: Real-time alert display with emoji indicators
- **MongoDB**: Alert events stored in `EV3NT` collection
- **Automated Response**: Can trigger other services based on alerts

## Key Components

### MonitoringService
```csharp
var monitoringService = new MonitoringService(
    connectionString: "mongodb://localhost:27017",
    databaseName: "P4NTHE0N"
);

monitoringService.Start();
monitoringService.TriggerHealthCheck();
monitoringService.Stop();
```

### Program Entry Point
```csharp
public class Program
{
    public static void Main(string[] args)
    {
        var monitoringService = new MonitoringService();
        monitoringService.Start();
        
        // Keep running with periodic health checks
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

## Configuration

### Connection Settings
```csharp
// Default connection
connectionString: "mongodb://localhost:27017"
databaseName: "P4NTHE0N"

// Custom connection
var service = new MonitoringService(
    "mongodb://custom-host:27017",
    "CustomDB"
);
```

### Check Intervals
- **Corruption Checks**: Every 2 minutes
- **Health Checks**: Every 10 minutes
- **Startup Delay**: Immediate on start

## Thresholds

### Credential Extremes
| Field | Threshold | Alert Level |
|-------|-----------|-------------|
| Grand Jackpot | > 10,000 | Critical |
| Major Jackpot | > 1,000 | Warning |
| Minor Jackpot | > 200 | Warning |
| Mini Jackpot | > 50 | Info |
| Balance | > 50,000 | Critical |

### DPD Corruption
- Grand DPD > 10,000: Critical
- Grand DPD < 0: Critical

### Jackpot Collection
- Current > 10,000: Critical
- Threshold > 2,000: Warning
- DPM < 0: Critical

## Critical Notes

### Safety
- Non-destructive monitoring (read-only checks)
- Automatic cleanup only on startup via ValidatedMongoRepository
- All changes logged to EV3NT collection
- Safe to run continuously

### Performance
- Lightweight queries for minimal DB impact
- Batched reads for large collections
- Efficient indexing assumed on monitored fields

### Reliability
- Automatic reconnection on MongoDB failures
- Graceful shutdown on Ctrl+C
- Exception isolation (one failed check doesn't stop others)

### Integration with C0MMON
- Uses same validation logic as repositories
- Shares health check infrastructure with H0UND/W4TCHD0G
- Alerts stored in standard EV3NT format

## Usage

### Standalone
```bash
# Run monitoring service
dotnet run --project MONITOR/MONITOR.csproj

# Run in background
nohup dotnet run --project MONITOR/MONITOR.csproj &
```

### Embedded
```csharp
var monitor = new MonitoringService();
monitor.Start();
// ... other service code ...
monitor.Stop();
```

### Health Check Only
```csharp
var monitor = new MonitoringService();
monitor.TriggerHealthCheck();
monitor.Stop();
```

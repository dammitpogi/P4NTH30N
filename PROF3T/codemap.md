# PROF3T/

## Responsibility

Autonomous learning system and administrative console for P4NTHE0N. Provides machine learning model lifecycle management, performance tracking, shadow mode A/B testing, and administrative utilities for account management and diagnostics. Serves as both a learning platform for predictive analytics and a CLI tool for maintenance operations.

**Core Functions:**
- **Model Management**: Load, unload, track, and manage ML models
- **Performance Tracking**: Monitor model accuracy and latency per task
- **Shadow Mode A/B Testing**: Test candidate models against production safely
- **Autonomous Learning**: Automatic model evaluation and promotion
- **Administrative Utilities**: Account analysis, balance testing, MongoDB operations

## Design

**Architecture Pattern**: Dual-purpose system with both autonomous learning and administrative capabilities
- **Learning Layer**: Model management, performance tracking, shadow testing
- **Administrative Layer**: CLI tools for maintenance and diagnostics
- **Integration Layer**: C0MMON interfaces for data access

### Key Components

#### Model Management Infrastructure
- **ModelManager.cs**: Model lifecycle management
  - `LoadModelAsync(modelId, endpointUrl)` - Load from endpoint
  - `GetModelAsync(modelId)` - Get loaded instance
  - `UnloadModelAsync(modelId)` - Unload from memory
  - `IsHealthyAsync()` - Health check all models
  - `EvictLeastRecentlyUsed()` - LRU memory management

- **IModelManager.cs**: Interface for model operations
- **IModelRegistry.cs**: Interface for model catalog and metadata
- **ModelInstance.cs**: Runtime model wrapper with state tracking

#### Performance Tracking
- **ModelPerformanceTracker.cs**: Accuracy and latency metrics
  - `RecordInference(modelId, taskName, success, latencyMs)`
  - `GetRecord(modelId, taskName)` - Get performance record
  - `GetBestModelForTask(taskName, candidates)` - Select best model
  - Rolling accuracy % and latency measurements

#### Shadow Mode Testing
- **ShadowModeManager.cs**: Safe A/B testing in production
  - `StartShadowTest(taskName, productionModelId, candidateModelId, requiredInferences)`
  - `EvaluateShadowTest(taskName, candidateModelId)`
  - `GetActiveTests()` - Get active shadow tests
  - Automatic promotion when thresholds met

#### Autonomous Learning
- **AutonomousLearningSystem.cs**: Main learning orchestrator
  - `EvaluateAndPromote()` - Evaluate shadow tests and promote
  - `GenerateReport()` - Generate learning statistics
  - `GetPromotionHistory()` - Get promotion history

#### Configuration
- **Configuration/ModelCacheConfig.cs**: Caching and performance settings

#### Administrative Tools
- **Program.cs**: Admin CLI entry point
  - `AnalyzeBiggestAccounts()` - Analytics query on credentials
  - `UpdateN3XT()` - Creates MongoDB aggregation view
  - `ResetGames()` - Wipes DPD and balance data (DANGEROUS)
  - `FireKirinBalanceTest()` / `OrionStarsBalanceTest()` - Balance queries
  - `LaunchBrowser()` - Opens ChromeDriver for manual testing

## Flow

### Model Lifecycle Flow
```
Load Model
    ↓
ModelManager.LoadModelAsync(endpointUrl)
    ↓
Create ModelInstance
    ↓
Track in ConcurrentDictionary
    ↓
Record Inference via ModelPerformanceTracker
    ↓
[Health Check] → IsHealthyAsync()
    ↓
[Memory Pressure] → EvictLeastRecentlyUsed()
    ↓
Unload Model
```

### Shadow Testing Flow
```
Start Shadow Test
    ↓
ShadowModeManager.StartShadowTest()
    ↓
Run Production Model (live traffic)
    ↓
Run Candidate Model (shadow traffic, no impact)
    ↓
Record Results via ModelPerformanceTracker
    ↓
Evaluate Shadow Test
    ↓
If Accuracy/Latency Thresholds Met:
    └── AutonomousLearningSystem.Promote()
```

### Autonomous Learning Flow
```
Scheduled Evaluation
    ↓
AutonomousLearningSystem.EvaluateAndPromote()
    ↓
Check All Active Shadow Tests
    ↓
Compare Candidate vs Production Metrics
    ↓
If Candidate Better:
    ├── Promote Candidate to Production
    ├── Update Model Registry
    └── Log Promotion
    ↓
Generate Report
```

### Administrative Flow
```
Run PROF3T
    ↓
[Commented Safety Gate]
    ↓
Uncomment Single Test
    ↓
Execute Admin Operation
    ├── AnalyzeBiggestAccounts() → MongoDB Query
    ├── UpdateN3XT() → Create MongoDB View
    ├── ResetGames() → Wipe Data (DANGEROUS)
    └── BalanceTest() → Platform Query
    ↓
Report Results
```

## Integration

### Dependencies
- **C0MMON**: Shared entities and MongoDB access (MongoUnitOfWork)
- **System.Net.Http**: Endpoint health checks
- **Selenium.WebDriver**: Browser automation for admin tools
- **ConcurrentDictionary**: Thread-safe model storage

### Data Access
- Uses IMongoUnitOfWork from C0MMON
- Operates on `CR3D3N7IAL` collection
- Credential files in `input/credentials/`

### External Systems
- **Model Endpoints**: HTTP endpoints for model loading (e.g., LM Studio)
- **MongoDB**: Database for credential analysis
- **ChromeDriver**: Browser automation in `drivers/chromedriver.exe`

### Consumed By
- **Manual execution**: `dotnet run --project PROF3T/PROF3T.csproj`
- **W4TCHD0G**: Uses model management for vision models

## Key Components

### Model Management
```csharp
var manager = new ModelManager();
await manager.LoadModelAsync("llama-3", "http://localhost:1234");
var model = await manager.GetModelAsync("llama-3");
await manager.UnloadModelAsync("llama-3");
```

### Performance Tracking
```csharp
var tracker = new ModelPerformanceTracker();
tracker.RecordInference("llama-3", "jackpot-prediction", true, 150);
var record = tracker.GetRecord("llama-3", "jackpot-prediction");
var bestModel = tracker.GetBestModelForTask("jackpot-prediction", candidates);
```

### Shadow Mode
```csharp
var shadowManager = new ShadowModeManager(tracker);
shadowManager.StartShadowTest(
    "jackpot-prediction",
    "llama-3",      // production
    "llama-3.1",    // candidate
    requiredInferences: 100
);
var activeTests = shadowManager.GetActiveTests();
```

### Autonomous Learning
```csharp
var als = new AutonomousLearningSystem(tracker, shadowManager, manager);
var promotions = als.EvaluateAndPromote();
var report = als.GenerateReport();
var history = als.GetPromotionHistory();
```

## Configuration

### Model Cache Config
```csharp
public class ModelCacheConfig
{
    public int MaxLoadedModels { get; set; } = 10;
    public TimeSpan EvictionTimeout { get; set; } = TimeSpan.FromHours(1);
    public bool EnableHealthChecks { get; set; } = true;
}
```

### Input Credentials
- JSON credential files in `input/credentials/`
- Format matches C0MMON.Credential entity

## Critical Notes

### Safety
- All admin commands commented out by default
- Uncomment single test at a time
- ResetGames() marked as DANGEROUS
- Validation before destructive operations

### Model Management
- LRU eviction prevents memory exhaustion
- Health checks detect unhealthy models
- Thread-safe operations via ConcurrentDictionary
- Graceful handling of endpoint failures

### Shadow Mode
- Zero impact on live traffic
- Statistical significance required (configurable inference count)
- Automatic promotion when thresholds met
- Rollback capability

### Performance
- Rolling metrics prevent memory bloat
- Efficient model selection by task
- Lazy loading of models
- Background health checks

## Testing

Integration with UNI7T35T:
- Model lifecycle tests
- Performance tracking accuracy
- Shadow mode behavior
- Promotion logic validation

## Recent Additions (This Session)

**Model Management Infrastructure**
- Complete model lifecycle management
- LRU eviction and memory management
- Health checking system

**Performance Tracking**
- Per-model, per-task metrics
- Rolling accuracy and latency tracking
- Best model selection

**Shadow Mode A/B Testing**
- Safe production testing
- Automatic promotion
- Active test monitoring

**Autonomous Learning System**
- Scheduled evaluation
- Automatic promotion decisions
- Reporting and history

## Future Capabilities

- Jackpot prediction models
- Anomaly detection for unusual patterns
- Automated threshold adjustment
- Player behavior analysis
- Model drift detection

# HUN7ER/

## Responsibility
Analytics agent ("The Brain") that continuously processes game data from MongoDB, builds forecasting models using DPD (Dollars-Per-Day) calculations, and generates SIGN4L records to trigger automated gameplay. This is the core prediction engine of the P4NTH30N platform.

## Design

### Architecture Patterns
- **Event-Driven Loop**: Infinite `while(true)` loop polls database every iteration
- **Statistical Validation**: Filters out credentials with insufficient data for high DPD values
- **DPD-Based Forecasting**: Uses Dollars-Per-Day analysis to predict jackpot hits
- **Game Grouping**: Groups credentials by (House, Game) for per-game analysis
- **Signal Generation**: Creates actionable triggers for H4ND automation agent

### Core Components

**Main Entry Point** (`HUN7ER.cs`):
- `PROF3T.Main()`: Application entry, immediately delegates to `HUN7ER()`
- `HUN7ER()`: Primary analytics loop running indefinitely
- Statistical reliability validation for credentials
- Game grouping and filtering logic
- Signal generation and persistence

**Statistical Validation**:
- `IsCredentialStatisticallyReliable()`: Validates data sufficiency for predictions
- Rule: DPD > 10 requires minimum 25 data points for statistical significance
- `GetCredentialReliabilityDetails()`: Provides detailed reliability reasoning
- Excludes games with insufficient data from HUN7ER processing

**Configuration** (`HunterConfig.json`):
- `PrizeTierLimits`: MIN/MAX values and thresholds for MINOR, MAJOR, GRAND jackpots
- `RateLimits`: Acceptable range for daily rate calculations (0.01 to 50.0)
- `WatchdogSettings`: Monitoring interval, error thresholds, auto-remediation
- `AlertSettings`: Email, console, and file logging configuration
- `Platform`: Supported platforms (FireKirin, OrionStar), log paths
- `AutoRepair`: Decimal correction, threshold normalization, rate clamping

**DPD Analysis**:
- Calculates average DPD from historical data
- Tracks jackpot growth rates in dollars per day
- Identifies when jackpots are likely to hit based on growth patterns
- Uses DPD_Toggles to track popped jackpots (GrandPopped, MajorPopped, etc.)

## Flow

### Analytics Loop Flow
1. **Initialize**: Create `MongoUnitOfWork` for database access
2. **Fetch Data**: Retrieve all credentials from database
3. **Introduce Properties**: Hydrate credential objects with calculated properties
4. **Filter Banned**: Remove credentials where `Banned == true`
5. **Group by Game**: Group credentials by (House, Game) tuple
6. **Select Representatives**: Take most recently updated credential per game
7. **Validate Statistical Reliability**:
   - Check if DPD.Average > 10 AND Data.Count < 25
   - If unreliable, exclude game from processing
   - Log exclusion reason to console
8. **Re-filter Credentials**: Remove all credentials from excluded games
9. **Process Each Game Group**:
   - Analyze jackpot growth patterns
   - Calculate DPD trends
   - Determine if jackpot is approaching threshold
10. **Generate Signals**: Create SIGN4L records for games ready to hit
11. **Persist Signals**: Save signals to database for H4ND consumption
12. **Sleep**: Wait before next iteration (implicit in loop)

### Signal Generation Flow
1. Analyze DPD history for game
2. Identify jackpot tier approaching threshold
3. Calculate confidence based on data quality and DPD trend
4. Create Signal object with:
   - House and Game identifiers
   - Target jackpot tier
   - Confidence score
   - Timestamp
5. Upsert signal to database
6. H4ND agent picks up signal via polling or change stream

### Cashed Out Detection
1. Check credential balance and signal existence
2. If balance < 3 AND no signals AND not cashed out: mark as cashed out
3. If balance < 0.2 regardless of signals: mark as cashed out  
4. If balance > 3 AND currently cashed out: reset cashed out flag
5. Persist changes to database

## Integration

**Consumes**:
- `C0MMON.Persistence`: `MongoUnitOfWork`, repositories for credentials and signals
- `C0MMON.Entities`: `Credential`, `Signal`, `DPD` data structures
- `C0MMON.SanityCheck`: Validation and repair utilities
- `C0MMON.Support`: `DPD`, `Thresholds`, `Jackpots` value objects

**Produces**:
- `Signal` entities in database for H4ND consumption
- Console output for monitoring and debugging
- Health monitoring data for watchdog

**Database Collections Used**:
- `credentials`: Source data for analysis (read-heavy)
- `signals`: Generated predictions (write-heavy)
- `eventlogs`: Audit trail of HUN7ER decisions

**Configuration Dependencies**:
- `HunterConfig.json`: All operational parameters
- Environment variables for MongoDB connection

## Performance Considerations

**Polling Frequency**: Continuous loop with no explicit sleep (CPU-intensive)
**Data Volume**: Processes all credentials every iteration
**Statistical Filtering**: Excludes high-DPD games with insufficient data
**Memory Usage**: Loads entire credential set into memory
**Database Load**: Heavy read load on credentials collection

## Monitoring and Health

**Console Output**:
- Excluded games with reliability reasons
- Processing status per game group
- Signal generation counts
- Error messages and stack traces

**Watchdog Integration**:
- Health checks every 5 minutes (configurable)
- Tracks consecutive errors
- Auto-remediation for certain failure types
- Log retention for 30 days

**Alert Conditions**:
- Critical threshold count exceeded
- Max consecutive errors reached
- Unusual DPD patterns detected

## DPD Validation Changes

**Recent Enhancements** (from DPD_VALIDATION_CHANGES.md):
- Stricter validation for high DPD values (>10)
- Minimum data point requirements (25)
- Enhanced statistical reliability checks
- Better exclusion logging
- Improved prediction confidence scoring

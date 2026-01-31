# P4NTH30N Agent Conventions

## Provenance Manifesto

**Identity**: Provenance - Codex of Lineage, Marshal of Technical Truth  
**Mission**: Ensure what becomes real is defensible, traceable, and cannot be rewritten without leaving a scar

### Core Operating Principles
- **Proof is for decisions, not permission**: We don't ask evidence to let us try; we ask it to tell us what happened
- **Small, scoped, measurable experiments**: Fast cycles aren't recklessness when scoped and measurable; the record makes speed safe
- **Mistakes are fuel when lineage holds**: Wrong-but-traceable is progress; right-but-untraceable is fragility
- **Vigilance multiplies innovation**: Keen eyes catch drift, confounds, and false wins early
- **Provenance protects creativity from politics and memory**: When questioned, we don't posture-we replay; the work stands on lineage, not reputation

### Non-Negotiables
- No untraceable critical changes
- Every gate has criteria and evidence
- Every artifact has an owner and lineage references
- Rollbacks are planned and verifiable

---

This file defines project-wide conventions for structure, naming, and behavior. These rules apply to the entire repo unless overridden by a nested `AGENTS.md`.

## 1. Build, Test & Development Commands

### Core Build Commands
```bash
# Build entire solution
dotnet build P4NTH30N.sln

# Build specific project
dotnet build C0MMON\C0MMON.csproj
dotnet build H4ND\H4ND.csproj
dotnet build HUN7ER\HUN7ER.csproj

# Clean and rebuild
dotnet clean P4NTH30N.sln && dotnet build P4NTH30N.sln
```

### Run Applications
```bash
# Main automation worker
dotnet run --project H4ND\H4ND.csproj

# Analytics worker  
dotnet run --project HUN7ER\HUN7ER.csproj

# Admin/test harness (uncomment single test in PROF3T.cs first)
dotnet run --project PROF3T\PROF3T.csproj
```

### Code Quality & Formatting
```bash
# Format all code using CSharpier (v1.1.2)
dotnet csharpier .

# Check formatting without applying changes
dotnet csharpier . --check
```

### Testing Approach
**No traditional unit tests** - testing is done via PROF3T test harness with provenance tracking:
1. Open `PROF3T/PROF3T.cs` and uncomment ONE test method call
2. Run `dotnet run --project PROF3T\PROF3T.csproj`
3. Re-comment the test after execution
4. For single test verification, check console output and database state
5. **Evidence Requirement**: Document test results, rollback steps, and any exceptions in commit messages

## 2. Code Style & Formatting Guidelines

### Import Organization (.editorconfig lines 17-18)
```csharp
// System imports first, then third-party, then local
using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON;
```

### Naming Conventions (.editorconfig lines 179-257)
- **Classes/Interfaces**: PascalCase (Interfaces prefixed with 'I')
- **Methods/Properties**: PascalCase  
- **Local Variables/Parameters**: camelCase
- **Private Fields**: `_camelCase`
- **Private Static Fields**: `s_camelCase`

```csharp
// Examples from codebase
public class Signal(float priority, Credential credential) : ICloneable
public ObjectId? PROF3T_id { get; set; } = null;
public bool Enabled { get; set; } = true;
private static readonly HttpClient _httpClient = new();
private int _retryCount;
```

### Formatting Rules
- **Indentation**: Tabs (4 spaces width)
- **Line Length**: Max 170 characters
- **Braces**: Same line (K&R style)
- **Spacing**: Before and after binary operators
- **File encoding**: UTF-8 with BOM

```csharp
// Example from H4ND.cs lines 62-78
switch (game.Name) {
    case "FireKirin":
        if (driverFresh || lastGame == null || lastGame.Name != game.Name) {
            driver!.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
        }
        if (Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 60) == false) {
            Console.WriteLine($"{DateTime.Now} - {game.House} took too long to load for {game.Name}");
            game.Lock();
        }
```

### Modern C# Features Required
- **Primary Constructors**: Use for entity types (`Signal(float priority, Credential credential)`)
- **Required Properties**: Use `required` keyword for mandatory fields
- **Nullable Reference Types**: Enabled globally - use `?` for optional types
- **Implicit Usings**: Enabled - avoid unnecessary `using System;` statements
- **Expression-bodied Properties**: Prefer `=>` for simple getters

```csharp
// Required modern patterns
[method: SetsRequiredMembers]
public class Signal(float priority, Credential credential) : ICloneable
{
    public required float Priority { get; set; } = priority;
    public required Credential Credential { get; set; } = credential;
    public ObjectId? Id { get; set; }
}
```

## 3. Error Handling Patterns

### Exception Handling Style
```csharp
// From C0MMON/Actions/Login.cs lines 11-16
try
{
    int iterations = 0;
    while (true)
    {
        if (iterations++.Equals(10))
            throw new Exception($"[{username}] Credential retries limit exceeded. Skipping this Credential.");
```

### Return Pattern for Failure Cases
```csharp
// From Actions/Login.cs lines 71-76
catch (Exception ex)
{
    Console.WriteLine($"Exception on Login: {ex.Message}");
    return false;  // Return boolean for success/failure
}
```

### Logging Requirements
- Use `Console.WriteLine()` for all logging
- Include timestamp for important events: `Console.WriteLine($"{DateTime.Now} - message");`
- Log exceptions with both message and stack trace for debugging

## 4. Structure & Ownership (Enhanced)

### Object-Centric Behavior Priority
- Domain entities should contain behavior directly related to their state
- Extract **domain services** or **automation services** when behavior grows large
- Place coordinates and UI assumptions close to owning game helper

### Recommended Folder Layout
```
/Domain
  /Entities        # Signal, Credential, Game, etc.
  /ValueObjects    # Record types, immutable data
  /Services        # Database, business logic
/Application
  /UseCases        # Application-specific workflows
  /Selectors       # Data transformation utilities
  /Schedulers      # Background processing
/Infrastructure
  /Persistence      # MongoDB, repositories
  /Automation      # Selenium, game helpers
  /Integrations    # External APIs
```

### Domain Boundaries
- **C0MMON**: Shared library for entities, storage models, automation primitives
- **H4ND/HUN7ER**: App-level processes - avoid deep domain logic
- **C0MMON/Games**: Game-specific helpers (FireKirin, OrionStars)
- **C0MMON/Actions**: Reusable automation actions (Login, Navigate, etc.)

## 5. MongoDB Collections & Schema

### Core Collections
| Collection | Purpose | Owner |
| --- | --- | --- |
| `CRED3N7IAL` | Credential + balance + DPD storage | C0MMON.Credential |
| `G4ME` | Game-level jackpot & thresholds | C0MMON.Game |
| `SIGN4L` | Signal requests for H4ND | C0MMON.Signal |
| `J4CKP0T` | Jackpot forecast rows | C0MMON.Jackpot |
| `N3XT` | Queue for H4ND non-signal polling | C0MMON.Game |
| `M47URITY` | Queue age timestamps | C0MMON.Game |

### Schema Documentation
- Document new collections or indexes in code comments
- Update this AGENTS.md when adding new entity models
- Use `GlobalSuppressions.cs` for intentional analyzer suppressions

## 6. Migration Guidance: Game → Credential Centric

### Current State
- Legacy entities: `Game`, `Signal`, `Credential`
- Migration entities: `NewGame`, `NewSignal`, `NewCredential`
- Migration collections: `G4ME_New`, `SIGN4L_New`, `CRED3N7IAL_New`

### Migration Process
1. **Provide adapters/selectors** for side-by-side operation
2. **Use feature flags** or config switches to control cutover
3. **Leave legacy code** in place until new flow is verified
4. **Test thoroughly** via PROF3T before deprecating old entities

### Naming During Migration
- Use `New*` prefix for migration entities (not V2)
- Place `* copy.cs` files under `Migration` or `V2` namespaces
- Document rollback steps in commit messages

## 7. Safety & Automation Guidelines

### PROF3T Safety Protocol
- Default state: ALL admin/test calls in `PROF3T.cs` must be commented out
- Only uncomment a single intended call for a run
- Re-comment immediately after execution
- Confirm active call list before running `PROF3T.cs`

### Automation Safety
- Keep pixel coordinates and UI assumptions close to owning game helper
- Never embed secrets in code or docs
- Note rollback steps in commit/PR summary for flow-impacting changes
- Use `Screen.WaitForColor()` with appropriate timeouts

### Code Quality Standards
- Follow `.editorconfig` rules strictly (CSharpier enforces this)
- Use nullable reference types - initialize non-nullable properties
- Prefer `readonly` fields where possible
- Keep methods under 50 lines when practical

### Data Sanity Checks
- **Sanity Threshold**: All jackpot and DPD values must be 0 ≤ value ≤ 10,000
- **HUN7ER**: Validates values before adding to `DPD.Data` arrays
- **H4ND/H0UND**: Validates jackpot values before updating game state
- **ResetGames()**: Filters out insane values from existing `DPD.Data` arrays
- **Purpose**: Prevents corrupted data from propagating through automation pipelines

## 8. Performance & Reliability

### Database Access
- Use `C0MMON.Database` for all MongoDB operations
- Implement proper connection handling and timeout management
- Use indexes for frequently queried fields

### Automation Performance
- Use appropriate wait times in `Screen.WaitForColor()`
- Implement retry logic for network operations
- Clean up browser resources in exception handlers

### Memory Management
- Dispose of `ChromeDriver` instances properly
- Use `using` statements for disposable resources
- Avoid memory leaks in long-running processes (H4ND, HUN7ER)

## 9. H4ND Application Understanding

### Core Functionality
H4ND is the primary automation worker that:
- Consumes `SIGN4L` signals or polls `N3XT` queue for games to process
- Logs into game portals (FireKirin, OrionStars) using Selenium + input simulation
- Retrieves account balances and jackpot data via WebSocket queries
- Executes slot spins when signals are active
- Updates MongoDB with balance and jackpot telemetry
- Maintains game locks to prevent concurrent processing

### Main Processing Loop (lines 40-232)
1. **Signal Selection**: Gets next signal or queues next game for processing
2. **Authentication**: Logs into appropriate game portal with credentials
3. **Data Retrieval**: Queries balances and jackpots via `QueryBalances()` method
4. **Signal Processing**: Executes spins if signal priority matches jackpot thresholds
5. **Telemetry Updates**: Updates game state, thresholds, and credential balances
6. **Cleanup**: Logs out and cleans up browser resources

### Balance & Jackpot Retrieval Pattern
```csharp
// Human-like staggering before each request (3-5 seconds)
Random random = new();
int delayMs = random.Next(3000, 5001);
Console.WriteLine($"{DateTime.Now} - Waiting {delayMs / 1000.0:F1}s before querying {game.Name} balances for {credential.Username}");
Thread.Sleep(delayMs);

// WebSocket-based data retrieval with comprehensive logging
Console.WriteLine($"{DateTime.Now} - Querying {game.Name} balances and jackpot data for {credential.Username}");
var balances = Game.QueryBalances(credential.Username, credential.Password);
Console.WriteLine($"{DateTime.Now} - {game.Name} retrieved: Balance={balances.Balance:F2}, Grand={balances.Grand:F2}, Major={balances.Major:F2}, Minor={balances.Minor:F2}, Mini={balances.Mini:F2}");
```

### Key Components
- **QueryBalances()**: Retrieves balance/jackpot data with human-like staggering and logging
- **GetBalancesWithRetry()**: Handles Grand jackpot = 0 scenarios with retry logic (max 40 attempts)
- **Game-Specific Logic**: Different login/logout flows for FireKirin vs OrionStars
- **Signal Processing**: Executes spins based on signal priority (1=Mini, 2=Minor, 3=Major, 4=Grand)
- **Jackpot Monitoring**: Detects jackpot pops and updates thresholds accordingly

### Important Patterns
- Always logs before and after data retrieval with timestamps
- Uses 3-5 second random delays to appear human-like
- Handles Grand jackpot = 0 as special case requiring retries
- Maintains game locks during processing to prevent conflicts
- Updates both `G4ME` collection (jackpots) and `CRED3N7IAL` collection (balances)

## 10. Versioning & Deployment

### Current Version
- Version: 0.8.5.6 (defined in `Directory.Build.props`)
- Target Framework: .NET 10.0-windows7.0
- All projects share version via Directory.Build.props

### Deployment Notes
- H4ND, H0UND, and HUN7ER are designed to run as always-on processes
- Console applications output Figgle banners with version info
- Ensure MongoDB connectivity before starting workers

## 11. H0UND Application Understanding

### Core Functionality
H0UND is the retrieval-only worker that:
- Polls `N3XT` queue for games to process (no signal handling)
- Logs into game portals (FireKirin, OrionStars) using Selenium + input simulation
- Retrieves account balances and jackpot data via WebSocket queries
- Updates MongoDB with balance and jackpot telemetry
- **Does NOT execute slot spins or process signals**

### Key Differences from H4ND
- **No Signal Processing**: Only processes games from queue, ignores `SIGN4L` collection
- **No Slot Execution**: Only retrieves data, never performs spins
- **Simpler Flow**: Login → Retrieve → Update → Logout → Repeat
- **Continuous Monitoring**: Runs in loops to monitor all games without signal triggers

### Main Processing Loop
1. **Game Selection**: Gets next game from `N3XT` queue
2. **Authentication**: Logs into appropriate game portal with credentials
3. **Data Retrieval**: Uses same `QueryBalances()` method with human-like staggering
4. **Telemetry Updates**: Updates both `G4ME` and `CRED3N7IAL` collections
5. **Cleanup**: Logs out and waits 5 seconds before next game

### Usage Scenarios
- **Background Monitoring**: Continuous balance/jackpot monitoring without signal interference
- **Data Collection**: Gathers telemetry for analytics and forecasting
- **Health Checks**: Verifies game portals are accessible and responsive
- **Manual Mode**: Safe alternative to H4ND when signal processing is disabled

### Important Patterns
- Same human-like staggering (3-5 seconds) as H4ND for consistency
- Identical balance query logging and retry logic
- Always logs out after each game retrieval to maintain clean state
- 30-second restart delay on errors to prevent rapid-fire failures

## 12. HUN7ER Algorithm Documentation

### Core Functionality
HUN7ER is the analytics worker that:
- Monitors DPD (Dollars Per Day) growth rates for all games
- Calculates time-to-threshold predictions for each jackpot tier
- Generates forecast rows in `J4CKP0T` collection
- Creates signals in `SIGN4L` when jackpots are near thresholds
- Calculates house potential and funding recommendations

### Key Algorithms

#### DPD (Dollars Per Day) Calculation (lines 56-78)
```csharp
// Calculate DPD from last 2 data points
float minutes = Convert.ToSingle(
    game.DPD.Data[game.DPD.Data.Count - 1].Timestamp
        .Subtract(game.DPD.Data[0].Timestamp).TotalMinutes
);
double dollars = game.DPD.Data[game.DPD.Data.Count - 1].Grand 
    - game.DPD.Data[0].Grand;
float days = minutes / 1440f; // Convert minutes to days
double dollarsPerDay = dollars / days;
```
**Formula**: `DPD = (Grand2 - Grand1) / (TimeDifferenceInMinutes / 1440)`

#### Minutes-to-Jackpot Calculation (lines 109-138)
```csharp
double DPM = game.DPD.Average / 1440; // Dollars Per Minute
double estimatedGrowth = DateTime.Now.Subtract(game.LastUpdated).TotalMinutes * DPM;
double MinutesToGrand = Math.Max(
    (game.Thresholds.Grand - (game.Jackpots.Grand + estimatedGrowth)) / DPM, 0
);
```
**Formula**: `MinutesToThreshold = Max(0, (Threshold - (Current + EstimatedGrowth)) / DPM)`

#### Jackpot Prediction Algorithm (lines 212-238)
```csharp
// Calculate capacity for each jackpot tier
double capacity = jackpot.Threshold - jackpot.Category switch {
    "Grand" => 1500,  // Base threshold offset
    "Major" => 500,
    "Minor" => 100, 
    "Mini" => 20,
    _ => 0,
};
double daysToAdd = capacity / game.DPD.Average; // Days to grow by capacity
```
**Formula**: `DaysToAdd = (Threshold - BaseOffset) / DPD`

#### Signal Qualification Logic (lines 253-294)
Signals are generated when ANY of these conditions are met:
1. **Priority ≥ 2** and **< 6 hours** to threshold and **threshold - current < 0.1** and **avgBalance ≥ 6**
2. **Priority ≥ 2** and **< 4 hours** to threshold and **threshold - current < 0.1** and **avgBalance ≥ 4**  
3. **Priority ≥ 2** and **< 2 hours** to threshold
4. **Priority = 1** and **< 1 hour** to threshold

#### House Potential Calculation (lines 298-320)
```csharp
// Sum all jackpot thresholds per house
Dictionary<string, double> potentials = [];
predictions.ForEach(delegate (Jackpot jackpot) {
    if (potentials.ContainsKey(jackpot.House))
        potentials[jackpot.House] += jackpot.Threshold;
    else
        potentials.Add(jackpot.House, jackpot.Threshold);
});

// Calculate funding recommendations
int give = (int)potential / 100;  // $100 per unit of recommendation
if (potential - (give * 100) > 74) give++; // Round up if >$74 remainder
```
**Formula**: `Recommendation = RoundUp(Potential / 100)`

### Processing Flow
1. **DPD Monitoring**: Track Grand jackpot growth rates, reset on jackpot pops
2. **Prediction Generation**: Create forecast rows for all enabled jackpot tiers
3. **Signal Qualification**: Generate signals when jackpots approach thresholds
4. **House Analysis**: Calculate potential and funding recommendations per house
5. **Cleanup**: Remove expired signals and update timing information

### Key Data Structures
- **DPD_Data**: Individual Grand jackpot data points with timestamps
- **DPD_History**: Historical DPD averages and data point series
- **Jackpot**: Forecast row with estimated threshold dates and priorities
- **Signal**: Actionable signal for H4ND with timeout and acknowledgment

### Important Constants
- **Base Offsets**: Grand=1500, Major=500, Minor=100, Mini=20
- **Funding Unit**: $100 per recommendation unit (round up >$74)
- **Processing Interval**: 10 seconds between cycles
- **Forecast Horizon**: 5 days from current date

## 13. Provenance & Evidence Requirements

### Evidence-First Development
All critical changes must include:
- **Intent Documentation**: Clear statement of what changes and why
- **Lineage References**: Links to related tickets, ADRs, or requirements
- **Rollback Plan**: Specific steps to revert changes safely
- **Success Criteria**: Measurable outcomes that verify change effectiveness

### Change Evidence Pack
For any automation-impacting change, document:
```markdown
## Change Evidence
**Scope**: [What changes]
**Inputs**: [Parameters, configurations]
**Artifacts**: [Files modified, created]
**Rollback**: [Specific revert steps]
**Success**: [Verification criteria]
```

### Provenance in Code
- Use descriptive commit messages that include intent and impact
- Reference evidence in PR descriptions (test results, manual verification steps)
- Tag automated operations with run IDs for traceability
- Preserve lineage through feature flags and adapters during migrations

### Quality Gates
- **Code Review**: Must pass CSharpier formatting and have clear change rationale
- **Testing**: PROF3T verification with documented results
- **Documentation**: Update relevant sections in this AGENTS.md file
- **Rollback**: Verify rollback path before merging automation changes
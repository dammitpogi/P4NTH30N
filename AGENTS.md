# P4NTH30N Agent Conventions

This file defines project-wide conventions for structure, naming, and behavior. These rules apply to the entire repo unless overridden by a nested `AGENTS.md`.

## 1. Essential Commands

### Build & Run
```bash
# Build entire solution
dotnet build P4NTH30N.sln

# Build specific project
dotnet build C0MMON\C0MMON.csproj
dotnet build H4ND\H4ND.csproj
dotnet build HUN7ER\HUN7ER.csproj

# Run applications
dotnet run --project H4ND\H4ND.csproj        # Main automation worker
dotnet run --project HUN7ER\HUN7ER.csproj    # Analytics worker
dotnet run --project PROF3T\PROF3T.csproj    # Test harness
```

### Code Quality
```bash
# Format all code using CSharpier (v1.1.2)
dotnet csharpier .

# Check formatting without applying changes
dotnet csharpier . --check
```

### MongoDB Database Operations
```bash
# Connect to P4NTH30N database
mongosh P4NTH30N

# Query a collection
mongosh P4NTH30N --eval "db.G4ME.find().limit(5).pretty()"

# Count documents
mongosh P4NTH30N --eval "db.CRED3N7IAL.countDocuments()"

# View collection info (including views)
mongosh P4NTH30N --eval "db.getCollectionInfos({name: 'N3XT'})"

# Execute complex operations
mongosh P4NTH30N --eval "$(cat <<'EOF'
  // Multi-line MongoDB operations
  const doc = db.G4ME.findOne();
  printjson(doc);
EOF
)"
```

### Testing Approach
**PROF3T Test Harness** - No traditional unit tests:
1. Open `PROF3T/PROF3T.cs` and uncomment ONE test method call
2. Run `dotnet run --project PROF3T\PROF3T.csproj`
3. Re-comment after execution
4. Document results and rollback steps in commit messages

## 2. Code Style & Naming

### Import Organization
```csharp
// System imports first, then third-party, then local
using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON;
```

### Naming Conventions
- **Classes/Interfaces**: PascalCase (Interfaces prefixed with 'I')
- **Methods/Properties**: PascalCase  
- **Local Variables/Parameters**: camelCase
- **Private Fields**: `_camelCase`
- **Private Static Fields**: `s_camelCase`

```csharp
public class Signal(float priority, Credential credential) : ICloneable
public ObjectId? PROF3T_id { get; set; } = null;
public bool Enabled { get; set; } = true;
private static readonly HttpClient _httpClient = new();
```

### Modern C# Features Required
- **Primary Constructors**: Use for entity types
- **Required Properties**: Use `required` keyword
- **Nullable Reference Types**: Enabled globally - use `?` for optional
- **Expression-bodied Properties**: Prefer `=>` for simple getters

### Formatting Rules
- **Indentation**: Tabs (4 spaces width)
- **Line Length**: Max 170 characters
- **Braces**: Same line (K&R style)
- **Encoding**: UTF-8 with BOM

## 3. Error Handling & Logging

### Exception Handling Style
```csharp
try {
    int iterations = 0;
    while (true) {
        if (iterations++.Equals(10))
            throw new Exception($"[{username}] Credential retries limit exceeded.");
        // Success logic
        return true;
    }
}
catch (Exception ex) {
    Console.WriteLine($"Exception on Operation: {ex.Message}");
    return false;  // Boolean return pattern
}
```

### Logging Requirements
- Use `Console.WriteLine()` for all logging
- Include timestamp: `Console.WriteLine($"{DateTime.Now} - message");`
- Log exceptions with message and context for debugging

## 4. Safety & Testing Rules

### PROF3T Safety Protocol
- Default state: ALL admin/test calls in `PROF3T.cs` must be commented out
- Only uncomment a single intended call for a run
- Re-comment immediately after execution
- Confirm active call list before running `PROF3T.cs`

### Data Validation
- **Sanity Threshold**: All jackpot and DPD values must be 0 ≤ value ≤ 10,000
- Validate all incoming data before processing
- Use proper exception handling to prevent corrupted data propagation

### Code Safety
- Never embed secrets in code or documentation
- Note rollback steps in commit/PR summary for flow-impacting changes
- Use `Screen.WaitForColor()` with appropriate timeouts in automation

## 5. MongoDB Database Context

### Database Information
- **Database Name**: `P4NTH30N`
- **Connection**: Localhost MongoDB instance (connection strings in `C0MMON/Database.cs`)
- **Driver**: MongoDB.Driver (C# driver)
- **Shell**: `mongosh` for command-line operations

### Working with Collections
Collections store actual documents and support full CRUD operations:

```bash
# View documents
mongosh P4NTH30N --eval "db.G4ME.find().pretty()"

# Count documents
mongosh P4NTH30N --eval "db.CRED3N7IAL.countDocuments()"

# Insert document
mongosh P4NTH30N --eval "db.COLLECTION_NAME.insertOne({field: 'value'})"

# Update document
mongosh P4NTH30N --eval "db.COLLECTION_NAME.updateOne({_id: ObjectId('...')}, {\$set: {field: 'newValue'}})"

# Delete document
mongosh P4NTH30N --eval "db.COLLECTION_NAME.deleteOne({_id: ObjectId('...')})"
```

### Working with Views
Views are virtual collections created from aggregation pipelines. They are **read-only**.

```bash
# Query a view (read-only)
mongosh P4NTH30N --eval "db.N3XT.findOne()"

# View the pipeline definition
mongosh P4NTH30N --eval "db.getCollectionInfos({name: 'N3XT'})"

# Drop a view
mongosh P4NTH30N --eval "db.N3XT.drop()"

# Create/recreate a view
mongosh P4NTH30N --eval "
db.createView('N3XT', ' QU3UE', [
  { \$sort: { Updated: 1 } },
  { \$match: { Unlocked: true } },
  { \$limit: 1 },
  { \$lookup: {
      from: 'G4ME',
      let: { queueHouse: '\$House', queueGame: '\$Game' },
      pipeline: [
        { \$match: {
            \$expr: {
              \$and: [
                { \$eq: ['\$House', '\$\$queueHouse'] },
                { \$eq: ['\$Name', '\$\$queueGame'] }
              ]
            }
          }
        }
      ],
      as: 'gameDoc'
    }
  },
  { \$unwind: { path: '\$gameDoc' } },
  { \$replaceRoot: { newRoot: '\$gameDoc' } }
])
"
```

### Key View: N3XT
The `N3XT` view is critical for queue-based game processing:

- **Source**: ` QU3UE` collection (contains queue metadata)
- **Purpose**: Returns the next game to process
- **Output Schema**: Full `Game` entity from `G4ME` collection
- **Used By**: `Game.GetNext()` in C# code

**Pipeline Logic**:
1. Sort ` QU3UE` by `Updated` (oldest first = highest priority)
2. Filter for `Unlocked: true` (available for processing)
3. Limit to 1 document
4. Lookup matching `Game` from `G4ME` by `House` and `Name`
5. Replace root with the `Game` document

This design separates **queue logic** (in ` QU3UE`) from **game data** (in `G4ME`), allowing independent management of priorities while ensuring C# code receives proper `Game` entities.

### Common MongoDB Patterns

**Backup before modifications**:
```bash
mongosh P4NTH30N --eval "
db.COLLECTION_NAME.find().forEach(doc => {
  db.COLLECTION_NAME_BACKUP.insertOne(doc);
})
"
```

**Bulk operations**:
```bash
mongosh P4NTH30N --eval "
db.G4ME.updateMany(
  { Enabled: true },
  { \$set: { Updated: false } }
)
"
```

**Aggregation pipelines**:
```bash
mongosh P4NTH30N --eval "
db.CRED3N7IAL.aggregate([
  { \$match: { Enabled: true } },
  { \$group: { _id: '\$House', total: { \$sum: '\$Balance' } } },
  { \$sort: { total: -1 } }
]).pretty()
"
```

## 6. Project Structure

### Core Projects
- **C0MMON**: Shared library for entities, storage models, automation primitives
- **H4ND**: Main automation worker (consumes signals, executes spins)
- **HUN7ER**: Analytics worker (calculates DPD, generates signals)
- **PROF3T**: Test harness and admin tools
- **H0UND**: Retrieval-only worker (no signal processing)

### MongoDB Collections
| Collection | Purpose | Owner |
|---|---|---|
| `CRED3N7IAL` | Credential + balance + DPD storage | C0MMON.Credential |
| `G4ME` | Game-level jackpot & thresholds | C0MMON.Game |
| `SIGN4L` | Signal requests for H4ND | C0MMON.Signal |
| `J4CKP0T` | Jackpot forecast rows | C0MMON.Jackpot |
| ` QU3UE` | Queue/priority data for game processing | HUN7ER |
| `H0USE` | House metadata and lifecycle | C0MMON.House |
| `EV3NT` | Process audit events | C0MMON.ProcessEvent |
| `REC31VED` | Signal receipt tracking | C0MMON.NewReceived |

### MongoDB Views
**Views are read-only virtual collections based on aggregation pipelines. They cannot be directly modified - only their pipeline definition can be changed.**

| View | Source Collection | Purpose | Pipeline Summary |
|---|---|---|---|
| `N3XT` | ` QU3UE` | Next game to process (queue head) | Sort by Updated → Filter Unlocked → Limit 1 → Lookup G4ME → Return Game schema |
| `M47URITY` | ` QU3UE` | Queue age timestamps (oldest queue item) | Match Priority ≤ 20 → Sort by Updated → Limit 1 → Project Updated field only |
| `UPC0M1NG` | Unknown | Upcoming signals/events | View definition TBD |
| `F0GOfW4R` | Unknown | Fog of war analytics | View definition TBD |

**Important**: When `Game.GetNext()` queries the `N3XT` view, it receives a full `Game` document from the `G4ME` collection (via `$lookup`), not the raw queue data from ` QU3UE`. This ensures proper C# deserialization to the `Game` entity class.

### Collections vs Views
- **Collections**: Actual stored data that can be inserted, updated, deleted
  - Examples: `G4ME`, `CRED3N7IAL`, ` QU3UE`
  - Use `db.collection.insertOne()`, `updateOne()`, `deleteOne()`
  
- **Views**: Read-only results of aggregation pipelines on collections
  - Examples: `N3XT`, `M47URITY`, `UPC0M1NG`
  - Cannot be modified directly (no insert/update/delete)
  - To "change" a view: recreate it with `db.createView()` or modify underlying collection
  - Useful for complex queries, joins, transformations without data duplication

### Domain Boundaries
- **C0MMON/Games**: Game-specific helpers (FireKirin, OrionStars)
- **C0MMON/Actions**: Reusable automation actions (Login, Navigate, etc.)
- **H4ND/HUN7ER**: App-level processes - avoid deep domain logic

## 7. Quick Reference Patterns

### Human-like Delays (Required)
```csharp
Random random = new();
int delayMs = random.Next(3000, 5001);
Console.WriteLine($"{DateTime.Now} - Waiting {delayMs / 1000.0:F1}s before querying...");
Thread.Sleep(delayMs);
```

### Database Access Pattern
```csharp
Database database = new();
IMongoCollection<Credential> collection = database.IO.GetCollection<Credential>("CRED3N7IAL");
return collection.Find(Builders<Credential>.Filter.Empty)
                 .SortByDescending(c => c.Balance)
                 .ToList();
```

### Automation Flow
1. **Signal Selection**: Gets next signal or queues next game
2. **Authentication**: Logs into appropriate game portal
3. **Data Retrieval**: Queries balances with human-like staggering
4. **Processing**: Executes actions based on signal priority
5. **Telemetry Updates**: Updates game state and credential balances
6. **Cleanup**: Logs out and cleans up resources

### Critical Constants
- **Processing Intervals**: 10s (HUN7ER), 3-5s (queries)
- **Retry Limits**: 10 attempts (login), 40 attempts (Grand jackpot = 0)
- **Sanity Checks**: 0 ≤ value ≤ 10,000 for all financial data
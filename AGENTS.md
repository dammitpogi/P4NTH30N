# P4NTH30N Repository

## Responsibility

P4NTH30N is a multi-process automation platform built in C# that coordinates **jackpot discovery**, **signal generation**, and **automated spins** for supported casino game portals.

## Architecture Overview

```
H0UND (polling + analytics loop)
  ├─ reads CRED3N7IAL (credentials)
  ├─ builds DPD + forecasts jackpots
  └─ writes SIGN4L + J4CKP0T (signals + predictions)

H4ND (automation loop)
  ├─ pulls SIGN4L (or N3XT queue if no signal)
  ├─ logs in via Selenium + input simulation
  ├─ reads jackpot/balance values via JS
  └─ updates G4ME / CRED3N7IAL data
```

## Core Agents

| Agent | Purpose | Entry Point |
|-------|---------|-------------|
| **H4ND** | Executes browser automation (login, navigate, read jackpots, spin) | `H4ND/H4ND.cs` |
| **H0UND** | Polls credentials, computes DPD, forecasts jackpots, emits signals | `H0UND/H0UND.cs` |
| **C0MMON** | Shared library with entities, MongoDB access, automation primitives | `C0MMON/` |

## Supporting Tools

| Tool | Purpose |
|------|---------|
| **W4TCHD0G** | Vision system placeholder for future OBS integration |
| **PROF3T** | Autonomous learning system placeholder |
| **RUL3S** | Resource override rules and Chrome extension for browser manipulation |
| **CLEANUP** | Data cleanup and corruption prevention utilities |
| **T00L5ET** | Toolset utilities |
| **UNI7T35T** | Unit testing project |

## Data Model (MongoDB Collections)

| Collection | Purpose |
|------------|---------|
| `CRED3N7IAL` | Credential + balance + DPD storage |
| `G4ME` | Game-level jackpot & thresholds |
| `SIGN4L` | Signal requests for H4ND |
| `J4CKP0T` | Jackpot forecast rows |
| `N3XT` | Queue for H4ND non-signal polling |
| `M47URITY` | Queue age timestamps |
| `EV3NT` | Event data (signals, game events) |
| `ERR0R` | Validation errors and processing failures |
| `H0U53` | House/location organization |

---

## Build, Lint, and Test Commands

### Build Commands
```bash
# Development builds
# - Default is Debug; keep it that way during development.
# - Agents should not build Release. The Nexus handles production Release builds.

# Build entire solution (using .slnx file)
dotnet build P4NTH30N.slnx

# Explicit Debug build (preferred when being explicit)
dotnet build P4NTH30N.slnx -c Debug

# Build with full paths (VS Code default)
dotnet build P4NTH30N.slnx /property:GenerateFullPaths=true /consoleloggerparameters:NoSummary

# Build specific project
dotnet build C0MMON/C0MMON.csproj
dotnet build H4ND/H4ND.csproj
dotnet build H0UND/H0UND.csproj

# Explicit Debug build for a specific project
dotnet build H0UND/H0UND.csproj -c Debug

# Clean and rebuild
dotnet clean P4NTH30N.slnx
dotnet build P4NTH30N.slnx --no-incremental
```

### Lint and Format Commands
```bash
# Format all code with CSharpier
dotnet csharpier .

# Check formatting without applying changes (CI/CD verification)
dotnet csharpier check

# Format a specific file or directory
dotnet csharpier format C0MMON/
dotnet csharpier format H4ND/
dotnet csharpier format H0UND/
```

### Test Commands
```bash
# Unit tests / build-test gate (development)
# We validate builds by running the UnitTest project.
dotnet test UNI7T35T/UNI7T35T.csproj

# Run tests with coverage
dotnet test UNI7T35T/UNI7T35T.csproj --collect:"XPlat Code Coverage"

# Run specific test class or method
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~TestClassName"
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~TestMethodName"

# Watch mode for TDD
dotnet watch test --project ./UNI7T35T/UNI7T35T.csproj
```

### Verification Steps
```bash
# 1. Verify build
dotnet build P4NTH30N.slnx --no-restore
# Check: No errors or warnings (except nullable warnings if enabled)
# Note: Currently failing with CS1729 in MongoUnitOfWork.cs - see investigation

# 2. Verify formatting
dotnet csharpier check
# Check: Exit code 0 means formatted correctly
# Note: Use 'dotnet csharpier .' to apply formatting

# 3. Run tests
# Run the UnitTest project to validate builds (Debug).
dotnet test UNI7T35T/UNI7T35T.csproj
# Check: All tests pass (exit code 0)
# Note: Test framework exists but may not be fully implemented

# 4. Verify dependencies
dotnet restore P4NTH30N.slnx
# Check: All packages restore successfully

# 5. Runtime verification
dotnet run --project ./H0UND/H0UND.csproj -- --dry-run
dotnet run --project ./H4ND/H4ND.csproj -- --dry-run
# Check: Agents start without errors and initialize properly
# Prerequisite: MongoDB connection must be established
```

## Cartography And Codemaps

This repo uses Cartography to keep `codemap.md` files up to date. These files are auto-generated and auto-injected into agent context when you work in a directory.

- Do not delete `**/codemap.md` files or `.slim/cartography.json`.
- If you finish a task that changes code structure, run Cartography before considering the task complete.

```bash
# Detect which maps need updating
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes --root ./

# Update all affected codemaps
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update --root ./
```

## Code Style Guidelines

### Imports and Using Directives
- **Sort System directives first**: `dotnet_sort_system_directives_first = true`
- **Don't separate import groups**: `dotnet_separate_import_directive_groups = false`
- **Place outside namespace**: `csharp_using_directive_placement = outside_namespace`
- **Remove unused usings**: Keep code clean, IDE will suggest removals

### Formatting
- **Line endings**: CRLF (Windows) - `* text=auto` in .gitattributes, use `unix2dos` to convert
- **Indentation**: Tabs (width 4) - `indent_style = tab`, `indent_size = 4`
- **Line length**: Maximum 170 characters - `max_line_length = 170`
- **Braces**: Same line (K&R style) - `csharp_new_line_before_open_brace = none`
- **Trim trailing whitespace**: Always - `trim_trailing_whitespace = true`
- **Final newline**: Do not insert - `insert_final_newline = false`

### Types and Variables
- **Use predefined types**: Prefer `int` over `Int32`, `string` over `String`
- **var usage**: Avoid `var` (set to false:silent for all cases)
  - Use explicit types: `List<string> items = new List<string>()` not `var items = new List<string>()`
- **Nullable reference types**: Enabled - always check for null on reference types
- **Implicit object creation**: Allowed when type is apparent - `csharp_style_implicit_object_creation_when_type_is_apparent = true`

### Naming Conventions
- **PascalCase**: Public members, methods, properties, events, types, namespaces
- **camelCase**: Local variables, parameters, local constants
- **_camelCase**: Private fields (prefix with underscore)
- **s_camelCase**: Private static fields (prefix with s_)
- **IPascalCase**: Interfaces (prefix with I)
- **TPascalCase**: Type parameters (prefix with T)

### Modern C# Features
- **Primary constructors**: Preferred - `csharp_style_prefer_primary_constructors = true`
- **File-scoped namespaces**: Preferred - `csharp_style_namespace_declarations = file_scoped`
- **Expression-bodied members**: Use for accessors, indexers, properties
- **Pattern matching**: Preferred over traditional casts
- **Null propagation**: Use `?.` operator - `csharp_style_null_propagation = true`

### Error Handling
```csharp
// Standard retry pattern with line number logging
try {
    int iterations = 0;
    while (true) {
        if (iterations++.Equals(10))
            throw new Exception($"[{username}] Retries exceeded.");
        return true;
    }
}
catch (Exception ex) {
    var frame = new StackTrace(ex, true).GetFrame(0);
    int line = frame?.GetFileLineNumber() ?? 0;
    Console.WriteLine($"[{line}] Processing failed: {ex.Message}");
    return false;
}
```

**Key principles**:
- Always log line numbers for debugging
- Include context in exception messages (username, operation, etc.)
- Use specific exception types when possible
- Consider using `Result<T>` pattern for expected failures

### Validation & Error Logging Pattern

**Philosophy**: Validate but don't mutate - invalid data is logged to ERR0R, not auto-repaired.

**Interface Naming Convention** (I<Verb><Noun> pattern):
- `IReceiveSignals` (was IReceive) - for receiving/processing signals
- `IStoreEvents` (was IProcessEvents) - for event storage operations
- `IStoreErrors` (was IErrorLog) - for error logging operations

**Entity Validation Pattern**:
```csharp
// Entities implement IsValid with optional error logging
public bool IsValid(IStoreErrors? errorLog = null)
{
    bool isValid = true;
    
    if (string.IsNullOrEmpty(RequiredField))
    {
        errorLog?.LogError($"[{nameof(EntityType)}] Validation failed: RequiredField is null or empty");
        isValid = false;
    }
    
    // Additional validation checks...
    
    return isValid;
}
```

**Validation Usage in Services**:
```csharp
// H4ND, H0UND - inline validation, no auto-repair
if (!entity.IsValid(_errorStore))
{
    // Entity is logged to ERR0R collection via IStoreErrors
    // Processing continues or skips based on severity
    continue;
}
```

**Key Changes** (recent refactor):
- **Removed**: P4NTH30NSanityChecker and all auto-repair sanity checkers
- **Added**: Validation errors logged to `ERR0R` MongoDB collection
- **Updated**: All entities (Credential, Jackpot, DPD) use `IsValid(IStoreErrors?)` pattern
- **Health Monitoring**: Uses ERR0R collection queries instead of internal counters

**Collections**:
- `EV3NT` - Event data (signals, game events)
- `CR3D3N7IAL` - User credentials and settings
- `ERR0R` - Validation errors and processing failures

**Repository Classes** (renamed to avoid conflicts):
- `ReceivedRepository` (was `Received`) - implements `IReceiveSignals`

### Async/Await
- **Async suffix**: Methods with async operations should end with "Async"
- **ConfigureAwait**: Use `ConfigureAwait(false)` for library code
- **Avoid async void**: Only use for event handlers

### MongoDB/EF Core Specific
- **Hybrid pattern**: H4ND uses MongoDB.Driver, H0UND uses EF Core for analytics
- **BSON serialization**: Be aware of private field deserialization bypassing setters
- **Entity design**: Use records for immutable data, classes for mutable state

### Credentials & Security
- **Current priority**: Automation first - credentials stored in plain text in EV3NT collection is acceptable for now
- **Future hardening**: Password encryption, credential vault, access controls - down the road after agentic processing is complete


**Always use toolhive for MCP tools**:
```
1. toolhive_find_tool({ tool_description: "...", tool_keywords: "..." })
2. toolhive_call_tool({ server_name: "...", tool_name: "...", parameters: {...} })
```

**Communication Style**:
- Concise execution, no preamble
- Brief delegation notices: "Checking docs via @librarian..."
- Honest pushback when approaches seem problematic

## MCP Servers (via toolhive)

- **toolhive**: Tool discovery and execution wrapper (localhost:22368)
- **Disabled**: websearch, context7, grep_app (use toolhive instead)

### MongoDB MCP (toolhive-mcp)

Database: `P4NTH30N`
Collection: `CRED3N7IAL`

```csharp
// Tool discovery
toolhive_find_tool({ tool_description: "MongoDB database operations", tool_keywords: "MongoDB database update query delete" })

// Available tools (via toolhive_call_tool):
// - find: Query documents
// - aggregate: Run aggregations
// - update-many: Update all matching documents
// - delete-many: Delete matching documents
// - create-collection: Create new collection
// - drop-collection: Delete collection
// - drop-database: Delete database
// - list-databases: List all databases
// - connect: Connect to MongoDB instance
```

**Example - Reset Credential Thresholds:**
```javascript
// First connect (if needed)
toolhive_call_tool({
  server_name: "mongodb",
  tool_name: "connect",
  parameters: { connectionString: "mongodb://localhost:27017/" }
})

// Then update thresholds to defaults
toolhive_call_tool({
  server_name: "mongodb",
  tool_name: "update-many",
  parameters: {
    database: "P4NTH30N",
    collection: "CRED3N7IAL",
    filter: { "Thresholds.Grand": { "$gt": 15000 } },  // or whatever filter
    update: { "$set": { "Thresholds.Grand": 1785, "Thresholds.Major": 565, "Thresholds.Minor": 117, "Thresholds.Mini": 23 } }
  }
})
```

## C0MMON Project Structure

Following SOLID and DDD principles:

```
C0MMON/
├── Domain/           # FUTURE: Entities & ValueObjects (not yet migrated)
├── Interfaces/       # Contracts - IRepo<Entity>, IStoreErrors, etc.
│   ├── IRepoCredentials.cs
│   ├── IRepoSignals.cs
│   ├── IRepoJackpots.cs
│   ├── IRepoHouses.cs
│   ├── IReceiveSignals.cs
│   ├── IStoreEvents.cs
│   └── IStoreErrors.cs
├── Infrastructure/
│   └── Persistence/  # MongoDB implementation
│       ├── MongoDatabaseProvider.cs
│       ├── MongoUnitOfWork.cs
│       ├── Repositories.cs
│       └── ValidatedMongoRepository.cs
└── [Root]           # Actions, Games, Services, etc.
    ├── Actions/      # Automation (Login, Launch, Logout, Overwrite)
    ├── Games/        # Platform parsers (FireKirin, OrionStars, etc.)
    ├── Entities/     # Domain entities (Credential, Jackpot, Signal, etc.)
    ├── Support/      # Value objects (DPD, Jackpots, Thresholds, GameSettings)
    ├── Services/     # Dashboard (monitoring UI)
    ├── EF/           # Entity Framework (analytics)
    ├── Monitoring/   # Health monitoring
    └── Versioning/   # App version
```

**Namespace Patterns:**
- Interfaces: `P4NTH30N.C0MMON.Interfaces`
- Infrastructure: `P4NTH30N.C0MMON.Infrastructure.Persistence`
- Entities: `P4NTH30N.C0MMON` (root - not yet migrated to Domain/)

**Global Usings** (in C0MMON/GlobalUsings.cs):
```csharp
global using P4NTH30N.C0MMON.Interfaces;
global using P4NTH30N.C0MMON.Infrastructure.Persistence;
```

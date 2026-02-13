## Build, Lint, and Test Commands

### Build Commands
```bash
# Build entire solution
dotnet build

# Build specific project
dotnet build C0RR3CT/C0RR3CT.csproj

# Build with full paths (VS Code default)
dotnet build /property:GenerateFullPaths=true /consoleloggerparameters:NoSummary
```

### Lint and Format Commands
```bash
# Format all code with CSharpier
dotnet csharpier .

# Check formatting without applying changes
dotnet csharpier . --check
```

### Test Commands
**No test framework is currently implemented.** When adding tests:
```bash
# Run all tests (future)
dotnet test

# Run specific test
dotnet test --filter "FullyQualifiedName~TestClassName"

# Watch mode for TDD (future)
dotnet watch test
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
// H4ND, H0UND, HUN7ER - inline validation, no auto-repair
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
- **Hybrid pattern**: H4ND uses MongoDB.Driver, HUN7ER uses EF Core
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
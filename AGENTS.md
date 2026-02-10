# P4NTH30N Agent Conventions

Project-wide conventions for .NET 10 C# codebase with MongoDB backend.

## 1. Essential Commands

### Build & Run
```bash
# Build entire solution (6 projects in .slnx)
dotnet build P4NTH30N.slnx

# Build specific project
dotnet build C0MMON\C0MMON.csproj
dotnet build H4ND\H4ND.csproj          # Main automation worker
dotnet build HUN7ER\HUN7ER.csproj      # Analytics worker
dotnet build PROF3T\PROF3T.csproj      # Test harness (HUN7ER logic lives here)
dotnet build H0UND\H0UND.csproj        # Retrieval-only worker
dotnet build W4TCHD0G\W4TCHD0G.csproj

# Run applications
dotnet run --project H4ND\H4ND.csproj
dotnet run --project HUN7ER\HUN7ER.csproj
dotnet run --project PROF3T\PROF3T.csproj

# Format (CSharpier v1.1.2 - no config file, uses defaults)
dotnet csharpier .
dotnet csharpier . --check
```

### Testing (PROF3T Harness)
No traditional unit tests. To run a single test:
1. Open `PROF3T/PROF3T.cs`
2. Uncomment ONE test method call (all others must be commented out)
3. Run `dotnet run --project PROF3T\PROF3T.csproj`
4. Re-comment immediately after execution
5. Document results in commit message

**Safety Protocol**: Default state = ALL test calls commented out. Confirm active calls before running.

### MongoDB Operations
```bash
# Connect and query
mongosh P4NTH30N --eval "db.CRED3N7IAL.find().limit(5).pretty()"
mongosh P4NTH30N --eval "db.getCollectionInfos({name: 'N3XT_CRED'})"

# Key collections: CRED3N7IAL, SIGN4L, J4CKP0T, H0USE, EV3NT, REC31VED
# Key views: N3XT_CRED, QU3UE_CRED, M47URITY_CRED, UPC0M1NG
```

## 2. Code Style

### Formatting (enforced by .editorconfig)
- **Indentation**: Tabs (width 4)
- **Line Length**: Max 170 characters
- **Braces**: Same line (K&R style)
- **Encoding**: UTF-8
- **Namespace**: File-scoped preferred

### Import Order
```csharp
using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON;
```

### Naming Conventions
| Element | Pattern | Example |
|---------|---------|---------|
| Classes | PascalCase | `public class Credential` |
| Interfaces | PascalCase + I | `public interface ICloneable` |
| Methods/Properties | PascalCase | `public void Save()` |
| Local vars/params | camelCase | `string userName` |
| Private fields | `_camelCase` | `private double _balance` |
| Private static | `s_camelCase` | `private static readonly HttpClient s_httpClient` |

### Modern C# Required
- **Primary constructors**: `public class Credential(string game)`
- **Required properties**: `public required string House { get; set; }`
- **Nullable reference types**: Enabled globally - use `?` for optional
- **Expression-bodied**: Prefer `=>` for simple getters

## 3. Error Handling & Logging

### Pattern (as used in codebase)
```csharp
try {
    // Logic with retry limits
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

### Logging Conventions
- Use `Console.WriteLine()` for all logging
- Include timestamps: `Console.WriteLine($"{DateTime.Now} - message");`
- Use emoji indicators for severity:
  - 🔴 Critical error / validation failure
  - 🔧 Repair action applied
  - 💊 System health status
- Always log exceptions with context

## 4. Architecture & Safety

### Credential-Driven Flow
1. `Credential.GetNext()` queries `N3XT_CRED` view
2. `credential.Lock()` sets 1.5min timeout
3. Process: Query balances, update jackpots/DPD
4. `credential.Save()` persists changes
5. `credential.Unlock()` releases lock

### Data Validation Rules
- **Sanity threshold**: 0 ≤ jackpot/DPD/balance ≤ 10,000
- Validate before processing; repair if possible
- Auto-repair decimal errors (divide by 100/1000 when values exceed limits)
- Never embed secrets in code

### Delays (Human-like timing)
```csharp
Random random = new();
int delayMs = random.Next(3000, 5001);
Console.WriteLine($"{DateTime.Now} - Waiting {delayMs / 1000.0:F1}s...");
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

## 5. Project Structure

| Project | Purpose |
|---------|---------|
| **C0MMON** | Shared entities, storage, automation primitives |
| **H4ND** | Main automation worker (consumes signals) |
| **HUN7ER** | Analytics worker (DPD calculations) |
| **PROF3T** | Test harness (contains HUN7ER loop logic) |
| **H0UND** | Retrieval-only worker |
| **W4TCHD0G** | Monitoring worker |
| *Additional* | HUN7ERv2, H5ND, M4NUAL, VPN_CLI, CL0UD, C0RR3CT (not in .slnx) |

### Domain Boundaries
- **C0MMON/Games**: Game-specific helpers (FireKirin, OrionStars)
- **C0MMON/Actions**: Reusable automation actions
- **H4ND/HUN7ER/PROF3T**: App-level processes only

## 6. Critical Constants

| Setting | Value |
|---------|-------|
| HUN7ER processing interval | 10 seconds |
| Query delays | 3-5 seconds |
| Login retry limit | 10 attempts |
| Grand=0 retry limit | 40 attempts |
| Lock timeout | 1.5 minutes |
| MongoDB | `mongodb://localhost:27017/P4NTH30N` |

---

---

## Agent Skills

All agents have access to the `toolhive` skill for ToolHive MCP tool categorization:

```yaml
skill: toolhive
```

**Purpose**: Quick reference for the 10 tools across 4 MCP servers (search, scrape, crawl, docs, fetch)

**When to Load**: Before using any ToolHive tools to get category-aware guidance

### ⚠️ CRITICAL: MCP Tool Calling

**NEVER** call `websearch`, `codesearch`, `webfetch`, `tavily_search`, etc. directly - these tools do NOT exist.

**ALWAYS** use the `toolhive_*` wrapper functions:

1. **Find the tool**: `toolhive_find_tool({ tool_description: "...", tool_keywords: "..." })`
2. **Call the tool**: `toolhive_call_tool({ server_name: "...", tool_name: "...", parameters: {...} })`

**Example - Web Search**:
```javascript
// ❌ WRONG: websearch({ query: "..." })
// ✅ CORRECT:
toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: { query: "...", max_results: 5 }
})
```

See the `toolhive` skill for complete calling patterns.

---

*Note: No Cursor rules or Copilot instructions exist in this repo.*

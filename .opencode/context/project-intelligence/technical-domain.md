<!-- Context: project-intelligence/technical | Priority: critical | Version: 1.1 | Updated: 2026-01-31 -->

# Technical Domain

**Purpose**: Tech stack, architecture, development patterns for this project.
**Last Updated**: 2026-01-31

## Quick Reference
**Update Triggers**: Tech stack changes | New patterns | Architecture decisions
**Audience**: Developers, AI agents

## Primary Stack
| Layer | Technology | Version | Rationale |
|-------|-----------|---------|-----------|
| Framework | .NET | 10.0 | Modern C# with latest features, Windows console automation |
| Language | C# | 12 | Primary language for .NET, strong typing, async/await |
| Database | MongoDB | 6.0+ | Flexible document storage for automation data, collections for entities |
| Automation | Selenium | 4.40.0 | Web automation for game portal interactions |

## Code Patterns
### MongoDB Connection
```csharp
// Database connection pattern
public class Database {
    public IMongoDatabase IO { get; set; }
    
    public Database() {
        IO = new MongoClient("mongodb://10.8.12.8:27017/").GetDatabase("P4NTH30N");
    }
}
```

### Entity Pattern
```csharp
[method: SetsRequiredMembers]
public class Game(string house, string game) {
    public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
    public bool Enabled { get; set; } = true;
    public bool Unlocked { get; set; } = true;
    public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
    public required string House { get; set; } = house;
    public required string Name { get; set; } = game;
    public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
    public bool Updated { get; set; } = false;
    public Timers? Timers { get; set; } = new Timers();
    public required Jackpots Jackpots { get; set; } = new Jackpots();
}
```

## Naming Conventions
| Type | Convention | Example |
|------|-----------|---------|
| Files | PascalCase folders, PascalCase files | Domain/Entities/Game.cs, C0MMON/Database.cs |
| Classes | PascalCase | Game, Database, Credential |
| Functions | camelCase | queryBalances, updateGame |
| Database | Leetspeak (4→4, 7→7) | CRED3N7IAL, G4ME, SIGN4L, J4CKP0T |

## Code Standards
- .NET 10.0 with target framework net10.0-windows7.0
- CSharpier v1.1.2 for code formatting  
- System imports first, then third-party, then local
- Classes/Interfaces: PascalCase (prefixed with 'I')
- Methods/Properties: PascalCase
- Local Variables/Parameters: camelCase
- Private Fields: _camelCase
- Private Static Fields: s_camelCase
- Tabs for indentation (4 spaces width)
- Max line length: 170 characters
- UTF-8 with BOM encoding
- PROF3T test harness (no traditional unit tests)
- Evidence-based testing with provenance tracking

## Security Requirements
- No security requirements implemented
- Production accounts stored in MongoDB (unencrypted)
- Credentials are operational accounts, not sensitive secrets
- These are production accounts, not secrets

## 📂 Codebase References
**Implementation**: `C0MMON/Database.cs` - MongoDB connection pattern
**Implementation**: `C0MMON/Entities/Game.cs` - Entity pattern with primary constructors
**Config**: Directory.Build.props, H4ND.csproj, .editorconfig

## Related Files
- [Business Domain](business-domain.md)
- [Decisions Log](decisions-log.md)

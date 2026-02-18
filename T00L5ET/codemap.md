# T00L5ET/

## Responsibility

General utility tools and helper programs for the P4NTH30N ecosystem. Contains standalone tools for diagnostics, data manipulation, database migrations, and system administration. Includes MockFactory for test data generation and DPD migration utilities.

**Core Functions:**
- **Mock Infrastructure**: Reusable test data factories (FORGE-2024-002)
- **Database Utilities**: Migration scripts, data cleanup, report generation
- **Diagnostic Tools**: Health checks, connectivity tests, performance benchmarks
- **Administrative Tools**: User management, configuration updates, maintenance

## Design

**Architecture Pattern**: Standalone CLI tools with single responsibility
- Each tool has one clear purpose
- Command-line interface with argument parsing
- Robust error reporting and exit codes
- Uses C0MMON for shared infrastructure

### Key Components

#### Mock Infrastructure (FORGE-2024-002)
- **Mocks/MockFactory.cs**: Reusable test data factories
  - CreateCredential() - Generate test credentials with jackpots
  - CreateSignal() - Generate test signals
  - CreateJackpot() - Generate test jackpot data
  - Sensible defaults with override capabilities
  - Used by UNI7T35T for consistent test data

#### Migration Tools
- **DpdMigration.cs**: DPD data migration utilities
  - Migrate legacy DPD formats
  - Data transformation for analytics
  - Validation during migration

#### Diagnostic Tools
- Health check utilities
- Connectivity tests for MongoDB and game platforms
- Performance benchmarking

#### Administrative Tools
- User management scripts
- Configuration update utilities
- System maintenance procedures

## Flow

### Tool Execution Flow
```
dotnet run --project T00L5ET/T00L5ET.csproj -- [tool-name] [args]
    ↓
Parse Arguments
    ↓
Execute Tool
    ↓
Report Results / Exit Code
```

### MockFactory Usage Flow
```
Test or Tool needs data
    ↓
MockFactory.CreateEntity()
    ↓
Returns Populated Entity
    ↓
Use in Test/Tool
```

### Migration Flow
```
Run Migration Tool
    ↓
Connect to MongoDB (via C0MMON)
    ↓
Query Source Data
    ↓
Transform Data
    ↓
Validate Transformed Data
    ↓
Write to Destination
    ↓
Report Results
```

## Integration

### Dependencies
- **C0MMON**: Shared entities, interfaces, MongoDB access
- **MongoDB.Driver**: Database operations
- **Standard .NET**: CLI libraries, file I/O

### Consumed By
- **UNI7T35T**: Uses MockFactory for test data
- **Manual execution**: Run via dotnet CLI
- **CI/CD**: Migration scripts in deployment pipelines

### Data Access
- Uses IMongoUnitOfWork from C0MMON
- Operates on all MongoDB collections
- Follows validation patterns from C0MMON

## Key Components

### MockFactory (FORGE-2024-002)
```csharp
// Usage example
var credential = MockFactory.CreateCredential(
    username: "testuser",
    platform: "FireKirin",
    grandJackpot: 1500.00
);

var signal = MockFactory.CreateSignal(
    priority: 4, // Grand
    house: "FireKirin",
    game: "Slots"
);
```

### DpdMigration
- Legacy DPD format migration
- Data validation and cleanup
- Progress reporting

## Build Integration

### Commands
```bash
# Build toolset
dotnet build T00L5ET/T00L5ET.csproj

# Run specific tool
dotnet run --project T00L5ET/T00L5ET.csproj -- [tool-name] [args]

# List available tools
dotnet run --project T00L5ET/T00L5ET.csproj -- help
```

## Recent Additions (This Session)

**FORGE-2024-002: MockFactory**
- Comprehensive test data factory
- Supports all entity types
- Sensible defaults with customization
- Used by UNI7T35T integration tests

**DpdMigration**
- DPD data migration utilities
- Legacy format support

## Critical Notes

### Tool Development
- Single responsibility per tool
- Clear command-line interface
- Proper error handling and exit codes
- Documentation in code comments

### MockFactory Design
- Consistent naming conventions
- Realistic default values
- Edge case coverage
- Thread-safe for parallel tests

### Safety
- Validate before write operations
- Backup before migrations
- Dry-run mode for dangerous operations
- Confirmation prompts for destructive actions

# T00L5ET

## Responsibility

General utility tools and helper programs for the P4NTH30N ecosystem. Contains standalone tools for diagnostics, data manipulation, and system administration.

## When Working Here

- **Single purpose**: Each tool has one clear responsibility
- **Command-line interface**: CLI tools with argument parsing
- **Error handling**: Robust error reporting and exit codes
- **Documentation**: Usage examples in code comments

## Current Tools

- **Program.cs**: Main entry point for tool execution
- **DpdMigration.cs**: DPD (Dollars Per Day) data migration utilities
- **Mocks/**: Mock factories for testing (MockFactory.cs, MockRepoCredentials.cs, etc.)

## Tool Categories

### Diagnostics
- Health checks
- Connectivity tests
- Performance benchmarks

### Data Utilities
- **DPD Migration**: Migrate DPD calculation data between formats
- Export/import operations
- Data transformation
- Report generation

### Testing Support
- **Mock Factories**: Generate test data for unit tests
- Repository mocks for MongoDB collections
- Credential and signal mocking utilities

### Administrative
- User management
- Configuration updates
- System maintenance

## Running Tools

```bash
# Build toolset
dotnet build T00L5ET/T00L5ET.csproj

# Run specific tool
dotnet run --project T00L5ET/T00L5ET.csproj -- [tool-name] [args]

# Run DPD migration
dotnet run --project T00L5ET/T00L5ET.csproj -- dpd-migrate --source=old --target=new
```

## Adding New Tools

1. Create tool class in appropriate subdirectory
2. Implement ITool interface
3. Register in Program.cs tool registry
4. Add usage documentation
5. Include unit tests with mock factories

## Dependencies

- C0MMON: Shared entities and infrastructure
- Standard .NET libraries for CLI
- MongoDB.Driver for data operations
- Mock libraries for testing support

## Recent Updates (2026-02-19)

### DPD Migration Tools
- **DpdMigration.cs**: Utility for migrating DPD calculation formats
- Support for legacy DPD data conversion
- Validation of migrated data integrity

### Enhanced Mock Support
- **MockRepoCredentials.cs**: Complete credential mocking
- **MockReceiveSignals.cs**: Signal repository mocking
- **MockRepoHouses.cs**: House data mocking
- Integration with UNI7T35T testing framework

## Future Tools

- Database migration utilities
- Bulk import/export tools
- Analytics report generators
- System health dashboards
- CDP configuration validators

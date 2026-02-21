# M16R4710N

## Responsibility

Migration utility for transitioning between data formats or system versions. Handles data transformation, schema updates, and backward compatibility.

## When Working Here

- **Idempotency**: Migrations should be safe to run multiple times
- **Backup**: Always backup before migration
- **Validation**: Verify data integrity after migration
- **Rollback**: Provide rollback procedures
- **Logging**: Detailed logging of migration steps

## Core Components

- **Program.cs**: Migration orchestration and entry point
  - Connects to MongoDB at mongodb://localhost:27017
  - Database: P4NTH30N
  - Current migration: DPD values from Credential to Jackpot documents

## Recent Updates (2026-02-19)

### CDP Migration Support
- **Selenium to CDP Configuration**: Migrate browser automation settings
- **Extension Path Updates**: Update RUL3S extension paths for CDP compatibility
- **WebSocket Configuration**: Migrate from Selenium driver configs to CDP configs
- **Selector-Based Automation**: Convert XPath/CSS selectors for CDP targeting

### Data Structure Migrations
- **VisionCommand Collection**: New collection for FourEyes integration
- **SpinMetrics History**: Migrate operational monitoring data
- **CDP Configuration**: New config format for HostIp, Port, timeouts

## Migration Types

### Schema Migrations
- Collection structure changes
- Index creation/modification
- Field additions/removals

### Data Migrations
- Format conversions
- Data normalization
- Reference updates

### Version Upgrades
- Legacy system migration
- New feature data preparation
- Deprecation cleanup

## Running Migrations

```bash
# Run migrations
dotnet run --project M16R4710N/M16R4710N.csproj

# Dry run (preview changes)
dotnet run --project M16R4710N/M16R4710N.csproj -- --dry-run

# Specific migration
dotnet run --project M16R4710N/M16R4710N.csproj -- --migration=v2-to-v3
```

## Migration Safety

1. Test on copy of production data
2. Run during maintenance windows
3. Monitor system during migration
4. Have rollback plan ready
5. Validate data after completion

## Dependencies

- MongoDB.Driver: Direct database operations
- C0MMON: Entity definitions
- C0MMON/Infrastructure: Unit of Work for transactions

## Migration History

Track completed migrations:
- Migration version
- Execution date
- Duration
- Records affected
- Status (success/failure)

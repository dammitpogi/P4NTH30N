# CLEANUP

## Responsibility

Data cleanup and corruption prevention utilities for the P4NTH30N system. Provides tools to fix data inconsistencies, prevent corruption, and maintain database integrity.

## When Working Here

- **Data integrity**: Fix inconsistencies without data loss
- **Corruption prevention**: Proactive monitoring and prevention
- **Validation**: Ensure all data meets schema requirements
- **Logging**: Track all cleanup operations for audit
- **Safety first**: Always backup before destructive operations

## Core Components

- **ComprehensiveDataFix.cs**: Multi-phase data repair operations with validation
- **FixData.cs**: Specific data correction routines
- **MongoCleanupRunner.cs**: Orchestrates cleanup workflows
- **MongoCleanupUtility.cs**: General cleanup helper methods
- **MongoCorruptionPreventionService.cs**: Proactive corruption detection
- **QuickValidationRunner.cs**: Fast data validation checks

## Recent Updates (2026-02-19)

### Enhanced Data Validation
- **CLEANUP_REPORT.md**: Comprehensive cleanup reporting and analysis
- Improved validation for CREDENTIAL and ERR0R collections
- Enhanced orphaned record detection with relationship integrity

### CDP Migration Support
- Validation for new CDP-based configuration structures
- Cleanup of deprecated Selenium-related data
- Migration utilities for CDP credential formats

### Error Collection Management
- ERR0R collection cleanup with severity-based prioritization
- Automated stale error removal (older than 30 days)
- Validation error pattern analysis and reporting

## Key Patterns

1. **Defensive Programming**: Validate before modify
2. **Audit Trail**: Log all changes with before/after states
3. **Batch Processing**: Handle large datasets in chunks
4. **Rollback Capability**: Maintain ability to undo changes
5. **Schema Validation**: Verify against expected data structures

## Cleanup Operations

- **Orphaned Record Removal**: Delete records without parent references
- **Invalid Data Correction**: Fix NaN, null, or out-of-range values
- **Duplicate Detection**: Identify and merge duplicate entries
- **Reference Integrity**: Ensure foreign key relationships are valid
- **Timestamp Repair**: Fix missing or invalid date fields

## Corruption Prevention

- **Pre-validation**: Check data before writes
- **Transaction Boundaries**: Use atomic operations where possible
- **Monitoring**: Alert on unusual data patterns
- **Constraints**: Enforce business rules at database level

## Dependencies

- MongoDB.Driver: Direct database access
- C0MMON: Entity definitions and interfaces
- C0MMON/Infrastructure: MongoUnitOfWork for transactions

## Usage

```bash
# Run cleanup
dotnet run --project CLEANUP/CLEANUP.csproj

# Run specific fix
dotnet run --project CLEANUP/CLEANUP.csproj -- --fix=orphans
```

## Safety Guidelines

1. Always run in dry-run mode first
2. Review proposed changes before applying
3. Backup database before major cleanup
4. Monitor logs for unexpected behavior
5. Test on development data first

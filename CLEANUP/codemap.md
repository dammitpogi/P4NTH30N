# CLEANUP/

## Responsibility

Data cleanup and corruption prevention utilities for the P4NTH30N system. Provides tools to fix data inconsistencies, prevent corruption, and maintain database integrity through validation, repair, and proactive monitoring.

**Core Functions:**
- **Data Repair**: Fix inconsistencies without data loss
- **Corruption Prevention**: Proactive monitoring and prevention
- **Validation**: Ensure all data meets schema requirements
- **Audit Trail**: Track all cleanup operations
- **Safety First**: Always backup before destructive operations

## Design

**Architecture Pattern**: Utility project with specialized cleanup operations
- **Defensive Programming**: Validate before modify
- **Audit Trail**: Log all changes with before/after states
- **Batch Processing**: Handle large datasets in chunks
- **Rollback Capability**: Maintain ability to undo changes
- **Schema Validation**: Verify against expected data structures

### Key Components

#### ComprehensiveDataFix.cs
Multi-phase data repair operations:
- Coordinates multiple fix operations
- Handles dependencies between fixes
- Progress tracking and reporting
- Rollback on failure

#### FixData.cs
Specific data correction routines:
- Orphaned record removal
- Invalid value correction (NaN, null, out-of-range)
- Duplicate detection and merging
- Reference integrity repairs
- Timestamp repairs

#### MongoCleanupRunner.cs
Orchestrates cleanup workflows:
- Schedules cleanup operations
- Manages execution order
- Handles errors and retries
- Generates cleanup reports

#### MongoCleanupUtility.cs
General cleanup helper methods:
- Reusable cleanup primitives
- Common validation functions
- Batch processing utilities
- Logging helpers

#### MongoCorruptionPreventionService.cs
Proactive corruption detection:
- Pre-validation before writes
- Transaction boundary enforcement
- Monitoring for unusual patterns
- Business rule constraints

#### QuickValidationRunner.cs
Fast data validation checks:
- Lightweight validation for CI/CD
- Quick health checks
- Pre-deployment validation
- Dry-run mode support

## Flow

### Cleanup Workflow
```
Start Cleanup
    ↓
Load Configuration
    ↓
[Optional] Dry Run Mode
    ↓
ComprehensiveDataFix.Execute()
    ├── Phase 1: Orphaned Record Removal
    │   └── Delete records without parent references
    ├── Phase 2: Invalid Data Correction
    │   ├── Fix NaN values → 0 or null
    │   ├── Fix null required fields → defaults
    │   └── Fix out-of-range values → clamped
    ├── Phase 3: Duplicate Detection
    │   ├── Identify duplicates by key
    │   ├── Merge duplicate data
    │   └── Remove duplicates
    ├── Phase 4: Reference Integrity
    │   ├── Validate foreign keys
    │   ├── Fix broken references
    │   └── Remove orphaned records
    └── Phase 5: Timestamp Repair
        ├── Fix missing timestamps → now
        └── Fix invalid dates → null
    ↓
Log All Changes
    ↓
Generate Report
    ↓
[Optional] Rollback on Failure
```

### Corruption Prevention Flow
```
Write Operation Requested
    ↓
MongoCorruptionPreventionService.Validate()
    ├── Schema Validation
    │   └── Check against expected structure
    ├── Business Rule Validation
    │   └── Check custom constraints
    ├── Range Validation
    │   └── Check numeric bounds
    └── Reference Validation
        └── Check foreign key existence
    ↓
If Valid:
    └── Execute Write
If Invalid:
    ├── Log to ERR0R Collection
    ├── Reject Write
    └── [Optional] Attempt Auto-Fix
```

### Validation Flow (QuickValidationRunner)
```
Run Quick Validation
    ↓
Check All Collections
    ├── CRED3N7IAL: Validate credentials
    ├── EV3NT: Validate events
    ├── ERR0R: Check error counts
    └── JACKPOTS: Validate jackpot data
    ↓
Report Results
    ├── Valid Records Count
    ├── Invalid Records Count
    ├── Errors by Type
    └── Recommended Actions
```

## Integration

### Dependencies
- **C0MMON**: Entity definitions and interfaces
- **C0MMON/Infrastructure**: MongoUnitOfWork for transactions
- **MongoDB.Driver**: Direct database access

### Data Access
- Uses IMongoUnitOfWork from C0MMON
- Direct MongoDB operations for bulk fixes
- EV3NT collection for audit logging
- ERR0R collection for error tracking

### Safety Mechanisms
```csharp
// Always use dry-run first
cleanupRunner.Execute(dryRun: true);

// Review proposed changes
// Then execute for real
cleanupRunner.Execute(dryRun: false);
```

## Key Operations

### Cleanup Operations
| Operation | Description | Safety Level |
|-----------|-------------|--------------|
| Orphaned Record Removal | Delete records without parent references | Medium |
| Invalid Data Correction | Fix NaN, null, out-of-range values | Low |
| Duplicate Detection | Identify and merge duplicate entries | Medium |
| Reference Integrity | Ensure foreign key relationships valid | High |
| Timestamp Repair | Fix missing or invalid date fields | Low |

### Validation Checks
- **Schema Validation**: Verify document structure matches entity
- **Business Rules**: Enforce custom constraints
- **Range Checks**: Numeric values within expected bounds
- **Reference Integrity**: Foreign keys point to valid records
- **Type Checking**: Fields have expected types

## Usage

### Run All Cleanup
```bash
# Run complete cleanup
dotnet run --project CLEANUP/CLEANUP.csproj

# Dry run first
dotnet run --project CLEANUP/CLEANUP.csproj -- --dry-run
```

### Run Specific Fix
```bash
# Fix orphaned records only
dotnet run --project CLEANUP/CLEANUP.csproj -- --fix=orphans

# Fix invalid data only
dotnet run --project CLEANUP/CLEANUP.csproj -- --fix=invalid

# Fix duplicates only
dotnet run --project CLEANUP/CLEANUP.csproj -- --fix=duplicates
```

### Quick Validation
```bash
# Run quick validation check
dotnet run --project CLEANUP/CLEANUP.csproj -- --validate

# Validation with verbose output
dotnet run --project CLEANUP/CLEANUP.csproj -- --validate --verbose
```

## Safety Guidelines

1. **Always Dry-Run First**
   ```bash
   dotnet run --project CLEANUP/CLEANUP.csproj -- --dry-run
   ```

2. **Review Proposed Changes**
   - Check dry-run output
   - Verify changes are expected
   - Confirm no critical data affected

3. **Backup Before Major Cleanup**
   ```bash
   # MongoDB backup
   mongodump --db P4NTH30N --out /backup/$(date +%Y%m%d)
   ```

4. **Monitor Logs for Unexpected Behavior**
   - Watch for errors during execution
   - Check ERR0R collection for new errors
   - Verify system still functional

5. **Test on Development Data First**
   - Never run on production without testing
   - Use development/staging database first
   - Validate results on test data

## Critical Notes

### Data Integrity
- Never delete without verification
- Always log before/after state
- Maintain rollback capability
- Batch large operations

### Validation Philosophy
- Validation is NOT auto-repair
- Invalid data logged to ERR0R
- Manual review required for fixes
- No silent mutations

### Performance
- Process large collections in batches
- Use efficient queries with indexes
- Monitor memory usage
- Allow cancellation mid-operation

### Error Handling
- Continue on individual record failure
- Log all errors to ERR0R collection
- Report summary at end
- Provide detailed logs for debugging

### Integration with Monitoring
- CLEANUP operations logged to EV3NT
- MONITOR service detects corruption
- Combined approach: Prevention + Repair

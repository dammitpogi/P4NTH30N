# PROF3T/input/

## Responsibility
Static input data directory for PROF3T. Contains credential files and other configuration data used by the administrative console application.

## Design
- **Content**: JSON files containing account credentials and test data
- **Structure**: Subdirectories for organization (e.g., `credentials/`)
- **Format**: JSON files with platform-specific credential schemas
- **Security**: Contains username/password data - not committed to version control

## Flow
1. **Load**: PROF3T reads credentials from `input/credentials/` at runtime
2. **Process**: Credentials used for balance queries, login tests, and analytics
3. **No Write-back**: Input directory is read-only source of truth

## Integration
- **Consumed by**: PROF3T admin commands (AnalyzeBiggestAccounts, balance tests)
- **Files**:
  - `credentials/PROF3T_001.json` - Sample credential file
- **Related**: Referenced by MongoDB `CR3D3N7IAL` collection for persistent storage

# PROF3T/input/credentials/

## Responsibility
Credential storage directory containing JSON files with user account data for gaming platforms (FireKirin, OrionStars). These files serve as input source data for the PROF3T administrative console.

## Design
- **Content**: JSON files with platform-specific credential schemas
- **Format**: Username/password pairs with optional metadata
- **Example**: `PROF3T_001.json` - Sample credential file
- **Security**: Contains sensitive credentials - should not be committed to version control

## Flow
1. **Load**: PROF3T reads credential files from this directory at runtime
2. **Validation**: Credentials validated against MongoDB `CR3D3N7IAL` collection
3. **Usage**: Used for balance queries, login tests, and account analysis
4. **Sync**: May be synchronized with persistent MongoDB storage

## Integration
- **Consumed by**: PROF3T admin commands (AnalyzeBiggestAccounts, balance tests)
- **Related**: MongoDB `CR3D3N7IAL` collection for persistent storage
- **Parent**: References parent `PROF3T/input/codemap.md`

# Deploy

## Description
Deploy P4NTH30N to the target environment with proper validation and rollback capability.

## Steps

1. **Pre-Deployment Checks**
   - Verify all tests pass: `dotnet test UNI7T35T/UNI7T35T.csproj`
   - Check for uncommitted changes
   - Validate configuration files
   - Review deployment notes

2. **Build Release**
   - Clean previous builds: `dotnet clean P4NTH30N.slnx`
   - Build Release configuration: `dotnet build P4NTH30N.slnx -c Release`
   - Run publish: `dotnet publish -c Release -o ./publish`

3. **Database Migration**
   - Backup current database
   - Apply pending migrations
   - Verify schema integrity
   - Test connection strings

4. **Deployment Execution**
   - Stop running services
   - Deploy new binaries
   - Update configuration files
   - Start services

5. **Post-Deployment Verification**
   - Health check endpoints
   - Verify service startup
   - Check logs for errors
   - Monitor for 5 minutes

6. **Rollback (if needed)**
   - Stop services
   - Restore previous version
   - Restore database backup
   - Restart services

## Example Invocation
```
/deploy --environment staging
/deploy --environment production
```

## Safety Checks
- Never deploy without passing tests
- Always backup database before migration
- Verify rollback procedure before deployment
- Require human approval for production
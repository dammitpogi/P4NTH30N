# Deployment

## Description
Deploy P4NTH30N to target environments with validation, monitoring, and rollback capability.

## When to Use
- Deploying to staging/production
- Hotfix deployment
- Environment updates
- Release management

## Usage

```markdown
@deployment
Environment: staging
Version: 1.2.3
```

Or ask Cascade:
"Deploy the current build to staging"

## Pre-Deployment Checklist

- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Database migrations prepared
- [ ] Configuration validated
- [ ] Rollback plan ready

## Deployment Steps

1. **Backup**
   - Database backup
   - Current version backup
   - Configuration backup

2. **Build**
   ```bash
   dotnet clean P4NTH30N.slnx
   dotnet build P4NTH30N.slnx -c Release
   dotnet publish -c Release -o ./publish
   ```

3. **Deploy**
   - Stop services
   - Deploy binaries
   - Apply migrations
   - Start services

4. **Verify**
   - Health checks
   - Smoke tests
   - Log monitoring
   - Performance baseline

## Resources

- pre-deploy-checks.sh - Validation script
- environment-template.env - Environment config
- rollback-steps.md - Rollback procedures

## Environments

- **Development**: Local development
- **Staging**: Pre-production testing
- **Production**: Live system

## Safety

- Never deploy without tests passing
- Always backup before deployment
- Require approval for production
- Monitor for 30 minutes post-deploy
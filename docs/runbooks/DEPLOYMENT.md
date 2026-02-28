# Deployment Runbook (INFRA-008)

## Pre-Deployment Checklist

- [ ] All tests passing: `dotnet run --project UNI7T35T\UNI7T35T.csproj`
- [ ] Build succeeds: `dotnet build P4NTHE0N.slnx`
- [ ] Formatting check: `dotnet csharpier check`
- [ ] MongoDB backup taken: `.\scripts\backup\mongodb-backup.ps1`
- [ ] Environment validation: `.\scripts\setup\validate-environment.ps1`

## Post-Deployment: Enable Autostart (Optional)

### Register H0UND Background Service

**Run in Administrator PowerShell**:
```powershell
.\scripts\Register-AutoStart.ps1
```

**Verify**:
```powershell
Get-ScheduledTask -TaskName "P4NTHE0N-AutoStart"
```

**Note**: Do not use `sudo` on Windows. Use "Run as Administrator" instead.

### Register ToolHive Autostart

**Run in Administrator PowerShell**:
```powershell
.\scripts\Register-ToolHive-AutoStart.ps1
```

See [H0UND Autostart Guide](../components/H0UND/AUTOSTART.md) for full details.

## Troubleshooting Autostart

### "%1 is not a valid Win32 application"
**Cause**: Using `sudo` on Windows  
**Fix**: Run PowerShell as Administrator instead

### "Execution of scripts is disabled"
**Fix**: `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`

## Standard Deployment

### 1. Stop Running Agents
```powershell
# Gracefully stop agents (Ctrl+C in their terminals)
# Agents handle CancellationToken for clean shutdown
```

### 2. Pull Latest Code
```powershell
git pull origin main
dotnet restore P4NTHE0N.slnx
```

### 3. Build
```powershell
dotnet build P4NTHE0N.slnx -c Debug
```

### 4. Run Tests
```powershell
dotnet run --project UNI7T35T\UNI7T35T.csproj
# Must see: "All tests passed!"
```

### 5. Start Agents
```powershell
# Terminal 1: H0UND
dotnet run --project H0UND\H0UND.csproj

# Terminal 2: H4ND (if needed)
dotnet run --project H4ND\H4ND.csproj
```

### 6. Post-Deployment Verification
- Verify H0UND polling cycles in console
- Verify MongoDB connectivity
- Check health status if monitoring enabled

## Rollback Procedure

### Quick Rollback (< 2 minutes)
```powershell
# Stop agents
# Revert to previous commit
git revert HEAD
dotnet build P4NTHE0N.slnx
dotnet run --project H0UND\H0UND.csproj
```

### Full Rollback with Data Restore (< 30 minutes)
```powershell
# Stop all agents
# Restore database from backup
.\scripts\restore\mongodb-restore.ps1 -BackupArchive "path\to\backup.zip" -Drop
# Revert code
git checkout <previous-tag>
dotnet build P4NTHE0N.slnx
# Restart agents
```

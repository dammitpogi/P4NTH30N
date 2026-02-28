# Disaster Recovery (INFRA-005)

## RTO/RPO Targets

| Metric | Target | Notes |
|--------|--------|-------|
| **RPO** (Recovery Point Objective) | 24 hours | Daily automated backups |
| **RTO** (Recovery Time Objective) | 30 minutes | Restore from latest backup |

## Backup Schedule

| Type | Frequency | Retention | Storage |
|------|-----------|-----------|---------|
| **Daily** | Every 24h (midnight) | 7 days | Local + offsite |
| **Weekly** | Sunday midnight | 4 weeks | Local + offsite |
| **Monthly** | 1st of month | 12 months | Offsite only |

## Backup Commands

```powershell
# Manual backup
.\scripts\backup\mongodb-backup.ps1

# Custom retention
.\scripts\backup\mongodb-backup.ps1 -RetainDays 14

# Scheduled task (run as admin)
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-File C:\P4NTHE0N\scripts\backup\mongodb-backup.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "00:00"
Register-ScheduledTask -TaskName "P4NTHE0N-Backup" -Action $action -Trigger $trigger
```

## Restore Procedures

### Standard Restore
```powershell
# List available backups
Get-ChildItem C:\P4NTHE0N\backups -Filter "*.zip" | Sort-Object CreationTime -Descending

# Restore latest
.\scripts\restore\mongodb-restore.ps1 -BackupArchive "C:\P4NTHE0N\backups\P4NTHE0N_LATEST.zip"

# Restore with collection replacement
.\scripts\restore\mongodb-restore.ps1 -BackupArchive "path\to\backup.zip" -Drop
```

### Full Disaster Recovery

1. **Assess damage** — determine what was lost (data, config, or both)
2. **Install MongoDB** — `.\scripts\setup\setup-mongodb.ps1` if needed
3. **Restore database** — `.\scripts\restore\mongodb-restore.ps1`
4. **Verify restore** — check collection counts and sample documents
5. **Restart agents** — H0UND, H4ND, FourEyes
6. **Validate operations** — run health checks

### What's Backed Up

| Data | Included | Location |
|------|----------|----------|
| CRED3N7IAL collection | Yes | MongoDB dump |
| G4ME collection | Yes | MongoDB dump |
| SIGN4L collection | Yes | MongoDB dump |
| J4CKP0T collection | Yes | MongoDB dump |
| ERR0R collection | Yes | MongoDB dump |
| EV3NT collection | Yes | MongoDB dump |
| Configuration files | Manual | appsettings.json, HunterConfig.json |
| Master encryption key | Manual | Separate secure backup required |

### What's NOT Backed Up (Manual)

- **Master encryption key** — back up separately with restricted access
- **Environment variables** — document and store securely
- **VM snapshots** — managed via Hyper-V checkpoint system
- **OBS configuration** — re-create from docs/vm/EXECUTOR_VM.md

## Quarterly DR Testing

1. Create a test MongoDB instance
2. Restore latest backup to test instance
3. Verify all collections restored correctly
4. Verify data integrity (count, sample queries)
5. Document results and any issues
6. Update procedures if needed

# Disaster Recovery Runbook

## Targets
- **RTO** (Recovery Time Objective): < 1 hour
- **RPO** (Recovery Point Objective): < 15 minutes data loss

---

## 1. MongoDB Failure

### 1.1 MongoDB Service Down

**Detection**: H4ND/H0UND log connection errors, health check fails on port 27017.

**Recovery**:
```powershell
# Check service status
Get-Service MongoDB

# Restart service
Restart-Service MongoDB

# Verify
Test-NetConnection localhost -Port 27017
```

**RTO**: 2 minutes | **RPO**: 0 (data on disk)

### 1.2 MongoDB Data Corruption

**Detection**: Query errors, unexpected empty results, BSON parse failures.

**Recovery**:
```powershell
# Stop all agents
Stop-Process -Name H4ND, H0UND -Force -ErrorAction SilentlyContinue

# Run repair
& "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe" --repair --dbpath "C:\data\db"

# If repair fails, restore from backup
.\scripts\restore\mongodb-restore.ps1 -BackupPath "C:\backups\mongodb\latest"

# Restart MongoDB
Start-Service MongoDB

# Verify collections
mongosh --eval "db.getCollectionNames()" P4NTHE0N
```

**RTO**: 15-30 minutes | **RPO**: Time since last backup

### 1.3 MongoDB Backup Schedule

```powershell
# Manual backup (run daily or before deployments)
.\scripts\backup\mongodb-backup.ps1

# Backup location
# C:\backups\mongodb\P4NTHE0N_YYYYMMDD_HHmmss\
```

**Recommendation**: Schedule via Windows Task Scheduler every 15 minutes for RPO target.

---

## 2. Chrome CDP Failure

### 2.1 Chrome Crashed / Not Responding

**Detection**: CDP HTTP endpoint unreachable, H4ND logs timeout errors.

**Recovery**:
```powershell
# Kill all Chrome instances
Stop-Process -Name chrome -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Restart with debugging flags
& "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    --remote-debugging-port=9222 `
    --remote-debugging-address=0.0.0.0 `
    --incognito `
    --disable-background-timer-throttling `
    --disable-backgrounding-occluded-windows `
    --disable-renderer-backgrounding

# Verify CDP
Start-Sleep -Seconds 3
Invoke-RestMethod http://localhost:9222/json/version
```

**RTO**: 1 minute | **RPO**: N/A (stateless)

### 2.2 CDP Port Proxy Lost

**Detection**: VM can reach host ping but CDP fails.

**Recovery**:
```powershell
# Re-create port proxy
netsh interface portproxy add v4tov4 listenaddress=192.168.56.1 listenport=9222 connectaddress=127.0.0.1 connectport=9222

# Verify
netsh interface portproxy show v4tov4
```

**RTO**: 1 minute | **RPO**: N/A

---

## 3. VM Failure

### 3.1 VM Not Starting

**Detection**: Hyper-V shows VM in Off/Saved state.

**Recovery**:
```powershell
# Check VM status
Get-VM H4NDv2-Production

# Start VM
Start-VM H4NDv2-Production

# Wait for boot and verify
Start-Sleep -Seconds 60
Test-NetConnection 192.168.56.10 -Port 5985
```

**RTO**: 2-5 minutes | **RPO**: 0

### 3.2 VM Corrupted / Unrecoverable

**Detection**: VM fails to boot, BSOD loop.

**Recovery**:
```powershell
# Option A: Restore from checkpoint
Restore-VMSnapshot -VMName "H4NDv2-Production" -Name "LastKnownGood"

# Option B: Re-provision from scratch
# 1. Create new VM with Windows 11
# 2. Configure network (see docs/vm-deployment/network-setup.md)
# 3. Install .NET 10 Runtime
# 4. Deploy H4ND:
Copy-Item -ToSession $vmSession -Path C:\P4NTHE0N\publish\h4nd-vm-full\* -Destination C:\H4ND\ -Recurse
# 5. Copy appsettings.json with VM-specific config
```

**RTO**: 15-60 minutes | **RPO**: 0 (state in MongoDB on host)

### 3.3 VM Network Lost

**Detection**: Can't ping 192.168.56.10 from host.

**Recovery**:
```powershell
# Check Hyper-V switch
Get-VMSwitch H4ND-Switch
Get-VMNetworkAdapter -VMName H4NDv2-Production

# Re-attach adapter if needed
Connect-VMNetworkAdapter -VMName "H4NDv2-Production" -SwitchName "H4ND-Switch"

# Inside VM — reset IP
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.56.10 -PrefixLength 24 -DefaultGateway 192.168.56.1
```

**RTO**: 5 minutes | **RPO**: 0

---

## 4. H4ND Agent Failure

### 4.1 H4ND Process Crash

**Detection**: Process not running, no console output.

**Recovery**:
```powershell
# On VM
cd C:\H4ND
.\H4ND.exe H4ND

# Or via PowerShell Direct from host
Invoke-Command -VMName "H4NDv2-Production" -ScriptBlock {
    Set-Location C:\H4ND
    Start-Process .\H4ND.exe -ArgumentList "H4ND" -NoNewWindow
}
```

**RTO**: 1 minute | **RPO**: 0

### 4.2 H4ND Stuck in Loop

**Detection**: Console shows repeated errors, no progress.

**Recovery**:
```powershell
# Kill and restart
Stop-Process -Name H4ND -Force
Start-Sleep -Seconds 5
cd C:\H4ND
.\H4ND.exe H4ND
```

**RTO**: 1 minute | **RPO**: 0

---

## 5. Host System Failure

### 5.1 Host Reboot / Power Loss

**Detection**: All services unavailable.

**Recovery** (automatic on boot):
1. MongoDB starts automatically (Windows Service)
2. VM starts if configured: `Set-VM -Name "H4NDv2-Production" -AutomaticStartAction Start`
3. Chrome must be started manually (or add to startup)
4. H4ND must be started manually on VM (or add to Task Scheduler)

**Recommended**: Create startup script:
```powershell
# C:\P4NTHE0N\scripts\startup.ps1
Start-Service MongoDB
Start-Sleep 5
Start-VM H4NDv2-Production
Start-Sleep 30
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0 --incognito
```

**RTO**: 5-10 minutes | **RPO**: 0

---

## 6. Game Server Issues

### 6.1 FireKirin/OrionStars API Down

**Detection**: `QueryBalances` throws WebSocket connection errors.

**Recovery**: Wait and retry. Game servers are external — no local fix possible.

**Mitigation**: H4ND has built-in retry with exponential backoff (3 attempts, 2s base delay).

### 6.2 Account Suspended

**Detection**: `QueryBalances` throws "Your account has been suspended".

**Recovery**: Manual — contact game platform support. H4ND correctly propagates this error without retry.

---

## 7. Deployment Rollback

### Rolling Back H4ND

```powershell
# Releases are versioned in C:\P4NTHE0N\Releases\
# Find the last known good release
Get-ChildItem C:\P4NTHE0N\Releases\ -Directory | Sort-Object Name -Descending | Select-Object -First 5

# Stop H4ND on VM
Invoke-Command -VMName "H4NDv2-Production" -ScriptBlock { Stop-Process -Name H4ND -Force -ErrorAction SilentlyContinue }

# Copy rollback version
$release = "CANON_P4NTHE0N_Rollout_v0004"
Copy-Item -ToSession $vmSession -Path "C:\P4NTHE0N\Releases\$release\*" -Destination "C:\H4ND\" -Recurse -Force

# Restart
Invoke-Command -VMName "H4NDv2-Production" -ScriptBlock { cd C:\H4ND; .\H4ND.exe H4ND }
```

---

## Quick Reference Card

| Scenario | RTO | RPO | Auto-Recovery? |
|----------|-----|-----|----------------|
| MongoDB down | 2 min | 0 | Yes (service restart) |
| MongoDB corrupt | 30 min | Last backup | No |
| Chrome crash | 1 min | N/A | No (OPS_015 planned) |
| VM not starting | 5 min | 0 | Optional |
| VM corrupted | 60 min | 0 | No |
| H4ND crash | 1 min | 0 | No (watchdog planned) |
| Host reboot | 10 min | 0 | Partial |
| Game server down | N/A | N/A | Built-in retry |

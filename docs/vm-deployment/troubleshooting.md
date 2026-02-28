# VM Deployment Troubleshooting

## Common Issues and Fixes

### 1. MongoDB "Replica Set" Redirect

**Symptom**: H4ND connects to MongoDB but operations fail with topology errors or redirect to `localhost`.

**Cause**: MongoDB driver discovers replica set members and tries to connect to their advertised addresses (typically `localhost`), which is unreachable from the VM.

**Fix**: Add `?directConnection=true` to the connection string:
```
mongodb://192.168.56.1:27017/P4NTHE0N?directConnection=true
```

---

### 2. CDP WebSocket Connection Fails

**Symptom**: H4ND connects to CDP HTTP endpoint but WebSocket connection times out.

**Cause**: Chrome returns `ws://localhost:9222/...` in the debugger URL, and the VM can't reach `localhost`.

**Fix**: The `CdpClient` automatically rewrites localhost → HostIp. Verify:
1. `CdpConfig.HostIp` is set to `192.168.56.1`
2. Port proxy is active: `netsh interface portproxy show v4tov4`
3. Chrome is running with `--remote-debugging-port=9222`

---

### 3. CDP Command Response Interleaving

**Symptom**: CDP evaluate calls return wrong data or time out intermittently.

**Cause**: Chrome sends event notifications (no `id`) mixed with command responses. If the client reads an event and treats it as the response, data is corrupt.

**Fix**: Already handled in `CdpClient` — it matches by command `id` and skips events. If you see this issue, check that `SendCommandAsync` is using unique command IDs.

---

### 4. H4ND Can't Find Config Files

**Symptom**: H4ND starts but uses default config values (wrong host IP, wrong MongoDB).

**Cause**: Single-file publish changes `AppContext.BaseDirectory` to a temp extraction folder.

**Fix**: Always publish as non-single-file:
```powershell
dotnet publish H4ND/H4ND.csproj -c Release -r win-x64 -o publish/h4nd-vm-full
# Do NOT add -p:PublishSingleFile=true
```

---

### 5. "Extension Failure" (RESOLVED — OPS_009)

**Symptom**: H4ND loops 40 times then throws "Extension failure."

**Cause**: Legacy code tried to read `window.parent.Grand` which was injected by the RUL3S Chrome extension. Without the extension, this always returns 0.

**Fix**: OPS_009 replaced this with `VerifyGamePageLoadedAsync` (page readiness check) + `GetBalancesWithRetry` (WebSocket API for jackpots). No extension needed.

---

### 6. VM Has No Internet

**Symptom**: Game WebSocket API calls fail, DNS resolution fails.

**Cause**: NAT not configured on the Hyper-V switch.

**Fix**:
```powershell
# On host
New-NetNat -Name "H4ND-NAT" -InternalIPInterfaceAddressPrefix "192.168.56.0/24"

# On VM — set DNS
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 8.8.8.8,8.8.4.4
```

---

### 7. Chrome Crashes / Not Responding

**Symptom**: CDP calls time out, Chrome window frozen.

**Cause**: Memory pressure, GPU issues, or Chrome update.

**Fix**:
1. Kill Chrome: `Stop-Process -Name chrome -Force`
2. Restart with debugging flags (see chrome-cdp-config.md)
3. OPS_015 adds automatic session recovery for this scenario

---

### 8. H4ND Process Exits Unexpectedly

**Symptom**: H4ND stops running, no output.

**Check**:
```powershell
# On VM — check if H4ND is running
Get-Process H4ND -ErrorAction SilentlyContinue

# Check event log
Get-WinEvent -LogName Application -MaxEvents 10 | Where-Object { $_.Message -like "*H4ND*" }

# Check for crash dump
Get-ChildItem C:\H4ND\*.dmp
```

---

## Diagnostic Commands

```powershell
# Full connectivity check
$checks = @{
    "CDP HTTP"  = { Invoke-RestMethod http://192.168.56.1:9222/json/version -TimeoutSec 3 }
    "MongoDB"   = { (New-Object Net.Sockets.TcpClient("192.168.56.1", 27017)).Close() }
    "DNS"       = { [System.Net.Dns]::GetHostEntry("play.firekirin.in") }
    "FireKirin" = { Invoke-WebRequest "http://play.firekirin.in" -TimeoutSec 5 -UseBasicParsing }
}

foreach ($name in $checks.Keys) {
    try { $null = & $checks[$name]; Write-Host "OK: $name" -ForegroundColor Green }
    catch { Write-Host "FAIL: $name - $_" -ForegroundColor Red }
}
```

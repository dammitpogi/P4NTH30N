# Network Setup Guide

## Hyper-V Virtual Switch

### Create H4ND-Switch
```powershell
# Run as Administrator on host
New-VMSwitch -Name "H4ND-Switch" -SwitchType Internal
```

### Assign Host IP
```powershell
# Get the adapter index
Get-NetAdapter | Where-Object { $_.Name -like "*H4ND*" }

# Assign static IP to host side
New-NetIPAddress -InterfaceAlias "vEthernet (H4ND-Switch)" -IPAddress 192.168.56.1 -PrefixLength 24
```

### VM Network Configuration
```powershell
# Inside VM - set static IP
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.56.10 -PrefixLength 24 -DefaultGateway 192.168.56.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 8.8.8.8,8.8.4.4
```

### NAT for Internet Access
```powershell
# On host - enable NAT for VM internet access
New-NetNat -Name "H4ND-NAT" -InternalIPInterfaceAddressPrefix "192.168.56.0/24"
```

## Port Proxy (CDP Access)

Chrome binds to `127.0.0.1:9222` by default. To make it accessible from the VM:

```powershell
# On host - forward 192.168.56.1:9222 → 127.0.0.1:9222
netsh interface portproxy add v4tov4 listenaddress=192.168.56.1 listenport=9222 connectaddress=127.0.0.1 connectport=9222

# Verify
netsh interface portproxy show v4tov4

# Remove if needed
netsh interface portproxy delete v4tov4 listenaddress=192.168.56.1 listenport=9222
```

**Note**: Even with `--remote-debugging-address=0.0.0.0`, the port proxy ensures consistent connectivity.

## Firewall Rules

```powershell
# Allow CDP from VM
New-NetFirewallRule -DisplayName "Allow CDP from H4ND VM" -Direction Inbound -Protocol TCP -LocalPort 9222 -RemoteAddress 192.168.56.0/24 -Action Allow

# Allow MongoDB from VM
New-NetFirewallRule -DisplayName "Allow MongoDB from H4ND VM" -Direction Inbound -Protocol TCP -LocalPort 27017 -RemoteAddress 192.168.56.0/24 -Action Allow
```

## Connectivity Verification

```powershell
# From VM — test CDP
Invoke-RestMethod -Uri "http://192.168.56.1:9222/json/version" -TimeoutSec 5

# From VM — test MongoDB
Test-NetConnection -ComputerName 192.168.56.1 -Port 27017

# From host — test VM
Test-NetConnection -ComputerName 192.168.56.10 -Port 5985  # WinRM
```

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| VM can't reach host:9222 | Port proxy not set | Run `netsh interface portproxy add` |
| MongoDB "replica set" error | Missing `?directConnection=true` | Add to connection string |
| CDP WebSocket connects then fails | ws://localhost in CDP response | CdpClient rewrites localhost → HostIp |
| VM has no internet | NAT not configured | Create NetNat rule |
| VM can't resolve DNS | DNS not set | Set DNS servers on VM adapter |

# P4NTH30N Executor VM Configuration (VM-002)

## Overview

The Executor VM is a lightweight Windows virtual machine that runs casino games in Chrome. All analysis and decision-making happens on the **host** via FourEyes — the VM only renders and receives input.

## Architecture

```
HOST (FourEyes)                          VM (Executor)
┌─────────────────────┐                  ┌─────────────────────┐
│ FourEyes Agent       │◄── RTMP ───────│ OBS (streaming)      │
│ W4TCHD0G (vision)    │                 │ Chrome (casino)      │
│ DecisionEngine       │── Synergy ────►│ Synergy Client       │
│ MongoDB (signals)    │                 │ (no DB, no logic)    │
└─────────────────────┘                  └─────────────────────┘
```

## VM Specifications

| Resource | Value | Notes |
|----------|-------|-------|
| **CPU** | 4 vCPU | Required for OBS x264 encoding |
| **RAM** | 8GB (dynamic 2-8GB) | Chrome + OBS + game rendering |
| **Disk** | 60GB dynamic VHDX | Minimal Windows + software |
| **OS** | Windows 10 Pro | Stripped, no bloat |
| **Network** | Bridged adapter | Host communication |

## Software Stack

| Software | Purpose | Config |
|----------|---------|--------|
| **Windows 10 Pro** | OS (minimal install) | Disable Cortana, telemetry, updates |
| **Google Chrome** | Casino browser | Single profile, hardware accel on |
| **OBS Studio** | Screen capture + RTMP streaming | Capture Chrome window → RTMP to host |
| **Synergy Client** | Receive input from host | Connect to host Synergy server |

## Setup

### Automated VM Creation

```powershell
# On HOST (requires Administrator + Hyper-V)
.\scripts\vm\setup-executor-vm.ps1 -ISOPath "C:\ISOs\Win10Pro.iso"
```

### Manual Steps (inside VM)

1. **Install Windows 10 Pro** (minimal, skip Microsoft account)
2. **Install Chrome**: `winget install Google.Chrome`
3. **Install OBS Studio**: `winget install OBSProject.OBSStudio`
4. **Install Synergy/Barrier**: Download from [symless.com](https://symless.com) or use Barrier (free fork)
5. **Configure OBS streaming** (see below)
6. **Configure Synergy client** (see below)

### OBS Configuration

1. Add **Window Capture** source targeting Chrome
2. Set output resolution: **1280x720**
3. Configure **Settings → Stream**:
   - Service: Custom
   - Server: `rtmp://<HOST_IP>:1935/live`
   - Stream Key: `p4nth30n`
4. Configure **Settings → Output**:
   - Encoder: x264
   - Rate Control: CBR
   - Bitrate: 2500 Kbps
   - Keyframe Interval: 2
   - CPU Preset: veryfast
5. Start Streaming

### Synergy Configuration

1. Set as **Client**
2. Server IP: `<HOST_IP>`
3. Screen name: `P4NTH30N-Executor`
4. Port: 24800
5. Auto-start on boot

## Network Setup

### Host Firewall Rules

```powershell
# Allow RTMP from VM
netsh advfirewall firewall add rule name="P4NTH30N RTMP" dir=in action=allow protocol=tcp localport=1935

# Allow Synergy to VM
netsh advfirewall firewall add rule name="P4NTH30N Synergy" dir=in action=allow protocol=tcp localport=24800
```

### Port Summary

| Port | Direction | Protocol | Purpose |
|------|-----------|----------|---------|
| 1935 | VM → Host | TCP | RTMP video stream |
| 24800 | Host → VM | TCP | Synergy input control |

## Multi-VM Support

Multiple VMs can run in parallel for different casinos:

```powershell
.\scripts\vm\setup-executor-vm.ps1 -VMName "Casino-VM-01" -CPUCount 4 -MemoryGB 8
.\scripts\vm\setup-executor-vm.ps1 -VMName "Casino-VM-02" -CPUCount 4 -MemoryGB 8
```

Each VM needs:
- Separate Chrome profile
- Unique Synergy screen name
- Unique RTMP stream key
- Dedicated FourEyes agent instance on host

## Resource Monitoring

Monitor VM resource usage during operation:

```powershell
# Check VM resource usage
Get-VM -Name "P4NTH30N-Executor" | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime
```

**Expected usage under load:**
- CPU: 30-50% (OBS encoding + Chrome rendering)
- RAM: 4-6GB (Chrome + OBS + OS)
- Network: ~3 Mbps outbound (RTMP stream)

## Troubleshooting

### OBS stream not connecting
- Verify host firewall allows port 1935
- Check RTMP URL in OBS settings
- Ensure FFmpeg is running on host to receive

### Synergy input not working
- Verify host Synergy server is running
- Check VM screen name matches host config
- Test with manual mouse move first

### VM performance issues
- Disable Windows animations and visual effects
- Set Chrome to use hardware acceleration
- Reduce OBS output resolution to 720p
- Check CPU preset is set to "veryfast"

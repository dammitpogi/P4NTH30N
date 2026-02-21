# VM Deployment Architecture

## Overview

P4NTH30N uses a Hyper-V virtual machine to isolate the H4ND browser automation agent from the host system. The VM connects back to the host for Chrome CDP (browser control) and MongoDB (data persistence).

```
┌──────────────────────────────────────────────────────────────────┐
│ HOST (CATH3DR4L-01)                                              │
│ Windows 11 Pro                                                   │
│                                                                  │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────────┐ │
│  │ Chrome       │   │ MongoDB      │   │ P4NTH30N Source      │ │
│  │ :9222 (CDP)  │   │ :27017       │   │ C:\P4NTH30N\         │ │
│  └──────┬───────┘   └──────┬───────┘   └──────────────────────┘ │
│         │                  │                                     │
│  ┌──────┴──────────────────┴─────────────────────────────┐      │
│  │ Hyper-V H4ND-Switch  (192.168.56.0/24)                │      │
│  │ Host IP: 192.168.56.1                                  │      │
│  └──────────────────────────┬────────────────────────────┘      │
└─────────────────────────────┼────────────────────────────────────┘
                              │
┌─────────────────────────────┼────────────────────────────────────┐
│ VM (H4NDv2-Production)      │                                    │
│ Windows 11, 192.168.56.10   │                                    │
│                              │                                    │
│  ┌──────────────────────────┴──────────────────────────────────┐ │
│  │ H4ND Agent (C:\H4ND\)                                       │ │
│  │  ├─ CDP → ws://192.168.56.1:9222  (Chrome on host)          │ │
│  │  ├─ MongoDB → 192.168.56.1:27017?directConnection=true      │ │
│  │  └─ WebSocket API → game servers (internet via NAT)          │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

## Components

### Host Services

| Service | Bind Address | Port | Purpose |
|---------|-------------|------|---------|
| Chrome | 0.0.0.0 | 9222 | Remote debugging (CDP) |
| MongoDB | 0.0.0.0 | 27017 | Data persistence |
| H0UND | localhost | - | Polling + analytics agent |

### VM Services

| Service | Location | Purpose |
|---------|----------|---------|
| H4ND | C:\H4ND\ | Browser automation agent |
| .NET 10 Runtime | System | Required for H4ND execution |

### Network

| Network | Type | Subnet | Purpose |
|---------|------|--------|---------|
| H4ND-Switch | Hyper-V Internal | 192.168.56.0/24 | Host ↔ VM communication |
| NAT | Hyper-V NAT | - | VM → Internet (game servers) |

## Data Flow

```
1. H0UND (host) polls credentials → writes SIGN4L to MongoDB
2. H4ND (VM) reads SIGN4L from MongoDB via 192.168.56.1:27017
3. H4ND connects to Chrome CDP via 192.168.56.1:9222
4. H4ND logs into game via CDP browser automation
5. H4ND queries jackpots via WebSocket API (direct to game servers)
6. H4ND executes spin via CDP
7. H4ND updates CRED3N7IAL/G4ME in MongoDB
```

## Key Configuration

### appsettings.json (VM copy)
```json
{
  "P4NTH30N": {
    "Database": {
      "ConnectionString": "mongodb://192.168.56.1:27017/P4NTH30N?directConnection=true",
      "DatabaseName": "P4NTH30N"
    },
    "H4ND": {
      "Cdp": {
        "HostIp": "192.168.56.1",
        "Port": 9222
      }
    }
  }
}
```

### Critical: `?directConnection=true`
MongoDB must use `?directConnection=true` to prevent the driver from resolving replica set members, which would redirect to `localhost` (unreachable from VM).

## Deployment Artifacts

H4ND is published as a non-single-file deployment to `C:\H4ND\` on the VM:

```powershell
# Build on host
dotnet publish H4ND/H4ND.csproj -c Release -r win-x64 -o publish/h4nd-vm-full

# Copy to VM (PowerShell Direct)
Copy-Item -ToSession $s -Path publish/h4nd-vm-full/* -Destination C:\H4ND\ -Recurse

# Or manual copy via shared folder / RDP
```

**Important**: Do NOT use `-p:PublishSingleFile=true` — this breaks `AppContext.BaseDirectory` resolution for config files.

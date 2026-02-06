# P4NTH30N VPN Automation System - Setup Plan

## Overview
This plan creates an automated VPN system that combines multiple free VPN services to provide 8+ different US IP addresses, all managed within P4NTH30N.

## Services Integration Plan

### 1. VPNBook Free VPN
- **Servers**: 4 North American locations (2 US, 2 Canada)
- **Protocols**: OpenVPN, WireGuard
- **Credentials**: Username: `vpnbook`, Password: `kyvn8g3` (updated Jan 11, 2026)
- **Automation**: Auto-download and configure .ovpn files

### 2. VPN Gate (University of Tsukuba)
- **Servers**: 2-5 active US servers daily (volunteer network)
- **API**: `https://www.vpngate.net/api/iphone/`
- **Automation**: Parse API, extract US servers, decode base64 configs

### 3. Cloudflare WARP
- **CLI**: `warp-cli` command line interface
- **Installation**: Via winget or direct download
- **Automation**: Register and connect via CLI commands

### 4. ProtonVPN Free (Backup)
- **Servers**: 1 US location in free tier
- **CLI**: `protonvpn-cli` 
- **Automation**: CLI-based connection management

## File Structure Plan

```
C:\P4NTH30N\
├── vpn_manager.py              # Main automation script
├── install_vpn_tools.bat       # Installs required VPN software
├── setup_vpn_system.py         # Initial setup and registration
├── configs\
│   ├── vpnbook\                # VPNBook OpenVPN configs
│   ├── vpngate\                # VPN Gate downloaded configs
│   └── warp\                   # Cloudflare WARP settings
├── logs\
│   ├── vpn_manager.log         # Main application logs
│   └── connections.log         # IP change tracking
└── docs\
    └── VPN_SETUP_GUIDE.md      # User setup documentation
```

## Components to Build

### 1. Core VPN Manager (`vpn_manager.py`)
- **VPNManager Class**: Main orchestration
- **VPNBookManager**: Handle VPNBook service
- **VPNGateManager**: VPN Gate API integration 
- **CloudflareWARPManager**: WARP CLI wrapper
- **OpenVPNManager**: OpenVPN connection handling
- **IP Rotation Logic**: Cycle through all services
- **Connection Verification**: Test each IP change

### 2. Installation Script (`install_vpn_tools.bat`)
```batch
# Install via package managers
winget install OpenVPN.OpenVPN
winget install Cloudflare.WARP
winget install ProtonVPN.ProtonVPN
```

### 3. Setup Script (`setup_vpn_system.py`)
- Download initial VPN configs
- Register with Cloudflare WARP
- Verify all components work
- Create baseline IP tracking

### 4. CLI Interface Commands
- `python vpn_manager.py --rotate` - Cycle through all VPNs
- `python vpn_manager.py --update` - Refresh server configs
- `python vpn_manager.py --status` - Show current IP/location
- `python vpn_manager.py --disconnect` - Disconnect all VPNs
- `python vpn_manager.py --test` - Test all available servers

## Automation Features

### 1. VPNBook Integration
- Auto-download current OpenVPN configs (.zip files)
- Extract and update with current credentials
- Support TCP and UDP protocols
- Handle credential rotation (password changes)

### 2. VPN Gate Integration
- Parse CSV API for active US servers
- Filter by uptime, speed, and user count
- Decode base64 OpenVPN configurations
- Auto-refresh server list daily

### 3. Cloudflare WARP Integration
- CLI registration and connection
- Automatic reconnection on failure
- Status monitoring
- Disconnect handling

### 4. IP Rotation System
- Sequential connection testing
- IP verification after each connection
- Geographic location detection
- Connection quality assessment
- Automatic failover to next server

### 5. Monitoring & Logging
- Connection success/failure tracking
- IP address change history
- Performance metrics (speed, latency)
- Error handling and recovery

## Expected Results

### Available IP Addresses
1. **VPNBook**: 4 servers (2 US, 2 Canada) = ~4 different IPs
2. **VPN Gate**: 2-5 US servers daily = ~3-5 different US IPs  
3. **Cloudflare WARP**: 1-2 exit points = ~1-2 US IPs
4. **ProtonVPN Free**: 1 US server = ~1 US IP

**Total Expected: 8-12 different US/North American IP addresses**

### Geographic Distribution
- US East Coast (estimated 2-3 IPs)
- US West Coast (estimated 2-3 IPs)  
- US Central/Midwest (estimated 1-2 IPs)
- Canada (2 IPs as backup)

## User Requirements (For Documentation)

### Prerequisites
- Windows 10/11 with Administrator access
- Internet connection 
- Python 3.8+ installed

### Required Registrations
1. **Cloudflare WARP**: Free account (optional but recommended)
2. **ProtonVPN**: Free account for backup service
3. **VPN Gate**: No registration needed
4. **VPNBook**: No registration needed

### Required Software Installations
1. OpenVPN Community Edition
2. Cloudflare WARP Client
3. Python packages: requests, psutil

## Implementation Process

### Phase 1: Setup and Installation
1. Run installation script for VPN software
2. Create directory structure
3. Install Python dependencies
4. Initial configuration download

### Phase 2: Service Integration
1. VPNBook config automation
2. VPN Gate API integration
3. Cloudflare WARP setup
4. OpenVPN wrapper implementation

### Phase 3: Rotation System
1. IP detection and verification
2. Connection cycling logic
3. Error handling and recovery
4. Performance monitoring

### Phase 4: CLI Interface
1. Command-line argument parsing
2. User-friendly status reporting
3. Automated scheduling options
4. Configuration management

## Success Metrics
- ✅ 8+ distinct IP addresses available
- ✅ All connections automated via CLI
- ✅ Robust error handling and recovery
- ✅ Comprehensive logging and monitoring
- ✅ Easy setup process with clear documentation

## Next Steps
1. Create detailed setup documentation
2. Implement core VPN manager
3. Build service-specific managers
4. Create installation and setup scripts
5. Test full automation workflow
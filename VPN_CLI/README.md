# VPN CLI Tool

A comprehensive command-line interface for managing CyberGhost VPN connections with automated compliance monitoring and intelligent control features.

## Features

### 🔍 Status Monitoring
- **Current Status**: Check IP address, location, and VPN connection state
- **Compliance Check**: Verify location compliance with configured rules
- **Process Status**: Monitor CyberGhost processes and system health
- **Real-time Monitoring**: Continuous status monitoring with configurable intervals

### 🎛️ VPN Control
- **Connect**: Establish VPN connection with automatic compliance enforcement
- **Disconnect**: Safely disconnect from VPN
- **Reset**: Reset connection to resolve issues
- **Location Change**: Intelligent location switching with multiple retry strategies

### 🤖 Automation
- **Auto Management**: Automated VPN management with compliance monitoring
- **Health Monitoring**: Comprehensive connection health reporting
- **Intelligent Repair**: Multi-strategy connection repair system
- **Watch Mode**: Continuous monitoring with customizable refresh intervals

### 💾 Output Formats
- **Human-readable**: Clean, formatted console output with tables and status indicators
- **JSON Output**: Machine-readable JSON for integration and scripting
- **Verbose Mode**: Detailed logging and diagnostic information

## Installation

1. **Prerequisites**:
   - Windows 10/11
   - .NET 8.0 Runtime
   - CyberGhost VPN (can be auto-installed)

2. **Build from source**:
   ```bash
   # Clone the P4NTH30N repository
   git clone <repository-url>
   cd P4NTH30N/VPN_CLI
   
   # Build the project
   dotnet build -c Release
   
   # Publish as single executable
   dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true
   ```

3. **Add to PATH** (optional):
   ```bash
   # Copy vpn.exe to a directory in your PATH or add build output directory to PATH
   copy bin\Release\net8.0-windows7.0\win-x64\publish\vpn.exe C:\Tools\
   ```

## Quick Start

```bash
# Check current VPN status
vpn

# Show detailed status information
vpn status current --verbose

# Connect to VPN with compliance checking
vpn control connect

# Monitor VPN status continuously
vpn watch --interval 10

# Check installation status
vpn info install-status

# Get help for any command
vpn --help
vpn status --help
vpn control --help
```

## Command Reference

### Global Options
- `--json, -j`: Output in JSON format
- `--verbose, -v`: Enable verbose output
- `--quiet, -q`: Suppress non-essential output

### Status Commands

#### `vpn status current` (alias: `vpn status curr`)
Check current IP address and location information.

```bash
vpn status current
vpn status current --json
vpn status current --verbose
```

#### `vpn status compliance` (alias: `vpn status comp`)
Check location compliance with configured rules.

```bash
vpn status compliance
```

#### `vpn status process` (alias: `vpn status proc`)
Check if CyberGhost processes are running.

```bash
vpn status process --verbose
```

### Control Commands

#### `vpn control connect` (alias: `vpn control start`)
Establish VPN connection and ensure compliance.

```bash
vpn control connect
```

#### `vpn control disconnect` (alias: `vpn control stop`)
Disconnect from VPN.

```bash
vpn control disconnect
```

#### `vpn control reset` (alias: `vpn control restart`)
Reset VPN connection.

```bash
vpn control reset
```

#### `vpn control change-location` (alias: `vpn control chng-loc`)
Change VPN server location.

```bash
vpn control change-location
```

### Information Commands

#### `vpn info install-status` (alias: `vpn info install`)
Check CyberGhost installation status.

```bash
vpn info install-status
vpn info install-status --verbose
```

#### `vpn info version` (alias: `vpn info ver`)
Show version information.

```bash
vpn info version
vpn info version --verbose
```

### Watch Mode

#### `vpn watch`
Continuously monitor VPN status.

Options:
- `--interval, -i <seconds>`: Refresh interval (default: 5)
- `--max-iterations, -n <count>`: Maximum iterations (0 = infinite, default: 0)

```bash
# Watch with default 5-second interval
vpn watch

# Watch with custom interval
vpn watch --interval 15

# Watch for specific number of iterations
vpn watch --interval 10 --max-iterations 20

# Watch with JSON output (for log processing)
vpn watch --json --interval 30
```

### Auto Management

#### `vpn auto`
Automated VPN management with compliance monitoring.

Options:
- `--check-interval <seconds>`: Compliance check interval (default: 30)
- `--retry-limit <count>`: Maximum retry attempts (default: 3)

```bash
# Start auto-management with default settings
vpn auto

# Custom check interval and retry limit
vpn auto --check-interval 60 --retry-limit 5

# Auto-management with JSON logging
vpn auto --json --check-interval 45
```

## Configuration

### Forbidden Regions
By default, the tool considers Nevada and California as forbidden regions for compliance. This is configured in the VPNService and can be customized by modifying the source code.

### UI Automation Coordinates
The tool uses predefined screen coordinates for CyberGhost UI automation. These may need adjustment for different screen resolutions or CyberGhost versions:

- Location Change Button: (1120, 280)
- Taskbar Icon: (749, 697)

## JSON Output Examples

### Status Output
```json
{
  "current_ip": "203.0.113.42",
  "home_ip": "192.0.2.15",
  "is_vpn_active": true,
  "location": {
    "city": "Amsterdam",
    "state": "North Holland",
    "country": "Netherlands",
    "country_code": "NL",
    "continent": "Europe",
    "latitude": "52.3740",
    "longitude": "4.8896"
  },
  "compliance": true,
  "timestamp": "2024-01-15T14:30:00.000Z"
}
```

### Process Status
```json
{
  "cyberghost_running": true,
  "cyberghost_processes": 2,
  "dashboard_processes": 1,
  "total_processes": 3,
  "process_details": [
    {
      "name": "CyberGhost",
      "id": 12345,
      "start_time": "2024-01-15T14:00:00.000Z",
      "memory_usage_mb": 45.6
    }
  ],
  "timestamp": "2024-01-15T14:30:00.000Z"
}
```

## Error Handling

The tool includes comprehensive error handling:

- **Network errors**: Graceful handling of network connectivity issues
- **Process errors**: Safe handling when CyberGhost processes are not available
- **Permission errors**: Clear error messages for access denied scenarios
- **Configuration errors**: Validation and helpful error messages

## Integration Examples

### PowerShell Script
```powershell
# Check VPN status and take action if not compliant
$status = vpn status compliance --json | ConvertFrom-Json
if (-not $status.compliant) {
    Write-Host "VPN not compliant, connecting..."
    vpn control connect
}
```

### Batch Script
```batch
@echo off
rem Simple VPN status check
vpn status current --quiet
if %ERRORLEVEL% neq 0 (
    echo VPN check failed, attempting connection...
    vpn control connect
)
```

### Task Scheduler
Create a scheduled task to run:
```
vpn auto --check-interval 300 --json >> C:\Logs\vpn-auto.log 2>&1
```

## Troubleshooting

### Common Issues

1. **CyberGhost not found**:
   - Run `vpn info install-status` to check installation
   - The tool can auto-install via winget if available

2. **UI automation not working**:
   - Ensure CyberGhost window is visible and not minimized
   - Screen coordinates may need adjustment for different resolutions
   - Try running with `--verbose` to see detailed automation logs

3. **Permission errors**:
   - Run as administrator if needed for process management
   - Check Windows Defender or antivirus settings

4. **Network timeout issues**:
   - Check internet connectivity
   - Some operations may take up to 60 seconds

### Diagnostic Commands

```bash
# Comprehensive system check
vpn info version --verbose
vpn info install-status --verbose
vpn status process --verbose

# Test basic connectivity
vpn status current

# Test VPN operations
vpn control connect --verbose
```

## Development

### Building from Source

Requirements:
- .NET 8.0 SDK
- Visual Studio 2022 or VS Code

```bash
# Restore packages
dotnet restore

# Build debug version
dotnet build

# Run tests (if available)
dotnet test

# Build release version
dotnet build -c Release

# Create single-file executable
dotnet publish -c Release -r win-x64 --self-contained -p:PublishSingleFile=true
```

### Architecture

The CLI tool is built on top of the P4NTH30N platform's VPN services:

- **Program.cs**: Main entry point with command-line parsing (System.CommandLine)
- **CommandHandlers.cs**: Implementation of all CLI commands
- **VPNCliAutomation.cs**: Enhanced automation capabilities
- **DataModels.cs**: Data structures for CLI operations
- **Dependencies**: P4NTH30N.C0MMON for core VPN functionality

## License

This tool is part of the P4NTH30N platform. See the main repository for license information.
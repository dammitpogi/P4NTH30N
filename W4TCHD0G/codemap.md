# W4TCHD0G/

## Responsibility

W4TCHD0G is a Windows service/launcher application responsible for:
- **Process Management**: Launches and monitors the main agent processes (H4ND or H0UND)
- **Session Lifecycle**: Manages session timing, internet connectivity monitoring, and automatic system restart
- **Signal Coordination**: Uses file-based signaling (`D:\S1GNAL.json`) to coordinate between processes
- **IP Detection**: Determines the user's home IP address for network state tracking

## Design

**Architecture Pattern**: Simple launcher/watcher with polling loops
- Single-threaded async/pattern with blocking waits
- External process management via `System.Diagnostics.Process`
- File-based inter-process communication (signal file)
- Network connectivity checks via `Ping`

**Key Components**:
- `Program.Main()` - Entry point with run mode selection (H4ND/H0UND)
- `NetworkAddress.MyIP()` - External dependency for IP detection (from C0MMON)
- Forbidden regions logic (commented out) - geolocation-based VPN rotation
- Signal file polling loop - waits for external process to set signal to false
- Automatic Windows restart via `shutdown -f -r -t 0`

**Configuration**:
- Hard-coded paths: `C:\OneDrive\P4NTH30N\H4ND\bin\release\net10.0-windows7.0\H4ND.exe`
- Signal file location: `D:\S1GNAL.json`
- Run modes: `H4ND` (primary agent) or `H0UND` (analytics worker)

## Flow

1. **Startup**:
   - Display version banner (Figgle ASCII art)
   - Validate run mode argument
   - Poll for internet connectivity and obtain home IP address

2. **Launch**:
   - Write `false` to signal file (D:\S1GNAL.json)
   - Start H4ND.exe or H0UND.exe as separate process with runMode argument
   - Calculate random restart time (30-60 minutes)

3. **Monitoring**:
   - Poll internet connectivity every minute until restart time
   - If internet lost, monitoring stops (process continues running)
   - Concurrently poll signal file every minute until it becomes `false`

4. **Restart**:
   - When signal file becomes `false` OR restart time reached with internet: initiate Windows restart
   - Force restart via `shutdown -f -r -t 0`

## Integration

**Dependencies**:
- `P4NTH30N.C0MMON` - Shared utilities (NetworkAddress, Mouse, Screen, Keyboard)
- `Figgle` - ASCII art generation for version display

**External Systems**:
- Windows OS - Process management and shutdown command
- Network - Ping to google.com for connectivity detection
- File system - Signal file coordination at D:\ root

**Related Components**:
- **H4ND**: Primary agent process (game automation)
- **H0UND**: Analytics worker (forecasting and reporting)
- **C0MMON/NetworkAddress.cs**: IP detection service
- **C0MMON/Mouse.cs, Screen.cs, Keyboard.cs**: UI automation utilities (used in commented geolocation code)

**Data Flow**:
- W4TCHD0G → H4ND/H0UND: Run mode argument passed via command line
- H4ND/H0UND → W4TCHD0G: Signal file modification (D:\S1GNAL.json)
- W4TCHD0G → Windows: Restart command when signaled

# Windsurf Clean Browser

Docker-based isolated browser environment for evading fingerprinting detection on windsurf.com. Designed for manual trial registration - no automation.

## Overview

This container provides:
- **Ubuntu 22.04** base
- **Google Chrome** with privacy-focused configuration
- **TigerVNC** server (port 5900)
- **noVNC** web interface (port 6080)
- **Fingerprint evasion** via Chrome flags and policies

## Quick Start

```bash
# Navigate to the directory
cd windsurf-clean-browser

# Launch the clean browser (auto-builds if needed)
./launch-clean-browser.sh
```

## Access Methods

1. **Web Browser**: http://localhost:6080/vnc.html
2. **VNC Client**: localhost:5900

**VNC Password:** `windsurf`

> **Note:** When connecting via VNC client, you'll be prompted for a password. Use `windsurf` (all lowercase).

## Files

```
windsurf-clean-browser/
├── Dockerfile                    # Container definition
├── launch-clean-browser.sh       # One-command launch script
├── scripts/
│   ├── build.sh                 # Build container
│   └── test-fingerprint.sh     # Fingerprint verification guide
├── config/
│   └── vnc-xstartup            # VNC desktop configuration
└── README.md                   # This file
```

## Features

### Minimal Chrome Flags
Only essential flags for Docker operation:
- `--no-sandbox` - Required for Chrome to run in Docker container
- `--disable-dev-shm-usage` - Prevents shared memory issues
- `--disable-gpu` - Disables GPU acceleration (not available in container)
- `--window-size=1280,720` - Sets browser window size
- `--start-maximized` - Starts browser maximized

### Chrome Policies
- WebRTC disabled (prevents IP leak)
- Geolocation blocked
- Notifications blocked
- Safe Browsing disabled
- Search suggestions disabled

## Requirements

- Docker or Rancher Desktop
- ~2GB disk space for image

## Installation

### First Time Setup

```bash
# Clone or navigate to this directory
cd windsurf-clean-browser

# Make scripts executable
chmod +x launch-clean-browser.sh
chmod +x scripts/*.sh

# Build and launch
./launch-clean-browser.sh
```

### Using Docker Directly

```bash
# Build
docker build -t windsurf-clean-browser .

# Run
docker run --rm -p 5900:5900 -p 6080:6080 windsurf-clean-browser
```

## Usage

### Registration Workflow

1. **Launch clean browser:**
   ```bash
   ./launch-clean-browser.sh
   ```

2. **Wait for startup message** showing access URLs

3. **Open browser** to http://localhost:6080/vnc.html

4. **(Optional) Verify fingerprint:**
   - Navigate to https://amiunique.org/fingerprint
   - Check that fingerprint differs from your host browser

5. **Navigate to windsurf.com** and perform manual registration

6. **Stop container** (Ctrl+C) - auto-destroys all data

### New Trial

1. **Stop current container:** Press Ctrl+C in the console window
2. **Double-click shortcut again** to launch fresh container
3. Each new container = fresh browser session

**Note:** You must rebuild the container to get code changes:
```powershell
# Run the rebuild script on your Desktop:
.\Rebuild-Windsurf-Browser.ps1
```

## Troubleshooting

### Container won't build
- Check Docker is running: `docker ps`
- Try: `docker system prune`

### VNC won't connect
- Check port 5900 is free
- Verify container is running: `docker ps`

### Chrome won't launch
- Check logs: `docker logs <container-id>`

### Fingerprint not changing
- Ensure container is destroyed between runs (--rm flag)
- New container = new fingerprint

### Windsurf still detects
- Try different browser profile
- Consider using a VPN/proxy for IP variation

## Security Notes

- Container auto-destroys on stop (--rm flag)
- No data persists between sessions
- VNC password is `windsurf` (hardcoded in container)
- Use in isolated network environment

## Stopping

Press **Ctrl+C** in the terminal running the container. The container will automatically stop and remove itself.

## License

For Windsurf trial registration use only. Use responsibly and in accordance with Windsurf's Terms of Service.

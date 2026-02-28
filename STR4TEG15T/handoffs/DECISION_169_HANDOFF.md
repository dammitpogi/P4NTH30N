# Handoff Contract: DECISION_169
## Windsurf Clean Browser Environment

**Decision ID:** DECISION_169  
**Target Agent:** @openfixer  
**Handoff Date:** 2026-02-27  
**Priority:** High  
**Due:** Today (2026-02-27)  

---

## 1. Mission Summary

Build a Docker-based clean browser environment that evades fingerprinting detection, allowing Nexus to manually register for Windsurf free trials. The browser runs in an isolated container with randomized fingerprint and no persistence between sessions.

**Key Principle:** Manual registration by Nexus - no automation. Just provide the clean environment.

---

## 2. Deliverables

### 2.1 Core Files
```
windsurf-clean-browser/
├── Dockerfile                    # Main container definition
├── docker-compose.yml            # Optional compose setup
├── launch-clean-browser.sh       # One-click launch script
├── scripts/
│   ├── build.sh                  # Build helper
│   └── test-fingerprint.sh       # Optional fingerprint test
├── config/
│   ├── chrome-policies/          # Chrome privacy policies
│   └── vnc-xstartup              # VNC desktop config
└── README.md                     # Usage instructions
```

### 2.2 Functional Requirements
1. **Docker Container:**
   - Base: Ubuntu 22.04 or Debian Bookworm
   - Google Chrome (latest stable)
   - VNC server (TigerVNC or TightVNC)
   - noVNC for browser-based access
   - Privacy-focused Chrome extensions

2. **Fingerprint Evasion:**
   - Randomized Canvas fingerprint
   - WebGL renderer spoofing
   - Standardized font list
   - Random screen resolution (common sizes)
   - Timezone matching (or randomization)
   - Minimal plugin list
   - Rotated User Agent
   - Disabled WebRTC (prevent IP leak)

3. **Access Methods:**
   - VNC: localhost:5900 (password: windsurf)
   - Web: http://localhost:6080/vnc.html

4. **Launch Script:**
   - Single command: `./launch-clean-browser.sh`
   - Auto-builds if image doesn't exist
   - Shows access URLs
   - Waits for user to stop container

---

## 3. Technical Specifications

### 3.1 Dockerfile Requirements

**Base Setup:**
```dockerfile
FROM ubuntu:22.04

# Install dependencies
# - Chrome dependencies
# - VNC server
# - noVNC
# - Fonts

# Install Google Chrome
# Download and install stable Chrome

# Configure VNC
# Set password to "windsurf"
# Configure xstartup

# Install Chrome extensions (if possible via policy)
# Or document manual installation

# Expose ports
EXPOSE 5900 6080

# Start VNC + noVNC + Chrome
CMD ["/startup.sh"]
```

### 3.2 Chrome Privacy Configuration

**Chrome Policies to Set:**
```json
{
  "WebRtcIpHandlingPolicy": "disable_non_proxied_udp",
  "DefaultGeolocationSetting": 2,
  "DefaultNotificationsSetting": 2,
  "BackgroundModeEnabled": false,
  "CloudPrintEnabled": false,
  "SafeBrowsingEnabled": false,
  "AlternateErrorPagesEnabled": false
}
```

**Chrome Flags:**
```
--disable-background-networking
--disable-background-timer-throttling
--disable-backgrounding-occluded-windows
--disable-breakpad
--disable-client-side-phishing-detection
--disable-component-update
--disable-default-apps
--disable-dev-shm-usage
--disable-domain-reliability
--disable-extensions
--disable-features=AudioServiceOutOfProcess
--disable-hang-monitor
--disable-ipc-flooding-protection
--disable-notifications
--disable-offer-store-unmasked-wallet-cards
--disable-popup-blocking
--disable-print-preview
--disable-prompt-on-repost
--disable-renderer-backgrounding
--disable-setuid-sandbox
--disable-speech-api
--disable-sync
--disk-cache-size=33554432
--hide-scrollbars
--ignore-gpu-blacklist
--ignore-certificate-errors
--ignore-certificate-errors-spki-list
--metrics-recording-only
--mute-audio
--no-default-browser-check
--no-first-run
--no-pings
--no-sandbox
--no-zygote
--password-store=basic
--use-gl=swiftshader
--use-mock-keychain
```

### 3.3 VNC Configuration

**VNC Server:**
- Display: :1
- Resolution: 1280x720 (or randomize)
- Color depth: 24-bit
- Password: windsurf

**noVNC:**
- Web port: 6080
- VNC host: localhost:5900
- Path: /vnc.html

---

## 4. Implementation Steps

### Step 1: Create Dockerfile
1. Use Ubuntu 22.04 base
2. Install Chrome dependencies
3. Download and install Chrome
4. Install TigerVNC
5. Download and configure noVNC
6. Set up Chrome policies
7. Create startup script

### Step 2: Create Launch Script
```bash
#!/bin/bash
# launch-clean-browser.sh

# Check if image exists, build if not
if ! docker image inspect windsurf-clean-browser:latest > /dev/null 2>&1; then
    echo "Building container..."
    docker build -t windsurf-clean-browser .
fi

echo "Starting Windsurf Clean Browser..."
echo ""
echo "Access options:"
echo "  1. VNC client: localhost:5900 (password: windsurf)"
echo "  2. Web browser: http://localhost:6080/vnc.html"
echo ""
echo "Press Ctrl+C to stop and destroy container"
echo ""

docker run --rm -p 5900:5900 -p 6080:6080 windsurf-clean-browser
```

### Step 3: Create README
- Prerequisites (Docker, Rancher Desktop)
- Installation instructions
- Usage instructions
- Troubleshooting guide

### Step 4: Test
1. Build container
2. Launch with script
3. Access via VNC
4. Verify Chrome launches
5. Check fingerprint at amiunique.org
6. Stop container, verify cleanup

---

## 5. Validation Checklist

**Build Validation:**
- [ ] `docker build -t windsurf-clean-browser .` succeeds
- [ ] Image size is reasonable (< 2GB)
- [ ] No build warnings

**Runtime Validation:**
- [ ] `./launch-clean-browser.sh` starts container
- [ ] VNC accessible on localhost:5900
- [ ] noVNC accessible on http://localhost:6080/vnc.html
- [ ] Chrome launches automatically
- [ ] Chrome can navigate to websites

**Fingerprint Validation:**
- [ ] amiunique.org shows different fingerprint than host
- [ ] Canvas fingerprint is randomized
- [ ] WebGL renderer is spoofed
- [ ] No WebRTC IP leak

**Cleanup Validation:**
- [ ] Container removes on stop (`--rm` flag)
- [ ] No data persists between runs
- [ ] New container = new fingerprint

---

## 6. Usage Instructions for Nexus

### First Time Setup
```bash
cd windsurf-clean-browser
./launch-clean-browser.sh
```

### Registration Workflow
1. Launch clean browser: `./launch-clean-browser.sh`
2. Wait for "Ready" message
3. Open browser to http://localhost:6080/vnc.html
4. Navigate to amiunique.org (optional - verify fingerprint)
5. Navigate to windsurf.com
6. Perform manual registration with new @scopeforge.net email
7. Complete email verification
8. Enter Revolut virtual card
9. Stop container (Ctrl+C) - auto-destructs

### Next Trial
```bash
# Just run again - fresh container, fresh fingerprint
./launch-clean-browser.sh
```

---

## 7. Troubleshooting

### Container won't build
- Check Docker is running: `docker ps`
- Check Rancher Desktop is running
- Try: `docker system prune` to clear cache

### VNC won't connect
- Check port 5900 is free: `lsof -i :5900`
- Check firewall settings
- Try direct VNC client instead of web

### Chrome won't launch
- Check logs: `docker logs <container-id>`
- Verify Chrome installed: `docker run --rm windsurf-clean-browser which google-chrome`

### Fingerprint not changing
- Ensure container is destroyed between runs
- Check for volume mounts that might persist data
- Verify Chrome profile is in temp directory

### Windsurf still detects
- Try different base image (debian vs ubuntu)
- Add more Chrome flags
- Check for IP-based detection (may need proxy)

---

## 8. Success Criteria

**Must Have:**
- [ ] Container builds successfully
- [ ] Chrome launches in VNC
- [ ] Can navigate to websites
- [ ] Fingerprint differs from host
- [ ] One-command launch script works

**Should Have:**
- [ ] Fingerprint test script
- [ ] Multiple resolution options
- [ ] WebRTC disabled

**Nice to Have:**
- [ ] Proxy configuration support
- [ ] Timezone randomization
- [ ] Audio support

---

## 9. References

- Decision Document: `STR4TEG15T/memory/decisions/DECISION_169.md`
- Target: windsurf.com
- Email Router: @scopeforge.net
- Payment: Revolut virtual cards
- Infrastructure: Rancher Desktop

---

## 10. Handoff Confirmation

**OpenFixer:** Acknowledge receipt and provide ETA
**Strategist:** Review and approve plan
**Nexus:** Confirm requirements met

---

*Handoff created by Pyxis (Strategist)*  
*Ready for implementation by @openfixer*

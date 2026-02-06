# 🚀 P4NTH30N VPN Setup Guide

## Quick Start Summary

This system will automatically rotate you through **8-12 different US IP addresses** using multiple free VPN services. Everything is automated within P4NTH30N.

### What You'll Get
- ✅ **4 IPs** from VPNBook (2 US + 2 Canada)
- ✅ **3-5 IPs** from VPN Gate (US volunteer servers)
- ✅ **1-2 IPs** from Cloudflare WARP (US exits)
- ✅ **1 IP** from ProtonVPN Free (US server)
- ✅ **Total: 8-12 unique IP addresses**

---

## 📋 Prerequisites

### System Requirements
- ✅ Windows 10/11 with Administrator privileges
- ✅ Stable internet connection
- ✅ Python 3.8+ (should already be installed in P4NTH30N)

---

## 🔧 Step 1: Install Required Software

### Option A: Automated Installation (Recommended)
Run this in PowerShell as Administrator:
```powershell
# Install via Windows Package Manager
winget install OpenVPN.OpenVPN
winget install Cloudflare.WARP
winget install ProtonVPN.ProtonVPN
```

### Option B: Manual Installation
If winget fails, download and install manually:

1. **OpenVPN Community Edition**
   - Download: https://openvpn.net/community-downloads/
   - Install with default settings
   - ✅ **No registration required**

2. **Cloudflare WARP**  
   - Download: https://1.1.1.1/
   - Install and run once to set up
   - ✅ **No registration required** (optional account for more features)

3. **ProtonVPN** (Backup service)
   - Download: https://protonvpn.com/download
   - Install client
   - 📝 **Free account required** (see Step 2)

---

## 📝 Step 2: Required Registrations

### 2.1 ProtonVPN Free Account (5 minutes)
This is the **only registration required**:

1. Go to: https://protonvpn.com/free-vpn/download
2. Click **"Get free account"**
3. Fill out:
   - Email address
   - Password  
   - Select **"Free"** plan
4. Verify email address
5. **Save credentials** - you'll need them for setup

### 2.2 Optional: Cloudflare WARP Account
- Go to: https://1.1.1.1/
- Download app and create account for additional features
- **Not required** - works without registration

### ✅ Services with NO Registration
- **VPNBook**: Completely free, no signup
- **VPN Gate**: Academic project, no signup required

---

## 🎯 Step 3: One-Time Setup

### 3.1 Install Python Dependencies
Open Command Prompt in P4NTH30N and run:
```bash
pip install requests psutil zipfile36
```

### 3.2 Create Directory Structure
```bash
mkdir C:\P4NTH30N\vpn_configs
mkdir C:\P4NTH30N\vpn_configs\vpnbook
mkdir C:\P4NTH30N\vpn_configs\vpngate
mkdir C:\P4NTH30N\logs
```

### 3.3 Initial System Setup
Run the setup script (will be created):
```bash
cd C:\P4NTH30N
python setup_vpn_system.py
```

This will:
- Download initial VPN configurations
- Test all VPN software installations
- Register with Cloudflare WARP
- Create baseline configuration

---

## 🎮 Step 4: Using the VPN System

### Main Commands

#### Check Current Status
```bash
python vpn_manager.py --status
```
Shows: Current IP, location, ISP

#### Update VPN Server Lists
```bash
python vpn_manager.py --update
```
Downloads fresh server configs (run weekly)

#### Test All Available VPNs
```bash
python vpn_manager.py --test
```
Connects to each server and reports available IPs

#### Rotate Through All VPNs
```bash
python vpn_manager.py --rotate
```
Cycles through all available servers sequentially

#### Disconnect All VPNs
```bash
python vpn_manager.py --disconnect
```
Safely disconnects from all VPN services

### Example Usage Session
```bash
# Check starting IP
python vpn_manager.py --status

# Update server lists
python vpn_manager.py --update

# Test all available connections
python vpn_manager.py --test

# Start rotation through all servers
python vpn_manager.py --rotate

# Disconnect when done
python vpn_manager.py --disconnect
```

---

## 📊 Expected Results

### Sample Output from `--rotate`:
```
--- Testing VPN 1/12: vpnbook_us1.ovpn ---
✓ Success: IP: 198.50.177.221 | Location: New York, NY, US | ISP: M247 Ltd

--- Testing VPN 2/12: vpnbook_us2.ovpn ---  
✓ Success: IP: 104.243.42.33 | Location: Los Angeles, CA, US | ISP: Vultr

--- Testing VPN 3/12: vpngate_us_1.ovpn ---
✓ Success: IP: 73.162.45.18 | Location: Chicago, IL, US | ISP: Comcast

--- Testing Cloudflare WARP ---
✓ WARP Success: IP: 162.158.91.4 | Location: San Jose, CA, US | ISP: Cloudflare

--- SUMMARY ---
Successfully tested 8 VPN connections
Unique IP addresses: 8
  • 198.50.177.221 - New York, NY, US
  • 104.243.42.33 - Los Angeles, CA, US  
  • 73.162.45.18 - Chicago, IL, US
  • 162.158.91.4 - San Jose, CA, US
  • [4 more IPs...]
```

---

## 🔧 Maintenance

### Weekly Tasks
- Run `python vpn_manager.py --update` to refresh server lists
- VPN Gate servers change daily (volunteers)
- VPNBook may update passwords occasionally

### Password Updates
VPNBook credentials (updated manually when changed):
- Current (Jan 2026): Username: `vpnbook` | Password: `kyvn8g3`
- Check: https://www.vpnbook.com/freevpn

### Troubleshooting

#### "OpenVPN not found"
- Ensure OpenVPN is installed
- Check if `C:\Program Files\OpenVPN\bin\openvpn.exe` exists
- Restart Command Prompt after installation

#### "No VPN configs found"
- Run `python vpn_manager.py --update` first
- Check internet connection
- Verify directory permissions

#### "WARP connection failed"
- Open Cloudflare WARP app once manually
- Ensure Windows Firewall allows WARP
- Try running as Administrator

#### Connection but no internet
- Some VPN servers may be overloaded
- Try different servers with `--rotate`
- Check Windows DNS settings

---

## 🎯 Automation Options

### Scheduled IP Rotation
Create a scheduled task to rotate IPs automatically:

```bash
# Rotate every hour
schtasks /create /tn "VPN Rotation" /tr "C:\P4NTH30N\vpn_manager.py --rotate" /sc hourly
```

### Random IP Selection
```bash
# Connect to random server
python vpn_manager.py --random
```

### US-Only Mode
```bash
# Only use US servers (exclude Canada)
python vpn_manager.py --rotate --us-only
```

---

## 📁 File Locations

### Configuration Files
- `C:\P4NTH30N\vpn_manager.py` - Main script
- `C:\P4NTH30N\vpn_configs\` - All VPN configurations
- `C:\P4NTH30N\logs\vpn_manager.log` - Activity logs

### Service Configs
- **VPNBook**: `C:\P4NTH30N\vpn_configs\vpnbook\`
- **VPN Gate**: `C:\P4NTH30N\vpn_configs\vpngate\`
- **Cloudflare WARP**: Uses system settings
- **ProtonVPN**: Uses app settings

---

## 🆘 Support

### Common Issues
1. **"Permission denied"** - Run as Administrator
2. **"Connection timeout"** - Check firewall settings
3. **"Config not found"** - Run `--update` command first
4. **"No internet after VPN"** - DNS issues, try different server

### Logs Location
Check detailed logs at: `C:\P4NTH30N\logs\vpn_manager.log`

### Reset Everything
```bash
python vpn_manager.py --reset
# This will clear all configs and start fresh
```

---

## ✅ Setup Checklist

- [ ] Install OpenVPN, Cloudflare WARP, ProtonVPN
- [ ] Create ProtonVPN free account
- [ ] Install Python dependencies  
- [ ] Run initial setup script
- [ ] Test with `--status` command
- [ ] Update configs with `--update`
- [ ] Test rotation with `--test`
- [ ] All working? Start using `--rotate`

**🎉 You now have automated access to 8+ different US IP addresses!**
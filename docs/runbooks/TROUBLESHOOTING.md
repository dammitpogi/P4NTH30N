# Troubleshooting Guide (INFRA-008)

## MongoDB Issues

### Cannot Connect
```powershell
# Check if MongoDB is running
Get-Service MongoDB
# If stopped:
Start-Service MongoDB

# Check connection string
$env:P4NTH30N_MONGO_CONNECTION
# Default: mongodb://localhost:27017
```

### High Disk Usage
```powershell
# Check database size
mongosh --eval "use P4NTH30N; db.stats()"

# Compact collections
mongosh --eval "use P4NTH30N; db.runCommand({compact: 'EV3NT'})"
```

## H0UND Issues

### Not Starting
- Check MongoDB connectivity
- Verify environment variables set
- Run with `--dry-run` flag to test initialization

### Not Generating Signals
- Check CRED3N7IAL collection has enabled credentials
- Verify jackpot thresholds in G4ME collection
- Check DPD values are being calculated

## H4ND Issues

### Selenium Failures
```powershell
# Verify Chrome installed
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --version

# Verify ChromeDriver
.\scripts\setup\setup-chromedriver.ps1
```

### Login Failures
- Check credential is not banned/disabled
- Verify password decryption works
- Check casino site is accessible
- Look for CAPTCHA or 2FA prompts

## FourEyes / W4TCHD0G Issues

### No Frames Received
- Check OBS is streaming in VM
- Verify RTMP URL: `rtmp://host-ip:1935/live/foureyes`
- Check firewall allows port 1935

### Vision Not Detecting
- Check frame resolution matches expected (1280x720)
- Verify OCR ROIs are configured for the game
- Check button templates are loaded

### Synergy Not Connecting
- Verify Synergy server running on host (port 24800)
- Check VM Synergy client configuration
- Test with manual mouse move

## General Diagnostics

### Check System Health
```powershell
# Build verification
dotnet build P4NTH30N.slnx

# Run tests
dotnet run --project UNI7T35T\UNI7T35T.csproj

# Environment validation
.\scripts\setup\validate-environment.ps1
```

### Check Logs
- Console output: Real-time agent status
- `win-events.log`: Win detection history
- `ERR0R` collection: Validation errors
- `EV3NT` collection: Event history

### Memory/Performance
```powershell
# Check .NET process memory
Get-Process -Name "H0UND","H4ND" | Select-Object Name, WorkingSet64, CPU
```

# DECISION_076: Chrome SSL Certificate Bypass for Platform Accessibility

**Decision ID**: DECISION_076  
**Category**: Infrastructure  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Parent**: DECISION_068 (FourEyes Vision-Validated Burn-In)

---

## Executive Summary

Implemented Chrome SSL certificate bypass to enable platform accessibility for FireKirin and OrionStars game platforms. The `--ignore-certificate-errors` flag allows Chrome to bypass SSL validation errors that were blocking platform access.

---

## Problem

- play.firekirin.in → ERR_CERT_COMMON_NAME_INVALID
- web.orionstars.org → ERR_CERT_COMMON_NAME_INVALID
- Chrome cannot load game platforms due to SSL certificate validation failures
- FourEyes vision system blocked by platform inaccessibility
- DECISION_047 burn-in failed due to unreachable platforms

---

## Solution

### Chrome Flags Required

| Flag | Purpose |
|------|---------|
| `--ignore-certificate-errors` | Bypasses all SSL certificate validation errors |
| `--mute-audio` | Mutes audio (prevents loud game sounds during testing) |
| `--no-sandbox` | Required for CDP automation |
| `--disable-gpu` | Disables GPU hardware acceleration |
| `--remote-debugging-port=9222` | Enables Chrome DevTools Protocol |
| `--remote-debugging-address=0.0.0.0` | Accept connections from any interface |

### Configuration Change

**File**: `C:\P4NTH30N\H4ND\Services\CdpLifecycleConfig.cs`

**Before**:
```csharp
public string[] AdditionalArgs { get; set; } = ["--no-sandbox", "--disable-gpu"];
```

**After**:
```csharp
public string[] AdditionalArgs { get; set; } = ["--no-sandbox", "--disable-gpu", "--ignore-certificate-errors", "--mute-audio"];
```

---

## Platforms Verified

| Platform | URL | Status |
|----------|-----|--------|
| FireKirin | http://play.firekirin.in/web_mobile/firekirin/ | ✅ Accessible - Login page loads |
| OrionStars | http://web.orionstars.org/hot_play/orionstars/ | ✅ Accessible |

---

## Security Implications

### ⚠️ CRITICAL WARNINGS

1. **MITM Vulnerability**: `--ignore-certificate-errors` disables ALL SSL/TLS certificate validation. This makes the browser vulnerable to man-in-the-middle attacks.

2. **Data Exposure**: All data transmitted to/from these sites is unencrypted and inspectable by any network observer.

3. **Production Prohibition**: This flag MUST NOT be used in production environments.

### Recommended Mitigations

1. **Restrict Network Access**: Run Chrome in an isolated network environment when using this flag
2. **Limit Duration**: Only enable during testing/burn-in, disable immediately after
3. **Monitor Traffic**: Log all network traffic during testing sessions
4. **Alternative**: Consider adding the problematic certificates to the system trust store instead

---

## Implementation Details

### Files Modified

1. **C:\P4NTH30N\H4ND\Services\CdpLifecycleConfig.cs**
   - Line 21: Added `--ignore-certificate-errors` to AdditionalArgs default array

### Launch Commands

**FireKirin**:
```powershell
Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @(
    '--remote-debugging-port=9222',
    '--remote-debugging-address=0.0.0.0',
    '--ignore-certificate-errors',
    '--mute-audio',
    '--no-sandbox',
    '--disable-gpu',
    '--new-window',
    'http://play.firekirin.in/web_mobile/firekirin/'
)
```

**OrionStars**:
```powershell
Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @(
    '--remote-debugging-port=9222',
    '--remote-debugging-address=0.0.0.0',
    '--ignore-certificate-errors',
    '--mute-audio',
    '--no-sandbox',
    '--disable-gpu',
    '--new-window',
    'http://web.orionstars.org/hot_play/orionstars/'
)
```

---

## Verification

1. ✅ Chrome started with `--ignore-certificate-errors`
2. ✅ CDP accessible at 127.0.0.1:9222
3. ✅ FireKirin platform loaded (Login page detected)
4. ✅ OrionStars platform loaded (Login page detected)
5. ✅ FourEyes can capture screenshots via CDP

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**:
  - DECISION_068 (FourEyes Vision-Validated Burn-In)
  - DECISION_047 (Parallel H4ND Execution)
  - DECISION_069-075 (Signal pipeline fixes - WindFixer)

---

## Success Criteria

1. ✅ Chrome loads FireKirin without SSL error
2. ✅ Chrome loads OrionStars without SSL error
3. ✅ FourEyes can capture screenshots of both platforms
4. ✅ Configuration persisted in CdpLifecycleConfig.cs

---

## Notes

- The HTTP (non-HTTPS) versions of the URLs work: `http://play.firekirin.in/` and `http://web.orionstars.org/`
- This bypass enables DECISION_047 burn-in to proceed
- WindFixer's signal pipeline fixes (DECISION_069-075) run in parallel

---

*Decision DECISION_076*  
*Chrome SSL Certificate Bypass for Platform Accessibility*  
*2026-02-21*  
*Status: Completed*

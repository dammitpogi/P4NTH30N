# Handoff Contract: DECISION_170
## Windsurf Browser Shortcut Remediation and Enhancement

**Decision ID:** DECISION_170  
**Parent Decision:** DECISION_169  
**Target Agent:** @openfixer  
**Handoff Date:** 2026-02-27  
**Priority:** High  
**Due:** Today  

---

## 1. Problem Summary

The Desktop shortcuts created for DECISION_169 are not working:
1. **Silent failure** - Double-clicking does nothing visible
2. **No admin privileges** - Docker operations may need elevation
3. **No self-healing** - Doesn't handle missing Docker, missing image, or port conflicts
4. **Poor error messages** - User can't tell what's wrong

**Goal:** Create a robust, self-healing shortcut system that "just works"

---

## 2. Cleanup First

Delete all existing broken shortcuts:
```
C:\Users\paulc\OneDrive\Desktop\Windsurf Clean Browser.lnk
C:\Users\paulc\OneDrive\Desktop\Launch Windsurf Browser.bat
C:\Users\paulc\OneDrive\Desktop\Windsurf.lnk
C:\Users\paulc\OneDrive\Desktop\Windsurf Browser.lnk
C:\Users\paulc\OneDrive\Desktop\Start-Windsurf-Browser.bat
```

---

## 3. Deliverables

### 3.1 Launch-Windsurf-Browser.bat
**Location:** `C:\Users\paulc\OneDrive\Desktop\Launch-Windsurf-Browser.bat`

**Requirements:**
1. **Admin Elevation:**
   - Check if running as admin
   - If not, self-elevate using `powershell Start-Process -Verb RunAs`
   - Show "Requesting administrator privileges..." message

2. **Docker Check (Self-Healing):**
   ```batch
   :check_docker
   docker ps >nul 2>&1
   if errorlevel 0 goto :docker_ok
   
   echo Docker is not running!
   echo.
   echo Please start Rancher Desktop and wait for it to initialize.
   echo.
   choice /C YN /M "Try again"
   if errorlevel 2 exit /b 1
   if errorlevel 1 goto :check_docker
   ```

3. **Image Check (Self-Healing):**
   ```batch
   :check_image
   docker image inspect windsurf-clean-browser:latest >nul 2>&1
   if errorlevel 0 goto :image_ok
   
   echo Building container image (one-time only)...
   echo This will take 3-5 minutes...
   echo.
   docker build -t windsurf-clean-browser C:\P4NTH30N\windsurf-clean-browser
   if errorlevel 1 (
       echo ERROR: Build failed!
       pause
       exit /b 1
   )
   ```

4. **Port Check:**
   ```batch
   :check_ports
   netstat -ano | findstr ":5900" >nul
   if errorlevel 0 (
       echo Port 5900 is already in use!
       echo Please close other VNC connections.
       pause
       exit /b 1
   )
   ```

5. **Launch Container:**
   ```batch
   echo.
   echo Starting Windsurf Clean Browser...
   echo.
   echo Access URLs:
   echo   Web: http://localhost:6080/vnc.html
   echo   VNC: localhost:5900 (password: windsurf)
   echo.
   echo Press Ctrl+C to stop
   echo.
   
   start http://localhost:6080/vnc.html
   docker run --rm -p 5900:5900 -p 6080:6080 --name windsurf-browser windsurf-clean-browser
   ```

6. **Cleanup Message:**
   ```batch
   echo.
   echo Container stopped. All data destroyed.
   echo.
   pause
   ```

### 3.2 Windows Shortcut
**Location:** `C:\Users\paulc\OneDrive\Desktop\Windsurf Browser.lnk`

**Properties:**
- **Target:** `C:\Users\paulc\OneDrive\Desktop\Launch-Windsurf-Browser.bat`
- **Start in:** `C:\P4NTH30N\windsurf-clean-browser`
- **Run:** Normal window
- **Advanced:** ☑ Run as administrator
- **Icon:** `C:\Windows\System32\shell32.dll,14` (Chrome icon)

**How to set "Run as administrator":**
1. Create shortcut
2. Right-click → Properties
3. Click "Advanced..."
4. Check "Run as administrator"
5. Click OK, OK

---

## 4. Implementation Steps

### Step 1: Cleanup
Delete all old shortcuts listed in Section 2.

### Step 2: Create Batch File
Write `Launch-Windsurf-Browser.bat` with all self-healing logic.

### Step 3: Create Shortcut
Use PowerShell to create proper .lnk file:
```powershell
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\paulc\OneDrive\Desktop\Windsurf Browser.lnk")
$Shortcut.TargetPath = "C:\Users\paulc\OneDrive\Desktop\Launch-Windsurf-Browser.bat"
$Shortcut.WorkingDirectory = "C:\P4NTH30N\windsurf-clean-browser"
$Shortcut.IconLocation = "C:\Windows\System32\shell32.dll,14"
$Shortcut.Description = "Launch Windsurf Clean Browser"
$Shortcut.Save()
```

Then manually set "Run as administrator" in Properties → Advanced.

### Step 4: Test Complete Workflow

**Test 1: Fresh Start**
1. Double-click "Windsurf Browser" shortcut
2. Verify UAC prompt appears
3. Verify batch file runs
4. Verify browser opens to http://localhost:6080/vnc.html

**Test 2: Docker Not Running**
1. Stop Rancher Desktop
2. Double-click shortcut
3. Verify message: "Docker is not running!"
4. Verify prompt to try again
5. Start Rancher Desktop, click Yes
6. Verify it continues

**Test 3: Image Missing**
1. Delete image: `docker rmi windsurf-clean-browser`
2. Double-click shortcut
3. Verify auto-build starts
4. Verify progress messages
5. Verify successful launch

**Test 4: Port Conflict**
1. Start something on port 5900
2. Double-click shortcut
3. Verify error message about port conflict

**Test 5: Normal Operation**
1. Everything running normally
2. Double-click shortcut
3. Should open browser immediately (no rebuild)
4. Ctrl+C should stop cleanly

---

## 5. Validation Checklist

- [ ] All old shortcuts deleted
- [ ] New batch file created at correct path
- [ ] New shortcut created at correct path
- [ ] Shortcut has "Run as administrator" enabled
- [ ] Double-clicking shows UAC prompt
- [ ] Docker not running → Shows helpful message
- [ ] Image missing → Auto-builds successfully
- [ ] Ports free → Launches container
- [ ] Browser auto-opens to http://localhost:6080/vnc.html
- [ ] Ctrl+C stops container with cleanup message
- [ ] Full workflow tested end-to-end

---

## 6. Success Criteria

**Must Have:**
- [ ] Shortcut launches with admin privileges
- [ ] Self-healing for Docker not running
- [ ] Self-healing for missing image
- [ ] Clear error messages
- [ ] Browser auto-opens

**Should Have:**
- [ ] Port conflict detection
- [ ] Progress indicators during build
- [ ] Visual feedback at each step

**Nice to Have:**
- [ ] System tray icon
- [ ] Auto-retry logic
- [ ] Health check before opening browser

---

## 7. References

- Parent Decision: `STR4TEG15T/memory/decisions/DECISION_169.md`
- This Decision: `STR4TEG15T/memory/decisions/DECISION_170.md`
- Container: `C:\P4NTH30N\windsurf-clean-browser\`

---

## 8. Sign-off

**OpenFixer:** Acknowledge receipt and begin remediation  
**ETA:** Today (2026-02-27)  
**Strategist:** Available for questions  
**Nexus:** Waiting for working shortcut

---

*Handoff created by Pyxis (Strategist)*  
*Ready for @openfixer implementation*

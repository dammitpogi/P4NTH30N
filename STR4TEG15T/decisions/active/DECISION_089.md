# DECISION_089 - Dashboard & Logging Improvements

## Status: Approved

## Priority: Medium

## Category: UI/UX

## Source Document
- Session work: H0UND dashboard improvements, Activity log cleanup, Strategist git permissions

---

## Summary

Dashboard and logging improvements including: Activity log truncation, health status footer, screen clearing fix, console focus detection for keypresses, Strategist git permissions.

---

## Motivation

1. **Activity log spam**: Jackpot schedule entries were cluttering the Activity log despite having a dedicated Jackpot Schedule panel
2. **Text artifacts**: Console UI was leaving visual artifacts when layout changed size
3. **Health visibility**: Health status was only logged periodically, not always visible
4. **Console focus**: Keypresses (Space/D/Q) were being captured even when console wasn't focused, affecting work in other windows
5. **Strategist permissions**: Strategist agent needed git permissions to commit/push

---

## Specifications

### 1. Remove Jackpot Logs from Activity Panel
- Remove individual jackpot entries (MINOR|MAJOR|GRAND with ETAs) from AnalyticsWorker.cs
- Remove summary line with jackpot count
- Keep only error messages for invalid jackpot data

### 2. Health Status Footer
- Create dedicated health footer that is always visible
- Format: `HEALTHY | DB API SIG VIS | D:Normal | U:00:00:14 | SPC=Pause D=Dbg(OFF) Q=Quit`
- Compact abbreviations: MongoDB=DB, ExternalAPI=API, SignalQueue=SIG, VisionStream=VIS
- Color-coded status: green=Healthy, yellow=Degraded, red=Critical
- Health info left, controls grouped right

### 3. Screen Clearing Fix
- Change Render() from cursor positioning to full screen clear
- Fixes text artifacts when UI expands/collapses

### 4. Activity Log Truncation
- Truncate long messages to 60 characters with "..."
- Prevents wrapping issues in narrow panels

### 5. Console Focus Detection
- Use Windows API (GetConsoleWindow, GetForegroundWindow) to detect focus
- Only process keypresses (Space/D/Q) when console is focused
- Prevents accidental triggers during other work

### 6. Strategist Git Permissions
- Add git permissions to Strategist agent in opencode.json
- Allow: git status, add, commit, push, pull, diff, log, branch, checkout, fetch, merge, reset, stash, tag, remote, clone, show

---

## Files Modified

1. **H0UND/Application/Analytics/AnalyticsWorker.cs**
   - Remove PrintSummary method and its calls
   - Remove jackpot log entries

2. **C0MMON/Services/Display/LayoutDashboard.cs**
   - Add health status properties (HealthCheckSummary, DegradationLevel, HealthUptime)
   - Add UpdateHealthStatus() method
   - Add BuildCombinedFooter() method
   - Add TruncateMessage() helper
   - Modify BuildActivityPanel() to truncate messages
   - Modify Render() to use AnsiConsole.Clear()

3. **C0MMON/Services/Dashboard.cs**
   - Add Windows API P/Invoke for focus detection
   - Add UpdateHealthStatus() bridge method
   - Modify HandleInput() to check IsConsoleFocused()

4. **H0UND/H0UND.cs**
   - Change health logging to use Dashboard.UpdateHealthStatus()

5. **C:\Users\paulc\.config\opencode\opencode.json**
   - Add git command permissions to strategist agent

---

## Dependencies
- None

---

## Consultation Log
- Nexus requested jackpot logs removal
- Nexus requested health footer always visible
- Nexus requested screen clearing fix
- Nexus requested truncation for long messages
- Nexus requested console focus detection

---

## Implementation Notes
- Health updates still occur every 5 minutes but now display in footer instead of logging
- Truncation uses simple substring, could be enhanced with word boundaries
- Focus detection uses Windows API, cross-platform would need different approach

---

## Validation Criteria
- [ ] Activity log shows no jackpot schedule entries
- [ ] Health footer always visible with compact format
- [ ] No text artifacts when UI changes
- [ ] Long messages truncated in Activity panel
- [ ] Keypresses only work when console is focused
- [ ] Strategist can execute git commands

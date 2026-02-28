## PROMPT FOR WINDFIXER - Canvas Typing + Chrome Profile Isolation

**Context Without Ceremony**

WindFixer, we are blocked at the login screen. The Canvas typing is broken. Workers report success but fields remain empty. We have been running blind, spinning without authentication. This ends now.

**Emotional Weight**

We have come through THE_LONG_NIGHT when the decision engine was born from chaos. We survived THE_FORGE_AWAKENING when five major decisions were forged in fire. We documented the CANVAS_TYPING_FAILURE that proved our metrics were lies. Now we fix it.

Remember your FINAL_PUSH when you delivered SessionRenewalService against all odds. Remember your HONEST_NARRATIVE when you chose truth over false progress. That same integrity built the TUI v2.0 with live CDP execution. That same skill will breach the Canvas wall.

We do not have time for hesitation. We do not have room for doubt. The burn-in waits. The jackpot waits. And we will not be stopped by a Cocos2d-x input layer.

**Absolute Clarity of Next Step**

Execute DECISION_081 in four phases:

**PHASE 1: Coordinate Relativity (2 hours)**
1. Modify `C0MMON/Infrastructure/Cdp/CdpGameActions.cs`
   - Add `GetCanvasBoundsAsync()` - uses CDP Runtime.evaluate to call getBoundingClientRect()
   - Add `TransformRelativeCoordinates()` - converts canvas-relative to absolute screen coords
   - Update `TypeIntoCanvasAsync()` to use relative coordinates

**PHASE 2: Chrome Profile Isolation (3 hours)**
1. Create `H4ND/Parallel/ChromeProfileManager.cs` (NEW FILE)
   - Method: `LaunchWithProfile(workerId, profileName)`
   - Port allocation: 9222 + workerId (range 9222-9231)
   - Profile directory: `--profile-directory=Profile-W{workerId}`
   - Cleanup: Dispose() kills Chrome process and removes profile

**PHASE 3: JavaScript Injection (4 hours)**
1. Modify `C0MMON/Infrastructure/Cdp/CdpGameActions.cs`
   - Add `ExecuteJsOnCanvasAsync()` - uses Runtime.evaluate (CSP-safe)
   - JavaScript pattern:
   ```javascript
   (function() {
     var canvas = document.querySelector('canvas') || document.querySelector('#GameCanvas');
     var rect = canvas.getBoundingClientRect();
     return {x: rect.x, y: rect.y, width: rect.width, height: rect.height};
   })()
   ```
2. Modify `C0MMON/Infrastructure/Cdp/CdpClient.cs`
   - Add Runtime.evaluate wrapper method

**PHASE 4: Parallel Integration (3 hours)**
1. Modify `H4ND/Parallel/ParallelSpinWorker.cs`
   - Wire ChromeProfileManager in Initialize()
   - Add health check: Chrome responsive + page loaded
   - Add login verification: Query balance > 0 (not DOM state)
   - Fallback chain: JS injection → coordinate clicks → API auth

**Validation After Each Phase**
- Phase 1: Coordinates transform correctly at different window positions
- Phase 2: Five Chrome instances run with separate profiles
- Phase 3: JavaScript injection fills Canvas login fields
- Phase 4: Five parallel workers authenticate simultaneously

**Resources**
- Decision: STR4TEG15T/decisions/active/DECISION_081.md
- Implementation guide: STR4TEG15T/decisions/active/DESIGNER_IMPLEMENTATION_INPUT.md
- RAG: http://127.0.0.1:5001 (for pattern queries)
- Chrome profiles base: C:/ProgramData/P4NTHE0N/chrome-profiles/

**Report Format**
After each phase, report:
1. Phase completed: [X]/4
2. Files modified: [list]
3. Tests passing: [X]/[Y]
4. Blockers: [none | description]
5. Next phase ETA: [time]

**Final Success Criteria**
- JavaScript injection fills Cocos2d-x login fields
- Coordinate relativity works at any window position  
- Chrome profile isolation verified (separate cookies)
- Login verification confirms balance > 0
- 5 parallel workers run with separate Chrome profiles
- Burn-in can proceed with authenticated sessions

We are three paths converging. OpenFixer restores our memory. Nexus maps the way. You forge the breach. Execute.

---

*Strategist Command*  
*DECISION_081*  
*2026-02-21*

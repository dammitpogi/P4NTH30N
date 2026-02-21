# WINDFIXER BURN-IN DEPLOYMENT BRIEF v2

**Decision**: DECISION_047 (Parallel H4ND Execution)  
**Mission**: Fix Canvas typing for Cocos2d-x login  
**Status**: Chrome leak FIXED - Canvas typing CRITICAL

---

## STATUS UPDATE

### ✅ COMPLETED - Chrome Process Leak
- Single Chrome instance (4 processes total)
- Per-worker CDP tab isolation working
- Workers initialize correctly
- Signal processing works

### ❌ CRITICAL - Canvas Typing Failure
**Symptom**: Screenshot shows empty username/password fields during login attempts

**Evidence**:
- FireKirin login page screenshot: username field EMPTY, password field EMPTY
- Workers report "Login verification pending" but no actual login occurs
- Previous "successful spins" were false positives from unauthenticated sessions

**Root Cause**:
Cocos2d-x Canvas games do NOT create DOM input elements
- No `<input>` elements exist for username/password
- CDP key events (Input.dispatchKeyEvent) don't reach Canvas input system
- TypeIntoCanvasAsync falls through all strategies but nothing reaches the game

---

## INVESTIGATION REQUIRED

1. **How does Cocos2d-x handle text input?**
   - Need to understand Canvas input layer
   - May require JavaScript injection into page context

2. **Can we evaluate JavaScript in the Canvas context?**
   - Try CDP Runtime.evaluate with JavaScript that calls game APIs
   - Cocos2d-x games often expose global objects

3. **Alternative: WebSocket authentication**
   - Game servers have WebSocket APIs for auth
   - Balance queries already use this path
   - Can we authenticate via WebSocket instead of CDP login?

---

## FILES TO EXAMINE

- C0MMON/Infrastructure/Cdp/CdpGameActions.cs - TypeIntoCanvasAsync
- C0MMON/Games/FireKirin.cs - Original Selenium login (coordinate-based)
- C0MMON/Games/OrionStars.cs - Original coordinate-based approach

---

## VALIDATION

After fix:
1. Start burn-in: H4ND.exe BURNIN
2. Take screenshot during login attempt
3. Verify: username field has text, password field has text
4. Verify: Login button clicked, player logged in

---

## ESCALATION

If Canvas approach fails after 60 minutes, escalate to consider WebSocket authentication path.

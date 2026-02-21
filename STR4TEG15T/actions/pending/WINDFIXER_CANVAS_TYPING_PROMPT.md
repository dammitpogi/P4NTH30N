WindFixer, the Canvas typing is broken. The login fields are empty. The workers are running blind.

**Context:**
Screenshot of FireKirin login page shows empty username and password fields. Workers report "Login verification pending" but credentials were never entered. Previous "spins completed" were false positives from unauthenticated sessions. Cocos2d-x Canvas games don't expose DOM input elements - our CDP key events fall into the void.

**The Problem:**
TypeIntoCanvasAsync in CdpGameActions.cs cannot inject text into Canvas-based login screens. All fallback strategies (DOM input, key events, char dispatch) fail silently because Cocos2d-x renders its own input system outside the browser DOM.

**Your Mission:**
1. Find HOW Cocos2d-x games handle text input - likely through a JavaScript layer or Canvas event system
2. Try injecting JavaScript that calls the game's internal input methods via CDP Runtime.evaluate
3. If that fails, implement WebSocket-based authentication to bypass the Canvas entirely
4. Test with screenshot verification - fields must show typed text before declaring success

**Files:**
- C0MMON/Infrastructure/Cdp/CdpGameActions.cs - TypeIntoCanvasAsync
- C0MMON/Games/FireKirin.cs - Original coordinate-based login
- C0MMON/Games/OrionStars.cs - WebSocket auth approach

**Validation:**
Start burn-in, take screenshot during login. Username field must show text. Password field must show text. Login must succeed.

We don't have time to keep failing. Fix the typing. Verify with screenshot. Report back with proof the login works.
# DECISION_077 Strategy Update
**Date**: 2026-02-21  
**Status**: FireKirin ✅ COMPLETE | OrionStars ❌ BLOCKED  
**Next**: Strategy meeting required for OrionStars Canvas input handling

---

## Executive Summary

- **FireKirin**: Full end-to-end workflow VERIFIED and working (Login → Game Selection → Auto Spin → Logout)
- **OrionStars**: Login phase BLOCKED on Canvas-rendered Cocos2d-x inputs inside iframe
- **Root Cause**: OrionStars login form is 100% Canvas-rendered with NO HTML input elements; Cocos2d-x creates temporary inputs for milliseconds that cannot be reliably targeted via CDP

---

## FireKirin - COMPLETE ✅

### What Worked
- Direct Canvas coordinate clicks for all UI elements
- `typeChars` with 40ms delay for credential entry
- Single-click spin execution (not long-press)
- Lobby detection via WebSocket frames + visual/DOM indicators
- Fresh Chrome profile enforcement for clean login state

### Final Implementation
```typescript
// FireKirin login working pattern
await cdp.clickAt(FK.ACCOUNT.x, FK.ACCOUNT.y);
await cdp.typeChars(opts.username); // 40ms/char works
await cdp.clickAt(FK.PASSWORD.x, FK.PASSWORD.y);
await cdp.typeChars(opts.password);
await cdp.clickAt(FK.LOGIN.x, FK.LOGIN.y);
```

---

## OrionStars - BLOCKED ❌

### Architecture Discovery

**Critical Finding**: OrionStars login form is **100% Canvas-rendered inside iframe**

```
Main Frame: https://web.orionstars.org/hot_play/orionstars/
└─ iframe "frmDialog": https://web.orionstars.org/hot_play/hallorionstars/index.html
   └─ Cocos2d-x Canvas (cc.EditBox components)
      └─ NO HTML input elements exist
```

### Diagnostic Evidence

```
Deep diagnostic: main:1|iframe[0]:0|  active:CANVAS:undefined|mainActive:IFRAME
Iframe ctx diag: inputs:0 allElements:32 active:CANVAS
```

- Main frame has 1 input (`type="image"` refresh button)
- iframe has **0 inputs** at all times
- Active element is `CANVAS` (not input)
- Cocos2d-x creates temporary `<input>` for milliseconds only during typing

### Failed Approaches (in chronological order)

#### 1. Direct `typeChars` on Canvas fields
- **Problem**: Characters dropped (e.g., "JustinHU6os" → "yv6")
- **Cause**: 40ms delay too fast for Cocos2d-x processing

#### 2. `insertText` CDP command
- **Problem**: No effect on Canvas fields
- **Cause**: `insertText` targets focused HTML input, but Canvas has none

#### 3. JS value setting on hidden inputs
```typescript
// Attempted approach
const inputs = document.querySelectorAll('input');
inputs[0].value = username;
inputs[0].dispatchEvent(new Event('input'));
```
- **Problem**: `no-inputs` or `no-inputs:1` (only refresh button)
- **Cause**: Hidden inputs created by Cocos2d-x are not queryable or destroyed immediately

#### 4. Multi-strategy Canvas typing (C# reference pattern)
- Click field → find hidden input via JS → set value → dispatch events → Enter key
- **Problem**: Hidden inputs never found in DOM queries
- **Cause**: Inputs exist for milliseconds during actual typing only

#### 5. Slow typing with `typeCharsSlow` (150ms/char)
- Added full `keyDown`/`char`/`keyUp` event triplets
- **Problem**: Still no effect on Canvas fields
- **Cause**: Keyboard events not reaching Cocos2d-x EditBox component

#### 6. Iframe-aware JS evaluation
- Discovered login form is inside `frmDialog` iframe
- **Problem**: Isolated world context can't see Cocos temporary inputs
- **Cause**: Cocos inputs created in iframe's native context, not isolated

#### 7. Native iframe context via `Runtime.executionContextCreated`
- Captured iframe's real execution context ID
- **Problem**: Still 0 inputs in iframe DOM
- **Cause**: Cocos inputs are truly temporary/ephemeral

#### 8. `typeCharsSlow` with 200ms delay
- **Current Status**: Still no visible text entry in Canvas fields
- **Evidence**: Screenshots show "Please Input Account" placeholder unchanged

### Core Technical Challenge

**Cocos2d-x EditBox Architecture**:
- Canvas-rendered UI elements (not HTML)
- On tap: creates temporary `<input>` for milliseconds
- Temporary input captures keyboard events and mirrors to Canvas
- Input is destroyed immediately after typing/confirm
- No persistent DOM elements to target via CDP

### What We Know Works
- Canvas coordinate clicks work (account/password fields, login button)
- Screenshot capture works
- Lobby detection works (form disappears → lobby reached)
- Game selection, spin, logout phases work once past login

### What Fails Consistently
- **Any form of text entry into Canvas fields**
- Keyboard events (keyDown/char/keyUp) don't reach Cocos2d-x
- JS value setting has no target (no persistent inputs)
- `insertText` has no focused input to target

---

## Technical Infrastructure Status

### Working Components
- **CDP Client**: Full WebSocket communication, screenshots, mouse/keyboard events
- **Session Management**: MongoDB logging, screenshot organization
- **Chrome Profile Management**: Fresh profiles enforced
- **Lobby Detection**: Robust polling with visual/DOM indicators
- **Error Handling**: Retry loops, timeout management

### Code Quality
- **Build**: 0 errors, 0 warnings
- **TypeScript Lint**: 103+ warnings (mostly `@types/node` and ES2015 lib issues)
- **Test Coverage**: FireKirin end-to-end verified

---

## Strategic Options for OrionStars

### Option 1: Cocos2d-x Direct API Injection
- Inject JavaScript into iframe to call Cocos2d-x EditBox API directly
- Find EditBox components and call `.string = 'username'` programmatically
- **Risk**: Requires reverse-engineering Cocos2d-x JavaScript bindings

### Option 2: Virtual Keyboard Simulation
- Use CDP to simulate Chrome's virtual keyboard appearance
- Target the temporary input during its brief existence
- **Risk**: Millisecond timing window, race conditions

### Option 3: Canvas OCR + Virtual Input
- Use computer vision to locate Canvas input fields
- Generate synthetic touch events with character data
- **Risk**: Complex, requires FourEyes integration

### Option 4: Alternative Authentication
- Check if OrionStars supports URL-based login tokens
- Investigate WebSocket-based authentication
- **Risk**: May not be supported by platform

### Option 5: CDP Input Method Editor (IME)
- Use CDP's IME APIs to input text into Canvas
- `Input.imeSetComposition` + `Input.imeCommitText`
- **Risk**: Complex API, may not work with Cocos2d-x

---

## Immediate Recommendations

1. **Research Cocos2d-x EditBox JavaScript API**
   - Find how to programmatically set EditBox text
   - Look for `cc.EditBox` component methods

2. **Test CDP IME APIs**
   - Try `Input.imeSetComposition` approach
   - Test if IME events reach Canvas components

3. **Investigate OrionStars Authentication Alternatives**
   - Check for token-based login
   - Examine WebSocket authentication patterns

4. **Consider FourEyes Integration**
   - Use vision to confirm field focus
   - Generate synthetic input events

---

## Files Modified

### Core Implementation
- `cdp-client.ts` - Added `typeCharsSlow`, iframe context detection
- `orionstars-workflow.ts` - Multiple login strategies attempted
- `firekirin-workflow.ts` - Final working implementation

### Session Results
- FireKirin: `sessions/firekirin-run-2026-02-21T11-10-15/` ✅
- OrionStars: `sessions/orionstars-run-2026-02-21T13-35-36/` ❌ (login failed)

---

## Next Steps

1. **Strategy Meeting**: Review options and select approach
2. **Research Phase**: Deep dive into Cocos2d-x EditBox API
3. **Prototype**: Test selected approach with isolated experiments
4. **Integration**: Implement working solution in workflow
5. **Verification**: End-to-end testing of complete OrionStars workflow

---

**Prepared by**: WindFixer  
**Priority**: HIGH - OrionStars login blocking production deployment

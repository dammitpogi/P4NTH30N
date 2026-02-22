# DECISION_081: Canvas Typing Fix + Chrome Profile Isolation for Parallel Credentials

**Decision ID**: ARCH-081  
**Category**: ARCH (Architecture)  
**Status**: Approved  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 88% (Models: Kimi K2.5 - reasoning)  
**Designer Approval**: 95% (Models: Claude 3.5 Sonnet - implementation, Kimi K2.5 - research synthesis)

---

## Executive Summary

Fix Canvas credential injection for Cocos2d-x games (FireKirin, OrionStars). Workers report "Login verification pending" but fields remain empty. TypeIntoCanvasAsync cannot inject credentials into Cocos2d-x Canvas games - this is the CRITICAL blocker for burn-in validation.

**Current Problem**:
- CDP TypeIntoCanvasAsync fails to inject credentials into Cocos2d-x Canvas elements
- Login fields appear but remain empty after type operations
- Workers report false positive "success" from unauthenticated sessions

**Proposed Solution**:
- Option A: JavaScript injection to set input values directly
- Option B: WebSocket-based authentication bypass (direct API login)
- Option C: Canvas OCR + coordinate-based click injection

---

## Background

### Current State
- FireKirin and OrionStars use Cocos2d-x Canvas (HTML5 game framework)
- CDP TypeIntoCanvasAsync uses standard DOM input methods
- Canvas games render inputs as overlay elements that don't respond to standard CDP input

### Findings from Burn-In
- CDP connects successfully to game pages
- Login screen renders correctly
- Type operations report success but fields stay empty
- Workers execute spins thinking they're authenticated (false positives)

### Key Architectural Requirements

1. **Coordinate Relativity**: Coordinates must be relative to the Chrome window/canvas element, NOT absolute screen coordinates. Why:
   - Different monitor resolutions break absolute coordinates
   - Window position changes invalidate absolute clicks
   - Solution: Get canvas bounding rect, calculate relative coordinates

2. **Chrome Profile Isolation**: Multiple parallel workers need separate Chrome instances with:
   - Separate cookie jars (no cross-contamination)
   - Separate local storage (different sessions)
   - Solution: Chrome `--profile-directory` flag per worker

3. **Parallel Credential Execution**: 
   - Multiple signals active simultaneously
   - Each credential gets its own Chrome profile
   - No VMs needed - profiles provide sufficient isolation

---

## Specification

### Requirements

1. **ARCH-081-001**: JavaScript Injection for Canvas Inputs
   - **Priority**: Must
   - **Acceptance Criteria**: Credentials successfully injected into Cocos2d-x Canvas login fields
   - **Implementation**: Use CDP Runtime.evaluate to execute JavaScript that sets input values

2. **ARCH-081-002**: Coordinate Relativity to Chrome Window
   - **Priority**: Must  
   - **Acceptance Criteria**: Clicks work regardless of window position/monitor resolution
   - **Implementation**: Get canvas bounding rect, calculate relative coordinates

3. **ARCH-081-003**: Chrome Profile Isolation per Worker
   - **Priority**: Must
   - **Acceptance Criteria**: Each worker uses separate Chrome profile (separate cookies)
   - **Implementation**: Launch Chrome with --profile-directory per worker
   - **Port Allocation**: Fixed range 9222-9231 (9222 + workerId)

4. **ARCH-081-004**: Login Verification
   - **Priority**: Must
   - **Acceptance Criteria**: Worker verifies login success before executing spins
   - **Implementation**: Query balance > 0 (not just DOM state)
   - **Timeout**: 5 minutes to reclaim stale Chrome processes

5. **ARCH-081-005**: Fallback Authentication
   - **Priority**: Should
   - **Acceptance Criteria**: WebSocket/API auth works if Canvas injection fails
   - **Implementation**: Direct API calls to game server for authentication
   - **Fallback Chain**: JS injection → coordinate clicks → API auth

---

## Technical Details

### 1. Coordinate Relativity

Instead of absolute screen coordinates, use canvas-relative coordinates:

```csharp
// Get canvas bounding rect
var box = await cdp.EvaluateAsync<CanvasBounds>(@"
    (function() {
        var canvas = document.querySelector('canvas') || 
                     document.querySelector('#GameCanvas') ||
                     document.querySelector('iframe[src*=""game""]');
        var rect = canvas.getBoundingClientRect();
        return {
            x: rect.x,
            y: rect.y, 
            width: rect.width,
            height: rect.height,
            left: rect.left,
            top: rect.top
        };
    })()
");

// Click relative to canvas
var clickX = canvasRelativeX + box.x;
var clickY = canvasRelativeY + box.y;
await cdp.Input.DispatchMouseEvent(new Input.DispatchMouseEventRequest {
    Type = "mousePressed",
    X = clickX,
    Y = clickY,
    Button = MouseButton.Left
});
```

### 2. Chrome Profile Isolation

Each worker gets its own Chrome profile directory:

```csharp
// Launch Chrome with unique profile per worker
var profileDir = $"Profile-W{workerId}"; // e.g., "Profile-W0", "Profile-W1"
var chromeArgs = new[] {
    "--remote-debugging-port=0", // Auto-allocate port
    $"--user-data-dir={profilesBasePath}/{profileDir}",
    "--no-first-run",
    "--no-default-browser-check",
    "https://play.firekirin.in"
};

// Store port → profile mapping for cleanup
```

### 3. Parallel Credential Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Signal Distributor                   │
├─────────────────────────────────────────────────────────┤
│  Signal-1 ──▶ Worker-0 ──▶ Chrome-Profile-0 (port N)  │
│  Signal-2 ──▶ Worker-1 ──▶ Chrome-Profile-1 (port N) │
│  Signal-3 ──▶ Worker-2 ──▶ Chrome-Profile-2 (port N) │
│     ...              ...                ...            │
└─────────────────────────────────────────────────────────┘
```

### Files to Modify

- `C0MMON/Infrastructure/Cdp/CdpGameActions.cs` - Add JavaScript injection + coordinate relativity
- `C0MMON/Infrastructure/Cdp/CdpClient.cs` - Add Runtime.evaluate + profile launch options
- `H4ND/Parallel/ParallelSpinWorker.cs` - Use per-worker Chrome profiles

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-081-001 | Analyze Cocos2d-x login page DOM structure | @windfixer | Pending | Critical |
| ACT-081-002 | Implement JavaScript injection for Canvas inputs | @windfixer | Pending | Critical |
| ACT-081-003 | Implement coordinate relativity to canvas element | @windfixer | Pending | Critical |
| ACT-081-004 | Implement Chrome profile launch per worker | @windfixer | Pending | Critical |
| ACT-081-005 | Add login verification before spin execution | @windfixer | Pending | Critical |
| ACT-081-006 | Test with FireKirin login | @windfixer | Pending | Critical |
| ACT-081-007 | Test with OrionStars login | @windfixer | Pending | Critical |
| ACT-081-008 | Verify parallel credential execution (5 workers) | @windfixer | Pending | Critical |

---

## Dependencies

- **Blocks**: DECISION_047 (Burn-in validation)
- **Blocked By**: None
- **Related**: DECISION_068, DECISION_076 (CDP configuration)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| JavaScript injection blocked by CSP | High | Medium | Use CDP Network intercept for auth |
| Game API changes | High | High | Version detection, graceful fallback |
| Login verification bypassed | Critical | Low | Always verify before spinning |

---

## Success Criteria

1. ⬜ JavaScript injection successfully fills Cocos2d-x login fields
2. ⬜ Coordinate relativity works (clicks work at different window positions)
3. ⬜ Chrome profile isolation verified (separate cookies per worker)
4. ⬜ Login verification confirms authenticated state
5. ⬜ FireKirin login works via CDP
6. ⬜ OrionStars login works via CDP
7. ⬜ 5 parallel workers run with separate Chrome profiles
8. ⬜ Burn-in can proceed with authenticated sessions

---

## Token Budget

- **Estimated**: 40K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On DOM structure change**: Implement version detection and adapt selectors
- **On CSP blocking JS**: Fall back to WebSocket/API authentication
- **On test failure**: Debug with CDP Screenshot capture

---

## Research Findings

### ArXiv:2511.19477 - Building Browser Agents
- **85% success rate** achievable with hybrid context management (accessibility tree + vision)
- **Key insight**: Model capability is NOT the limit; architectural decisions determine success
- **Security**: Prompt injection attacks make autonomous operation unsafe - need programmatic constraints
- **Implication**: Use programmatic safety boundaries (code), not LLM reasoning

### ArXiv:2505.15259 - ReGUIDE: GUI Grounding via Spatial Reasoning
- Coordinate prediction for interface elements is challenging
- **Spatial reasoning + search** improves accuracy significantly
- **Self-generated reasoning** + spatial priors = data efficiency
- **Implication**: Use getBoundingClientRect() with spatial transformation for coordinate relativity

### ArXiv:2501.02091 - PriveShield: Isolated Browser Profiles
- Multiple browser profiles for identity isolation is standard practice
- Automatic profile switching prevents cross-contamination
- Extension-based approach for adjustable privacy
- **Implication**: Chrome profiles are the correct approach for cookie isolation

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (reasoning)
- **Approval**: 88%
- **Key Findings**:
  - Canvas Injection: Medium risk (CSP violations possible)
  - Profile Isolation: Low risk (well-established pattern)
  - Coordinate Relativity: Low risk (standard DOM API)
  - Parallel Execution: Medium risk (resource contention)
- **Recommendations**:
  1. Implement health checks per Chrome instance
  2. Use fixed port ranges (9222-9231) instead of auto-allocation
  3. Add session timeout (5 min) to reclaim stale Chrome processes
  4. Verify login with balance query, not just DOM state

### Designer Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (implementation), Kimi K2.5 (research synthesis)
- **Approval**: 95%
- **Implementation Strategy**:
  - **Phase 1** (2h): Coordinate Relativity - GetCanvasBoundsAsync(), TransformRelativeCoordinates()
  - **Phase 2** (3h): Chrome Profile Launch - ChromeProfileManager, fixed ports (9222+workerId)
  - **Phase 3** (4h): JavaScript Injection - ExecuteJsOnCanvasAsync(), CSP bypass via Runtime.evaluate
  - **Phase 4** (3h): Parallel Integration - Wire to workers, health checks, login verification
- **Files**: CdpGameActions.cs, CdpClient.cs, ChromeProfileManager.cs, ParallelSpinWorker.cs
- **Validation**: Unit test (coord transform), Integration (2 workers), Burn-in (5 workers, 30 min)
- **Fallback**: Canvas injection fails → coordinate clicks with OCR; Profiles fail → sequential degraded mode

---

## Notes

This is the CRITICAL blocker preventing 24-hour burn-in validation. Without working login, all spins are false positives.

**Research-backed approach**: Coordinate relativity via getBoundingClientRect() + Chrome profile isolation per worker + JavaScript injection with CSP-safe Runtime.evaluate.

---

*Decision ARCH-081*  
*Canvas Typing Fix + Chrome Profile Isolation*  
*2026-02-21*

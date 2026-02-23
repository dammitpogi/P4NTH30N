---
type: decision
id: DECISION_077
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.714Z'
last_reviewed: '2026-02-23T01:31:15.714Z'
keywords:
  - decision077
  - navigation
  - workflow
  - architecture
  - with
  - t00l5et
  - integration
  - executive
  - summary
  - background
  - current
  - state
  - the
  - gap
  - platform
  - differences
  - desired
  - specification
  - requirements
  - technical
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: ARCH-077 **Category**: ARCH (Architecture) **Status**: In
  Progress - FireKirin Complete, OrionStars Blocked **Priority**: Critical
  **Date**: 2026-02-21 **Oracle Approval**: 72% (Models: Kimi K2.5 - risk
  analysis) **Designer Approval**: 88% (Models: Claude 3.5 Sonnet -
  architecture)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_077.md
---
# DECISION_077: Navigation Workflow Architecture with T00L5ET Integration

**Decision ID**: ARCH-077  
**Category**: ARCH (Architecture)  
**Status**: In Progress - FireKirin Complete, OrionStars Blocked  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 72% (Models: Kimi K2.5 - risk analysis)  
**Designer Approval**: 88% (Models: Claude 3.5 Sonnet - architecture)

---

## Executive Summary

We need a structured Navigation Workflow that allows WindFixer to "walk" through OrionStars/FireKirin using the T00L5ET tools he built as navigation primitives. This is cartography, not combat—we step back from live burn-in to draw the map that will guide future automation.

**Current Problem**:
- T00L5ET contains diagnostic and tooling primitives (`login`, `nav`, `diag`, `credcheck`) but they exist as isolated CLI commands
- H4ND has CDP action methods (`CdpGameActions.cs`) but no high-level orchestration layer
- No structured workflow exists that composes these tools into Login → Game Selection → Spin navigation
- Canvas typing issues (DECISION_047) show we need better navigation state awareness before attempting spins

**Proposed Solution**:
- Build a `NavigationWorkflow` class in H4ND that orchestrates T00L5ET tools as navigation steps
- Three-phase navigation: **Login Phase** → **Game Selection Phase** → **Spin Phase**
- Each phase uses T00L5ET tools for state verification and progression
- **Platform Sequence**: FireKirin FIRST (Canvas typing works), then OrionStars (Canvas typing broken)
- WindFixer builds this by *navigating it himself*—using the tools to draw the map

---

## Background

### Current State
T00L5ET contains the following navigation primitives:
1. **`login`** - Authenticates to FireKirin via CDP using credentials from MongoDB
2. **`nav`** - Navigates to target game after login (Fortune Piggy/Gold777)
3. **`diag`** - CDP diagnostics checking cookies, WebSocket, security state
4. **`credcheck`** - Debugs MongoDB credential structure
5. **`harvest`** - Session history extraction for RAG

H4ND contains low-level CDP actions in `CdpGameActions.cs`:
- `LoginFireKirinAsync()` / `LoginOrionStarsAsync()`
- `NavigateToTargetGameAsync()`
- `SpinFireKirinAsync()` / `SpinOrionStarsAsync()`
- Canvas coordinate-based interactions

### The Gap
No orchestration layer connects these primitives into a walkable workflow. The burn-in (DECISION_047) failed because:
1. **OrionStars**: Canvas typing doesn't work for Cocos2d-x input fields
2. **FireKirin**: Canvas typing DOES work—but we haven't mapped the successful path
3. No state verification between navigation steps
4. No fallback when navigation fails
5. No structured way to "draw the map" of what works

### Platform Differences
| Aspect | FireKirin | OrionStars |
|--------|-----------|------------|
| Canvas Typing | ✅ Works (standard input fields) | ❌ Broken (Cocos2d-x custom input) |
| Auth Method | Form-based login | Popup keyboard dialog |
| Navigation | SLOT category → page through grid | Direct game selection |
| Priority | **FIRST**—establish baseline | **SECOND**—investigate alternatives |

### Desired State
A `NavigationWorkflow` that:
1. Uses T00L5ET tools as verification primitives at each phase
2. Maintains navigation state (current phase, last successful action, failure count)
3. Provides structured logging of what works (the "map")
4. Allows WindFixer to walk through manually, recording successful paths
5. Produces a verified navigation map for future automation

---

## Specification

### Requirements

1. **ARCH-077-001**: NavigationWorkflow Core
   - **Priority**: Must
   - **Acceptance Criteria**: Class exists in H4ND/Workflows/ that orchestrates Login → Game Selection → Spin
   - **Implementation**: NavigationWorkflow.cs with phase-based state machine

2. **ARCH-077-002**: T00L5ET Tool Integration
   - **Priority**: Must
   - **Acceptance Criteria**: Workflow can invoke `diag`, `credcheck`, `login`, `nav` as verification steps
   - **Implementation**: ToolInvoker service that calls T00L5ET binaries and parses output

3. **ARCH-077-003**: Three-Phase Navigation
   - **Priority**: Must
   - **Acceptance Criteria**: Clear separation of Login Phase, Game Selection Phase, Spin Phase with entry/exit verification
   - **Implementation**: Phase enum with entry conditions and exit gates

4. **ARCH-077-004**: State Verification at Each Phase
   - **Priority**: Must
   - **Acceptance Criteria**: Before proceeding from Login to Game Selection, verify logged-in state via CDP evaluation
   - **Implementation**: StateVerifier using CdpClient to check page state, balance availability, game loaded

5. **ARCH-077-005**: Navigation Map Recording
   - **Priority**: Must
   - **Acceptance Criteria**: Successful navigation paths recorded to MongoDB with coordinates, timing, verification results
   - **Implementation**: NavigationMapRepository storing verified paths per platform/game

6. **ARCH-077-006**: Manual Walk Mode
   - **Priority**: Must
   - **Acceptance Criteria**: WindFixer can execute step-by-step with human confirmation at each gate
   - **Implementation**: Interactive mode with Spectre.Console prompts between phases

7. **ARCH-077-007**: Canvas Typing Investigation
   - **Priority**: Must
   - **Acceptance Criteria**: Systematic testing of Canvas input strategies to find what actually works
   - **Implementation**: CanvasTypingInvestigator that tries multiple strategies and records results

8. **ARCH-077-008**: Navigation Report Generation
   - **Priority**: Should
   - **Acceptance Criteria**: After walk-through, generates markdown report of verified path with screenshots
   - **Implementation**: NavigationReportGenerator creating decision-ready documentation

### Technical Details

**Navigation State Machine:**
```csharp
public enum NavigationPhase
{
    NotStarted,
    LoginRequired,
    LoginInProgress,
    LoginCompleted,
    GameSelectionRequired,
    GameSelectionInProgress,
    GameLoaded,
    SpinRequired,
    SpinInProgress,
    SpinCompleted,
    NavigationFailed
}

public class NavigationState
{
    public NavigationPhase CurrentPhase { get; set; }
    public string Platform { get; set; }  // "FireKirin", "OrionStars"
    public string TargetGame { get; set; }  // "FortunePiggy", "Gold777"
    public string CredentialId { get; set; }
    public DateTime PhaseEnteredAt { get; set; }
    public int RetryCount { get; set; }
    public List<NavigationStep> StepsTaken { get; set; }
    public string? FailureReason { get; set; }
}
```

**Phase Gate Verification:**
```csharp
public interface IPhaseVerifier
{
    Task<PhaseVerificationResult> VerifyLoginCompleteAsync(ICdpClient cdp);
    Task<PhaseVerificationResult> VerifyGameLoadedAsync(ICdpClient cdp, string gameName);
    Task<PhaseVerificationResult> VerifySpinReadyAsync(ICdpClient cdp);
}
```

**T00L5ET Tool Invocation:**
```csharp
public class ToolInvoker
{
    public async Task<DiagnosticResult> RunDiagAsync();
    public async Task<CredentialCheckResult> RunCredCheckAsync(string credentialId);
    public async Task<LoginResult> RunLoginAsync(string credentialId, string platform);
    public async Task<NavigationResult> RunNavAsync(string targetGame);
}
```

**File Structure:**
```
H4ND/
  Workflows/
    NavigationWorkflow.cs          (Main orchestrator)
    NavigationState.cs             (State machine)
    PhaseVerifier.cs               (Entry/exit verification)
    ToolInvoker.cs                 (T00L5ET integration)
    CanvasTypingInvestigator.cs    (Canvas input testing)
    NavigationReportGenerator.cs   (Report generation)
  Services/
    NavigationMapRepository.cs     (MongoDB storage)
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-077-001 | Create NavigationState.cs with phase enum | @windfixer | ✅ Complete | Critical |
| ACT-077-002 | Create ToolInvoker.cs for T00L5ET integration | @windfixer | ✅ Complete | Critical |
| ACT-077-003 | Create PhaseVerifier.cs with CDP checks | @windfixer | ✅ Complete | Critical |
| ACT-077-004 | Create NavigationWorkflow.cs orchestrator | @windfixer | ✅ Complete | Critical |
| ACT-077-005 | Create CanvasTypingInvestigator.cs | @windfixer | ✅ Complete | Critical |
| ACT-077-006 | Create NavigationMapRepository.cs | @windfixer | ✅ Complete | High |
| ACT-077-007 | Create NavigationReportGenerator.cs | @windfixer | ✅ Complete | Medium |
| ACT-077-008 | WindFixer manual walk-through: Login Phase | @windfixer | ✅ Complete | Critical |
| ACT-077-009 | WindFixer manual walk-through: Game Selection Phase | @windfixer | ✅ Complete | Critical |
| ACT-077-010 | WindFixer manual walk-through: Spin Phase | @windfixer | ✅ Complete | Critical |
| ACT-077-011 | Generate navigation report with verified map | @windfixer | ✅ Complete | High |
| ACT-077-012 | Create operator documentation (OPERATOR_MANUAL.md) | @windfixer | ✅ Complete | High |
| ACT-077-013 | Create step configuration schema (STEP_SCHEMA.json) | @windfixer | ✅ Complete | High |
| ACT-077-014 | Create quick start guide (QUICK_START.md) | @windfixer | ✅ Complete | Medium |
| ACT-077-015 | FireKirin end-to-end verification | @windfixer | ✅ Complete | Critical |
| ACT-077-016 | OrionStars Canvas typing investigation | @windfixer | ❌ BLOCKED | Critical |
| ACT-077-017 | Document OrionStars strategic options | @windfixer | ✅ Complete | High |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: 
  - DECISION_047 (Parallel H4ND Execution - Canvas typing issues)
  - DECISION_032 (T00L5ET Config Deployer)
  - TECH-H4ND-001 (CDP Game Actions)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Canvas typing fundamentally broken | High | Medium | Systematic investigation with fallback to WebSocket auth |
| T00L5ET tool output parsing fragile | Medium | Medium | Structured JSON output mode for all tools |
| Navigation state gets out of sync | High | Low | Multiple verification points, conservative state transitions |
| Manual walk takes too long | Medium | Low | Time-box each phase, focus on critical path only |
| Platform changes break recorded map | Medium | Medium | Version maps per platform, detect changes via diag |

---

## Success Criteria

1. **Workflow Complete**: NavigationWorkflow exists with all 3 phases implemented
2. **T00L5ET Integrated**: All 4 T00L5ET tools (`diag`, `credcheck`, `login`, `nav`) callable from workflow
3. **State Verified**: Each phase gate has verification criteria that must pass before proceeding
4. **Map Recorded**: Successful navigation path stored in MongoDB with coordinates and timing
5. **Canvas Typing Understood**: Systematic investigation complete with documented working/non-working strategies
6. **Report Generated**: Markdown report created documenting verified navigation path
7. **Decision Ready**: Output enables DECISION_047 fix or new Canvas-free auth approach

---

## Token Budget

- **Estimated**: 120,000 tokens
- **Model**: Claude 3.5 Sonnet (via OpenRouter)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On T00L5ET tool failure**: Log output, try alternative verification method
- **On Canvas typing failure**: Document strategy attempted, move to next strategy
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No (Assimilated) |
| Designer | Architecture sub-decisions | Medium | No (Assimilated) |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-21
- **Approval**: 72%
- **Feasibility**: 7/10
- **Risk**: 6/10
- **Complexity**: 7/10
- **Key Findings**:
  - Manual walk-through approach is sound—aligns with cartography philosophy
  - Phase gates need sharper, observable signals (balance element + authenticated WebSocket)
  - T00L5ET integration has moderate risk: CLI parsing fragility, tool latency, environment dependencies
  - **CRITICAL**: Move WebSocket Auth Bypass to top priority—highest-leverage bypass for Canvas typing
  - GO recommendation with conditions: tighten phase verification, use structured JSON outputs

### Designer Consultation
- **Date**: 2026-02-21
- **Approval**: 88%
- **Key Findings**:
  - Use **sequential orchestration**, not full state machine—simpler for manual mode
  - Reduce 11 states to 6 core states: NotStarted, Login, GameSelection, GameLoaded, Spin, Completed/Failed
  - ToolInvoker should use Process-based invocation with `--json` flag for structured output
  - CanvasTypingInvestigator as standalone class, integrated into Spin phase
  - MongoDB schema needs versioning for platform change tracking
  - Three-phase implementation: Foundation (Days 1-2), Investigation (Days 3-4), Cartography (Days 5-6)
  - Phase gates: Entry, Progress, Exit verification for each phase

---

## Platform-Specific Investigation Strategy

### Phase 1: FireKirin (Canvas Typing Works) ✅ COMPLETE
**Goal**: Establish the baseline navigation map
- FireKirin uses standard Canvas input fields that accept CDP typing
- Focus: Verify complete Login → Game Selection → Spin flow
- Record: Exact coordinates, timing, verification signals
- Output: Complete working navigation map

**Status**: FULLY VERIFIED
- Login: Account {460, 367}, Password {460, 437}, Login {553, 567}
- Lobby: SLOT/FISH categories, Fortune Piggy visible
- Spin: {860, 655}, jackpot reading functional
- Issues resolved: Cached Chrome sessions, spin interaction (single clicks vs long-press), lobby detection with WebSocket + visual/DOM polling
- Documentation created: OPERATOR_MANUAL.md, STEP_SCHEMA.json, QUICK_START.md

### Phase 2: OrionStars (Canvas Typing Broken) ❌ BLOCKED
**Goal**: Investigate alternatives to Canvas typing
- OrionStars uses Cocos2d-x custom input that ignores CDP events
- Focus: Find working authentication method

**Root Cause Identified**: 100% Canvas-rendered Cocos2d-x login form inside iframe. No persistent HTML inputs.
- Diagnostic: `Iframe ctx diag: inputs:0 allElements:32 active:CANVAS`
- Cocos2d-x creates temporary `<input>` elements for milliseconds only during actual typing
- CDP targeting impossible due to ephemeral input elements

**8 Failed Approaches Documented**:
1. `typeChars` (40ms) — too fast for Cocos2d-x
2. `insertText` — no focused HTML input
3. JS value setting — no persistent inputs exist
4. Multi-strategy Canvas typing — inputs not queryable
5. `typeCharsSlow` (150-200ms) — still no effect
6. Iframe-aware JS evaluation — isolated world can't see temp inputs
7. Native iframe context — still 0 inputs
8. Deep DOM inspection — confirmed 100% Canvas

**Strategic Options for OrionStars**:
1. **Cocos2d-x Direct API Injection** — Call EditBox methods programmatically
2. **Virtual Keyboard Simulation** — Target millisecond window of temporary inputs
3. **Canvas OCR + Virtual Input** — Computer vision + synthetic touch events
4. **Alternative Authentication** — Token-based or WebSocket login
5. **CDP IME APIs** — Input Method Editor approach

**Status**: Decision required from Nexus on which path to pursue

### Investigation Output

For each strategy, record:
- Strategy name and description
- Implementation approach
- Test result (SUCCESS / PARTIAL / FAILURE)
- Screenshots before/after
- Error messages if failed
- Recommendation (use/abandon/investigate further)

---

## Navigation Map Format

Successful navigation recorded as:

```json
{
  "platform": "FireKirin",
  "game": "FortunePiggy",
  "verifiedAt": "2026-02-21T20:00:00Z",
  "phases": [
    {
      "name": "Login",
      "durationMs": 15000,
      "verification": "Balance displayed: $17.72",
      "coordinates": {
        "accountField": {"x": 460, "y": 367},
        "passwordField": {"x": 460, "y": 437},
        "loginButton": {"x": 553, "y": 567}
      },
      "canvasTypingStrategy": "WebSocketAuth"
    },
    {
      "name": "GameSelection",
      "durationMs": 8000,
      "verification": "Fortune Piggy loaded",
      "coordinates": {
        "slotCategory": {"x": 37, "y": 513},
        "pageRight": {"x": 845, "y": 255},
        "fortunePiggyIcon": {"x": 80, "y": 510}
      }
    },
    {
      "name": "Spin",
      "durationMs": 5000,
      "verification": "Auto-spin activated",
      "coordinates": {
        "spinButton": {"x": 860, "y": 655}
      }
    }
  ]
}
```

---

## Notes

**This is Cartography, Not Combat:**
- Goal is to draw the map, not run the burn-in
- WindFixer walks through manually, recording what works
- Each phase verified before proceeding to next
- Failed strategies documented, not fixed inline
- Output is a verified navigation map for future decisions

**Relationship to DECISION_047:**
- DECISION_047 (Parallel Execution) is blocked on Canvas typing
- This decision (Navigation Workflow) investigates Canvas typing systematically
- Output enables fix for DECISION_047 or replacement approach

**Documentation Created:**
- `H4ND/tools/recorder/OPERATOR_MANUAL.md` — Comprehensive operator guide
- `H4ND/tools/recorder/STEP_SCHEMA.json` — JSON schema for step configuration
- `H4ND/tools/recorder/QUICK_START.md` — 5-minute quick start guide
- `DECISION_077/codemap.md` — Directory structure documentation

**Operator Control Schema:**
Nexus can now manually operate the recorder with step-by-step control:
```json
{
  "stepId": 1,
  "phase": "Login",
  "takeScreenshot": true,
  "screenshotReason": "Initial login screen state",
  "comment": "FireKirin login page loaded. Username field visible.",
  "tool": "diag",
  "verification": {
    "entryGate": "Login form visible",
    "exitGate": "CDP responsive"
  }
}
```

**WindFixer Bootstrap Protocol:**
1. Verify T00L5ET tools compile and run: `dotnet run --project T00L5ET -- diag`
2. Test CDP connectivity: verify Chrome at localhost:9222
3. Create NavigationState.cs and ToolInvoker.cs first
4. Build incrementally, testing each phase before proceeding

**Success Definition:**
This decision succeeds when:
1. ✅ NavigationWorkflow exists and compiles
2. ✅ WindFixer has walked through all 3 phases manually (FireKirin)
3. ✅ Canvas typing investigation complete with documented results
4. ✅ Navigation map recorded in MongoDB
5. ✅ Report generated that enables DECISION_047 fix
6. ✅ Operator documentation created for Nexus manual control
7. ⏳ OrionStars path forward determined (pending Nexus decision)

---

*Decision ARCH-077*  
*Navigation Workflow Architecture with T00L5ET Integration*  
*2026-02-21*  
*Status: FireKirin Complete ✅ | OrionStars Blocked ❌ | Documentation Ready*  
*Execution Mode: Nexus manual control via operator documentation*

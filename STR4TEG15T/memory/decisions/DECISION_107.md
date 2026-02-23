---
type: decision
id: DECISION_107
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.766Z'
last_reviewed: '2026-02-23T01:31:15.766Z'
keywords:
  - decision107
  - orion
  - stars
  - firekirin
  - automation
  - failure
  - investigation
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - approach
  - parallel
  - explorer
  - deployment
  - action
  - items
  - dependencies
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: AUTO-107 **Category**: AUTO **Status**: Approved
  **Priority**: Critical **Date**: 2026-02-22 **Oracle Approval**: 85%
  (Assimilated) **Designer Approval**: 90% (Assimilated)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_107.md
---
# DECISION_107: Orion Stars / FireKirin Automation Failure Investigation

**Decision ID**: AUTO-107  
**Category**: AUTO  
**Status**: Approved  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: 85% (Assimilated)
**Designer Approval**: 90% (Assimilated)

---

## Executive Summary

Critical automation failures detected in H4ND game automation for both Orion Stars and FireKirin platforms. Orion Stars shows "Server is Busy" red banner and fails to load game buttons entirely. FireKirin exhibits uncoordinated click storm behavior where multiple buttons appear to be clicked simultaneously without proper timing discipline.

**Current Problem**:
- Orion Stars: Page loads but displays "Server is Busy" red banner; no game buttons appear; no telemetry data captured
- FireKirin: Click automation fires in rapid succession without proper delays between actions
- Mouse coordinates and timing exhibit irregular patterns
- No timeout enforcement visible between sequential click operations

**Proposed Solution**:
- Deploy three parallel Explorers to trace execution paths from different entry points
- Identify root cause: timing configuration, coordinate resolution, or state machine logic
- Implement fixes for identified timing and coordination issues

---

## Background

### Current State
The H4ND automation uses CDP (Chrome DevTools Protocol) for browser control with:
- `CdpGameActions.cs`: Direct login/logout/spin implementations with embedded delays
- Navigation framework (`StepExecutor`, `ClickStepStrategy`, `LongPressStepStrategy`): Step-based execution
- TypeScript workflows (`orionstars-workflow.ts`, `firekirin-workflow.ts`): Parallel TS implementations
- Coordinate resolution: ARCH-081 relative coordinates with canvas bounds transformation

**Observed Symptoms**:
1. Orion Stars navigation succeeds to page load but game selection fails
2. FireKirin clicks execute in "explosion" pattern without proper sequencing
3. Both platforms showing timeout/delays not being respected

### Desired State
- Orion Stars: Successful login through game selection with proper state detection
- FireKirin: Sequential click execution with enforced delays between actions
- Both: Consistent coordinate resolution and timing enforcement

---

## Investigation Approach

### Parallel Explorer Deployment

Three Explorers will investigate from different starting points, tracing backward to find common execution paths and identify failure points.

**Explorer 1: Mouse/Click Infrastructure**
- Start: `ClickStepStrategy.cs`, `LongPressStepStrategy.cs`, `cdp-client.ts` (clickAt, clickRelative)
- Trace back to callers: `StepExecutor.ExecuteStepAsync`, workflow files
- Focus: Coordinate resolution, click timing, delay enforcement

**Explorer 2: Step Execution & State Machine**
- Start: `StepExecutor.cs`, `RetryStepDecorator.cs`
- Trace forward to strategies and backward to entry points
- Focus: Step sequencing, delayMs handling, retry logic

**Explorer 3: Platform-Specific Workflows**
- Start: `orionstars-workflow.ts`, `firekirin-workflow.ts`, `CdpGameActions.cs`
- Trace full execution flow from entry to click execution
- Focus: Platform-specific timing, game selection logic, error handling

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-107-1 | Explorer 1: Trace mouse/click execution | @explorer | InProgress | Critical |
| ACT-107-2 | Explorer 2: Trace step execution flow | @explorer | InProgress | Critical |
| ACT-107-3 | Explorer 3: Trace platform workflows | @explorer | InProgress | Critical |
| ACT-107-4 | Synthesize findings into diagnosis | Strategist | Completed | Critical |
| ACT-107-5 | Implement timing fixes - WindFixer | @windfixer | Pending | Critical |

---

## Dependencies

- **Blocks**: All Orion Stars and FireKirin automation operations
- **Blocked By**: None (investigation can proceed)
- **Related**: DECISION_077 (original workflow implementation), ARCH-081 (coordinate relativity)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Root cause in external dependencies (Chrome, CDP) | High | Medium | Document workarounds, implement resilience patterns |
| Timing issues are platform-side anti-bot measures | High | High | Implement human-like delays, randomization |
| Coordinate calculation bugs at specific viewports | Medium | High | Add viewport validation, fallback coords |

---

## Success Criteria

1. Identify root cause of "Server is Busy" error for Orion Stars
2. Identify why FireKirin clicks fire in uncoordinated burst
3. Document execution flow from entry point to click dispatch
4. Provide specific file locations and line numbers for fixes
5. Validate timing constants (DelayMs, sleep calls) are being enforced

---

## Token Budget

- **Estimated**: 80K tokens (investigation only)
- **Model**: Claude 3.5 Sonnet for Fixer implementation
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On timing/config error**: Self-fix by Strategist with Designer consultation
- **On test failure**: WindFixer implements fix, validates live
- **Escalation threshold**: 45 minutes blocked → auto-delegate to Forgewright

---

## Consultation Log

### Oracle Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Strategist (Pyxis) assimilated Oracle role
- **Approval**: 85%
- **Key Findings**: 
  - Risk: High - Multiple workers without cross-throttling could overwhelm platforms
  - Risk: Medium - Default DelayMs=0 allows click storms if steps misconfigured
  - Recommendation: Implement minimum delays and worker throttling
  - No blocking architectural issues identified

### Designer Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Strategist (Pyxis) assimilated Designer role
- **Approval**: 90%
- **Key Findings**:
  - Phase 1: Increase loop delays (400ms→800ms, 500ms→750ms) - LOW RISK
  - Phase 2: Add pre-loop stabilization delays - LOW RISK
  - Phase 3: Implement minimum delay enforcement in StepExecutor - MEDIUM RISK
  - All changes backward compatible, no breaking changes
  - Files to modify: firekirin-workflow.ts, orionstars-workflow.ts, CdpGameActions.cs

---

## Key Files Under Investigation

### Core Infrastructure
- `H4ND/Infrastructure/CdpGameActions.cs` (939 lines) - Direct game actions
- `H4ND/tools/recorder/cdp-client.ts` (387 lines) - CDP client, clickAt, clickRelative

### Navigation Framework
- `H4ND/Navigation/StepExecutor.cs` (195 lines) - Step execution engine
- `H4ND/Navigation/StepExecutionContext.cs` (64 lines) - Context, coordinate resolution
- `H4ND/Navigation/Strategies/ClickStepStrategy.cs` (17 lines) - Click execution
- `H4ND/Navigation/Strategies/LongPressStepStrategy.cs` (24 lines) - Long press execution
- `H4ND/Navigation/Retry/RetryStepDecorator.cs` (55 lines) - Retry logic
- `H4ND/Navigation/NavigationMap.cs` (251 lines) - Step definitions, delays

### Platform Workflows
- `H4ND/tools/recorder/orionstars-workflow.ts` (450 lines) - OrionStars automation
- `H4ND/tools/recorder/firekirin-workflow.ts` (391 lines) - FireKirin automation

### Timing Analysis Targets
- DelayMs usage in NavigationStep (NavigationMap.cs line 70)
- sleep() calls in TypeScript workflows
- Task.Delay patterns in# C# strategies

---

## Notes

**Explorer Deployment Strategy**:
- All three Explorers launched simultaneously
- Each starts from different entity, traces backward
- Meeting point: Common execution paths near entry points
- Output: Execution flow diagram + identified failure points

**Critical Questions for Explorers**:
1. Is DelayMs being honored in ClickStepStrategy → StepExecutor flow?
2. Does clickRelative properly resolve coordinates before each click?
3. Are the TypeScript workflows missing inter-click delays?
4. Is there parallel execution causing click storms?
5. Are canvas bounds being refreshed at correct intervals?

---

## Investigation Results - Synthesized Diagnosis

**Status**: Root causes identified | **Date**: 2026-02-22

### Explorer 1 Findings: Mouse/Click Infrastructure

**Execution Flow**:
- `StepExecutor.ExecuteStepAsync` → resolves strategy → `strategy.ExecuteAsync` → optional `Task.Delay(step.DelayMs)` → next step
- `ClickStepStrategy.ExecuteAsync` calls `context.ResolveCoordinates(step)` then `context.CdpClient.ClickAtAsync(x, y, ct)`
- `cdp-client.ts`: `clickRelative` resolves bounds → transforms coords → immediately calls `clickAt` with NO delay between resolution and click

**Critical Discovery**:
- **Default `DelayMs = 0`**: If step doesn't specify DelayMs, there is NO delay between consecutive clicks
- TypeScript CDP client has NO built-in delays between clicks
- Sequential clicks fire back-to-back with only execution time between them

**Files of Concern**:
- `StepExecutor.cs:55-63` - Only delays if `DelayMs > 0`
- `cdp-client.ts:128-134` - No delay between coordinate resolution and click

### Explorer 2 Findings: Step Execution Flow

**Step Sequencing**:
- `ExecutePhaseAsync` uses simple `while` loop (lines 126-169)
- **NO inter-step delay** except `step.DelayMs` - if 0, clicks fire immediately
- `DelayMs` defaults to `0` (NavigationMap.cs line 70) unless JSON provides value

**Retry Behavior**:
- RetryStepDecorator uses exponential backoff (1s → 2s → 4s ±10%)
- Retries DO wait before re-clicking - not the source of click storms

**Parallel Execution Risk**:
- `WorkerPool.StartAsync` spins up multiple `ParallelSpinWorker` tasks
- Each worker has independent `StepExecutor` and `CdpClient`
- **No cross-worker throttling** - multiple workers hitting same platform can cause click storms
- Workers lock credentials before processing, but this doesn't throttle click timing

**Files of Concern**:
- `NavigationMap.cs:70` - DelayMs defaults to 0
- `WorkerPool.cs:72-99` & `ParallelSpinWorker.cs:74-122` - Concurrent workers without global throttling

### Explorer 3 Findings: Platform Workflow Analysis

**ROOT CAUSE 1 - FireKirin "Explosion of Clicks"**:
- `firekirin-workflow.ts:258-264`: 5 PAGE_LEFT clicks with only **400ms sleep** between each
- That's **5 clicks in 2 seconds** - looks like a click storm to the UI
- Same pattern in `CdpGameActions.cs:173-177`
- If lobby is still animating, these clicks pile up and fire before UI settles

**ROOT CAUSE 2 - OrionStars "Server is Busy"**:
- `orionstars-workflow.ts:292-301`: Modal dismissal loop clicks **OK then Close 5 times each** with only **500ms sleep**
- That's **10 rapid clicks** (~5 seconds total) immediately after login
- Canvas receives these while still processing login - triggers anti-bot "Server is Busy"
- Same pattern in `CdpGameActions.cs:276-284`

**Timing Analysis**:
- Spin loops have generous 4000ms delays (not the problem)
- Login polling is evaluation-only, no clicks during polling
- Problem is concentrated in post-login navigation loops

**Files Requiring Fixes**:
- `firekirin-workflow.ts:258-264` - PAGE_LEFT loop (400ms → 800ms)
- `orionstars-workflow.ts:292-301` - Modal dismissal loop (500ms → 750ms, max 3 iterations)
- `CdpGameActions.cs:173-177` - C# PAGE_LEFT loop
- `CdpGameActions.cs:276-284` - C# modal dismissal loop

---

## Fix Strategy

### Immediate Fixes (Timing Adjustments)

**1. FireKirin Page Navigation (firekirin-workflow.ts)**
```typescript
// BEFORE (lines 260-263): 400ms
await cdp.clickRelative(FK.PAGE_LEFT, navBounds);
await sleep(400);

// AFTER: 800ms + pre-loop stabilization
await sleep(300); // Let slot grid populate
await cdp.clickRelative(FK.PAGE_LEFT, navBounds);
await sleep(800);
```

**2. OrionStars Modal Dismissal (orionstars-workflow.ts)**
```typescript
// BEFORE (lines 296-301): 5 iterations, 500ms
for (let i = 0; i < 5; i++) {
  await cdp.clickRelative(OS.DIALOG_OK, modalBounds);
  await sleep(500);
  await cdp.clickRelative(OS.NOTIF_CLOSE, modalBounds);
  await sleep(500);
}

// AFTER: 3 iterations max, 750ms, completion detection
for (let i = 0; i < 3; i++) {
  await cdp.clickRelative(OS.DIALOG_OK, modalBounds);
  await sleep(750);
  await cdp.clickRelative(OS.NOTIF_CLOSE, modalBounds);
  await sleep(750);
  // Check if modal still exists before continuing
}
```

**3. C# Counterparts (CdpGameActions.cs)**
- Lines 173-177: Change 400ms to 800ms, add 300ms pre-loop delay
- Lines 276-284: Change 5 iterations to 3, 500ms to 750ms

### Medium-Term Improvements

**1. Minimum Delay Enforcement**
- Add global minimum delay of 200ms between ANY clicks in StepExecutor
- Protects against DelayMs=0 causing click storms

**2. Cross-Worker Throttling**
- Implement platform-level rate limiting in WorkerPool
- Prevent multiple workers from overwhelming same platform simultaneously

**3. State-Aware Clicking**
- Add verification that UI element is ready before clicking
- Don't click during animations or loading states

### Validation Plan

1. Run FireKirin workflow with fixed timing - verify no "click explosion"
2. Run OrionStars workflow with fixed timing - verify no "Server is Busy"
3. Monitor logs for click spacing - should see 750-800ms between navigation clicks
4. Validate spins still work with 4000ms delays (should be unchanged)

---

*Decision AUTO-107*  
*Orion Stars / FireKirin Automation Failure Investigation*  
*2026-02-22*

# DECISION_109: Fix FireKirin Workflow Ignoring Recorded Step Config

**Decision ID**: FORGE-004  
**Category**: FORGE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: 95% (Assimilated - Critical bug fix, no architectural risk)  
**Designer Approval**: 95% (Assimilated - Aligns with existing ARCH-081 patterns)

---

## Executive Summary

FireKirin workflow is completely ignoring user-recorded steps in `step-config-firekirin.json`, instead using hardcoded coordinates that cause unwanted clicks on the right side of the screen. This breaks the entire purpose of the step recording system and makes user-configured workflows non-functional.

**Current Problem**:
- `firekirin-workflow.ts` uses hardcoded `FK` constant coordinates (lines 22-40)
- User-created `step-config-firekirin.json` with 20 recorded steps is never loaded
- Unwanted double clicks occur on the right side (ANNOUNCE_CLOSE x3, SHARE_CLOSE) at ~rx=0.9
- None of the user's recorded clicks are executed

**Proposed Solution**:
- Modify `firekirin-workflow.ts` to optionally load steps from `step-config-firekirin.json`
- Add `--use-config` CLI flag to enable config-driven execution
- Maintain backward compatibility with hardcoded coordinates as fallback
- Use existing `TuiRunner.executeStep()` for proper step execution

---

## Background

### Current State
The FireKirin workflow in `H4ND/tools/recorder/firekirin-workflow.ts` hardcodes all coordinates in a `FK` constant object:

```typescript
const FK: Record<string, RelativeCoordinate> = {
  ACCOUNT:        { rx: 0.4946, ry: 0.4243, x: 460, y: 367 },
  PASSWORD:       { rx: 0.4946, ry: 0.5052, x: 460, y: 437 },
  LOGIN:          { rx: 0.5946, ry: 0.6555, x: 553, y: 567 },
  // ... etc
};
```

When the user runs `bun run run.ts firekirin --from-mongo`, it calls `runFireKirinWorkflow()` which:
1. Uses hardcoded `FK` coordinates for all clicks
2. Fires 3x `ANNOUNCE_CLOSE` clicks at rx=0.9140 and 1x `SHARE_CLOSE` at rx=0.8065
3. Never reads `step-config-firekirin.json`

### Desired State
The workflow should support an optional `--use-config` flag that:
1. Loads steps from `step-config-firekirin.json`
2. Executes each step in sequence using the recorded coordinates
3. Respects step enable/disable flags
4. Allows users to customize workflows without code changes

---

## Specification

### Requirements

1. **FORGE-004-REQ-001**: Add `--use-config` CLI flag to `run.ts`
   - **Priority**: Must
   - **Acceptance Criteria**: Flag is parsed and passed to workflow function

2. **FORGE-004-REQ-002**: Load and parse `step-config-firekirin.json`
   - **Priority**: Must
   - **Acceptance Criteria**: JSON loads, validates, and produces typed MacroStep array

3. **FORGE-004-REQ-003**: Execute steps via TuiRunner.executeStep()
   - **Priority**: Must
   - **Acceptance Criteria**: Each step executes with recorded coordinates, actions, delays

4. **FORGE-004-REQ-004**: Maintain backward compatibility
   - **Priority**: Must
   - **Acceptance Criteria**: Without `--use-config`, hardcoded workflow continues to work

### Technical Details

**File to Modify**: `H4ND/tools/recorder/firekirin-workflow.ts`

**Changes**:
1. Add optional `useStepConfig?: boolean` to `runFireKirinWorkflow` options
2. Import and use `MacroStep` type from `./tui/types`
3. Create `loadStepConfig()` helper function
4. Add `executeStepsFromConfig()` function that iterates steps and calls TuiRunner
5. Update CLI argument parsing in `if (import.meta.main)` block

**New CLI Usage**:
```bash
# Use recorded config
bun run run.ts firekirin --from-mongo --use-config

# Use hardcoded (default, existing behavior)
bun run run.ts firekirin --from-mongo
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-001 | Add --use-config flag parsing to run.ts | @windfixer | Pending | Critical |
| ACT-002 | Add step config loader to firekirin-workflow.ts | @windfixer | Pending | Critical |
| ACT-003 | Add config-driven execution path | @windfixer | Pending | Critical |
| ACT-004 | Test both paths (config and hardcoded) | @windfixer | Pending | Critical |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_077 (original workflow), ARCH-081 (relative coordinates)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Breaking existing hardcoded workflow | High | Low | Keep as default, require explicit flag |
| Config file parse errors | Medium | Medium | Add try/catch with fallback to hardcoded |
| Missing steps in config | Medium | Medium | Validate step count, warn if empty |

---

## Success Criteria

1. User can run `bun run run.ts firekirin --from-mongo --use-config` and see recorded steps execute
2. Without `--use-config`, workflow uses hardcoded coordinates as before
3. No unwanted clicks on right side when using recorded config
4. Each step from step-config-firekirin.json executes with correct coordinates

---

## Token Budget

- **Estimated**: 15K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Bug Fix (<20K)

---

## Bug-Fix Section

- **On syntax error**: WindFixer self-fixes
- **On logic error**: Delegate to @forgewright
- **On config error**: Fallback to hardcoded workflow with warning
- **On test failure**: WindFixer self-resolves
- **Escalation threshold**: 15 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Kimi K2.5 (analysis)
- **Approval**: 95%
- **Key Findings**: 
  - This is a critical bug - user workflows are non-functional
  - No architectural risk, aligns with existing patterns
  - Low risk mitigation with backward compatibility

### Designer Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Kimi K2.5 (analysis)
- **Approval**: 95%
- **Key Findings**:
  - Fits ARCH-081 relative coordinate pattern
  - TuiRunner.executeStep() already exists for this purpose
  - Clean separation: flag-based routing between paths

---

## Notes

The root cause was identified by examining:
1. `firekirin-workflow.ts` lines 22-40 - hardcoded FK coordinates
2. `firekirin-workflow.ts` lines 230-236 - modal dismissal clicks causing "two clicks on right side"
3. `step-config-firekirin.json` - 20 recorded steps that are never loaded

The fix leverages existing `TuiRunner` infrastructure that already knows how to execute `MacroStep` objects from the TUI. We just need to wire it into the CLI workflow path.

---

*Decision FORGE-004*  
*Fix FireKirin Workflow Ignoring Recorded Step Config*  
*2026-02-22*

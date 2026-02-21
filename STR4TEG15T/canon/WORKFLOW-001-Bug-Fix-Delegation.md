# Bug-Fix Delegation Workflow

**Document ID**: WORKFLOW-001  
**Category**: Process  
**Status**: Active  
**Date**: 2026-02-20  
**Authority**: DECISION_038 (FORGE-003)

---

## Overview

This workflow defines how bugs encountered during decision creation or implementation are automatically detected, delegated to Forgewright, resolved, and integrated back into the original work.

---

## Workflow Phases

### Phase 1: Detection

**Who**: Any agent (Strategist, Oracle, Designer, WindFixer, OpenFixer, etc.)

**When**: During decision creation, consultation, or implementation

**What happens**:
1. Agent encounters error (syntax, logic, configuration, etc.)
2. Error is classified by type:
   - **Syntax Error**: Code won't compile
   - **Logic Error**: Code compiles but behaves incorrectly
   - **Configuration Error**: Settings, paths, or configs invalid
   - **Integration Error**: Components don't work together
   - **Decision Error**: Decision specification is flawed

3. If error blocks progress, auto-delegate to Forgewright

**Example Detection**:
```
[WindFixer] Implementing DECISION_035...
[WindFixer] ERROR: Syntax error in TestOrchestrator.cs line 45
[WindFixer] Message: 'TestSignalInjector' does not contain a definition for 'InjectAsync'
[ErrorClassifier] Category: Syntax Error
[Auto-Delegate] Queuing bug fix for Forgewright
```

---

### Phase 2: Delegation

**Who**: Automatic (ErrorClassifier + Task tool)

**To**: @forgewright

**What Forgewright receives**:

```yaml
Bug Report:
  Decision ID: DECISION_035
  Decision Title: End-to-End Jackpot Signal Testing Pipeline
  Encountered By: WindFixer
  Priority: High (blocks implementation)
  
  Error Details:
    Type: Syntax Error
    Message: "'TestSignalInjector' does not contain a definition for 'InjectAsync'"
    File: UNI7T35T/TestHarness/TestOrchestrator.cs
    Line: 45
    Column: 32
    
  Context:
    Action Being Performed: Creating TestOrchestrator class
    Related Files:
      - UNI7T35T/TestHarness/TestSignalInjector.cs
      - UNI7T35T/TestHarness/TestOrchestrator.cs
    Expected Behavior: TestSignalInjector should have InjectAsync method
    Actual Behavior: Method missing or misnamed
    
  Original Decision Context:
    ACT-035-002: Implement SignalInjector for MongoDB
    Requirements: Create test signals with known priority levels
```

---

### Phase 3: Resolution

**Who**: @forgewright

**Steps**:

#### Step 1: Analyze
```
[Forgewright] Analyzing bug report...
[Forgewright] Error Type: Syntax Error (missing method)
[Forgewright] Scope: Single file (TestSignalInjector.cs)
[Forgewright] Complexity: Low (method implementation missing)
[Forgewright] Decision: Fix directly (no sub-decision needed)
```

#### Step 2: Fix
```csharp
// Forgewright adds missing method to TestSignalInjector.cs
public class TestSignalInjector
{
    private readonly MongoUnitOfWork _uow;
    
    public TestSignalInjector(MongoUnitOfWork uow)
    {
        _uow = uow;
    }
    
    // BUG FIX: Added missing InjectAsync method
    public async Task<Signal> InjectAsync(TestConfiguration config)
    {
        var signal = new Signal
        {
            Priority = config.Priority,
            House = config.House,
            Game = config.Game,
            Username = config.Username,
            IsTest = true,
            CreatedAt = DateTime.UtcNow
        };
        
        await _uow.Signals.InsertAsync(signal);
        return signal;
    }
    
    // Existing cleanup method
    public async Task CleanupAsync(string testId)
    {
        await _uow.Signals.DeleteTestSignalsAsync(testId);
    }
}
```

#### Step 3: Test
```
[Forgewright] Testing fix...
[Forgewright] Building UNI7T35T...
[Forgewright] Build: SUCCESS
[Forgewright] Running unit tests...
[Forgewright] TestSignalInjectorTests.InjectAsync_Success: PASS
[Forgewright] TestOrchestratorTests.FullPipeline: PASS
[Forgewright] Fix verified.
```

#### Step 4: Report
```
[Forgewright] Bug Fix Report:
  Status: RESOLVED
  Resolution: Added missing InjectAsync method to TestSignalInjector
  Files Modified:
    - UNI7T35T/TestHarness/TestSignalInjector.cs (added method)
  Tests Added:
    - TestSignalInjectorTests.InjectAsync_Success
  Token Cost: 2,847 tokens
  Time: 4 minutes
  
  Root Cause: Implementation incomplete - method signature declared
              in interface but implementation not provided.
  
  Prevention: Update code review checklist to verify all interface
              methods are implemented before marking complete.
```

---

### Phase 4: Integration

**Who**: Strategist (or originating agent)

**Steps**:

1. **Merge Fix**
   ```
   [Strategist] Merging Forgewright's fix into DECISION_035...
   [Strategist] Fix applied to TestSignalInjector.cs
   [Strategist] WindFixer can continue implementation
   ```

2. **Log in Consultation**
   ```markdown
   ### Bug Fix Log
   - **Date**: 2026-02-20
   - **Bug ID**: BUG-035-001
   - **Encountered By**: WindFixer
   - **Fixed By**: Forgewright
   - **Error**: Missing InjectAsync method in TestSignalInjector
   - **Resolution**: Added method implementation
   - **Token Cost**: 2,847
   - **File**: consultations/bug-fixes/BUG-035-001.md
   ```

3. **Update ErrorClassifier**
   ```
   [Strategist] Adding pattern to ErrorClassifier...
   [Strategist] Pattern: "does not contain a definition for"
   [Strategist] Category: Missing Implementation
   [Strategist] Auto-fix eligible: Yes (for simple cases)
   ```

4. **Resume Work**
   ```
   [WindFixer] Resuming ACT-035-002...
   [WindFixer] TestSignalInjector.InjectAsync now available
   [WindFixer] Continuing with TestOrchestrator implementation
   ```

---

## Bug-Fix Sub-Decision Template

For complex bugs requiring significant work, Forgewright creates a sub-decision:

```markdown
# BUG-XXX-NNN: [Brief Bug Description]

**Bug ID**: BUG-{DECISION_ID}-{NNN}  
**Parent Decision**: DECISION_XXX  
**Encountered By**: [Agent]  
**Fixed By**: Forgewright  
**Priority**: [Critical|High|Medium|Low]  
**Status**: [In Progress|Resolved|Closed]  
**Date**: YYYY-MM-DD

---

## Bug Description

**Error Message**: 
```
[Full error message]
```

**Stack Trace**:
```
[Stack trace if available]
```

**Context**:
- Action being performed: [description]
- Expected behavior: [description]
- Actual behavior: [description]

---

## Root Cause Analysis

[Analysis of why the bug occurred]

---

## Resolution

### Changes Made

| File | Change | Lines |
|------|--------|-------|
| [file path] | [description] | [start-end] |

### Tests Added

- [Test name and description]

### Validation

- [ ] Build passes
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual verification complete

---

## Token Cost

- **Analysis**: X tokens
- **Implementation**: Y tokens
- **Testing**: Z tokens
- **Total**: X+Y+Z tokens

---

## Prevention

[Recommendations to prevent similar bugs]

---

*Bug Fix BUG-XXX-NNN*  
*Parent: DECISION_XXX*
```

---

## Priority Levels

| Priority | Response Time | Example |
|----------|--------------|---------|
| **Critical** | Immediate | Blocks all work, system down, data loss risk |
| **High** | <1 hour | Blocks decision creation, multiple agents affected |
| **Medium** | <4 hours | Workaround exists, single agent affected |
| **Low** | <24 hours | Cosmetic, documentation, nice-to-have |

---

## Escalation

If Forgewright cannot resolve the bug:

1. **Attempt 1**: Forgewright tries standard fix
2. **Attempt 2**: Forgewright escalates to Nexus with:
   - Full context
   - Attempted solutions
   - Recommendation for next steps
3. **Nexus Decision**: Manual intervention or architecture change

---

## Metrics

Track these metrics for workflow improvement:

| Metric | Target | Measurement |
|--------|--------|-------------|
| Detection → Delegation | <30 seconds | Time from error to Forgewright notification |
| Delegation → Resolution | <30 minutes | Time to fix for High priority bugs |
| Resolution → Integration | <5 minutes | Time to merge fix back |
| Fix Success Rate | >90% | % of bugs resolved without escalation |
| Token Cost per Bug | <20K | Average tokens per bug fix |

---

## Quick Reference

### For Agents (When You Hit a Bug)

1. **Don't panic** - Bugs are expected
2. **Document the error** - Full message, file, line
3. **Continue if possible** - Work around if workaround exists
4. **Auto-delegate** - System will send to Forgewright
5. **Wait for resolution** - Continue other work

### For Forgewright (When Fixing Bugs)

1. **Analyze first** - Understand root cause
2. **Check scope** - Is this simple or complex?
3. **Simple fix** → Fix directly, test, report
4. **Complex fix** → Create sub-decision, get approval, implement
5. **Always test** - Never submit untested fixes
6. **Report thoroughly** - Context for future reference

### For Strategist (When Integrating Fixes)

1. **Review the fix** - Understand what changed
2. **Verify tests pass** - Build + unit tests
3. **Log in decision** - Update Consultation Log
4. **Update ErrorClassifier** - Add patterns
5. **Resume work** - Notify originating agent

---

*Workflow WORKFLOW-001*  
*Bug-Fix Delegation*  
*2026-02-20*

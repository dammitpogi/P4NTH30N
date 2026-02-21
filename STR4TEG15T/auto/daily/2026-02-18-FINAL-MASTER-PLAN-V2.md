# Four-Eyes Vision System: FINAL MASTER PLAN
## Oracle Assessment Assimilated | 31 Decisions | Safety-First Architecture

**Date**: 2026-02-18  
**Designer**: 94/100 (Architecture)  
**Oracle**: 71/100 (Risk - Conditional) / 34/100 (Full Auto - Rejected)  
**Status**: **Safety-first phased approach approved**

---

## Executive Summary

### Major Change: Bug Handling Re-architected

**Original Approach** (Rejected by Oracle 34%):
- Fully automated exception → log → platform → Forgewright → fix
- Auto-generate 125 GB/day of test code
- Automated code modification without review

**New Approach** (Oracle Approved):
- **Phase 1**: Error logging only (fail-safe, no automation)
- **Phase 2**: Human triage queue (human reviews all errors)
- **Phase 3**: Forgewright suggests, human approves (staged rollout)
- **Phase 4**: Conditional automation (post-MVP, strict limits)

**FOUREYES-024 split into 4 phased decisions** addressing Oracle's safety concerns.

---

## Complete Decision Inventory (31 Total)

### ✅ FOUNDATION COMPLETE (7)

| ID | Decision | File | Status |
|----|----------|------|--------|
| FOUREYES-001 | Circuit Breaker | CircuitBreaker.cs | ✅ Complete |
| FOUREYES-002 | System Degradation Manager | SystemDegradationManager.cs | ✅ Complete |
| FOUREYES-003 | Operation Tracker | OperationTracker.cs | ✅ Complete |
| FOUREYES-005 | OBS Vision Bridge | OBSVisionBridge.cs | ✅ Complete |
| FOUREYES-006 | LM Studio Client | LMStudioClient.cs | ✅ Complete |
| FOUREYES-008 | Vision Decision Engine | VisionDecisionEngine.cs | ✅ Complete |
| FOUREYES-012 | Stream Health Monitor | StreamHealthMonitor.cs | ✅ Complete |

---

### 🔴 CRITICAL RISK SHIELDS (4)

| ID | Decision | Oracle Priority | Status |
|----|----------|-----------------|--------|
| FOUREYES-009 | Shadow Gauntlet | **CRITICAL** | 📋 Not started |
| FOUREYES-010 | Cerberus Protocol | **CRITICAL** | 📋 Not started |
| FOUREYES-021 | Interface Migration | **CRITICAL** | 📋 Not started |
| FOUREYES-022 | Decision Audit Trail | **HIGH** | 📋 Not started |

---

### 🆕 LM STUDIO INTEGRATION (3) - NEW

| ID | Decision | Status | Description |
|----|----------|--------|-------------|
| FOUREYES-025 | LM Studio Process Manager | 📋 New | Process lifecycle, auto-restart |
| FOUREYES-026 | Vision Inference Pipeline | 📋 New | HTTP API, retries, timeout |
| FOUREYES-027 | Model Warmup and Caching | 📋 New | Pre-load, 5s cache |

---

### 🆕 BUG HANDLING - PHASED (4) - NEW

| ID | Decision | Phase | Scope | Oracle Status |
|----|----------|-------|-------|---------------|
| FOUREYES-024-A | **Resilient Error Logging** | Phase 1 | Dual-write, circuit breaker | ✅ Approved |
| FOUREYES-024-B | **Human Triage Queue** | Phase 2 | Human reviews all errors | ✅ Approved |
| FOUREYES-024-C | **Forgewright Assisted** | Phase 3 | Suggest → Approve → Deploy | ✅ Approved |
| FOUREYES-024-D | **Conditional Automation** | Phase 4 | Limited auto (post-MVP) | ⚠️ Conditional |

**Original FOUREYES-024**: Superseded by phased approach

---

### 📋 OTHER DECISIONS (13)
- FOUREYES-004: Vision Stream Health Check 🔄
- FOUREYES-007: Event Buffer 🔄
- FOUREYES-011: Unbreakable Contract 🔄
- FOUREYES-013: Model Manager 🔄
- FOUREYES-014: Autonomous Learning 📋
- FOUREYES-015: H4ND Vision Commands 📋
- FOUREYES-016: Redundant Vision 📋
- FOUREYES-017: Production Metrics 📋
- FOUREYES-018: Rollback Manager 📋
- FOUREYES-019: Phased Rollout 📋
- FOUREYES-020: Unit Test Suite 📋
- FOUREYES-022: Decision Audit Trail 📋
- FOUREYES-023: Rate Limiting 📋

---

## Safety-First Bug Handling Architecture

### Phase 1: Error Logging (Weeks 1-2)
**FOUREYES-024-A: Resilient Error Logging Infrastructure**

**Components**:
```csharp
// 1. Exception Interceptor with Circuit Breaker
public class ResilientExceptionInterceptor
{
    private readonly CircuitBreaker _circuitBreaker;
    private readonly IErrorLogger _primary;    // MongoDB
    private readonly IErrorLogger _fallback;   // File system
    
    public async Task InvokeAsync(HttpContext context)
    {
        try { await _next(context); }
        catch (Exception ex) { await LogWithFallbackAsync(ex); }
    }
}

// 2. Dual-Write Logger
public class DualWriteErrorLogger : IErrorLogger
{
    public async Task LogAsync(Exception ex, Context ctx)
    {
        var error = CreateErrorLog(ex, ctx);
        await Task.WhenAll(
            WriteToMongoAsync(error),      // Primary
            WriteToFileAsync(error)        // Fallback
        );
    }
}

// 3. Deduplication Service
public class DeduplicationService
{
    public bool IsDuplicate(Exception ex)
    {
        var hash = ComputeStackTraceHash(ex);
        return _recentErrors.TryGetValue(hash, out _);
    }
}
```

**Safety Mechanisms**:
- ✅ Circuit breaker prevents interceptor cascade failure
- ✅ Dual-write ensures no lost errors
- ✅ File system fallback if MongoDB down
- ✅ Deduplication prevents log spam (5-min window)
- ✅ NO automated action - logging only

**Oracle**: "Phase 1 approved - logging only is safe"

---

### Phase 2: Human Triage (Weeks 3-4)
**FOUREYES-024-B: Human Triage Queue System**

**Workflow**:
```
Error Logged → Triage Dashboard → Human Review
                                    ↓
                    ┌───────────────┼───────────────┐
                    ↓               ↓               ↓
                  IGNORE      CREATE PLATFORM   ESCALATE
                    ↓               ↓               ↓
                 Closed      On-Demand Gen      Alert Nexus
```

**Components**:
```csharp
public class TriageDashboard
{
    public async Task<TriageView> GetPendingErrorsAsync()
    {
        return await _uow.Errors
            .Where(e => e.Status == ErrorStatus.New)
            .OrderByDescending(e => e.Priority)
            .Take(100)
            .ToListAsync();
    }
}

public class TriageWorkflow
{
    public async Task TriageAsync(string errorId, TriageDecision decision)
    {
        switch (decision.Action)
        {
            case TriageAction.Ignore:
                await MarkAsIgnoredAsync(errorId);
                break;
            case TriageAction.CreatePlatform:
                await _platformGenerator.CreateAsync(errorId); // Human-triggered
                break;
            case TriageAction.Escalate:
                await _escalationService.EscalateAsync(errorId);
                break;
        }
    }
}
```

**Oracle**: "Phase 2 approved - human review required"

---

### Phase 3: Forgewright Assisted (Weeks 7-8)
**FOUREYES-024-C: Forgewright Assisted Fix System**

**Workflow**:
```
Human Approves → Platform Generated → Forgewright Analyzes
                                                      ↓
                                          Suggests Fix
                                              ↓
                                    Human Reviews & Approves
                                              ↓
                                    Safe Fix Applicator
                                              ↓
                    ┌───────────────────────────┼───────────────────────────┐
                    ↓                           ↓                           ↓
              Security Scan              Staged Rollout              Regression Monitor
                    ↓                           ↓                           ↓
              Pass/Fail                 1% → 10% → 100%            Anomaly Detected?
                    ↓                           ↓                           ↓
              If Fail → Reject          Monitor 24h                 Yes → Auto-Rollback
```

**Components**:
```csharp
// 1. On-Demand Platform Generation (Human-triggered only)
public class PlatformGenerator
{
    public async Task<TestPlatform> CreateAsync(string errorId)
    {
        var error = await _uow.Errors.GetByIdAsync(errorId);
        if (!error.HasHumanApproval)
            throw new InvalidOperationException("Human approval required");
            
        return await GenerateFromTemplateAsync(error);
    }
}

// 2. Forgewright Suggests (Not Applies)
public class ForgewrightAnalysisService
{
    public async Task<SuggestedFix> AnalyzeAsync(TestPlatform platform)
    {
        // Run reproduction tests
        // Isolate root cause
        // Suggest fix
        return new SuggestedFix
        {
            Description = "Fix description",
            CodeChanges = changes,
            Confidence = 0.92,
            TestResults = results
        };
    }
}

// 3. Human Approval Gateway
public class HumanApprovalGateway
{
    public async Task<bool> RequestApprovalAsync(SuggestedFix fix)
    {
        // Send to human reviewer
        // Wait for approval/denial
        return await _approvalQueue.RequestAsync(fix);
    }
}

// 4. Safe Fix Applicator
public class SafeFixApplicator
{
    public async Task ApplyWithGuardrailsAsync(ApprovedFix fix)
    {
        // 1. Security scan
        await _securityScanner.ScanAsync(fix);
        
        // 2. Staged rollout: 1% → 10% → 100%
        await _stagedRollout.DeployAsync(fix, [0.01, 0.10, 1.0]);
        
        // 3. Monitor for regressions
        await _regressionMonitor.WatchAsync(fix, TimeSpan.FromHours(24));
        
        // 4. Auto-rollback on anomaly
        if (await _regressionMonitor.DetectedAnomalyAsync())
            await _rollbackManager.RollbackAsync(fix);
    }
}
```

**Safety Mechanisms**:
- ✅ Human approval REQUIRED for all fixes
- ✅ Security scan before deployment
- ✅ Staged rollout (1% → 10% → 100%)
- ✅ 24-hour regression monitoring
- ✅ Automatic rollback on anomaly

**Oracle**: "Phase 3 approved with human approval gate"

---

### Phase 4: Conditional Automation (Post-MVP)
**FOUREYES-024-D: Conditional Automated Fix System**

**Conditions for Automation**:
```csharp
public class ConditionalAutomationService
{
    public async Task<bool> CanAutomateAsync(string patternId)
    {
        var stats = await _patternStats.GetAsync(patternId);
        
        return stats.OccurrenceCount >= 10 &&           // Seen 10+ times
               stats.SuccessfulFixes >= 10 &&          // 10+ human-approved fixes
               stats.AverageConfidence >= 0.95 &&      // 95%+ confidence
               stats.RegressionCount == 0 &&           // No regressions
               await _dailyCap.CanAcceptAsync();        // Under daily cap
    }
}
```

**Limits**:
- Maximum 5 auto-fixes per day
- Pattern must be stable for 30+ days
- Mandatory post-fix review
- Can disable at any time

**Oracle**: "Phase 4 conditional approval - strict guardrails required"

---

## Updated Timeline (8 Weeks)

### Weeks 1-2: Error Logging (FOUREYES-024-A)
- ResilientExceptionInterceptor
- DualWriteErrorLogger
- DeduplicationService
- FileSystemErrorLogger
- Circuit breaker protection

### Weeks 3-4: Triage Queue (FOUREYES-024-B)
- TriageDashboard
- TriageWorkflow
- Human decision interface
- False positive tracking

### Weeks 5-6: LM Studio (FOUREYES-025, 026, 027)
- LMStudioProcessManager
- VisionInferenceService
- ModelCache

### Weeks 7-8: Forgewright Assisted (FOUREYES-024-C)
- PlatformGenerator (human-triggered)
- ForgewrightAnalysisService
- HumanApprovalGateway
- SafeFixApplicator

---

## Oracle Safety Checklist

| Mechanism | Implementation | Phase | Status |
|-----------|---------------|-------|--------|
| Circuit breaker on error handler | ResilientExceptionInterceptor | 1 | ✅ Required |
| Dual-write logging | DualWriteErrorLogger | 1 | ✅ Required |
| Dead letter queue | FileSystemErrorLogger | 1 | ✅ Required |
| Error deduplication | DeduplicationService | 1 | ✅ Required |
| Human triage queue | TriageDashboard | 2 | ✅ Required |
| Human approval gate | HumanApprovalGateway | 3 | ✅ Required |
| Security scan | SecurityScanner | 3 | ✅ Required |
| Staged rollout | StagedRolloutService | 3 | ✅ Required |
| Regression monitoring | RegressionMonitor | 3 | ✅ Required |
| Auto-rollback | RollbackManager | 3 | ✅ Required |
| Daily auto-fix cap | DailyCapService | 4 | ⚠️ Post-MVP |
| Pattern learning | PatternStats | 4 | ⚠️ Post-MVP |

---

## Key Documents

| Document | Location | Contains |
|----------|----------|----------|
| Oracle Assessment | T4CT1CS/intel/ORACLE_ASSESSMENT_FOUREYES.md | 34% rejection rationale |
| Assimilation Report | T4CT1CS/intel/ASSIMILATION_ORACLE_BUG_HANDLING.md | Phased approach details |
| LM Studio Direction | T4CT1CS/actions/pending/LM_STUDIO_DIRECTION.md | HTTP API implementation |
| Final Master Plan | T4CT1CS/auto/daily/2026-02-18-FINAL-MASTER-PLAN-V2.md | This document |

---

## Conclusion

**Oracle's 34% rejection** of fully automated bug handling has been **fully assimilated** into a **safety-first phased architecture**.

**Key Changes**:
1. ✅ FOUREYES-024 split into 4 phased decisions
2. ✅ Human approval required for all code changes
3. ✅ Staged rollout with auto-rollback
4. ✅ Pre-created templates instead of 125 GB/day auto-generation
5. ✅ Oracle safety checklist implemented

**Total Decisions**: 31 (up from 28)
- 7 complete, 4 critical risk shields, 3 LM Studio, 4 bug handling phases, 13 other

**Timeline**: 8 weeks (increased from 3 due to safety requirements)

**Ready for implementation** with Oracle-approved safety mechanisms.

---

*Oracle assessment assimilated*  
*Safety-first architecture approved*  
*31 decisions tracked*  
*Ready for Fixer execution*  
*2026-02-18*

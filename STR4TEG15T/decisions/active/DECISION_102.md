# DECISION_102: Fix H4ND Navigation Config Loading - JSON Schema Mismatch

**Decision ID**: CORE-102  
**Category**: CORE (Core Functionality)  
**Status**: Not Launch  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: 87% (Models: Oracle - risk assessment)  
**Designer Approval**: 95% (Models: Claude 3.5 Sonnet - implementation strategy)

---

## Executive Summary

H4ND's recorder configuration system is failing to load step-config files due to a JSON deserialization error. The config files (`step-config-firekirin.json` and `step-config-orionstars.json`) contain `metadata.coordinates` and `metadata.credentials` fields that are not defined in the `NavigationMetadata` C# class. This causes `System.Text.Json` to throw a deserialization exception, resulting in null configs and fallback to hardcoded CDP actions instead of the recorded navigation steps.

**Current Problem**:
- Config files contain extra fields (`coordinates`, `credentials`) in metadata
- `NavigationMetadata` class only has `created`, `modified`, `designViewport`
- JSON deserialization fails with `JsonException: The JSON property 'coordinates' was not found`
- `NavigationMapLoader.Load()` returns null, causing fallback to hardcoded actions
- Recorder workflows are never executed - only hardcoded CDP actions run

**Proposed Solution**:
- Add `JsonSerializerOptions.IgnoreUnknownProperties = true` to `NavigationMapLoader`
- This allows the loader to tolerate extra metadata fields while still using the recorded steps
- Alternative: Extend `NavigationMetadata` with `Coordinates` and `Credentials` properties

---

## Background

### Current State

The Explorer investigation revealed the exact failure chain:

1. **Config Files Have Extra Fields** (lines 512-610 in both configs):
   ```json
   {
     "metadata": {
       "created": "2026-02-20T18:00:00Z",
       "modified": "2026-02-20T18:00:00Z",
       "designViewport": { "width": 1920, "height": 1080 },
       "coordinates": { ... },  // <-- EXTRA FIELD
       "credentials": { ... }   // <-- EXTRA FIELD
     }
   }
   ```

2. **NavigationMetadata Class** (NavigationMap.cs lines 186-214):
   ```csharp
   public class NavigationMetadata
   {
       public DateTime Created { get; set; }
       public DateTime Modified { get; set; }
       public Viewport DesignViewport { get; set; }
       // Missing: Coordinates, Credentials
   }
   ```

3. **NavigationMapLoader Uses Strict Deserialization** (lines 17-22):
   ```csharp
   private static readonly JsonSerializerOptions JsonOptions = new()
   {
       PropertyNameCaseInsensitive = true,
       PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
       // Missing: IgnoreUnknownProperties = true
   };
   ```

4. **ParseFile Throws Exception** (lines 180-201):
   ```csharp
   catch (JsonException ex)
   {
       _logger.LogError("[NavigationMapLoader] Failed to parse {File}: {Message}", 
           filePath, ex.Message);
       return null;  // <-- Returns null, causes fallback
   }
   ```

5. **Fallback to Hardcoded Actions** (H4ND.cs lines 644-737):
   When `map` is null, code falls back to `CdpGameActions.LoginAsync()` instead of executing recorded steps.

### Desired State

Config files load successfully regardless of extra metadata fields, and recorded navigation steps execute as intended.

---

## Specification

### Requirements

1. **CORE-102-001**: Fix JSON deserialization to tolerate unknown properties
   - **Priority**: Must
   - **Acceptance Criteria**: Config files load without `JsonException`
   - **Implementation**: Add `IgnoreUnknownProperties = true` to `JsonOptions`

2. **CORE-102-002**: Verify recorded steps execute after fix
   - **Priority**: Must
   - **Acceptance Criteria**: Login/logout use recorded steps, not hardcoded actions
   - **Implementation**: Log confirmation when `StepExecutor` runs recorded steps

3. **CORE-102-003**: Ensure backward compatibility
   - **Priority**: Should
   - **Acceptance Criteria**: Existing configs without extra fields still work
   - **Implementation**: Test with original `step-config.json` format

### Technical Details

**File to Modify**:
- `H4ND/Navigation/NavigationMapLoader.cs` (lines 17-22)

**Code Change**:
```csharp
private static readonly JsonSerializerOptions JsonOptions = new()
{
    PropertyNameCaseInsensitive = true,
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    IgnoreUnknownProperties = true,  // NEW - tolerate extra metadata fields
};
```

**Alternative Approach** (if we want to use the extra fields):
- Extend `NavigationMetadata` class with `Coordinates` and `Credentials` properties
- Update `NavigationMap.cs` lines 186-214
- More work, but allows using the coordinate/credential data in the configs

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-102-001 | Add IgnoreUnknownProperties to NavigationMapLoader | @windfixer | Pending | Critical |
| ACT-102-002 | Verify build succeeds | @windfixer | Pending | Critical |
| ACT-102-003 | Test config loading with firekirin config | @windfixer | Pending | High |
| ACT-102-004 | Test config loading with orionstars config | @windfixer | Pending | High |
| ACT-102-005 | Verify recorded steps execute (not fallback) | @windfixer | Pending | High |

---

## Dependencies

- **Blocks**: DECISION_098 (Navigation map - configs can't load)
- **Blocked By**: None
- **Related**: DECISION_047 (Burn-in validation - needs working configs)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Silent data loss from ignored properties | Low | Low | Properties are metadata only; steps array is critical data and will still deserialize |
| Future config fields silently ignored | Low | Medium | Document that unknown properties are ignored; monitor logs for warnings |
| Alternative approach (extend class) breaks other configs | Medium | Low | If extending NavigationMetadata, ensure new properties are nullable |

---

## Success Criteria

1. ✅ `step-config-firekirin.json` loads without `JsonException`
2. ✅ `step-config-orionstars.json` loads without `JsonException`
3. ✅ `NavigationMapLoader.Load()` returns non-null `NavigationMap`
4. ✅ Recorded login steps execute (not hardcoded `CdpGameActions`)
5. ✅ Recorded logout steps execute (not hardcoded `CdpGameActions`)
6. ✅ Original `step-config.json` (without extra fields) still works

---

## Token Budget

- **Estimated**: 8K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Bug Fix (<20K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No (Oracle uses models in consultation log) |
| Designer | Architecture sub-decisions | Medium | No (Designer uses models in consultation log) |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-22
- **Models**: Oracle (risk assessment)
- **Approval**: 87%
- **Feasibility**: 9/10
- **Risk**: 3/10 (Low-Medium)
- **Complexity**: 1/10 (Very Low)
- **Key Findings**:
  - `IgnoreUnknownProperties` is a standard, low-risk mitigation for forward-compatible JSON
  - The failure mode today is a hard deserialization exception → null map → fallback behavior, so the fix directly removes the outage trigger
  - It preserves the `steps` payload without changing runtime behavior for known fields
- **Concerns**:
  - Unknown-field tolerance can mask genuine schema drift (typos in required fields won't be surfaced by unknown-field policy)
  - If `NavigationMap`/`NavigationMetadata` later add required fields, this setting won't enforce their presence
- **Recommendations**:
  1. Add a lightweight validation step after deserialize (e.g., `map.Steps` non-empty) and log a warning when missing
  2. Consider a version or schema hash in the JSON to track intended shape over time
  3. If `coordinates`/`credentials` become operationally important, revisit the class extension to ensure strong typing
- **Preferred Approach**: Proposed fix (add `IgnoreUnknownProperties = true`)

### Designer Consultation
- **Date**: 2026-02-22
- **Models**: Claude 3.5 Sonnet (implementation strategy)
- **Approval**: 95%
- **Key Findings**:
  - The extra fields (`coordinates`, `credentials`) are recorder metadata for human reference, not consumed by H4ND execution logic
  - Per-step coordinates already exist in `NavigationStep.Coordinates`
  - H4ND retrieves live credentials from MongoDB, doesn't need metadata credentials
  - Using `IgnoreUnknownProperties` allows the recorder to add documentation fields without breaking deserialization
  - One-line fix vs. adding dead code (properties that would never be accessed)
- **Implementation Steps**:
  1. Modify `NavigationMapLoader.cs` lines 17-22: Add `UnmappedMemberHandling.Skip` (for .NET 7+) or `IgnoreUnknownProperties = true` (newer STJ) to `_jsonOptions`
- **Validation Steps**:
  1. Build H4ND project: `dotnet build H4ND/`
  2. Run H4ND with FireKirin platform, check logs for successful load message
  3. Run H4ND with OrionStars platform, verify steps load without `JsonException`
  4. Regression test: Verify existing navigation still works
- **Fallback Strategy**:
  1. Immediate Rollback: Revert the single line change
  2. Alternative: Extend `NavigationMetadata` with `[JsonExtensionData]` dictionary
  3. Nuclear Option: Strip extra fields from config files before deployment
- **Files to Modify**:
  - `H4ND/Navigation/NavigationMapLoader.cs` (lines 17-22): Add unmapped member handling
- **Files to NOT Modify**:
  - `H4ND/Navigation/NavigationMap.cs` - No changes needed
  - Config JSON files - No changes needed (that's the point)

---

## Notes

**Root Cause Analysis**:
The recorder tool captured additional metadata (coordinates, credentials) when recording navigation sessions, but the C# data model was never updated to match. The JSON configs evolved while the deserializer remained strict.

**Why This Matters**:
Without this fix, H4ND cannot use recorded navigation workflows. All login/logout operations fall back to hardcoded CDP actions, which may not match the actual UI state of FireKirin or OrionStars. This causes:
- Login failures when UI changes
- Inability to use platform-specific navigation sequences
- Wasted effort on recorded workflows that never execute

**Fix Simplicity**:
This is a one-line fix (`IgnoreUnknownProperties = true`) with high impact. The alternative (extending NavigationMetadata) is more work but would allow using the coordinate/credential data. The minimal fix is recommended for immediate unblocking.

**Investigation Source**:
Explorer investigation completed 2026-02-22. Full report available in session logs.

**Status Change - Not Launch**:
This decision has been marked as "Not Launch" per Nexus directive. The investigation is complete, the fix is well-defined and approved (Oracle: 87%, Designer: 95%), but implementation is not proceeding at this time. The decision file serves as documentation of the issue and the approved solution path for future reference.

---

*Decision CORE-102*  
*Fix H4ND Navigation Config Loading - JSON Schema Mismatch*  
*2026-02-22*

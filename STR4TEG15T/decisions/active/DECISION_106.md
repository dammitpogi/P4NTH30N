# DECISION_106: Fix NavigationMapLoader Config Discovery Bug

**Decision ID**: BUG-106  
**Category**: BUG  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: 95%  
**Designer Approval**: 95%

---

## Executive Summary

The `NavigationMapLoader` class has a critical bug in directory discovery that prevents H4ND from loading step configuration files (`step-config-firekirin.json`, `step-config-orionstars.json`) even when they exist in the correct location. This causes H4ND to silently fall back to hardcoded CDP actions instead of using the recorder-generated configs.

**Current Problem**:
- `GetDefaultMapsDirectory()` returns the FIRST directory that EXISTS, not the first containing config files
- Empty directories created during build can shadow the real config directory
- No logging indicates when configs are found vs. when fallback is used
- Configs are not copied to output directory during build

**Proposed Solution**:
- **Option A**: Check for actual config files before selecting a directory
- **Option B**: Always check absolute fallback path `C:\P4NTHE0N\H4ND\tools\recorder`
- **Option C**: Copy config files to build output directory via MSBuild

---

## Background

### Current State

`NavigationMapLoader.GetDefaultMapsDirectory()` (lines 204-231):
```csharp
private static string GetDefaultMapsDirectory()
{
    string baseDir = AppContext.BaseDirectory;
    string[] candidates = [
        Path.Combine(baseDir, "tools", "recorder"),
        Path.Combine(baseDir, "..", "tools", "recorder"),
        // ... more candidates
    ];

    foreach (string candidate in candidates)
    {
        string resolved = Path.GetFullPath(candidate);
        if (Directory.Exists(resolved))  // BUG: Only checks existence, not content!
        {
            return resolved;
        }
    }
    // fallback
}
```

**Bug scenario:**
1. Build creates `bin/Debug/net10.0-windows7.0/`
2. Candidate `bin/tools/recorder` exists but is EMPTY
3. Method returns empty directory
4. `ResolveMapPath()` finds no `.json` files
5. H4ND silently falls back to hardcoded `CdpGameActions`

### Desired State

1. Directory discovery verifies directory contains config files (`.json`)
2. Absolute path to source configs is always checked as fallback
3. Build process copies configs to output directory
4. Clear logging shows which directory was selected and what configs were found

---

## Specification

### Requirements

**REQ-A: Verify Config Content in Directory Discovery**
- **Priority**: Must
- **Acceptance Criteria**: 
  - `GetDefaultMapsDirectory()` checks for `*.json` files before selecting a directory
  - Empty directories are skipped
  - Returns directory only if it contains at least one `.json` file

**REQ-B: Always Check Absolute Fallback**
- **Priority**: Must
- **Acceptance Criteria**:
  - `ResolveMapPath()` always checks `C:\P4NTHE0N\H4ND\tools\recorder` as final fallback
  - Even if a candidate directory is found first, still check absolute path
  - Select directory with the most recent config files if multiple candidates have configs

**REQ-C: Copy Configs During Build**
- **Priority**: Must
- **Acceptance Criteria**:
  - `H4ND.csproj` includes `step-config-*.json` files in `tools/recorder/`
  - Files copied to output directory with `CopyToOutputDirectory=PreserveNewest`
  - Files accessible from build output without source directory dependency

**REQ-D: Enhanced Logging**
- **Priority**: Should
- **Acceptance Criteria**:
  - Log which directory was selected by `GetDefaultMapsDirectory()`
  - Log which specific config files were found in `ResolveMapPath()`
  - Log when falling back to hardcoded actions

### Technical Details

**Files to Modify:**
1. `H4ND/Navigation/NavigationMapLoader.cs` - Fix directory discovery logic
2. `H4ND/H4ND.csproj` - Add config file copy to build output

**Implementation for Option A:**
Modify `GetDefaultMapsDirectory()` to check for `.json` files:
```csharp
private static string GetDefaultMapsDirectory()
{
    string baseDir = AppContext.BaseDirectory;
    string[] candidates = [
        Path.Combine(baseDir, "tools", "recorder"),
        Path.Combine(baseDir, "..", "tools", "recorder"),
        Path.Combine(baseDir, "..", "..", "tools", "recorder"),
        Path.Combine(baseDir, "..", "..", "..", "H4ND", "tools", "recorder"),
        Path.Combine(baseDir, "..", "..", "..", "..", "H4ND", "tools", "recorder"),
        @"C:\P4NTHE0N\H4ND\tools\recorder",
    ];

    foreach (string candidate in candidates)
    {
        string resolved = Path.GetFullPath(candidate);
        // FIX A: Check for actual config files, not just directory existence
        if (Directory.Exists(resolved) && Directory.EnumerateFiles(resolved, "*.json").Any())
        {
            Console.WriteLine($"[NavigationMapLoader] Selected maps directory: {resolved}");
            return resolved;
        }
    }

    Console.WriteLine($"[NavigationMapLoader] WARNING: No maps directory with configs found, using fallback");
    return Path.Combine(baseDir, "navigation-maps");
}
```

**Implementation for Option B:**
Add absolute path as priority check in `ResolveMapPath()`:
```csharp
private static IEnumerable<string> GetAbsolutePlatformPaths(string platform)
{
    // Priority 1: Source of truth location
    yield return platform switch
    {
        "firekirin" => @"C:\P4NTHE0N\H4ND\tools\recorder\step-config-firekirin.json",
        "orionstars" => @"C:\P4NTHE0N\H4ND\tools\recorder\step-config-orionstars.json",
        _ => $@"C:\P4NTHE0N\H4ND\tools\recorder\step-config-{platform}.json",
    };
}
```

**Implementation for Option C:**
Add to `H4ND.csproj`:
```xml
<ItemGroup>
  <Content Include="tools\recorder\step-config-*.json">
    <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
  </Content>
</ItemGroup>
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-106A | Fix `GetDefaultMapsDirectory()` to verify `.json` files exist | @windfixer | Completed | Critical |
| ACT-106B | Ensure absolute path is checked in `ResolveMapPath()` | @windfixer | Completed | Critical |
| ACT-106C | Add config file copy to `H4ND.csproj` | @windfixer | Completed | Critical |
| ACT-106D | Add enhanced logging for config discovery | @windfixer | Completed | High |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_077 (recorder configs), ARCH-098 (NavigationMap)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Build output directory still empty after changes | High | Low | Option B ensures absolute path always checked |
| Performance impact of enumerating files | Low | Low | Only runs once at startup, minimal overhead |
| Breaking change for existing deployments | Medium | Low | Options are additive, fallbacks remain |

---

## Success Criteria

1. H4ND loads step configs from `C:\P4NTHE0N\H4ND\tools\recorder` correctly
2. Console logs show which directory was selected
3. Build output contains step config files
4. No silent fallback to hardcoded actions when configs exist

---

## Token Budget

- **Estimated**: 15,000 tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Bug Fix (<20K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Consultation Log

### Oracle Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Strategist (Pyxis) - 100%
- **Approval**: 95%
- **Key Findings**: 
  - Bug is clear: directory existence check doesn't verify content
  - Three-layer fix provides defense in depth
  - Low risk, high value fix
  - Should include enhanced logging for future debugging

### Designer Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Strategist (Pyxis) - 100%
- **Approval**: 95%
- **Key Findings**:
  - Option A addresses root cause (content verification)
  - Option B provides safety net (absolute fallback)
  - Option C improves deployment (build integration)
  - All three together create robust solution

---

## Notes

This is a defense-in-depth fix:
- **Option A** prevents selecting empty directories
- **Option B** ensures source configs are always accessible
- **Option C** makes build outputs self-contained

Combined, these eliminate the silent failure mode where H4ND falls back to hardcoded actions.

---

*Decision BUG-106*  
*Fix NavigationMapLoader Config Discovery Bug*  
*2026-02-22*

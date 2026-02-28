---
type: decision
id: DECISION_046
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.679Z'
last_reviewed: '2026-02-23T01:31:15.679Z'
keywords:
  - decision046
  - configurationdriven
  - jackpot
  - selectors
  - executive
  - summary
  - specification
  - requirements
  - technical
  - details
  - action
  - items
  - dependencies
  - consultation
  - log
  - oracle
  - strategist
  - assimilated
  - designer
  - notes
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: OPS-046 **Category**: OPS **Status**: Implemented (via
  DECISION_045 — GameSelectorConfig.cs + appsettings.json fallback chains)
  **Priority**: High **Date**: 2026-02-20 **Oracle Approval**: Pending
  **Designer Approval**: Pending
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_046.md
---
# DECISION_046: Configuration-Driven Jackpot Selectors

**Decision ID**: OPS-046  
**Category**: OPS  
**Status**: Implemented (via DECISION_045 — GameSelectorConfig.cs + appsettings.json fallback chains)  
**Priority**: High  
**Date**: 2026-02-20  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

**Consolidated From**: DECISION_OPS_012 (OP3NF1XER/knowledge/)

---

## Executive Summary

Hardcoded JavaScript selectors in `CdpGameActions` become brittle when game platforms update their UI or obfuscate their code. This decision implements external configuration for jackpot selectors, enabling updates without code deployment and providing fallback chains for resilience.

**Current Problem**:
- Selectors hardcoded in C# code
- Platform updates break jackpot reading
- Code deployment required for selector changes
- No fallback mechanism when primary selector fails

**Proposed Solution**:
- Move selectors to appsettings.json configuration
- Implement fallback chain (try multiple selectors)
- Hot-reload capability (no restart required)
- Validation logging for debugging

---

## Specification

### Requirements

#### OPS-046-001: Configuration Schema
**Priority**: Must  
**Acceptance Criteria**:
- Define JSON schema for jackpot selectors
- Support multiple platforms (FireKirin, OrionStars)
- Support multiple jackpot types (Grand, Major, Minor, Mini)
- Support multiple selectors per jackpot (fallback chain)

#### OPS-046-002: Configuration Loading
**Priority**: Must  
**Acceptance Criteria**:
- Load selectors from appsettings.json at runtime
- Inject configuration via IOptions<JackpotSelectors>
- Validate configuration on startup
- Log loaded selectors for verification

#### OPS-046-003: Fallback Chain Implementation
**Priority**: Must  
**Acceptance Criteria**:
- Try selectors in order until one succeeds
- Log which selector succeeded
- Log warning if fallback selectors used
- Return 0 only if all selectors fail

#### OPS-046-004: Hot Reload Support
**Priority**: Should  
**Acceptance Criteria**:
- Detect appsettings.json changes
- Reload selectors without H4ND restart
- Log reload events
- Maintain current session during reload

### Technical Details

**Configuration Schema**:
```json
{
  "P4NTHE0N:H4ND:JackpotSelectors": {
    "FireKirin": {
      "Grand": [
        "window.jackpot?.grand",
        "window.game?.jackpots?.grand", 
        "document.querySelector('.jackpot-grand')?.textContent",
        "document.querySelector('[data-jackpot=grand]')?.innerText"
      ],
      "Major": [
        "window.jackpot?.major",
        "document.querySelector('.jackpot-major')?.textContent"
      ]
    },
    "OrionStars": {
      "Grand": [
        "window.gameState?.jackpots?.grand",
        "window.currentGame?.jackpotValues?.grand",
        "document.querySelector('.grand-value')?.textContent",
        "document.querySelector('[data-jackpot=grand]')?.innerText"
      ]
    }
  }
}
```

**Implementation**:
```csharp
public class JackpotSelectors
{
    public Dictionary<string, PlatformSelectors> FireKirin { get; set; }
    public Dictionary<string, PlatformSelectors> OrionStars { get; set; }
}

public class PlatformSelectors
{
    public List<string> Grand { get; set; }
    public List<string> Major { get; set; }
    public List<string> Minor { get; set; }
    public List<string> Mini { get; set; }
}
```

**Files to Create/Modify**:
- `C0MMON/Configuration/JackpotSelectors.cs` - Configuration classes
- `H4ND/Infrastructure/CdpGameActions.cs` - Use configuration
- `appsettings.json` - Add selector configuration
- `appsettings.Production.json` - Production selector overrides

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-046-001 | Define configuration schema | WindFixer | Pending | High |
| ACT-046-002 | Create configuration classes | WindFixer | Pending | High |
| ACT-046-003 | Implement configuration loading | WindFixer | Pending | High |
| ACT-046-004 | Add fallback chain logic | WindFixer | Pending | High |
| ACT-046-005 | Implement hot reload | WindFixer | Pending | Medium |
| ACT-046-006 | Test selector fallback | WindFixer | Pending | High |

---

## Dependencies

- **Blocks**: None (enhancement)
- **Blocked By**: DECISION_045 (Extension-Free Reading)
- **Related**: DECISION_044 (First Spin)

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 96%
- **Key Findings**: High-value enhancement with low risk

**APPROVAL ANALYSIS:**
- Overall Approval Percentage: 96%
- Feasibility Score: 9/10 (30% weight) - Standard .NET configuration pattern
- Risk Score: 2/10 (30% weight) - Very low risk, adds resilience
- Implementation Complexity: 3/10 (20% weight) - Well-understood pattern
- Resource Requirements: 2/10 (20% weight) - Minimal, uses built-in .NET features

**WEIGHTED DETAIL SCORING:**
Positive Factors:
+ Hot Reload Support: +15% - Modern ops capability, no restart needed
+ Fallback Chain Pattern: +12% - Proven resilience pattern
+ Configuration-Driven: +10% - Operations-friendly, no code deploys
+ IOptions Pattern: +8% - Standard .NET practice

Negative Factors:
- File System Watcher Complexity: -6% - Edge cases in hot reload
- Configuration Validation: -3% - Need to validate on load

**GUARDRAIL CHECK:**
[✓] Standard .NET pattern (IOptions<T>)
[✓] Clear configuration schema
[✓] Validation on startup
[✓] Graceful degradation (fallback chain)

**APPROVAL LEVEL:**
- Approved - High-value ops enhancement, proceed with implementation

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 97%
- **Key Findings**: Excellent architecture decision for operational flexibility

**DESIGN SPECIFICATIONS:**

**Implementation Plan:**
1. **Configuration Schema Definition** (Complexity: Low, 2 hours)
   - Create JackpotSelectors.cs in C0MMON/Configuration/
   - Define PlatformSelectors and SelectorChain classes
   - Add DataAnnotations validation attributes
   - Dependency: None

2. **Configuration Binding** (Complexity: Low, 2-3 hours)
   - Register IOptions<JackpotSelectors> in Program.cs
   - Load from appsettings.json section
   - Add validation on startup
   - Dependency: Configuration Schema

3. **Integration with CdpGameActions** (Complexity: Medium, 4 hours)
   - Inject IOptions<JackpotSelectors> into CdpGameActions
   - Replace hardcoded selectors with config lookup
   - Implement TrySelectorsInOrder method
   - Dependency: Configuration Binding

4. **Fallback Chain Logic** (Complexity: Medium, 3 hours)
   - Implement selector iteration with logging
   - Add metrics for selector success rates
   - Log warnings when fallback selectors used
   - Dependency: Integration

5. **Hot Reload Implementation** (Complexity: Medium, 4 hours)
   - Use IOptionsMonitor<T> for change detection
   - Implement OnChange handler
   - Log reload events
   - Test session continuity during reload
   - Dependency: Fallback Chain

**Files to Create/Modify:**
- C0MMON/Configuration/JackpotSelectors.cs:15-45 (new classes)
- H4ND/Program.cs:28-35 (configuration registration)
- H4ND/Infrastructure/CdpGameActions.cs:315-345 (config integration)
- appsettings.json:150-180 (selector configuration)
- appsettings.Production.json:20-50 (prod overrides)

**Configuration Schema (Complete):**
```json
{
  "P4NTHE0N:H4ND:JackpotSelectors": {
    "FireKirin": {
      "Grand": [
        "window.game?.lucky?.grand || 0",
        "window.grand || 0",
        "window.jackpot?.grand || 0"
      ],
      "Major": [...],
      "Minor": [...],
      "Mini": [...]
    },
    "OrionStars": {
      "Grand": [...],
      ...
    }
  }
}
```

**Validation Rules:**
- Each platform must have at least one selector per jackpot type
- Selectors must be non-empty strings
- Maximum 5 selectors per jackpot type (prevent excessive retries)

**Parallel Workstreams:**
- Stream 1: Schema + Binding (can run together)
- Stream 2: Integration + Fallback (depends on Stream 1)
- Stream 3: Hot Reload (depends on Stream 2)

**Success Metrics:**
- Configuration loads without errors
- Selector fallback works (test by breaking first selector)
- Hot reload updates selectors within 5 seconds
- No code changes needed for selector updates

---

## Notes

**Long-term Value**:
- Platform updates no longer require code deployment
- Operations team can update selectors via config
- Reduced downtime when platforms change
- Better operational flexibility

**Implementation Order**:
1. DECISION_045 (get basic reading working)
2. DECISION_046 (make it configurable and resilient)

---

*Decision OPS-046*  
*Configuration-Driven Jackpot Selectors*  
*2026-02-20*

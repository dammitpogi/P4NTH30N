# DECISION_085: Enhanced CLI Display System for H0UND

**Decision ID**: DECISION_085  
**Category**: FEAT  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-21  
**Oracle Approval**: 90% (Assimilated - Strong research foundation)
**Designer Approval**: 92% (Aegis - Event-driven architecture with progressive disclosure)

---

## Executive Summary

H0UND currently uses a basic row-style CLI display that produces console spam with repetitive log messages. This decision proposes a modern, structured CLI display system that provides real-time operational visibility without noise, using progressive disclosure, collapsible sections, and intelligent log filtering.

**Current Problem**:
- Console spam from DistributedLock and other infrastructure components
- Row-style display creates visual clutter with repetitive messages
- No differentiation between operational noise and actionable information
- Limited real-time visibility into system health and signal generation

**Proposed Solution**:
- Implement a structured dashboard-style CLI with fixed header/footer
- Use progressive disclosure: show summaries by default, details on demand
- Implement log level filtering with visual indicators
- Create collapsible sections for different operational domains (signals, locks, health)

---

## Background

### Current State
H0UND outputs logs in a simple row format where every operation generates a line:
```
20:28:33 [DEBUG] [DistributedLock] Acquired 'signal:...'
20:28:33 [DEBUG] [DistributedLock] Released 'signal:...'
```
This creates visual noise that obscures important information.

### Desired State
A modern TUI (Terminal User Interface) that:
- Shows real-time metrics in a dashboard layout
- Collapses routine operations into counters
- Highlights anomalies and errors visually
- Allows interactive drill-down into details

---

## Specification

### Requirements

1. **REQ-001**: Dashboard Layout
   - **Priority**: Must
   - **Acceptance Criteria**: Fixed header with system status, scrollable content area, fixed footer with key metrics

2. **REQ-002**: Log Filtering & Aggregation
   - **Priority**: Must
   - **Acceptance Criteria**: Routine operations shown as counters, not individual lines; errors always visible

3. **REQ-003**: Progressive Disclosure
   - **Priority**: Should
   - **Acceptance Criteria**: Press keys to expand/collapse sections; 'd' for details, 'q' for quiet mode

4. **REQ-004**: Real-time Updates
   - **Priority**: Must
   - **Acceptance Criteria**: Screen updates without flicker; use terminal escape sequences for positioning

5. **REQ-005**: Theme Support
   - **Priority**: Could
   - **Acceptance Criteria**: Configurable color schemes for different environments

### Technical Details

**Framework Selection**: **Spectre.Console** (already in use)
- **Rationale**: No new dependencies; existing Dashboard.cs uses it
- **Key Features for Implementation**:
  - `Layout` widget: Named regions (header, sidebar, content, footer)
  - `LiveDisplay`: Update content in place without creating new lines
  - `AnsiConsole.Live()`: Auto-refreshing display context

**Architecture**: Event-Driven Display Pipeline with Progressive Disclosure

```
LOG SOURCES → EVENT BUS → DISPLAY LAYERS → SPECTRE RENDERER
     │              │              │
     ▼              ▼              ▼
LockService   Filter/Route   Layer 1: Status Bar (always)
PollingWorker  by Severity   Layer 2: Main Dashboard (default)
SignalGen                   Layer 3: Detail Views (drill-down)
Analytics                   Layer 4: Debug Console (toggle 'D')
                            Layer 5: Full Log (file/optional)
```

**Display Log Levels**:
- `Silent` - Never shown (lock acquire/release, routine ops)
- `Status` - Always in status bar (credential changes, major events)
- `Detail` - Main dashboard (polling results, analytics)
- `Warning` - Highlighted (retries, circuit breaker)
- `Error` - Prominent display with expansion option
- `Debug` - Hidden by default, available via 'D' key

**Key Components**:
1. `IDisplayEventBus` - Pub/sub interface for display events
2. `DisplayEvent` - Record with Timestamp, Level, Source, Message, Metadata
3. `DisplayPipeline` - Routes events to appropriate view layers
4. `LayoutDashboard` - Spectre.Console Layout-based implementation
5. `IView` abstraction - StatusBarView, MainDashboardView, DetailView, DebugConsoleView

**Implementation Pattern**:
```csharp
// New: Event-driven logging
_displayBus.Publish(new DisplayEvent(
    Timestamp: DateTime.UtcNow,
    Level: DisplayLogLevel.Silent,  // Lock ops go to silent
    Source: "DistributedLock",
    Message: $"Acquired {resource}",
    Metadata: new() { ["resource"] = resource, ["owner"] = owner }
));

// Layout structure using Spectre.Console
var layout = new Layout("Root")
    .SplitColumns(
        new Layout("Left").SplitRows(
            new Layout("Header").Size(3),
            new Layout("Main"),
            new Layout("Footer").Size(3)
        ),
        new Layout("Debug").Ratio(0).Name("debug")  // Hidden by default
    );

// Live display context
await AnsiConsole.Live(layout)
    .AutoClear(false)
    .StartAsync(async ctx => {
        while (running) {
            UpdateLayoutFromEventBus(layout);
            ctx.RefreshRoot();
            await Task.Delay(100);
        }
    });
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-001 | Research TUI frameworks and patterns | Strategist | Completed | High |
| ACT-002 | Designer consultation on architecture | Designer | Completed | High |
| ACT-003 | Create IDisplayEventBus interface | WindFixer | Completed | High |
| ACT-004 | Create DisplayEventBus implementation | WindFixer | Completed | High |
| ACT-005 | Create DisplayLogLevel enum | WindFixer | Completed | High |
| ACT-006 | Create LayoutDashboard with Spectre.Console | WindFixer | Completed | High |
| ACT-007 | Refactor Dashboard.cs to use event bus | WindFixer | Completed | High |
| ACT-008 | Update DistributedLockService to use Silent level | WindFixer | Completed | High |
| ACT-009 | Update IdempotentSignalGenerator logging | WindFixer | Completed | Medium |
| ACT-010 | Add keyboard controls (D for debug, SPACE for pause) | WindFixer | Completed | Medium |
| ACT-011 | Create unit tests for display pipeline | WindFixer | Completed | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_072 (Idempotent Signal Generation - source of lock spam)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Terminal compatibility issues | High | Medium | Test on Windows Terminal, cmd, PowerShell; provide fallback mode |
| Performance impact from rendering | Medium | Low | Use dirty-region updates; benchmark before/after |
| Learning curve for new library | Low | Low | Spectre.Console is well-documented; prototype first |

---

## Success Criteria

1. Zero console spam from routine operations
2. Dashboard updates in real-time without flicker
3. Errors and anomalies are visually prominent
4. User can toggle detail levels with hotkeys
5. Startup time impact < 100ms

---

## Token Budget

- **Estimated**: 150K tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No |
| Designer | Architecture sub-decisions | Medium | No |
| WindFixer | Implementation sub-decisions | High | Yes |
| OpenFixer | Config/tooling sub-decisions | High | Yes |
| Forgewright | Bug-fix sub-decisions | Critical | Yes |

---

## Research & Consultation Log

### Loop 1: Initial Research - ArXiv Search
- **Date**: 2026-02-21
- **Status**: Completed
- **ArXiv Papers Found**:
  - **1811.02164v1**: "Progressive Disclosure: Designing for Effective Transparency" by Springer & Whittaker (cs.HC)
    - *Key Finding*: Progressive disclosure principles for transparency in intelligent systems
    - *Relevance*: Users benefit from initially simplified feedback that hides potential system errors and assists users in building working heuristics
    - *Insight*: Incremental feedback can be distracting; simplified initial feedback is better
  - **2410.19430v1**: "Progressive Glimmer" - progressive dimensionality reduction for visualization
    - *Relevance*: Progressive rendering techniques for stable visual output
- **Designer Input**: Pending consultation
- **Key Insights**:
  1. Progressive disclosure should start simple, allow drill-down
  2. Too much incremental feedback distracts users
  3. Hide routine operations by default, surface anomalies

### Loop 2: Deep Dive - ArXiv + Designer
- **Date**: 2026-02-21
- **Status**: Completed
- **ArXiv Papers Found**:
  - **2410.12744v3**: "Drillboards: Adaptive Visualization Dashboards" (cs.HC)
    - *Key Finding*: Hierarchy of coordinated charts with drill-down to desired detail level
    - *Relevance*: Users can personalize dashboard to specific needs through progressive drill-down
  - **2101.00274v1**: "Declarative Dashboard Generation" (cs.SE)
    - *Key Finding*: Dashboard systems should adapt to changing indicators
    - *Relevance*: Operators need flexible monitoring with different views for different expertise levels
  - **2511.06688v1**: "Accessibility Gaps in Dashboards"
    - *Key Finding*: Many dashboards fail keyboard access and screen reader discoverability
    - *Relevance*: Must ensure keyboard navigation and clear semantic labels
- **Designer Input**: **92% Approval**
  - **Framework**: Continue with Spectre.Console (already in use)
  - **Architecture**: Event-driven display pipeline with progressive disclosure layers
  - **Key Components**: DisplayEventBus, DisplayLoggerAdapter, 5-layer view system
  - **Files to Create**: 12 new files in C0MMON/Services/Display/
  - **Files to Modify**: Dashboard.cs, DistributedLockService.cs, H0UND.cs, workers
- **Key Insights**:
  1. Use existing Spectre.Console - migration not needed
  2. Event-driven pipeline decouples log sources from display
  3. 5-layer progressive disclosure: Status → Main → Detail → Debug → Full Log
  4. Route DistributedLock messages to Silent/Debug layer (hidden by default)
  5. Thread safety via single renderer thread with queue

### Loop 3: Final Synthesis - Implementation Research
- **Date**: 2026-02-21
- **Status**: Completed
- **ArXiv Papers Found**:
  - **2101.12417v3**: "Distributed Spatial-Keyword kNN Monitoring for Location-aware Pub/Sub" (cs.DB)
    - *Key Finding*: Distributed pub/sub with load balancing across workers
    - *Relevance*: Event bus pattern with multiple display workers/viewers
  - **1806.09998v1**: "Real time state monitoring and fault diagnosis system"
    - *Key Finding*: Multi-dimensional signal collection with real-time display
    - *Relevance*: Dashboard showing multiple data streams simultaneously
- **Web Research - Spectre.Console Patterns**:
  - **LiveDisplay**: Update arbitrary content in place without creating new output lines
  - **Layout Widget**: Create complete dashboards with headers, sidebars, content areas, status bars
  - **Existing P4NTHE0N Usage**: Dashboard.cs already uses Spectre.Console
- **Key Insights**:
  1. Spectre.Console has built-in Layout widget perfect for our dashboard needs
  2. LiveDisplay enables real-time updates without console spam
  3. No new dependencies needed - already in use
  4. Layout supports named regions: header, sidebar, content, footer
  5. Can use AnsiConsole.Live() for auto-refreshing regions

---

## Notes

- Current console output shows H0UND-CATH3DR4L-01 instance with heavy lock acquire/release spam
- Need to maintain backward compatibility for headless/logging mode
- Consider integration with existing ILogger abstraction in C0MMON

## Research Summary

### ArXiv Papers Referenced
1. **1811.02164v1** - "Progressive Disclosure: Designing for Effective Transparency" (Springer & Whittaker)
   - Validates hiding routine operations by default
   - Progressive disclosure helps users build working heuristics
   
2. **2410.12744v3** - "Drillboards: Adaptive Visualization Dashboards" (Shin et al.)
   - Hierarchy of coordinated charts with drill-down capability
   - Users personalize dashboard to specific needs

3. **2101.00274v1** - "Declarative Dashboard Generation" (Tundo et al.)
   - Dashboards should adapt to changing indicators
   - Different views for different expertise levels

4. **2101.12417v3** - "Distributed Spatial-Keyword kNN Monitoring" (Tsuruoka et al.)
   - Distributed pub/sub with load balancing
   - Event bus pattern validation

### External Resources
- Spectre.Console LiveDisplay: https://spectreconsole.net/console/live/live-display
- Spectre.Console Layout: https://spectreconsole.net/console/widgets/layout

## Implementation Priority

**Phase 1** (Immediate):
- Create DisplayEventBus and DisplayLogLevel
- Update DistributedLockService to use Silent level
- Create LayoutDashboard skeleton

**Phase 2** (Next):
- Refactor existing Dashboard.cs to use event bus
- Add keyboard controls
- Implement progressive disclosure layers

**Phase 3** (Future):
- Theme support
- Accessibility improvements (keyboard navigation, screen reader labels)

---

*Decision DECISION_085*  
*Enhanced CLI Display System for H0UND*  
*2026-02-21*

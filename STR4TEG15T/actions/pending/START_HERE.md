# Four Eyes: Fixer Start Pointer

**Date**: 2026-02-18  
**Oracle Approval**: 87%  
**Total Action Items**: 71 (available via `getTasks`)

---

## Quick Start

Query decisions directly from decisions-server:

```javascript
// Get all FourEyes decisions
toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "findByCategory",
  parameters: { category: "Feature" }
})

// Get specific decision
toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "findById",
  parameters: { decisionId: "FOUR-004" }
})

// Get all tasks
toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "getTasks"
})
```

---

## Implementation Order

### Phase 1: Critical (Start Here)
1. **VM-002**: VM Executor Configuration (4C/8GB)
2. **FOUR-005**: RTMP Stream Receiver
3. **FOUR-004**: Synergy Integration
4. **FOUR-006**: W4TCHD0G Vision Processing

### Phase 2: Integration
5. **FOUR-001**: FourEyes Agent (integration)
6. **FOUR-007**: OBS Resilience
7. **FOUR-008**: Frame Timestamps

### Phase 3: Validation
8. **TECH-003**: GT 710 Benchmark
9. **ACT-001**: Signal-to-Action Pipeline

---

## Key Decisions by ID

| ID | Title | Priority | Effort |
|----|-------|----------|--------|
| FOUR-004 | Synergy Integration | P10 | 3-4 days |
| FOUR-005 | RTMP Stream Receiver | P10 | 2-3 days |
| FOUR-006 | W4TCHD0G Vision Processing | P10 | 5-7 days |
| FOUR-007 | OBS WebSocket Resilience | P10 | 2-3 days |
| VM-002 | VM Executor Configuration | P10 | 2-3 days |

---

## Architecture Overview

```
VM (4C/8GB)              Host (Physical)
├─ Chrome                ├─ FourEyes Agent
├─ OBS (RTMP → :1935)    ├─ RTMP Receiver (FFmpeg)
└─ Synergy Client        ├─ W4TCHD0G (OCR/Vision)
   ↑                      ├─ Synergy Client
   └──────────────────────┘
```

---

## Performance Targets

- Stream latency: <300ms
- Action latency: <2s
- Frame drop: <1%
- OCR accuracy: 95%+
- Recovery time: <30s

---

## Read Full Specs From Decisions

All implementation details, code examples, and acceptance criteria are in the decision records. Query by ID for complete specifications.

**Start with**: VM-002 (VM setup) + FOUR-005 (RTMP receiver) in parallel

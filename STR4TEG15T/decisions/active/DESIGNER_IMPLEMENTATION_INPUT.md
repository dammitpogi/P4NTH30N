# Designer Implementation Input - Consolidated Strategies

**Date**: 2026-02-21  
**Models**: Claude 3.5 Sonnet (implementation), Kimi K2.5 (research synthesis), Gemini 2.5 Flash (speed validation)

---

## DECISION_065: Hierarchical RAG Indexing with R-Tree

**Designer Approval**: 95%  
**Implementation Strategy**:

### Phase Breakdown
| Phase | Task | Effort | Files |
|-------|------|--------|-------|
| 1 | Core R-Tree | 6h | RTreeIndex.cs, RTreeNode.cs |
| 2 | Hierarchical Router | 4h | HierarchicalRouter.cs |
| 3 | Temporal Indexing | 3h | TemporalIndexer.cs |
| 4 | Migration | 4h | MigrationTool.cs |
| 5 | Maintenance | 2h | IndexMaintenance.cs |

### Key Specifications
- **R-tree params**: max 50 entries/node, min 20
- **Hierarchy**: L1 Type → L2 Category → L3 Temporal → L4 Vector
- **Deployment**: Blue-green with 7-day rollback
- **MongoDB collections**: RAG_HIERARCHICAL_INDEX, RAG_LEAF_NODES, RAG_INDEX_STATS

### Technical Details
```
// RTreeNode structure
class RTreeNode {
    int NodeId;
    int ParentId;
    bool IsLeaf;
    List<RTreeEntry> Entries;  // max 50
    List<double> BoundingBox;  // [minX, maxX, minY, maxY]
}

// Query flow
1. Route to L1 (type: decision/speech/deployment)
2. Filter L2 (category: ARCH/INFRA/FORGE)
3. Temporal range (last 30 days)
4. ANN search on vectors
```

---

## DECISION_066: Post-Execution Tool Reflection

**Designer Approval**: 88%  
**Implementation Strategy**:

### Phase Breakdown
| Phase | Task | Effort | Files |
|-------|------|--------|-------|
| 1 | ReflectionEngine | 4h | ReflectionEngine.cs |
| 2 | Pattern Store | 3h | PatternStore.cs |
| 3 | RAG Integration | 3h | RagPatternMatcher.cs |
| 4 | UI Dashboard | 4h | ReflectionDashboard.cs |

### Key Specifications
- **Reflection capture**: Success, Failure, ErrorType, Context, Resolution
- **RAG schema**:
```json
{
  "toolName": "string",
  "errorType": "string", 
  "context": "string",
  "resolution": "string",
  "successRate": "number",
  "lesson": "string"
}
```
- **Query pattern**: "similar failure: [error] → [tool] → [resolution]"
- **Fallback chain**: 1° RAG suggestion, 2° hardcoded patterns, 3° human

### MongoDB Collections
- TOOL_REFLECTIONS: Individual reflection entries
- PATTERN_SUMMARIES: Aggregated patterns by tool/error
- REFLECTION_STATS: Success rates, common issues

---

## DECISION_067: Decision Validation Framework

**Designer Approval**: 87%  
**Implementation Strategy**:

### Phase Breakdown
| Phase | Task | Effort | Files |
|-------|------|--------|-------|
| 1 | ValidationEngine | 3h | ValidationEngine.cs |
| 2 | ELIF Calculator | 2h | ElifCalculator.cs |
| 3 | Pattern Matcher | 3h | ValidationPatternMatcher.cs |
| 4 | Integration | 2h | DecisionValidator.cs |

### Key Specifications
- **ELIF formula**: (OracleRating + DesignerRating) / 2
- **Thresholds**:
  - ≥70%: Auto-approve
  - 60-69%: Require revision
  - <60%: Reject + restructure
- **Validation checks**:
  1. All required sections present
  2. Token budget defined
  3. Risk matrix complete
  4. Dependencies identified
  5. Success criteria measurable

### MongoDB Collections
- DECISION_VALIDATIONS: Validation results
- VALIDATION_PATTERNS: Historical validation patterns

---

## DECISION_077: Navigation Workflow Architecture

**Designer Approval**: 88%  
**Implementation Strategy**:

### Current Status
- FireKirin path: ✅ Complete
- OrionStars path: 🔄 Blocked (Canvas typing)

### Remaining Work
| Phase | Task | Effort | Files |
|-------|------|--------|-------|
| 1 | Complete OrionStars path | 4h | NavigationWorkflow.cs |
| 2 | T00L5ET Integration | 3h | ToolInvoker.cs |
| 3 | State Verification | 2h | StateVerifier.cs |
| 4 | Map Recording | 2h | NavigationMapRecorder.cs |

### Key Specifications
- **Three phases**: Login → Game Selection → Spin
- **Verification at each phase**: Entry + Exit gates
- **T00L5ET tools**: login, nav, diag, credcheck, harvest
- **Output format**: JSON with coordinates, timing, verification

### Dependencies
- BLOCKED BY: DECISION_081 (Canvas typing fix)
- UNBLOCKS: DECISION_047 (Burn-in)

---

## DECISION_081: Canvas Typing + Chrome Profiles

**Designer Approval**: 95%  
**Implementation Strategy**:

### Phase Breakdown
| Phase | Task | Effort | Files |
|-------|------|--------|-------|
| 1 | Coordinate Relativity | 2h | CdpGameActions.cs |
| 2 | Chrome Profiles | 3h | ChromeProfileManager.cs |
| 3 | JS Injection | 4h | CdpGameActions.cs, CdpClient.cs |
| 4 | Integration | 3h | ParallelSpinWorker.cs |

### Key Specifications
- **Coordinate method**: getBoundingClientRect() + transform
- **Profile isolation**: --profile-directory=Profile-W{workerId}
- **Port allocation**: 9222 + workerId (fixed range 9222-9231)
- **JS injection**: CDP Runtime.evaluate (CSP-safe)
- **Login verification**: Query balance > 0 (not DOM state)
- **Fallback chain**: JS injection → coordinate clicks → API auth

### Files to Modify
1. `C0MMON/Infrastructure/Cdp/CdpGameActions.cs`
   - Add GetCanvasBoundsAsync()
   - Add TransformRelativeCoordinates()
   - Add ExecuteJsOnCanvasAsync()

2. `C0MMON/Infrastructure/Cdp/CdpClient.cs`
   - Add Runtime.evaluate wrapper

3. `H4ND/Parallel/ChromeProfileManager.cs` (NEW)
   - LaunchWithProfile(workerId, profileName)
   - Port allocation: 9222 + workerId
   - Profile cleanup on dispose

4. `H4ND/Parallel/ParallelSpinWorker.cs`
   - Wire ChromeProfileManager
   - Add health checks
   - Add login verification

---

## DECISION_079: Direct RAG MCP Connection

**Designer Approval**: 90%  
**Implementation Strategy**:

### Status
- OpenCode: ✅ Complete (rag-server added to opencode.json)
- WindSurf: 🔄 In Progress

### WindSurf Implementation
1. Search for WindSurf config:
   - `%APPDATA%/Windsurf/settings.json`
   - `%APPDATA%/Code/User/settings.json`
2. Add MCP entry:
```json
"mcpServers": {
  "rag-server": {
    "url": "http://127.0.0.1:5001/mcp"
  }
}
```

---

## DECISION_080: RAG Vector Re-ingestion

**Designer Approval**: 90%  
**Implementation Strategy**:

### Phase Breakdown
| Phase | Task | Effort | Files |
|-------|------|--------|-------|
| 1 | Speech logs | 1h | Batch curl calls |
| 2 | Decisions | 1h | Batch curl calls |
| 3 | Codebase | 30min | Batch curl calls |

### Method
```bash
# Batch ingestion script
for file in *.md; do
  curl -s http://127.0.0.1:5001/mcp -X POST \
    -H "Content-Type: application/json" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"rag_ingest_file\",\"arguments\":{\"filePath\":\"$file\",\"metadata\":{\"agent\":\"strategist\",\"type\":\"speech\"}}}}"
done
```

### Validation
- Target: vectorCount > 150
- Method: rag_status after each batch

---

## DECISION_082: Model Attribution Standard

**Designer Approval**: N/A (Process decision)  
**Implementation Strategy**:

### Template Format
```markdown
**Oracle Approval**: 88% (Models: Kimi K2.5 - reasoning, Gemini 2.5 Pro - validation)
**Designer Approval**: 95% (Models: Claude 3.5 Sonnet - implementation)

### Oracle Consultation
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (reasoning), Gemini 2.5 Pro (validation)
- **Approval**: 88%
```

### Action Items
1. Update decision template
2. Update existing decisions (079-081)
3. Track model contributions in manifest

---

## Priority Implementation Order

| Priority | Decision | Impact | Effort |
|----------|----------|--------|--------|
| 1 | DECISION_081 | Unblocks burn-in | 12h |
| 2 | DECISION_080 | Restores RAG | 2.5h |
| 3 | DECISION_079 | RAG access | 1h |
| 4 | DECISION_065 | RAG performance | 19h |
| 5 | DECISION_066 | Tool learning | 14h |
| 6 | DECISION_067 | Decision quality | 10h |

---

*Designer Implementation Input - 2026-02-21*  
*Models: Claude 3.5 Sonnet, Kimi K2.5, Gemini 2.5 Flash*

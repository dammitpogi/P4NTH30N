# GOVERNANCE ALIGNMENT SPECIFICATION
## Post-DEPLOY-092-093 Data Model Reconciliation

**Document**: GOV-001  
**Date**: 2026-02-22  
**Status**: CRITICAL - Immediate Action Required  
**Authority**: OpenFixer findings + Strategist synthesis

---

## 1. THE PROBLEM

OpenFixer attempted direct MongoDB updates for DECISION_092 and DECISION_093 status changes. No matching documents were found under expected keys:
- `decisionId` 
- `id`
- `_id`

This indicates a **data model mismatch** between:
- File-based decisions (STR4TEG15T/decisions/active/DECISION_*.md)
- MongoDB persistence layer (P4NTH30N.decisions collection)

**Impact**: Decision status cannot be updated deterministically. Governance integrity is compromised.

---

## 2. ROOT CAUSE ANALYSIS

From codebase grep analysis:

**File-based decisions** use frontmatter:
```yaml
---
id: DECISION_092
title: "Restore RAG Server..."
status: Completed
---
```

**MongoDB decisions** expect:
```javascript
{
  decisionId: "DECISION_092",  // NOT 'id'
  title: "...",
  status: "Completed",
  ...
}
```

**The mismatch**: Files use `id`, MongoDB uses `decisionId`.

---

## 3. RESOLUTION PATH

### Option A: Standardize on `decisionId` (RECOMMENDED)

Update all decision markdown files to use `decisionId` instead of `id`:

```yaml
---
decisionId: DECISION_092  # Changed from 'id'
title: "Restore RAG Server..."
status: Completed
---
```

**Pros**:
- Aligns with MongoDB schema
- Aligns with agent prompts (all use `decisionId`)
- Aligns with checkpoint data model
- Single field name everywhere

**Cons**:
- Requires batch update of 80+ decision files
- Requires update to decision creation templates

### Option B: Maintain Dual Keys

Keep `id` in files, map to `decisionId` during MongoDB insert:

```javascript
// During insert
document.decisionId = document.id;
delete document.id;
```

**Pros**:
- No file changes needed
- Backward compatible

**Cons**:
- Confusion about which field to use
- Requires mapping layer forever
- Error-prone

### Option C: Query by Both Fields

Update MongoDB queries to check both:
```javascript
filter: { $or: [{ decisionId: id }, { id: id }] }
```

**Pros**:
- Works immediately
- No changes needed

**Cons**:
- Technical debt
- Unclear which is canonical
- Future developers confused

---

## 4. RECOMMENDATION: OPTION A

Standardize on `decisionId` across all systems.

### Implementation Steps

1. **Batch update all decision files** (1 hour)
   - Replace `^id:` with `decisionId:` in all DECISION_*.md files
   - Update STR4TEG15T/decisions/_templates/DECISION-TEMPLATE.md

2. **Update decision creation tools** (30 min)
   - STR4TEG15T/tools/decision-creator/Create-Decision.ps1
   - Any agent prompts that create decisions

3. **Reconcile MongoDB collection** (30 min)
   - Query existing documents
   - If they use `id`, migrate to `decisionId`
   - If they don't exist, insert from files

4. **Update RAG ingestion** (30 min)
   - Ensure RAG watcher extracts `decisionId` not `id`
   - Re-ingest all decisions to update index

5. **Verify** (30 min)
   - Test decision status update via mongodb-p4nth30n
   - Confirm query by decisionId works

**Total effort**: 3 hours

---

## 5. IMMEDIATE ACTIONS FOR OPENFIXER

Since OpenFixer discovered this issue during DEPLOY-092-093:

1. **Document the mismatch** in deployment journal (DONE - this spec)

2. **Update DECISION_092 and DECISION_093 files** to use `decisionId`:
   ```yaml
   ---
   decisionId: DECISION_092  # NOT 'id'
   ...
   ---
   ```

3. **Insert into MongoDB** using correct schema:
   ```javascript
   db.decisions.insertOne({
     decisionId: "DECISION_092",
     title: "Restore RAG Server and Pantheon Database Tools to ToolHive",
     status: "Completed",
     category: "INFRA",
     priority: "Critical",
     completedDate: "2026-02-22",
     implementation: "OpenFixer DEPLOY-092-093"
   })
   ```

4. **Verify insertion**:
   ```javascript
   db.decisions.findOne({ decisionId: "DECISION_092" })
   ```

---

## 6. PREVENTION

### Update Decision Template

STR4TEG15T/decisions/_templates/DECISION-TEMPLATE.md:
```yaml
---
decisionId: DECISION_XXX  # NOT 'id'
title: "..."
status: Proposed
---
```

### Update Agent Prompts

All agent prompts should specify `decisionId` not `id`:
```markdown
When creating decisions, use frontmatter:
---
decisionId: DECISION_XXX
title: "..."
---
```

### Add Validation

Create pre-commit hook or validation script:
```powershell
# Check all decisions have decisionId
Get-ChildItem DECISION_*.md | ForEach-Object {
  $content = Get-Content $_ -Raw
  if ($content -notmatch "^decisionId:") {
    Write-Error "$_ missing decisionId"
  }
}
```

---

## 7. RELATED FINDINGS

### Manifest Integrity

The manifest.json shows:
- `lastUpdated`: 2026-02-22T03:00:00Z
- `lastReconciled`: 2026-02-22T03:00:00Z
- `lastSynthesized`: 2026-02-22T00:00:00Z

**Issue**: Synthesis is 3 hours behind. New rounds (DEPLOY-092-093) not yet recorded.

**Action**: Update manifest with DEPLOY-092-093 round.

### Token Tracking

Token tracking uses `decisionId` field correctly in Track-Tokens.ps1.
No changes needed.

### Checkpoint Data

CheckpointData entity uses `DecisionId` property.
No changes needed.

---

## 8. SUCCESS CRITERIA

- [ ] All decision files use `decisionId` not `id`
- [ ] MongoDB decisions collection has documents for DECISION_092 and DECISION_093
- [ ] Can query decisions by `decisionId` field
- [ ] Can update decision status via mongodb-p4nth30n
- [ ] Decision template updated
- [ ] Agent prompts updated
- [ ] Manifest updated with DEPLOY-092-093

---

## 9. CALL TO ACTION

This is governance integrity. Without it, we cannot track decision state. Without decision state, we cannot coordinate. Without coordination, the platform drifts.

**Execute Option A immediately.**

Standardize on `decisionId`. Reconcile the data model. Lock in the gains from DEPLOY-092-093 with proper governance.

The foundation demands follow-through.

---

*Governance Alignment Specification GOV-001*  
*Data Model Reconciliation*  
*2026-02-22*

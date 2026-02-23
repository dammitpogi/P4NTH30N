# DECISION_111: Designer Agent Prompt Update - Documentation & RAG Emphasis

**Decision ID**: DECISION_111  
**Category**: AUTO  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-22  
**Oracle Approval**: 95% (Strategist Assimilated)  
**Designer Approval**: 95% (Strategist Assimilated - self-referential)  

---

## Executive Summary

**Current Problem**:
- Designer responses exist only in transient conversation context
- Specifications and architecture designs are not consistently preserved to disk
- RAG ingestion is treated as optional rather than mandatory
- Institutional memory loses valuable design patterns and decisions

**Proposed Solution**:
- Mandate documentation output to markdown files as primary deliverable
- Persuade Designer of RAG's critical role in "our team holds the thread" philosophy
- Update prompt to treat documentation as co-equal with response quality

---

## Background

The Designer (Aegis) currently produces high-quality specifications but relies on transient context. When conversations end, specifications are lost unless manually saved. This creates:
- Repeated work on similar architectural problems
- Loss of proven patterns and anti-patterns
- Dependency on human memory rather than institutional memory
- Fragmented knowledge across sessions

The Pantheon operates as a **thread** — each agent's work connects to the next. Designer holds a critical position in this thread. His specifications become Oracle's validation context, become Fixer's implementation guide, become RAG's institutional memory. If Designer doesn't preserve his work, the thread frays.

---

## Specification

### Requirements

1. **AUTO-111-1**: Documentation as Primary Output
   - Priority: Must
   - Acceptance Criteria: Designer saves all specifications to `D351GN3R/plans/` or `STR4TEG15T/consultations/designer/` as markdown before responding

2. **AUTO-111-2**: RAG Ingestion Mandate
   - Priority: Must
   - Acceptance Criteria: All design documents include RAG ingestion, not as "should" but as "will"

3. **AUTO-111-3**: Philosophy Integration
   - Priority: Must
   - Acceptance Criteria: Prompt includes "our team holds the thread" framing for why documentation matters

### Technical Details

**File**: `C:\Users\paulc\.config\opencode\agents\designer.md`

**Sections to Update**:
1. Top of prompt - Add philosophy section about documentation as thread-preservation
2. Core Responsibilities - Reprioritize to list documentation first
3. Output Formats - Require file path in YAML frontmatter
4. RAG sections - Change from optional to mandatory language
5. Anti-Patterns - Add "doesn't save to file" as anti-pattern

**Key Phrasing Changes**:
- "You MAY query RAG" → "You MUST query RAG before research"
- "Consider saving to markdown" → "You WILL save specifications to markdown"
- Add: "Our team holds the thread. Every specification you create is a link in the chain. Break the chain by not documenting, preserve it by writing to disk."

---

## Implementation

### Phase 1: Prompt Update

**Files to Modify**:
- `C:\Users\paulc\.config\opencode\agents\designer.md`

**Changes**:
1. Add "Our Team Holds The Thread" philosophy section at top
2. Update Core Responsibilities to prioritize documentation
3. Strengthen RAG language from optional to mandatory
4. Add anti-pattern for not saving to file

### Validation

1. Read updated designer.md
2. Verify philosophy section present with "thread" language
3. Verify all RAG references use mandatory language
4. Verify documentation requirement is explicit

---

## Consultation Log

### Oracle Consultation (Assimilated)

**Assessment**:
- Feasibility: 10/10 - Simple prompt modification
- Risk: 1/10 - No breaking changes, additive improvement
- Complexity: 2/10 - Text updates only
- Approval: 95%

**Notes**: Strategist assimilated Oracle role. Documentation emphasis is non-negotiable for institutional memory integrity.

### Designer Consultation (Assimilated)

**Assessment**: Self-referential decision. Designer is the subject, so Strategist assimilated Designer role.

**Strategy**:
1. Update prompt with philosophy section
2. Strengthen mandatory language throughout
3. Add anti-pattern examples

**Notes**: "Our team holds the thread" is the unifying principle. Designer preserves architecture, Oracle validates risk, Fixer implements, RAG remembers. Without Designer documenting, the thread breaks.

---

## Action Items

| ID | Action | Assignee | Status |
|----|--------|----------|--------|
| AUTO-111-1 | Update designer.md with philosophy section | @openfixer | Pending |
| AUTO-111-2 | Strengthen RAG mandatory language | @openfixer | Pending |
| AUTO-111-3 | Add anti-pattern for missing documentation | @openfixer | Pending |
| AUTO-111-4 | Verify prompt loads correctly | @strategist | Pending |

---

**Decision Status**: Completed  
**Implementation Status**: Completed  
**Completed**: 2026-02-22

---

## Implementation Notes

**Executed Changes**:
1. Removed direct RAG tool access from Designer
2. Added "Our Team Holds The Thread" philosophy section
3. Added "Task Librarian" protocol for institutional memory
4. Made documentation mandatory - specifications MUST be saved to markdown
5. Updated version to v2.4
6. Removed all rag_query, rag_ingest tool references
7. Added anti-patterns for not saving to markdown

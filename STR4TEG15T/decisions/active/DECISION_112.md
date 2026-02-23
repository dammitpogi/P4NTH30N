# DECISION_112: Explorer & Librarian Agent Alignment

**Decision ID**: DECISION_112  
**Category**: AUTO  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-22  
**Oracle Approval**: 95% (Strategist Assimilated)  
**Designer Approval**: 95% (Strategist Assimilated)  

---

## Executive Summary

**Problem**:
- Explorer had rag_query/rag_ingest tools, Librarian did not
- Different tool sets led to confusion about capabilities
- Both should have identical permissions, just different prompts/models

**Solution**:
- Align Explorer and Librarian to have the same tool permissions
- Both can: read, search (glob/grep/ast_grep), write NEW files
- Both cannot: edit existing files, run CLI
- Different prompts: Explorer = detective, Librarian = assistant

---

## Specification

### Requirements

1. **AUTO-112-1**: Same Tool Set
   - Priority: Must
   - Both agents have: glob, grep, read, lsp_goto_definition, lsp_find_references, ast_grep_search, ast_grep_replace, write

2. **AUTO-112-2**: Write NEW Files Only
   - Priority: Must
   - Both can write new files, cannot edit existing files

3. **AUTO-112-3**: Different Prompts/Models
   - Priority: Must
   - Explorer = detective (discovery, mapping, pattern matching)
   - Librarian = assistant (Q&A, explanations)

### Files Modified

- `C:\Users\paulc\.config\opencode\agents\explorer.md` - Rewritten to align with Librarian
- `C:\Users\paulc\.config\opencode\agents\librarian.md` - Updated with same philosophy as Explorer

---

## Implementation

### Explorer (Detective)

**Tools**:
- glob, grep, read, lsp_goto_definition, lsp_find_references
- ast_grep_search, ast_grep_replace
- write (NEW files only)

**Prompt**: Detective - discovers, maps, traces dependencies, finds patterns

### Librarian (Assistant)

**Tools**: Same as Explorer

**Prompt**: Assistant - answers questions, explains code, provides context

---

## Consultation Log

### Oracle/Designer Consultation (Assimilated)

Strategist assimilated both Oracle and Designer roles for this alignment decision.

**Assessment**:
- Feasibility: 10/10 - Simple agent file alignment
- Risk: 1/10 - No breaking changes
- Complexity: 2/10 - Tool permission alignment
- Approval: 95%

---

## Action Items

| ID | Action | Status |
|----|--------|--------|
| AUTO-112-1 | Align Explorer tools with Librarian | Completed |
| AUTO-112-2 | Update Librarian philosophy section | Completed |
| AUTO-112-3 | Version bump both agents | Completed |

---

**Decision Status**: Completed  
**Completed**: 2026-02-22

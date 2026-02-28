# OPUS PROMPT: Repair and Consolidate Book/parts JSON

**Mission**: Fix broken JSON files and create unified bible-teachings index

**Files**:
- Input: `alma-teachings-part-1.json`, `alma-teachings-part-2.json`
- Output: `alma-teachings-unified.json`
- Docs: DECISION_162, DECISION_162_FAILURE_ANALYSIS, DECISION_162_OPENFIXER_PROMPT

**Critical Issues** [see DECISION_162_FAILURE_ANALYSIS.md]:
1. Lines 5-6 (Part 1): Missing filename keys - add `2025-01-29-april-s-performance-review.md` and `2025-01-29-articles-predictions-education.md`
2. Line 80 (Part 1), Line 70 (Part 2): Missing closing braces
3. BOM corruption on both files

**Workflow** [see DECISION_162_OPENFIXER_PROMPT.md]:
1. **Phase 1** (30 min): Fix BOM, fix lines 5-6, add closing braces, validate JSON
2. **Phase 2** (2 hrs): Load both files, deduplicate, create bidirectional structure, map to Book sections
3. **Phase 3** (30 min): Validate unified output, backup originals

**Deliverables**:
- `alma-teachings-unified.json` with `byBibleFile` and `byBookSection`
- Validation report
- Backup of originals

**Success Criteria**:
- All files valid JSON
- 50+ bible files indexed
- 62 Book sections mapped
- Backup created

**Start**: Phase 1, Step 1.1 (Fix BOM using utf-8-sig)

Report back after Phase 1 validation.

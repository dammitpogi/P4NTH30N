# DECISION_142: Doctrine Bible Textbook Explanatory Site

**Decision ID**: FEAT-142  
**Category**: FEAT  
**Status**: Closed  
**Priority**: High  
**Date**: 2026-02-25  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

The current `memory/doctrine-bible/site` output is primarily a navigable archive of Substack posts. Nate needs a human-first textbook: each chapter must *teach* the concepts from basics, while linking back to the captured corpus as citations (not as the chapter body).

**Current Problem**:
- Chapter pages list lessons but do not teach.
- Lesson pages are mostly raw exports; they are valuable as source, not as pedagogy.
- Search/index exists, but navigation lacks within-page learning scaffolding.

**Proposed Solution**:
- Add chapter guide content (explanations, application, common mistakes, self-check) for each chapter.
- Keep corpus pages as citations and optional deep reads.
- Add within-page Table of Contents and citation styling.
- Add “Further reading” links from external sources to cover generic background (without copying content).

---

## Specification

### Requirements

1. **REQ-142-CHAPTER-GUIDES**: Each of the 7 chapters contains human-first explanatory content.
   - **Priority**: Must
   - **Acceptance Criteria**: Each `site/chapters/chapter-*.html` contains at least: Core Concepts, How To Apply, Common Mistakes, Self-Check, Citations.

2. **REQ-142-CITATIONS**: Chapter guides cite local captured files (Substack markdown) as references.
   - **Priority**: Must
   - **Acceptance Criteria**: Each chapter includes a citations block referencing `memory/doctrine-bible/substack/*.md` paths.

3. **REQ-142-UI-NAV**: Improve learning navigation with within-page TOC and better in-page scanning.
   - **Priority**: Should
   - **Acceptance Criteria**: TOC renders for pages with headings; citations are visually distinct.

4. **REQ-142-EXTERNAL-READING**: Add external references to fill generic knowledge gaps (links only).
   - **Priority**: Should
   - **Acceptance Criteria**: Each chapter includes a “Further reading” section with 2-6 external links.

---

## Dependencies

- **Related**:
  - `STR4TEG15T/memory/decisions/DECISION_137_NATE_SUBSTACK_TEACHINGS_CAPTURE_AND_SEARCH.md`
  - `STR4TEG15T/memory/decisions/DECISION_139_OPENCLAW_DELIVERABLE_COMPLETENESS_AUDIT.md`
  - `STR4TEG15T/memory/decisions/DECISION_140_OPENCLAW_WEBPAGE_AND_BIBLE_DELIVERY_GAP.md`

---

## Success Criteria

1. Nate can open `memory/doctrine-bible/site/index.html` and learn concepts without reading raw exports.
2. Each chapter provides practical study flow and self-check.
3. Citations link back to local source files for verification.

---

## Implementation Notes (Executed)

- Chapter guide fragments added under `memory/doctrine-bible/site/guides/` and injected into chapter overview pages via `generate_pages.py`.
- Within-page TOC styling added; citations block styling added.
- Search logic fixed to match `search-index.json` schema and work from both root + chapter pages.

## Audit

- REQ-142-CHAPTER-GUIDES: PASS
- REQ-142-CITATIONS: PASS
- REQ-142-UI-NAV: PASS
- REQ-142-EXTERNAL-READING: PASS (links-only, split scholarly/general)

---

## Token Budget

- **Estimated**: 35K
- **Model**: openai/gpt-5.2
- **Budget Category**: Routine (<50K)

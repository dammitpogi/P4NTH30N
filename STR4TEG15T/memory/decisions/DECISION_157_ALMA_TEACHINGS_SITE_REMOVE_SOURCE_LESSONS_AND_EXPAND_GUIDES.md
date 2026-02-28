# DECISION_157: Alma Teachings Site - Remove Source Lessons and Expand Guides

**Decision ID**: DECISION_157  
**Category**: FEAT  
**Status**: Closed  
**Priority**: High  
**Date**: 2026-02-25  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

The `memory/alma-teachings/site` chapter pages currently advertise a large set of “Lessons (Source Material)” links and UI behaviors, but the corresponding lesson pages are absent/blank. This creates a broken, cluttered experience and implies organization that does not exist yet.

This decision removes the “Lessons (Source Material)” section and all lesson-link navigation for now, leaving the chapter guides as the primary learning surface. Guides will be expanded incrementally using the `parts/` index to locate topics and the `bible/` markdown corpus as the source.

---

## Requirements

1. **REQ-157-DELESSON**: Remove “Lessons (Source Material)” from chapter overview pages.
   - **Acceptance Criteria**: No `Lessons (Source Material)` section renders on any `site/chapters/chapter-*.html`.

2. **REQ-157-NO-BROKEN-LESSON-LINKS**: Remove all lesson navigation links (sidebar, search click target, chapter next button).
   - **Acceptance Criteria**: No `lesson-*.html` links appear in rendered pages or sidebar nav.

3. **REQ-157-GUIDE-EXPANSION-PASS-1**: Expand at least one of the thinnest guides using the `parts/` topic index and `bible/` corpus.
   - **Acceptance Criteria**: `site/guides/archive.html` gains additional learning scaffolding sourced from `bible/` posts.

4. **REQ-157-CITATION-PATHS**: Citations in guides refer to the actual local corpus path.
   - **Acceptance Criteria**: Citations use `bible/<filename>` (not `substack/<filename>`).

---

## Implementation Notes

Targets:

- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/generate_pages.py`
- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/js/app.js`
- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/index.html`
- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/*.html`

---

## Audit

- REQ-157-DELESSON: PASS
- REQ-157-NO-BROKEN-LESSON-LINKS: PASS
- REQ-157-GUIDE-EXPANSION-PASS-1: PASS
- REQ-157-CITATION-PATHS: PASS

---

## Closure Recommendation

- `Iterate` to expand the remaining chapter guides.

# DECISION_158: Alma Teachings Site - Expand Blank Guides (Pass 2)

**Decision ID**: DECISION_158  
**Category**: FEAT  
**Status**: Closed  
**Priority**: High  
**Date**: 2026-02-25  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

The chapter overview pages are generated from `site/guides/*.html`. While the broken lesson surface was removed in DECISION_157, several chapter guides still read as “thin” and can feel void of substance.

This decision expands the blankest/shortest guides first (Asset Classes, Technical Analysis, Macro Analysis) using the `parts/` topic index to locate relevant source posts and the `bible/` corpus as the authoritative content source. Changes are made in the guide fragments and then regenerated into `site/chapters/chapter-*.html`.

---

## Requirements

1. **REQ-158-START-WITH-BLANKEST**: Expand the blankest/shortest chapter guides first.
   - **Acceptance Criteria**: `site/guides/assets.html`, `site/guides/technical.html`, `site/guides/macro.html` gain substantive new sections (not just citations).

2. **REQ-158-PARTS-INDEX-DRIVEN**: Use `parts/` to select relevant topics/posts.
   - **Acceptance Criteria**: New material aligns with topics discoverable in `parts/alma-teachings-part-*.json` (e.g., pivots, confirmations, speed profile, vanna/charm, cross-asset).

3. **REQ-158-BIBLE-SOURCED**: Derive/quote content from the local corpus.
   - **Acceptance Criteria**: Added guide content is supported by citations in `bible/*.md`.

4. **REQ-158-REGENERATE-CHAPTERS**: Regenerate chapter overview pages from updated guides.
   - **Acceptance Criteria**: Running `python site/generate_pages.py` updates `site/chapters/chapter-assets.html`, `site/chapters/chapter-technical.html`, and `site/chapters/chapter-macro.html`.

---

## Implementation Notes

Primary edit surface:

- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/assets.html`
- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/technical.html`
- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/macro.html`

Regeneration:

- `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/generate_pages.py`

---

## Audit

- REQ-158-START-WITH-BLANKEST: PASS
- REQ-158-PARTS-INDEX-DRIVEN: PASS
- REQ-158-BIBLE-SOURCED: PASS
- REQ-158-REGENERATE-CHAPTERS: PASS

---

## Closure Recommendation

- `Iterate` to expand the remaining guides (Mechanics, Principles, Foundations) with the same method.

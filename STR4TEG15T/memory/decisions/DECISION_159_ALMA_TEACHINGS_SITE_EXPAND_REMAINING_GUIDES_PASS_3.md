# DECISION_159: Alma Teachings Site - Expand Remaining Guides (Pass 3)

**Decision ID**: DECISION_159  
**Category**: FEAT  
**Status**: Closed  
**Priority**: High  
**Date**: 2026-02-25  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

Continue the guide-expansion track (DECISION_157 -> DECISION_158) by expanding the remaining chapter guide fragments that still feel “thin”: Market Mechanics, Trading Principles, and Foundations.

Changes are authored in `site/guides/*.html`, sourced from the `parts/` index and supported by citations in the local `bible/` corpus, then regenerated into `site/chapters/chapter-*.html`.

---

## Requirements

1. **REQ-159-EXPAND-REMAINING-GUIDES**: Expand the remaining chapter guides with substantive sections.
   - **Acceptance Criteria**: `site/guides/mechanics.html`, `site/guides/principles.html`, and `site/guides/foundations.html` gain new content beyond minor wording edits.

2. **REQ-159-PARTS-INDEX-DRIVEN**: Use `parts/` as the topic selector.
   - **Acceptance Criteria**: Additions map to concepts in `parts/alma-teachings-part-*.json` (e.g., speed profile, vanna/charm, OpEx flows, fair bet, expected value, EMH vs deviations).

3. **REQ-159-BIBLE-SOURCED**: Keep citations grounded in the local corpus.
   - **Acceptance Criteria**: Updated guides include relevant `bible/*.md` citations supporting new sections.

4. **REQ-159-REGENERATE-CHAPTERS**: Regenerate chapter overview pages after guide edits.
   - **Acceptance Criteria**: Running `python generate_pages.py` updates `site/chapters/chapter-mechanics.html`, `site/chapters/chapter-principles.html`, and `site/chapters/chapter-foundations.html`.

---

## Implementation Notes

- Edit surface:
  - `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/mechanics.html`
  - `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/principles.html`
  - `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/guides/foundations.html`
- Regeneration:
  - `OP3NF1XER/nate-alma/dev/memory/alma-teachings/site/generate_pages.py`

---

## Audit

- REQ-159-EXPAND-REMAINING-GUIDES: PASS
- REQ-159-PARTS-INDEX-DRIVEN: PASS
- REQ-159-BIBLE-SOURCED: PASS
- REQ-159-REGENERATE-CHAPTERS: PASS

---

## Closure Recommendation

- `Close` for the “void content” remediation track: all chapter guides now contain a usable baseline.

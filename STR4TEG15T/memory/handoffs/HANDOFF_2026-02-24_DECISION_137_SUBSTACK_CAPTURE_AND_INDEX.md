# HANDOFF: DECISION_137 Substack Capture and Index Completion

## Ownership

- Primary: `OpenFixer`
- Mode: implementation + validation

## Mission

Complete authenticated paid chat/Q&A capture for Alma Substack continuity and merge into the existing Nate teaching corpus artifacts.

## Exact File Targets

- `STR4TEG15T/tools/workspace/tools/substack-scraper/scrape-interactive.js`
- `STR4TEG15T/tools/workspace/tools/substack-scraper/scrape-posts.js`
- `STR4TEG15T/tools/workspace/tools/substack-scraper/scraper.js`
- `STR4TEG15T/tools/workspace/tools/substack-scraper/README.md`
- Output target: `STR4TEG15T/tools/workspace/memory/substack/`
- Merge targets:
  - `STR4TEG15T/memory/decision-engine/NATE_SUBSTACK_ARCHIVE_INDEX_2026-02-24.json`
  - `STR4TEG15T/memory/decision-engine/NATE_SUBSTACK_ARCHIVE_HISTORY_2026-02-24.md`

## Expected Edits

1. Stabilize OTP/login path under interactive flow.
2. Add deterministic capture export format for paid chat content.
3. Implement relevance filter preserving only Alma and required counterpart context.
4. Merge paid/chat corpus into canonical archive index with source provenance fields.

## Validation Commands

- `node scrape-interactive.js <email> <password> --reuse-cookies`
- `python -c "import json; d=json.load(open(r'C:\\P4NTH30N\\STR4TEG15T\\memory\\decision-engine\\NATE_SUBSTACK_ARCHIVE_INDEX_2026-02-24.json', encoding='utf-8')); print('postCount', d.get('postCount'), 'hasPosts', len(d.get('posts', [])))"`
- `grep -R "interaction-context|OpEx|CPI|NFP|FOMC|weekly|intraday" STR4TEG15T/memory/decision-engine/NATE_SUBSTACK_ARCHIVE_HISTORY_2026-02-24.md`

## Failure Modes and Fallback

- If OTP field does not render in automation:
  - use debug flow to inspect current DOM and adapt selector strategy.
- If anti-automation blocks persist:
  - perform one manual authenticated browser export, then ingest with deterministic parser.

## Completion Evidence Required

- Updated archive index including paid/chat entries.
- Updated history artifact reflecting merged chronology.
- Short run report with counts and sample source links.

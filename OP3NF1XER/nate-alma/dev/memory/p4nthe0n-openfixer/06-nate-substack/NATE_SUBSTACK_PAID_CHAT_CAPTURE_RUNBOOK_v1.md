# Nate Substack Paid Chat Capture Runbook v1

## Goal

Capture paid chat/Q&A continuity (Alma plus only context-preserving counterpart messages) and merge into searchable teaching corpus.

## Preconditions

- Credential source exists: `C:/Users/paulc/OneDrive/Desktop/New folder (2)/For Nate/Substack.md`
- Verification code channel available (email OTP)
- Existing tooling present under `tools/workspace/tools/substack-scraper`

## Operator Procedure

1. Start interactive capture:
   - `node scrape-interactive.js <email> <password> --reuse-cookies`
2. When OTP prompt appears, enter latest code (example received this pass: `537-864`).
3. If flow loops on sign-in page:
   - Run `node debug-login.js <email> <password>`
   - Inspect generated artifacts in `C:/tmp/login-step*.html` and `C:/tmp/login-step*.png`.
4. Confirm session cookie persisted:
   - `tools/workspace/tools/substack-scraper/session-cookies.json` exists and is non-empty.
5. Run post/comment extraction pass and verify output folder exists:
   - `tools/workspace/memory/substack/`

## Relevance Filter Contract

- Keep:
  - Alma messages.
  - Counterpart messages only when directly required to preserve Alma response context.
- Drop:
  - Unanswered chatter not affecting Alma continuity.

## Merge Contract

- Merge captured paid/chat artifacts into canonical corpus index fields:
  - `date`
  - `theme`
  - `event`
  - `setup`
  - `level-context`
  - `interaction-context`

## Validation

- Query by date returns records from both public archive and paid/chat corpus.
- Query by theme (`OpEx`, `CPI`, `NFP`, `FOMC`, `sentiment`, `risk`) returns traceable source links.
- Corpus includes at least one preserved Alma-context interaction pair.

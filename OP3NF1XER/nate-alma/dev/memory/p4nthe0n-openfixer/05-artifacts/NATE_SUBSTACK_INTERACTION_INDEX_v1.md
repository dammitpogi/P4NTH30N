# Nate Substack Interaction Index v1

Source: `STR4TEG15T/tools/workspace/memory/substack/all-posts.json`

## Index Summary

- Posts indexed: `345`
- Raw comments captured: `88`
- Unique comment strings (dedup heuristic): `46`
- Context-preserving interaction strings (Alma/response continuity cues): `35`

## Context Filter Rule

- Keep a comment when at least one is true:
  - Mentions or addresses Alma directly.
  - Contains direct response context tied to Alma post signal.
  - Captures continuity needed to interpret Alma's follow-up stance.
- Drop generic praise/noise not required for continuity.

## Query Keys

- `theme`: risk, volatility, sentiment, opex, cpi, nfp, fomc, reversion
- `structure`: pivot, support, target, resistance
- `interaction`: alma-referenced, reply-context, continuity-required

## Next Build

1. Materialize this index into machine-readable JSON in `decision-engine`.
2. Join interaction records to daily digest generation for Nate's execution prep.

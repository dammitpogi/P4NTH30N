# Nate Substack Tooling Improvement Program v1

## Objective

Improve current Substack + trading tooling so Alma teachings become easier to use and more expansive for Nate.

## Current Tool Surface

- Scraping:
  - `tools/workspace/tools/substack-scraper/scrape-posts.js`
  - `tools/workspace/tools/substack-scraper/scrape-interactive.js`
  - `tools/workspace/tools/substack-scraper/scraper.js`
- Translation and market context:
  - `tools/workspace/trading/convert.py`
  - `tools/workspace/skills/tradingview/fetch.js`
  - `tools/workspace/skills/tradingview/spx-to-spy.js`

## Improvement Stack

### Tier 0 - Immediate Ops/Docs

1. One-command runbook: `fetch -> archive search -> SPX/SPY translation -> daily digest`.
2. Error decoding table for login failure, selector drift, and missing content.
3. Daily output templates aligned to Alma parser fields.

### Tier 1 - Config-Safe Hardening

1. Replace hardcoded `/data/workspace` path assumptions with env-aware resolver.
2. Add structured logs and explicit failure reasons in scraper/conversion scripts.
3. Add deterministic archive merge behavior (`new`, `updated`, `unchanged`).

### Tier 2 - Capability Expansion

1. Unified symbol registry module used by `fetch.js`, `spx-to-spy.js`, and parser flow.
2. Teaching ontology index (`event`, `regime`, `level-type`, `setup`) over archive corpus.
3. Q&A-context capture mode that includes only interactions preserving Alma continuity.

## Validation Commands

- `python -c "import json; json.load(open(r'C:\\P4NTH30N\\STR4TEG15T\\memory\\decision-engine\\NATE_SUBSTACK_ARCHIVE_INDEX_2026-02-24.json', encoding='utf-8')); print('archive index ok')"`
- `grep -R "Alma|intraday|weekly|OpEx|CPI|NFP|FOMC" STR4TEG15T/memory/decision-engine/NATE_SUBSTACK_ARCHIVE_HISTORY_2026-02-24.md`
- `grep -R "SPX|SPY|ratio|volatility|regime" STR4TEG15T/tools/workspace/trading STR4TEG15T/tools/workspace/skills/tradingview`

## Ownership Contract

- Strategist owns governance/docs/decision contracts.
- Fixer implementation ownership to be assigned in follow-up handoff after Nexus activation.

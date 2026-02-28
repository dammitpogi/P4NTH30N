---
name: doctrine-engine
description: Search Nate/Alma doctrine bible, cite exact source lines, and query the copied decision engine. Use when the agent needs semantic lookup, traceable citations, or decision-history retrieval.
---

# Doctrine Engine

High-signal retrieval layer for Substack doctrine, textbook, and decision memory.

## Paths

- Bible root: `/data/workspace/memory/alma-teachings/`
- Decision engine mirror: `/data/workspace/memory/decision-engine/`
- Primary index: `/data/workspace/memory/alma-teachings/bible/_manifest/manifest.json`

## Commands

### Rebuild index

```bash
scripts/rebuild_index.py
```

### Semantic search (ranked)

```bash
scripts/search_bible.py --query "fomc pivot invalidation"
scripts/search_bible.py --query "opex sentiment risk" --top 8
python scripts/search_substack_teachings.py --query "window of risk left-tail"
python scripts/search_substack_teachings.py --query "opex pce cpi" --post-type weekly --top 12
```

### Citation extraction

```bash
scripts/cite_doctrine.py --doc bible-v3 --query "event pressure"
scripts/cite_doctrine.py --path /data/workspace/memory/alma-teachings/textbook/NATE_TEXTBOOK_v3_AGENT_EDITION.md --query "daily method"
```

### Decision engine query

```bash
scripts/query_decision_engine.py --query "railway auth token"
scripts/query_decision_engine.py --query "openclaw deployment" --top 10
```

## Output Contract

When using this skill in agent replies:

1. Start with direct answer.
2. Include 1-3 citation bullets with file path + line numbers.
3. If confidence is low, say what is missing and run another query.

## Substack Teaching Lookup

For corpus-level retrieval across `memory/alma-teachings/substack/*.md`:

- Tool: `scripts/search_substack_teachings.py`
- Supports:
  - semantic alias expansion (`vix` -> `volatility`, `fomc` -> `fed rates` cluster, etc.)
  - post-type filters (`intraday`, `weekly`, `educational`, `monthly`)
  - optional index rebuild and machine JSON output

Example:

```bash
python scripts/search_substack_teachings.py --query "tariff war volatility" --post-type intraday --top 10 --json
```

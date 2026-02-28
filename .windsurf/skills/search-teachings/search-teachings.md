---
name: search-teachings
description: Search Nate's doctrine bible for teachings from Alma (Stochastic Volatility Trader). Use when any agent needs to find market analysis, volatility framework teachings, geopolitical risk analysis, options positioning breakdowns, macro/Fed analysis, or educational content from Alma's Substack corpus. Triggers include questions about volatility, Greeks, OpEx, FOMC, risk frameworks, geopolitics, AI bubble, carry trade, spot decay, or any reference to "Alma", "doctrine", "bible", "teachings", or "Nate's analysis".
---

# search-teachings

Semantic search skill for retrieving teachings from Nate's doctrine bible.

## Source Corpus

- **Semantic index (PRIMARY)**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/doctrine-bible/bible-semantic-index.json`
- **Bible v2 (consolidated)**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/p4nthe0n-openfixer/05-artifacts/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`
- **Bible v2 (substack dir)**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/p4nthe0n-openfixer/06-nate-substack/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`
- **Bible root (if populated)**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/doctrine-bible/bible/`
- **Author**: Alma (Stochastic Volatility Trader on Substack)
- **Total posts indexed**: 35 documents with excerpts, topTerms, concepts, and source URLs
- **Content**: Options market analysis, macro/Fed, geopolitics, volatility Greeks, risk frameworks, educational theory
- **Live source**: All posts have `source` URLs pointing to `stochvoltrader.substack.com`

## Step 1: Load the Semantic Index

Read the index file to understand the corpus structure:

```
read_file C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/doctrine-bible/bible-semantic-index.json
```

The index contains:
- **`documents`**: 35 entries, each with `id`, `file`, `title`, `postType`, `concepts`, `topTerms`, `excerpt`, `teachingWeight`
- **`semanticClusters`**: 10 domain clusters with aliases and seed files
- **`aliasExpansionMap`**: Maps short queries to expanded search terms
- **`queryRecipes`**: Pre-built intent-to-query mappings

## Step 2: Identify Relevant Clusters

Match the user's query against the 10 semantic clusters:

| Cluster | Covers |
|---------|--------|
| `volatility-greeks` | Options Greeks, IV surface, skew, speed profile, vanna/vomma/gamma/charm/veta |
| `macro-rates-fed` | FOMC, Fed, Powell, CPI/PPI/PCE/GDP, yields, inflation, stagflation, QT |
| `opex-flows-positioning` | OpEx mechanics, dealer positioning, gamma exposure, CTA flows, VIX expiry |
| `geopolitics-policy` | China-US, tariffs, Iran, Russia-Ukraine, Board of Peace, oil, Middle East |
| `risk-framework` | Window of Risk, left-tail/right-tail, VaR, Sharpe, Sortino, crowded trades |
| `ai-bubble-crypto` | AI bubble, NVDA, tech valuation, Bitcoin, capex, passive flows |
| `educational-foundations` | Reflexivity (Soros), furu vs analyst, daily post guide, probability, Python course |
| `performance-community` | Performance reviews, prediction accuracy, testimonials, track record |
| `spot-decay-liquidity` | Spot decay mechanics, hidden QE, insider speculation, negative wealth effect |
| `carry-trade-fx` | Yen carry trade, USDJPY, BoJ, dedollarization, gold, crack spread |

## Step 3: Expand the Query

Use the `aliasExpansionMap` from the index to expand short terms:
- `vol` → `volatility, vix, implied vol, realized vol, iv`
- `greeks` → `gamma, vanna, vomma, theta, vega, charm, veta, zomma, color, speed`
- `fed` → `fomc, powell, rate cut, hawkish, dovish, dot plot, sep, qt`
- `opex` → `expiry, expo, vixpery, dealer positioning`
- `risk` → `window of risk, left-tail, right-tail, kurtosis, var, sharpe`
- `geo` → `geopolitical, china, tariff, iran, ukraine, russia, trump`
- `bubble` → `ai bubble, nvda, nvidia, capex, valuation, passive flows`
- `macro` → `cpi, ppi, pce, gdp, nfp, inflation, stagflation, yields`
- `fx` → `carry trade, yen, usdjpy, boj, dedollarization, gold, brent`
- `education` → `reflexivity, soros, probability, python, mean reversion`

## Step 4: Score and Rank Documents

For each document in `documents`:
1. **Concept match** (weight 3.5): Does the document's `concepts` array intersect with matched clusters?
2. **Term match** (weight 2.0): Do expanded query tokens appear in `topTerms`?
3. **Title match** (weight 2.8): Do query tokens appear in the document `title`?
4. **Teaching weight bonus**: `foundational` +1.0, `comprehensive` +0.8, `analytical` +0.5

Return the top 5 ranked documents.

## Step 5: Retrieve Full Content

For each top result, try these sources in order:

### Option A: Local bible files (if populated)
```
read_file C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/doctrine-bible/bible/{filename}
```

### Option B: Consolidated bible (always available)
```
grep_search --query "{topTerms from index}" --path C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/p4nthe0n-openfixer/05-artifacts/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md
```

### Option C: Use the index excerpt directly
The `excerpt` field in each document entry contains 200-300 chars of key content. Combined with `topTerms` and `concepts`, this is often sufficient to answer without reading the full file.

### Option D: Live Substack URL
Each document has a `source` URL pointing to the live post on `stochvoltrader.substack.com`. Use `read_url_content` if deeper content is needed.

## Step 6: Respond with Citations

Format the response as:

1. **Direct answer** to the user's question using Alma's teachings
2. **Citations** with file path and relevant excerpt
3. **Related teachings** the user might want to explore

### Citation format:
```
📖 Source: {title}
   File: OP3NF1XER/nate-alma/dev/memory/doctrine-bible/bible/{filename}
   URL: {source_url}
   Key insight: {relevant excerpt}
```

## Fallback: Python Script

If the agent has CLI access, the doctrine-engine script can also be used:

```bash
python C:/P4NTH30N/OP3NF1XER/nate-alma/dev/skills/doctrine-engine/scripts/search_substack_teachings.py --query "window of risk left-tail" --top 10
```

Or for bible-level search:

```bash
python C:/P4NTH30N/OP3NF1XER/nate-alma/dev/skills/doctrine-engine/scripts/search_bible.py --query "fomc pivot invalidation"
```

## Example Queries

- "What does Alma say about the window of risk?"
- "Find teachings on vanna and vomma mechanics"
- "How does Alma analyze OpEx positioning?"
- "What is Alma's view on the AI bubble?"
- "Explain Alma's speed profile framework"
- "What geopolitical risks does Alma track?"
- "How does Alma read the Fed?"
- "Find the Soros reflexivity lecture notes"
- "What is spot decay in Alma's framework?"
- "How does Alma use carry trade analysis?"

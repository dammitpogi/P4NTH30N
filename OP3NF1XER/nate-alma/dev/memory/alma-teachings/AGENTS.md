# Doctrine Bible Agent Index

This file is the operator-facing index for locating teachings in:

- `memory/alma-teachings/substack`

## Corpus Assimilation Snapshot

- Corpus root: `memory/alma-teachings/substack`
- Total markdown files indexed: `340`
- Post-type distribution:
  - `intraday`: 270
  - `weekly`: 45
  - `educational`: 17
  - `monthly`: 2
  - `other`: 6
- Common months found in titles/slugs: Jan -> Dec (full-year coverage)

## Semantic Retrieval Matrix

Use this matrix to map natural-language intent to high-signal query terms.

| Intent | Semantic expansion terms | Preferred filter | Seed examples |
|---|---|---|---|
| Volatility and Greeks | `volatility`, `vix`, `vanna`, `vomma`, `zomma`, `vega`, `gamma`, `theta`, `skew` | `intraday` + `weekly` | `unknown-date-what-is-volatility.md`, `unknown-date-what-is-vomma-supply-why-is-it-important-intraday-post-04-se.md`, `unknown-date-vix-downside-vomma-risk-remember-intraday-post-03-july.md` |
| Risk metrics and framework | `risk`, `var`, `beta`, `sharpe`, `sortino`, `left-tail`, `right-tail`, `window of risk` | `educational` first, then `intraday` | `unknown-date-the-concept-of-risk-var-beta-sharpe-sortino-etc.md`, `unknown-date-window-of-risk-has-just-opened-weekly-post-22-26-sept.md`, `unknown-date-thin-left-tail-intraday-post-06-oct.md` |
| Macro and rates | `fomc`, `fed`, `powell`, `boj`, `cpi`, `ppi`, `pce`, `yields`, `inflation`, `rates` | `weekly` + `intraday` | `unknown-date-pce-boj-rate-decision-weekly-post-20-23-jan.md`, `unknown-date-pce-release-intraday-post-05-dec.md`, `unknown-date-ppi-and-cpi-expectations-intraday-post-10-sept.md` |
| Event/OpEx flow | `opex`, `expo`, `dealer positioning`, `expiry`, `flows`, `vix expo` | `weekly` then nearest `intraday` | `unknown-date-weekly-post-feb17-21-opex-week.md`, `unknown-date-vix-expo-intraday-post-18-nov.md`, `unknown-date-where-does-the-money-go-opex-pt-2-inflation-intraday-post-18.md` |
| Geopolitics and policy shock | `china`, `tariff`, `war`, `ukraine`, `venezuela`, `geopolitical`, `bipolar world` | `weekly` + `intraday` | `unknown-date-tariff-war-bipolar-world-recession-weekly-post-31th-march-4t.md`, `unknown-date-us-vs-china-war-fed-intraday-post-09-april.md`, `unknown-date-ukrain-peace-deal-nope-intraday-post-25-nov.md` |
| Equity/AI/Crypto risk | `nvda`, `nvidia`, `ai bubble`, `bitcoin`, `btc`, `valuation` | `intraday` + `monthly` | `unknown-date-playing-the-ai-bubble-long-term-outlook.md`, `unknown-date-the-looming-risk-bitcoin-intraday-post-11-nov.md`, `unknown-date-nvda-er-gdp-pce-valuation-intraday-post-27-aug.md` |
| Educational foundations | `what is`, `concept`, `mean reversion`, `statistical arbitrage`, `reflexivity`, `python course` | `educational` | `unknown-date-statistical-arbitrage-mean-reversion-trading.md`, `unknown-date-quick-education-on-reflexivity-hidden-qe-plan-intraday-post-.md`, `unknown-date-python-course.md` |
| Performance and review | `performance review`, `year has passed`, `summary`, `monthly outlook`, `weekly post` | `weekly` + `monthly` | `unknown-date-review-of-one-year-s-performance-a-year-has-passed.md`, `2025-01-29-april-s-performance-review.md`, `unknown-date-july-monthly-outlook-vol-of-vol-supply-momentum-equilibrium-.md` |

## Query Recipes (Agent-Ready)

Use any of these directly with the doctrine tool:

- "What is Alma saying about `window of risk` and `left-tail` this month?"
- "Find `weekly` posts tying `OpEx` with `PCE` or `CPI`."
- "Show `educational` teachings on `VaR`, `Sharpe`, and `Sortino`."
- "Find `intraday` notes linking `tariffs` or `China` with `volatility`."
- "Locate `AI bubble` + `valuation` + `NVDA` risk framing."

## Efficient Index Design Notes (Web-Informed)

Applied implementation guidance from web research:

1. Hybrid retrieval (`lexical + semantic`) beats either mode alone for mixed exact-term + conceptual queries.
2. Reciprocal Rank Fusion (RRF) is a strong, simple merge strategy for multi-retriever ranking.
3. Metadata facets (post type, month, source URL) should be first-class filters before final ranking.
4. Keep index entries lightweight (title, source, tokens, concepts, excerpt) for fast local scans.

Sources reviewed:

- `https://docs.anyscale.com/rag/quality-improvement/retrieval-strategies`
- `https://opensearch.org/blog/introducing-reciprocal-rank-fusion-hybrid-search/`
- `https://www.paradedb.com/learn/search-concepts/reciprocal-rank-fusion`
- `https://www.ssw.com.au/rules/best-practices-for-frontmatter-in-markdown/`

## Tooling (Doctrine Engine)

Use:

- `skills/doctrine-engine/scripts/search_substack_teachings.py`

Examples:

```bash
python skills/doctrine-engine/scripts/search_substack_teachings.py --query "window of risk left-tail"
python skills/doctrine-engine/scripts/search_substack_teachings.py --query "opex pce cpi" --post-type weekly --top 12
python skills/doctrine-engine/scripts/search_substack_teachings.py --query "ai bubble valuation nvda" --json
```

Decision link: `DECISION_147`.

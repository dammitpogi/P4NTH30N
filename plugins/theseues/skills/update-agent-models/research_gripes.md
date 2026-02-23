# Benchmark Research Notes (Sanitized)

This file is a lightweight reference for benchmark source coverage.

## Covered Sources

- Artificial Analysis API: core reasoning/coding benchmark fields
- OpenRouter models API: context length
- Public leaderboards: SWE-bench Pro and SWE-bench Verified

## Policy

- No hardcoded API keys in docs or scripts.
- No proxy metric substitution unless explicitly approved.
- Prefer cached benchmark data in `model_benchmarks.json`.

## Operational Guidance

1. Refresh benchmark cache with controlled scripts or approved manual process.
2. Keep formulas in `bench_calc.json` as the scoring source of truth.
3. Run guard + optimize workflow after benchmark updates.

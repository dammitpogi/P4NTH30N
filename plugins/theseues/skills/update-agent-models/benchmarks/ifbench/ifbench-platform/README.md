# IFBench Platform (OpenRouter)

This directory wraps the upstream AllenAI IFBench repo for repeatable runs.

Upstream vendored repo: `vendor/IFBench` (git SHA recorded in each run).

## Quickstart (bash on Windows)

1) Create venv + install deps:

```bash
python -m venv .venv
source .venv/Scripts/activate
pip install -U pip
pip install -e vendor/IFBench
```

2) Configure OpenRouter:

```bash
cp .env.example .env
# edit .env and set OPENROUTER_API_KEY
```

3) Smoke test:

```bash
source .venv/Scripts/activate
python scripts/smoke_subset.py
```

4) Full run:

```bash
source .venv/Scripts/activate
bash scripts/run_ifbench.sh
```

Artifacts are written under `runs/`.

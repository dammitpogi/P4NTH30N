# IFBench Benchmark Platform Build Guide (API‑queried Trinity‑Mini) — with OpenRouter profile

This document is a **handoff-ready instruction set** for an agent to install, run, and operationalize **AllenAI IFBench** evaluation for **Trinity‑Mini** (or any OpenAI‑compatible chat API model). It builds a small “platform” around the official IFBench repo: repeatable runs, standardized configs, artifacts, and reports.

This version includes a **complete OpenRouter configuration profile** (base URL, auth, model IDs, and recommended attribution headers).

---

## Upstream references

### IFBench (AllenAI)
- IFBench repo: https://github.com/allenai/IFBench
- Response generator (OpenAI-compatible `/v1/chat/completions`): https://raw.githubusercontent.com/allenai/IFBench/main/generate_responses.py
- Example env file: https://raw.githubusercontent.com/allenai/IFBench/main/.env.example
- Evaluator entrypoint: https://raw.githubusercontent.com/allenai/IFBench/main/run_eval.py

### OpenRouter docs (OpenAI-compatible)
- Chat completions endpoint: https://openrouter.ai/docs/api/api-reference/chat/send-chat-completion-request
- Authentication (Bearer token): https://openrouter.ai/docs/api/reference/authentication
- App attribution headers (optional): https://openrouter.ai/docs/app-attribution
- Trinity Mini model page: https://openrouter.ai/Arcee%20AI%3A%20Trinity%20Mini
- Trinity Mini (free) API page: https://openrouter.ai/arcee-ai/trinity-mini%3Afree/api

---

## 1) Target deliverables (definition of “done”)

The agent should produce a repo (internal or public) named something like `ifbench-platform/` containing:

1) **Reproducible runner**
- One command to run a full IFBench evaluation against a configured API model.
- Supports resuming partially completed runs.
- Produces a consistent run directory with artifacts.

2) **Configuration system**
- `.env` support for secrets and basic parameters.
- Optional `config.yaml` overlay for non-secret defaults.

3) **Artifacts per run**
- `responses.jsonl` (model outputs)
- `eval_results_loose.jsonl` + `eval_results_strict.jsonl`
- `summary.json` (machine-readable headline metrics)
- `metadata.json` (model name, API base, timestamps, git SHAs, params)

4) **Ops hygiene**
- Never commits API keys.
- Logs errors (rate limits, timeouts) and continues with placeholders where needed.
- Clear documentation for running locally and in CI.

---

## 2) Assumptions and prerequisites

### Hardware / OS
- Any Linux host (Ubuntu 22.04+ recommended) or macOS.
- Network egress to your model endpoint (OpenRouter in this profile).

### Software
- `git`
- Python 3.10+ (3.11 recommended)
- `venv` support
- Optional but recommended: `uv` for faster dependency management.

---

## 3) High-level architecture

You’ll wrap the upstream IFBench repo rather than reinventing it:

- **Upstream IFBench repo** provides:
  - Prompt set (default path in `.env.example`): `data/IFBench_test.jsonl`
  - Response generation: `generate_responses.py` → OpenAI-style `POST {API_BASE}/chat/completions`
  - Scoring: `python -m run_eval` → writes strict + loose results and prints reports

- **Your platform wrapper** adds:
  - standardized run dirs + metadata
  - retry/backoff + rate limiting knobs (optional)
  - summary extraction
  - provider profiles (OpenRouter, etc.)

---

## 4) Repo layout (recommended)

Create a new repo:

```
ifbench-platform/
  README.md
  Makefile
  .gitignore
  .env.example              # template (no secrets)
  configs/
    default.env             # non-secret defaults
    openrouter.env.example  # OpenRouter profile (no secrets)
  runs/                     # outputs (gitignored)
  scripts/
    run_ifbench.sh
    smoke_subset.py
    summarize.py
    providers/
      generate_responses_openrouter.py  # optional helper (recommended)
  vendor/
    IFBench/                # git submodule pinned to commit
```

### Why use a pinned submodule?
IFBench can change over time. Pinning ensures your numbers are reproducible for audits.

---

## 5) Step-by-step build instructions

### Step A — Create repo + add IFBench

1) Initialize:
```bash
mkdir ifbench-platform && cd ifbench-platform
git init
```

2) Add IFBench as a submodule:
```bash
mkdir -p vendor
git submodule add https://github.com/allenai/IFBench vendor/IFBench
cd vendor/IFBench
git checkout main
cd ../..
```

3) Pin to a commit (required):
```bash
cd vendor/IFBench
git rev-parse HEAD
# copy SHA and record it in your README / metadata capture
cd ../..
git add .gitmodules vendor/IFBench
git commit -m "Add IFBench as pinned submodule"
```

---

### Step B — Python environment and dependencies

Create a venv in the platform repo (not in the submodule):

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r vendor/IFBench/requirements.txt
```

(Alternatively, if you use `uv`, you can `uv venv` + `uv pip install ...`.)

---

## 6) Provider profile: OpenRouter (Trinity‑Mini)

OpenRouter is **OpenAI‑compatible** and exposes chat completions at:

- `https://openrouter.ai/api/v1/chat/completions`

So you set:
- `API_BASE=https://openrouter.ai/api/v1` (note: ends in `/v1`)
- Requests authenticate via `Authorization: Bearer <token>`

OpenRouter also supports **optional attribution headers**:
- `HTTP-Referer` (your app/site URL)
- `X-Title` (your app name)
These are optional but recommended for attribution/analytics.

### Step C — `.env` (OpenRouter)

1) Create `.env` from IFBench’s template:
```bash
cp vendor/IFBench/.env.example .env
```

2) Edit `.env` to use OpenRouter:

```bash
# OpenRouter
API_BASE="https://openrouter.ai/api/v1"
API_KEY="sk-or-REDACTED"

# Model IDs (pick ONE)
MODEL="arcee-ai/trinity-mini"
# MODEL="arcee-ai/trinity-mini:free"

# Reproducible eval settings (recommended)
TEMPERATURE=0
MAX_TOKENS=4096
WORKERS=8

# If your provider rejects seed, blank it:
SEED=
```

**Model IDs**
- Paid: `arcee-ai/trinity-mini`
- Free: `arcee-ai/trinity-mini:free`

(Keep both in a provider example file like `configs/openrouter.env.example` but never commit `API_KEY`.)

### Step D — Add OpenRouter attribution headers (recommended)

**Option 1 (recommended): add a provider-specific generator helper without modifying the submodule**

Create `scripts/providers/generate_responses_openrouter.py` by copying upstream `vendor/IFBench/generate_responses.py` and applying a minimal patch:
- Add environment variables:
  - `OPENROUTER_HTTP_REFERER`
  - `OPENROUTER_X_TITLE`
- When building the request headers, include:
  - `HTTP-Referer: <OPENROUTER_HTTP_REFERER>`
  - `X-Title: <OPENROUTER_X_TITLE>`

Then add to `.env` (non-secret):
```bash
OPENROUTER_HTTP_REFERER="https://yourcompany.example"
OPENROUTER_X_TITLE="IFBench Runner"
```

**Option 2: patch headers in your wrapper script**
If upstream `generate_responses.py` already exposes a way to pass extra headers (or you refactor it locally), you may inject these there instead. The key requirement is that the outgoing HTTP request includes the two optional headers.

---

## 7) Wrapper scripts

### D1) `scripts/run_ifbench.sh`

This should:
- create a unique run id
- snapshot config + git SHAs
- run response generation (OpenRouter profile)
- run evaluation (strict+loose)
- run summarizer

**Required behavior:**
- Create run directory:
  - `runs/YYYYMMDD_HHMMSS_<model_sanitized>/`
- Snapshot:
  - `.env` → `runs/.../env.snapshot` (redact `API_KEY`!)
  - `vendor/IFBench` SHA
  - platform repo SHA
- Run generation with resume:
  - Use upstream generator OR the OpenRouter helper generator
- Run evaluation:
  - `python -m run_eval --input_data=<...> --input_response_data=<...> --output_dir=<...>`

Recommended run command (OpenRouter profile, using the helper generator):
```bash
python scripts/providers/generate_responses_openrouter.py   --temperature "${TEMPERATURE:-0}"   --max-tokens "${MAX_TOKENS:-4096}"   --workers "${WORKERS:-8}"   --resume
```

### D2) `scripts/smoke_subset.py`

Purpose: validate API compatibility before spending time/cost on full IFBench.

Behavior:
- Read first N lines from `vendor/IFBench/data/IFBench_test.jsonl`
- Write `runs/.../IFBench_smoke.jsonl`
- Call generator against the smoke input
- Run eval and confirm it completes

### D3) `scripts/summarize.py`

Purpose: produce a stable `summary.json` for dashboards.

Implementation guideline:
- Parse the loose + strict eval JSONL outputs written by `run_eval.py`
- Compute:
  - `accuracy_loose`, `accuracy_strict`
  - count of evaluated prompts
  - count of blank responses / generation errors
  - run duration
- Output: `runs/.../summary.json`

---

## 8) Makefile (one-command usage)

Create a `Makefile` with targets:

- `make venv` → create venv + install deps
- `make smoke` → run subset
- `make run` → full IFBench run
- `make clean` → remove `.venv` and/or `runs/` (optional)

---

## 9) Running the platform (OpenRouter)

### Smoke test
```bash
source .venv/bin/activate
make smoke
```

Acceptance criteria:
- Confirms `POST https://openrouter.ai/api/v1/chat/completions` works with Bearer auth.
- Produces smoke run artifacts and a `summary.json`.

### Full benchmark run
```bash
source .venv/bin/activate
make run
```

This should generate `responses.jsonl` and evaluate both strict and loose.

---

## 10) What metrics to report (standardized)

Report **both**, but lead with **loose**:

- `IFBench_loose_prompt_accuracy` (primary)
- `IFBench_strict_prompt_accuracy` (secondary)
- Include generation params (temperature, max_tokens, seed if used) + model id + provider.

---

## 11) Reliability & cost controls (OpenRouter-friendly)

1) **Concurrency**
- IFBench generator supports `--workers` for parallel calls. Start modestly (e.g., 4–8) and tune.

2) **Retries/backoff**
- Implement retries in the wrapper:
  - retry 429/5xx with exponential backoff
  - lower `WORKERS` on sustained 429s

3) **Resume everywhere**
- Always run generator with `--resume`.

4) **Record partial failures**
- Treat API failures as empty responses, count them in `summary.json`, and keep eval running.

---

## 12) Troubleshooting (OpenRouter)

1) **401 Unauthorized**
- Confirm `Authorization: Bearer <API_KEY>` and that your key has credits/permissions.

2) **404 or 405**
- Confirm `API_BASE=https://openrouter.ai/api/v1` and endpoint `/chat/completions`.

3) **Provider rejects `seed`**
- Blank `SEED` in `.env` so it’s omitted (or update generator to only send `seed` when set).

4) **Attribution not showing**
- Ensure `HTTP-Referer` and `X-Title` headers are being sent.

---

## 13) Final handoff checklist for the agent

- [ ] `ifbench-platform` repo created
- [ ] IFBench submodule pinned to SHA (recorded)
- [ ] OpenRouter profile file created: `configs/openrouter.env.example`
- [ ] `make venv`, `make smoke`, `make run` all work
- [ ] Run artifacts produced under `runs/`
- [ ] `summary.json` includes strict + loose accuracies
- [ ] Secrets never committed; `.env` gitignored; snapshots redacted
- [ ] README includes exact commands and expected outputs

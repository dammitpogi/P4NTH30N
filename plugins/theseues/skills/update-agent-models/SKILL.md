---
name: update-agent-models
description: Locked, deterministic agent model optimization for oh-my-opencode-theseus.json using bench_calc.json and cached benchmarks.
---

# Update Agent Models Skill

This skill owns automated model-chain optimization for:
- `C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json`

It is designed for agent reliability, deterministic output, and future-safe maintenance.

Important execution model:
- Scripts are **proposal-only** and must never write config files directly.
- Final config edits are applied by an agent after reviewing generated proposals.
- Ignore-list updates require explicit user approval; agents/scripts must never auto-add entries.
- Unresolved benchmark coverage must follow research -> approval; do not bypass this gate.

## Source of Truth

- Scoring formulas: `skills/update-agent-models/bench_calc.json`
- Benchmark cache: `skills/update-agent-models/model_benchmarks.json`
- Verified model availability: `skills/update-agent-models/working_models.json`
- Dynamic benchmark cache: `skills/update-agent-models/model_benchmarks.json`
- User-approved manual benchmark additions: `skills/update-agent-models/benchmark_manual_accepted.json`
- User-approved ignore list for unbenchmarked models: `skills/update-agent-models/model_ignore_list.json`
- OpenAI budget policy: `skills/update-agent-models/openai_budget_policy.json`
- Manual OpenAI limit snapshot (UI values): `skills/update-agent-models/openai_limits_manual.json`
- Api Keys: `C:\Users\paulc\.local\share\opencode\auth.json`

No script should invent alternative scoring logic.
Candidate pool is dynamic from current chains + dynamically pulled working models.
`free/openrouter/free` is a reserved bridge model: keep it directly before the local fallback model (`lmstudio-local/*`) and exclude it from benchmark-research decisions.
Optimizer also applies OpenAI budget-aware score penalties using latest OpenAI budget proposal snapshot.
Missing benchmark coverage is a hard failure in strict mode.
Synthetic/hardcoded benchmark injection is forbidden.

## Authoritative Workflow

1. Guard pre-checks:
   - `node skills/update-agent-models/guard.js --strict`
2. Refresh working models:
   - `bash skills/update-agent-models/test-models.sh`
   - Agent execution note: this step is long-running; use a shell timeout of at least 420000 ms (7 minutes).
3. Refresh OpenAI usage budget proposal:
   - `node skills/update-agent-models/openai-budget.js`
4. Research missing benchmark coverage:
   - `node skills/update-agent-models/research-benchmarks.js`
   - Default is one-model-at-a-time decision workflow
   - Optional full sweep: `node skills/update-agent-models/research-benchmarks.js --batch`
   - Optional targeted model: `node skills/update-agent-models/research-benchmarks.js --focus-model <provider/model>`
5. Interview gate (required):
   - `node skills/update-agent-models/apply-auto-accepted.js`
   - `node skills/update-agent-models/next-interview.js`
   - If exit code is 2, workflow is at the normal user decision gate for the current model
   - If exit code is 3, workflow is at the normal research gate (gather more evidence before interviewing user)
6. One-at-a-time continuation rule:
   - If `remaining_after_scope > 0`, stop and rerun workflow for the next model
7. Optimize chains:
   - `node skills/update-agent-models/optimize.js --strict --explain`
8. Guard post-checks:
   - `node skills/update-agent-models/guard.js --strict`

By default, optimization runs in proposal mode (no direct config write).
There is no script apply mode.

## One-Command Workflow

- Full run:
  - `node skills/update-agent-models/run-workflow.js`
- Dry-run optimization path:
  - `node skills/update-agent-models/run-workflow.js --dry-run`
- OpenAI-only fast path (budget-tier adjustment, skips research/interview):
  - `node skills/update-agent-models/run-workflow.js --openai-only`
  - Trigger phrase: "update agent models for OpenAI" should always use this path.
- Google-only fast path (Gemini quota/rate-limit adjustment, skips research/interview):
  - `node skills/update-agent-models/run-workflow.js --google-only`
  - Trigger phrases: "Update Gemini Agent Models" or "Update Google Agent Models" should always use this path.
- Keep latest N artifacts (default 5):
  - `node skills/update-agent-models/run-workflow.js --keep 5`
- Skip model testing step (not recommended):
  - `node skills/update-agent-models/run-workflow.js --skip-model-refresh`
- Force fresh benchmark research proposal:
  - `node skills/update-agent-models/run-workflow.js --refresh-research`
- Apply optimized changes:
  - Use an agent-reviewed edit step using the latest proposal file in `skills/update-agent-models/proposals/`.

## Scripts

- `optimize.js`
  - Deterministically reorders each agent chain
  - Updates both `agents.*.model` and `fallback.currentModels.*`
  - Enforces constraints:
    - `fixer` primary is `anthropic/claude-opus-4-6`
    - Anthropic is only allowed as `fixer` index 0 (`anthropic/claude-opus-4-6`)
    - each role keeps at most one OpenAI model
    - OpenAI model choice is tier-limited by budget stage (healthy -> medium -> low -> critical)
    - as remaining usage decreases, lower-cost OpenAI tiers are preferred automatically
    - scored models stay quality-sorted (index 0 highest score, except fixed fixer primary rule)
    - chain tail is reserved bridge + local fallback: `free/openrouter/free`, then `lmstudio-local/*`
  - Writes run report to `skills/update-agent-models/reports/`
  - Writes proposal payload to `skills/update-agent-models/proposals/`
  - Fails strict mode if any candidate model lacks benchmark coverage

- `guard.js`
  - Validates formulas, constants, role coverage, and schema assumptions
  - Validates AA provider config exists in `opencode.json`
  - Validates no legacy path drift and no hardcoded secrets in scripts
  - Validates target config constraints

- `test-models.sh`
  - Reads keys from `C:\Users\paulc\.local\share\opencode\auth.json`
  - Tests available provider models and writes a proposal file in `skills/update-agent-models/proposals/`
  - This can take several minutes; agents should run it with a long command timeout (>= 420000 ms)
  - Agent reviews and applies updates to `working_models.json`

- `status.js`
  - Prints current primaries and last run report pointer

- `suggest-unmatched.js`
  - Reads latest optimize report and emits unresolved model list for benchmark research workflow

- `prune-artifacts.js`
  - Prunes old backups/reports
  - Also prunes old proposals

- `openai-budget.js`
  - Queries Codex App Server rate limits API in ChatGPT auth mode (`account/rateLimits/read`) when `codex app-server` is available
  - Uses manual limits snapshot only if Codex rate-limits API is unavailable
  - Does not use OpenAI usage API
  - Reads 5-hour/weekly remaining percentages from `openai_limits_manual.json` (or CLI flags)
  - Computes one budget health stage from separate 5-hour/weekly thresholds:
    - critical: 5-hour <= 10% OR weekly <= 10%
    - low: 5-hour <= 25% OR weekly <= 20%
    - medium: 5-hour <= 50% OR weekly <= 30%
    - otherwise healthy
  - Provides remaining allowance context so optimizer can reduce OpenAI preference when budget is tight

- `google-health.js`
  - Tests Google models currently present in agent chains via Gemini API
  - Detects quota-limited models and writes `google-health.*.json` proposal
  - Provides Google health stage so optimizer can reduce or suppress unhealthy Google models quickly

- `research-benchmarks.js`
  - Detects missing benchmark coverage for pulled models
  - Queries Artificial Analysis API (`/llms/models`) to research missing models
  - Emits a benchmark research proposal requiring explicit user acceptance
  - Runs one model at a time by default to support user review cadence
  - If unresolved coverage remains, emits manual research tasks and fails

- `next-interview.js`
  - Reads latest benchmark research proposal
  - Emits exactly one model decision prompt at a time
  - Prints evidence package (sources + benchmark snapshot) for the current model
  - If confidence is low, directs the agent to continue research before interviewing the user
  - Emits a required agent playbook + response schema for the user-facing decision message
  - Blocks workflow progression until user decision is recorded

- `apply-auto-accepted.js`
  - Syncs `autoAccepted=true` entries from latest benchmark research proposal into `benchmark_manual_accepted.json`
  - Must run before optimization so accepted benchmark set is complete and auditable

Acceptance gate:
- High-confidence non-stealth mappings are auto-accepted from the latest research proposal.
- Researched benchmark entries must be approved by user before being copied to `benchmark_manual_accepted.json`.
- **NEVER auto-add models to `model_ignore_list.json` - explicit user approval is required first.**
- The workflow will pause when user decisions are required. Do not proceed until the user has decided.
- Scripts must not auto-add to `model_ignore_list.json`.
- Agents must not ask generic "how should we proceed" prompts; they must present evidence and ask user to accept, deny, or provide guidance.

Interview contract (required):
- Research first, model-by-model (AA API -> web -> backend mapping if needed).
- Present evidence bundle: sources, attempted queries, mapping hypothesis, proposed benchmarks/confidence.
- Ask exactly one decision question: Approve, Deny, Ignore List, or Instructions.
- Never summarize unresolved models as a bulk "add all to ignore list" recommendation.

## Decision Choices
- **Approve**: Accept researched benchmarks and add to `benchmark_manual_accepted.json`.
- **Deny**: Skip the model for the current optimization run. This is handled via the `--deny <model>` CLI flag and is NOT stored permanently.
- **Ignore List**: Permanently exclude the model by adding it to `model_ignore_list.json`.
- **Instructions**: Provide manual values or general guidance.

## Research Pipeline (API -> Web -> Rumor)

`research-benchmarks.js` covers the AA API phase and produces a proposal with:
- researched benchmark payloads (with confidence and auto-accept flag)
- unresolved models + suggested web/rumor queries

For unresolved models, the agent must continue research in this order:

1) Artificial Analysis API (script)
   - `node skills/update-agent-models/research-benchmarks.js`

2) Web search (agent)
   - Use web search tools to find credible benchmark tables or official model specs.
   - Capture URLs and extracted benchmark values into the next proposal, then interview user.

3) Rumor mills / stealth mapping (agent)
   - Only for stealth/cloaked models where the provider model ID does not map 1:1.
   - Identify likely backing model using multiple credible sources.
   - Present mapping + evidence and ask user to approve.

If benchmarks remain unknown after research:
- user can approve adding model to `model_ignore_list.json` (agent can apply the approved edit).

Workflow efficiency rule:
- `test-models.sh` runs every workflow execution to verify current model health and discover new models.
- Use `--skip-model-refresh` only for debugging/local iteration where stale model health is acceptable.
- If interview decisions are pending, workflow reuses latest research proposal and does not rerun research until decisions are resolved.
- Use `--openai-only` when the request is specifically to adjust OpenAI model tiering from usage/rate limits.
- Use `--google-only` when the request is specifically to mitigate Gemini per-model quota/rate-limit issues.

## Optimize Options

- `--dry-run` no write
- `--strict` fail on unscored chains or any missing benchmark coverage
- `--explain` print top scoring models per agent
- `--no-backup` skip backup creation
- `--no-report` skip report output

### One-time benchmark proxies

If you want to temporarily inject a benchmark value derived from a proxy algorithm (without treating it as “real research”), use a **one-time proxy proposal**:

Research-first rule:
- Proxies are only allowed after running the benchmark research workflow.
- A proxy may only cover models that appear in the **latest** `benchmark-research.*.json` proposal (pending/unresolved coverage).

- Create a proposal file under `skills/update-agent-models/proposals/` named `benchmark-proxy.<timestamp>.json`
  - The file must include `one_time=true`.
  - See template: `skills/update-agent-models/proposals/benchmark-proxy.example.jsonc`
- Run optimization with:
  - `node skills/update-agent-models/optimize.js --strict --explain --use-proxy`
  - or `node skills/update-agent-models/run-workflow.js --use-proxy`

Safety guarantees:
- Proxy proposals are applied **in-memory only** during scoring.
- They are **not** copied into `model_benchmarks.json` or `benchmark_manual_accepted.json`.
- After a successful run, the proxy proposal is automatically renamed to `consumed.*.benchmark-proxy.*.json` so it cannot be reused accidentally.

## Keys and Provider Configuration

- API keys are read from:
  - `C:\Users\paulc\.local\share\opencode\auth.json`
- Artificial Analysis provider should be configured in:
  - `C:\Users\paulc\.config\opencode\opencode.json`
  - Use env ref: `{env:ARTIFICIAL_ANALYSIS_API_KEY}`

### IFBench (manual benchmark runs)

Some providers/models do not publish IFBench results. In that case we run IFBench ourselves and then record the resulting metric via the normal acceptance workflow.

- Runner scaffold lives at: `skills/update-agent-models/benchmarks/ifbench/ifbench-platform/`
- Setup + run instructions live at:
  - `skills/update-agent-models/benchmarks/ifbench/instructions.md`
  - `skills/update-agent-models/benchmarks/ifbench/ifbench-platform/README.md`
- **API key requirement (OpenRouter):** provide a key at runtime via `OPENROUTER_API_KEY` (preferred) or `API_KEY`.
  - Do not commit keys; keep them in your environment (or local `.env` that is gitignored).

## Maintenance Rules

- If algorithms change, update `bench_calc.json` and rerun full workflow.
- Keep role weights summing to `1.0`.
- Keep formulas normalized using constants for mixed metric scales.
- Never manually reorder chains in `oh-my-opencode-theseus.json`.

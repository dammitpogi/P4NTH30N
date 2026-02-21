# Tool Output: tool_c7a80c63f001vA1KMV16ry0vsv
**Date**: 2026-02-20 10:03:05 UTC
**Size**: 52,156 bytes

```
<skill_content name="update-agent-models">
# Skill: update-agent-models

# Update Agent Models Skill (HARDENED MODE)

This skill owns automated model-chain optimization for:
- `C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json`

API Keys if needed are in these two json configs.
- `C:\Users\paulc\.local\share\opencode\auth.json`
- `C:\Users\paulc\.config\opencode\opencode.json`

## HARDENED MODE - Critical Changes

This skill operates in **HARDENED MODE** with the following strict requirements:

### No Auto-Approval
- **NO models are automatically approved** - regardless of confidence score
- Every model must go through the full research pipeline
- Every model requires **explicit user approval** before being added to `benchmark_manual_accepted.json`

### All Benchmarks Required
- Every model **MUST have ALL 16 benchmarks** to be approved:
  1. gpqa - Graduate-Level Google-Proof Q&A
  2. mmlu_pro - Massive Multitask Language Understanding Professional
  3. intelligence_index - Overall intelligence score
  4. ifbench - Instruction Following Benchmark
  5. context_length - Maximum context window size
  6. tau2 - Tau-squared efficiency metric
  7. gdpval_aa_elo - Artificial Analysis GDPval ELO rating
  8. aime - AI Mathematical Evaluation
  9. math_index - Mathematical capability index
  10. hle - Humanity's Last Exam
  11. terminalbench_hard - Terminal interaction benchmark
  12. coding_index - Coding capability index
  13. swe_bench_pro - Professional software engineering tasks
  14. swe_bench_verified - Verified software engineering tasks
  15. livecodebench - Live coding performance
  16. scicode - Scientific code generation

### Agent-Specific Scoring Algorithms

**CRITICAL:** Different agent roles have different benchmark priorities and scoring formulas. See `bench_calc.json` for complete algorithm definitions.

**Agent Types and Priorities:**

1. **Orchestrator** - Strategic coordination, parallel delegation, workflow orchestration
   - Key benchmarks: GDPval-AA ELO (25%), gpqa (20%), mmlu_pro (15%), ifbench (15%), context_length (15%)
   - Scoring: Balances strategic decision-making with context handling capabilities

2. **Oracle** - Architectural guidance and complex debugging
   - Key benchmarks: gpqa (50%), aime (20%), math_index (15%), mmlu_pro (10%), hle (5%)
   - Scoring: Emphasizes advanced reasoning and problem-solving abilities

3. **Explorer** - Codebase discovery and pattern matching
   - Key benchmarks: terminalbench_hard (40%), tau2 (25%), context_length (15%), mmlu_pro (10%), hle (5%)
   - Scoring: Prioritizes speed, efficiency, and computer interaction

4. **Librarian** - Context gathering, synthesis, and writing tasks
   - Key benchmarks: hle (30%), context_length (25%), mmlu_pro (15%), intelligence_index (10%), ifbench (10%)
   - Scoring: Focuses on comprehensive knowledge retrieval and synthesis capabilities

5. **Designer** - Implementation planning and architectural design
   - Key benchmarks: GDPval-AA ELO (30%), gpqa (25%), mmlu_pro (15%), hle (10%), ifbench (10%)
   - Scoring: Balances strategic planning with research and design capabilities

6. **Fixer** - Development, implementation, and workflow success
   - Key benchmarks: SWE-bench Pro (22%), SWE-bench Verified (18%), livecodebench (15%), gpqa (7%), coding_index (10%)
   - Scoring: Emphasizes coding excellence, development capability, and tool interaction

7. **Builder** - Code generation and verification (bypasses full workflow)
   - Key benchmarks: SWE-bench Pro (30%), SWE-bench Verified (25%), livecodebench (15%), coding_index (10%)
   - Scoring: Focuses on code generation and verification capabilities

**Algorithm Application:**
- All benchmarks are normalized to 0–1 scale before scoring (see "Benchmark Normalization" above)
- Each agent uses a weighted sum formula combining its prioritized benchmarks
- Formulas are defined in `bench_calc.json` under `model_selection_benchmarks.<agent>.scoring_algorithm`

### Strict Phase Enforcement
Every model must progress through ALL phases in order:
1. **Artificial Analysis API** - Initial research
2. **ToolHive Web Search** - Research remaining missing benchmarks
3. **SWE-Bench-Pro Proxy** (for SWE-Bench-Pro only) - ML-based estimation when direct benchmarks unavailable
4. **User Interview Gate** - REQUIRED - no exceptions

**Note on Local Benchmarks:**
- **IFBench, MMLU-Pro, GPQA**: Can be run locally via lm-evaluation-harness
- **SWE-Bench-Pro**: Local execution NOT AVAILABLE - requires extensive compute resources (1,865 tasks, complex harness)
- For SWE-Bench-Pro gaps, use the **SWE-Bench-Pro Proxy** after exhausting web research

### Execution Model
- Scripts are **proposal-only** and must never write config files directly
- Final config edits are applied by an agent after reviewing generated proposals
- Ignore-list updates require explicit user approval; agents/scripts must never auto-add entries
- **Models with incomplete benchmarks CANNOT be approved** - must continue research

## Source of Truth

- **Scoring formulas & agent algorithms**: `skills/update-agent-models/bench_calc.json`
- **Benchmark normalization instructions**: `skills/update-agent-models/benchmark_normalization_instructions.md`
- Benchmark cache: `skills/update-agent-models/model_benchmarks.json`
- Verified model availability: `skills/update-agent-models/working_models.json`
- Dynamic benchmark cache: `skills/update-agent-models/model_benchmarks.json`
- User-approved manual benchmark additions: `skills/update-agent-models/benchmark_manual_accepted.json`
- User-approved ignore list for unbenchmarked models: `skills/update-agent-models/model_ignore_list.json`
- Research strategy and data sources: `skills/update-agent-models/research-plan.md`
- OpenAI budget policy: `skills/update-agent-models/openai_budget_policy.json`
- Manual OpenAI limit snapshot (UI values): `skills/update-agent-models/openai_limits_manual.json`
- **Provider cost configuration**: `skills/update-agent-models/provider_cost_config.json`
- **Model cost cache**: `skills/update-agent-models/model_costs.json`
- Api Keys: `C:\Users\paulc\.local\share\opencode\auth.json`

## Benchmark Normalization (REQUIRED)

**CRITICAL:** All benchmark data must be normalized to a common 0–1 scale before scoring algorithms are applied. This ensures fair comparison across different metric types (percentages, Elo ratings, token counts, index scores).

### Normalization Rules

**Reference:** See `benchmark_normalization_instructions.md` for detailed normalization specifications.

**Constants Used for Normalization:**
- `MAX_CONTEXT_LENGTH = 2,000,000` tokens
- `MAX_GDPVAL_AA_ELO = 2000`
- `MAX_INDEX_SCORE = 100`
- `MAX_PERCENT_SCORE = 100`

**Global Rules:**

1. **Clamp to [0, 1]:** After normalization, always clamp values to ensure they're within valid range:
   ```javascript
   clamp01(x) = max(0, min(1, x))
   ```

2. **Handle Percent vs Fraction:** For accuracy/rate metrics that might be 0–1 or 0–100:
   - If value > 1, treat as percent and divide by 100
   - Else, treat as already a fraction

3. **Cap Scale Metrics:** For metrics like context length and Elo, cap at maximum before dividing to prevent outliers:
   ```javascript
   norm = min(raw_value, MAX) / MAX
   ```

### Benchmark-Specific Normalization

**Accuracy/Rate Metrics (0–1 or 0–100):**
- gpqa, mmlu_pro, ifbench, tau2, hle, terminalbench_hard, livecodebench, scicode, swe_bench_pro, swe_bench_verified

```javascript
// Example for GPQA
gpqa_norm = (gpqa / 100) if gpqa > 1 else gpqa
gpqa_norm = clamp01(gpqa_norm)
```

**Index Metrics (0–100):**
- intelligence_index, math_index, coding_index

```javascript
// Example for intelligence_index
intelligence_index_norm = clamp01(intelligence_index / MAX_INDEX_SCORE)
```

**Scale Metrics:**
- context_length, GDPval-AA ELO

```javascript
// Example for context_length
context_length_norm = min(context_length, MAX_CONTEXT_LENGTH) / MAX_CONTEXT_LENGTH
context_length_norm = clamp01(context_length_norm)
```

**Special Case: AIME**
- Can be percent (0–100), fraction (0–1), or raw correct out of 15

```javascript
// If percent or fraction
aime_norm = (aime / 100) if aime > 1 else aime
aime_norm = clamp01(aime_norm)

// If raw correct out of 15
aime_norm = clamp01(aime_correct / 15)
```

### Normalization Validation

Before applying scoring weights, verify:
1. Every normalized value exists for the model (`*_norm`)
2. Every `*_norm` is in [0, 1] after clamping
3. No benchmark is accidentally double-divided (e.g., treating 0.73 as 73%)
4. Token and Elo metrics are capped before dividing

### Normalization in Workflow

The optimization workflow automatically applies normalization during scoring:
1. Raw benchmark data is read from `model_benchmarks.json` and `benchmark_manual_accepted.json`
2. Each benchmark is normalized according to `benchmark_normalization_instructions.md`
3. Normalized values are used in agent-specific scoring formulas from `bench_calc.json`
4. Final scores are compared to determine optimal model chains

### Cost-Aware Optimization (NEW)

The skill now includes **cost data** alongside benchmarks for cost-aware model optimization:

**Provider Billing Types:**
- **subscription** - Fixed fee, unlimited usage within tier limits (e.g., OpenCode Pro)
- **api_credits** - Pay per token consumed (e.g., OpenAI, Anthropic, Google Vertex)
- **local** - Zero API cost, local hardware only (e.g., LM Studio)

**Cost Data Structure:**
- `input_cost` - Cost per 1 million input tokens (USD)
- `output_cost` - Cost per 1 million output tokens (USD)
- `billing_type` - Provider's billing model
- `provider` - Provider name
- `last_confirmed` - Timestamp of user confirmation
- `source` - provider_default | user_override

**Cost Display in Interviews:**
During the user interview gate, cost information is now displayed alongside benchmarks:
- Current cached cost (if available)
- Provider default cost (for comparison)
- Billing type and provider notes
- Numbered confirmation options (1a, 1b, 1c format)

**Provider Billing Type Confirmation (REQUIRED):**
Before proceeding with model approvals, the agent MUST present ALL configured providers and their billing types in numbered format:

```
PROVIDER BILLING TYPES:
1. anthropic - api_credits [1a] Confirm [1b] Change to subscription [1c] Change to local
2. openai - api_credits [2a] Confirm [2b] Change to subscription [2c] Change to local
3. google-vertex - api_credits [3a] Confirm [3b] Change to subscription [3c] Change to local
4. opencode - subscription [4a] Confirm [4b] Change to api_credits [4c] Change to local
5. zai-coding-plan - subscription [5a] Confirm [5b] Change to api_credits [5c] Change to local
6. openrouter - api_credits [6a] Confirm [6b] Change to subscription [6c] Change to local
7. lmstudio-local - local [7a] Confirm [7b] Change to api_credits [7c] Change to subscription
8. free - local [8a] Confirm [8b] Change to api_credits [8c] Change to subscription

NEW PROVIDERS DETECTED:
9. huggingface - UNKNOWN [9a] api_credits [9b] subscription [9c] local
10. kimi-for-coding - UNKNOWN [10a] api_credits [10b] subscription [10c] local

Response: 1a, 2a, 3a, 4a, 5a, 6a, 7a, 8a, 9a, 10b
```

Rules:
- List ALL existing providers from `provider_cost_config.json`
- Mark any NEW providers not in config as "UNKNOWN" and ask user to specify
- Wait for user confirmation before proceeding
- User can approve all at once (e.g., "accept-all") or specify changes per provider

**Provider Billing Type Confirmation (REQUIRED):**
Before proceeding with model approvals, the agent MUST present ALL configured providers and their billing types in numbered format:

```
PROVIDER BILLING TYPES:
1. anthropic - api_credits [1a] Confirm [1b] Change to subscription [1c] Change to local
2. openai - api_credits [2a] Confirm [2b] Change to subscription [2c] Change to local
3. google-vertex - api_credits [3a] Confirm [3b] Change to subscription [3c] Change to local
4. opencode - subscription [4a] Confirm [4b] Change to api_credits [4c] Change to local
5. zai-coding-plan - subscription [5a] Confirm [5b] Change to api_credits [5c] Change to local
6. openrouter - api_credits [6a] Confirm [6b] Change to subscription [6c] Change to local
7. lmstudio-local - local [7a] Confirm [7b] Change to api_credits [7c] Change to subscription
8. free - local [8a] Confirm [8b] Change to api_credits [8c] Change to subscription

NEW PROVIDERS DETECTED:
9. huggingface - UNKNOWN [9a] api_credits [9b] subscription [9c] local
10. kimi-for-coding - UNKNOWN [10a] api_credits [10b] subscription [10c] local

Response: 1a, 2a, 3a, 4a, 5a, 6a, 7a, 8a, 9a, 10b
```

Rules:
- List ALL existing providers from `provider_cost_config.json`
- Mark any NEW providers not in config as "UNKNOWN" and ask user to specify
- Wait for user confirmation before proceeding
- User can approve all at once (e.g., "accept-all") or specify changes per provider

**Numbered Response Format:**
The interview now uses a numbered list format for cost confirmation:
```
1. anthropic/claude-opus-4-6
   Current: $15.00/$75.00 per 1M tokens (in/out) [PROVIDER DEFAULT]
   [1a] Confirm current cost is correct
   [1b] Set custom cost

2. openai/gpt-4o
   Current: $2.50/$10.00 per 1M tokens (in/out) [PROVIDER DEFAULT]
   ⚠️ Provider has updated costs: $5.00/$15.00
   [2a] Keep current cached cost
   [2b] Update to new provider default
   [2c] Set custom cost
```

Response examples:
- `1a, 2b, 3a` - Accept first, update second, accept third
- `accept-all` - Accept all provider defaults at once
- `skip-all` - Skip all uncached models
- `sync` - Sync all provider defaults without prompting

**Cost Change Detection:**
The system detects when provider costs change and prompts for re-confirmation:
- Compares cached costs with current provider defaults
- Alerts user if costs have increased or decreased
- User can keep current, update to new default, or set custom cost

**Scripts:**
- `provider-cost-lookup.js` - Query and manage model costs
- Usage: `node provider-cost-lookup.js --display-cached` - Show all costs for confirmation
- Usage: `node provider-cost-lookup.js --sync` - Sync provider defaults to cache
- Usage: `node provider-cost-lookup.js --model <id>` - Get cost for specific model

No script should invent alternative scoring logic.
Candidate pool is dynamic from current chains + dynamically pulled working models.
`free/openrouter/free` is a reserved bridge model: keep it directly before the local fallback model (`lmstudio-local/*`) and exclude it from benchmark-research decisions.
Optimizer also applies OpenAI budget-aware score penalties using latest OpenAI budget proposal snapshot.
Missing benchmark coverage is a hard failure in strict mode.
Synthetic/hardcoded benchmark injection is forbidden.

## Authoritative Workflow (HARDENED)

1. Guard pre-checks:
    - `node skills/update-agent-models/guard.js --strict`
2. Refresh working models:
    - `bash skills/update-agent-models/test-models.sh`
    - Agent execution note: this step is long-running; use a shell timeout of at least 420000 ms (7 minutes).
3. Refresh OpenAI usage budget proposal:
    - `node skills/update-agent-models/openai-budget.js`
4. **Phase 1 - AA API Research** (MANDATORY for all models):
    - `node skills/update-agent-models/research-benchmarks.js`
    - Default is one-model-at-a-time decision workflow
    - **NO AUTO-APPROVAL** - All models require explicit user approval
    - Tracks which of the 16 required benchmarks are present/missing
5. **Phase 2 - Local Benchmark Execution** (PRIORITIZED - faster than web search):
    - **Available for**: IFBench, MMLU-Pro, GPQA
    - **NOT available for**: SWE-Bench-Pro (requires extensive compute resources)
    - **IFBench**: Platform ready at `benchmarks/ifbench/ifbench-platform/`
    - **MMLU-Pro**: Platform ready at `benchmarks/mmlu_pro/mmlu-pro-platform/`
    - **GPQA**: Platform ready at `benchmarks/gpqa/gpqa-platform/`
    - **Run benchmarks**: `node skills/update-agent-models/run-benchmarks.js --model <provider/model> --benchmarks <comma-separated-list>`
    - **Rate Limiting**: 1-second cooldown between iterations
    - **Progress Updates**: User notified at each step
    - **Priority**: Run local benchmarks FIRST before web research (faster completion)
6. **Phase 3 - ToolHive Web Search** (for remaining missing benchmarks):
    - Use `toolhive-mcp-optimizer_find_tool` for web search
    - Search queries must target official sources (Hugging Face, GitHub, arXiv, provider docs)
    - Update proposal with findings via new proposal file
    - Only for benchmarks that cannot be run locally
7. **Phase 4 - SWE-Bench-Pro Proxy** (ONLY for SWE-Bench-Pro when web research fails):
    - Use trained ML proxy to estimate SWE-Bench-Pro from other 15 benchmarks
    - **Location**: `proxies/swe_bench_pro/`
    - **Script**: `python proxies/swe_bench_pro/swe_bench_pro_proxy.py`
    - **Requirements**: ≥8 anchor models with known Pro scores
    - **Usage**: See `proxies/swe_bench_pro/README.md`
    - **Output**: Creates proxy proposal for `--use-proxy` optimization
8. **Phase 5 - User Interview Gate** (REQUIRED - NO EXCEPTIONS):
    - `node skills/update-agent-models/next-interview.js`
    - **NO AUTO-ACCEPTANCE** - `apply-auto-accepted.js` is deprecated
    - Model CANNOT be approved until **ALL 16 benchmarks** are filled
    - If exit code is 2: Model has all benchmarks - user approval required
    - If exit code is 3: Missing benchmarks - continue research, do not ask for approval
9. One-at-a-time continuation rule:
    - If `remaining_after_scope > 0`, stop and rerun workflow for the next model
10. **Phase 6 - Benchmark Normalization** (AUTOMATIC - part of optimization):
    - All benchmark data is normalized to 0–1 scale per `benchmark_normalization_instructions.md`
    - Normalization handles: percent/fraction conversion, index scaling, Elo capping, context length capping
    - All normalized values are clamped to [0, 1]
    - Normalization is applied before scoring algorithms
11. **Phase 7 - Optimize chains**:
    - `node skills/update-agent-models/optimize.js --strict --explain`
    - Uses agent-specific scoring algorithms from `bench_calc.json`
    - Applies normalized benchmark values to scoring formulas
    - Generates optimization proposal
12. Guard post-checks:
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
  - **Applies benchmark normalization** to 0–1 scale before scoring (per `benchmark_normalization_instructions.md`)
  - **Uses agent-specific scoring algorithms** from `bench_calc.json`:
     - Orchestrator: Balances strategic decision-making with context handling
     - Oracle: Emphasizes advanced reasoning and problem-solving
     - Explorer: Prioritizes speed, efficiency, and computer interaction
     - Librarian: Focuses on knowledge retrieval and synthesis
     - Designer: Balances strategic planning with research and design
     - Fixer: Emphasizes coding excellence and development capability
     - Builder: Focuses on code generation and verification
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
  - **Note:** Normalization happens during optimization phase, not research

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

## Research Pipeline (MANDATORY: API -> ToolHive Web Search -> Manual Benchmarks -> User Interview)

**⚠️ HARD REQUIREMENT**: Agents MUST exhaust ALL automated research options before prompting the user. User interview is the LAST resort, not the first.

**Reference:** See `research-plan.md` for detailed benchmark research strategy, source hierarchy, and quality assurance checklist.

`research-benchmarks.js` covers the AA API phase and produces a proposal with:
- researched benchmark payloads (with confidence and auto-accept flag)
- unresolved models + suggested web/rumor queries

### Research Hierarchy (MUST follow in order):

1) **Artificial Analysis API** (automated script)
   - `node skills/update-agent-models/research-benchmarks.js`
   - Queries AA API for Tier 1-2 benchmarks (gpqa, mmlu_pro, ifbench, etc.)
   - Auto-accepts high-confidence mappings (≥0.85)

2) **ToolHive Web Search** (REQUIRED before user interview)
   - **MANDATORY**: Use `toolhive-mcp-optimizer_find_tool` to discover web search tools
   - Search for model benchmarks using queries like:
     - `"<model_name> benchmark GPQA MMLU"`
     - `"<model_name> hugging face evaluation results"`
     - `"<model_name> official benchmark scores"`
   - **Priority sources**: Hugging Face, GitHub repos, paperswithcode.com, arXiv, official provider docs
   - **Action required**: For each unresolved model, conduct web research and update the proposal
   - **Evidence capture**: Record all URLs, extracted values, and confidence scores
   - **Do NOT skip this step**: The workflow must demonstrate ToolHive was attempted

3) **Manual Benchmark Execution** (if web research inadequate)
    - **User Notification**: Notify user that benchmarks will be attempted for missing data
    - **Platform Check**: Verify benchmark platforms are configured (IFBench, MMLU-Pro, GPQA)
    - **Execution**: Run available benchmarks with 1-second cooldown between iterations
    - **Progress Updates**: Keep user informed of benchmark progress at each step
    - **Result Capture**: Record successful benchmark results for user approval
    - **SWE-Bench-Pro**: **NOT AVAILABLE** for local execution (requires extensive compute)

4) **SWE-Bench-Pro Proxy** (ONLY when SWE-Bench-Pro is missing after web research)
    - **Location**: `proxies/swe_bench_pro/`
    - **Script**: `python proxies/swe_bench_pro/swe_bench_pro_proxy.py`
    - **Requirements**: ≥8 anchor models with known Pro scores
    - **Method**: Ridge regression on composite features (C=code, A=agentic, R=reasoning)
    - **Output**: Point estimate + bootstrap intervals (80%, 95%)
    - **Confidence**: Mark as proxy in proposal (not ground truth)
    - **Documentation**: See `proxies/swe_bench_pro/README.md`
    - **Integration**: Creates proxy proposal for `--use-proxy` optimization flag

4) **Stealth/Rumor Mapping** (only for cloaked models)
   - Only for models where provider ID doesn't map 1:1 to known benchmarks
   - Identify likely backing model using multiple credible sources
   - Present mapping + evidence with confidence score

5) **User Interview Gate** (LAST RESORT - only when all above exhausted)
    - Triggered ONLY when:
      - AA API returned low confidence (<0.85)
      - Web search yielded no credible benchmark data
      - Manual benchmarks cannot be run or failed
      - SWE-Bench-Pro Proxy cannot be applied (insufficient anchors or too uncertain)
    - Present complete evidence package
    - Ask for ONE decision: Approve/Deny/Ignore List/Instructions

### ToolHive Web Search Protocol:

```javascript
// Step 1: Find web search tool
const searchTool = await toolhive_find_tool({
  tool_description: "search the web for information",
  tool_keywords: "web search google"
});

// Step 2: Execute search for each unresolved model
for (const model of unresolvedModels) {
  const results = await toolhive_call_tool({
    server_name: searchTool.server_name,
    tool_name: searchTool.tool_name,
    parameters: { 
      query: `${model.name} benchmark GPQA MMLU ${model.provider}`,
      num_results: 10
    }
  });
  
  // Extract benchmark values from results
  // Update proposal with findings
}
```

**Quality Assurance:** Before accepting benchmark data, verify source reliability, metric correctness, model match, and cross-validate with multiple sources per `research-plan.md` checklist.

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

### Manual Benchmark Runs (IFBench, MMLU-Pro, GPQA)

Some providers/models do not publish academic benchmark results. In that case we run the benchmarks ourselves and then record the resulting metric via the normal acceptance workflow.

**Note: SWE-Bench-Pro is NOT available for local execution.** See "SWE-Bench-Pro Proxy" below for estimation method.

#### IFBench
- Runner scaffold: `skills/update-agent-models/benchmarks/ifbench/ifbench-platform/`
- Instructions: `skills/update-agent-models/benchmarks/ifbench/instructions.md`

#### MMLU-Pro
- Runner scaffold: `skills/update-agent-models/benchmarks/mmlu_pro/mmlu-pro-platform/`
- Instructions: `skills/update-agent-models/benchmarks/mmlu_pro/openrouter_mmlu_pro_lm_eval_instructions.md`

#### GPQA
- Runner scaffold: `skills/update-agent-models/benchmarks/gpqa/gpqa-platform/`
- Instructions: `skills/update-agent-models/benchmarks/gpqa/gpqa_openrouter_install.md`

#### Setup & Keys
- **Shared Vendor**: All platforms share a vendored `lm-evaluation-harness` at `skills/update-agent-models/benchmarks/vendor/lm-evaluation-harness/`.
- **API Keys**: Provide keys at runtime via `OPENROUTER_API_KEY` (preferred) or `API_KEY`.
- **GPQA Gated Access**: Requires `HF_TOKEN` and accepting terms on Hugging Face.
- **Venvs**: Each platform has a dedicated `.venv/` for isolation.

Do not commit keys; keep them in your environment (or local `.env` that is gitignored).

### SWE-Bench-Pro Proxy

When SWE-Bench-Pro scores are missing after exhausting all research methods, use the ML-based proxy to estimate scores from the 15 other available benchmarks.

#### When to Use
- Model missing SWE-Bench-Pro after AA API and web search
- You have ≥8 anchor models with known Pro scores
- Need provisional score for optimization (will be marked as proxy)

#### How It Works
The proxy uses ridge regression with composite features:
- **C (Coding)**: swe_bench_verified, livecodebench, coding_index, scicode, terminalbench_hard
- **A (Agentic)**: terminalbench_hard, tau2, ifbench, context_length  
- **R (Reasoning)**: gpqa, mmlu_pro, intelligence_index, hle, aime, math_index, GDPval-AA ELO
- **K (Context)**: context_length
- **C×A**: Interaction term

Features are percentile-normalized against anchor distributions, then fed into a ridge regression model with bootstrap prediction intervals.

#### Usage

1. **Prepare anchors** - Create `anchors.json` with models having known Pro scores:
```json
[
  {
    "model_id": "anthropic/claude-opus-4-6",
    "pro_public_score": 32.4,
    "pro_source": "swebench.com",
    "pro_date": "2026-02-01"
  }
]
```

2. **Train proxy**:
```bash
cd skills/update-agent-models/proxies/swe_bench_pro
python swe_bench_pro_proxy.py train \
  --anchors anchors.json \
  --benchmarks ../../../model_benchmarks.json \
  --output artifacts/v1
```

3. **Generate predictions**:
```bash
python swe_bench_pro_proxy.py predict \
  --artifacts artifacts/v1 \
  --benchmarks models_to_predict.json \
  --output predictions.json
```

4. **Create proxy proposal** for optimization with `--use-proxy` flag.

#### Location
- **Implementation**: `proxies/swe_bench_pro/swe_bench_pro_proxy.py`
- **Documentation**: `proxies/swe_bench_pro/README.md`
- **Spec**: `proxies/swe_bench_pro/swe_bench_pro_proposed.md`

#### Requirements
- Python 3.8+
- numpy
- ≥8 anchor models with known SWE-Bench-Pro scores
- All 15 input benchmarks available for anchors and targets

## Cleanup

To remove temporary files and reset the skill state:

```bash
# Remove all proposal files (keeps last 5 by default)
node skills/update-agent-models/cleanup.js

# Remove ALL proposal files
node skills/update-agent-models/cleanup.js --all

# Remove benchmark data and start fresh
node skills/update-agent-models/cleanup.js --reset-data

# Full cleanup - proposals, reports, temp files, and reset data
node skills/update-agent-models/cleanup.js --full-reset
```

**Cleanup targets:**
- `proposals/*.json` - Research and optimization proposals
- `reports/*.json` - Optimization run reports
- `.slim/cartography.json` - Cartography cache (if needed)
- Temporary files in platform directories
- **Optional:** `benchmark_manual_accepted.json` and `model_benchmarks.json` (with `--reset-data`)

## Maintenance Rules

- **HARDENED MODE**: No auto-approval allowed. Every model requires explicit user approval.
- **ALL BENCHMARKS REQUIRED**: Models missing any of 16 benchmarks cannot be approved.
- **STRICT PHASE ENFORCEMENT**: Must follow API → Web Search → Local Benchmarks → User approval.
- **BENCHMARK NORMALIZATION REQUIRED**: All benchmarks must be normalized to 0–1 scale before scoring per `benchmark_normalization_instructions.md`.
- **AGENT-SPECIFIC ALGORITHMS**: Scoring formulas are defined in `bench_calc.json` for each agent type (Orchestrator, Oracle, Explorer, Librarian, Designer, Fixer, Builder).
- If scoring algorithms change, update `bench_calc.json` and rerun full workflow.
- If normalization rules change, update `benchmark_normalization_instructions.md` and rerun full workflow.
- Keep role weights summing to `1.0` in `bench_calc.json`.
- Keep formulas normalized using constants for mixed metric scales (MAX_CONTEXT_LENGTH, MAX_GDPVAL_AA_ELO, etc.).
- Never manually reorder chains in `oh-my-opencode-theseus.json`.
- Run `cleanup.js --full-reset` to erase all data and start from scratch.

---

# WORKFLOW IS LAW - STRICT ENFORCEMENT PROTOCOL

## Universal Principles

### 1. NO MODELS SKIPPED - EVER

**PRINCIPLE:** ALL models are treated equally. NO exceptions.

**ENFORCEMENT:**
```
✅ TEST: Claude Opus 4.6 ($15/$75 per 1M tokens) 
✅ TEST: GPT-5.2 Codex (high tier)
✅ TEST: Gemini 3 Pro (premium)
✅ TEST: Llama 3.2 1B (small local)
✅ TEST: Qwen 0.5B (tiny local)

ALL models tested. ALL models researched. ALL presented for approval.
```

**ONLY valid reason to skip:**
- Model fails test (no response)
- User explicitly denies

**NEVER skip because:**
- High cost
- Provider preference
- Assumed working
- "Too expensive to test"

### 2. ONE-AT-A-TIME INTERVIEW - MANDATORY

**PRINCIPLE:** Present EACH model individually. WAIT for response. Proceed ONLY after explicit approval/denial.

**FORBIDDEN:**
```javascript
// ❌ WRONG - Batch approval
"25 models complete. Approve all? (yes/no)"

// ❌ WRONG - Implicit approval
User: "Continue"
Assistant: *adds all models*

// ❌ WRONG - Ambiguous interpreted as yes
User: "1" (meaning option 1)
Assistant: *interprets as "approve all"
```

**REQUIRED:**
```javascript
// ✅ CORRECT - One at a time
"Model 1 of 25: anthropic/claude-opus-4-1"
"Benchmarks: [full list with values]"
"Sources: [list]"
"Missing: 0/16"
"Approve this model? (yes/no/ignore/provide-values)"

[WAIT FOR RESPONSE]

User: "yes"
Assistant: "✓ Approved. Model 2 of 25..."
```

**INTERVIEW FORMAT:**
```
═══════════════════════════════════════════════════════════════
MODEL X OF Y: [model-id]
═══════════════════════════════════════════════════════════════

Name: [display name]
Provider: [provider]

BENCHMARKS (16/16):
  ✓ gpqa: [value] (source: [source])
  ✓ mmlu_pro: [value] (source: [source])
  ... all 16 listed ...

Missing: 0
Confidence: [score]
Research Phase: [phase completed]

DECISION REQUIRED:
  [A]pprove - Add to accepted benchmarks
  [D]eny    - Skip this model
  [I]gnore  - Add to permanent ignore list
  [V]alues  - I have manual values to provide

Your choice: _
═══════════════════════════════════════════════════════════════
```

**RULE:** Cannot proceed to next model until current model resolved.

### 3. NO PROGRAMMATIC ADDITIONS - EVER

**PRINCIPLE:** Code/Scripts CANNOT add models to lists. ONLY user decisions can.

**FORBIDDEN:**
```javascript
// ❌ NEVER DO THIS:
for (const model of completeModels) {
  accepted.models[model.id] = model.benchmarks; // VIOLATION
}

// ❌ NEVER DO THIS:
if (model.missingBenchmarks.length === 0) {
  addToAccepted(model); // VIOLATION - no user approval
}

// ❌ NEVER DO THIS:
const allComplete = getCompleteModels();
addAllToAccepted(allComplete); // VIOLATION - batch add
```

**REQUIRED:**
```javascript
// ✅ CORRECT - Must go through interview
gotoInterviewGate();
// Interview presents ONE model at a time
// User responds to EACH
// ONLY THEN is model added

// ✅ CORRECT - Direct user action
User: "Approve anthropic/claude-opus-4-1"
Assistant: *adds only that model*
```

**FILES PROTECTED:**
- `benchmark_manual_accepted.json` - NO programmatic writes
- `model_ignore_list.json` - NO programmatic writes  
- `proposals/benchmark-research*.json` - NO auto-modification
- `oh-my-opencode-theseus.json` - Proposal-only, agent applies

### 4. HARD STOPS - NON-NEGOTIABLE

**SCENARIO 1: Unresolved Models**
```
ERROR: Cannot optimize
Reason: 8 models unresolved
Action Required: Run interview gate

[HARD STOP - Cannot proceed]
```

**SCENARIO 2: Pending Approvals**
```
ERROR: Cannot optimize
Reason: 12 models awaiting user approval
Action Required: Complete interview for each

[HARD STOP - Cannot proceed]
```

**SCENARIO 3: Incomplete Benchmarks**
```
ERROR: Cannot approve model
Reason: Missing 3 benchmarks
Action Required: Complete research

[HARD STOP - Cannot add to accepted]
```

**RULE:** When hard stop triggered, assistant MUST:
1. STOP immediately
2. Explain why
3. Present next required action
4. WAIT for user

### 5. ALIAS/STEALTH MODEL HANDLING

**DETECTION:**
- Name patterns: `*-free`, `*-latest`, `opencode/*`
- User guidance: "Big Pickle is GLM stealth"

**PROTOCOL:**
```
ALIAS DETECTED: opencode/kimi-k2.5-free

Hypothesis: Moonshot Kimi K2.5 free tier
Evidence: OpenCode wrapper for Moonshot
Suggested Mapping: opencode/kimi-k2.5-free -> huggingface/moonshotai/Kimi-K2.5

Is this correct?
  [Y]es - Use target model's benchmarks
  [N]o - Treat as separate model (requires full benchmarks)
  [P]rovide - I'll specify different target
  [R]esearch - Need more info

Your choice: _
```

**RULE:** Map ONLY after explicit user confirmation.

### 6. WORKFLOW VIOLATION RECOVERY

**IF VIOLATION DETECTED:**
1. STOP all operations
2. Log violation details
3. Present recovery options:
   - Continue with violation noted
   - Revert to last checkpoint
   - Restart from specific phase
4. WAIT for user decision

**NEVER:**
- Auto-correct violations
- Pretend violation didn't happen
- Continue without acknowledgment

### 7. AUDIT REQUIREMENTS

**EVERY action logs:**
```json
{
  "timestamp": "2026-02-16T14:30:00Z",
  "action": "MODEL_APPROVED",
  "modelId": "anthropic/claude-opus-4-1",
  "userResponse": "yes",
  "interviewSession": "uuid-here",
  "benchmarksHash": "sha256-of-benchmarks",
  "previousState": "hash-before",
  "newState": "hash-after",
  "stackTrace": "..."
}
```

**VIOLATIONS log:**
```json
{
  "timestamp": "2026-02-16T14:30:00Z",
  "violation": "PROGRAMMATIC_ADDITION_ATTEMPT",
  "attempted": "batch_add_models",
  "blocked": true,
  "userNotified": true
}
```

### 8. DECISION TREE - WORKFLOW LAW

```
START
  │
  ▼
┌─────────────────────┐
│ Test ALL models     │ ◄── NO SKIPPING
│ (test-models.sh)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Research ALL models │ ◄── NO SHORTCUTS
│ (AA API → Web →     │
│  Local benchmarks)  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Interview Gate      │ ◄── HARD STOP
│ ONE model at a time │     if unresolved
│ WAIT for approval   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ All approved?       │
└──────────┬──────────┘
           │
      ┌────┴────┐
      │         │
     NO        YES
      │         │
      ▼         ▼
┌──────────┐ ┌─────────────────────┐
│HARD STOP │ │ Optimize chains     │
│Complete  │ │ (guard --strict)    │
│interviews│ └─────────────────────┘
└──────────┘
```

## COMMAND REFERENCE

### Run Full Workflow
```bash
node skills/update-agent-models/run-workflow.js --strict
```

### Test Models (NO EXCLUSIONS)
```bash
bash skills/update-agent-models/test-models.sh
# Tests ALL models including expensive ones
# Timeout: 420000ms (7 minutes minimum)
```

### Research Benchmarks
```bash
node skills/update-agent-models/research-benchmarks.js
# Researches ALL models equally
```

### Interview Gate (ONE AT A TIME)
```bash
node skills/update-agent-models/next-interview.js
# Presents ONE model
# WAITS for user input
# Logs decision
# Loops until all resolved
```

### Optimize (HARD STOPS IF UNRESOLVED)
```bash
node skills/update-agent-models/optimize.js --strict
# FAILS if any unresolved
# FAILS if any pending approval
# Only proceeds when clean
```

## VIOLATION EXAMPLES FROM SESSION 2026-02-16

**VIOLATION 1:** Auto-added 6 Claude models after proxy research
```
Status: VIOLATION
Expected: Present each model individually
Actual: Batch added to accepted
Impact: 6 models approved without explicit per-model consent
```

**VIOLATION 2:** Continued with 22 unresolved models
```
Status: VIOLATION
Expected: Hard stop at interview gate
Actual: Auto-added models programmatically
Impact: Bypassed user approval for 22 models
```

**VIOLATION 3:** Interpreted "1" as "approve all"
```
Status: VIOLATION
Expected: Clarify ambiguous instruction
Actual: Assumed batch approval
Impact: 25+ models auto-processed
```

## CORRECT BEHAVIOR CHECKLIST

When user says "Let's update all models":

- [ ] Run test-models.sh (ALL models, NO exclusions)
- [ ] Run research-benchmarks.js (ALL models)
- [ ] STOP if unresolved models exist
- [ ] Present models ONE AT A TIME
- [ ] WAIT for explicit yes/no/ignore per model
- [ ] ONLY ad

---

# WORKFLOW IS LAW - STRICT ENFORCEMENT PROTOCOL

## Universal Principles

### 1. NO MODELS SKIPPED - EVER

**PRINCIPLE:** ALL models are treated equally. NO exceptions.

**ENFORCEMENT:**
- Test Claude Opus 4.6 ($15/$75 per 1M tokens) 
- Test GPT-5.2 Codex (high tier)
- Test Gemini 3 Pro (premium)
- Test Llama 3.2 1B (small local)
- Test Qwen 0.5B (tiny local)

ALL models tested. ALL models researched. ALL presented for approval.

**ONLY valid reason to skip:**
- Model fails test (no response)
- User explicitly denies

**NEVER skip because:**
- High cost
- Provider preference
- Assumed working
- "Too expensive to test"

### 2. ONE-AT-A-TIME INTERVIEW - MANDATORY

**PRINCIPLE:** Present EACH model individually. WAIT for response. Proceed ONLY after explicit approval/denial.

**FORBIDDEN:**
- Batch approval requests ("Approve all 25?")
- Implicit approval from ambiguous instructions
- Interpreting numbers as approvals
- Continuing without explicit per-model consent

**REQUIRED FORMAT:**
```
MODEL X OF Y: [model-id]
Name: [display name]
Provider: [provider]

BENCHMARKS (16/16):
  gpqa: [value] (source: [source])
  mmlu_pro: [value] (source: [source])
  ... all 16 listed ...

Missing: 0
Confidence: [score]

DECISION REQUIRED:
  [A]pprove - Add to accepted benchmarks
  [D]eny    - Skip this model
  [I]gnore  - Add to permanent ignore list
  [V]alues  - I have manual values to provide

Your choice: _
```

**RULE:** Cannot proceed to next model until current model resolved.

### 3. NO PROGRAMMATIC ADDITIONS - EVER

**PRINCIPLE:** Code/Scripts CANNOT add models to lists. ONLY user decisions can.

**FORBIDDEN:**
- for-loop adding all complete models
- Auto-adding when missingBenchmarks.length === 0
- Batch add functions
- Any code that writes to accepted/ignore without explicit per-model user approval

**REQUIRED:**
- Must go through interview gate for EACH model
- User responds to EACH individually
- ONLY THEN is model added

**FILES PROTECTED:**
- benchmark_manual_accepted.json - NO programmatic writes
- model_ignore_list.json - NO programmatic writes  
- proposals/benchmark-research*.json - NO auto-modification
- oh-my-opencode-theseus.json - Proposal-only, agent applies

### 4. HARD STOPS - NON-NEGOTIABLE

**Unresolved Models:**
```
ERROR: Cannot optimize
Reason: X models unresolved
Action Required: Run interview gate for each
[HARD STOP - Cannot proceed]
```

**Pending Approvals:**
```
ERROR: Cannot optimize
Reason: X models awaiting user approval
Action Required: Complete interview for each
[HARD STOP - Cannot proceed]
```

**RULE:** When hard stop triggered, assistant MUST stop, explain why, present next action, and WAIT.

### 5. ALIAS/STEALTH PROTOCOL

**Detection:** Name patterns (*-free, *-latest, opencode/*)

**Required:**
```
ALIAS DETECTED: [model-id]
Hypothesis: [target model]
Evidence: [reasoning]
Is this correct? [Y]es/[N]o/[P]rovide/[R]esearch
```

Map ONLY after explicit user confirmation.

### 6. AUDIT REQUIREMENTS

Every action logs: timestamp, action, modelId, userResponse, state hashes, stack trace.

## VIOLATIONS FROM SESSION 2026-02-16

1. **Auto-added 6 Claude models** - Expected individual presentation, batch added instead
2. **Continued with 22 unresolved** - Expected hard stop, auto-added programmatically  
3. **Interpreted "1" as approval** - Expected clarification, assumed batch approval

## CORRECT CHECKLIST

- [ ] Run test-models.sh (ALL models)
- [ ] Run research-benchmarks.js (ALL models)
- [ ] STOP if unresolved models exist
- [ ] Present models ONE AT A TIME
- [ ] WAIT for explicit yes/no/ignore per model
- [ ] ONLY add after explicit approval
- [ ] NEVER batch add or assume
- [ ] Optimize ONLY when all clean

**Better to ask than to violate.**

Base directory for this skill: file:///C:/Users/paulc/.config/opencode/skills/update-agent-models
Relative paths in this skill (e.g., scripts/, reference/) are relative to this bas

... (truncated)
```

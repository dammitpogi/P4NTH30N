#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Load .env into environment (best-effort).
if [ -f ".env" ]; then
  set -a
  # shellcheck disable=SC1091
  source ".env"
  set +a
fi

API_BASE="${API_BASE:-https://openrouter.ai/api/v1}"
MODEL="${MODEL:-arcee-ai/trinity-mini:free}"
INPUT_FILE="${INPUT_FILE:-vendor/IFBench/data/IFBench_test.jsonl}"
TEMPERATURE="${TEMPERATURE:-0}"
MAX_TOKENS="${MAX_TOKENS:-4096}"
WORKERS="${WORKERS:-4}"
SEED="${SEED:-}"

MODEL_SAFE="$(echo "$MODEL" | tr '/:' '--')"
RUN_ID="$(date +%Y%m%d_%H%M%S)_${MODEL_SAFE}"
RUN_DIR="runs/${RUN_ID}"
EVAL_DIR="${RUN_DIR}/eval"

mkdir -p "$RUN_DIR" "$EVAL_DIR"

IFBENCH_SHA="$(git -C vendor/IFBench rev-parse HEAD 2>/dev/null || echo "unknown")"

export RUN_DIR API_BASE MODEL TEMPERATURE MAX_TOKENS WORKERS SEED INPUT_FILE IFBENCH_SHA

# Ensure consistent UTF-8 decoding on Windows (IFBench reads jsonl without explicit encoding).
export PYTHONUTF8=1
export PYTHONIOENCODING=utf-8

python - <<'PY'
import json, os, time
run_dir=os.environ["RUN_DIR"]
meta={
  "timestamp": time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
  "api_base": os.environ.get("API_BASE"),
  "model": os.environ.get("MODEL"),
  "temperature": os.environ.get("TEMPERATURE"),
  "max_tokens": os.environ.get("MAX_TOKENS"),
  "workers": os.environ.get("WORKERS"),
  "seed": os.environ.get("SEED"),
  "input_file": os.environ.get("INPUT_FILE"),
  "ifbench_git_sha": os.environ.get("IFBENCH_SHA"),
}
with open(os.path.join(run_dir, "metadata.json"), "w", encoding="utf-8") as f:
  json.dump(meta, f, indent=2, sort_keys=True)
PY

# Snapshot env without secrets.
{
  echo "API_BASE=${API_BASE}"
  echo "MODEL=${MODEL}"
  echo "INPUT_FILE=${INPUT_FILE}"
  echo "TEMPERATURE=${TEMPERATURE}"
  echo "MAX_TOKENS=${MAX_TOKENS}"
  echo "WORKERS=${WORKERS}"
  echo "SEED=${SEED}"
  echo "IFBENCH_SHA=${IFBENCH_SHA}"
} >"${RUN_DIR}/env.snapshot"

RESPONSES_FILE="${RUN_DIR}/${MODEL_SAFE}-responses.jsonl"

GEN_ARGS=(
  --api-base "$API_BASE"
  --model "$MODEL"
  --input-file "$INPUT_FILE"
  --output-file "$RESPONSES_FILE"
  --temperature "$TEMPERATURE"
  --max-tokens "$MAX_TOKENS"
  --workers "$WORKERS"
  --resume
)

if [ -n "$SEED" ]; then
  GEN_ARGS+=(--seed "$SEED")
fi

python scripts/providers/generate_responses_openrouter.py "${GEN_ARGS[@]}"

# Run evaluation
PYTHONPATH="vendor/IFBench" python vendor/IFBench/run_eval.py \
  --input_data="$INPUT_FILE" \
  --input_response_data="$RESPONSES_FILE" \
  --output_dir="$EVAL_DIR"

python scripts/summarize.py --run-dir "$RUN_DIR"

echo "Done. Run dir: ${RUN_DIR}"

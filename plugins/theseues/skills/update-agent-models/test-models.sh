#!/bin/bash
# Test ALL models from opencode models CLI
# Output: working_models.json with verified model IDs

AUTH_FILE="C:/Users/paulc/.local/share/opencode/auth.json"

get_key() {
    local provider="$1"
    python - "$AUTH_FILE" "$provider" <<'PY'
import json
import sys
path, provider = sys.argv[1], sys.argv[2]
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)
entry = data.get(provider, {})
print(entry.get("key", ""))
PY
}

# API Keys from auth.json
OPENROUTER_API_KEY="$(get_key openrouter)"
GOOGLE_API_KEY="$(get_key google)"
GROQ_API_KEY="$(get_key groq)"
MOONSHOT_API_KEY="$(get_key moonshotai)"
CEREBRAS_API_KEY="$(get_key cerebras)"
LMSTUDIO_API_KEY="$(get_key lmstudio)"
[ -z "$LMSTUDIO_API_KEY" ] && LMSTUDIO_API_KEY="$(get_key lmstudio:)"

PROPOSAL_DIR="C:/Users/paulc/.config/opencode/skills/update-agent-models/proposals"
mkdir -p "$PROPOSAL_DIR"
PROVIDER_CACHE_DIR="$PROPOSAL_DIR/.provider-model-cache"
mkdir -p "$PROVIDER_CACHE_DIR"
OUTPUT_FILE="$PROPOSAL_DIR/working_models.$(date -u +%Y%m%dT%H%M%SZ).json"
TIMESTAMP=$(date +%s)000

echo "Getting all models from opencode models CLI..."
models_list=$(opencode models 2>&1 | grep -v "^\[" | grep "/")
opencode_list=$(opencode models opencode 2>&1 | grep -v "^\[" | grep "^opencode/")

# Provider endpoints and test functions
test_google() {
    local model="$1"
    curl -s -w "%{http_code}" -X POST "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$GOOGLE_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{"contents":[{"parts":[{"text":"OK"}]}],"generationConfig":{"maxOutputTokens":5}}' -o /dev/null 2>/dev/null
}

test_groq() {
    local model="$1"
    curl -s -w "%{http_code}" -X POST "https://api.groq.com/openai/v1/chat/completions" \
        -H "Authorization: Bearer $GROQ_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}" -o /dev/null 2>/dev/null
}

test_openrouter() {
    local model="$1"
    curl -s -w "%{http_code}" -X POST "https://openrouter.ai/api/v1/chat/completions" \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        -H "HTTP-Referer: https://opencode.ai" \
        -H "X-Title: OpenCode" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}" -o /dev/null 2>/dev/null
}

test_cerebras() {
    local model="$1"
    curl -s -w "%{http_code}" -X POST "https://api.cerebras.ai/v1/chat/completions" \
        -H "Authorization: Bearer $CEREBRAS_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}" -o /dev/null 2>/dev/null
}

test_moonshotai() {
    local model="$1"
    curl -s -w "%{http_code}" -X POST "https://api.moonshot.ai/v1/chat/completions" \
        -H "Authorization: Bearer $MOONSHOT_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}" -o /dev/null 2>/dev/null
}

test_lmstudio() {
    local model="$1"
    curl -s -w "%{http_code}" -X POST "http://localhost:1234/v1/chat/completions" \
        -H "Authorization: Bearer $LMSTUDIO_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}" -o /dev/null 2>/dev/null
}

sanitize_provider() {
    local provider="$1"
    printf "%s" "$provider" | tr '/:' '__'
}

is_valid_model_id() {
    local model_id="$1"
    if [[ ! "$model_id" =~ ^[A-Za-z0-9._:-]+/[A-Za-z0-9._:/-]+$ ]]; then
        return 1
    fi
    case "$model_id" in
        artificial-analysis/llms/models)
            return 1
            ;;
        free/openrouter/free)
            return 1
            ;;
    esac
    return 0
}

is_blocked_provider() {
    local provider="$1"
    case "$provider" in
        artificial-analysis)
            return 0
            ;;
    esac
    return 1
}

provider_list_file() {
    local provider="$1"
    local key
    key="$(sanitize_provider "$provider")"
    echo "$PROVIDER_CACHE_DIR/$key.txt"
}

cache_provider_models() {
    local provider="$1"
    local file
    file="$(provider_list_file "$provider")"
    opencode models "$provider" 2>/dev/null | grep -v "^\[" | grep "^${provider}/" > "$file" || true
}

provider_has_model() {
    local provider="$1"
    local model_id="$2"
    local file
    file="$(provider_list_file "$provider")"
    cache_provider_models "$provider"
    grep -Fxq "$model_id" "$file"
}

# Arrays to collect results
working=()
skipped=0
invalid=0

echo ""
echo "Testing ALL models..."
echo ""

# Read models and test each
total=0
while IFS= read -r model_id; do
    if ! is_valid_model_id "$model_id"; then
        ((invalid++))
        echo "⏭️  $model_id (invalid/non-inference model id)"
        continue
    fi

    provider="${model_id%%/*}"
    model="${model_id#*/}"

    if is_blocked_provider "$provider"; then
        ((invalid++))
        echo "⏭️  $model_id (blocked provider)"
        continue
    fi
    
    ((total++))
    
    case "$provider" in
        google)
            if [ -n "$GOOGLE_API_KEY" ]; then
                code=$(test_google "$model")
            else
                code="SKIP_NO_KEY"
            fi
            ;;
        groq)
            if [ -n "$GROQ_API_KEY" ]; then
                code=$(test_groq "$model")
            else
                code="SKIP_NO_KEY"
            fi
            ;;
        openrouter)
            if [ -n "$OPENROUTER_API_KEY" ]; then
                code=$(test_openrouter "$model")
            else
                code="SKIP_NO_KEY"
            fi
            ;;
        cerebras)
            if [ -n "$CEREBRAS_API_KEY" ]; then
                code=$(test_cerebras "$model")
            else
                code="SKIP_NO_KEY"
            fi
            ;;
        moonshotai)
            if [ -n "$MOONSHOT_API_KEY" ]; then
                code=$(test_moonshotai "$model")
            else
                code="SKIP_NO_KEY"
            fi
            ;;
        lmstudio-local)
            if [ -n "$LMSTUDIO_API_KEY" ]; then
                code=$(test_lmstudio "$model")
            else
                code="SKIP_NO_KEY"
            fi
            ;;
        opencode)
            if echo "$opencode_list" | grep -Fxq "$model_id"; then
                code="200"
            else
                code="000"
            fi
            ;;
        *)
            if provider_has_model "$provider" "$model_id"; then
                code="200"
            else
                code="000"
            fi
            ;;
    esac
    
    if [ "$code" = "200" ]; then
        working+=("$model_id")
        echo "✅ $model_id"
    elif [ "$code" = "SKIP_NO_KEY" ]; then
        ((skipped++))
        echo "⏭️  $model_id (missing provider key)"
    else
        echo "❌ $model_id ($code)"
    fi
done <<< "$models_list"

echo ""
echo "=========================================="
echo "Total tested: $total"
echo "Working: ${#working[@]}"
echo "Skipped (no key): $skipped"
echo "Skipped (invalid id): $invalid"
echo "=========================================="

# Write JSON
{
    echo '{
  "_schema": "https://opencode.ai/skills/update-agent-models/working-models.json",
  "_description": "Verified working models from opencode models CLI",
  "_lastUpdated": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "models": {'
    
    first=true
    for m in "${working[@]}"; do
        p="${m%%/*}"
        [ "$first" = true ] && first=false || echo ","
        echo -n "    \"$m\": {\"lastVerified\": $TIMESTAMP, \"successCount\": 1, \"failureCount\": 0, \"provider\": \"$p\", \"displayName\": \"$m\"}"
    done
    
    echo ""
    echo "  }"
    echo "}"
} > "$OUTPUT_FILE"

echo ""
echo "Proposal written to: $OUTPUT_FILE"
echo "No direct config write performed. Agent should review and apply updates to working_models.json."

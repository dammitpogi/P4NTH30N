---
name: model-tester
description: Test OpenRouter models manually and add failures to triage. Use when user asks to test models, check model availability, or verify API keys.
---

# Model Tester Skill

Tests OpenRouter models from `opencode.json` configuration and adds failed models to the triage list in `oh-my-opencode-theseus.json`.

## When to Use

- User asks to "test models", "check models", or "verify API"
- User asks to "test opencode.json" or "test providers"
- User asks to "send failed models to triage"
- User asks to "check model availability"

## Test Process

### Step 1: Read Configuration

Read `opencode.json` to get the provider configuration and models:

```json
{
  "provider": {
    "openrouter-free": {
      "options": {
        "baseURL": "https://openrouter.ai/api/v1",
        "apiKey": "sk-or-v1-..."
      },
      "models": {
        "model/id:free": { "name": "Display Name" }
      }
    }
  }
}
```

### Step 2: Test Each Model

Use curl to test each model:

```bash
curl -s -w "\n%{http_code}" -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-or-v1-YOUR_API_KEY" \
  -H "HTTP-Referer: https://opencode.ai" \
  -H "X-Title: OpenCode" \
  -d "{\"model\": \"MODEL_ID\", \"messages\": [{\"role\": \"user\", \"content\": \"Say OK\"}], \"max_tokens\": 5}"
```

### Step 3: Interpret Results

| HTTP Code | Meaning | Action |
|-----------|---------|--------|
| 200 | Success | Model works |
| 400 | Bad request | Model may be deprecated |
| 401 | Unauthorized | API key issue |
| 402 | Quota exceeded | Add to triage |
| 403 | Forbidden | Model unavailable |
| 404 | Not found | Model doesn't exist |
| 429 | Rate limited | Retry later |
| 500+ | Server error | Add to triage |
| Timeout | No response | Add to triage |

### Step 4: Update Triage

Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:

```json
"triage": {
  "provider-id/model:id": {
    "lastChecked": 1770962431,
    "failureCount": 1,
    "lastFailure": 1770962431,
    "error": "Error type or message"
  }
}
```

The failureCount and lastFailure are used by the circuit breaker to automatically recover models over time.

## Example Test Sequence

```bash
# Test a single model
curl -s -w "\n%{http_code}" -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer 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" \
  -H "HTTP-Referer: https://opencode.ai" \
  -H "X-Title: OpenCode" \
  -d "{\"model\": \"openrouter/free\", \"messages\": [{\"role\": \"user\", \"content\": \"Say OK\"}], \"max_tokens\": 5}"
```

## Notes

- Test with minimal tokens (5-10) for quick validation
- A response with HTTP 200 means the model is functional
- The triage system automatically recovers models after enough time passes
- Use `timestamp` from response or current Unix time for lastChecked/lastFailure

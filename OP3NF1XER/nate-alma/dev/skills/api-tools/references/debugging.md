# API Debugging Guide

## Enable Verbose Mode

Always use `-v` when debugging:

```bash
scripts/api_request.py https://api.example.com/endpoint -v
```

This shows:
- Full request URL and method
- All headers sent
- Request body
- Response status and timing

## Common Issues

### 401 Unauthorized

**Cause:** Missing or invalid auth

**Debug:**
```bash
# Check if auth is being sent
scripts/api_request.py https://api.example.com/protected -v

# Verify token format
scripts/api_request.py https://api.example.com/protected \
  --auth-type bearer \
  --auth-value "your-token" \
  -v
```

### 400 Bad Request

**Cause:** Malformed request body or invalid data

**Debug:**
```bash
# Check JSON is valid
echo '{"name":"test"}' | python3 -m json.tool

# Send with verbose to see what's actually sent
scripts/api_request.py https://api.example.com/endpoint \
  -X POST \
  -d '{"name":"test"}' \
  -v
```

### 429 Too Many Requests

**Cause:** Rate limit exceeded

**Fix:** Add delays between requests or check rate limit headers in response.

### Connection Timeouts

**Cause:** Slow API or network issues

**Fix:** Increase timeout:
```bash
scripts/api_request.py https://slow-api.com/endpoint \
  --timeout 60
```

## Inspecting Responses

### Pretty-print JSON
```bash
scripts/api_request.py https://api.example.com/data | python3 -m json.tool
```

### Extract specific fields
```bash
scripts/api_request.py https://api.example.com/user | jq '.body.name'
```

### Save response to file
```bash
scripts/api_request.py https://api.example.com/data > response.json
```

## Testing Endpoints

### Quick health check
```bash
scripts/api_request.py https://api.example.com/health
```

### Test with curl for comparison
```bash
curl -v https://api.example.com/endpoint
```

### Check headers only
```bash
scripts/api_request.py https://api.example.com/endpoint | jq '.headers'
```

## Rate Limiting

Check response headers for rate limit info:
- `X-RateLimit-Limit` - Max requests per period
- `X-RateLimit-Remaining` - Requests left
- `X-RateLimit-Reset` - When limit resets (usually Unix timestamp)

```bash
scripts/api_request.py https://api.example.com/endpoint -v | jq '.headers | with_entries(select(.key | startswith("X-RateLimit")))'
```

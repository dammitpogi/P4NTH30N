---
name: api-tools
description: Generic API testing and development toolkit. Use when working with any HTTP API - making requests, testing endpoints, debugging responses, handling authentication (Bearer, API key, Basic), or exploring new APIs. Supports all standard HTTP methods (GET, POST, PUT, PATCH, DELETE) with flexible auth and data handling.
---

# API Tools

Generic toolkit for API testing, development, and debugging.

## Quick Start

Basic GET request:
```bash
scripts/api_request.py https://api.example.com/endpoint
```

POST with JSON body:
```bash
scripts/api_request.py https://api.example.com/users \
  -X POST \
  -d '{"name":"Alice","email":"alice@example.com"}'
```

With authentication:
```bash
scripts/api_request.py https://api.example.com/protected \
  --auth-type bearer \
  --auth-value "your-token-here"
```

## Core Script: api_request.py

Flexible HTTP client supporting all standard methods and auth types.

**Common Options:**
- `-X METHOD` - HTTP method (GET, POST, PUT, PATCH, DELETE)
- `-d DATA` - Request body (JSON or form data)
- `--auth-type TYPE` - Auth type: bearer, api_key, basic
- `--auth-value VALUE` - Auth credential
- `-H "Header: Value"` - Add custom headers
- `-v` - Verbose mode (shows request/response details)
- `--timeout SECONDS` - Request timeout (default: 30)

**Output:** JSON with status, headers, body, timing

## Authentication

See [references/auth-patterns.md](references/auth-patterns.md) for detailed patterns:
- Bearer tokens (OAuth, JWT)
- API keys
- Basic auth
- Custom headers

## HTTP Methods

See [references/http-methods.md](references/http-methods.md) for:
- When to use GET vs POST vs PUT vs PATCH
- Idempotency and safety guarantees
- Common response codes

## Debugging

See [references/debugging.md](references/debugging.md) for:
- Troubleshooting 401, 400, 429 errors
- Inspecting requests and responses
- Rate limiting patterns
- Testing strategies

## Examples

### REST API Testing
```bash
# List resources
scripts/api_request.py https://api.example.com/users

# Create resource
scripts/api_request.py https://api.example.com/users \
  -X POST \
  -d '{"name":"Bob","email":"bob@example.com"}'

# Update resource
scripts/api_request.py https://api.example.com/users/123 \
  -X PATCH \
  -d '{"email":"newemail@example.com"}'

# Delete resource
scripts/api_request.py https://api.example.com/users/123 -X DELETE
```

### With Authentication
```bash
# Bearer token
scripts/api_request.py https://api.example.com/me \
  --auth-type bearer \
  --auth-value "eyJhbGc..."

# API key
scripts/api_request.py https://api.example.com/data \
  --auth-type api_key \
  --auth-value "sk-1234567890"
```

### Debugging
```bash
# Verbose mode
scripts/api_request.py https://api.example.com/endpoint -v

# Pretty-print response
scripts/api_request.py https://api.example.com/data | python3 -m json.tool

# Save response
scripts/api_request.py https://api.example.com/data > response.json
```

## Tips

- **Start simple:** Test with GET before moving to POST/PUT
- **Use verbose mode:** `-v` flag shows exactly what's being sent
- **Check docs first:** Most APIs have OpenAPI/Swagger specs
- **Mind rate limits:** Check response headers for limits
- **Test incrementally:** Verify auth, then add headers, then body

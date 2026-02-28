# HTTP Methods Reference

## Standard Methods

### GET - Retrieve Data
Read-only. No side effects.

```bash
# Simple GET
scripts/api_request.py https://api.example.com/users

# With query params
scripts/api_request.py "https://api.example.com/users?page=2&limit=10"
```

### POST - Create Resource
Creates new resources. Not idempotent (multiple calls = multiple resources).

```bash
scripts/api_request.py https://api.example.com/users \
  -X POST \
  -d '{"name":"Alice","email":"alice@example.com"}'
```

### PUT - Update/Replace Resource
Replaces entire resource. Idempotent (safe to retry).

```bash
scripts/api_request.py https://api.example.com/users/123 \
  -X PUT \
  -d '{"name":"Alice Smith","email":"alice@example.com","active":true}'
```

### PATCH - Partial Update
Updates specific fields. May or may not be idempotent (depends on API).

```bash
scripts/api_request.py https://api.example.com/users/123 \
  -X PATCH \
  -d '{"email":"newemail@example.com"}'
```

### DELETE - Remove Resource
Deletes resource. Idempotent.

```bash
scripts/api_request.py https://api.example.com/users/123 \
  -X DELETE
```

## When to Use Each

| Method | Purpose | Has Body? | Idempotent? | Safe? |
|--------|---------|-----------|-------------|-------|
| GET | Read | No | Yes | Yes |
| POST | Create | Yes | No | No |
| PUT | Replace | Yes | Yes | No |
| PATCH | Update | Yes | Varies | No |
| DELETE | Remove | No | Yes | No |

**Idempotent** = Same request multiple times has same effect as once  
**Safe** = Read-only, no side effects

## Response Codes

### Success (2xx)
- **200 OK** - Request succeeded (GET, PUT, PATCH, DELETE)
- **201 Created** - Resource created (POST)
- **204 No Content** - Success but no response body (DELETE)

### Client Errors (4xx)
- **400 Bad Request** - Invalid syntax or data
- **401 Unauthorized** - Missing or invalid auth
- **403 Forbidden** - Auth valid but insufficient permissions
- **404 Not Found** - Resource doesn't exist
- **429 Too Many Requests** - Rate limit exceeded

### Server Errors (5xx)
- **500 Internal Server Error** - Server crashed
- **502 Bad Gateway** - Proxy/gateway error
- **503 Service Unavailable** - Server overloaded/down
- **504 Gateway Timeout** - Upstream timeout

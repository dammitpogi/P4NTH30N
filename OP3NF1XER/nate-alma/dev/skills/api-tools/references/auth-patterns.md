# API Authentication Patterns

## Common Auth Types

### Bearer Token
Most common for modern APIs (OAuth 2.0, JWT).

```bash
scripts/api_request.py https://api.example.com/user \
  --auth-type bearer \
  --auth-value "your-token-here"
```

Header sent: `Authorization: Bearer your-token-here`

### API Key
Simple key-based auth. Key name varies by service.

```bash
scripts/api_request.py https://api.example.com/data \
  --auth-type api_key \
  --auth-value "your-api-key"
```

Header sent: `X-API-Key: your-api-key`

**Note:** Some APIs use different header names:
- `X-API-Key` (default in our script)
- `api-key`
- `apikey`
- Custom headers via `-H "Custom-Key: value"`

### Basic Auth
Username + password (base64 encoded).

```bash
scripts/api_request.py https://api.example.com/resource \
  --auth-type basic \
  --auth-value "username:password"
```

Header sent: `Authorization: Basic <base64(username:password)>`

### Custom Headers
For non-standard auth:

```bash
scripts/api_request.py https://api.example.com/endpoint \
  -H "X-Custom-Auth: token" \
  -H "X-Client-ID: client-123"
```

## OAuth 2.0 Flow

Most OAuth APIs require a multi-step flow:

1. **Get authorization code** (manual browser step)
2. **Exchange for access token** (use api_request.py)
3. **Use access token** (bearer auth)

Example token exchange:

```bash
scripts/api_request.py https://oauth.example.com/token \
  -X POST \
  -d '{"grant_type":"authorization_code","code":"AUTH_CODE","client_id":"CLIENT_ID","client_secret":"SECRET"}'
```

## Security Notes

- Never commit API keys to version control
- Store credentials in environment variables or secure vaults
- Use `.env` files (gitignored) for local dev
- Rotate keys regularly
- Use least-privilege scopes when possible

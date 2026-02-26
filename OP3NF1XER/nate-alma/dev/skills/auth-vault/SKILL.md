---
name: auth-vault
description: Secure credential and token vault for passwords, bearer tokens, and OAuth lifecycles with retrieval and refresh helpers.
---

# Auth Vault

Use this skill for credentials that should not live in normal memory notes.

Vault path (Nate-Alma dev lane):

- `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/.secrets/auth-vault`

## Coverage

- Password records
- Bearer tokens
- OAuth token bundles (access + refresh + expiry + token endpoint)
- API keys
- Generic encrypted secret records
- Secure key generation for agent personas (for example Alma)
- Authorization header rendering
- OAuth refresh flow update
- Vault locator repair/doctor pass

## Commands

```bash
# Store bearer token
python skills/auth-vault/scripts/vault.py set-bearer --name railway-api --token "..."

# Store password
python skills/auth-vault/scripts/vault.py set-password --name gmail-main --username "nate@example.com" --password "..."

# Store oauth token bundle
python skills/auth-vault/scripts/vault.py set-oauth --name google-oauth --access-token "..." --refresh-token "..." --token-url "https://oauth2.googleapis.com/token" --client-id "..." --client-secret "..."

# Store API key
python skills/auth-vault/scripts/vault.py set-api-key --name openai-main --provider openai --key "..."

# Store generic encrypted secret
python skills/auth-vault/scripts/vault.py set-generic --name alma-webhook --secret-type webhook --secret "..."

# Generate a new key for Alma (encrypted at rest)
python skills/auth-vault/scripts/vault.py generate-key --name alma-agent-master-key --kind api-key --provider alma --prefix "alma_" --reveal

# Read safe metadata only
python skills/auth-vault/scripts/vault.py list

# Resolve an auth header
python skills/auth-vault/scripts/vault.py auth-header --name railway-api

# Refresh oauth token in-place
python skills/auth-vault/scripts/vault.py oauth-refresh --name google-oauth

# Repair old locator paths to this workspace vault
python skills/auth-vault/scripts/vault.py doctor

# Rotate Doctrine Bible web login (nate-bible-site-login)
python skills/auth-vault/scripts/update_bible_login.py --username "nate" --password "..."
```

## Security behavior

- Windows uses DPAPI-backed secure-string encryption by default.
- Other platforms prefer `keyring` if available.
- Plaintext fallback is disabled unless `--allow-plaintext-fallback` is explicitly used.

## Output contract

Every command returns structured JSON and never prints secret values unless `--reveal` is explicitly passed.

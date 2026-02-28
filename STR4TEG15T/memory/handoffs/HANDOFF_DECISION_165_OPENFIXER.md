# HANDOFF: DECISION_165 (ALMA Deployment Success + Admin Secrets Vault)

Owner: OpenFixer

This handoff adds two deliverables:

1) Enforceable, evidence-capturing deployment success gates ("online + reachable") across OpenClaw + SFTPGo + MongoDB (+ optional RAG if deployed).
2) A minimal encrypted CRUD secrets store at `OP3NF1XER/nate-alma/secrets`.

This handoff does not replace DECISION_146; it tightens completion gates and adds an operator secrets system.

## Files / Targets

- `C:\P4NTH30N\OP3NF1XER\nate-alma\secrets\` (new)
  - `store.json.enc` (encrypted store; created at runtime)
  - `alma-secrets.ps1` (or equivalent CLI entrypoint)
  - `README.md` (usage + policy)
  - `inventory.json` (non-secret index of what exists)

Optional (recommended) operator docs update:

- `C:\P4NTH30N\OP3NF1XER\nate-alma\dev\TOOLS.md`

## Secrets Store Requirements (Hard)

- Encrypted at rest: single file `store.json.enc`.
- CRUD commands:
  - `alma-secrets init`
  - `alma-secrets set <key> --value <string>`
  - `alma-secrets get <key>`
  - `alma-secrets del <key>`
  - `alma-secrets list`
- Master key via env var only:
  - `ALMA_SECRETS_KEY_B64` = base64 of 32 random bytes
- AEAD encryption:
  - AES-256-GCM acceptable (XChaCha20-Poly1305 preferred if straightforward)
- Atomic writes; no plaintext files on disk; no secret values logged.

## Success Gates (Evidence Required)

Capture outputs/screenshots/log snippets proving:

1) OpenClaw public health:
   - `curl -i https://<domain>/healthz` => 200

2) Setup wizard is gated:
   - `curl -i https://<domain>/setup` => 401/403 unless `SETUP_PASSWORD` provided

3) SFTPGo reachable via Railway TCP Proxy:
   - Record endpoint: `<tcp_proxy_host>:<tcp_proxy_port>`
   - Successful key-only login
   - Upload proof to `/data/workspace/` (file exists in container after upload)
   - Host key fingerprint recorded and stable across redeploy

4) MongoDB ping from inside `openclaw` service:
   - `mongosh "$MONGO_URL" --quiet --eval 'db.runCommand({ ping: 1 })'`

Optional (only if RAG deployed):

5) LM Anywhere readiness:
   - `curl -fsS <LM_ANYWHERE_BASE_URL>/models`

6) RAG round-trip:
   - minimal ingest + query proving the service is not just "up" but functional.

## Credential Inventory to Populate (Store + Railway)

Store these (encrypted) values locally and paste/manage them into Railway Variables as needed:

- `railway.openclaw.setup_password` (SETUP_PASSWORD)
- `railway.openclaw.gateway_token` (OPENCLAW_GATEWAY_TOKEN)
- `railway.mongodb.mongo_url` (MONGO_URL)

If enabling SFTP user creation via bootstrap:
- `sftpgo.bootstrap.username`
- `sftpgo.bootstrap.public_key` (not secret, but store ok)

If enabling AnythingLLM:
- `anythingllm.sig_key`
- `anythingllm.sig_salt`
- `anythingllm.jwt_secret`
- `anythingllm.auth_token` (if public auth enabled)

If enabling LightRAG:
- `lightrag.api_key`
- `lightrag.token_secret` (if JWT auth used)

If enabling LM Anywhere auth:
- `lm_anywhere.api_key`

## Policy Gates (Fail Fast)

- If any paid-provider keys are present by default (e.g. `OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY`): treat as violation and HOLD.
- MongoDB TCP proxy: disable by default; enabling requires explicit exception record.
- SFTPGo: key-only auth; disable password + keyboard-interactive.
- SFTPGo HTTP admin/rest/webclient: disabled or localhost-only.

## Copy/Paste Prompt for OpenFixer Execution

Implement DECISION_165.

1) Create `C:\P4NTH30N\OP3NF1XER\nate-alma\secrets\` with:
   - encrypted single-file store `store.json.enc`
   - CLI `alma-secrets` with init/set/get/del/list using AEAD
   - README and non-secret inventory.json.
2) Populate the store with keys needed for OpenClaw + MongoDB + (optional) RAG.
3) Produce a validation evidence bundle proving:
   - OpenClaw is online over HTTPS and `/setup` is gated.
   - SFTPGo is reachable via Railway TCP proxy, key-only, upload works, fingerprint stable.
   - MongoDB ping works from inside the container via $MONGO_URL.
4) If optional RAG is deployed, prove it is functional and uses LM Anywhere only.
5) Update `OP3NF1XER/nate-alma/dev/TOOLS.md` with real endpoints and fingerprints.

Return:
- The exact list of secrets keys created in `alma-secrets list`
- The recorded TCP proxy endpoint + SFTP hostkey fingerprint
- The exact Railway Variable set used for each service (names only; no values)

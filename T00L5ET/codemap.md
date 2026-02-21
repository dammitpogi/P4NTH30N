# T00L5ET/

## Responsibility

Hosts the multi-tool CLI dispatcher (DECISION_032 / 034) plus a suite of diagnosis, automation, and validation helpers that lean on the shared C0MMON/H4ND services.
The directory now acts as:
- **Config Deployer**: `Program` parses flags (`--dry-run`, `--agents-only`, `--rag`, `--rag-binary`) and serially copies agent prompts, MCP configs, and optionally publishes RAG binaries based on `deploy-manifest.json`.
- **Live Validator**: `LiveValidator` drives DECISION_045/044/041 by fetching a FireKirin credential, calling `FireKirin.QueryBalances`, checking OrionStars balances, and validating CDP login state via `CdpGameActions` plus jackpot readers.
- **Operational Automation**: `FireKirinLogin`, `GameNavigator`, `CdpDiagnostic`, and `CredCheck` automate login attempts, in-browser navigation, network diagnostics, and MongoDB credential inspection for the FireKirin platform.
- **Session Harvester**: `SessionHarvester` reads OpenCode SQLite sessions, tool outputs, and logs, serializes them into markdown, and optionally pushes documents into the RAG ingestion endpoint.

## Design

**Command Router**
- `Program` is a single-entry-point CLI that switches on the first argument (`validate`, `login`, `nav`, `diag`, `credcheck`, `harvest`) before falling back to deploy logic; the deploy path still coordinates manifest-driven file copies with SHA256 verification.
- Each tool exposes a `RunAsync`/`Run` entry that can be invoked directly (e.g., `LiveValidator.RunAsync`, `SessionHarvester.Run`).

**CDP‑first Automation**
- `FireKirinLogin` and `GameNavigator` both own CDP clients configured for `localhost:9222`, issue targeted `ClickAtAsync` sequences, capture screenshots, and instrument WebSocket traffic (`window._wsFrames`, `window._wsJackpots`) through `Page.addScriptToEvaluateOnNewDocument`.
- `CdpDiagnostic` leans on the CDP WebSocket, Network, and Security domains to inspect cookies, storage, transports, flags, console errors, and handshake behaviors for FireKirin pages.

**Data Harvesting Pattern**
- `SessionHarvester` opens `opencode.db` read-only, introspects schema, serializes rows into markdown artifacts under `rag/harvested`, and calls a configurable `rag_ingest_file` tool via HTTP when not in dry-run.
- Tool output and log cataloging happens separately but uses the same markdown + ingest template, ensuring consistent metadata (size, timestamp, snippet truncation).

## Flow

### CLI Dispatch Flow
```
dotnet run --project T00L5ET/T00L5ET.csproj -- [command] [flags]
    ↓
; command matches validate/login/nav/diag/credcheck/harvest → delegate to corresponding helper
    ↓
; otherwise → load deploy-manifest, copy agents/mcp artifacts, optionally publish binaries (rag/rag-binary) with hash verification
```

### Live Validation Flow
1. Connect to MongoDB, select the top FireKirin credential (enabled, not banned, positive balance).
2. Run `FireKirin.QueryBalances` (DECISION_045) and persist jackpot evidence in `T35T_R3SULT`.
3. Probe OrionStars (DECISION_041) via config endpoint and WebSocket query if credentials exist.
4. Connect to Chrome CDP, call `CdpGameActions.LoginFireKirinAsync`, verify with `CdpGameActions.VerifyGamePageLoadedAsync`, and read jackpots with `JackpotReader`.

### Automation & Diagnostics Flow
1. `FireKirinLogin` loops enabled credentials, reloads the FireKirin canvas, types into hidden inputs or dispatches key events, clicks login, waits for websocket-backed `window._wsLoginResult`, and records failures to `test-results/login_failures.log` plus screenshots.
2. `GameNavigator` uses sequential clicks to close overlays, navigate the slot sidebar, and launch Fortune Piggy (fallback to Gold777), capturing screenshots at each milestone.
3. `CdpDiagnostic` interrogates cookies, storage, WebSocket reachability (including wss://), security flags, and console errors; `CredCheck` inspects the `CRED3N7IAL` collection to enumerate houses and summarize counts of enabled FireKirin credentials.

### Session Harvest Flow
1. Open `opencode.db`, enumerate tables, and sample the most recent 50 sessions/messages; render each row as markdown and ingest if allowed.
2. Enumerate `tool-output` files and tail `log/*.log`, truncating oversized content; tag outputs with metadata headers before writing markdown slices under `rag/harvested/{sessions,tool-outputs,logs}`.
3. For each artifact, optionally POST to `http://127.0.0.1:5100/mcp` (configurable `--rag-url`). Dry runs skip disk writes and HTTP calls.

## Integration

### Dependencies
- **C0MMON**: Provides CDP helpers (`CdpClient`, `CdpGameActions`, `CdpGameActions.VerifyGamePageLoadedAsync`), infrastructure types (e.g., `CdpConfig`), and shared constants for Chrome/FireKirin automation.
- **H4ND**: Supplies services like `FireKirin.QueryBalances`, `OrionStars.QueryBalances`, `JackpotReader`, and any CDP-based game helpers used by the live validator.
- **MongoDB.Driver**: Accesses `CRED3N7IAL` and `T35T_R3SULT` collections for credential selection, diagnostics, and validation evidence.
- **Microsoft.Data.Sqlite**: Reads `opencode.db` for session harvesting.
- **System.Net.Http**: Fetches remote config endpoints (FireKirin config, OrionStars config) and optionally ingests harvested files into the RAG service.

### Consumers & Callers
- **DECISION_032**: Config deployment logic executed when no special command argument is passed; ensures agent prompts, MCP configs, and binaries stay in sync with `deploy-manifest.json`.
- **DECISIONS_041/044/045**: LIVE VALIDATOR reuses `FireKirin.QueryBalances` and `OrionStars.QueryBalances`, corroborating jackpot data and writing validation evidence back to MongoDB.
- **RAG pipelines**: Session/tool/log markdowns produced by `SessionHarvester` are meant for ingestion by downstream RAG systems via the `rag_ingest_file` tool.
- **Operations & Diagnostics**: Manual invocations of `credcheck`, `diag`, `login`, `nav`, and `validate` support troubleshooting FireKirin stability and player sessions.

### Build Integration
```
dotnet build T00L5ET/T00L5ET.csproj
dotnet run --project T00L5ET/T00L5ET.csproj -- [command] [args]
```

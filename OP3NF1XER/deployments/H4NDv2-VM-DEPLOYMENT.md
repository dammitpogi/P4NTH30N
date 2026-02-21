# H4NDv2 VM Deployment Journal

**Agent**: Vigil (OpenFixer)
**Date Started**: 2026-02-19
**Status**: In Progress — MongoDB directConnection blocker remaining
**VM**: H4NDv2-Production (Hyper-V, Windows 11)
**Target**: CDP-based jackpot execution pipeline running H4ND in isolated VM

---

## Mission

Deploy H4ND agent into a Hyper-V VM (`H4NDv2-Production`) that connects back to the host machine for Chrome CDP (port 9222) and MongoDB (port 27017). Validate the full stack with OPS-JP-002 (End-to-End Spin) and OPS-JP-003 (Failure Recovery).

---

## Architecture

```
┌──────────────────────────────────┐     ┌──────────────────────────────┐
│  HOST (Windows)                  │     │  VM: H4NDv2-Production       │
│                                  │     │  Windows 11                  │
│  Chrome CDP → 127.0.0.1:9222    │◄────│  H4ND.exe @ C:\H4ND\        │
│    ↕ portproxy                   │     │  IP: 192.168.56.10           │
│  192.168.56.1:9222 ──►127.0.0.1 │     │                              │
│                                  │     │  Connects to:                │
│  MongoDB → 0.0.0.0:27017        │◄────│   192.168.56.1:9222 (CDP)    │
│  Config: mongod.cfg (ProgramData)│     │   192.168.56.1:27017 (Mongo) │
│                                  │     │                              │
│  H4ND-Switch: 192.168.56.0/24   │     │  .NET 10 Preview 1           │
└──────────────────────────────────┘     └──────────────────────────────┘
```

---

## Chronological Log

### Phase 1: Infrastructure Provisioning ✅

**VM Creation & OS Install**
- Created H4NDv2-Production VM in Hyper-V
- Installed Windows 11 via oobe/bypassnro
- User: `h4ndv2.01`, credentials stored securely
- .NET 10 Preview 1 installed (self-contained publish, so runtime not strictly required)

**Network Configuration**
- Created H4ND-Switch (internal, 192.168.56.0/24)
- VM static IP: 192.168.56.10, gateway 192.168.56.1
- NAT configured for internet access from VM
- Firewall rules: CDP (9222) and MongoDB (27017) from VM subnet

### Phase 2: CDP Connectivity ✅

**Obstacle 1: Chrome CDP only binds to 127.0.0.1**
- `--remote-debugging-address=0.0.0.0` flag has no effect on modern Chrome
- Chrome CDP hardcodes localhost binding regardless of flags
- **Resolution**: `netsh interface portproxy add v4tov4 listenaddress=192.168.56.1 listenport=9222 connectaddress=127.0.0.1 connectport=9222`
- Must be re-added if networking stack resets

**Obstacle 2: CDP WebSocket URL contains `localhost`**
- Chrome's `/json/list` returns `ws://localhost:9222/devtools/page/...`
- VM fetches this URL and tries to connect to its own localhost
- **Resolution**: Modified `CdpClient.FetchDebuggerUrlAsync()` to replace `localhost` with configured HostIp
- File: `C0MMON/Infrastructure/Cdp/CdpClient.cs`

**Obstacle 3: CDP event message interleaving**
- `SendCommandAsync` read the next WebSocket message, which could be an event notification
- `eval(1+1)` returned 0 instead of 2 because the response was consumed by an event handler
- **Resolution**: Modified `SendCommandAsync` to loop until a message with matching command `id` is found, buffering unrelated events
- File: `C0MMON/Infrastructure/Cdp/CdpClient.cs`

**Final State**: All 4 CDP health checks pass (HTTP, WebSocket, Round-trip eval, Login flow). H4ND reports HEALTHY.

### Phase 3: MongoDB Connectivity 🔄 (CURRENT BLOCKER)

**Obstacle 4: MongoDB config file location mismatch**
- Assumed config at `C:\Program Files\MongoDB\Server\8.0\mongod.cfg`
- Actual service config: `C:\ProgramData\P4NTH30N\mongodb\mongod.cfg` (confirmed via service binary path)
- Both files updated to `bindIp: 0.0.0.0` for good measure
- **Resolution**: Updated correct config, restarted MongoDB service

**Obstacle 5: MongoDB replica set server discovery**
- MongoDB configured with `replSetName: rs0`
- Driver connects to `192.168.56.1:27017`, performs replica set discovery
- Member advertises itself as `localhost:27017`
- Driver redirects to `localhost:27017` — which is the VM itself (no MongoDB there)
- **Resolution**: Use `?directConnection=true` in connection string to bypass discovery

**Obstacle 6: Single-file publish and AppContext.BaseDirectory**
- Published H4ND as single-file self-contained exe
- `AppContext.BaseDirectory` resolves to temp extraction dir (`AppData\Local\Temp\.net\H4ND\<hash>\`)
- `mongodb.uri` file placed next to exe was never found
- **Resolution**: Switched to non-single-file publish (`PublishSingleFile=false`), files stay next to exe

**Obstacle 7: Environment variables not inherited in PowerShell Direct**
- Set `P4NTH30N_MONGODB_URI` via `[Environment]::SetEnvironmentVariable(..., "Machine")`
- Value set to `mongodb://192.168.56.1:27017/` (WITHOUT `?directConnection=true`)
- `MongoConnectionOptions.FromEnvironment()` reads env var FIRST, before file check
- Env var wins, file override never executes
- **Current State**: URI is `mongodb://192.168.56.1:27017/` — missing `?directConnection=true`
- **Root Cause Identified**: Machine-level env var was set early in debugging, before we understood the replica set issue. It takes precedence over the `mongodb.uri` file.
- **Fix**: Update the Machine-level env var to include `?directConnection=true`

### Phase 4: OPS-JP-002 End-to-End Spin ⏳ (Blocked by Phase 3)

- Test signal injected into SIGN4L collection
- 3 existing unacknowledged signals also present
- Awaiting MongoDB fix to proceed

### Phase 5: OPS-JP-003 Failure Recovery ⏳ (Blocked by Phase 3)

- Circuit Breaker: threshold=5, recovery=2min, all 4 unit tests pass
- DLQ discrepancy: Task references `V1S10N_DLQ` but H4ND logs rejections to console only; H0UND uses `D34DL3TT3R`

---

## Code Changes Made

| File | Change | Purpose |
|------|--------|---------|
| `C0MMON/Infrastructure/Persistence/MongoConnectionOptions.cs` | Added `mongodb.uri` file override with 3-path search + env var check | VM deployment config flexibility |
| `C0MMON/Infrastructure/Cdp/CdpClient.cs` | Rewrite `ws://localhost:` → `ws://{HostIp}:` in FetchDebuggerUrlAsync | Fix CDP WebSocket URL for remote access |
| `C0MMON/Infrastructure/Cdp/CdpClient.cs` | Loop on matching command ID in SendCommandAsync | Fix CDP event interleaving |

## Infrastructure Artifacts

| Artifact | Location | Purpose |
|----------|----------|---------|
| VM publish output | `c:\P4NTH30N\publish\h4nd-vm-full\` | Non-single-file self-contained build |
| VM appsettings | `c:\P4NTH30N\appsettings.vm.json` | CDP HostIp=192.168.56.1 |
| mongodb.uri (local) | `c:\P4NTH30N\publish\h4nd-vm-full\mongodb.uri` | `mongodb://192.168.56.1:27017/?directConnection=true` |
| mongodb.uri (VM) | `C:\H4ND\mongodb.uri` | Same — but overridden by env var |
| Port proxy | `netsh interface portproxy` on host | `192.168.56.1:9222 → 127.0.0.1:9222` |
| mongod.cfg | `C:\ProgramData\P4NTH30N\mongodb\mongod.cfg` | `bindIp: 0.0.0.0`, `replSetName: rs0` |

## Temp Scripts (Pending Cleanup)

43 temp scripts in `c:\P4NTH30N\temp_*.ps1` created during iterative debugging. To be cleaned up after verification complete.

---

## Next Steps (Pending Oracle Proposals)

1. **DECISION_OPS_004**: Fix MongoDB env var — update Machine-level `P4NTH30N_MONGODB_URI` to include `?directConnection=true`, restart H4ND, verify connection
2. **DECISION_OPS_005**: Execute OPS-JP-002 — End-to-End spin verification after MongoDB fix
3. **DECISION_OPS_006**: Execute OPS-JP-003 — Failure recovery verification (Circuit Breaker + DLQ)
4. **DECISION_OPS_007**: Cleanup — remove 43 temp scripts, consider reverting MongoConnectionOptions if env var approach is permanent
5. **DECISION_OPS_008**: DLQ Implementation — resolve V1S10N_DLQ vs D34DL3TT3R discrepancy, implement actual DLQ writes in H4ND pipeline

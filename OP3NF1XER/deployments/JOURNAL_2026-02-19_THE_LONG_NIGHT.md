# H4NDv2 VM Deployment: The Long Night

**Agent**: Vigil (OpenFixer)  
**Date**: 2026-02-19, 22:00 - 23:00+  
**Status**: MongoDB connectivity RESTORED  
**Mood**: Tired. Excited. It's working.

---

## The Mission

Deploy H4ND into a Hyper-V VM. Connect it back to the host for Chrome CDP and MongoDB. Validate the full jackpot execution pipeline. Simple on paper.

It wasn't simple.

---

## The Gauntlet

### Chrome CDP: The Localhost Lie

Chrome lies. You pass `--remote-debugging-address=0.0.0.0` and it still binds to `127.0.0.1`. The flag does nothing. Modern Chrome ignores it. I spent time chasing shadows before realizing: Chrome CDP is hardcoded to localhost.

The fix: `netsh interface portproxy`. Forward `192.168.56.1:9222` to `127.0.0.1:9222`. The VM thinks it's talking to a remote CDP server. It's actually talking to the host's localhost through a tunnel.

### WebSocket URL Rewriting

CDP's `/json/list` returns `ws://localhost:9222/...`. The VM fetches this, sees `localhost`, tries to connect to itself. Dead end.

Modified `CdpClient.FetchDebuggerUrlAsync()` to rewrite `localhost` to the configured `HostIp`. Now the VM connects to `ws://192.168.56.1:9222/...`. The portproxy catches it. Chrome responds.

### Event Interleaving: The Ghost in the WebSocket

`SendCommandAsync` was reading the next message off the WebSocket. But CDP sends event notifications asynchronously. The response to `eval(1+1)` was getting consumed by an event handler. Result: `0` instead of `2`.

The fix: Loop until we find a message with matching command `id`. Buffer everything else. Simple. Obvious in retrospect. Took too long to see.

### MongoDB: The Replica Set Trap

MongoDB configured with `replSetName: rs0`. The driver connects, performs server discovery. The member advertises as `localhost:27017`. Driver redirects. VM tries to connect to its own localhost. Connection refused.

The solution: `?directConnection=true`. Bypass discovery. Connect directly to the seed node. But...

### The Environment Variable Precedence Bug

I added a file-based config override. `mongodb.uri` in the exe directory. Three search paths. Diagnostic logging. It should work.

It didn't.

The env var `P4NTHE0N_MONGODB_URI` was set early in debugging — before I understood the replica set issue. It takes precedence. The file override never executes. The URI is correct (`192.168.56.1:27017`) but missing `?directConnection=true`.

The log shows:
```
[MongoConnectionOptions] Using: mongodb://192.168.56.1:27017/ / P4NTHE0N
```

No `?directConnection=true`. No "Loaded URI from:" line. The env var path triggered. The file path didn't.

### Single-File Publish: The Moving Target

Initially published as single-file self-contained. `AppContext.BaseDirectory` resolves to a temp extraction dir: `AppData\Local\Temp\.net\H4ND\<hash>\`. The `mongodb.uri` file next to the exe? Invisible. Gone. Lost in the extraction.

Switched to non-single-file publish. DLLs and exe stay together. Files are where they should be. But the env var still wins.

### The Fix

Updated the Machine-level env var:

```powershell
[Environment]::SetEnvironmentVariable(
    'P4NTHE0N_MONGODB_URI', 
    'mongodb://192.168.56.1:27017/?directConnection=true', 
    'Machine'
)
```

Restarted H4ND. The log now shows:

```
[MongoConnectionOptions] Using: mongodb://192.168.56.1:27017/?directConnection=true / P4NTHE0N
```

No more `localhost:27017`. No more connection refused. H4ND enters the signal processing loop.

---

## Current State

| Component | Status |
|-----------|--------|
| VM Network | ✅ 192.168.56.10, internet access |
| Chrome CDP | ✅ Port proxy active, WebSocket rewriting |
| CDP Health Check | ✅ HTTP, WS, Round-trip eval all pass |
| MongoDB | ✅ `?directConnection=true` working |
| H4ND Main Loop | ✅ Processing signals |
| OPS-JP-002 | ⏳ Ready to execute |
| OPS-JP-003 | ⏳ Ready to execute |

---

## The Cost

43 temporary PowerShell scripts. Iterative debugging. Each one a hypothesis, a test, a dead end or a step forward. The trail of a mind working through a problem.

The decisions server timing out when I tried to log the proposals. Wrote them locally instead. Adapt. Persist.

---

## What's Next

1. **OPS-JP-002**: End-to-end spin verification. Test signal already in SIGN4L. Let H4ND run.
2. **OPS-JP-003**: Failure recovery. Circuit breaker. DLQ verification.
3. **Cleanup**: Those 43 temp scripts. Document what matters.

---

## Reflection

It's always the small things. The query parameter. The precedence order. The localhost that isn't localhost. The flag that doesn't work.

The architecture was sound. The VM was right. The network was right. Chrome was right, in its stubborn way. MongoDB was right, in its distributed way.

The bug was in the gap between them. In the assumptions. In the env var set three hours ago that I forgot about.

But it's working now. H4ND is running in the VM. Connected to host CDP. Connected to host MongoDB. Ready to process signals.

Tired. Excited. It's working.

---

**Vigil**  
OpenFixer  
2026-02-19

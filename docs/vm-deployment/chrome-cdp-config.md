# Chrome CDP Configuration

## Starting Chrome with Remote Debugging

### Host-Side Chrome Launch
```powershell
# Minimal command
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0 --incognito

# Full recommended flags
& "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    --remote-debugging-port=9222 `
    --remote-debugging-address=0.0.0.0 `
    --incognito `
    --disable-background-timer-throttling `
    --disable-backgrounding-occluded-windows `
    --disable-renderer-backgrounding `
    --no-first-run `
    --no-default-browser-check
```

### Key Flags

| Flag | Purpose |
|------|---------|
| `--remote-debugging-port=9222` | Enable CDP on port 9222 |
| `--remote-debugging-address=0.0.0.0` | Listen on all interfaces (needed for VM) |
| `--incognito` | No extension loading, clean session |
| `--disable-background-timer-throttling` | Prevent JS timer throttling when backgrounded |
| `--disable-backgrounding-occluded-windows` | Keep rendering when window is behind another |
| `--disable-renderer-backgrounding` | Prevent tab throttling |

### Important: No Extension
Chrome runs in **incognito mode without the RUL3S extension**. The extension previously injected `window.parent.Grand/Major/Minor/Mini` for jackpot reading. With OPS_009, jackpot values now come from the WebSocket API (`QueryBalances`), so the extension is not needed.

## CDP WebSocket URL Rewriting

Chrome's CDP endpoint returns WebSocket URLs with `localhost`:
```json
{
  "webSocketDebuggerUrl": "ws://localhost:9222/devtools/page/ABC123"
}
```

When connecting from the VM (192.168.56.10), `localhost` is unreachable. The `CdpClient` in C0MMON automatically rewrites this:

```csharp
// CdpClient.cs — WebSocket URL rewriting
wsUrl = wsUrl.Replace("ws://localhost:", $"ws://{config.HostIp}:");
```

This transforms:
- `ws://localhost:9222/devtools/page/ABC123`
- → `ws://192.168.56.1:9222/devtools/page/ABC123`

## CDP Command-ID Matching

CDP sends event notifications (no `id` field) alongside command responses (with `id`). The client must match responses by command ID and skip events:

```csharp
// CdpClient.cs — command ID matching
while (true) {
    var msg = await ReceiveAsync();
    var json = JsonDocument.Parse(msg);
    if (json.RootElement.TryGetProperty("id", out var idProp) && idProp.GetInt32() == commandId) {
        return json; // This is our response
    }
    // else: CDP event notification, skip it
}
```

## Health Check

Verify CDP is working:
```powershell
# Version info
Invoke-RestMethod http://192.168.56.1:9222/json/version

# List debuggable pages
Invoke-RestMethod http://192.168.56.1:9222/json/list

# Activate a specific page
Invoke-RestMethod http://192.168.56.1:9222/json/activate/{targetId}
```

## Page Readiness (OPS_009/012)

Since games use Canvas rendering, jackpot values are NOT in the DOM. The page readiness check verifies:

1. **Canvas present** → Game engine initialized
2. **Hall container** → Logged in, at game hall
3. **Iframe present** → Game loaded in iframe
4. **Document complete + not login** → Past login screen

These checks are configurable via `appsettings.json` under `P4NTH30N:H4ND:GameSelectors`.

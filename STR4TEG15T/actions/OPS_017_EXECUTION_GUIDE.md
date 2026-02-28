# OPS_017: Jackpot Selector Discovery

## Status: READY FOR VM EXECUTION

OPS_018 (Enable Remote CDP Execution) is **COMPLETE**. The custom MCP server has been built and tested successfully.

## What Was Built

### Custom MCP Server: `p4nth30n-cdp-mcp`

Location: `C:\P4NTHE0N\chrome-devtools-mcp\`

**Tools Available:**
1. `get_version` - Get Chrome version and protocol info
2. `list_targets` - List CDP targets (pages, workers)
3. `navigate` - Navigate browser to URL
4. `evaluate_script` - Execute JavaScript on remote Chrome

**All tools accept optional `host` and `port` parameters** (default: 192.168.56.1:9222)

## Execution Steps on H4ND VM

### 1. Start Chrome on Host with CDP

On the **Windows host** (not VM):

```powershell
# Kill existing Chrome
Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force

# Start Chrome with CDP
Start-Process "chrome.exe" -ArgumentList "--remote-debugging-port=9222", "--remote-debugging-address=0.0.0.0", "--incognito"

# Verify port proxy
netsh interface portproxy show v4tov4
```

### 2. Run Discovery Script on VM

On the **H4ND VM** (192.168.56.10):

```powershell
# Navigate to the script
Set-Location C:\H4ND\ops017

# Run the discovery
node ops017-discover-selectors.js
```

### 3. Manual Discovery (Alternative)

If the automated script doesn't work, manually test selectors:

```powershell
# Start MCP server in HTTP mode
.\Start-CdpMcpServer.ps1 -Background

# Test a simple evaluation
$body = @{
    function = "() => document.title"
    host = "192.168.56.1"
    port = 9222
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3001/call/evaluate_script" -Method POST -Body $body -ContentType "application/json"
```

## Expected Output

The discovery script will generate:

1. `jackpot_selectors_discovery.json` - Raw discovery data
2. `jackpot_selectors.md` - Human-readable report

## Candidate Selectors to Test

### Window Variables
- `window.game`
- `window.jackpot`
- `window.Hall`
- `window.Grand`
- `window.Major`
- `window.Minor`
- `window.Mini`
- `window.jackpots`
- `window.bonus`
- `window.prizes`

### DOM Selectors
- `[data-jackpot]`
- `[class*="jackpot"]`
- `[id*="jackpot"]`
- `.grand-value`
- `.major-value`
- `.minor-value`
- `.mini-value`
- `.jackpot-grand`
- `.jackpot-major`
- `.jackpot-minor`
- `.jackpot-mini`

## Success Criteria

✓ Identify at least one reliable method to read each jackpot tier (Grand, Major, Minor, Mini)
✓ Document the exact JavaScript expression or DOM selector
✓ Verify values update in real-time as jackpots change
✓ Measure read latency (< 500ms acceptable)

## Next Steps After Discovery

Once selectors are discovered:

1. Update `OPS_009` with the discovered selectors
2. Refactor `ReadExtensionGrandAsync()` in `CdpGameActions.cs`
3. Test with actual game play

## Files

- Discovery script: `C:\P4NTHE0N\STR4TEG15T\actions\ops017-discover-selectors.js`
- MCP server: `C:\P4NTHE0N\chrome-devtools-mcp\server.js`
- Output location: `C:\P4NTHE0N\STR4TEG15T\knowledge\jackpot_selectors.md`

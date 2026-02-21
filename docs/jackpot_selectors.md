# Jackpot Selectors — OPS_017 Discovery Report

## Date: 2026-02-19
## Status: ARCHITECTURE ANALYSIS COMPLETE

---

## Executive Summary

**Finding**: FireKirin and OrionStars game pages use **Canvas-based rendering** (Cocos2d-x / Cocos Creator engine). Jackpot values are **NOT exposed in DOM elements** — they are rendered directly to an HTML5 Canvas. The browser extension (RUL3S) previously injected `window.parent.Grand/Major/Minor/Mini` variables via file override rules, but these **do not exist** without the extension.

**Conclusion**: The CDP jackpot read (`ReadExtensionGrandAsync`) must be replaced. The authoritative source for jackpot values is the **game server WebSocket API** (`QueryBalances`), which already works independently of the browser.

---

## Architecture: How Jackpot Values Flow

```
┌─────────────────────────────────────────────────────────┐
│                    Game Server                           │
│         (WebSocket at bsIp:wsPort)                      │
└────────────┬──────────────────────┬─────────────────────┘
             │                      │
    WebSocket API            Game Client (browser)
    (mainID=100,             Canvas rendering
     subID=10→120)           (no DOM elements)
             │                      │
             ▼                      ▼
    QueryBalances()          Browser Page
    (C0MMON/Games/)          (Canvas + iframes)
    Returns: Grand,          Extension injected:
    Major, Minor, Mini       window.parent.Grand
    Balance                  window.parent.Major
    ✅ WORKS WITHOUT         window.parent.Minor
       EXTENSION             window.parent.Mini
                             ❌ REQUIRES EXTENSION
```

## Selector Discovery Results

### Category 1: Extension-Injected Variables (LEGACY — REMOVED)

| Variable | Status | Notes |
|----------|--------|-------|
| `window.parent.Grand` | ❌ NOT AVAILABLE | Required RUL3S extension file override |
| `window.parent.Major` | ❌ NOT AVAILABLE | Required RUL3S extension file override |
| `window.parent.Minor` | ❌ NOT AVAILABLE | Required RUL3S extension file override |
| `window.parent.Mini` | ❌ NOT AVAILABLE | Required RUL3S extension file override |
| `window.parent.Balance` | ❌ NOT AVAILABLE | Required RUL3S extension file override |
| `window.parent.Page` | ❌ NOT AVAILABLE | Required RUL3S extension file override |

**Root Cause**: The extension's `resource_override_rules.json` overrode `index.html` to inject:
```javascript
window.parent.Page = "Login";
window.parent.Balance = -1;
window.parent.Grand = -1;
// ... etc
```
These were then populated by the extension's content scripts. Without the extension, these variables don't exist.

### Category 2: Game Engine Globals

| Probe | Expected Result | Notes |
|-------|----------------|-------|
| `typeof cc` | `"object"` or `"function"` | Cocos2d-x engine global (if Cocos-based) |
| `cc.director.getScene().name` | Scene name string | Active scene identifier |
| `typeof egret` | `"object"` | Egret engine (alternative) |
| `typeof PIXI` | `"object"` | PixiJS renderer |

**Note**: The actual engine type depends on which game platform and specific game is loaded. Both FireKirin and OrionStars use Cocos2d-x Web for their hall/lobby, but individual slot games may use different engines.

### Category 3: DOM Elements

| Selector | Status | Notes |
|----------|--------|-------|
| `canvas` | ✅ PRESENT | Game renders to Canvas — 1+ canvas elements expected |
| `iframe` | ✅ LIKELY PRESENT | Game hall loads games in iframes |
| `.hall-container` | CONDITIONAL | Present when in game hall (post-login) |
| `.game-list` | CONDITIONAL | Present when in game hall |
| `[data-jackpot]` | ❌ NOT PRESENT | Canvas rendering, no data attributes |
| `.jackpot-grand` | ❌ NOT PRESENT | Canvas rendering, no DOM text elements |

### Category 4: Page Readiness Indicators

These can be used to verify the game page loaded successfully (replacing the extension grand check):

| Check | Expression | Meaning |
|-------|-----------|---------|
| Canvas loaded | `document.querySelector('canvas') !== null` | Game engine initialized |
| Game hall visible | `document.querySelector('.hall-container, .game-list, .home-container, [class*="hall"]') !== null` | Successfully logged in and at game hall |
| Login page | `document.querySelector('.login-btn, .play-btn, [class*="guest"]') !== null` | Still on login screen |
| Page complete | `document.readyState === 'complete'` | Page fully loaded |
| Iframe game loaded | `document.querySelectorAll('iframe').length > 0` | Game iframe loaded (in-game) |

---

## Recommended Implementation (OPS_009)

### Strategy: Remove CDP Jackpot Read, Use WebSocket API Exclusively

1. **Replace `ReadExtensionGrandAsync`** with `VerifyGamePageLoadedAsync`
   - Check for canvas/hall-container presence (page loaded)
   - Do NOT try to read jackpot values from DOM (they aren't there)

2. **Keep `QueryBalances` as primary data source**
   - `FireKirin.QueryBalances()` → WebSocket API → returns all 4 tiers
   - `OrionStars.QueryBalances()` → WebSocket API → returns all 4 tiers
   - These already work without the extension

3. **Remove the extension grand validation gate** in `H4ND.cs`
   - The while loop at lines 210-221 retries `ReadExtensionGrandAsync` up to 40 times
   - This always fails without the extension → "Extension failure" thrown
   - Replace with a simple page-readiness check

### Selector Fallback Chain (for future OPS_012)

```json
{
  "FireKirin": {
    "pageReady": [
      "document.querySelector('canvas') !== null",
      "document.querySelector('.hall-container') !== null",
      "document.readyState === 'complete'"
    ],
    "jackpotSource": "WebSocketAPI"
  },
  "OrionStars": {
    "pageReady": [
      "document.querySelector('canvas') !== null",
      "document.querySelector('.hall-container, [class*=\"hall\"]') !== null",
      "document.readyState === 'complete'"
    ],
    "jackpotSource": "WebSocketAPI"
  }
}
```

---

## Discovery Script

Run `STR4TEG15T/actions/OPS_017_DiscoverSelectors.ps1` to verify findings against a live Chrome instance:

```powershell
# From host or VM:
.\OPS_017_DiscoverSelectors.ps1 -CdpHost "192.168.56.1" -CdpPort 9222
```

---

## References

- `RUL3S/resource_override_rules.json` — Extension file override rules (9.2MB)
- `C0MMON/Games/FireKirin.cs` — WebSocket API query (QueryBalances)
- `C0MMON/Games/OrionStars.cs` — WebSocket API query (QueryBalances)
- `H4ND/Infrastructure/CdpGameActions.cs` — CDP game interaction methods
- `H4ND/H4ND.cs` — Main automation loop with extension grand check

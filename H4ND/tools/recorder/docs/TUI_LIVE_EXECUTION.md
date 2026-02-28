# P4NTHE0N Recorder TUI — Live Execution Guide

**Version**: 2.1  
**Date**: 2026-02-21  
**Status**: Production-ready editor and debugger

---

## Overview

The Recorder TUI v2.0 is a **real editor and debugger** for macro workflows. It connects directly to Chrome via the Chrome DevTools Protocol (CDP) and executes steps live — clicking, typing, navigating, waiting, and capturing screenshots in real time.

### What Changed from v1.0

| Feature | v1.0 (Simulation) | v2.0 (Live) |
|---------|-------------------|-------------|
| Run Mode | Fake status icons | Real CDP execution |
| Click | Simulated pass | `Input.dispatchMouseEvent` sent to Chrome |
| Type | Simulated pass | `Input.dispatchKeyEvent` character-by-character |
| Navigate | Simulated pass | `Page.navigate` to URL |
| Wait | Instant advance | Real `setTimeout` with abort support |
| Screenshot | CDP ping only | `Page.captureScreenshot` → PNG saved to session dir |
| Breakpoints | Visual only | Pauses real execution, Space=step / A=resume |
| Auto-run | N/A | Default mode — runs all steps, pauses at breakpoints |
| CDP Status | N/A | Header shows CDP:ON/CDP:OFF |
| Window Mgmt | N/A | Chrome brought to front on run, TUI refocused for input |
| Run Summary | N/A | `run-summary.json` written to session dir on completion |

---

## Architecture

```
recorder-tui.ts          Entry point
  └─ tui/app.ts          Main TUI (state machine, views, input)
       ├─ tui/types.ts   MacroStep, AppState, ViewMode
       ├─ tui/screen.ts  ANSI rendering primitives
       └─ tui/runner.ts  CDP runner (NEW — real execution)
            └─ cdp-client.ts  Chrome DevTools Protocol client
```

### Runner Module (`tui/runner.ts`)

The `TuiRunner` class wraps `CdpClient` and provides:

- **`ensureChrome()`** — Checks CDP port 9222, spawns Chrome if needed, waits up to 10s
- **`connect()`** — WebSocket connection to first page target
- **`executeStep(step)`** — Dispatches action via CDP, waits for delay, captures screenshot
- **`takeScreenshot(label)`** — Standalone screenshot capture
- **`abort()`** — Signals current step to stop (checked during wait/delay loops)
- **`disconnect()`** — Closes WebSocket connection

---

## Quick Start

### 1. Launch TUI

```bash
cd C:\P4NTHE0N\H4ND\tools\recorder
bun run tui
```

### 2. Connect to Chrome

Press **F** in the step list view. The TUI will:
1. Check if Chrome is running on port 9222
2. If not, spawn `chrome.exe` with required flags (CDP, incognito, insecure content allowed)
3. Connect via WebSocket to the first page target
4. Show `CDP:ON` in the header

**Required Chrome flags** (auto-applied):
```
--remote-debugging-port=9222
--remote-debugging-address=127.0.0.1
--incognito
--no-first-run
--ignore-certificate-errors
--disable-web-security
--allow-running-insecure-content
--disable-features=SafeBrowsing
```

> `--allow-running-insecure-content` is **critical** — without it, `ws://` WebSocket connections to game servers are blocked from HTTPS pages.

### 3. Run Steps

Press **R** to enter run mode (auto-connects if needed). Then:

- **Space** — Execute one step at a time (single-step debugging)
- **A** — Auto-run all remaining steps (pauses at breakpoints)
- **Esc** — Abort execution and return to step list

---

## Run Mode Interface

```
┌─ Run Mode [AUTO] ────────────────────────┐┌─ Execution ──────────────┐
│ Progress: ████████░░░░░░░░░░░░ 6✓ 0✗ /14││ Step 7: click            │
│                                           ││                          │
│ ✓   1 [Login] navigate        1203ms      ││ Coords: (460, 367)       │
│ ✓   2 [Login] wait            5012ms      ││ Delay:  600ms            │
│ ✓   3 [Login] click           623ms       ││                          │
│ ✓   4 [Login] type            1842ms      ││ ✓ Clicked (460, 367)     │
│ ✓   5 [Login] click           589ms       ││ Duration: 623ms          │
│ ✓   6 [Login] type            1756ms      ││ 📸 sessions/tui-run.../  │
│ ⟳ ● 7 [Login] click           —           ││   007_step07_click.png   │
│ ○   8 [Login] wait            —           ││                          │
│ ○   9 [GameS] click           —           ││ Click LOGIN button       │
│ ○  10 [GameS] wait            —           │└──────────────────────────┘
│                                           │
│ BREAKPOINT at step 9 — Space to continue  │
│ Session: C:\...\sessions\tui-run-2026-... │
├───────────────────────────────────────────┤
│ Space Step  Auto-Run  Esc/Q Abort         │
└───────────────────────────────────────────┘
```

### Left Panel
- **Status icons**: ✓ passed, ✗ failed, ⟳ running, ○ pending
- **Breakpoint indicator**: Red ● next to step number
- **Duration**: Shown after execution completes
- **Progress bar**: Shows passed + failed vs total

### Right Panel
- **Step details**: Coordinates, input, delay
- **Execution result**: Success/failure message
- **Duration**: Total time including delay
- **Screenshot path**: Where the PNG was saved
- **Comment**: From step configuration

---

## Step Actions

### click
Dispatches `mousePressed` + `mouseReleased` at `(x, y)` coordinates via CDP `Input.dispatchMouseEvent`. Followed by the configured delay.

### type
Sends each character via `Input.dispatchKeyEvent` with 40ms inter-key delay. Uses the `input` field value.

### longpress
Dispatches `mousePressed`, waits for `delayMs` milliseconds, then `mouseReleased`. The delay field controls hold duration.

### navigate
Extracts the first URL (`https?://...`) from the step's `comment` field and calls `Page.navigate`. If no URL found, the step reports an error but continues.

### wait
Pauses for `delayMs` milliseconds. The wait is chunked into 200ms intervals so it can be aborted mid-wait.

---

## Breakpoints

Toggle breakpoints with **B** in the step list. During execution:

- **Single-step mode (Space)**: Breakpoints are checked before each step. Execution pauses and shows a red `BREAKPOINT` banner.
- **Auto-run mode (A)**: Auto-run stops at breakpoints. Press **Space** to continue one step, or **A** to resume auto-run.

Breakpoints are saved to `step-config.json`.

---

## Screenshots

### During Execution
If `takeScreenshot` is `true` on a step, a PNG is captured after the action completes. Screenshots are saved to:

```
sessions/tui-run-YYYY-MM-DDTHH-MM-SS/
  001_step01_navigate.png
  002_step03_click.png
  ...
```

### Manual Screenshots
Press **S** in the step list to capture a screenshot at any time (requires CDP connection). Saved with a `manual_` prefix.

---

## Error Handling

- **CDP not running**: Press F to connect, or R will auto-connect
- **Step fails**: Step marked with ✗, error shown in right panel. In single-step mode, execution pauses. In auto-run mode, execution continues.
- **Abort**: Press Esc during execution. Current step's wait/delay is interrupted within 200ms.
- **Chrome crashes**: CDP:OFF shown in header. Press F to reconnect.

---

## Session Directory

Each run creates a session directory under `sessions/`:

```
sessions/
  tui-run-2026-02-21T12-30-00/
    001_step01_navigate.png
    002_step03_click.png
    003_step07_click.png
    ...
```

The session path is shown in the run mode view.

---

## Keyboard Reference

### Step List
| Key | Action |
|-----|--------|
| ↑/↓ | Navigate steps |
| Enter | View step detail |
| A | Add step |
| E | Edit step |
| D | Delete step |
| C | Clone step |
| B | Toggle breakpoint |
| U/J | Move step up/down |
| **F** | **Connect to Chrome (CDP)** |
| **R** | **Run from cursor (live CDP)** |
| **S** | **Take screenshot (CDP)** |
| P | Toggle platform |
| ? | Help |
| Q | Quit (auto-saves) |

### Run Mode
| Key | Action |
|-----|--------|
| **Space** | **Execute next step** |
| **A** | **Auto-run all (pauses at breakpoints)** |
| **Esc** | **Abort / stop auto-run** |

### Global
| Key | Action |
|-----|--------|
| Ctrl+S | Save config |
| Ctrl+C | Quit (auto-saves, disconnects CDP) |

---

## Integration with step-config.json

The TUI reads and writes `step-config.json`. Each step maps directly to a CDP action:

```json
{
  "stepId": 3,
  "phase": "Login",
  "action": "click",
  "coordinates": { "x": 460, "y": 367 },
  "delayMs": 600,
  "takeScreenshot": true,
  "screenshotReason": "After clicking account field",
  "comment": "Click ACCOUNT field on Canvas login",
  "breakpoint": false,
  "tool": "none",
  "verification": { "entryGate": "", "exitGate": "" }
}
```

Runtime fields (`_status`, `_lastResult`, `_screenshotPath`, `_durationMs`) are never saved.

---

## Troubleshooting

### "CDP not responding on port 9222"
Chrome is not running with CDP. Press F to auto-launch, or start manually:
```bash
chrome.exe --remote-debugging-port=9222 --remote-debugging-address=127.0.0.1 --incognito --no-first-run --ignore-certificate-errors --disable-web-security --allow-running-insecure-content --disable-features=SafeBrowsing --user-data-dir="%TEMP%\chrome_debug_tui"
```

### "No page target found"
Chrome is running but has no open tabs. Open a tab first, then press F.

### "Navigate — no URL found in comment"
The `navigate` action extracts URLs from the step's `comment` field. Add the URL:
```
comment: "Navigate to https://play.firekirin.in/index_v3.html"
```

### Screenshots not saving
Check that the session directory is writable. The TUI creates `sessions/tui-run-*/` in the recorder directory.

### WebSocket blocked (mixed content)
Ensure Chrome was launched with `--allow-running-insecure-content`. The TUI's auto-launch includes this flag.

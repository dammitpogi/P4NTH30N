# DECISION_077 Recorder Operator Manual

## Overview
Screenshot-guided navigation recording system for mapping FireKirin/OrionStars workflows.

---

## Session Lifecycle

### 1. Initialize Session
```powershell
cd C:\P4NTHE0N\H4ND\tools\recorder
bun run recorder.ts --init --platform={firekirin|orionstars} --decision=DECISION_077
```
**Output**: Session directory path (save this)

### 2. Record Steps
```powershell
bun run recorder.ts --step \
  --phase={Login|GameSelection|Spin} \
  --screenshot={filename}.png \
  --session-dir="{session-path}" \
  --run-tool={diag|login|nav|credcheck|none}
```

---

## Step Configuration Schema

Each step requires a JSON configuration file:

**File**: `{session-dir}/step-config.json`

```json
{
  "steps": [
    {
      "stepId": 1,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Initial login screen state before any interaction",
      "comment": "FireKirin login page loaded. Username field visible at {460, 367}.",
      "tool": "diag",
      "coordinates": {
        "accountField": {"x": 460, "y": 367},
        "passwordField": {"x": 460, "y": 437},
        "loginButton": {"x": 553, "y": 567}
      },
      "verification": {
        "entryGate": "Login form visible with username/password fields",
        "exitGate": "CDP responsive, page readyState complete"
      }
    },
    {
      "stepId": 2,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "After clicking account field, before typing",
      "comment": "Account field focused, cursor visible. Ready for username input.",
      "tool": "none",
      "action": "click",
      "coordinates": {"x": 460, "y": 367},
      "verification": {
        "entryGate": "Field focused",
        "exitGate": "Cursor visible in account field"
      }
    },
    {
      "stepId": 3,
      "phase": "Login",
      "takeScreenshot": false,
      "screenshotReason": "Typing action - no visual change in screenshot",
      "comment": "Typed username 'MelodyS68fk' into account field. Canvas accepted input.",
      "tool": "none",
      "action": "type",
      "input": "MelodyS68fk",
      "verification": {
        "entryGate": "Field focused",
        "exitGate": "Username visible in field"
      }
    }
  ]
}
```

---

## Step Configuration Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `stepId` | number | Yes | Sequential step identifier |
| `phase` | string | Yes | Login, GameSelection, or Spin |
| `takeScreenshot` | boolean | Yes | true = capture screen, false = skip |
| `screenshotReason` | string | Yes | Why this screenshot matters |
| `comment` | string | Yes | Operator observation at this step |
| `tool` | string | Yes | diag, login, nav, credcheck, none |
| `action` | string | No | click, type, longpress, navigate |
| `coordinates` | object | No | {x, y} for click actions |
| `input` | string | No | Text to type (if action=type) |
| `verification` | object | Yes | Entry and exit criteria |

---

## Screenshot Decision Guide

### ALWAYS Take Screenshot (`takeScreenshot: true`)
- Initial state of each phase
- After significant UI changes
- Before/after authentication
- Game loaded confirmation
- Error states
- Unexpected behavior

### SKIP Screenshot (`takeScreenshot: false`)
- Typing actions (no visual change)
- Rapid successive clicks
- Retry loops (screenshot first attempt only)
- Successful verification already captured

---

## Operating H4ND

### Prerequisites
1. Chrome running with CDP:
   ```powershell
   chrome.exe --remote-debugging-port=9222 --remote-debugging-address=127.0.0.1 --incognito
   ```
2. MongoDB accessible at `localhost:27017`
3. Valid credentials in `CRED3N7IAL` collection

---

## Manual Navigation Workflow

### Step 1: CDP Check
```powershell
bun run recorder.ts --step \
  --phase=Login \
  --screenshot=001.png \
  --session-dir="{path}" \
  --run-tool=diag
```
**Expected**: CDP connected, version info returned

### Step 2: Navigate to Platform
- Manually navigate to `http://play.firekirin.in/web_mobile/firekirin/`
- Screenshot login screen → `002.png`

### Step 3: Execute Login
```powershell
bun run recorder.ts --step \
  --phase=Login \
  --screenshot=002.png \
  --session-dir="{path}" \
  --run-tool=login
```

### Step 4: Verify Lobby
- Check for SLOT/FISH categories
- Screenshot → `003.png`
- Record game selection coordinates

### Step 5: Navigate to Game
```powershell
bun run recorder.ts --step \
  --phase=GameSelection \
  --screenshot=003.png \
  --session-dir="{path}" \
  --run-tool=nav
```

### Step 6: Verify Game Loaded
- Check for SPIN button
- Screenshot → `004.png`
- Record spin coordinates

### Step 7: Execute Spin
- Click spin button
- Screenshot result → `005.png`

---

## Comment Template

Use this format for `comment` field:

```
[Platform] [Phase] - [Action] - [Result] - [Observation]
```

### Examples:
- `"FireKirin Login - Click account field - Success - Cursor appeared, field highlighted"`
- `"FireKirin Login - Type username - Success - Text accepted, dots appeared"`
- `"OrionStars Login - Click password field - Failure - No cursor, Canvas not responding"`

---

## Verification Checklist

Before proceeding to next step, verify:
- [ ] Screenshot captured (if `takeScreenshot=true`)
- [ ] Comment describes current state
- [ ] Coordinates recorded (if click action)
- [ ] Tool output saved
- [ ] Exit gate criteria met

---

## Troubleshooting

### CDP Connection Refused
- **Cause**: Chrome not running with `--remote-debugging-port=9222`
- **Solution**: Restart Chrome with CDP flags

### Login Fails
- Check credential exists in MongoDB
- Verify platform URL correct
- Retry with `--run-tool=login`

### Canvas Typing Fails
- **FireKirin**: Should work with CDP typing
- **OrionStars**: Document failure, try alternative strategies

---

## Output Files

After session completes:
1. `session.ndjson` - Machine-readable step log
2. `session.md` - Human-readable narrative
3. `screenshots/` - All captured images
4. `step-config.json` - Your step definitions

---

## Next Steps

1. Initialize session
2. Create `step-config.json` with planned steps
3. Execute steps one at a time
4. Record observations in comments
5. Generate final navigation map

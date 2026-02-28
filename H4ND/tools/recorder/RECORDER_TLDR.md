# recorder.ts TL;DR

## What It Does
Screenshot-guided navigation recorder for mapping FireKirin/OrionStars workflows. Records each step with screenshots, coordinates, tool outputs, and verification gates.

## Quick Start

### 1. Record a Step (Auto-Starts Chrome)
```powershell
cd C:\P4NTHE0N\H4ND\tools\recorder
bun run recorder.ts --step --phase=Login --screenshot=001.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\FK_001" --run-tool=diag
```

**What Happens:**
- ✅ Checks if Chrome is running on port 9222
- ✅ If not, kills existing Chrome and starts fresh with CDP
- ✅ Creates session directory if missing
- ✅ Runs T00L5ET diagnostic tool
- ✅ Captures screenshot metadata
- ✅ Records step to `session.ndjson` and `session.md`

### 2. Available Tools
- `--run-tool=diag` - CDP connection check
- `--run-tool=login` - Execute login via T00L5ET
- `--run-tool=credcheck` - Verify credentials in MongoDB
- `--run-tool=nav` - Navigation helper
- `--run-tool=none` - Manual step (no tool execution)

### 3. Phases
- `--phase=Login` - Login workflow steps
- `--phase=GameSelection` - Game selection steps
- `--phase=Spin` - Spin execution steps

## Example Workflow

```powershell
# Step 1: Check CDP and take initial screenshot
bun run recorder.ts --step --phase=Login --screenshot=001_login_page.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\FK_001" --run-tool=diag

# Step 2: Record clicking account field (manual action)
bun run recorder.ts --step --phase=Login --screenshot=002_account_focused.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\FK_001" --run-tool=none

# Step 3: Record typing username (no screenshot needed)
bun run recorder.ts --step --phase=Login --screenshot=003_username_entered.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\FK_001" --run-tool=none

# Step 4: Execute login
bun run recorder.ts --step --phase=Login --screenshot=004_login_clicked.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\FK_001" --run-tool=login
```

## Output Files

After each step:
- `session.ndjson` - Machine-readable log (one JSON object per line)
- `session.md` - Human-readable report with screenshots, coordinates, tool output
- `screenshots/` - All captured images

## Chrome Auto-Start

The recorder now **automatically**:
1. Checks if Chrome is running on port 9222
2. Kills existing Chrome if running without CDP
3. Starts fresh Chrome with correct CDP flags
4. Waits for Chrome to initialize (up to 10 seconds)
5. Proceeds with tool execution

**No manual Chrome setup needed!**

## Key Features

✅ **Auto-creates session directories** - No need to run `--init`  
✅ **Auto-starts Chrome with CDP** - Handles port conflicts  
✅ **Records coordinates** - From phase definitions  
✅ **Tool integration** - Runs T00L5ET commands  
✅ **Verification gates** - Entry/exit criteria for each step  
✅ **Screenshot metadata** - Links visual state to actions  

## Common Use Cases

### Record Manual Navigation
```powershell
# Just record what you see, no tool execution
bun run recorder.ts --step --phase=Login --screenshot=current_state.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\manual_001" --run-tool=none
```

### Verify CDP Connection
```powershell
# Quick diagnostic check
bun run recorder.ts --step --phase=Login --screenshot=check.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\diag_001" --run-tool=diag
```

### Execute Automated Login
```powershell
# Run full login via T00L5ET
bun run recorder.ts --step --phase=Login --screenshot=login_attempt.png --session-dir="C:\P4NTHE0N\DECISION_077\sessions\auto_login" --run-tool=login
```

## View Results

```powershell
# Human-readable report
Get-Content "C:\P4NTHE0N\DECISION_077\sessions\FK_001\session.md"

# Machine-readable log
Get-Content "C:\P4NTHE0N\DECISION_077\sessions\FK_001\session.ndjson"

# Screenshots
Get-ChildItem "C:\P4NTHE0N\DECISION_077\sessions\FK_001\screenshots\"
```

## Troubleshooting

**Chrome won't start:**
- Check if `chrome.exe` is in PATH
- Manually kill Chrome: `taskkill /F /IM chrome.exe`
- Try again

**T00L5ET not found:**
- Verify path: `C:\P4NTHE0N\T00L5ET\bin\Debug\net10.0-windows7.0\T00L5ET.exe`
- Build T00L5ET if missing

**Session directory errors:**
- Recorder auto-creates directories now
- Ensure you have write permissions to `C:\P4NTHE0N\DECISION_077\sessions\`

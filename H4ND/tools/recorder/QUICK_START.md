# Quick Start: Operating the Recorder

## 5-Minute Setup

1. **Open PowerShell**

2. **Initialize session:**
   ```powershell
   cd C:\P4NTH30N\H4ND\tools\recorder
   bun run recorder.ts --init --platform=firekirin
   ```

3. Save the session directory path (printed in output)

---

## Recording Your First Step

1. **Start Chrome with CDP:**
   ```powershell
   chrome.exe --remote-debugging-port=9222 --incognito
   ```

2. Navigate to FireKirin login page

3. Take screenshot, save as `001.png`

4. **Record step:**
   ```powershell
   bun run recorder.ts --step \
     --phase=Login \
     --screenshot=001.png \
     --session-dir="PASTE_SESSION_PATH_HERE" \
     --run-tool=diag
   ```

5. Check output in `session.md`

---

## Step-by-Step Workflow

| Step | Action | Screenshot | Tool | Comment |
|------|--------|------------|------|---------|
| 1 | Open login page | Yes | diag | Initial state |
| 2 | Click account field | Yes | none | Field focused |
| 3 | Type username | No | none | Text entered |
| 4 | Click password field | Yes | none | Field focused |
| 5 | Type password | No | none | Masked input |
| 6 | Click login | Yes | login | Auth attempt |
| 7 | Verify lobby | Yes | none | SLOT visible |
| 8 | Click Fortune Piggy | Yes | nav | Game selected |
| 9 | Verify game loaded | Yes | none | SPIN button visible |
| 10 | Click spin | Yes | none | Spin executed |

---

## Common Commands

**Check CDP status:**
```powershell
curl http://127.0.0.1:9222/json/version
```

**View session log:**
```powershell
cat C:\P4NTH30N\DECISION_077\sessions\{session-id}\session.md
```

**List all screenshots:**
```powershell
ls C:\P4NTH30N\DECISION_077\sessions\{session-id}\screenshots\
```

---

## Tips

- Always verify CDP is running before starting
- Use meaningful screenshot filenames (`001_login`, `002_lobby`, etc.)
- Write detailed comments - future you will thank you
- If a step fails, document why before retrying

---

## Next Steps

After completing your first recording session:
1. Review `session.md` for completeness
2. Verify all screenshots captured correctly
3. Check `step-config.json` matches your observations
4. Use the navigation map to build automated workflows

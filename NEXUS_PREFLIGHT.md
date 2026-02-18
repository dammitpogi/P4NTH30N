# NEXUS PRE-FLIGHT CHECKLIST

**Before Fixer Begins Work**

---

## STEP 1: Configure WindSurf Settings (Nexus Only)

Fixer cannot change these - you must set them before Fixer starts.

### Open WindSurf Settings (Ctrl+,)

Copy-paste this into your `settings.json`:

```json
{
  // TERMINAL - Allow Fixer to run commands without approval
  "windsurf.terminalAutoExecution": "turbo",
  "windsurf.cascadeCommandsAllowList": [
    "dotnet", "bun", "npm", "node", "git", 
    "python", "powershell", "bash", "mkdir", "cp"
  ],
  "windsurf.cascadeCommandsDenyList": [
    "rm -rf /", "format", "diskpart"
  ],
  
  // GITIGNORE - Allow Fixer to edit config files
  "windsurf.cascadeGitignoreAccess": true,
  
  // AUTO-SAVE - Prevent file conflicts
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000
}
```

### Toggle These Settings ON:
- [ ] **Settings → Terminal Auto Execution**: Set to "Turbo"
- [ ] **Settings → Cascade Gitignore Access**: Toggle ON

---

## STEP 2: Verify Permissions

Test these commands in WindSurf terminal - they should run WITHOUT prompting:

```bash
echo "Testing permissions"
mkdir test_fixer_dir
ls test_fixer_dir
rm -rf test_fixer_dir
```

**If any prompt appears**: Settings not applied correctly. Check Step 1.

---

## STEP 3: Confirm MCP Servers Active

Verify these are already running (they should be):
- ✅ MongoDB MCP (for decisions)
- ✅ ToolHive MCP (for tools)
- ✅ Decisions-server MCP

Check: WindSurf → Settings → MCP → Verify servers listed

---

## STEP 4: Load Fixer Context

Copy-paste into WindSurf chat:

```
You are Fixer (Vigil). Read and follow the comprehensive prompt in:
C:/P4NTH30N/FIXER_PROMPT.md

Your mission: Complete all decisions marked Proposed or InProgress.
Start with INFRA-009 (In-House Secrets Management).

Work autonomously. Build to last. Comment thoroughly.
Do not stop for prompts unless security critical.
```

---

## STEP 5: Execute

Once settings are configured:
1. Load Fixer prompt above
2. Fixer queries decisions-server for active decisions
3. Fixer begins autonomous implementation
4. Monitor via T4CT1CS updates

---

## WHAT FIXER CAN/CANNOT DO

| Task | Can Fixer Do It? |
|------|------------------|
| Read/write code files | ✅ Yes |
| Execute terminal commands | ✅ Yes (if Turbo mode enabled) |
| Query decisions-server | ✅ Yes |
| Update decision status | ✅ Yes |
| Change WindSurf settings | ❌ No (Nexus must do this) |
| Access gitignored files | ⚠️ Only if you enabled toggle |
| Install MCP servers | ❌ No (Nexus must do this) |

---

## READY CHECKLIST

Before saying "Go Fixer":

- [ ] WindSurf terminal set to "Turbo"
- [ ] Gitignore access toggle ON
- [ ] Test commands run without prompts
- [ ] MCP servers showing as connected
- [ ] FIXER_PROMPT.md loaded into context
- [ ] You understand Fixer will work autonomously

---

## EMERGENCY STOP

If Fixer goes wrong:
1. **Immediate**: Ctrl+C in terminal
2. **Pause**: Say "Fixer stop" in chat
3. **Review**: Check T4CT1CS/speech/ for updates
4. **Correct**: Give specific correction, resume

---

**Status**: ⏳ Waiting for Nexus to complete Step 1-2
**Next Action**: Configure WindSurf settings, then say "Go Fixer"

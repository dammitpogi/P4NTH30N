# WindSurf Permissions Configuration Guide

**Goal**: Open permissions for Fixer to work autonomously without stopping for prompts

---

## 1. Terminal Auto-Execution (Most Critical)

**Location**: WindSurf Settings → Terminal auto-execution

**Recommended Setting**: **Turbo**

**Configuration**:
```json
// settings.json
{
  "windsurf.cascadeCommandsAllowList": [
    "dotnet",
    "bun",
    "npm",
    "node",
    "git",
    "mkdir",
    "cp",
    "mv",
    "rm",
    "powershell",
    "bash",
    "python",
    "pip",
    "docker",
    "kubectl"
  ],
  "windsurf.cascadeCommandsDenyList": [
    "rm -rf /",
    "format",
    "diskpart",
    "dd",
    "del /f /s /q C:\\" 
  ]
}
```

**UI Path**:
1. Open WindSurf
2. File → Preferences → Settings (Ctrl+,)
3. Search "cascade terminal"
4. Set "Terminal Auto Execution" to **Turbo**
5. Add allowed commands to allowlist

---

## 2. File Access Permissions

### A. Gitignore Access (Critical for Fixer)

**Location**: WindSurf Settings → "Cascade Gitignore Access"

**Setting**: **Toggle ON** ✅

**Why**: Fixer needs to edit files that may be in .gitignore (config files, secrets templates, etc.)

### B. Workspace Boundaries

**Current**: WindSurf operates within workspace only

**Extension via MCP**:
```json
// MCP servers configuration
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:/P4NTHE0N", "C:/Users/paulc/.config/opencode"]
    }
  }
}
```

**UI Path**:
1. WindSurf Settings → MCP
2. Add Filesystem MCP server
3. Configure allowed directories:
   - `C:/P4NTHE0N` (main project)
   - `C:/Users/paulc/.config/opencode` (configs)
   - `C:/Users/paulc/.config/opencode/dev` (plugin dev)

---

## 3. File Edit Permissions

### A. Indexing Controls

**Current Defaults** (can block Fixer):
- Ignores: `.gitignore` paths, `node_modules`, hidden dot-paths

**Solution - .codeiumignore**:
Create `C:/P4NTHE0N/.codeiumignore`:
```
# Allow access to normally ignored files
!.env.template
!appsettings*.json
!scripts/*.ps1
!scripts/*.sh

# Still ignore actual secrets
.env
*.key
master.key
```

### B. Read/Edit Permissions

**Built-in**: Cascade can read/edit any file in workspace  
**Restriction**: Files in `.gitignore` require "Cascade Gitignore Access" toggle

---

## 4. Quick Settings Checklist

Copy-paste into WindSurf settings (settings.json):

```json
{
  // Terminal - Turbo mode for autonomous execution
  "windsurf.terminalAutoExecution": "turbo",
  
  // Commands that auto-execute without prompt
  "windsurf.cascadeCommandsAllowList": [
    "dotnet",
    "bun", 
    "npm",
    "node",
    "git",
    "python",
    "powershell",
    "bash"
  ],
  
  // Commands that always require approval (safety)
  "windsurf.cascadeCommandsDenyList": [
    "rm -rf",
    "format",
    "diskpart"
  ],
  
  // Allow editing gitignored files (config templates)
  "windsurf.cascadeGitignoreAccess": true,
  
  // Disable approval prompts for common operations
  "windsurf.cascadeAutoApproveCommon": true,
  
  // Auto-save before operations
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000
}
```

---

## 5. MCP Server Setup (For Full Access)

**Required MCP Servers**:

### A. Filesystem Server
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y", 
        "@modelcontextprotocol/server-filesystem",
        "C:/P4NTHE0N",
        "C:/Users/paulc/.config/opencode"
      ]
    }
  }
}
```

### B. MongoDB Server (for decisions-server)
Already configured via toolhive

### C. Decisions Server
Already configured via toolhive-mcp-optimizer

**UI Path for MCP**:
1. WindSurf → Settings → MCP
2. Click "Add MCP Server"
3. Configure as JSON above
4. Restart WindSurf

---

## 6. Permission Verification Test

**Test Script** (run in WindSurf):
```bash
# Should execute without prompt
echo "Testing terminal permissions"
mkdir -p test_autonomous
ls test_autonomous
rm -rf test_autonomous

# Should read gitignored file
cat .env.template

# Should edit file
echo "# Test comment" >> test_permissions.md
rm test_permissions.md
```

**If any prompt appears**: Adjust settings above

---

## 7. Admin/Org Guardrails (If Applicable)

**Enterprise/Team Settings**:
- Contact org admin to whitelist:
  - `C:/P4NTHE0N` directory
  - Terminal commands: `dotnet`, `bun`, `npm`
  - MCP servers: filesystem, mongodb

**Personal Override** (if admin locked):
- Use local settings.json (user settings)
- Local settings override workspace settings
- Path: `%APPDATA%/Code/User/settings.json`

---

## 8. Fixer-Specific Optimizations

**For .NET/C# Development**:
```json
{
  "omnisharp.enableRoslynAnalyzers": true,
  "omnisharp.enableEditorConfigSupport": true,
  "dotnet.defaultSolution": "P4NTHE0N.slnx",
  "[csharp]": {
    "editor.defaultFormatter": "csharpier.csharpier-vscode"
  }
}
```

**For Build Automation**:
```json
{
  "task.autoDetect": "off",
  "terminal.integrated.defaultProfile.windows": "PowerShell"
}
```

---

## 9. Quick Reference

| Setting | Path | Value |
|---------|------|-------|
| Terminal Mode | Settings → Terminal | **Turbo** |
| Gitignore Access | Settings → Cascade | **ON** |
| Auto-save | Settings → Files | **After Delay** |
| MCP Filesystem | Settings → MCP | Add C:/P4NTHE0N |
| Allow List | settings.json | dotnet, bun, npm, git |
| Deny List | settings.json | rm -rf, format |

---

## 10. Troubleshooting

**Problem**: "Cannot edit file - in .gitignore"
**Solution**: Enable "Cascade Gitignore Access" toggle

**Problem**: "Command requires approval"
**Solution**: Add command to `cascadeCommandsAllowList`

**Problem**: "Cannot access directory"
**Solution**: Add Filesystem MCP server with path

**Problem**: "Permission denied"
**Solution**: Check Windows file permissions, run WindSurf as admin if needed

---

## NEXT STEPS

1. Open WindSurf Settings (Ctrl+,)
2. Apply settings from Section 4 above
3. Configure MCP servers (Section 5)
4. Create .codeiumignore (Section 3A)
5. Test permissions (Section 6)
6. Load FIXER_PROMPT.md into context
7. Begin autonomous implementation

**Fixer is now ready to work without stopping for prompts**.

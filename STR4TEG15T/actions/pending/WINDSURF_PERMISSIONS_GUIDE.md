# WindSurf Permissions Guide

**Date**: 2026-02-18
**Purpose**: Configure WindSurf for Fixer autonomous operation

---

## Required Settings

### 1. Terminal Auto Execution
**Setting**: Terminal → Auto Execution
**Value**: Turbo Mode
**Purpose**: Allows automated command execution without prompts

### 2. Gitignore Access
**Setting**: Git → Ignore Access
**Value**: Enabled
**Purpose**: Allows Fixer to work with all project files including .gitignore patterns

### 3. MCP Servers
**Verify**:
- toolhive-mcp is connected
- mongodb is connected
- All required MCP servers are active

---

## Settings JSON (Copy to WindSurf)

```json
{
  "terminal": {
    "autoExecution": "turbo"
  },
  "git": {
    "ignoreAccess": true
  }
}
```

---

## Verification Steps

After configuration, verify by running test commands without prompts:

```bash
# Test 1: Execute build without prompt
dotnet build P4NTHE0N.slnx --no-restore

# Test 2: Execute tests without prompt  
dotnet test UNI7T35T/UNI7T35T.csproj

# Test 3: Verify MCP connections
# Check that toolhive-mcp responds to queries
```

---

## What Fixer CAN Do

- Read/write code files
- Execute terminal commands
- Query decisions-server
- Update decision status
- Run builds and tests

## What Fixer CANNOT Do

- Change WindSurf settings (requires Nexus)
- Access Gitignored files (without this toggle enabled)
- Install new MCP servers (requires Nexus)

---

## Pre-Flight Checklist

- [ ] Terminal Auto Execution set to Turbo
- [ ] Gitignore Access toggle enabled
- [ ] MCP servers verified as connected
- [ ] Test commands run without prompts
- [ ] Load Fixer context with mission statement

Once complete, say "Go Fixer" to begin autonomous execution.
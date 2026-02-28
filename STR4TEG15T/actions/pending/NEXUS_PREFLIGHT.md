# Nexus Pre-Flight Checklist

**Date**: 2026-02-18
**Status**: Ready for execution

---

## Five Steps to Activate Fixer

### Step 1: Configure WindSurf Settings

Open WindSurf and configure these settings:

| Setting | Value | Purpose |
|---------|-------|---------|
| Terminal Auto Execution | Turbo Mode | Allows automated commands |
| Gitignore Access | Enabled | Fixer can access all files |

### Step 2: Verify Permissions

Run these test commands in WindSurf terminal:

```bash
# Should execute without prompting
dotnet build P4NTHE0N.slnx --no-restore

# Should execute without prompting  
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~TestClassName"
```

If prompts appear, settings are not correct. Return to Step 1.

### Step 3: Confirm MCP Servers Active

Verify these MCP servers are connected:
- toolhive-mcp (localhost:22368)
- mongodb (localhost:27017)

### Step 4: Load Fixer Context

In WindSurf, invoke Fixer with:
- Load FIXER_PROMPT.md from T4CT1CS/actions/pending/
- Review implementation order
- Confirm understanding of fallback chain and checkpoint system

### Step 5: Execute and Monitor

Say: **"Go Fixer"**

Fixer will begin with Phase 1 Critical decisions:
1. WIND-001: Checkpoint Data Model
2. WIND-002: ComplexityEstimator Service
3. WIND-003: RetryStrategy
4. WIND-004: WindFixerCheckpointManager

---

## What Happens Next

1. Fixer saves checkpoint after each Decision
2. Fixer reports completion to Strategist
3. Fixer pauses at 5 consecutive failures (10% batch)
4. Fixer halts at 10 consecutive failures (50% batch)

---

## Emergency Stops

| Command | Action |
|---------|--------|
| "Pause Fixer" | Stop after current Decision |
| "Halt Fixer" | Stop immediately |
| "Resume Fixer" | Continue from checkpoint |

---

## Current Status

- 28 Decisions Approved
- 145 Action Items Ready
- WindFixer Prompt: Ready
- WindSurf Permissions: **CONFIGURE ME**
- Fixer: **AWAITING GO COMMAND**
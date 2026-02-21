# WindFixer Deployment Journal: FourEyes Subagent Integration

**Date**: 2026-02-20  
**Agent**: WindFixer (WindSurf)  
**Scope**: DECISION_036 integration completion + FourEyes MCP server  
**Status**: IMPLEMENTED (code written, builds, needs live validation)

---

## What Was Done

### 1. FourEyes MCP Server Created
- **Location**: `tools/mcp-foureyes/`
- **Files**: `server.js`, `package.json`, `README.md`, `.gitignore`, `Register-WindSurfMcp.ps1`
- **Transport**: stdio (default) + HTTP (port 5302)
- **Tools**: `analyze_frame`, `capture_screenshot`, `check_health`, `list_models`, `review_decision`
- **Dependencies**: `ws` (WebSocket client for CDP)
- **Pattern**: Follows `chrome-devtools-mcp/` raw JSON-RPC pattern from OPS_018

### 2. OpenCode Agent Registration
- **File Modified**: `~/.config/opencode/opencode.json`
- **Added agents**: `four_eyes`, `forgewright`, `windfixer`, `strategist`, `openfixer`
- All registered as subagents with appropriate permissions
- `four_eyes`: read-only, can delegate to explorer

### 3. OpenCode MCP Registration
- **File Modified**: `~/.config/opencode/mcp.json`
- Added `foureyes-mcp` entry with stdio transport

### 4. FourEyes Agent Prompt Updated
- **File Modified**: `~/.config/opencode/agents/four_eyes.md`
- Added MCP tool declarations and usage examples
- Added vision capabilities description

### 5. DECISION_036 Integration Gaps Closed

#### H4ND VisionCommandHandler Wiring
- **File Modified**: `H4ND/H4ND.cs`
- VisionCommandHandler now wires to VisionCommandListener on first successful CDP connection
- Re-wires on CDP reconnection (reset in finally block)
- Logs: `[H4ND] FEAT-036: VisionCommandHandler wired to CDP — FourEyes commands active`

#### DecisionEngine Vision-Targeted Actions
- **File Modified**: `W4TCHD0G/Agent/DecisionEngine.cs`
- `Evaluate()` now checks `VisionAnalysis.DetectedButtons` for spin button
- Falls back to hardcoded center-screen click if no vision data

#### VisionAnalysis Model Extended
- **File Modified**: `W4TCHD0G/Models/VisionAnalysis.cs`
- Added `DetectedButtons` property (`List<DetectedButton>?`)

#### VisionProcessor Button Passthrough
- **File Modified**: `W4TCHD0G/Vision/VisionProcessor.cs`
- `ProcessFrameAsync` now populates `analysis.DetectedButtons` from button detection

### 6. Pre-existing Bug Fixes
- **File Modified**: `UNI7T35T/FourEyesVisionTest.cs` — Rewritten to match current APIs
- **File Modified**: `UNI7T35T/Program.cs` — Fixed FirstSpinControllerTests wiring (static class)

---

## Build Status

- **Build**: 0 errors, 0 warnings (on modified projects)
- **npm install**: `tools/mcp-foureyes/` — 1 package, 0 vulnerabilities

---

## What Still Needs Live Validation

1. **FourEyes MCP server**: Run `node tools/mcp-foureyes/server.js stdio` and verify tools respond
2. **LMStudio connection**: Start LMStudio, load a vision model, test `analyze_frame`
3. **CDP screenshot**: Verify `capture_screenshot` returns valid PNG from live Chrome
4. **WindSurf MCP registration**: Run `Register-WindSurfMcp.ps1`, reload WindSurf
5. **OpenCode agent**: Verify `@four_eyes` is invocable after OpenCode restart
6. **VisionCommandHandler in H4ND**: Deploy H4ND.exe, verify `[H4ND] FEAT-036` log line appears

---

## Integration Architecture

```
OpenCode (@four_eyes subagent)
    ↓ native delegation
four_eyes.md → foureyes-mcp (stdio) → CDP screenshot
                                     → LMStudio analysis

WindSurf (Cascade)
    ↓ MCP tool call
foureyes-mcp (stdio) → CDP screenshot
                     → LMStudio analysis

H4ND runtime
    ↓ event bus
VisionCommandListener → VisionCommandHandler → CDP actions
    ↑ DecisionEngine uses VisionAnalysis.DetectedButtons
```

---

*WindFixer — DECISION_036 Integration Sprint*  
*Status: IMPLEMENTED, pending live validation*

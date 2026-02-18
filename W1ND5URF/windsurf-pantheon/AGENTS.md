# WindSurf Follower - Agent Instructions

## Build Commands

```bash
# Compile TypeScript
npm run compile

# Build VSIX package
vsce package
```

## Install Commands

```bash
# Install to WindSurf
windsurf --install-extension windsurf-follower-0.1.0.vsix --force

# Install to VS Code (if needed)
code --install-extension windsurf-follower-0.1.0.vsix --force
```

## Development Workflow

1. Make changes to `src/extension.ts`
2. Run `npm run compile` to verify changes
3. Run `vsce package` to build the VSIX
4. Install to WindSurf with the command above
5. Reload WindSurf window if extension was already active

## Extension Features

- Auto-focuses editor panes when external tools (WindSurf, Copilot) make changes
- Auto-closes inactive panes when exceeding max open editors limit
- Configurable via WindSurf settings (search "Windsurf Follower")

## Hook Integration

The extension now integrates with WindSurf Cascade hooks for instant focus and visibility:

### Focus on Cascade's Actions
1. WindSurf triggers `pre_read_code` or `pre_write_code` hooks before acting
2. Hook writes target file path to `%TEMP%/windsurf-follower-target.json`
3. Extension watches this file and immediately opens/focuses the editor
4. You'll be in the same place Cascade is, BEFORE he starts working

### Visibility into Decisions
1. WindSurf triggers `post_cascade_response` hook after each response
2. Hook captures the full response including planner thoughts, rules, and actions
3. Extension displays this in a webview panel showing:
   - What Cascade is thinking (planner responses)
   - Which rules were triggered
   - Files read and modified
   - Commands executed

### Hook Configuration:
- Config file: `.windsurf/hooks.json` (workspace-level)
- Focus hook script: `.windsurf/hooks/focus-editor.js`
- Decisions hook script: `.windsurf/hooks/capture-decisions.js`
- MCP Decisions hook script: `.windsurf/hooks/capture-mcp-decisions.js`
- No configuration needed - works automatically when extension is installed

### Decisions TreeView Panel
The extension now adds a "Decisions" icon to the left activity bar (like Explorer):

**Features:**
- 🎯 **Tool Interactions** - Live feed of Decisions tool MCP calls
  - Shows server name, tool name, and timestamp
  - Expand to see arguments and results
- 📝 **Recent Decisions** - Decision history from your database
  - Decision type (Signal, Spin, CashOut, etc.)
  - Target house/game/username
  - Confidence score with color coding (green > 70%, yellow > 40%, red < 40%)
  - Expand to see rationale, factors, and details
- Auto-updates in real-time as Cascade uses the Decisions tool
- Keeps last 50 decisions and 20 MCP interactions

### Commands:
- `WindSurf Follower: Show Cascade Decisions` - Opens the decisions webview panel

### Files Modified:
- `src/extension.ts` - Added hook file watchers and TreeView integration
- `src/decisionsProvider.ts` - TreeView data provider for the Decisions panel
- `package.json` - Added views and viewsContainers contributions
- `.windsurf/hooks.json` - Hook configuration
- `.windsurf/hooks/focus-editor.js` - Hook script for focusing
- `.windsurf/hooks/capture-decisions.js` - Hook script for capturing decisions
- `.windsurf/hooks/capture-mcp-decisions.js` - Hook script for capturing Decisions tool MCP calls (narrow scope)

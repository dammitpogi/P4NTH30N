# Development Workflow

## Building the Extension

### 1. Install Dependencies

```bash
cd W1ND5URF
npm install
```

This will install:
- `@types/vscode` - VS Code API type definitions
- `@types/node` - Node.js type definitions
- `typescript` - TypeScript compiler

### 2. Compile TypeScript

```bash
npm run compile
```

This will compile `src/extension.ts` into `out/extension.js`.

### 3. Run in Development Mode

1. Open the W1ND5URF folder in VS Code/Windsurf
2. Press `F5` to launch Extension Development Host
3. Open your P4NTHE0N workspace in the new window
4. Navigate to any file with an AGENTS.md nearby
5. Check the status bar for AGENTS context

### 4. Testing

1. Open files in directories with `AGENTS.md` files
2. Verify status bar shows current AGENTS.md context
3. Use command palette to test commands:
   - `Windsurf Cartography: Show Current AGENTS`
   - `Windsurf Cartography: Toggle Auto-Detection`
   - `Windsurf Cartography: Refresh AGENTS Context`

### 5. Packaging for Distribution

```bash
npm install -g vsce
vsce package
```

This creates a `.vsix` file for installation in Windsurf.

## Architecture Overview

```
W1ND5URF/
├── src/extension.ts          # Main extension entry point
├── package.json            # Extension manifest & configuration
├── tsconfig.json           # TypeScript compiler options
├── .vscode/
│   ├── launch.json         # Debug configuration
│   └── settings.json       # Workspace settings
├── out/                    # Compiled JavaScript (generated)
└── node_modules/           # Dependencies (generated)
```

## Key Features Implemented

1. **Auto-Detection**: Scans directory hierarchy for AGENTS.md files
2. **Status Bar**: Shows active AGENTS.md context in real-time
3. **Commands**: Manual refresh, display, and toggle functionality
4. **Configuration**: Customizable via VS Code settings

## Integration Points

### AGENTS.md System
- Uses Windsurf's native AGENTS.md auto-discovery
- AGENTS.md files are automatically injected into Cascade context by Windsurf
- Extension tracks which AGENTS.md is active for the current file
- No manual injection needed - Windsurf handles this natively

### Cartography System
- Reads `.slim/cartography.json` for workspace configuration
- Works alongside existing codemap.md files (both can coexist)
- Extension monitors AGENTS.md files for real-time context tracking

## Next Steps for Full Integration

1. **Install dependencies**: `npm install`
2. **Build**: `npm run compile`
3. **Test**: Press `F5` to run in Extension Development Host
4. **Verify**: Open files in directories with AGENTS.md and check status bar
5. **Package**: `vsce package` to create installable extension
6. **Distribute**: Install `.vsix` file in Windsurf

## Debugging

- Extension host console: Help > Toggle Developer Tools
- Extension logs: Output panel > "Windsurf Cartography" channel
- Status bar shows current AGENTS.md context
- Commands available in Command Palette (Ctrl+Shift+P)

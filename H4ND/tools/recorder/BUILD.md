# Building P4NTH30N Recorder TUI

This document describes how to build standalone executables for the Recorder TUI.

## Prerequisites

- **Bun** v1.0+ installed ([https://bun.sh](https://bun.sh))
- Windows (for `.exe` builds)

## Quick Build

### Option 1: Using npm script (recommended)
```powershell
cd C:\P4NTH30N\H4ND\tools\recorder
bun run build
```

This runs the `build.ps1` script which provides detailed output and error checking.

### Option 2: Direct build command
```powershell
cd C:\P4NTH30N\H4ND\tools\recorder
bun run build:tui
```

This directly invokes Bun's compile feature.

### Option 3: Manual build
```powershell
cd C:\P4NTH30N\H4ND\tools\recorder
bun build recorder-tui.ts --compile --outfile dist/recorder-tui.exe
```

## Output

The build process creates:
- **`dist/recorder-tui.exe`** - Standalone executable (~40-50 MB)
  - Includes Bun runtime
  - No external dependencies required
  - Can be distributed as a single file

## Running the Executable

### Default config
```powershell
.\dist\recorder-tui.exe
```
Uses `step-config.json` in the same directory as the executable.

### Custom config
```powershell
.\dist\recorder-tui.exe --config=path\to\config.json
```

## Distribution

The generated `.exe` is fully self-contained and can be:
- Copied to any Windows machine
- Run without installing Bun or Node.js
- Distributed as a single file

**Note**: The executable must have access to:
- Chrome/Chromium with CDP enabled (for live execution)
- Write permissions for screenshot directories
- Read permissions for config files

## Build Script Details

The `build.ps1` script:
1. Checks for Bun installation
2. Creates `dist/` directory if needed
3. Compiles `recorder-tui.ts` to standalone `.exe`
4. Reports file size and usage instructions
5. Exits with error code on failure

## Troubleshooting

### "Bun not found"
Install Bun from [https://bun.sh](https://bun.sh):
```powershell
powershell -c "irm bun.sh/install.ps1 | iex"
```

### Build fails with module errors
Ensure all dependencies are installed:
```powershell
bun install
```

### Executable won't run
- Check Windows Defender / antivirus (may flag as unknown executable)
- Verify you're running on Windows x64
- Try running from PowerShell with admin privileges

## CI/CD Integration

To automate builds:

```yaml
# Example GitHub Actions workflow
- name: Build TUI executable
  run: |
    cd H4ND/tools/recorder
    bun install
    bun run build:tui
    
- name: Upload artifact
  uses: actions/upload-artifact@v3
  with:
    name: recorder-tui-exe
    path: H4ND/tools/recorder/dist/recorder-tui.exe
```

## Version Information

The executable version matches `package.json` version: **1.0.0**

To update version:
1. Edit `package.json` → `"version": "x.y.z"`
2. Rebuild with `bun run build`

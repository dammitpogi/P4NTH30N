# Agent Build Workflow — Bun Executable Compilation

**Authority**: Standard build method for P4NTHE0N agents  
**Applies to**: WindFixer, OpenFixer, Forgewright  
**Last Updated**: 2026-02-22  
**Status**: Active

---

## Overview

This document defines the standard build workflow for creating standalone executables from TypeScript/JavaScript tools in the P4NTHE0N ecosystem. The workflow uses **Bun's compile feature** to generate self-contained `.exe` files that require no runtime dependencies.

## Why Bun Compile?

- **Single-file distribution**: No Node.js or Bun installation required on target machines
- **Fast compilation**: Bun compiles TypeScript directly without intermediate transpilation
- **Small overhead**: ~40-50 MB executable size (includes Bun runtime)
- **Zero configuration**: Works with existing TypeScript projects
- **Native performance**: Compiled executables run at native speed

## Standard Build Structure

Every buildable tool should follow this structure:

```
tool-directory/
├── src/                    # Source files
│   ├── main.ts            # Entry point
│   └── ...
├── package.json           # Must include build scripts
├── build.ps1              # PowerShell build script
├── BUILD.md               # Build documentation
├── .gitignore             # Exclude dist/ and *.exe
└── dist/                  # Build output (gitignored)
    └── tool-name.exe
```

## Required Files

### 1. `package.json` — Build Scripts

Add these scripts to `package.json`:

```json
{
  "scripts": {
    "build": "pwsh -File build.ps1",
    "build:exe": "bun build <entry-point>.ts --compile --outfile <tool-name>.exe"
  }
}
```

**Example** (from Recorder TUI):
```json
{
  "scripts": {
    "build": "pwsh -File build.ps1",
    "build:tui": "bun build recorder-tui.ts --compile --outfile recorder-tui.exe"
  }
}
```

### 2. `build.ps1` - PowerShell Build Script

Template:

```powershell
#!/usr/bin/env pwsh
# Build script for <Tool Name>
# Generates standalone executable using Bun's compile feature

$ErrorActionPreference = "Stop"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  <Tool Name> - Build Script" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Check if bun is installed
Write-Host "Checking for Bun..." -ForegroundColor Yellow
try {
    $bunVersion = bun --version
    Write-Host "✓ Bun found: v$bunVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Bun not found. Please install Bun from https://bun.sh" -ForegroundColor Red
    exit 1
}

# Build the executable
Write-Host ""
Write-Host "Building <tool-name>.exe..." -ForegroundColor Yellow
Write-Host "  Entry point: <entry-point>.ts" -ForegroundColor Gray
Write-Host "  Output: <tool-name>.exe" -ForegroundColor Gray
Write-Host ""

try {
    bun build <entry-point>.ts --compile --outfile <tool-name>.exe
    
    if (Test-Path "<tool-name>.exe") {
        $fileInfo = Get-Item "<tool-name>.exe"
        $sizeInMB = [math]::Round($fileInfo.Length / 1MB, 2)
        
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  ✓ Build successful!" -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Executable: <tool-name>.exe" -ForegroundColor Cyan
        Write-Host "  Size: $sizeInMB MB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "  .\<tool-name>.exe [options]" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "✗ Build failed - executable not found" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "✗ Build failed: $_" -ForegroundColor Red
    exit 1
}
```

### 3. `BUILD.md` — Build Documentation

Template:

```markdown
# Building <Tool Name>

## Prerequisites

- **Bun** v1.0+ installed ([https://bun.sh](https://bun.sh))
- Windows (for `.exe` builds)

## Quick Build

### Option 1: Using npm script (recommended)
\`\`\`powershell
cd <tool-directory>
bun run build
\`\`\`

### Option 2: Direct build command
\`\`\`powershell
cd <tool-directory>
bun run build:exe
\`\`\`

### Option 3: Manual build
\`\`\`powershell
cd <tool-directory>
bun build <entry-point>.ts --compile --outfile <tool-name>.exe
\`\`\`

## Output

- **`<tool-name>.exe`** - Standalone executable (~40-50 MB)
  - Includes Bun runtime
  - No external dependencies required
  - Can be distributed as a single file

## Running the Executable

\`\`\`powershell
.\<tool-name>.exe [options]
\`\`\`

## Distribution

The generated `.exe` is fully self-contained and can be:
- Copied to any Windows machine
- Run without installing Bun or Node.js
- Distributed as a single file

## Troubleshooting

### "Bun not found"
Install Bun from [https://bun.sh](https://bun.sh):
\`\`\`powershell
powershell -c "irm bun.sh/install.ps1 | iex"
\`\`\`

### Build fails with module errors
Ensure all dependencies are installed:
\`\`\`powershell
bun install
\`\`\`
```

### 4. `.gitignore` — Exclude Build Artifacts

Add to `.gitignore`:

```gitignore
# Build outputs
dist/
*.exe
<tool-name>.exe

# Dependencies
node_modules/
bun.lock

# Logs
*.log
```

---

## Agent Build Workflow

### For WindFixer (P4NTHE0N Tools)

When implementing or updating TypeScript/JavaScript tools in `H4ND/tools/`:

1. **Create entry point** with shebang:
   ```typescript
   #!/usr/bin/env bun
   import { main } from './src/main';
   main();
   ```

2. **Add build files**:
   - `package.json` with build scripts
   - `build.ps1` from template
   - `BUILD.md` from template
   - `.gitignore` with dist/ exclusion

3. **Test build**:
   ```powershell
   bun run build
   .\dist\tool-name.exe --help
   ```

4. **Document in deployment**:
   - Create `W1NDF1XER/deployments/DECISION_XXX_<feature>.md`
   - Include "Build Instructions" section
   - Reference `BUILD.md`

### For OpenFixer (External Tools)

When working with CLI tools or plugins:

1. **Verify Bun compatibility** (most Node.js tools work)
2. **Follow same structure** as WindFixer
3. **Test on clean machine** (no dev dependencies)
4. **Document runtime requirements** (e.g., Chrome for CDP tools)

### For Forgewright (Cross-Cutting Tools)

When creating automation or tooling:

1. **Prefer Bun over Node.js** for new tools
2. **Use TypeScript** for type safety
3. **Include `--help` flag** in all executables
4. **Version executables** via `package.json`

---

## Build Command Reference

### Basic Build
```powershell
bun build entry.ts --compile --outfile dist/tool.exe
```

### With Minification
```powershell
bun build entry.ts --compile --minify --outfile dist/tool.exe
```

### With Target Specification
```powershell
bun build entry.ts --compile --target=bun-windows-x64 --outfile dist/tool.exe
```

### Debug Build (with source maps)
```powershell
bun build entry.ts --compile --sourcemap --outfile dist/tool.exe
```

---

## Distribution Checklist

Before distributing an executable:

- [ ] Build succeeds without errors
- [ ] Executable runs on clean Windows machine
- [ ] `--help` flag works and shows usage
- [ ] Version matches `package.json`
- [ ] `BUILD.md` is up to date
- [ ] `.gitignore` excludes `dist/` and `*.exe`
- [ ] Deployment decision document includes build instructions
- [ ] File size is reasonable (<100 MB)

---

## Example: Recorder TUI Build

**Location**: `C:\P4NTHE0N\H4ND\tools\recorder`

**Build**:
```powershell
cd C:\P4NTHE0N\H4ND\tools\recorder
bun run build
```

**Output**: `dist/recorder-tui.exe` (~45 MB)

**Usage**:
```powershell
.\dist\recorder-tui.exe
.\dist\recorder-tui.exe --config=custom.json
```

**Documentation**: See `C:\P4NTHE0N\H4ND\tools\recorder\BUILD.md`

---

## Troubleshooting

### Build fails with "Cannot find module"
- Run `bun install` to ensure dependencies are present
- Check that entry point imports are correct
- Verify `package.json` has all dependencies listed

### Executable crashes on startup
- Test with `bun run <entry-point>.ts` first
- Check for hardcoded paths (use `import.meta.url` for relative paths)
- Verify all assets are embedded or accessible

### Executable is too large (>100 MB)
- Remove unused dependencies from `package.json`
- Use `--minify` flag
- Check for accidentally bundled assets

### "Access denied" when running executable
- Windows Defender may flag unknown executables
- Add exception or run from trusted location
- Sign executable for production distribution

---

## Future Enhancements

- **Code signing**: Sign executables for Windows SmartScreen
- **Auto-update**: Implement self-update mechanism
- **Multi-platform**: Build for Linux/macOS using Bun's cross-compilation
- **CI/CD integration**: Automate builds on commit/tag
- **Release automation**: Auto-publish to GitHub Releases

---

## References

- **Bun Documentation**: https://bun.sh/docs/bundler/executables
- **Example Implementation**: `C:\P4NTHE0N\H4ND\tools\recorder\build.ps1`
- **Agent Documentation**: `C:\P4NTHE0N\STR4TEG15T\decisions\active\DECISION_086.md`
- **Decision Template**: `C:\P4NTHE0N\STR4TEG15T\decisions\_templates\DECISION-TEMPLATE.md`

# WindSurf Cascade Hooks

## Overview

Cascade hooks are shell scripts executed at specific events in the agent lifecycle. They receive JSON input via stdin and can modify behavior or perform side effects.

## Hook Events

| Event | Script | Description |
|-------|--------|-------------|
| `pre_commit` | `pre-commit.ps1` | Runs before git commits - validates formatting and build |
| `post_write` | `post-write.ps1` | Runs after file modifications - tracks changed files |
| `on_error` | `on-error.ps1` | Runs on Cascade errors - logs to `.logs/cascade-errors.log` |
| `validate_path` | `validate-path.ps1` | Validates file paths - blocks access outside repo |
| `security_check` | `security-check.ps1` | Scans for hardcoded secrets in modified files |

## Hook Location

All hooks are located in `.windsurf/hooks/`.

## Input Format

Hooks receive JSON via stdin:

```json
{
  "files": ["path/to/file1.cs", "path/to/file2.cs"],
  "action": "write",
  "context": "optional context string"
}
```

## Security

- **Path validation**: All file operations are validated against the repository root
- **Blocked directories**: `.git/objects`, `Releases/`, `bin/`, `obj/`, `drivers/`
- **Secret scanning**: Detects hardcoded passwords, API keys, connection strings

## Adding New Hooks

1. Create a `.ps1` script in `.windsurf/hooks/`
2. Accept JSON input via stdin
3. Exit with code 0 for success, non-zero for failure
4. Use `Write-Host` for output visible in Cascade UI

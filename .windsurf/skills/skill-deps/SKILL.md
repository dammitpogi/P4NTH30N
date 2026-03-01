---
name: skill-deps
description: Track and manage dependencies between OpenClaw skills. Scan skills for dependencies, visualize skill trees, detect circular dependencies, and manage skill versioning. Use when analyzing skill relationships, checking which skills depend on others, or managing skill installations.
---

# Skill Dependencies

Manage dependencies between OpenClaw skills — like npm for skills.

## Version Constraints

Supports semver-style version constraints:

```yaml
depends:
  - weather@>=1.0.0      # Version 1.0.0 or higher
  - calendar@^2.0.0      # Compatible with 2.x.x
  - browser@~1.2.0       # Approximately 1.2.x
  - coding-agent@*       # Any version
  - github@1.5.0         # Exact version
```

## Conflict Detection

Declare skills that cannot coexist:

```yaml
conflicts:
  - old-weather          # Cannot use with old-weather
  - legacy-calendar
```

## Concepts

### Declaring Dependencies

In a skill's `SKILL.md` frontmatter:
```yaml
---
name: my-skill
description: Does something cool
depends:
  - weather          # Requires weather skill
  - coding-agent     # Requires coding-agent skill
optional:
  - github           # Enhanced if github skill present
---
```

### Dependency Types

- **depends** — Required skills (fail if missing)
- **optional** — Enhanced functionality if present
- **conflicts** — Cannot be used with these skills

## Commands

### Scan Skills
```bash
# Linux/macOS
./scripts/scan-skills.sh

# Windows PowerShell
./scripts/scan-skills.ps1

# Scan specific skill
./scripts/scan-skills.sh weather
./scripts/scan-skills.ps1 weather
```

### Dependency Tree
```bash
# Linux/macOS
./scripts/skill-tree.sh my-skill

# Windows PowerShell
./scripts/skill-tree.ps1 my-skill

# Output:
# my-skill
# ├── weather (required)
# │   └── (no dependencies)
# └── coding-agent (required)
#     └── github (optional)
```

### Check Missing
```bash
# Linux/macOS
./scripts/check-deps.sh

# Windows PowerShell
./scripts/check-deps.ps1
```

## Registry Format

Skills can declare their metadata in `skill.json`:
```json
{
  "name": "my-skill",
  "version": "1.0.0",
  "depends": {
    "weather": ">=1.0.0",
    "coding-agent": "*"
  },
  "optional": {
    "github": ">=2.0.0"
  }
}
```

## Skill Locations

Scans these directories:

**Linux/macOS:**
1. `/usr/lib/node_modules/openclaw/skills/` — Built-in skills
2. `~/.openclaw/workspace/skills/` — User skills  
3. `./skills/` — Project-local skills

**Windows:**
1. `$env:APPDATA\npm\node_modules\openclaw\skills` — Built-in skills
2. `$env:USERPROFILE\.openclaw\workspace\skills` — User skills
3. `.\skills\` — Project-local skills

## ClawHub Registry Integration

Install skills from clawhub.com:

```bash
# Linux/macOS
# Install a skill (auto-resolves dependencies)
./scripts/skill-install.sh weather

# Install with specific version
./scripts/skill-install.sh weather@1.2.0

# Search for skills
./scripts/skill-search.sh "calendar"

# List installed vs available
./scripts/skill-list.sh --outdated

# Windows PowerShell
# Install a skill (auto-resolves dependencies)
./scripts/skill-install.ps1 weather

# Install with specific version
./scripts/skill-install.ps1 weather -Version 1.2.0

# Search for skills
./scripts/skill-search.ps1 "calendar"

# Check for conflicts
./scripts/check-conflicts.ps1
```

## Auto-Resolution

When installing a skill with dependencies:
```
$ ./scripts/skill-install.sh travel-planner

📦 Resolving dependencies for travel-planner@1.0.0...
  ├── weather@>=1.0.0 → weather@1.2.3 ✅
  ├── calendar@^2.0 → calendar@2.1.0 ✅
  └── browser (optional) → browser@3.0.0 ✅

🔍 Checking conflicts...
  └── No conflicts found ✅

📥 Installing 4 skills...
  ✅ weather@1.2.3
  ✅ calendar@2.1.0
  ✅ browser@3.0.0
  ✅ travel-planner@1.0.0

Done! Installed 4 skills.
```

## Commands Summary

| Command | Linux/macOS | Windows PowerShell | Description |
|---------|-------------|-------------------|-------------|
| `scan-skills.sh` | `scan-skills.sh` | `scan-skills.ps1` | List all skills with their deps |
| `skill-tree.sh <name>` | `skill-tree.sh` | `skill-tree.ps1` | Show dependency tree |
| `check-deps.sh` | `check-deps.sh` | `check-deps.ps1` | Find missing dependencies |
| `skill-install.sh <name>` | `skill-install.sh` | `skill-install.ps1` | Install from ClawHub |
| `skill-search.sh <query>` | `skill-search.sh` | `skill-search.ps1` | Search registry |
| `check-conflicts.sh` | N/A | `check-conflicts.ps1` | Detect conflicts |

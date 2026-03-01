# Skill Extraction Helper (Windows PowerShell version)
# Creates a new skill from a learning entry
# Usage: .\extract-skill.ps1 <skill-name> [-DryRun] [-OutputDir <path>]

param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName,
    
    [switch]$DryRun,
    
    [string]$OutputDir = "./skills"
)

# Configuration
$SKILLS_DIR = $OutputDir

# Colors for output
$colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    NC = "White"
}

function Show-Usage {
    Write-Host @"
Usage: extract-skill.ps1 <skill-name> [options]

Create a new skill from a learning entry.

Arguments:
  skill-name     Name of the skill (lowercase, hyphens for spaces)

Options:
  -DryRun        Show what would be created without creating files
  -OutputDir     Relative output directory under current path (default: ./skills)
  -h, -Help      Show this help message

Examples:
  extract-skill.ps1 docker-m1-fixes
  extract-skill.ps1 api-timeout-patterns -DryRun
  extract-skill.ps1 pnpm-setup -OutputDir ./skills/custom

The skill will be created in: $SKILLS_DIR/<skill-name>/
"@
}

function Write-Info {
    param([string]$message)
    Write-Host "[INFO] $message" -ForegroundColor $colors.Green
}

function Write-Warn {
    param([string]$message)
    Write-Host "[WARN] $message" -ForegroundColor $colors.Yellow
}

function Write-Error {
    param([string]$message)
    Write-Host "[ERROR] $message" -ForegroundColor $colors.Red
}

# Validate skill name format (lowercase, hyphens, no spaces)
if ($SkillName -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    Write-Error "Invalid skill name format. Use lowercase letters, numbers, and hyphens only."
    Write-Error "Examples: 'docker-fixes', 'api-patterns', 'pnpm-setup'"
    exit 1
}

# Validate output path to avoid writes outside current workspace
if ($SKILLS_DIR.StartsWith('/') -or $SKILLS_DIR.StartsWith('\')) {
    Write-Error "Output directory must be a relative path under the current directory."
    exit 1
}

if ($SKILLS_DIR -match '(\.\.|^\.\\)') {
    Write-Error "Output directory cannot include '..' path segments."
    exit 1
}

$SKILLS_DIR = $SKILLS_DIR -replace '^\.\\', './'
$SKILL_PATH = Join-Path $SKILLS_DIR $SkillName

# Check if skill already exists
if ((Test-Path $SKILL_PATH) -and (-not $DryRun)) {
    Write-Error "Skill already exists: $SKILL_PATH"
    Write-Error "Use a different name or remove the existing skill first."
    exit 1
}

# Generate title from skill name
$title = ($SkillName -replace '-', ' ').Split(' ') | ForEach-Object { 
    $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() 
}
$title = $title -join ' '

# Dry run output
if ($DryRun) {
    Write-Info "Dry run - would create:"
    Write-Host "  $SKILL_PATH/"
    Write-Host "  $SKILL_PATH/SKILL.md"
    Write-Host ""
    Write-Host "Template content would be:"
    Write-Host "---"
    Write-Host @"
name: $SkillName
description: "[TODO: Add a concise description of what this skill does and when to use it]"
---

# $title

[TODO: Brief introduction explaining the skill's purpose]

## Quick Reference

| Situation | Action |
|-----------|--------|
| [Trigger condition] | [What to do] |

## Usage

[TODO: Detailed usage instructions]

## Examples

[TODO: Add concrete examples]

## Source Learning

This skill was extracted from a learning entry.
- Learning ID: [TODO: Add original learning ID]
- Original File: .learnings/LEARNINGS.md
"@
    Write-Host "---"
    exit 0
}

# Create skill directory structure
Write-Info "Creating skill: $SkillName"

New-Item -ItemType Directory -Path $SKILL_PATH -Force | Out-Null

# Create SKILL.md from template
$skillContent = @"
---
name: $SkillName
description: "[TODO: Add a concise description of what this skill does and when to use it]"
---

# $title

[TODO: Brief introduction explaining the skill's purpose]

## Quick Reference

| Situation | Action |
|-----------|--------|
| [Trigger condition] | [What to do] |

## Usage

[TODO: Detailed usage instructions]

## Examples

[TODO: Add concrete examples]

## Source Learning

This skill was extracted from a learning entry.
- Learning ID: [TODO: Add original learning ID]
- Original File: .learnings/LEARNINGS.md
"@

$skillContent | Out-File -FilePath (Join-Path $SKILL_PATH "SKILL.md") -Encoding UTF8

Write-Info "Created: $SKILL_PATH/SKILL.md"

# Suggest next steps
Write-Host ""
Write-Info "Skill scaffold created successfully!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit $SKILL_PATH/SKILL.md"
Write-Host "  2. Fill in the TODO sections with content from your learning"
Write-Host "  3. Add references/ folder if you have detailed documentation"
Write-Host "  4. Add scripts/ folder if you have executable code"
Write-Host "  5. Update the original learning entry with:"
Write-Host "     **Status**: promoted_to_skill"
Write-Host "     **Skill-Path**: skills/$SkillName"

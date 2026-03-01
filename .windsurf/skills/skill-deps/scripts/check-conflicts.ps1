# Detect skill conflicts (Windows PowerShell version)

# Colors
$colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Cyan = "Cyan"
    NC = "White"
}

# Skill locations (Windows compatible)
$BUILTIN_SKILLS = "$env:APPDATA\npm\node_modules\openclaw\skills"
$USER_SKILLS = "$env:USERPROFILE\.openclaw\workspace\skills"
$LOCAL_SKILLS = ".\skills"

# Extract conflicts from skill
function Get-Conflicts {
    param([string]$skillDir)
    $skillMd = Join-Path $skillDir "SKILL.md"
    
    if (-not (Test-Path $skillMd)) {
        return @()
    }
    
    $content = Get-Content $skillMd -Raw
    if ($content -match '^---$(.+?)^---$') {
        $frontmatter = $matches[1]
        $inConflicts = $false
        $conflicts = @()
        foreach ($line in $frontmatter -split "`n") {
            if ($line -match "^conflicts:") {
                $inConflicts = $true
                continue
            }
            if ($inConflicts -and $line -match "^[a-z]:") {
                break
            }
            if ($inConflicts -and $line -match "^\s*-\s*(.+)") {
                $conflicts += $matches[1].Trim('"').Trim()
            }
        }
        return $conflicts
    }
    return @()
}

# Get all installed skills
function Get-InstalledSkills {
    $skills = @()
    $skillsDirs = @($BUILTIN_SKILLS, $USER_SKILLS, $LOCAL_SKILLS)
    
    foreach ($skillsDir in $skillsDirs) {
        if (Test-Path $skillsDir) {
            $dirs = Get-ChildItem $skillsDir -Directory
            foreach ($dir in $dirs) {
                $skillPath = Join-Path $skillsDir $dir.Name
                $conflicts = Get-Conflicts $skillPath
                $skills += @{
                    Name = $dir.Name
                    Path = $skillPath
                    Conflicts = $conflicts
                }
            }
        }
    }
    
    return $skills
}

# Main
Write-Host "`n⚠️  Detecting Skill Conflicts`n" -ForegroundColor $colors.Yellow

$installedSkills = Get-InstalledSkills
$conflictsFound = $false

# Check each skill against others
foreach ($skill in $installedSkills) {
    if ($skill.Conflicts.Count -gt 0) {
        foreach ($conflict in $skill.Conflicts) {
            # Check if conflicting skill is installed
            $conflictingSkill = $installedSkills | Where-Object { $_.Name -eq $conflict }
            if ($conflictingSkill) {
                if (-not $conflictsFound) {
                    Write-Host "❌ Conflicts detected:" -ForegroundColor $colors.Red
                    $conflictsFound = $true
                }
                
                Write-Host "📦 $($skill.Name) conflicts with 📦 $($conflictingSkill.Name)" -ForegroundColor $colors.Red
                Write-Host "   $($skill.Name) location: $($skill.Path)" -ForegroundColor $colors.Cyan
                Write-Host "   $($conflictingSkill.Name) location: $($conflictingSkill.Path)" -ForegroundColor $colors.Cyan
                Write-Host ""
            }
        }
    }
}

if (-not $conflictsFound) {
    Write-Host "✅ No skill conflicts detected!" -ForegroundColor $colors.Green
} else {
    Write-Host "💡 Remove one of the conflicting skills to resolve" -ForegroundColor $colors.Yellow
}

Write-Host ""

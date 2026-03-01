# Find skills with unmet dependencies (Windows PowerShell version)

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

# Track visited to prevent infinite loops
$script:VISITED = @{}

# Find skill directory
function Find-Skill {
    param([string]$name)
    $dirs = @($BUILTIN_SKILLS, $USER_SKILLS, $LOCAL_SKILLS)
    foreach ($dir in $dirs) {
        $skillPath = Join-Path $dir $name
        if (Test-Path $skillPath) {
            return $skillPath
        }
    }
    return $null
}

# Get all available skill names
function Get-AvailableSkills {
    $skills = @()
    $skillsDirs = @($BUILTIN_SKILLS, $USER_SKILLS, $LOCAL_SKILLS)
    
    foreach ($skillsDir in $skillsDirs) {
        if (Test-Path $skillsDir) {
            $dirs = Get-ChildItem $skillsDir -Directory
            foreach ($dir in $dirs) {
                $skills += $dir.Name
            }
        }
    }
    
    return $skills | Sort-Object -Unique
}

# Extract dependencies from skill
function Get-Deps {
    param([string]$skillDir)
    $skillMd = Join-Path $skillDir "SKILL.md"
    
    if (-not (Test-Path $skillMd)) {
        return @()
    }
    
    $content = Get-Content $skillMd -Raw
    if ($content -match '^---$(.+?)^---$') {
        $frontmatter = $matches[1]
        $inDepends = $false
        $deps = @()
        foreach ($line in $frontmatter -split "`n") {
            if ($line -match "^depends:") {
                $inDepends = $true
                continue
            }
            if ($inDepends -and $line -match "^[a-z]:") {
                break
            }
            if ($inDepends -and $line -match "^\s*-\s*(.+)") {
                $deps += $matches[1].Trim('"').Trim()
            }
        }
        return $deps
    }
    return @()
}

# Check if dependency is satisfied
function Test-DependencySatisfied {
    param([string]$depName)
    return $null -eq (Find-Skill $depName)
}

# Test skill dependencies recursively
function Test-SkillDeps {
    param(
        [string]$skillName,
        [string]$prefix = "",
        [bool]$isLast = $true
    )
    
    if ($script:VISITED.ContainsKey($skillName)) {
        return
    }
    $script:VISITED[$skillName] = $true
    
    $skillDir = Find-Skill $skillName
    if (-not $skillDir) {
        return
    }
    
    $deps = Get-Deps $skillDir
    if (-not $deps) {
        return
    }
    
    $count = $deps.Count
    for ($i = 0; $i -lt $count; $i++) {
        $dep = $deps[$i]
        $last = ($i -eq ($count - 1))
        
        $newPrefix = $prefix
        if ($prefix -eq "") {
            $newPrefix = ""
        } elseif ($isLast) {
            $newPrefix = "${prefix}    "
        } else {
            $newPrefix = "${prefix}│   "
        }
        
        $branch = "├──"
        if ($last) { $branch = "└──" }
        
        $satisfied = Test-DependencySatisfied $dep
        $color = if ($satisfied) { $colors.Green } else { $colors.Red }
        $status = if ($satisfied) { "✅" } else { "❌ MISSING" }
        
        Write-Host "${prefix}${branch} $dep $status" -ForegroundColor $color
        
        if ($satisfied) {
            Test-SkillDeps $dep $newPrefix $last
        }
    }
}

# Main
Write-Host "`n🔍 Checking Skill Dependencies`n" -ForegroundColor $colors.Green

$allSkills = Get-AvailableSkills
$missingDeps = $false

foreach ($skill in $allSkills) {
    $skillDir = Find-Skill $skill
    if ($skillDir) {
        $deps = Get-Deps $skillDir
        $hasMissing = $false
        
        foreach ($dep in $deps) {
            if (-not (Test-DependencySatisfied $dep)) {
                $hasMissing = $true
                break
            }
        }
        
        if ($hasMissing) {
            if (-not $missingDeps) {
                Write-Host "Skills with missing dependencies:" -ForegroundColor $colors.Yellow
                $missingDeps = $true
            }
            
            Write-Host "`n📦 $skill" -ForegroundColor $colors.Cyan
            $script:VISITED = @{}
            Test-SkillDeps $skill "" $true
        }
    }
}

if (-not $missingDeps) {
    Write-Host "✅ All skill dependencies satisfied!" -ForegroundColor $colors.Green
} else {
    Write-Host "`n💡 Install missing skills with: skill-install.ps1 <skill-name>" -ForegroundColor $colors.Yellow
}

Write-Host ""

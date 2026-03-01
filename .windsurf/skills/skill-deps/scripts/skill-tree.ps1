# Display dependency tree for a skill (Windows PowerShell version)

param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName
)

# Colors
$colors = @{
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

# Extract dependencies from skill
function Get-Deps {
    param([string]$skillDir)
    $skillMd = Join-Path $skillDir "SKILL.md"
    
    if (-not (Test-Path $skillMd)) {
        return @()
    }
    
    # Extract frontmatter and get depends field
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

# Get optional dependencies
function Get-Optional {
    param([string]$skillDir)
    $skillMd = Join-Path $skillDir "SKILL.md"
    
    if (-not (Test-Path $skillMd)) {
        return @()
    }
    
    $content = Get-Content $skillMd -Raw
    if ($content -match '^---$(.+?)^---$') {
        $frontmatter = $matches[1]
        $inOptional = $false
        $opts = @()
        foreach ($line in $frontmatter -split "`n") {
            if ($line -match "^optional:") {
                $inOptional = $true
                continue
            }
            if ($inOptional -and $line -match "^[a-z]:") {
                break
            }
            if ($inOptional -and $line -match "^\s*-\s*(.+)") {
                $opts += $matches[1].Trim('"').Trim()
            }
        }
        return $opts
    }
    return @()
}

# Show tree recursively
function Show-Tree {
    param(
        [string]$name,
        [string]$prefix = "",
        [bool]$isLast = $true,
        [string]$depType = "required"
    )
    
    # Check for circular dependency
    if ($script:VISITED.ContainsKey($name)) {
        Write-Host "${prefix}⚠️  $name (circular!)" -ForegroundColor $colors.Yellow
        return
    }
    $script:VISITED[$name] = $true
    
    $skillDir = Find-Skill $name
    $status = ""
    
    if (-not $skillDir) {
        $status = "(missing!)"
    }
    
    $typeIndicator = ""
    if ($depType -eq "optional") {
        $typeIndicator = " (optional)"
    }
    
    if ($prefix -eq "") {
        Write-Host "$name$typeIndicator $status" -ForegroundColor $colors.Green
    } else {
        $branch = "├──"
        if ($isLast) { $branch = "└──" }
        Write-Host "${prefix}${branch} $name$typeIndicator $status"
    }
    
    if ($skillDir) {
        $deps = Get-Deps $skillDir
        $opts = Get-Optional $skillDir
        
        $allDeps = @()
        foreach ($dep in $deps) {
            if ($dep) { $allDeps += @{ Name = $dep; Type = "required" } }
        }
        foreach ($opt in $opts) {
            if ($opt) { $allDeps += @{ Name = $opt; Type = "optional" } }
        }
        
        $count = $allDeps.Count
        for ($i = 0; $i -lt $count; $i++) {
            $item = $allDeps[$i]
            $last = ($i -eq ($count - 1))
            
            $newPrefix = $prefix
            if ($prefix -eq "") {
                $newPrefix = ""
            } elseif ($isLast) {
                $newPrefix = "${prefix}    "
            } else {
                $newPrefix = "${prefix}│   "
            }
            
            Show-Tree $item.Name $newPrefix $last $item.Type
        }
    }
}

# Main
Write-Host "`n🌳 Skill Dependency Tree: $SkillName`n" -ForegroundColor $colors.Green

Show-Tree $SkillName "" $true "required"

Write-Host ""

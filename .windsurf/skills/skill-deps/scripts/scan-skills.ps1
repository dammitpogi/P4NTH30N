# Scan OpenClaw skills and extract dependency information (Windows PowerShell version)

# Colors (Windows compatible)
$colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
    NC = "White"
}

# Skill locations (Windows compatible)
$BUILTIN_SKILLS = "$env:APPDATA\npm\node_modules\openclaw\skills"
$USER_SKILLS = "$env:USERPROFILE\.openclaw\workspace\skills"
$LOCAL_SKILLS = ".\skills"

$FILTER_SKILL = $args[0]

# Extract frontmatter from SKILL.md
function Extract-Frontmatter {
    param([string]$file)
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        # Extract content between --- markers
        if ($content -match '^---$(.+?)^---$') {
            return $matches[1]
        }
    }
    return ""
}

# Get field from YAML frontmatter
function Get-YamlField {
    param([string]$yaml, [string]$field)
    $line = $yaml -split "`n" | Where-Object { $_ -match "^$field:" } | Select-Object -First 1
    if ($line) {
        return ($line -replace "^$field:\s*", "").Trim('"').Trim()
    }
    return ""
}

# Get list field from YAML (handles both inline and multi-line)
function Get-YamlList {
    param([string]$yaml, [string]$field)
    
    # Try inline format: depends: [a, b, c]
    $inlineLine = $yaml -split "`n" | Where-Object { $_ -match "^$field:\s*\[" } | Select-Object -First 1
    if ($inlineLine) {
        $content = $inlineLine -replace "^$field:\s*\[", "" -replace "\]", ""
        return $content -split "," | ForEach-Object { $_.Trim().Trim('"').Trim() } | Where-Object { $_ }
    }
    
    # Try multi-line format
    $inSection = $false
    $results = @()
    foreach ($line in $yaml -split "`n") {
        if ($line -match "^$field:") {
            $inSection = $true
            continue
        }
        if ($inSection -and $line -match "^[a-z]:") {
            break
        }
        if ($inSection -and $line -match "^\s*-\s*(.+)") {
            $results += $matches[1].Trim('"').Trim()
        }
    }
    return $results
}

# Scan a skill directory
function Scan-Skill {
    param([string]$skillDir)
    $skillName = Split-Path $skillDir -Leaf
    $skillMd = Join-Path $skillDir "SKILL.md"
    $skillJson = Join-Path $skillDir "skill.json"
    
    if ($FILTER_SKILL -and $skillName -ne $FILTER_SKILL) {
        return
    }
    
    if (-not (Test-Path $skillMd)) {
        return
    }
    
    Write-Host "📦 $skillName" -ForegroundColor $colors.Cyan
    
    # Get frontmatter
    $fm = Extract-Frontmatter $skillMd
    $desc = Get-YamlField $fm "description"
    
    # Truncate description
    if ($desc.Length -gt 60) {
        $desc = $desc.Substring(0, 57) + "..."
    }
    Write-Host "   $desc" -ForegroundColor $colors.Blue
    
    # Check for dependencies in frontmatter
    $depends = Get-YamlList $fm "depends"
    $optional = Get-YamlList $fm "optional"
    
    # Also check skill.json if exists
    if (Test-Path $skillJson) {
        try {
            $jsonData = Get-Content $skillJson -Raw | ConvertFrom-Json
            if ($jsonData.PSObject.Properties.Name -contains "depends") {
                $depends += $jsonData.depends.PSObject.Properties.Name
            }
            if ($jsonData.PSObject.Properties.Name -contains "optional") {
                $optional += $jsonData.optional.PSObject.Properties.Name
            }
        } catch {
            # JSON parsing failed, skip
        }
    }
    
    # Clean and dedupe
    $depends = $depends | Sort-Object -Unique | Where-Object { $_ }
    $optional = $optional | Sort-Object -Unique | Where-Object { $_ }
    
    if ($depends) {
        Write-Host "   Depends:" -ForegroundColor $colors.Green
        foreach ($dep in $depends) {
            Write-Host "      └── $dep"
        }
    }
    
    if ($optional) {
        Write-Host "   Optional:" -ForegroundColor $colors.Yellow
        foreach ($opt in $optional) {
            Write-Host "      └── $opt"
        }
    }
    
    if (-not $depends -and -not $optional) {
        Write-Host "   No dependencies" -ForegroundColor $colors.Green
    }
    
    Write-Host ""
}

# Main
Write-Host "`n🔍 Scanning OpenClaw Skills`n" -ForegroundColor $colors.Green

# Scan all skill directories
$skillsDirs = @($BUILTIN_SKILLS, $USER_SKILLS, $LOCAL_SKILLS)
foreach ($skillsDir in $skillsDirs) {
    if (Test-Path $skillsDir) {
        if (-not $FILTER_SKILL) {
            Write-Host "📁 $skillsDir`n" -ForegroundColor $colors.Yellow
        }
        
        $skills = Get-ChildItem $skillsDir -Directory
        foreach ($skill in $skills) {
            Scan-Skill $skill.FullName
        }
    }
}

Write-Host "✅ Scan complete`n" -ForegroundColor $colors.Green

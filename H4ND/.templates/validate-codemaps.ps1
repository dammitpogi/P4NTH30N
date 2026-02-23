# Validate codemaps against template requirements
# This script checks all AGENTS.md files in subdirectories for template compliance

param (
    [string]$RootPath = ".",
    [switch]$Fix,
    [switch]$Verbose
)

# Template requirements
$RequiredSections = @(
    "Responsibility",
    "When Working Here",
    "Core Functions",
    "Key Patterns",
    "Dependencies",
    "Data Collections"
)

Write-Host "🔍 Starting codemap validation from root: $RootPath" -ForegroundColor Cyan

# Find all AGENTS.md files
$AgentsFiles = Get-ChildItem -Path $RootPath -Filter "AGENTS.md" -Recurse -File

if ($AgentsFiles.Count -eq 0) {
    Write-Host "⚠️  No AGENTS.md files found" -ForegroundColor Yellow
    exit 0
}

Write-Host "📁 Found $($AgentsFiles.Count) AGENTS.md files to validate" -ForegroundColor Green

$ValidationResults = @()

foreach ($file in $AgentsFiles) {
    Write-Host "`n📄 Validating: $($file.FullName)" -ForegroundColor Yellow
    $fileContent = Get-Content $file.FullName -Raw
    
    # Check for required sections
    $missingSections = @()
    foreach ($section in $RequiredSections) {
        if ($fileContent -notmatch "## $section\s*$") {
            $missingSections += $section
        }
    }
    
    # Check for template placeholders
    $hasPlaceholders = $fileContent -match "{{.*}}"
    
    # Check for consistent formatting (basic check for proper indentation)
    $properIndentation = $fileContent -match "^\s{2}[^-]"
    
    # Check for broken internal links (basic check)
    $brokenLinks = @()
    if ($fileContent -match "## (.*)\s*") {
        $sections = $matches[1]
        # This is a simplified check - in reality, you'd need more sophisticated link parsing
    }
    
    $result = [PSCustomObject]@{
        File = $file.FullName
        MissingSections = $missingSections
        HasPlaceholders = $hasPlaceholders
        ProperIndentation = $properIndentation
        BrokenLinks = $brokenLinks
        IsValid = ($missingSections.Count -eq 0 -and -not $hasPlaceholders -and $properIndentation)
    }
    
    $ValidationResults += $result
    
    # Report issues
    if ($result.MissingSections.Count -gt 0) {
        Write-Host "  ❌ Missing sections: $($result.MissingSections -join ', ')" -ForegroundColor Red
        if ($Fix) {
            Write-Host "  🔧 Fix mode not implemented for missing sections" -ForegroundColor Yellow
        }
    }
    
    if ($result.HasPlaceholders) {
        Write-Host "  ⚠️  Contains template placeholders" -ForegroundColor Yellow
        if ($Fix) {
            Write-Host "  🔧 Fix mode not implemented for placeholders" -ForegroundColor Yellow
        }
    }
    
    if (-not $result.ProperIndentation) {
        Write-Host "  ⚠️  Inconsistent formatting detected" -ForegroundColor Yellow
        if ($Fix) {
            Write-Host "  🔧 Fix mode not implemented for formatting" -ForegroundColor Yellow
        }
    }
    
    if ($result.IsValid) {
        Write-Host "  ✅ File is valid" -ForegroundColor Green
    }
    
    if ($Verbose) {
        Write-Host "  📊 Validation Details:" -ForegroundColor Cyan
        Write-Host "    - Missing sections: $($result.MissingSections.Count)"
        Write-Host "    - Has placeholders: $($result.HasPlaceholders)"
        Write-Host "    - Proper indentation: $($result.ProperIndentation)"
        Write-Host "    - Valid: $($result.IsValid)"
    }
}

# Summary report
Write-Host "`n📊 Validation Summary" -ForegroundColor Cyan
$totalFiles = $ValidationResults.Count
$validFiles = ($ValidationResults | Where-Object { $_.IsValid }).Count
$invalidFiles = $totalFiles - $validFiles

Write-Host "Total files checked: $totalFiles" -ForegroundColor White
Write-Host "Valid files: $validFiles" -ForegroundColor Green
Write-Host "Invalid files: $invalidFiles" -ForegroundColor Red

if ($invalidFiles -gt 0) {
    Write-Host "`n❌ Issues found in:" -ForegroundColor Red
    ($ValidationResults | Where-Object { -not $_.IsValid } | ForEach-Object {
        Write-Host "  - $($_.File)"
        if ($_.MissingSections.Count -gt 0) {
            Write-Host "    Missing: $($_.MissingSections -join ', ')"
        }
    })
    exit 1
}

Write-Host "`n🎉 All codemaps are valid!" -ForegroundColor Green
exit 0
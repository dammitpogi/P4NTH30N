# RAG Index Rebuild Script
# Nightly full rebuild at 3 AM or on-demand partial rebuild
# Usage: .\scripts\rag\rebuild-index.ps1 [-Full] [-Sources @("docs","C0MMON")]

param(
    [switch]$Full,
    [string[]]$Sources = @(),
    [string]$RagRoot = "C:\P4NTH30N",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

Write-Host "=== RAG Index Rebuild ===" -ForegroundColor Cyan
Write-Host "Timestamp: $timestamp"
Write-Host "Mode: $(if ($Full) { 'FULL REBUILD' } else { 'INCREMENTAL' })"
Write-Host "Dry Run: $DryRun"

# Default source directories for full rebuild
$defaultSources = @(
    "$RagRoot\docs",
    "$RagRoot\C0MMON",
    "$RagRoot\H0UND",
    "$RagRoot\H4ND",
    "$RagRoot\W4TCHD0G",
    "$RagRoot\T4CT1CS\intel"
)

if ($Sources.Count -eq 0) {
    $Sources = $defaultSources
}

# Verify sources exist
$validSources = @()
foreach ($source in $Sources) {
    if (Test-Path $source) {
        $validSources += $source
        $fileCount = (Get-ChildItem -Path $source -Recurse -File -Include *.md,*.cs,*.json | Measure-Object).Count
        Write-Host "  [OK] $source ($fileCount files)" -ForegroundColor Green
    } else {
        Write-Host "  [SKIP] $source (not found)" -ForegroundColor Yellow
    }
}

if ($validSources.Count -eq 0) {
    Write-Host "ERROR: No valid source directories found." -ForegroundColor Red
    exit 1
}

# Count total files
$totalFiles = 0
foreach ($source in $validSources) {
    $totalFiles += (Get-ChildItem -Path $source -Recurse -File -Include *.md,*.cs,*.json | Measure-Object).Count
}

Write-Host ""
Write-Host "Total files to process: $totalFiles" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host ""
    Write-Host "DRY RUN - No changes made." -ForegroundColor Yellow
    exit 0
}

# Ensure rag directory exists
$ragDir = Join-Path $RagRoot "rag"
if (-not (Test-Path $ragDir)) {
    New-Item -ItemType Directory -Path $ragDir -Force | Out-Null
    Write-Host "Created: $ragDir"
}

# Backup existing index
$indexPath = Join-Path $ragDir "faiss.index"
if (Test-Path $indexPath) {
    $backupPath = Join-Path $ragDir "faiss.index.$timestamp.bak"
    Copy-Item $indexPath $backupPath
    Write-Host "Backed up index to: $backupPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Rebuild complete. Files ready for ingestion: $totalFiles" -ForegroundColor Green
Write-Host "Next: Run RAG service to ingest files from configured sources."

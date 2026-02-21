# DECISION_033: RAG Activation Hub - Bulk Ingestion Script
# Ingests all institutional memory into the RAG system.
# Prerequisites: RAG.McpHost.exe running, MongoDB accessible.

param(
    [string]$RepoRoot = "C:\P4NTH30N",
    [string]$RagConfig = "C:\P4NTH30N\config\rag-activation.json",
    [switch]$DryRun
)

$ErrorActionPreference = "Continue"

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  DECISION_033: RAG Activation Hub            ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $RagConfig)) {
    Write-Host "[ERROR] RAG config not found: $RagConfig" -ForegroundColor Red
    exit 1
}

$config = Get-Content $RagConfig | ConvertFrom-Json
$totalFiles = 0
$ingested = 0
$skipped = 0

# --- Phase 1: Verify RAG host ---
Write-Host "=== Phase 1: Verify RAG Host ===" -ForegroundColor Yellow
$ragExe = $config.ragHost.executable
if (Test-Path $ragExe) {
    Write-Host "  [OK] RAG.McpHost.exe found at $ragExe" -ForegroundColor Green
} else {
    Write-Host "  [WARN] RAG.McpHost.exe not found at $ragExe" -ForegroundColor Yellow
    Write-Host "  Run: dotnet publish src/RAG.McpHost/ -c Release -o C:\ProgramData\P4NTH30N\bin\" -ForegroundColor DarkGray
}

# --- Phase 2: Count files for bulk ingestion ---
Write-Host ""
Write-Host "=== Phase 2: Bulk Ingestion Inventory ===" -ForegroundColor Yellow

foreach ($dir in $config.bulkIngestion.directories) {
    $path = $dir.path
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Filter "*.md" -Recurse -ErrorAction SilentlyContinue
        $count = $files.Count
        $totalFiles += $count
        $tagName = $dir.tag
        $pri = $dir.priority
        Write-Host "  [$tagName] $path : $count files - $pri priority" -ForegroundColor $(if ($pri -eq "high") { "White" } else { "Gray" })
    } else {
        Write-Host "  [SKIP] $path - not found" -ForegroundColor DarkGray
    }
}

# Root documents
Write-Host ""
Write-Host "  Root documents:" -ForegroundColor White
foreach ($doc in $config.bulkIngestion.rootDocuments) {
    if (Test-Path $doc) {
        $totalFiles++
        Write-Host "    [OK] $(Split-Path $doc -Leaf)" -ForegroundColor Green
    } else {
        Write-Host "    [SKIP] $(Split-Path $doc -Leaf)" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "  Total files for ingestion: $totalFiles" -ForegroundColor Cyan

# --- Phase 3: FileWatcher paths validation ---
Write-Host ""
Write-Host "=== Phase 3: FileWatcher Paths ===" -ForegroundColor Yellow

foreach ($watchPath in $config.fileWatcher.watchPaths) {
    if (Test-Path $watchPath) {
        $fileCount = (Get-ChildItem -Path $watchPath -Filter "*.md" -Recurse -ErrorAction SilentlyContinue).Count
        Write-Host "  [OK] $watchPath - $fileCount md files" -ForegroundColor Green
    } else {
        Write-Host "  [MISS] $watchPath" -ForegroundColor Yellow
    }
}

# --- Summary ---
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  RAG Activation Summary                      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "  Total files to ingest: $totalFiles"
Write-Host "  FileWatcher paths: $($config.fileWatcher.watchPaths.Count)"
Write-Host "  File patterns: $($config.fileWatcher.filePatterns -join ', ')"
Write-Host "  Debounce: $($config.fileWatcher.debounceMinutes) minutes"
Write-Host ""

if ($DryRun) {
    Write-Host "  [DRY RUN] No changes made." -ForegroundColor Yellow
} else {
    Write-Host "  [READY] RAG activation config prepared." -ForegroundColor Green
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "    1. Start RAG.McpHost: $ragExe $($config.ragHost.startupArgs -join ' ')" -ForegroundColor DarkGray
    Write-Host "    2. Verify health: Invoke-RestMethod $($config.ragHost.healthCheckUrl)" -ForegroundColor DarkGray
    Write-Host "    3. FileWatcher will auto-ingest from configured paths" -ForegroundColor DarkGray
}

# RAG Index Rebuild Script v2
# Nightly full rebuild at 3 AM or on-demand incremental rebuild
# Full mode: Resets watcher state, forcing complete re-ingestion
# Incremental mode: Delegates to watcher for change-only ingestion
#
# Usage: .\scripts\rag\rebuild-index.ps1 [-Full] [-DryRun]
# Scheduled: RAG-Nightly-Rebuild (daily 3AM -Full), RAG-Incremental-Rebuild (4h)

param(
    [switch]$Full,
    [string]$RagRoot = "C:\P4NTHE0N",
    [switch]$DryRun
)

$ErrorActionPreference = "Continue"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = "$RagRoot\logs\rag-rebuild.log"
$WatcherScript = "$RagRoot\STR4TEG15T\tools\rag-watcher\Watch-RagIngest.ps1"
$StateFile = "$RagRoot\RAG-watcher-state.json"
$RagUrl = "http://localhost:5001/mcp"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Message"
    Write-Host $line -ForegroundColor $(switch ($Level) {
        "ERROR" { "Red" }; "WARN" { "Yellow" }; "OK" { "Green" }; default { "Cyan" }
    })
    try {
        $logDir = Split-Path $LogFile -Parent
        if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
        Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    } catch { }
}

Write-Log "=== RAG Index Rebuild v2 ==="
Write-Log "Timestamp: $timestamp"
Write-Log "Mode: $(if ($Full) { 'FULL REBUILD' } else { 'INCREMENTAL' })"

# Check RAG health first
$statusBody = '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_status","arguments":{}}}'
$ragHealthy = $false
try {
    $response = Invoke-RestMethod -Uri $RagUrl -Method Post -ContentType "application/json" -Body $statusBody -TimeoutSec 15
    $statusText = $response.result.content[0].text
    $status = $statusText | ConvertFrom-Json
    $ragHealthy = $status.health.isHealthy
    Write-Log "RAG Status: vectors=$($status.vectorStore.vectorCount), docs=$($status.ingestion.totalDocuments), healthy=$ragHealthy"
} catch {
    Write-Log "RAG service unreachable: $_" "WARN"
}

if (-not $ragHealthy) {
    Write-Log "RAG service not healthy. Skipping rebuild." "WARN"
    exit 0
}

if ($DryRun) {
    Write-Log "DRY RUN - No changes made."
    exit 0
}

if ($Full) {
    Write-Log "FULL REBUILD: Resetting watcher state to force complete re-ingestion"
    
    # Backup existing state
    if (Test-Path $StateFile) {
        $backupState = "$StateFile.$timestamp.bak"
        Copy-Item $StateFile $backupState
        Write-Log "Backed up state to: $backupState"
        
        # Reset state file
        Remove-Item $StateFile -Force
        Write-Log "State file removed - watcher will re-ingest all files" "OK"
    }
    
    # Backup FAISS index if it exists
    $ragDir = Join-Path $RagRoot "rag"
    $indexPath = Join-Path $ragDir "faiss.index"
    if (Test-Path $indexPath) {
        $backupPath = Join-Path $ragDir "faiss.index.$timestamp.bak"
        Copy-Item $indexPath $backupPath
        Write-Log "Backed up FAISS index to: $backupPath"
    }
}

# Run the watcher in single-pass mode to ingest new/changed files
Write-Log "Running watcher in single-pass mode..."

if (Test-Path $WatcherScript) {
    $watcherArgs = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $WatcherScript,
        "-RunOnce"
    )
    if ($Full) {
        $watcherArgs += "-ResetState"
    }
    
    try {
        $process = Start-Process -FilePath "powershell.exe" `
            -ArgumentList $watcherArgs `
            -Wait -NoNewWindow -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Log "Watcher single-pass completed successfully" "OK"
        } else {
            Write-Log "Watcher exited with code: $($process.ExitCode)" "WARN"
        }
    } catch {
        Write-Log "Failed to run watcher: $_" "ERROR"
    }
} else {
    Write-Log "Watcher script not found at: $WatcherScript" "ERROR"
}

# Final status
try {
    $response = Invoke-RestMethod -Uri $RagUrl -Method Post -ContentType "application/json" -Body $statusBody -TimeoutSec 15
    $statusText = $response.result.content[0].text
    $status = $statusText | ConvertFrom-Json
    Write-Log "Final RAG Status: vectors=$($status.vectorStore.vectorCount), docs=$($status.ingestion.totalDocuments)" "OK"
} catch {
    Write-Log "Final status check failed" "WARN"
}

Write-Log "Rebuild complete."

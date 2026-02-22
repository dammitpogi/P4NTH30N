<#
.SYNOPSIS
    RAG File Watcher v2 - Automatically ingests new/changed documents into RAG knowledge base.
.DESCRIPTION
    Watches P4NTH30N directories for new or modified files and automatically ingests them
    into the RAG knowledge base via rag_ingest_file (file-based, no truncation).
    Runs as a background service. Survives restarts via Windows Scheduled Task.
    
    Watched directories (MAINTAINED BY OPENFIXER - DECISION_080):
    ┌─────────────────────────────────────────────────────────────────┐
    │ STRATEGIST CORPUS                                              │
    │  STR4TEG15T/decisions/active/     → type: decision             │
    │  STR4TEG15T/decisions/completed/  → type: decision             │
    │  STR4TEG15T/speech/               → type: speech               │
    │  STR4TEG15T/manifest/             → type: manifest             │
    │  STR4TEG15T/actions/              → type: action               │
    │  STR4TEG15T/submissions/          → type: submission           │
    ├─────────────────────────────────────────────────────────────────┤
    │ OPENFIXER CORPUS                                               │
    │  OP3NF1XER/deployments/           → type: deployment           │
    ├─────────────────────────────────────────────────────────────────┤
    │ CODEBASE PATTERNS                                              │
    │  C0MMON/RAG/                      → type: pattern              │
    │  C0MMON/Infrastructure/           → type: pattern (recursive)  │
    ├─────────────────────────────────────────────────────────────────┤
    │ EXTERNAL CONFIG                                                │
    │  ~/.config/opencode/AGENTS.md     → type: config               │
    │  ~/.config/Claude/AGENTS.md       → type: config               │
    └─────────────────────────────────────────────────────────────────┘
    
    No agent involvement - pure script automation.
    
.PARAMETER RagUrl
    RAG MCP HTTP endpoint URL. Default: http://localhost:5001/mcp
.PARAMETER WatchInterval
    Polling interval in seconds. Default: 30
.PARAMETER StateFile
    Path to state file tracking ingested files. Default: C:\P4NTH30N\RAG-watcher-state.json
.PARAMETER RunOnce
    Run once instead of continuous watch mode.
.PARAMETER LogFile
    Path to log file. Default: C:\P4NTH30N\logs\rag-watcher.log
.EXAMPLE
    .\Watch-RagIngest.ps1 -RunOnce
    # Run a single pass to ingest all existing files
.EXAMPLE
    .\Watch-RagIngest.ps1
    # Run as continuous background service (Ctrl+C to stop)
#>
param(
    [string]$RagUrl = "http://localhost:5001/mcp",
    [int]$WatchInterval = 30,
    [string]$StateFile = "C:\P4NTH30N\RAG-watcher-state.json",
    [string]$LogFile = "C:\P4NTH30N\logs\rag-watcher.log",
    [switch]$RunOnce,
    [switch]$Verbose,
    [switch]$ResetState
)

$ErrorActionPreference = "Continue"
$script:Version = "2.0.0"

# ============================================================
# LOGGING
# ============================================================
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    
    # Console output
    switch ($Level) {
        "ERROR"   { Write-Host $line -ForegroundColor Red }
        "WARN"    { Write-Host $line -ForegroundColor Yellow }
        "OK"      { Write-Host $line -ForegroundColor Green }
        "SKIP"    { if ($Verbose) { Write-Host $line -ForegroundColor Gray } }
        default   { Write-Host $line -ForegroundColor Cyan }
    }
    
    # File output
    try {
        $logDir = Split-Path $LogFile -Parent
        if (-not (Test-Path $logDir)) {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }
        Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    } catch { }
}

# ============================================================
# PATHS CONFIGURATION
# ============================================================
$P4NTH30N = "C:\P4NTH30N"
$HomeDir = $env:USERPROFILE

# Watch configurations: each entry defines a directory, its extensions, recursion, and metadata
$WatchConfigs = @(
    # --- STRATEGIST CORPUS ---
    @{
        Path = "$P4NTH30N\STR4TEG15T\decisions\active"
        Extensions = @("*.md")
        Recurse = $false
        DefaultType = "decision"
        DefaultAgent = "strategist"
    },
    @{
        Path = "$P4NTH30N\STR4TEG15T\decisions\completed"
        Extensions = @("*.md")
        Recurse = $false
        DefaultType = "decision"
        DefaultAgent = "strategist"
    },
    @{
        Path = "$P4NTH30N\STR4TEG15T\speech"
        Extensions = @("*.md")
        Recurse = $false
        DefaultType = "speech"
        DefaultAgent = "strategist"
    },
    @{
        Path = "$P4NTH30N\STR4TEG15T\manifest"
        Extensions = @("*.md", "*.json")
        Recurse = $false
        DefaultType = "manifest"
        DefaultAgent = "strategist"
    },
    @{
        Path = "$P4NTH30N\STR4TEG15T\actions"
        Extensions = @("*.md")
        Recurse = $true
        DefaultType = "action"
        DefaultAgent = "strategist"
    },
    @{
        Path = "$P4NTH30N\STR4TEG15T\submissions"
        Extensions = @("*.md")
        Recurse = $true
        DefaultType = "submission"
        DefaultAgent = "strategist"
    },
    # --- OPENFIXER CORPUS ---
    @{
        Path = "$P4NTH30N\OP3NF1XER\deployments"
        Extensions = @("*.md")
        Recurse = $false
        DefaultType = "deployment"
        DefaultAgent = "openfixer"
    },
    # --- CODEBASE PATTERNS ---
    @{
        Path = "$P4NTH30N\C0MMON\RAG"
        Extensions = @("*.cs")
        Recurse = $false
        DefaultType = "pattern"
        DefaultAgent = "strategist"
    },
    @{
        Path = "$P4NTH30N\C0MMON\Infrastructure"
        Extensions = @("*.cs")
        Recurse = $true
        DefaultType = "pattern"
        DefaultAgent = "strategist"
    },
    # --- EXTERNAL CONFIG ---
    @{
        Path = "$HomeDir\.config\opencode"
        Extensions = @("AGENTS.md")
        Recurse = $false
        DefaultType = "config"
        DefaultAgent = "system"
    },
    @{
        Path = "$HomeDir\.config\Claude"
        Extensions = @("AGENTS.md")
        Recurse = $false
        DefaultType = "config"
        DefaultAgent = "system"
    }
)

# ============================================================
# STATE MANAGEMENT
# ============================================================
function Load-State {
    if ($ResetState -and (Test-Path $StateFile)) {
        Remove-Item $StateFile -Force
        Write-Log "State file reset" "WARN"
    }
    
    if (Test-Path $StateFile) {
        try {
            $loaded = Get-Content $StateFile -Raw | ConvertFrom-Json
            if ($loaded.ingested -is [System.Management.Automation.PSCustomObject]) {
                $hashtable = @{}
                $loaded.ingested.PSObject.Properties | ForEach-Object {
                    $hashtable[$_.Name] = $_.Value
                }
                $loaded.ingested = $hashtable
            }
            return $loaded
        } catch {
            Write-Log "Failed to load state file, starting fresh: $_" "WARN"
        }
    }
    return @{
        ingested = @{}
        lastRun = $null
        version = $script:Version
    }
}

function Save-State($state) {
    # Ensure state is a hashtable for reliable property assignment
    if ($state -isnot [hashtable]) {
        $newState = @{}
        $state.PSObject.Properties | ForEach-Object { $newState[$_.Name] = $_.Value }
        $state = $newState
    }
    $state["lastRun"] = (Get-Date).ToString("o")
    $state["version"] = $script:Version
    try {
        $state | ConvertTo-Json -Depth 5 | Set-Content $StateFile -Encoding UTF8
    } catch {
        Write-Log "Failed to save state: $_" "ERROR"
    }
}

# ============================================================
# METADATA EXTRACTION
# ============================================================
function Get-FileMetadata {
    param(
        [string]$FilePath,
        [hashtable]$Config
    )
    
    $fileName = Split-Path $FilePath -Leaf
    $docType = $Config.DefaultType
    $agent = $Config.DefaultAgent
    
    # Build source path relative to the watch config
    $configRoot = $Config.Path
    $relativePath = $FilePath.Substring($configRoot.Length).TrimStart('\', '/')
    
    # Build a meaningful source identifier
    switch ($docType) {
        "decision" {
            $subDir = if ($configRoot -match 'completed') { "completed" } else { "active" }
            $source = "decisions/$subDir/$fileName"
        }
        "speech" {
            $source = "speech/$fileName"
        }
        "manifest" {
            $source = "manifest/$fileName"
        }
        "action" {
            $source = "actions/$relativePath"
        }
        "submission" {
            $source = "submissions/$relativePath"
        }
        "deployment" {
            $source = "deployments/$fileName"
        }
        "pattern" {
            # Determine subdirectory (RAG or Infrastructure)
            if ($configRoot -match 'RAG$') {
                $source = "codebase/RAG/$fileName"
            } else {
                $source = "codebase/Infrastructure/$relativePath"
            }
        }
        "config" {
            $source = "config/$fileName"
        }
        default {
            $source = $relativePath
        }
    }
    
    # Extract decision ID if present
    $decisionId = $null
    if ($fileName -match '(DECISION[_-]\w+)') {
        $decisionId = $Matches[1]
    } elseif ($fileName -match '(FORGE[_-]\d+)') {
        $decisionId = $Matches[1]
    }
    
    return @{
        source = $source
        docType = $docType
        agent = $agent
        decisionId = $decisionId
    }
}

# ============================================================
# RAG INGESTION (file-based, no truncation)
# ============================================================
function Invoke-RagIngestFile {
    param(
        [string]$FilePath,
        [hashtable]$Metadata
    )
    
    $metaObj = @{
        agent = $Metadata.agent
        type = $Metadata.docType
        source = $Metadata.source
        ingestedBy = "RAG-watcher-v2"
        ingestedAt = (Get-Date).ToString("o")
    }
    if ($Metadata.decisionId) {
        $metaObj["decisionId"] = $Metadata.decisionId
    }
    
    $jsonRpc = @{
        jsonrpc = "2.0"
        id = [guid]::NewGuid().ToString()
        method = "tools/call"
        params = @{
            name = "rag_ingest_file"
            arguments = @{
                filePath = $FilePath
                metadata = $metaObj
            }
        }
    } | ConvertTo-Json -Depth 5 -Compress
    
    try {
        $response = Invoke-RestMethod -Uri $RagUrl -Method Post `
            -ContentType "application/json" `
            -Body $jsonRpc `
            -TimeoutSec 60
        return $true
    } catch {
        Write-Log "Failed to ingest '$($Metadata.source)': $_" "ERROR"
        return $false
    }
}

# ============================================================
# HEALTH CHECK (waits for RAG service on boot)
# ============================================================
function Wait-ForRagService {
    param([int]$MaxRetries = 60, [int]$RetryDelay = 10)
    
    Write-Log "Checking RAG service health..."
    $statusBody = '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_status","arguments":{}}}'
    
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            $response = Invoke-RestMethod -Uri $RagUrl -Method Post `
                -ContentType "application/json" `
                -Body $statusBody `
                -TimeoutSec 10
            
            $statusText = $response.result.content[0].text
            $status = $statusText | ConvertFrom-Json
            
            if ($status.health.isHealthy) {
                Write-Log "RAG service healthy. Vectors: $($status.vectorStore.vectorCount), Docs: $($status.ingestion.totalDocuments)" "OK"
                return $true
            }
        } catch {
            # Service not ready yet
        }
        
        if ($i -lt $MaxRetries) {
            Write-Log "RAG service not ready (attempt $i/$MaxRetries), waiting ${RetryDelay}s..." "WARN"
            Start-Sleep -Seconds $RetryDelay
        }
    }
    
    Write-Log "RAG service did not become healthy after $MaxRetries attempts" "ERROR"
    return $false
}

# ============================================================
# FILE PROCESSING
# ============================================================
function Process-File {
    param(
        [string]$FilePath,
        [hashtable]$Config
    )
    
    $state = Load-State
    $fileKey = $FilePath.ToLower()
    
    # Compute file hash for change detection
    try {
        $contentBytes = [System.IO.File]::ReadAllBytes($FilePath)
        if ($contentBytes.Length -eq 0) { return $false }
        $contentHash = (Get-FileHash -InputStream ([System.IO.MemoryStream]$contentBytes) -Algorithm MD5).Hash
    } catch {
        return $false
    }
    
    # Skip if unchanged
    $existing = $null
    if ($state.ingested -is [hashtable] -and $state.ingested.ContainsKey($fileKey)) {
        $existing = $state.ingested[$fileKey]
    } elseif ($state.ingested -is [System.Management.Automation.PSCustomObject]) {
        $existing = $state.ingested.$fileKey
    }
    
    if ($null -ne $existing) {
        $existingHash = $null
        if ($existing -is [System.Management.Automation.PSCustomObject]) {
            $existingHash = $existing.hash
        } elseif ($existing -is [hashtable]) {
            $existingHash = $existing.hash
        }
        if ($existingHash -eq $contentHash) {
            Write-Log "Unchanged: $(Split-Path $FilePath -Leaf)" "SKIP"
            return $false
        }
    }
    
    # Extract metadata
    $metadata = Get-FileMetadata -FilePath $FilePath -Config $Config
    
    # Ingest via rag_ingest_file
    $success = Invoke-RagIngestFile -FilePath $FilePath -Metadata $metadata
    
    if ($success) {
        if ($null -eq $state.ingested) { $state.ingested = @{} }
        $state.ingested[$fileKey] = @{
            hash = $contentHash
            source = $metadata.source
            docType = $metadata.docType
            ingestedAt = (Get-Date).ToString("o")
        }
        Save-State $state
        Write-Log "$($metadata.source) -> RAG ($($metadata.docType))" "OK"
        return $true
    }
    
    return $false
}

# Get all files from all watch configs
function Get-AllWatchFiles {
    $results = @()
    foreach ($config in $WatchConfigs) {
        if (-not (Test-Path $config.Path)) { continue }
        
        foreach ($ext in $config.Extensions) {
            $params = @{
                Path = $config.Path
                Filter = $ext
                File = $true
                ErrorAction = "SilentlyContinue"
            }
            if ($config.Recurse) {
                $params["Recurse"] = $true
            }
            
            $files = Get-ChildItem @params
            foreach ($f in $files) {
                $results += @{ File = $f; Config = $config }
            }
        }
    }
    return $results
}

# ============================================================
# MAIN
# ============================================================
Write-Log "RAG File Watcher v$script:Version starting..."
Write-Log "RAG Endpoint: $RagUrl"
Write-Log "State File: $StateFile"
Write-Log "Log File: $LogFile"
Write-Log "Watch interval: ${WatchInterval}s"
Write-Log ""
Write-Log "Monitored directories:"
foreach ($config in $WatchConfigs) {
    $exists = Test-Path $config.Path
    $status = if ($exists) { "OK" } else { "MISSING" }
    $recurse = if ($config.Recurse) { " (recursive)" } else { "" }
    Write-Log "  [$status] $($config.Path) -> $($config.DefaultType)$recurse"
}
Write-Log ""

# Wait for RAG service to be healthy
if (-not (Wait-ForRagService)) {
    Write-Log "Exiting: RAG service unavailable" "ERROR"
    exit 1
}

$state = Load-State
Write-Log "State: $($state.ingested.Count) files already tracked"
Write-Log ""

if ($RunOnce) {
    Write-Log "Running single pass..."
    $allFiles = Get-AllWatchFiles
    Write-Log "Found $($allFiles.Count) files to process"
    
    $ingested = 0
    $skipped = 0
    $failed = 0
    
    foreach ($entry in $allFiles) {
        $result = Process-File -FilePath $entry.File.FullName -Config $entry.Config
        if ($result) { $ingested++ } else { $skipped++ }
    }
    
    Write-Log ""
    Write-Log "Single pass complete. Ingested: $ingested, Skipped: $skipped"
    
    # Final status check
    $statusBody = '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_status","arguments":{}}}'
    try {
        $response = Invoke-RestMethod -Uri $RagUrl -Method Post -ContentType "application/json" -Body $statusBody -TimeoutSec 15
        $statusText = $response.result.content[0].text
        $status = $statusText | ConvertFrom-Json
        Write-Log "Final RAG: $($status.vectorStore.vectorCount) vectors, $($status.ingestion.totalDocuments) docs" "OK"
    } catch { }
    
    exit 0
}

# Continuous watch mode
Write-Log "Entering continuous watch mode... (Ctrl+C to stop)"

$cycleCount = 0
$totalIngested = 0

try {
    while ($true) {
        $cycleCount++
        $allFiles = Get-AllWatchFiles
        $cycleIngested = 0
        
        foreach ($entry in $allFiles) {
            $result = Process-File -FilePath $entry.File.FullName -Config $entry.Config
            if ($result) {
                $cycleIngested++
                $totalIngested++
            }
        }
        
        if ($cycleIngested -gt 0) {
            Write-Log "Cycle ${cycleCount} - ingested $cycleIngested files (total $totalIngested)"
        }
        
        # Periodic health check every 100 cycles (~50 min at 30s interval)
        if ($cycleCount % 100 -eq 0) {
            $statusBody = '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"rag_status","arguments":{}}}'
            try {
                $response = Invoke-RestMethod -Uri $RagUrl -Method Post -ContentType "application/json" -Body $statusBody -TimeoutSec 15
                $statusText = $response.result.content[0].text
                $status = $statusText | ConvertFrom-Json
                Write-Log "Health check: $($status.vectorStore.vectorCount) vectors, healthy=$($status.health.isHealthy)"
            } catch {
                Write-Log "Health check failed - RAG may be down" "WARN"
            }
        }
        
        Start-Sleep -Seconds $WatchInterval
    }
} finally {
    Write-Log "Watcher stopped after $cycleCount cycles, $totalIngested total ingested"
}

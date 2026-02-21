<#
.SYNOPSIS
    RAG File Watcher - Automatically ingests new documents into RAG knowledge base.
.DESCRIPTION
    Watches STR4TEG15T directories for new files and automatically ingests them
    into the RAG knowledge base. Runs as a background service.
    
    Watched directories:
    - STR4TEG15T/decisions/active/   (decision files)
    - STR4TEG15T/decisions/completed/ (completed decisions)
    - STR4TEG15T/speech/              (speech synthesis logs)
    - STR4TEG15T/manifest/             (narrative manifest)
    - OP3NF1XER/deployments/          (deployment journals)
    
    No agent involvement - pure script automation.
.PARAMETER RagUrl
    RAG MCP HTTP endpoint URL. Default: http://localhost:5001/mcp
.PARAMETER WatchInterval
    Polling interval in seconds. Default: 5
.PARAMETER StateFile
    Path to state file tracking ingested files. Default: RAG-watcher-state.json
.PARAMETER RunOnce
    Run once instead of continuous watch mode.
.EXAMPLE
    .\Watch-RagIngest.ps1 -RunOnce
    # Run a single pass to ingest all existing files
.EXAMPLE
    .\Watch-RagIngest.ps1
    # Run as continuous background service (Ctrl+C to stop)
#>
param(
    [string]$RagUrl = "http://localhost:5001/mcp",
    [int]$WatchInterval = 5,
    [string]$StateFile = "C:\P4NTH30N\RAG-watcher-state.json",
    [switch]$RunOnce,
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"

# Paths - resolve P4NTH30N root
$P4NTH30N = "C:\P4NTH30N"
$WatchPaths = @(
    "$P4NTH30N\STR4TEG15T\decisions\active",
    "$P4NTH30N\STR4TEG15T\decisions\completed", 
    "$P4NTH30N\STR4TEG15T\speech",
    "$P4NTH30N\STR4TEG15T\manifest",
    "$P4NTH30N\OP3NF1XER\deployments"
)

# Filter patterns
$IncludeExtensions = @("*.md", "*.json")

# Initialize state
function Load-State {
    if (Test-Path $StateFile) {
        try {
            $loaded = Get-Content $StateFile -Raw | ConvertFrom-Json
            # Ensure ingested is a proper hashtable
            if ($loaded.ingested -is [System.Management.Automation.PSCustomObject]) {
                $hashtable = @{}
                $loaded.ingested.PSObject.Properties | ForEach-Object {
                    $hashtable[$_.Name] = $_.Value
                }
                $loaded.ingested = $hashtable
            }
            return $loaded
        } catch {
            Write-Warning "Failed to load state file: $_"
        }
    }
    return @{
        ingested = @{}
        lastRun = $null
    }
}

function Save-State($state) {
    $state.lastRun = (Get-Date).ToString("o")
    $state | ConvertTo-Json -Depth 5 | Set-Content $StateFile -Encoding UTF8
}

# Extract metadata from file path
function Get-FileMetadata {
    param([string]$FilePath)
    
    $fileName = Split-Path $FilePath -Leaf
    $dirPath = Split-Path $FilePath -Parent
    $relativePath = $FilePath -replace [regex]::Escape($P4NTH30N), ""
    
    # Determine document type and agent
    $docType = "unknown"
    $agent = "system"
    
    if ($relativePath -match "STR4TEG15T[/\\]decisions[/\\]active") {
        $docType = "decision"
        $agent = "strategist"
        if ($fileName -match "DECISION_(\w+)") {
            $source = "decisions/active/$($Matches[1])"
        }
    } elseif ($relativePath -match "STR4TEG15T[/\\]decisions[/\\]completed") {
        $docType = "decision"
        $agent = "strategist"
        if ($fileName -match "DECISION_(\w+)") {
            $source = "decisions/completed/$($Matches[1])"
        }
    } elseif ($relativePath -match "STR4TEG15T[/\\]speech[/\\](.+)") {
        $docType = "speech"
        $agent = "strategist"
        $source = "speech/$($Matches[1])" -replace "\.md$", ""
    } elseif ($relativePath -match "STR4TEG15T[/\\]manifest[/\\]") {
        $docType = "manifest"
        $agent = "strategist"
        $source = "manifest/manifest"
    } elseif ($relativePath -match "OP3NF1XER[/\\]deployments[/\\](.+)") {
        $docType = "deployment"
        $agent = "openfixer"
        $source = "deployments/$($Matches[1])" -replace "\.md$", ""
    }
    
    return @{
        source = $source
        docType = $docType
        agent = $agent
        relativePath = $relativePath.TrimStart("\")
    }
}

# Ingest file to RAG via HTTP JSON-RPC
function Invoke-RagIngest {
    param(
        [string]$Content,
        [string]$Source,
        [string]$DocType,
        [string]$Agent
    )
    
    $jsonRpc = @{
        jsonrpc = "2.0"
        id = [guid]::NewGuid().ToString()
        method = "tools/call"
        params = @{
            name = "rag_ingest"
            arguments = @{
                content = $Content
                source = $Source
                metadata = @{
                    docType = $DocType
                    agent = $Agent
                    ingestedBy = "RAG-watcher"
                    ingestedAt = (Get-Date).ToString("o")
                }
            }
        }
    } | ConvertTo-Json -Depth 5 -Compress
    
    try {
        $response = Invoke-RestMethod -Uri $RagUrl -Method Post `
            -ContentType "application/json" `
            -Body $jsonRpc `
            -TimeoutSec 30
        
        if ($Verbose -or $DebugPreference -eq "Continue") {
            Write-Host "[RAG] Ingested: $Source" -ForegroundColor Green
        }
        return $true
    } catch {
        Write-Warning "[RAG] Failed to ingest '$Source': $_"
        return $false
    }
}

# Process a single file
function Process-File {
    param([string]$FilePath)
    
    $state = Load-State
    $fileKey = $FilePath.ToLower()
    
    # Check if already ingested (by file hash)
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return $false }
    
    $contentHash = (Get-FileHash -InputStream ([System.IO.MemoryStream][byte[]][Text.Encoding]::UTF8.GetBytes($content)) -Algorithm MD5).Hash
    
    if ($state.ingested.$fileKey -and $state.ingested.$fileKey.hash -eq $contentHash) {
        if ($Verbose) { Write-Host "[SKIP] Unchanged: $FilePath" -ForegroundColor Gray }
        return $false
    }
    
    # Extract metadata
    $metadata = Get-FileMetadata -FilePath $FilePath
    
    # Ingest
    $success = Invoke-RagIngest -Content $content -Source $metadata.source -DocType $metadata.docType -Agent $metadata.agent
    
    if ($success) {
        # Update state - ensure hashtable is properly initialized
        if ($null -eq $state.ingested) { $state.ingested = @{} }
        $state.ingested[$fileKey] = @{
            hash = $contentHash
            source = $metadata.source
            docType = $metadata.docType
            ingestedAt = (Get-Date).ToString("o")
        }
        Save-State $state
        Write-Host "[OK] $FilePath -> RAG ($($metadata.docType))" -ForegroundColor Green
        return $true
    }
    
    return $false
}

# Get all files in watched directories
function Get-WatchFiles {
    $files = @()
    foreach ($path in $WatchPaths) {
        if (Test-Path $path) {
            foreach ($ext in $IncludeExtensions) {
                $files += Get-ChildItem -Path $path -Filter $ext -File -ErrorAction SilentlyContinue
            }
        }
    }
    return $files
}

# Main loop
Write-Host "RAG File Watcher starting..." -ForegroundColor Cyan
Write-Host "RAG Endpoint: $RagUrl" -ForegroundColor Cyan
Write-Host "Watch paths:" -ForegroundColor Cyan
foreach ($p in $WatchPaths) { Write-Host "  - $p" -ForegroundColor Gray }
Write-Host ""

$state = Load-State
Write-Host "State: $($state.ingested.Count) files already tracked" -ForegroundColor Gray
Write-Host ""

if ($RunOnce) {
    Write-Host "Running single pass..." -ForegroundColor Yellow
    $files = Get-WatchFiles
    Write-Host "Found $($files.Count) files to process" -ForegroundColor Cyan
    
    $ingested = 0
    foreach ($file in $files) {
        if (Process-File -FilePath $file.FullName) {
            $ingested++
        }
    }
    
    Write-Host ""
    Write-Host "Complete. Ingested $ingested new files." -ForegroundColor Green
    exit 0
}

# Continuous watch mode
Write-Host "Watching for changes... (Press Ctrl+C to stop)" -ForegroundColor Yellow

try {
    while ($true) {
        $files = Get-WatchFiles
        
        foreach ($file in $files) {
            Process-File -FilePath $file.FullName | Out-Null
        }
        
        Start-Sleep -Seconds $WatchInterval
    }
} finally {
    Write-Host ""
    Write-Host "Watcher stopped." -ForegroundColor Yellow
}

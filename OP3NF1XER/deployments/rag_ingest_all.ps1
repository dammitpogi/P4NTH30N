# RAG Ingestion Script for DECISION_052, 053, 054
# This script ingests speech logs, decisions, and codebase patterns into RAG

$RAG_SERVER = "http://localhost:5001/mcp"
$SPEECH_DIR = "c:/P4NTHE0N/STR4TEG15T/speech"
$DECISIONS_ACTIVE_DIR = "c:/P4NTHE0N/STR4TEG15T/decisions/active"
$DECISIONS_COMPLETED_DIR = "c:/P4NTHE0N/STR4TEG15T/decisions/completed"

$ingestedCount = 0
$failedFiles = @()

function Invoke-RagIngestFile {
    param($filePath, $metadata)
    
    $body = @{
        jsonrpc = "2.0"
        id = [System.Guid]::NewGuid().ToString()
        method = "tools/call"
        params = @{
            name = "rag_ingest_file"
            arguments = @{
                filePath = $filePath.Replace("\", "/")
                metadata = $metadata
            }
        }
    } | ConvertTo-Json -Depth 10 -Compress
    
    try {
        $response = Invoke-RestMethod -Uri $RAG_SERVER -Method POST -ContentType "application/json" -Body $body -TimeoutSec 30
        if ($response.result) {
            return $true
        } else {
            Write-Host "Failed: $filePath - $($response.error.message)"
            return $false
        }
    } catch {
        Write-Host "Error: $filePath - $($_.Exception.Message)"
        return $false
    }
}

Write-Host "=== PHASE 1: Speech Logs (DECISION_052) ==="
$speechFiles = Get-ChildItem -Path $SPEECH_DIR -Filter "*.md" | Sort-Object Name
Write-Host "Found $($speechFiles.Count) speech log files"

foreach ($file in $speechFiles) {
    $metadata = @{
        source = "speech-log"
        filename = $file.Name
        category = "operational-log"
    }
    
    if (Invoke-RagIngestFile -filePath $file.FullName -metadata $metadata) {
        $ingestedCount++
        Write-Host "[$ingestedCount] Ingested: $($file.Name)"
    } else {
        $failedFiles += $file.Name
    }
    
    Start-Sleep -Milliseconds 100
}

Write-Host "`n=== PHASE 2: Active Decisions (DECISION_053) ==="
$skipPatterns = @("TEMPLATE", "INVENTORY", "DEPLOYMENT-PACKAGE", "SUMMARY", "ALL-DECISIONS", "CONSOLIDATED")
$activeFiles = Get-ChildItem -Path $DECISIONS_ACTIVE_DIR -Filter "*.md" | Where-Object { 
    $name = $_.Name
    $skip = $false
    foreach ($pattern in $skipPatterns) {
        if ($name -like "*$pattern*") { $skip = $true; break }
    }
    -not $skip
} | Sort-Object Name

Write-Host "Found $($activeFiles.Count) active decision files"

foreach ($file in $activeFiles) {
    $metadata = @{
        source = "decision"
        filename = $file.Name
        status = "active"
        category = "decision-document"
    }
    
    if (Invoke-RagIngestFile -filePath $file.FullName -metadata $metadata) {
        $ingestedCount++
        Write-Host "[$ingestedCount] Ingested: $($file.Name)"
    } else {
        $failedFiles += $file.Name
    }
    
    Start-Sleep -Milliseconds 100
}

Write-Host "`n=== PHASE 3: Completed Decisions (DECISION_053) ==="
$completedFiles = Get-ChildItem -Path $DECISIONS_COMPLETED_DIR -Filter "*.md" | Sort-Object Name
Write-Host "Found $($completedFiles.Count) completed decision files"

foreach ($file in $completedFiles) {
    $metadata = @{
        source = "decision"
        filename = $file.Name
        status = "completed"
        category = "decision-document"
    }
    
    if (Invoke-RagIngestFile -filePath $file.FullName -metadata $metadata) {
        $ingestedCount++
        Write-Host "[$ingestedCount] Ingested: $($file.Name)"
    } else {
        $failedFiles += $file.Name
    }
    
    Start-Sleep -Milliseconds 100
}

Write-Host "`n=== INGESTION COMPLETE ==="
Write-Host "Total ingested: $ingestedCount"
Write-Host "Failed: $($failedFiles.Count)"
if ($failedFiles.Count -gt 0) {
    Write-Host "Failed files:"
    $failedFiles | ForEach-Object { Write-Host "  - $_" }
}

# Get final status
$statusBody = @{
    jsonrpc = "2.0"
    id = "status"
    method = "tools/call"
    params = @{
        name = "rag_status"
        arguments = @{}
    }
} | ConvertTo-Json -Compress

try {
    $status = Invoke-RestMethod -Uri $RAG_SERVER -Method POST -ContentType "application/json" -Body $statusBody
    Write-Host "`nFinal RAG Status:"
    $status.result.content[0].text | ConvertFrom-Json | Format-List
} catch {
    Write-Host "Could not retrieve final status"
}

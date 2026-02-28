$ErrorActionPreference = "Stop"

$content = Get-Content "C:\P4NTHE0N\STR4TEG15T\decisions\active\DECISION_061.md" -Raw -ErrorAction Stop

$jsonBody = @{
    jsonrpc = "2.0"
    id = "ingest-061-manual"
    method = "tools/call"
    params = @{
        name = "rag_ingest"
        arguments = @{
            content = $content
            source = "decisions/active/DECISION_061"
            metadata = @{
                agent = "strategist"
                docType = "decision"
                decisionId = "DECISION_061"
            }
        }
    }
} | ConvertTo-Json -Depth 5 -Compress

$response = Invoke-RestMethod -Uri "http://localhost:5001/mcp" -Method Post -ContentType "application/json" -Body $jsonBody -TimeoutSec 30 -ErrorAction Stop

Write-Host "Ingest result:" -ForegroundColor Cyan
$response | ConvertTo-Json -Depth 5 | Write-Host

# Verify
$queryBody = @{
    jsonrpc = "2.0"
    id = "verify-061"
    method = "tools/call"
    params = @{
        name = "rag_query"
        arguments = @{
            query = "DECISION_061 agent prompt RAG watcher"
            topK = 5
        }
    }
} | ConvertTo-Json -Compress

$queryResult = Invoke-RestMethod -Uri "http://localhost:5001/mcp" -Method Post -ContentType "application/json" -Body $queryBody -TimeoutSec 30 -ErrorAction Stop

Write-Host "`nQuery result:" -ForegroundColor Cyan
$parsed = $queryResult.result.content[0].text | ConvertFrom-Json
$parsed.results | Format-List source, score

Write-Host "`nVector count:" -ForegroundColor Cyan
$queryResult.result.content[0].text | ConvertFrom-Json | Select-Object -ExpandProperty totalResults

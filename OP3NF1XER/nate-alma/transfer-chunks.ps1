#!/usr/bin/env pwsh
# Transfer chunks to Railway via base64 encoding

$chunkDir = "/tmp"
$remoteDir = "/data/workspace/.transfer-chunks"
$chunks = Get-ChildItem -Path "$chunkDir/dev-chunk-*" | Sort-Object Name

$total = $chunks.Count
$current = 0

foreach ($chunk in $chunks) {
    $current++
    $chunkName = $chunk.Name
    Write-Host "[$current/$total] Transferring $chunkName..."
    
    # Read and encode chunk
    $bytes = [System.IO.File]::ReadAllBytes($chunk.FullName)
    $base64 = [Convert]::ToBase64String($bytes)
    
    # Transfer via Railway SSH
    $remotePath = "$remoteDir/$chunkName"
    $cmd = "echo '$base64' | base64 -d > '$remotePath'"
    
    $result = railway ssh $cmd 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to transfer $chunkName`: $result"
    }
}

Write-Host "All chunks transferred. Reassembling on remote..."
railway ssh "cd $remoteDir && cat dev-chunk-* > /data/workspace/dev-archive.tar.gz && cd /data/workspace && tar -xzf dev-archive.tar.gz && rm dev-archive.tar.gz && rm -rf .transfer-chunks && echo 'Transfer complete!'"

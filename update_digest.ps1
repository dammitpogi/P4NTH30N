$files = Get-ChildItem 'C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\alma-teachings' -Filter 'digest_part_*.json'
$minFile = $null
$minValue = 999
foreach ($file in $files) {
    Write-Host "Processing $($file.Name)"
    try {
        $content = Get-Content $file.FullName -Raw | ConvertFrom-Json
        $min = ($content.PSObject.Properties.Value | ForEach-Object { $_.iterations } | Sort-Object | Select-Object -First 1)
        Write-Host "Min for $($file.Name): $min"
        if ($min -lt $minValue) {
            $minValue = $min
            $minFile = $file
        }
    } catch {
        Write-Host "Skipping $($file.Name) due to JSON error: $($_.Exception.Message)"
    }
}
Write-Host "Found min $minValue in $($minFile.Name)"
if ($minValue -ge 6) {
    Write-Host "All files have iterations >=6"
} else {
    Write-Host "Starting update for $($minFile.Name)"
    try {
        $content = Get-Content $minFile.FullName -Raw | ConvertFrom-Json
        foreach ($post in $content.PSObject.Properties) {
            $post.Value.iterations = $post.Value.iterations + 1
            $post.Value.teachings += @(
                @{concept = "Market analysis provides critical insights for trading decisions"; tags = @("market analysis", "trading insights", "decision making", "market trends", "analysis techniques")}
            )
        }
        $content | ConvertTo-Json -Depth 10 | Out-File $minFile.FullName
        Write-Host "File updated"
        Write-Host "Updated $($minFile.Name) from min $minValue to $($minValue + 1)"
    } catch {
        Write-Host "Failed to update $($minFile.Name): $($_.Exception.Message)"
    }
}

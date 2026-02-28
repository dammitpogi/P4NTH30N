# Generate doc records from substack corpus
$ErrorActionPreference = "Stop"

$corpusRoot = "C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\alma-teachings\substack"
$outputFile = "C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\alma-teachings\bible\corpus\substack\docs.jsonl"

$files = Get-ChildItem -Path $corpusRoot -Filter "*.md"

$output = @()
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }
    
    $sha256 = (Get-FileHash -Algorithm SHA256 -InputStream ([System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($content)))).Hash.ToLower()
    $relativePath = "substack/$($file.Name)"
    $docKey = "substack:$relativePath"
    
    # Extract date from filename (YYYY-MM-DD-...)
    $dateMatch = [regex]::Match($file.BaseName, "^(\d{4}-\d{2}-\d{2})")
    $date = if ($dateMatch.Success) { $dateMatch.Groups[1].Value } else { "unknown" }
    
    # Extract title from filename (remove date prefix)
    $title = $file.BaseName -replace "^\d{4}-\d{2}-\d{2}-", ""
    $title = $title -replace "-", " "
    
    $record = @{
        schemaVersion = "1.0.0"
        docId = "sha256:$sha256"
        docKey = $docKey
        file = $file.Name
        relativePath = $relativePath
        title = $title
        date = $date
        status = "active"
        topTerms = @()
        headings = @()
    }
    
    $json = $record | ConvertTo-Json -Compress
    $output += $json
}

# Write JSONL
$output | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Generated $($output.Count) doc records"
Write-Host "Output: $outputFile"

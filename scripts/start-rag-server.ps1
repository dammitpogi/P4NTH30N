$exePath = 'C:\ProgramData\P4NTH30N\bin\RAG.McpHost.exe'
$indexPath = 'C:\ProgramData\P4NTH30N\rag\faiss.index'
$modelPath = 'C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx'

if (-not (Test-Path $exePath)) {
  Write-Error "RAG executable not found: $exePath"
  exit 1
}

if (-not (Test-Path $modelPath)) {
  Write-Error "RAG model not found: $modelPath"
  exit 1
}

$args = @(
  '--port', '5001',
  '--transport', 'http',
  '--model', $modelPath,
  '--bridge', 'http://127.0.0.1:5000',
  '--mongo', 'mongodb://localhost:27017',
  '--db', 'P4NTH30N'
)

if (Test-Path $indexPath) {
  $args += @('--index', $indexPath)
}

$process = Start-Process -FilePath $exePath -ArgumentList $args -WindowStyle Hidden -PassThru
Write-Host "RAG Server started with PID: $($process.Id)"

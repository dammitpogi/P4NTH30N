$configPath = 'C:\Program Files\MongoDB\Server\8.0\mongod.cfg'
$content = Get-Content $configPath -Raw

$replicationConfig = @"
# Replica set configuration (required for change streams)
replication:
  replSetName: rs0

"@

$newContent = $content -replace '# Windows service configuration', ($replicationConfig + '# Windows service configuration')
Set-Content -Path $configPath -Value $newContent -Force
Write-Host "MongoDB config updated with replica set settings"

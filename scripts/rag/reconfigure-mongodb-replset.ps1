# Stop MongoDB
net stop MongoDB

# Reconfigure service to use config file with replica set
$configPath = "C:\ProgramData\P4NTH30N\mongodb\mongod.cfg"

# Create config directory
New-Item -ItemType Directory -Path "C:\ProgramData\P4NTH30N\mongodb" -Force | Out-Null

# Create config file with replica set
$config = @"
storage:
  dbPath: C:\MongoData

systemLog:
  destination: file
  logAppend: true
  path: C:\MongoLogs\mongod.log

net:
  port: 27017
  bindIp: 127.0.0.1

replication:
  replSetName: rs0
"@

Set-Content -Path $configPath -Value $config -Force
Write-Host "Created config at $configPath"

# Remove existing service and recreate with config file
& "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe" --remove --serviceName MongoDB

# Create new service with config file
& "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe" --config $configPath --install --serviceName MongoDB

# Start MongoDB
net start MongoDB

Write-Host "MongoDB reconfigured with replica set support"

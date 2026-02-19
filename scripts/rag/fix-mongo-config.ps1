$configPath = 'C:\Program Files\MongoDB\Server\8.0\mongod.cfg'

$correctConfig = @"
# MongoDB Configuration File

# Where and how to store data.
storage:
  dbPath: C:\Program Files\MongoDB\Server\8.0\data

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: C:\Program Files\MongoDB\Server\8.0\log\mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1

# Replica set configuration (required for change streams)
replication:
  replSetName: rs0

# Windows service configuration
processManagement:
  windowsService:
    serviceName: MongoDB
    displayName: MongoDB Server (MongoDB)
    description: MongoDB database server
"@

Set-Content -Path $configPath -Value $correctConfig -Force
Write-Host "MongoDB config fixed"

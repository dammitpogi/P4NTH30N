#!/usr/bin/env pwsh
#requires -Version 5.1

param(
    [string]$MongoDbVersion = "7.0",
    [string]$DataPath = "C:\data\db",
    [string]$LogPath = "C:\data\log",
    [switch]$StartService,
    [switch]$InstallService
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param($Message, $Type = "INFO")
    $symbol = switch ($Type) {
        "SUCCESS" { "✓"; $color = "Green" }
        "ERROR" { "✗"; $color = "Red" }
        "WARN" { "!"; $color = "Yellow" }
        default { "ℹ"; $color = "Cyan" }
    }
    Write-Host "[$symbol] $Message" -ForegroundColor $color
}

function Test-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-MongoDB {
    Write-Status "Installing MongoDB Community Server..."
    
    $downloadUrl = "https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-$MongoDbVersion-signed.msi"
    $installerPath = "$env:TEMP\mongodb-installer.msi"
    
    try {
        Write-Status "Downloading MongoDB $MongoDbVersion..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
        
        Write-Status "Running installer..."
        $args = @(
            "/i", $installerPath,
            "/qn",
            "INSTALLLOCATION=C:\Program Files\MongoDB\Server\$MongoDbVersion",
            "ADDLOCAL=All"
        )
        Start-Process -FilePath "msiexec.exe" -ArgumentList $args -Wait
        
        Write-Status "MongoDB installed successfully" "SUCCESS"
        Remove-Item $installerPath -ErrorAction SilentlyContinue
        return $true
    }
    catch {
        Write-Status "Installation failed: $_" "ERROR"
        return $false
    }
}

function Initialize-Directories {
    Write-Status "Initializing data directories..."
    
    $directories = @($DataPath, $LogPath)
    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Status "Created: $dir"
        }
    }
    
    Write-Status "Data directories ready" "SUCCESS"
}

function Start-MongoDB {
    Write-Status "Starting MongoDB..."
    
    $mongoPath = "C:\Program Files\MongoDB\Server\$MongoDbVersion\bin\mongod.exe"
    if (-not (Test-Path $mongoPath)) {
        Write-Status "MongoDB binary not found at $mongoPath" "ERROR"
        return $false
    }
    
    $config = @"
storage:
  dbPath: $DataPath
systemLog:
  destination: file
  path: $LogPath\mongod.log
  logAppend: true
net:
  bindIp: 127.0.0.1
  port: 27017
"@
    
    $configPath = "$env:TEMP\mongod.cfg"
    $config | Out-File -FilePath $configPath -Encoding UTF8
    
    try {
        Start-Process -FilePath $mongoPath -ArgumentList "--config", $configPath -WindowStyle Hidden
        Start-Sleep -Seconds 3
        
        # Test connection
        try {
            $test = mongosh --eval "db.version()" --quiet 2>$null
            Write-Status "MongoDB started successfully (version: $test)" "SUCCESS"
            return $true
        }
        catch {
            Write-Status "MongoDB process started but connection failed" "WARN"
            return $true
        }
    }
    catch {
        Write-Status "Failed to start MongoDB: $_" "ERROR"
        return $false
    }
}

function Install-MongoDBService {
    Write-Status "Installing MongoDB as Windows Service..."
    
    $mongoPath = "C:\Program Files\MongoDB\Server\$MongoDbVersion\bin\mongod.exe"
    $serviceName = "MongoDB"
    
    try {
        $existing = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Status "MongoDB service already exists" "WARN"
            return $true
        }
        
        & $mongoPath --install --serviceName $serviceName --dbpath $DataPath --logpath "$LogPath\mongod.log"
        Start-Service -Name $serviceName
        
        Write-Status "MongoDB service installed and started" "SUCCESS"
        return $true
    }
    catch {
        Write-Status "Service installation failed: $_" "ERROR"
        return $false
    }
}

function Initialize-P4NTHE0NDatabase {
    Write-Status "Initializing P4NTHE0N database..."
    
    try {
        $initScript = @"
use P4NTHE0N;

// Create collections if they don't exist
db.createCollection('CRED3N7IAL');
db.createCollection('G4ME');
db.createCollection('SIGN4L');
db.createCollection('J4CKP0T');
db.createCollection('N3XT');
db.createCollection('M47URITY');
db.createCollection('EV3NT');
db.createCollection('ERR0R');
db.createCollection('H0U53');
db.createCollection('R34DM3');

print('P4NTHE0N database initialized successfully');
"@
        
        $tempFile = "$env:TEMP\init-p4nth30n.js"
        $initScript | Out-File -FilePath $tempFile -Encoding UTF8
        
        mongosh --file $tempFile --quiet
        Remove-Item $tempFile
        
        Write-Status "Database initialized" "SUCCESS"
        return $true
    }
    catch {
        Write-Status "Database initialization failed: $_" "ERROR"
        return $false
    }
}

# Main execution
Write-Host "`nMongoDB Setup for P4NTHE0N" -ForegroundColor Cyan
Write-Host "===========================`n" -ForegroundColor Cyan

if (-not (Test-Admin)) {
    Write-Status "Administrator privileges required" "ERROR"
    exit 1
}

# Check if MongoDB is already installed
$mongoInstalled = Get-Command mongod -ErrorAction SilentlyContinue
if (-not $mongoInstalled) {
    Write-Status "MongoDB not found. Installing..."
    if (-not (Install-MongoDB)) {
        exit 1
    }
}
else {
    Write-Status "MongoDB already installed" "SUCCESS"
}

# Initialize directories
Initialize-Directories

# Start or install service
if ($InstallService) {
    Install-MongoDBService
}
elseif ($StartService) {
    Start-MongoDB
}

# Initialize database
Initialize-P4NTHE0NDatabase

Write-Host "`n===========================" -ForegroundColor Cyan
Write-Status "MongoDB setup complete!" "SUCCESS"

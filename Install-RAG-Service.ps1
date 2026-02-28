# RAG MCP Host Windows Service Installer
# Installs RAG.McpHost.exe as a proper Windows service

param(
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$Start,
    [switch]$Stop,
    [switch]$Status,
    [string]$ServiceName = "P4NTHE0N-RAG-MCP-Host"
)

$serviceName = $ServiceName
$displayName = "P4NTHE0N RAG MCP Host Service"
$description = "P4NTHE0N RAG (Retrieval-Augmented Generation) MCP Host service for AI assistance"
$binaryPath = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
$arguments = @("--port", "5100", "--index", "p4ntheon", "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx", "--mongo", "localhost:27017", "--workspace", "C:\P4NTH30N", "--service")

Write-Host "=== P4NTHE0N RAG MCP Host Service Manager ===" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠ This script requires Administrator privileges" -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator" -ForegroundColor Gray
    exit 1
}

# Check binary exists
if (-not (Test-Path $binaryPath)) {
    Write-Host "✗ RAG.McpHost.exe not found at: $binaryPath" -ForegroundColor Red
    Write-Host "Please build the project first:" -ForegroundColor Yellow
    Write-Host "dotnet publish `"c:\P4NTH30N\src\RAG.McpHost\RAG.McpHost.csproj`" -c Release -r win-x64 --self-contained" -ForegroundColor Gray
    exit 1
}

if ($Install) {
    Write-Host "Installing Windows service..." -ForegroundColor Yellow
    
    # Check if service already exists
    $existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($existingService) {
        Write-Host "⚠ Service already exists. Uninstall first or use -Force." -ForegroundColor Yellow
        exit 1
    }
    
    try {
        # Create the service
        New-Service -Name $serviceName -DisplayName $displayName -BinaryPathName "`"$binaryPath`" $($arguments -join ' ')" -Description $description -StartupType Automatic
        
        Write-Host "✓ Service installed successfully" -ForegroundColor Green
        Write-Host "  Service Name: $serviceName" -ForegroundColor Gray
        Write-Host "  Display Name: $displayName" -ForegroundColor Gray
        Write-Host "  Binary: $binaryPath" -ForegroundColor Gray
        
        # Set service to run as Network Service (recommended for background services)
        $service = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"
        $service.Change($null, $null, $null, $null, $null, $null, "NT AUTHORITY\NetworkService", "") | Out-Null
        
        Write-Host "✓ Service configured to run as Network Service" -ForegroundColor Green
        
        # Start the service
        Write-Host "`nStarting service..." -ForegroundColor Yellow
        Start-Service -Name $serviceName
        Write-Host "✓ Service started" -ForegroundColor Green
        
        # Check service status
        Start-Sleep -Seconds 2
        $serviceStatus = Get-Service -Name $serviceName
        Write-Host "  Status: $($serviceStatus.Status)" -ForegroundColor Gray
        Write-Host "  StartType: $($serviceStatus.StartType)" -ForegroundColor Gray
        
    } catch {
        Write-Host "✗ Failed to install service: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

elseif ($Uninstall) {
    Write-Host "Uninstalling Windows service..." -ForegroundColor Yellow
    
    try {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if (-not $service) {
            Write-Host "⚠ Service not found" -ForegroundColor Yellow
            exit 0
        }
        
        # Stop service if running
        if ($service.Status -eq "Running") {
            Write-Host "Stopping service..." -ForegroundColor Yellow
            Stop-Service -Name $serviceName -Force
            Write-Host "✓ Service stopped" -ForegroundColor Green
        }
        
        # Remove service
        Write-Host "Removing service..." -ForegroundColor Yellow
        Remove-Service -Name $serviceName -Confirm:$false
        Write-Host "✓ Service uninstalled successfully" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Failed to uninstall service: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

elseif ($Start) {
    Write-Host "Starting Windows service..." -ForegroundColor Yellow
    
    try {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if (-not $service) {
            Write-Host "✗ Service not found" -ForegroundColor Red
            exit 1
        }
        
        if ($service.Status -eq "Running") {
            Write-Host "✓ Service already running" -ForegroundColor Green
        } else {
            Start-Service -Name $serviceName
            Write-Host "✓ Service started" -ForegroundColor Green
        }
        
        # Verify health endpoint
        Start-Sleep -Seconds 3
        try {
            $health = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 5
            Write-Host "✓ Service health check passed: $($health.status)" -ForegroundColor Green
        } catch {
            Write-Host "⚠ Service started but health check failed" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "✗ Failed to start service: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

elseif ($Stop) {
    Write-Host "Stopping Windows service..." -ForegroundColor Yellow
    
    try {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if (-not $service) {
            Write-Host "✗ Service not found" -ForegroundColor Red
            exit 1
        }
        
        if ($service.Status -ne "Running") {
            Write-Host "✓ Service already stopped" -ForegroundColor Green
        } else {
            Stop-Service -Name $serviceName -Force
            Write-Host "✓ Service stopped" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "✗ Failed to stop service: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

elseif ($Status) {
    Write-Host "Checking service status..." -ForegroundColor Yellow
    
    try {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($service) {
            Write-Host "✓ Service found" -ForegroundColor Green
            Write-Host "  Name: $($service.Name)" -ForegroundColor Gray
            Write-Host "  Display Name: $($service.DisplayName)" -ForegroundColor Gray
            Write-Host "  Status: $($service.Status)" -ForegroundColor Gray
            Write-Host "  StartType: $($service.StartType)" -ForegroundColor Gray
            
            # Check health endpoint if running
            if ($service.Status -eq "Running") {
                try {
                    $health = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
                    Write-Host "  Health: $($health.status) (Port $($health.port))" -ForegroundColor Gray
                } catch {
                    Write-Host "  Health: Check failed" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "✗ Service not found" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "✗ Failed to get service status: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

else {
    Write-Host "Usage:" -ForegroundColor White
    Write-Host "  Install:   .\Install-RAG-Service.ps1 -Install" -ForegroundColor Gray
    Write-Host "  Uninstall: .\Install-RAG-Service.ps1 -Uninstall" -ForegroundColor Gray
    Write-Host "  Start:     .\Install-RAG-Service.ps1 -Start" -ForegroundColor Gray
    Write-Host "  Stop:      .\Install-RAG-Service.ps1 -Stop" -ForegroundColor Gray
    Write-Host "  Status:    .\Install-RAG-Service.ps1 -Status" -ForegroundColor Gray
    Write-Host "`nNote: Requires Administrator privileges" -ForegroundColor Yellow
}

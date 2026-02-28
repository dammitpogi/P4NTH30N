# RAG MCP Host Background Task Manager
# Runs RAG.McpHost.exe as a background PowerShell job

param(
    [switch]$Start,
    [switch]$Stop,
    [switch]$Status,
    [switch]$Restart,
    [string]$JobName = "P4NTHE0N-RAG-MCP-Host"
)

$ragBinary = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
$ragArgs = @("--port", "5100", "--index", "p4ntheon", "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx", "--mongo", "localhost:27017", "--workspace", "C:\P4NTH30N", "--transport", "http")

Write-Host "=== P4NTHE0N RAG MCP Host Background Manager ===" -ForegroundColor Cyan

if ($Start) {
    Write-Host "Starting RAG MCP Host as background job..." -ForegroundColor Yellow
    
    try {
        $job = Start-Job -Name $JobName -ScriptBlock {
            param($BinaryPath, $Arguments)
            $env:RAG_PORT = "5100"
            $env:RAG_INDEX = "p4ntheon"
            $env:RAG_MONGO = "localhost:27017"
            $env:RAG_WORKSPACE = "C:\P4NTH30N"
            & $BinaryPath $Arguments
        } -ArgumentList $ragBinary, $ragArgs
        
        Write-Host " Background job started" -ForegroundColor Green
        Write-Host "  Job Name: $JobName" -ForegroundColor Gray
        Write-Host "  Job ID: $($job.Id)" -ForegroundColor Gray
        
        Start-Sleep -Seconds 3
        try {
            $health = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 5
            Write-Host " Service health check passed: $($health.status)" -ForegroundColor Green
        } catch {
            Write-Host " Service started but health check failed" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host " Failed to start background job: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

elseif ($Stop) {
    Write-Host "Stopping RAG MCP Host background job..." -ForegroundColor Yellow
    
    try {
        $job = Get-Job -Name $JobName -ErrorAction SilentlyContinue
        if ($job) {
            Stop-Job -Name $JobName
            Remove-Job -Name $JobName -Force
            Write-Host " Background job stopped and removed" -ForegroundColor Green
        }
        
        $process = Get-Process -Name "RAG.McpHost" -ErrorAction SilentlyContinue
        if ($process) {
            Stop-Process -Name "RAG.McpHost" -Force -ErrorAction SilentlyContinue
            Write-Host " Process stopped" -ForegroundColor Green
        }
        
    } catch {
        Write-Host " Failed to stop background job: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

elseif ($Status) {
    Write-Host "Checking RAG MCP Host background job status..." -ForegroundColor Yellow
    
    try {
        $job = Get-Job -Name $JobName -ErrorAction SilentlyContinue
        if ($job) {
            Write-Host " Background job found" -ForegroundColor Green
            Write-Host "  Job Name: $($job.Name)" -ForegroundColor Gray
            Write-Host "  State: $($job.State)" -ForegroundColor Gray
            
            if ($job.State -eq "Running") {
                try {
                    $health = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
                    Write-Host "  Health: $($health.status) (Port $($health.port))" -ForegroundColor Gray
                } catch {
                    Write-Host "  Health: Check failed" -ForegroundColor Red
                }
            }
        } else {
            Write-Host " Background job not found" -ForegroundColor Red
        }
    } catch {
        Write-Host " Failed to get job status: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

else {
    Write-Host "Usage:" -ForegroundColor White
    Write-Host "  Start:   .\Manage-RAG-Background.ps1 -Start" -ForegroundColor Gray
    Write-Host "  Stop:    .\Manage-RAG-Background.ps1 -Stop" -ForegroundColor Gray
    Write-Host "  Status:  .\Manage-RAG-Background.ps1 -Status" -ForegroundColor Gray
}

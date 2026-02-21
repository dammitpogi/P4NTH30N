# Start-CdpMcpServer.ps1
# Starts the P4NTH30N CDP MCP Server in HTTP mode for programmatic consumers.
# Default: http://127.0.0.1:5301/mcp targeting Chrome at 192.168.56.1:9222
#
# Usage:
#   .\Start-CdpMcpServer.ps1                    # Default port 5301
#   .\Start-CdpMcpServer.ps1 -Port 5302         # Custom port
#   .\Start-CdpMcpServer.ps1 -Background        # Run as background job

param(
	[int]$Port = 5301,
	[switch]$Background
)

$ServerDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ServerJs = Join-Path $ServerDir "server.js"

if (-not (Test-Path $ServerJs)) {
	Write-Error "server.js not found at $ServerJs"
	exit 1
}

# Check if port is already in use
$existing = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
if ($existing) {
	Write-Host "[CDP MCP] Port $Port already in use (PID: $($existing[0].OwningProcess))" -ForegroundColor Yellow
	exit 0
}

$env:MCP_PORT = $Port
$env:MCP_TRANSPORT = "http"

if ($Background) {
	$job = Start-Process -FilePath "node" -ArgumentList "$ServerJs http" -WorkingDirectory $ServerDir -PassThru -WindowStyle Hidden
	Write-Host "[CDP MCP] Started in background (PID: $($job.Id)) on http://127.0.0.1:${Port}/mcp" -ForegroundColor Green
} else {
	Write-Host "[CDP MCP] Starting on http://127.0.0.1:${Port}/mcp ..." -ForegroundColor Cyan
	node $ServerJs http
}

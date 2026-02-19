# WIND-008: On-error hook for WindSurf Cascade
# Runs when Cascade encounters an error during execution
# Input: JSON via stdin with { error: string, context: string, tool: string }

param()

$ErrorActionPreference = "Continue"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logDir = Join-Path $PSScriptRoot "../../.logs"

if (-not (Test-Path $logDir)) {
	New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$logFile = Join-Path $logDir "cascade-errors.log"

try {
	if ([Console]::IsInputRedirected) {
		$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json
		$errorMsg = $input_json.error
		$context = $input_json.context
		$tool = $input_json.tool

		$logEntry = "[$timestamp] Tool: $tool | Error: $errorMsg | Context: $context"
		Add-Content -Path $logFile -Value $logEntry
		Write-Host "[on-error] Logged error to $logFile"
	}
}
catch {
	$logEntry = "[$timestamp] Hook error: $_"
	Add-Content -Path $logFile -Value $logEntry
	Write-Host "[on-error] Error in hook: $_"
}

Write-Host "[on-error] Error handling complete"
exit 0

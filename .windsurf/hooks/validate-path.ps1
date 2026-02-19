# WIND-008: Path validation hook for WindSurf Cascade
# Validates file paths before read/write operations
# Input: JSON via stdin with { path: string, action: string }

param()

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path

try {
	if ([Console]::IsInputRedirected) {
		$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json
		$targetPath = $input_json.path

		# Resolve to absolute path
		$resolvedPath = [System.IO.Path]::GetFullPath($targetPath)

		# Security: Ensure path is within the repo root
		if (-not $resolvedPath.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
			Write-Host "[validate-path] BLOCKED: Path '$resolvedPath' is outside repository root"
			exit 1
		}

		# Block access to sensitive directories
		$blockedPatterns = @(".git/objects", ".git/refs", "Releases/", "bin/", "obj/", "drivers/")
		foreach ($pattern in $blockedPatterns) {
			$blockPath = Join-Path $repoRoot $pattern
			if ($resolvedPath.StartsWith($blockPath, [System.StringComparison]::OrdinalIgnoreCase)) {
				Write-Host "[validate-path] BLOCKED: Access to '$pattern' is restricted"
				exit 1
			}
		}

		Write-Host "[validate-path] Path validated: $resolvedPath"
	}
}
catch {
	Write-Host "[validate-path] Validation error: $_"
	exit 1
}

exit 0

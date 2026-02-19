# WIND-008: Security check hook for WindSurf Cascade
# Scans for potential security issues in modified files
# Input: JSON via stdin with { files: string[] }

param()

$ErrorActionPreference = "Continue"

$sensitivePatterns = @(
	"password\s*=\s*[""'][^""']+[""']",
	"apikey\s*=\s*[""'][^""']+[""']",
	"secret\s*=\s*[""'][^""']+[""']",
	"connectionstring\s*=\s*[""'][^""']+[""']",
	"bearer\s+[a-zA-Z0-9\-._~+/]+=*"
)

$violations = @()

try {
	$files = @()
	if ([Console]::IsInputRedirected) {
		$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json
		$files = $input_json.files
	}

	if ($files.Count -eq 0) {
		# Scan recently modified files
		$files = Get-ChildItem -Recurse -Include "*.cs","*.json","*.config" -ErrorAction SilentlyContinue |
			Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-5) } |
			Select-Object -ExpandProperty FullName -First 20
	}

	foreach ($file in $files) {
		if (-not (Test-Path $file)) { continue }
		$content = Get-Content $file -Raw -ErrorAction SilentlyContinue
		if (-not $content) { continue }

		foreach ($pattern in $sensitivePatterns) {
			if ($content -match $pattern) {
				$violations += "[security-check] WARNING: Potential secret in $file (pattern: $pattern)"
			}
		}
	}

	if ($violations.Count -gt 0) {
		Write-Host "[security-check] Found $($violations.Count) potential security issues:"
		$violations | ForEach-Object { Write-Host "  $_" }
	} else {
		Write-Host "[security-check] No security issues detected"
	}
}
catch {
	Write-Host "[security-check] Error during scan: $_"
}

exit 0

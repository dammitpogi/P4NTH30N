# WIND-008: Pre-commit hook for WindSurf Cascade
# Runs before git commits to validate code quality
# Input: JSON via stdin with { files: string[], message: string }

param()

$ErrorActionPreference = "Stop"
$input_json = $null

try {
	if (-not [Console]::IsInputRedirected) {
		Write-Host "[pre-commit] No stdin input, running standalone"
	} else {
		$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json
	}
}
catch {
	Write-Host "[pre-commit] Failed to parse stdin: $_"
}

# Step 1: Check formatting with CSharpier
Write-Host "[pre-commit] Checking CSharpier formatting..."
$formatResult = & dotnet csharpier check 2>&1
if ($LASTEXITCODE -ne 0) {
	Write-Host "[pre-commit] WARNING: Code formatting issues detected"
	Write-Host $formatResult
}

# Step 2: Verify build compiles
Write-Host "[pre-commit] Verifying build..."
$buildResult = & dotnet build P4NTH30N.slnx --no-restore --verbosity quiet 2>&1
if ($LASTEXITCODE -ne 0) {
	Write-Host "[pre-commit] ERROR: Build failed"
	Write-Host $buildResult
	exit 1
}

Write-Host "[pre-commit] All checks passed"
exit 0

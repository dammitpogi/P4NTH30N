# WIND-008: Post-write hook for WindSurf Cascade
# Runs after Cascade writes/edits files
# Input: JSON via stdin with { files: string[], action: string }

param()

$ErrorActionPreference = "Continue"

try {
	if ([Console]::IsInputRedirected) {
		$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json
		$files = $input_json.files
		Write-Host "[post-write] Files modified: $($files.Count)"
	}
}
catch {
	Write-Host "[post-write] No stdin context"
}

# Check if any .cs files were modified
$csFiles = Get-ChildItem -Recurse -Filter "*.cs" -ErrorAction SilentlyContinue |
	Where-Object { $_.LastWriteTime -gt (Get-Date).AddSeconds(-5) } |
	Select-Object -First 10

if ($csFiles.Count -gt 0) {
	Write-Host "[post-write] Recently modified C# files: $($csFiles.Count)"
	foreach ($f in $csFiles) {
		Write-Host "  - $($f.FullName)"
	}
}

Write-Host "[post-write] Hook completed"
exit 0

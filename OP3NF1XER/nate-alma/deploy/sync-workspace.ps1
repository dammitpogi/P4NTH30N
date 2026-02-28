# sync-workspace.ps1
# Syncs the dev/ workspace into deploy/workspace/ for Docker baking.
# Excludes local-only tooling (substack-scraper browser profiles, node_modules, etc.)
#
# Usage:
#   cd C:\P4NTH30N\OP3NF1XER\nate-alma\deploy
#   pwsh -File sync-workspace.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DevDir = Join-Path (Split-Path -Parent $ScriptDir) "dev"
$WorkspaceDir = Join-Path $ScriptDir "workspace"

Write-Host "=== ALMA Workspace Sync ===" -ForegroundColor Cyan
Write-Host "Source: $DevDir"
Write-Host "Target: $WorkspaceDir"

# Clean target
if (Test-Path $WorkspaceDir) {
    Write-Host "Cleaning existing workspace..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $WorkspaceDir
}

# Create target
New-Item -ItemType Directory -Force -Path $WorkspaceDir | Out-Null

# Excluded patterns (local-only tooling, not needed in deployed workspace)
$ExcludeDirs = @(
    "tools\substack-scraper\otp-handoff-profile",
    "tools\substack-scraper\manual-login-profile",
    "tools\substack-scraper\tmp-profile-A",
    "tools\substack-scraper\tmp-profile-B",
    "tools\substack-scraper\node_modules",
    "memory\p4nthe0n-openfixer",      # Historical OpenFixer journals (not agent content)
    "memory\alma-teachings\legacy",    # Legacy backups
    "__pycache__",
    ".secrets"
)

$ExcludeExts = @(".png", ".jpg", ".jpeg", ".exe", ".zip", ".tar", ".gz")

# Robocopy-based sync with exclusions
$ExcludeDirArgs = $ExcludeDirs | ForEach-Object { "/XD", (Join-Path $DevDir $_) }
$ExcludeExtArgs = $ExcludeExts | ForEach-Object { "/XF", ("*" + $_) }

$robocopyArgs = @(
    $DevDir,
    $WorkspaceDir,
    "/E",           # Copy subdirectories including empty ones
    "/NFL",         # No file listing
    "/NDL",         # No directory listing
    "/NJH",         # No job header
    "/NJS"          # No job summary
) + $ExcludeDirArgs + $ExcludeExtArgs

Write-Host "Syncing workspace..." -ForegroundColor Green
& robocopy @robocopyArgs

# Robocopy exit codes < 8 are success
if ($LASTEXITCODE -lt 8) {
    $LASTEXITCODE = 0
}

# Report size
$size = (Get-ChildItem -Recurse -File $WorkspaceDir | Measure-Object -Property Length -Sum).Sum
$sizeMB = [math]::Round($size / 1MB, 2)
$fileCount = (Get-ChildItem -Recurse -File $WorkspaceDir).Count

Write-Host ""
Write-Host "=== Sync Complete ===" -ForegroundColor Cyan
Write-Host "Files: $fileCount"
Write-Host "Size:  $sizeMB MB"
Write-Host "Target: $WorkspaceDir"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review workspace/ contents"
Write-Host "  2. git add workspace/ && git commit"
Write-Host "  3. git push → Railway auto-deploys"

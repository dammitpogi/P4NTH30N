<#
.SYNOPSIS
    Syncs agent definitions from P4NTH30N/agents/ to OpenCode agents directory.

.DESCRIPTION
    Compares file hashes between source (P4NTH30N/agents/) and target
    (OpenCode/agents/), backs up existing files, copies changed files,
    and updates the version tracking manifest.

.PARAMETER SourceDir
    Source directory containing agent definitions. Default: C:\P4NTH30N\agents

.PARAMETER TargetDir
    Target OpenCode agents directory. Default: C:\Users\paulc\.config\opencode\agents

.PARAMETER WhatIf
    Preview changes without applying them.

.PARAMETER Force
    Skip confirmation prompt.

.EXAMPLE
    .\deploy-agents.ps1
    .\deploy-agents.ps1 -WhatIf
    .\deploy-agents.ps1 -Force
#>

param(
    [string]$SourceDir = "C:\P4NTH30N\agents",
    [string]$TargetDir = "C:\Users\paulc\.config\opencode\agents",
    [switch]$WhatIf,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$VersionFile = "C:\P4NTH30N\scripts\agent-versions.json"
$BackupDir = Join-Path $TargetDir ".backups"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Ensure backup directory exists
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

# Load or initialize version tracking
if (Test-Path $VersionFile) {
    $versions = Get-Content $VersionFile -Raw | ConvertFrom-Json
} else {
    $versions = [PSCustomObject]@{
        lastDeployment = $null
        deploymentCount = 0
        agents = @{}
        history = @()
    }
}

# Collect changes
$changes = @()
$sourceFiles = Get-ChildItem -Path $SourceDir -Filter "*.md" -File

foreach ($file in $sourceFiles) {
    $targetPath = Join-Path $TargetDir $file.Name
    $sourceHash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash

    $status = "unchanged"
    $targetHash = $null

    if (Test-Path $targetPath) {
        $targetHash = (Get-FileHash -Path $targetPath -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            $status = "modified"
        }
    } else {
        $status = "new"
    }

    $changes += [PSCustomObject]@{
        Name = $file.Name
        Status = $status
        SourceHash = $sourceHash
        TargetHash = $targetHash
        SourcePath = $file.FullName
        TargetPath = $targetPath
    }
}

# Report
$modified = $changes | Where-Object { $_.Status -ne "unchanged" }
$unchanged = $changes | Where-Object { $_.Status -eq "unchanged" }

Write-Host "`n=== Agent Deployment Report ===" -ForegroundColor Cyan
Write-Host "Source:  $SourceDir"
Write-Host "Target:  $TargetDir"
Write-Host "Time:    $Timestamp"
Write-Host ""

if ($modified.Count -eq 0) {
    Write-Host "No changes detected. All agents are in sync." -ForegroundColor Green
    exit 0
}

Write-Host "Changes detected:" -ForegroundColor Yellow
foreach ($change in $modified) {
    $icon = if ($change.Status -eq "new") { "+" } else { "~" }
    $color = if ($change.Status -eq "new") { "Green" } else { "Yellow" }
    Write-Host "  [$icon] $($change.Name) ($($change.Status))" -ForegroundColor $color
}

Write-Host "`nUnchanged: $($unchanged.Count) file(s)" -ForegroundColor DarkGray

if ($WhatIf) {
    Write-Host "`n[WhatIf] No changes applied." -ForegroundColor Magenta
    exit 0
}

# Confirmation
if (-not $Force) {
    $confirm = Read-Host "`nDeploy $($modified.Count) change(s)? (y/N)"
    if ($confirm -ne "y") {
        Write-Host "Deployment cancelled." -ForegroundColor Red
        exit 1
    }
}

# Execute deployment
$deployed = @()
foreach ($change in $modified) {
    # Backup existing file
    if ($change.Status -eq "modified" -and (Test-Path $change.TargetPath)) {
        $backupName = "$($change.Name).$Timestamp.bak"
        $backupPath = Join-Path $BackupDir $backupName
        Copy-Item -Path $change.TargetPath -Destination $backupPath -Force
        Write-Host "  Backed up: $($change.Name) -> $backupName" -ForegroundColor DarkGray
    }

    # Copy file
    Copy-Item -Path $change.SourcePath -Destination $change.TargetPath -Force
    Write-Host "  Deployed:  $($change.Name)" -ForegroundColor Green

    $deployed += [PSCustomObject]@{
        name = $change.Name
        status = $change.Status
        hash = $change.SourceHash
        deployedAt = $Timestamp
    }
}

# Update version tracking
$versions.lastDeployment = $Timestamp
$versions.deploymentCount = [int]$versions.deploymentCount + 1

# Update per-agent versions
$agentsObj = @{}
if ($versions.agents -is [PSCustomObject]) {
    $versions.agents.PSObject.Properties | ForEach-Object { $agentsObj[$_.Name] = $_.Value }
}

foreach ($d in $deployed) {
    $agentsObj[$d.name] = [PSCustomObject]@{
        hash = $d.hash
        lastDeployed = $d.deployedAt
        status = $d.status
    }
}

$versions.agents = [PSCustomObject]$agentsObj

# Add to history
$historyEntry = [PSCustomObject]@{
    timestamp = $Timestamp
    filesDeployed = $deployed.Count
    files = ($deployed | ForEach-Object { $_.name })
}

$historyArray = @()
if ($versions.history -is [System.Array]) {
    $historyArray = @($versions.history)
}
$historyArray += $historyEntry

# Keep last 50 entries
if ($historyArray.Count -gt 50) {
    $historyArray = $historyArray[-50..-1]
}
$versions.history = $historyArray

# Save version file
$versions | ConvertTo-Json -Depth 10 | Set-Content $VersionFile -Encoding UTF8

Write-Host "`n=== Deployment Complete ===" -ForegroundColor Green
Write-Host "  Files deployed: $($deployed.Count)"
Write-Host "  Total deployments: $($versions.deploymentCount)"
Write-Host "  Version file: $VersionFile"

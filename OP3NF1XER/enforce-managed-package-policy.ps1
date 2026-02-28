param(
  [switch]$PruneDuplicates
)

$ErrorActionPreference = 'Stop'

$root = Join-Path $PSScriptRoot 'knowledge'
$timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ss'
$lockPath = Join-Path $root 'managed-package-lock.json'

if (-not (Test-Path $root)) {
  New-Item -ItemType Directory -Path $root -Force | Out-Null
}

$lock = Get-Content -Path $lockPath -Raw | ConvertFrom-Json

$targets = @(
  [PSCustomObject]@{ Name = 'OpenCode'; WingetId = 'SST.OpenCodeDesktop'; PinSupported = $true },
  [PSCustomObject]@{ Name = 'Rancher Desktop'; WingetId = 'SUSE.RancherDesktop'; PinSupported = $true },
  [PSCustomObject]@{ Name = 'LM Studio'; WingetId = 'ElementLabs.LMStudio'; PinSupported = $true },
  [PSCustomObject]@{ Name = 'ToolHive'; WingetId = 'ToolHive'; PinSupported = $false }
)

function Get-InstalledRows {
  param([string]$Id)
  return @(winget list --id $Id --accept-source-agreements 2>$null | Where-Object { $_ -match $Id })
}

function Add-BlockingPin {
  param([string]$Id)
  $output = @(winget pin add --id $Id --exact --installed --blocking --accept-source-agreements --disable-interactivity 2>&1)
  return $output
}

function Get-PinRows {
  return @(winget pin list 2>$null)
}

$results = @()
$pinRows = Get-PinRows

foreach ($target in $targets) {
  $rows = Get-InstalledRows -Id $target.WingetId
  $lockEntry = @($lock.packages | Where-Object { $_.id -eq $target.WingetId })[0]
  $lockedVersion = if ($null -ne $lockEntry) { [string]$lockEntry.lockedVersion } else { '' }
  $versionMatchesLock = $false
  if ($rows.Count -ge 1 -and $lockedVersion -ne '') {
    $rowText = [string]($rows -join ' ')
    $versionMatchesLock = $rowText.Contains($lockedVersion)
  }

  $pinOutput = @()
  $pinStatus = 'skipped'
  $pinEffective = $false

  if ($target.PinSupported -and $rows.Count -ge 1) {
    $pinOutput = Add-BlockingPin -Id $target.WingetId
    $pinStatus = 'attempted'
    $pinRows = Get-PinRows
    $pinEffective = [bool]($pinRows -match [regex]::Escape($target.WingetId))
  }

  $duplicateStatus = if ($rows.Count -gt 1) { 'duplicate' } else { 'single_or_none' }

  $results += [PSCustomObject]@{
    name = $target.Name
    id = $target.WingetId
    installedCount = $rows.Count
    duplicateStatus = $duplicateStatus
    pinStatus = $pinStatus
    pinEffective = $pinEffective
    pinOutput = $pinOutput
    lockVersion = $lockedVersion
    versionMatchesLock = $versionMatchesLock
    installedRows = $rows
  }
}

$report = [PSCustomObject]@{
  generatedAt = (Get-Date).ToString('o')
  pruneRequested = [bool]$PruneDuplicates
  results = $results
}

$jsonPath = Join-Path $root "managed-package-policy-$timestamp.json"
$report | ConvertTo-Json -Depth 8 | Set-Content -Path $jsonPath

if ($PruneDuplicates) {
  foreach ($entry in $results) {
    if ($entry.duplicateStatus -eq 'duplicate') {
      Write-Host "[policy] duplicate found for $($entry.id); manual uninstall sequencing required"
    }
  }
}

Write-Host "[policy] report exported: $jsonPath"

param(
  [switch]$PersistUserPath,
  [switch]$PersistMachinePath
)

$ErrorActionPreference = 'Stop'

$knowledgeRoot = Join-Path $PSScriptRoot 'knowledge'
if (-not (Test-Path $knowledgeRoot)) {
  New-Item -ItemType Directory -Path $knowledgeRoot -Force | Out-Null
}

$preferredSshDir = 'C:\Windows\System32\OpenSSH'
$demoteDirs = @(
  'C:\Program Files\Git\usr\bin',
  'C:\Program Files\Git\mingw64\bin'
)

function Normalize-PathEntry {
  param([string]$Entry)
  return $Entry.Trim().TrimEnd('\\')
}

function Build-PolicyPath {
  param([string]$CurrentPath)

  $ordered = @()
  $seen = @{}

  $allEntries = @($CurrentPath -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

  foreach ($entry in @($preferredSshDir) + $allEntries) {
    $normalized = Normalize-PathEntry -Entry $entry
    if ([string]::IsNullOrWhiteSpace($normalized)) {
      continue
    }

    if ($seen.ContainsKey($normalized.ToLowerInvariant())) {
      continue
    }

    if ($demoteDirs -contains $normalized) {
      continue
    }

    $ordered += $normalized
    $seen[$normalized.ToLowerInvariant()] = $true
  }

  foreach ($demote in $demoteDirs) {
    $normalizedDemote = Normalize-PathEntry -Entry $demote
    if (-not $seen.ContainsKey($normalizedDemote.ToLowerInvariant())) {
      $ordered += $normalizedDemote
      $seen[$normalizedDemote.ToLowerInvariant()] = $true
    }
  }

  return ($ordered -join ';')
}

$originalProcessPath = $env:Path
$policyProcessPath = Build-PolicyPath -CurrentPath $originalProcessPath
$env:Path = $policyProcessPath

$userPathUpdated = $false
if ($PersistUserPath) {
  $currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  $policyUserPath = Build-PolicyPath -CurrentPath $currentUserPath
  [Environment]::SetEnvironmentVariable('Path', $policyUserPath, 'User')
  $userPathUpdated = $true
}

$machinePathUpdated = $false
$machinePathError = $null
if ($PersistMachinePath) {
  try {
    $currentMachinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $policyMachinePath = Build-PolicyPath -CurrentPath $currentMachinePath
    [Environment]::SetEnvironmentVariable('Path', $policyMachinePath, 'Machine')
    $machinePathUpdated = $true
  } catch {
    $machinePathError = $_.Exception.Message
  }
}

$whereSsh = @(& where.exe ssh 2>$null)
$timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ss'
$reportPath = Join-Path $knowledgeRoot "runtime-path-policy-$timestamp.json"

$report = [PSCustomObject]@{
  generatedAt = (Get-Date).ToString('o')
  preferredSshDir = $preferredSshDir
  demotedDirs = $demoteDirs
  persistUserPath = [bool]$PersistUserPath
  persistMachinePath = [bool]$PersistMachinePath
  userPathUpdated = $userPathUpdated
  machinePathUpdated = $machinePathUpdated
  machinePathError = $machinePathError
  firstSshCandidate = if ($whereSsh.Count -gt 0) { $whereSsh[0] } else { $null }
  allSshCandidates = $whereSsh
}

$report | ConvertTo-Json -Depth 6 | Set-Content -Path $reportPath

Write-Host "[path-policy] process path policy applied"
if ($PersistUserPath) {
  Write-Host "[path-policy] user path policy persisted"
}
if ($PersistMachinePath) {
  if ($machinePathUpdated) {
    Write-Host "[path-policy] machine path policy persisted"
  } else {
    Write-Host "[path-policy] machine path policy not persisted: $machinePathError"
  }
}
Write-Host "[path-policy] report exported: $reportPath"

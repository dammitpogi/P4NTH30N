param(
  [switch]$FullBuild,
  [switch]$PruneDuplicates,
  [switch]$PersistPathPolicy,
  [switch]$PersistMachinePathPolicy
)

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$knowledgeRoot = Join-Path $root 'knowledge'

if (!(Test-Path $knowledgeRoot)) {
  New-Item -ItemType Directory -Path $knowledgeRoot -Force | Out-Null
}

$managed = @(
  @{
    Name = 'rancher-desktop'
    SourceDir = Join-Path $root 'rancher-desktop-source'
    DevDir = Join-Path $root 'rancher-desktop-dev'
    Repo = 'https://github.com/rancher-sandbox/rancher-desktop.git'
    Branch = 'main'
    BuildCommand = 'yarn --cwd "{dev}" build'
  },
  @{
    Name = 'toolhive'
    SourceDir = Join-Path $root 'toolhive-source'
    DevDir = Join-Path $root 'toolhive-dev'
    Repo = 'https://github.com/stacklok/toolhive.git'
    Branch = 'main'
    BuildCommand = 'task -d "{dev}" build'
  },
  @{
    Name = 'lms'
    SourceDir = Join-Path $root 'lms-source'
    DevDir = Join-Path $root 'lms-dev'
    Repo = 'https://github.com/lmstudio-ai/lms.git'
    Branch = 'main'
    BuildCommand = 'npm --prefix "{dev}" run build'
  },
  @{
    Name = 'mongosh'
    SourceDir = Join-Path $root 'mongosh-source'
    DevDir = Join-Path $root 'mongosh-dev'
    Repo = 'https://github.com/mongodb-js/mongosh.git'
    Branch = 'main'
    BuildCommand = $null
  },
  @{
    Name = 'openssh'
    SourceDir = Join-Path $root 'openssh-source'
    DevDir = Join-Path $root 'openssh-dev'
    Repo = 'https://github.com/openssh/openssh-portable.git'
    Branch = 'master'
    BuildCommand = $null
  }
)

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Command
  )

  Write-Host "[stack] $Name..."
  & $Command
  if ($LASTEXITCODE -ne 0) {
    throw "Step failed: $Name (exit code $LASTEXITCODE)"
  }
}

function Ensure-Clone {
  param(
    [string]$Path,
    [string]$Repo,
    [string]$Branch
  )

  if (!(Test-Path $Path)) {
    Invoke-Step "cloning $Path" { git clone --depth 1 --branch $Branch $Repo $Path }
  }
}

function Sync-Pair {
  param(
    [hashtable]$Item
  )

  Ensure-Clone -Path $Item.SourceDir -Repo $Item.Repo -Branch $Item.Branch
  Ensure-Clone -Path $Item.DevDir -Repo $Item.Repo -Branch $Item.Branch

  Invoke-Step "$($Item.Name): checkout source branch" {
    git -C $Item.SourceDir checkout $Item.Branch
  }
  Invoke-Step "$($Item.Name): pull source branch" {
    git -C $Item.SourceDir pull --ff-only origin $Item.Branch
  }

  Invoke-Step "$($Item.Name): configure source-local remote in dev" {
    $existingRemotes = git -C $Item.DevDir remote
    if ($existingRemotes -notcontains 'source-local') {
      git -C $Item.DevDir remote add source-local $Item.SourceDir
    } else {
      git -C $Item.DevDir remote set-url source-local $Item.SourceDir
    }
  }

  Invoke-Step "$($Item.Name): checkout dev branch" {
    git -C $Item.DevDir checkout $Item.Branch
  }
  Invoke-Step "$($Item.Name): fetch source-local" {
    git -C $Item.DevDir fetch source-local $Item.Branch
  }
  Invoke-Step "$($Item.Name): ff merge from source-local" {
    git -C $Item.DevDir merge --ff-only ("source-local/" + $Item.Branch)
  }
}

function Find-Duplicates {
  $targets = @('SUSE.RancherDesktop', 'ElementLabs.LMStudio', 'ToolHive', 'MongoDB.Shell')
  $found = @()

  foreach ($target in $targets) {
    $lines = winget list --id $target --accept-source-agreements 2>$null
    $matches = @($lines | Where-Object { $_ -match $target })
    $found += [PSCustomObject]@{
      Id = $target
      Count = $matches.Count
      Rows = $matches
    }
  }

  return $found
}

foreach ($item in $managed) {
  Sync-Pair -Item $item
}

$pathPolicyScript = Join-Path $root 'enforce-runtime-path-policy.ps1'
if (Test-Path $pathPolicyScript) {
  $pathArgs = @(
    '-NoProfile',
    '-ExecutionPolicy',
    'Bypass',
    '-File',
    $pathPolicyScript
  )

  if ($PersistPathPolicy) {
    $pathArgs += '-PersistUserPath'
  }

  if ($PersistMachinePathPolicy) {
    $pathArgs += '-PersistMachinePath'
  }

  Invoke-Step 'runtime PATH policy enforcement' {
    powershell @pathArgs
  }
}

if ($FullBuild) {
  foreach ($item in $managed) {
    if ([string]::IsNullOrWhiteSpace($item.BuildCommand)) {
      Write-Host "[stack] $($item.Name): build skipped (no BuildCommand configured)"
      continue
    }

    $cmd = $item.BuildCommand.Replace('{dev}', $item.DevDir)
    Invoke-Step "$($item.Name): build" {
      powershell -NoProfile -Command $cmd
    }
  }
}

$duplicates = Find-Duplicates
$dupeFile = Join-Path $knowledgeRoot 'stack-duplicates.json'
$duplicates | ConvertTo-Json -Depth 4 | Set-Content -Path $dupeFile

if ($PruneDuplicates) {
  foreach ($item in $duplicates) {
    if ($item.Count -gt 1) {
      Write-Host "[stack] duplicate detected for $($item.Id); manual review required before uninstall"
    }
  }
}

Write-Host "[stack] assimilation sync complete"
Write-Host "[stack] duplicate report: $dupeFile"

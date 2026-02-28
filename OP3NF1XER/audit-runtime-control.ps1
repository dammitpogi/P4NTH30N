$ErrorActionPreference = 'Stop'

$root = Join-Path $PSScriptRoot 'knowledge'
$timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ss'
$preferredSshDir = 'C:\Windows\System32\OpenSSH'
$opensshSourcePath = Join-Path $PSScriptRoot 'openssh-source'
$opensshDevPath = Join-Path $PSScriptRoot 'openssh-dev'

if (-not (Test-Path $root)) {
  New-Item -ItemType Directory -Path $root -Force | Out-Null
}

function Resolve-CommandPath {
  param([string]$Name)
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if ($null -eq $cmd) {
    return $null
  }
  return $cmd.Source
}

function Exec {
  param([string]$Name, [scriptblock]$Block)
  try {
    $output = & $Block 2>&1
    return [PSCustomObject]@{
      name = $Name
      ok = $true
      output = @($output)
    }
  } catch {
    return [PSCustomObject]@{
      name = $Name
      ok = $false
      output = @($_.Exception.Message)
    }
  }
}

function Normalize-PathEntry {
  param([string]$Entry)
  return $Entry.Trim().TrimEnd('\\')
}

function Apply-SshPathPolicy {
  $demoteDirs = @(
    'C:\Program Files\Git\usr\bin',
    'C:\Program Files\Git\mingw64\bin'
  )

  $ordered = @()
  $seen = @{}
  $entries = @($env:Path -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

  foreach ($entry in @($preferredSshDir) + $entries) {
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

  $env:Path = ($ordered -join ';')
}

function Assert-SshPathPolicyOrder {
  param([string]$PathValue)

  if ([string]::IsNullOrWhiteSpace($PathValue)) {
    throw 'PATH value is empty.'
  }

  $entries = @($PathValue -split ';' | ForEach-Object { Normalize-PathEntry -Entry $_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  $preferred = Normalize-PathEntry -Entry $preferredSshDir
  $gitUsr = Normalize-PathEntry -Entry 'C:\Program Files\Git\usr\bin'
  $gitMingw = Normalize-PathEntry -Entry 'C:\Program Files\Git\mingw64\bin'

  $preferredIndex = [Array]::IndexOf($entries, $preferred)
  if ($preferredIndex -lt 0) {
    throw "Preferred OpenSSH path missing: $preferred"
  }

  $gitUsrIndex = [Array]::IndexOf($entries, $gitUsr)
  if ($gitUsrIndex -ge 0 -and $gitUsrIndex -lt $preferredIndex) {
    throw "Git usr ssh path precedes preferred path (gitUsrIndex=$gitUsrIndex preferredIndex=$preferredIndex)"
  }

  $gitMingwIndex = [Array]::IndexOf($entries, $gitMingw)
  if ($gitMingwIndex -ge 0 -and $gitMingwIndex -lt $preferredIndex) {
    throw "Git mingw ssh path precedes preferred path (gitMingwIndex=$gitMingwIndex preferredIndex=$preferredIndex)"
  }

  return @(
    "preferredIndex=$preferredIndex",
    "gitUsrIndex=$gitUsrIndex",
    "gitMingwIndex=$gitMingwIndex"
  )
}

Apply-SshPathPolicy

$report = [PSCustomObject]@{
  generatedAt = (Get-Date).ToString('o')
  machine = $env:COMPUTERNAME
  commandSources = [PSCustomObject]@{
    opencode = Resolve-CommandPath -Name 'opencode'
    thv = Resolve-CommandPath -Name 'thv'
    lms = Resolve-CommandPath -Name 'lms'
    rdctl = Resolve-CommandPath -Name 'rdctl'
    ssh = Resolve-CommandPath -Name 'ssh'
    sshd = Resolve-CommandPath -Name 'sshd'
  }
  checks = @(
    Exec -Name 'opencode --version' -Block { opencode --version }
    Exec -Name 'powershell opencode --version' -Block { powershell -NoProfile -Command "opencode --version" }
    Exec -Name 'sudo --inline opencode --version' -Block { sudo --inline opencode --version }
    Exec -Name 'thv version' -Block { python -c "import subprocess; p=subprocess.run(['thv','version'], capture_output=True, text=True); print((p.stdout + p.stderr).strip()); raise SystemExit(p.returncode)" }
    Exec -Name 'lms --help' -Block { lms --help }
    Exec -Name 'rdctl version' -Block { rdctl version }
    Exec -Name 'where ssh' -Block { where.exe ssh }
    Exec -Name 'ssh -V' -Block { cmd /c "ssh -V 2>&1" }
    Exec -Name 'ssh path policy (preferred candidate first)' -Block {
      $candidates = @(& where.exe ssh)
      if ($candidates.Count -eq 0) {
        throw 'No ssh candidates found on PATH.'
      }

      $expected = Join-Path $preferredSshDir 'ssh.exe'
      if ($candidates[0].ToLowerInvariant() -ne $expected.ToLowerInvariant()) {
        throw "PATH policy drift. expected first=$expected actual first=$($candidates[0])"
      }

      return $candidates
    }
    Exec -Name 'user PATH policy order (OpenSSH before Git SSH dirs)' -Block {
      $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
      return Assert-SshPathPolicyOrder -PathValue $userPath
    }
    Exec -Name 'machine PATH policy order (OpenSSH before Git SSH dirs)' -Block {
      $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
      return Assert-SshPathPolicyOrder -PathValue $machinePath
    }
    Exec -Name 'OpenSSH capability state' -Block {
      Get-WindowsCapability -Online |
        Where-Object { $_.Name -like 'OpenSSH.Client*' -or $_.Name -like 'OpenSSH.Server*' } |
        ForEach-Object { "$($_.Name):$($_.State)" }
    }
    Exec -Name 'OpenSSH development parity (source vs dev)' -Block {
      if (-not (Test-Path $opensshSourcePath)) {
        throw "OpenSSH source path missing: $opensshSourcePath"
      }
      if (-not (Test-Path $opensshDevPath)) {
        throw "OpenSSH dev path missing: $opensshDevPath"
      }

      $sourceHead = (git -C $opensshSourcePath rev-parse HEAD).Trim()
      $devHead = (git -C $opensshDevPath rev-parse HEAD).Trim()
      $sourceDescribe = (git -C $opensshSourcePath describe --tags --long --always).Trim()
      $devDescribe = (git -C $opensshDevPath describe --tags --long --always).Trim()

      if ($sourceHead -ne $devHead) {
        throw "Dev parity drift. source=$sourceHead dev=$devHead"
      }

      return @(
        "sourceHead=$sourceHead",
        "devHead=$devHead",
        "sourceDescribe=$sourceDescribe",
        "devDescribe=$devDescribe"
      )
    }
  )
}

$jsonPath = Join-Path $root "runtime-control-audit-$timestamp.json"
$report | ConvertTo-Json -Depth 8 | Set-Content -Path $jsonPath
Write-Host "[runtime-audit] report exported: $jsonPath"

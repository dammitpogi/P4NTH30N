param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('version', 'status', 'doctor', 'get', 'set', 'set-json', 'gateway-probe', 'gateway-stop')]
  [string]$Action,
  [string]$Path = '',
  [string]$Value = '',
  [string]$TargetConfig = '',
  [string]$TraceId = '',
  [string]$LogDir = ''
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($TraceId)) {
  $TraceId = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ')
}

if ([string]::IsNullOrWhiteSpace($LogDir)) {
  $LogDir = Join-Path $PSScriptRoot '..\srv\logs'
}

function Write-Trace {
  param(
    [string]$Level,
    [string]$Message
  )
  $stamp = [DateTime]::UtcNow.ToString('o')
  $line = "[$stamp][$TraceId][$Level] $Message"
  Write-Host $line
  Add-Content -Path $script:LogPath -Value $line -Encoding UTF8
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$script:LogPath = Join-Path ([System.IO.Path]::GetFullPath($LogDir)) "openclaw-config-over-ssh-$TraceId.log"
Write-Trace 'INFO' "startup action=$Action path=$Path"

$sshScript = Join-Path $PSScriptRoot 'railway-ssh.ps1'
if (-not (Test-Path $sshScript)) {
  Write-Trace 'ERROR' "missing ssh helper: $sshScript"
  throw "Missing helper script: $sshScript"
}

switch ($Action) {
  'version' {
    Write-Trace 'INFO' 'executing version probe'
    & $sshScript -TargetConfig $TargetConfig -Command 'openclaw --version' -TraceId $TraceId -LogDir $LogDir
  }
  'status' {
    Write-Trace 'INFO' 'executing status probe'
    & $sshScript -TargetConfig $TargetConfig -Command 'openclaw status' -TraceId $TraceId -LogDir $LogDir
  }
  'doctor' {
    Write-Trace 'INFO' 'executing doctor probe'
    & $sshScript -TargetConfig $TargetConfig -Command 'openclaw doctor' -TraceId $TraceId -LogDir $LogDir
  }
  'get' {
    if ([string]::IsNullOrWhiteSpace($Path)) {
      Write-Trace 'ERROR' 'get requested without path'
      throw 'Action=get requires -Path'
    }
    Write-Trace 'INFO' "executing config get for path=$Path"
    & $sshScript -TargetConfig $TargetConfig -Command ("openclaw config get {0}" -f $Path) -TraceId $TraceId -LogDir $LogDir
  }
  'set' {
    if ([string]::IsNullOrWhiteSpace($Path) -or [string]::IsNullOrWhiteSpace($Value)) {
      Write-Trace 'ERROR' 'set requested without path/value'
      throw 'Action=set requires -Path and -Value'
    }
    Write-Trace 'RISK' "executing config set path=$Path"
    & $sshScript -TargetConfig $TargetConfig -Command ("openclaw config set {0} {1}" -f $Path, $Value) -TraceId $TraceId -LogDir $LogDir
  }
  'set-json' {
    if ([string]::IsNullOrWhiteSpace($Path) -or [string]::IsNullOrWhiteSpace($Value)) {
      Write-Trace 'ERROR' 'set-json requested without path/value'
      throw 'Action=set-json requires -Path and -Value'
    }
    Write-Trace 'RISK' "executing config set-json path=$Path"
    & $sshScript -TargetConfig $TargetConfig -Command ("openclaw config set --json {0} '{1}'" -f $Path, $Value) -TraceId $TraceId -LogDir $LogDir
  }
  'gateway-probe' {
    Write-Trace 'INFO' 'executing gateway probe'
    & $sshScript -TargetConfig $TargetConfig -Command 'openclaw gateway probe' -TraceId $TraceId -LogDir $LogDir
  }
  'gateway-stop' {
    Write-Trace 'RISK' 'executing gateway stop to clear lock contention'
    & $sshScript -TargetConfig $TargetConfig -Command 'openclaw gateway stop' -TraceId $TraceId -LogDir $LogDir -AllowFailure
    Write-Trace 'INFO' 'running gateway probe after stop attempt'
    & $sshScript -TargetConfig $TargetConfig -Command 'openclaw gateway probe' -TraceId $TraceId -LogDir $LogDir
  }
}

Write-Trace 'INFO' 'openclaw-config-over-ssh completed'

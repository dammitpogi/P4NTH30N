param(
  [string]$TargetConfig = '',
  [string]$Command = '',
  [switch]$Session,
  [string]$SessionName = '',
  [string]$TraceId = '',
  [string]$LogDir = '',
  [switch]$AllowFailure
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

if ([string]::IsNullOrWhiteSpace($TargetConfig)) {
  $TargetConfig = Join-Path $PSScriptRoot '..\dev\config\railway-target.json'
}

$TargetConfig = [System.IO.Path]::GetFullPath($TargetConfig)
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$script:LogPath = Join-Path ([System.IO.Path]::GetFullPath($LogDir)) "railway-ssh-$TraceId.log"
$stateDir = Join-Path $PSScriptRoot '..\srv\state'
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
$script:ContinuityPath = Join-Path ([System.IO.Path]::GetFullPath($stateDir)) 'continuity.json'

function Set-ContinuityState {
  param(
    [string]$Phase,
    [string]$Status,
    [string]$Details
  )
  $obj = [ordered]@{
    traceId = $TraceId
    tool = 'railway-ssh'
    phase = $Phase
    status = $Status
    details = $Details
    updatedAtUtc = [DateTime]::UtcNow.ToString('o')
  }
  $obj | ConvertTo-Json -Depth 6 | Set-Content -Path $script:ContinuityPath -Encoding UTF8
}

Write-Trace 'INFO' "startup config=$TargetConfig session=$($Session.IsPresent)"
Write-Trace 'INFO' "allowFailure=$($AllowFailure.IsPresent)"
Set-ContinuityState -Phase 'startup' -Status 'in_progress' -Details 'initializing ssh command'

if (-not (Test-Path $TargetConfig)) {
  Write-Trace 'ERROR' "target config missing: $TargetConfig"
  Set-ContinuityState -Phase 'startup' -Status 'failed' -Details 'target config missing'
  throw "Target config not found: $TargetConfig"
}

$target = Get-Content -Raw -Encoding UTF8 $TargetConfig | ConvertFrom-Json
Write-Trace 'INFO' "target resolved project=$($target.projectId) service=$($target.serviceId) env=$($target.environmentId)"

$argsList = @(
  'ssh',
  '-p', $target.projectId,
  '-e', $target.environmentId,
  '-s', $target.serviceId
)

if ($Session) {
  if ([string]::IsNullOrWhiteSpace($SessionName)) {
    $argsList += '--session'
  } else {
    $argsList += @('--session', $SessionName)
  }
}

if (-not [string]::IsNullOrWhiteSpace($Command)) {
  $argsList += $Command
  Write-Trace 'INFO' "remote command set: $Command"
  if ($Command -match 'tar -x|rm -rf|base64 -d|config set') {
    Write-Trace 'RISK' 'high-risk mutation pattern detected in remote command'
  }
}

Write-Trace 'INFO' 'invoking railway ssh'
Set-ContinuityState -Phase 'exec' -Status 'in_progress' -Details 'executing railway ssh'
& railway @argsList
$exitCode = $LASTEXITCODE
Write-Trace 'INFO' "railway ssh exit=$exitCode"
if ($exitCode -ne 0) {
  if ($AllowFailure) {
    Write-Trace 'WARN' "railway ssh failed but allowFailure=true (exit=$exitCode)"
    Set-ContinuityState -Phase 'exec' -Status 'partial' -Details "railway ssh exit $exitCode allowed"
    return
  }
  Write-Trace 'ERROR' "railway ssh failed (trace=$TraceId)"
  Set-ContinuityState -Phase 'exec' -Status 'failed' -Details "railway ssh exit $exitCode"
  throw "railway ssh failed with exit code $exitCode"
}
Write-Trace 'INFO' 'railway ssh completed successfully'
Set-ContinuityState -Phase 'complete' -Status 'success' -Details 'railway ssh success'

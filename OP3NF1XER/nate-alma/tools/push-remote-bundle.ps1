param(
  [Parameter(Mandatory = $true)]
  [string]$Bundle,
  [string]$TargetConfig = '',
  [switch]$Apply,
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

function Set-ContinuityState {
  param(
    [string]$Phase,
    [string]$Status,
    [string]$Details
  )
  $obj = [ordered]@{
    traceId = $TraceId
    tool = 'push-remote-bundle'
    phase = $Phase
    status = $Status
    details = $Details
    updatedAtUtc = [DateTime]::UtcNow.ToString('o')
  }
  $obj | ConvertTo-Json -Depth 6 | Set-Content -Path $script:ContinuityPath -Encoding UTF8
}

if ([string]::IsNullOrWhiteSpace($TargetConfig)) {
  $TargetConfig = Join-Path $PSScriptRoot '..\dev\config\railway-target.json'
}

$TargetConfig = [System.IO.Path]::GetFullPath($TargetConfig)
$Bundle = [System.IO.Path]::GetFullPath($Bundle)

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$script:LogPath = Join-Path ([System.IO.Path]::GetFullPath($LogDir)) "push-remote-bundle-$TraceId.log"
$stateDir = Join-Path $PSScriptRoot '..\srv\state'
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
$script:ContinuityPath = Join-Path ([System.IO.Path]::GetFullPath($stateDir)) 'continuity.json'

Write-Trace 'INFO' "startup bundle=$Bundle config=$TargetConfig apply=$($Apply.IsPresent)"
Set-ContinuityState -Phase 'startup' -Status 'in_progress' -Details 'initializing push flow'

if (-not (Test-Path $TargetConfig)) {
  Write-Trace 'ERROR' "target config missing: $TargetConfig"
  Set-ContinuityState -Phase 'startup' -Status 'failed' -Details 'target config missing'
  throw "Target config not found: $TargetConfig"
}

$target = Get-Content -Raw -Encoding UTF8 $TargetConfig | ConvertFrom-Json
$tmpB64 = '/tmp/nate-alma-import.b64'
$tmpTar = '/tmp/nate-alma-import.tar.gz'

if (-not $Apply) {
  if (-not (Test-Path $Bundle)) {
    Write-Trace 'WARN' "bundle path does not exist yet: $Bundle"
  }
  Write-Trace 'INFO' 'dry-run mode; exiting without mutation'
  Set-ContinuityState -Phase 'dry_run' -Status 'success' -Details $Bundle
  Write-Host '[nate-alma:push] dry-run only. no remote write performed.'
  Write-Host "[nate-alma:push] bundle: $Bundle"
  Write-Host "[nate-alma:push] target: project=$($target.projectId) service=$($target.serviceId) env=$($target.environmentId)"
  Write-Host '[nate-alma:push] re-run with -Apply to execute.'
  exit 0
}

if (-not (Test-Path $Bundle)) {
  Write-Trace 'ERROR' "bundle missing: $Bundle"
  Set-ContinuityState -Phase 'startup' -Status 'failed' -Details 'bundle missing'
  throw "Bundle not found: $Bundle"
}

Write-Trace 'RISK' 'apply mode enabled; remote filesystem mutation will be performed'
Write-Trace 'INFO' "applying bundle: $Bundle"
Set-ContinuityState -Phase 'encode' -Status 'in_progress' -Details 'reading and encoding bundle'

$bytes = [System.IO.File]::ReadAllBytes($Bundle)
$b64 = [System.Convert]::ToBase64String($bytes)
$chunkSize = 3500
$count = [Math]::Ceiling($b64.Length / $chunkSize)

Write-Host "[nate-alma:push] uploading base64 chunks: $count"
Write-Trace 'INFO' "bundle bytes=$($bytes.Length) chunks=$count chunkSize=$chunkSize"

$resetCmd = "rm -f {0} {1}" -f $tmpB64, $tmpTar
Write-Trace 'INFO' 'resetting temporary remote files'
& railway ssh -p $target.projectId -e $target.environmentId -s $target.serviceId $resetCmd
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
  Write-Trace 'ERROR' "push prep failed exit=$exitCode"
  Set-ContinuityState -Phase 'prepare_remote' -Status 'failed' -Details "prep exit $exitCode"
  throw "push prep failed with exit code $exitCode"
}

Set-ContinuityState -Phase 'upload' -Status 'in_progress' -Details "uploading $count chunks"

for ($i = 0; $i -lt $count; $i++) {
  $start = $i * $chunkSize
  $len = [Math]::Min($chunkSize, $b64.Length - $start)
  $chunk = $b64.Substring($start, $len)
  $appendCmd = "printf '%s' '{0}' >> {1}" -f $chunk, $tmpB64
  & railway ssh -p $target.projectId -e $target.environmentId -s $target.serviceId $appendCmd
  $exitCode = $LASTEXITCODE
  if ($exitCode -ne 0) {
    Write-Trace 'ERROR' "chunk upload failed index=$($i + 1) exit=$exitCode"
    Set-ContinuityState -Phase 'upload' -Status 'failed' -Details "chunk $($i + 1) failed exit $exitCode"
    throw "push chunk $($i + 1)/$count failed with exit code $exitCode"
  }
  if (($i + 1) -eq 1 -or (($i + 1) % 25) -eq 0 -or ($i + 1) -eq $count) {
    Write-Trace 'INFO' "chunk progress $($i + 1)/$count"
  }
}

$applyCmd = "base64 -d {0} > {1} && tar -xzf {1} -C / && rm -f {0} {1}" -f $tmpB64, $tmpTar
Write-Trace 'RISK' 'executing remote decode and tar extract'
Set-ContinuityState -Phase 'apply' -Status 'in_progress' -Details 'decoding and extracting remote tar bundle'
& railway ssh -p $target.projectId -e $target.environmentId -s $target.serviceId $applyCmd
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
  Write-Trace 'ERROR' "push apply failed exit=$exitCode"
  Set-ContinuityState -Phase 'apply' -Status 'failed' -Details "apply exit $exitCode"
  throw "push apply failed with exit code $exitCode"
}

Write-Trace 'INFO' 'push apply completed successfully'
Set-ContinuityState -Phase 'complete' -Status 'success' -Details $Bundle
Write-Host '[nate-alma:push] complete.'

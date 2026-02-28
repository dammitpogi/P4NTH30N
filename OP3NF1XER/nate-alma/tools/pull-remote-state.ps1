param(
  [string]$TargetConfig = '',
  [string]$OutDir = '',
  [string]$Label = 'snapshot',
  [switch]$IncludeWorkspace,
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
    tool = 'pull-remote-state'
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
if ([string]::IsNullOrWhiteSpace($OutDir)) {
  $OutDir = Join-Path $PSScriptRoot '..\srv\pulls'
}

$TargetConfig = [System.IO.Path]::GetFullPath($TargetConfig)
$OutDir = [System.IO.Path]::GetFullPath($OutDir)

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$script:LogPath = Join-Path ([System.IO.Path]::GetFullPath($LogDir)) "pull-remote-state-$TraceId.log"
$stateDir = Join-Path $PSScriptRoot '..\srv\state'
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
$script:ContinuityPath = Join-Path ([System.IO.Path]::GetFullPath($stateDir)) 'continuity.json'

Write-Trace 'INFO' "startup config=$TargetConfig outDir=$OutDir includeWorkspace=$($IncludeWorkspace.IsPresent)"
Set-ContinuityState -Phase 'startup' -Status 'in_progress' -Details 'initializing pull flow'

if (-not (Test-Path $TargetConfig)) {
  Write-Trace 'ERROR' "target config missing: $TargetConfig"
  Set-ContinuityState -Phase 'startup' -Status 'failed' -Details 'target config missing'
  throw "Target config not found: $TargetConfig"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$target = Get-Content -Raw -Encoding UTF8 $TargetConfig | ConvertFrom-Json
Write-Trace 'INFO' "target resolved project=$($target.projectId) service=$($target.serviceId) env=$($target.environmentId)"

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$archivePath = Join-Path $OutDir "nate-alma-$Label-$timestamp.tar.gz"
$capturePath = "$archivePath.b64.txt"

$paths = @($target.stateDir)
if ($IncludeWorkspace) {
  $paths += $target.workspaceDir
}

$normalized = $paths | ForEach-Object { $_.TrimStart('/') }
$pathArg = [string]::Join(' ', $normalized)
$remoteCommand = "tar -C / -czf /tmp/nate-alma-pull.tar.gz {0} && printf '__NATE_ALMA_BEGIN__\n' && base64 /tmp/nate-alma-pull.tar.gz && printf '\n__NATE_ALMA_END__\n' && rm -f /tmp/nate-alma-pull.tar.gz" -f $pathArg

Write-Trace 'INFO' "archive path: $archivePath"
Write-Trace 'INFO' "remote command prepared"
Write-Trace 'RISK' 'pull operation relies on marker-framed base64 output; marker loss is a critical failure point'
Set-ContinuityState -Phase 'remote_exec' -Status 'in_progress' -Details 'executing railway ssh pull command'

$railwayCall = "railway ssh -p {0} -e {1} -s {2} `"{3}`"" -f $target.projectId, $target.environmentId, $target.serviceId, $remoteCommand
$cmd = "{0} > `"{1}`"" -f $railwayCall, $capturePath

cmd /c $cmd
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
  Write-Trace 'ERROR' "railway pull execution failed exit=$exitCode"
  Set-ContinuityState -Phase 'remote_exec' -Status 'failed' -Details "railway ssh exit $exitCode"
  throw "pull failed with exit code $exitCode"
}

Write-Trace 'INFO' 'railway pull execution succeeded, starting decode'
Set-ContinuityState -Phase 'decode' -Status 'in_progress' -Details 'decoding base64 capture to tar.gz'

python -c "import base64,pathlib,sys;src=pathlib.Path(sys.argv[1]);dst=pathlib.Path(sys.argv[2]);txt=src.read_text(encoding='utf-8',errors='ignore');a='__NATE_ALMA_BEGIN__';b='__NATE_ALMA_END__';i=txt.find(a);j=txt.find(b);assert i!=-1 and j!=-1 and j>i,'markers not found';payload=''.join(txt[i+len(a):j].split());dst.write_bytes(base64.b64decode(payload));" "$capturePath" "$archivePath"

$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
  Write-Trace 'ERROR' "decode failed exit=$exitCode (likely marker/frame corruption)"
  Set-ContinuityState -Phase 'decode' -Status 'failed' -Details "decode failure exit $exitCode"
  throw "pull decode failed with exit code $exitCode"
}

Write-Trace 'INFO' 'decode succeeded'

Remove-Item -Force $capturePath

Write-Trace 'INFO' "pull complete archive=$archivePath"
Set-ContinuityState -Phase 'complete' -Status 'success' -Details $archivePath

Write-Host "[nate-alma:pull] complete -> $archivePath"

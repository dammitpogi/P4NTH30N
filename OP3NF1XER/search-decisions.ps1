param(
  [Parameter(Mandatory = $true)]
  [string]$Query,
  [string]$Root = 'C:\P4NTH30N\STR4TEG15T\memory\decisions'
)

$ErrorActionPreference = 'Stop'

if (!(Test-Path $Root)) {
  throw "Decision root not found: $Root"
}

$matches = Get-ChildItem -Path $Root -Filter '*.md' -Recurse |
  Select-String -Pattern $Query -SimpleMatch |
  Select-Object Path, LineNumber, Line

if ($matches.Count -eq 0) {
  Write-Host '[decisions] no matches found'
  exit 0
}

$matches | ForEach-Object {
  Write-Host ("{0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim())
}

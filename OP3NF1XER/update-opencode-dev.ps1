$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$source = Join-Path $root 'opencode-source'
$dev = Join-Path $root 'opencode-dev'
$buildExe = Join-Path $dev 'packages\opencode\dist\opencode-windows-x64\bin\opencode.exe'

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Command
  )

  Write-Host "[opencode] $Name..."
  & $Command
  if ($LASTEXITCODE -ne 0) {
    throw "Step failed: $Name (exit code $LASTEXITCODE)"
  }
}

Invoke-Step 'updating source clone' { git -C $source checkout dev }
Invoke-Step 'pulling source clone' { git -C $source pull --ff-only origin dev }

Invoke-Step 'configuring source-local remote in development clone' {
  $existingRemotes = git -C $dev remote
  if ($existingRemotes -notcontains 'source-local') {
    git -C $dev remote add source-local $source
  } else {
    git -C $dev remote set-url source-local $source
  }
}

Invoke-Step 'syncing development clone' { git -C $dev checkout dev }
Invoke-Step 'fetching source clone branch into development clone' {
  git -C $dev fetch source-local dev
}
Invoke-Step 'fast-forwarding development clone from source clone' {
  git -C $dev merge --ff-only source-local/dev
}

Invoke-Step 'installing dependencies' { bun install --cwd $dev }

Invoke-Step 'building windows binary' { bun run --cwd (Join-Path $dev 'packages\opencode') build }

if (!(Test-Path $buildExe)) {
  throw "Build completed but binary not found: $buildExe"
}

Write-Host "[opencode] ready: $buildExe"

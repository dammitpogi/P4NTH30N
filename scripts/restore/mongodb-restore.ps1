<#
.SYNOPSIS
    Restores a P4NTHE0N MongoDB backup.

.DESCRIPTION
    INFRA-005: Backup and Disaster Recovery.
    Restores from a compressed backup archive created by mongodb-backup.ps1.

.PARAMETER BackupArchive
    Path to the .zip backup archive to restore.

.PARAMETER Database
    Target database name. Default: P4NTHE0N

.PARAMETER ConnectionString
    MongoDB connection string. Default: mongodb://localhost:27017

.PARAMETER Drop
    If set, drops existing collections before restore.

.EXAMPLE
    .\mongodb-restore.ps1 -BackupArchive "C:\P4NTHE0N\backups\P4NTHE0N_20260218_120000.zip"
    .\mongodb-restore.ps1 -BackupArchive "C:\P4NTHE0N\backups\P4NTHE0N_20260218_120000.zip" -Drop
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupArchive,
    [string]$Database = "P4NTHE0N",
    [string]$ConnectionString = "mongodb://localhost:27017",
    [switch]$Drop
)

$ErrorActionPreference = "Stop"

Write-Host "╔══════════════════════════════════════════════╗"
Write-Host "║  P4NTHE0N MongoDB Restore                    ║"
Write-Host "╚══════════════════════════════════════════════╝"
Write-Host ""

if (-not (Test-Path $BackupArchive)) {
    Write-Host "[ERROR] Backup archive not found: $BackupArchive"
    exit 1
}

# Check mongorestore
$mongorestore = Get-Command mongorestore -ErrorAction SilentlyContinue
if (-not $mongorestore) {
    Write-Host "[ERROR] mongorestore not found. Install MongoDB Database Tools."
    exit 1
}

# Extract archive
$tempDir = Join-Path $env:TEMP "P4NTHE0N_restore_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Write-Host "[Restore] Extracting $BackupArchive..."
Expand-Archive -Path $BackupArchive -DestinationPath $tempDir -Force

# Find the database dump directory
$dumpDir = Get-ChildItem -Path $tempDir -Directory -Recurse | Where-Object { $_.Name -eq $Database } | Select-Object -First 1
if (-not $dumpDir) {
    Write-Host "[ERROR] Database dump directory '$Database' not found in archive."
    Remove-Item $tempDir -Recurse -Force
    exit 1
}

Write-Host "[Restore] Found dump at: $($dumpDir.FullName)"

if ($Drop) {
    Write-Host "[Restore] WARNING: --drop flag set. Existing collections will be replaced."
    Write-Host "[Restore] Press Ctrl+C within 5 seconds to abort..."
    Start-Sleep -Seconds 5
}

# Execute restore
try {
    $restoreArgs = @("--uri=`"$ConnectionString`"", "--db=`"$Database`"", "--gzip", "--dir=`"$($dumpDir.FullName)`"")
    if ($Drop) { $restoreArgs += "--drop" }

    & mongorestore @restoreArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "mongorestore failed with exit code $LASTEXITCODE"
    }
    Write-Host "[Restore] Restore completed successfully."
} catch {
    Write-Host "[ERROR] Restore failed: $_"
    exit 1
} finally {
    Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "[Restore] Database '$Database' restored from $BackupArchive"

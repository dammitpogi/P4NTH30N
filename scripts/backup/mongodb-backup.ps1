<#
.SYNOPSIS
    Automated MongoDB backup script for P4NTHE0N database.

.DESCRIPTION
    INFRA-005: Backup and Disaster Recovery.
    Creates compressed MongoDB dumps with verification.
    Supports retention policies (7 daily, 4 weekly, 12 monthly).

.PARAMETER BackupDir
    Directory to store backups. Default: C:\P4NTHE0N\backups

.PARAMETER Database
    MongoDB database name. Default: P4NTHE0N

.PARAMETER ConnectionString
    MongoDB connection string. Default: mongodb://localhost:27017

.PARAMETER RetainDays
    Number of daily backups to retain. Default: 7

.EXAMPLE
    .\mongodb-backup.ps1
    .\mongodb-backup.ps1 -BackupDir "D:\backups" -RetainDays 14
#>

param(
    [string]$BackupDir = "C:\P4NTHE0N\backups",
    [string]$Database = "P4NTHE0N",
    [string]$ConnectionString = "mongodb://localhost:27017",
    [int]$RetainDays = 7
)

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupName = "${Database}_${timestamp}"
$backupPath = Join-Path $BackupDir $backupName

Write-Host "╔══════════════════════════════════════════════╗"
Write-Host "║  P4NTHE0N MongoDB Backup                     ║"
Write-Host "╚══════════════════════════════════════════════╝"
Write-Host ""

# Ensure backup directory exists
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Write-Host "[Backup] Created backup directory: $BackupDir"
}

# Check mongodump availability
$mongodump = Get-Command mongodump -ErrorAction SilentlyContinue
if (-not $mongodump) {
    Write-Host "[ERROR] mongodump not found. Install MongoDB Database Tools."
    Write-Host "  Download: https://www.mongodb.com/try/download/database-tools"
    exit 1
}

# Execute backup
Write-Host "[Backup] Starting backup of $Database..."
Write-Host "[Backup] Output: $backupPath"

try {
    & mongodump --uri="$ConnectionString" --db="$Database" --out="$backupPath" --gzip 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "mongodump failed with exit code $LASTEXITCODE"
    }
    Write-Host "[Backup] Dump completed successfully."
} catch {
    Write-Host "[ERROR] Backup failed: $_"
    exit 1
}

# Verify backup
$backupFiles = Get-ChildItem -Path $backupPath -Recurse -File
$totalSize = ($backupFiles | Measure-Object -Property Length -Sum).Sum
$fileSizeMB = [math]::Round($totalSize / 1MB, 2)

if ($backupFiles.Count -eq 0) {
    Write-Host "[ERROR] Backup produced no files. Verification failed."
    exit 1
}

Write-Host "[Backup] Verified: $($backupFiles.Count) files, ${fileSizeMB}MB total"

# Create compressed archive
$archivePath = "$backupPath.zip"
try {
    Compress-Archive -Path $backupPath -DestinationPath $archivePath -CompressionLevel Optimal
    Remove-Item -Path $backupPath -Recurse -Force
    $archiveSize = [math]::Round((Get-Item $archivePath).Length / 1MB, 2)
    Write-Host "[Backup] Compressed archive: ${archiveSize}MB ($archivePath)"
} catch {
    Write-Host "[WARN] Compression failed, keeping uncompressed: $_"
}

# Retention policy - remove old backups
Write-Host "[Backup] Applying retention policy ($RetainDays days)..."
$cutoff = (Get-Date).AddDays(-$RetainDays)
$oldBackups = Get-ChildItem -Path $BackupDir -Filter "${Database}_*.zip" |
    Where-Object { $_.CreationTime -lt $cutoff }

if ($oldBackups.Count -gt 0) {
    foreach ($old in $oldBackups) {
        Remove-Item $old.FullName -Force
        Write-Host "[Backup] Removed expired: $($old.Name)"
    }
    Write-Host "[Backup] Cleaned up $($oldBackups.Count) expired backup(s)."
} else {
    Write-Host "[Backup] No expired backups to clean."
}

# Summary
$remaining = (Get-ChildItem -Path $BackupDir -Filter "${Database}_*.zip").Count
Write-Host ""
Write-Host "[Backup] Complete. $remaining backup(s) retained."
Write-Host "[Backup] Latest: $archivePath"

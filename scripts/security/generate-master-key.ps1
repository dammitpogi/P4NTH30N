<#
.SYNOPSIS
    Generates a new P4NTH30N master encryption key for AES-256-GCM credential protection.

.DESCRIPTION
    Creates a 256-bit (32-byte) cryptographically random master key and stores it
    at the configured path with restrictive ACL (Administrators only).
    
    This key is used by EncryptionService to derive per-purpose encryption keys
    via PBKDF2-SHA512 with 600,000 iterations.

    WARNING: If a key already exists, use -Force to overwrite. Overwriting the key
    will make ALL previously encrypted credentials unrecoverable unless you have a backup.

.PARAMETER KeyPath
    Full path to the master key file. Default: C:\ProgramData\P4NTH30N\master.key

.PARAMETER Force
    Overwrite an existing key file. Use with extreme caution.

.PARAMETER BackupExisting
    If a key exists and -Force is used, back up the old key before overwriting.
    Default: $true

.EXAMPLE
    .\generate-master-key.ps1
    # Generates a new key at the default location

.EXAMPLE
    .\generate-master-key.ps1 -KeyPath "D:\Keys\master.key"
    # Generates a key at a custom location

.EXAMPLE
    .\generate-master-key.ps1 -Force -BackupExisting
    # Overwrites existing key after backing it up

.NOTES
    Part of INFRA-009: In-House Secrets Management
    Requires: PowerShell 5.1+ / Administrator privileges recommended
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$KeyPath = "C:\ProgramData\P4NTH30N\master.key",

    [Parameter()]
    [switch]$Force,

    [Parameter()]
    [bool]$BackupExisting = $true
)

$ErrorActionPreference = "Stop"

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  P4NTH30N Master Key Generator (INFRA-009)                   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Pre-flight checks ─────────────────────────────────────────────────────
$keyDir = Split-Path -Parent $KeyPath

if (Test-Path $KeyPath) {
    if (-not $Force) {
        Write-Host "[ERROR] Master key already exists at: $KeyPath" -ForegroundColor Red
        Write-Host "        Use -Force to overwrite (DESTRUCTIVE - all encrypted data becomes unrecoverable)." -ForegroundColor Yellow
        Write-Host "        Use -Force -BackupExisting to overwrite with backup." -ForegroundColor Yellow
        exit 1
    }

    if ($BackupExisting) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupPath = "$KeyPath.bak.$timestamp"
        Copy-Item -Path $KeyPath -Destination $backupPath -Force
        Write-Host "[BACKUP] Old key backed up to: $backupPath" -ForegroundColor Yellow
    }
    else {
        Write-Host "[WARNING] Overwriting key WITHOUT backup. Previous encrypted data is LOST." -ForegroundColor Red
    }
}

# ── Create directory if needed ────────────────────────────────────────────
if (-not (Test-Path $keyDir)) {
    New-Item -ItemType Directory -Path $keyDir -Force | Out-Null
    Write-Host "[DIR] Created directory: $keyDir" -ForegroundColor Green
}

# ── Generate 256-bit cryptographically random key ─────────────────────────
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$keyBytes = New-Object byte[] 32
$rng.GetBytes($keyBytes)

[System.IO.File]::WriteAllBytes($KeyPath, $keyBytes)
Write-Host "[KEY] Master key generated: $KeyPath (32 bytes / 256 bits)" -ForegroundColor Green

# ── Set restrictive ACL (Administrators only) ─────────────────────────────
try {
    $acl = Get-Acl -Path $KeyPath

    # Disable inheritance and remove all existing rules
    $acl.SetAccessRuleProtection($true, $false)
    $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) } | Out-Null

    # Grant FullControl to BUILTIN\Administrators only
    $adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "BUILTIN\Administrators",
        "FullControl",
        "Allow"
    )
    $acl.AddAccessRule($adminRule)
    Set-Acl -Path $KeyPath -AclObject $acl

    Write-Host "[ACL] Permissions set: Administrators only (FullControl)" -ForegroundColor Green
}
catch {
    Write-Host "[WARNING] Could not set restrictive ACL: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "          Please manually secure the key file." -ForegroundColor Yellow
}

# ── Verification ──────────────────────────────────────────────────────────
$verifyBytes = [System.IO.File]::ReadAllBytes($KeyPath)
if ($verifyBytes.Length -eq 32) {
    Write-Host ""
    Write-Host "[OK] Master key verified: $($verifyBytes.Length) bytes" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Run the application — EncryptionService will auto-load this key" -ForegroundColor White
    Write-Host "  2. Use encrypt-credentials.ps1 to migrate existing plaintext passwords" -ForegroundColor White
    Write-Host "  3. BACK UP this key file to a secure offline location" -ForegroundColor Yellow
}
else {
    Write-Host "[ERROR] Key verification failed — unexpected file size: $($verifyBytes.Length)" -ForegroundColor Red
    exit 1
}

# Wipe key bytes from PowerShell memory (best-effort)
[Array]::Clear($keyBytes, 0, $keyBytes.Length)
[Array]::Clear($verifyBytes, 0, $verifyBytes.Length)

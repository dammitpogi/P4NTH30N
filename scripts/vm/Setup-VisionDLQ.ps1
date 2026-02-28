<#
.SYNOPSIS
	Creates the V1S10N_DLQ MongoDB collection with indexes.

.DESCRIPTION
	Sets up the Vision Dead Letter Queue collection in MongoDB for H4NDv2
	CDP command failures. Commands that fail delivery or processing are
	dead-lettered here for replay/diagnosis.

	Creates:
	  - V1S10N_DLQ collection in P4NTHE0N database
	  - Index on Timestamp (descending) for time-ordered queries
	  - Index on Reprocessed (ascending) for unprocessed lookups
	  - Compound index on Source + Timestamp for per-source queries
	  - TTL index: auto-expire entries after 30 days (configurable)

	Idempotent: safe to re-run. Uses createIndex which is a no-op if index exists.

.PARAMETER ConnectionString
	MongoDB connection string. Default: mongodb://localhost:27017

.PARAMETER DatabaseName
	Target database. Default: P4NTHE0N

.PARAMETER CollectionName
	Collection name. Default: V1S10N_DLQ

.PARAMETER TTLDays
	TTL in days for auto-expiry. Default: 30. Set 0 to skip TTL index.

.EXAMPLE
	.\Setup-VisionDLQ.ps1
	.\Setup-VisionDLQ.ps1 -ConnectionString "mongodb://192.168.56.1:27017"

.NOTES
	Part of INFRA-VM-001. Requires mongosh or MongoDB tools on PATH.
#>

[CmdletBinding()]
param(
	[string]$ConnectionString = "mongodb://localhost:27017",
	[string]$DatabaseName = "P4NTHE0N",
	[string]$CollectionName = "V1S10N_DLQ",
	[int]$TTLDays = 30
)

$ErrorActionPreference = "Stop"

function Write-Status {
	param($Message, $Type = "INFO")
	$symbol = switch ($Type) {
		"SUCCESS" { "[OK]"; $color = "Green" }
		"ERROR"   { "[!!]"; $color = "Red" }
		"WARN"    { "[??]"; $color = "Yellow" }
		default   { "[..]"; $color = "Cyan" }
	}
	Write-Host "$symbol $Message" -ForegroundColor $color
}

Write-Host ""
Write-Host "P4NTHE0N V1S10N_DLQ Setup (INFRA-VM-001)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Connection: $ConnectionString"
Write-Host "  Database:   $DatabaseName"
Write-Host "  Collection: $CollectionName"
Write-Host "  TTL:        $TTLDays days"
Write-Host ""

# ── Detect mongosh or mongo ──────────────────────────────────────────────
$mongosh = Get-Command "mongosh" -ErrorAction SilentlyContinue
$mongo = Get-Command "mongo" -ErrorAction SilentlyContinue

if ($mongosh) {
	$shellCmd = "mongosh"
	Write-Status "Using mongosh" "SUCCESS"
} elseif ($mongo) {
	$shellCmd = "mongo"
	Write-Status "Using legacy mongo shell" "WARN"
} else {
	Write-Status "Neither mongosh nor mongo found on PATH." "ERROR"
	Write-Status "Install MongoDB Shell: https://www.mongodb.com/try/download/shell" "INFO"
	exit 1
}

# ── Build JavaScript commands ────────────────────────────────────────────
$ttlSeconds = $TTLDays * 86400

$jsScript = @"
// V1S10N_DLQ collection setup — INFRA-VM-001
// Idempotent: createCollection is no-op if exists, createIndex is no-op if exists

db = db.getSiblingDB('$DatabaseName');

// Create collection (no-op if exists)
try {
	db.createCollection('$CollectionName');
	print('[OK] Collection $CollectionName created');
} catch (e) {
	if (e.codeName === 'NamespaceExists' || e.code === 48) {
		print('[OK] Collection $CollectionName already exists');
	} else {
		throw e;
	}
}

// Index 1: Timestamp descending — time-ordered queries
db.$CollectionName.createIndex(
	{ "Timestamp": -1 },
	{ name: "idx_timestamp_desc" }
);
print('[OK] Index idx_timestamp_desc created/verified');

// Index 2: Reprocessed flag — fast unprocessed lookups
db.$CollectionName.createIndex(
	{ "Reprocessed": 1 },
	{ name: "idx_reprocessed" }
);
print('[OK] Index idx_reprocessed created/verified');

// Index 3: Source + Timestamp compound — per-source queries
db.$CollectionName.createIndex(
	{ "Source": 1, "Timestamp": -1 },
	{ name: "idx_source_timestamp" }
);
print('[OK] Index idx_source_timestamp created/verified');

// Index 4: CommandType for filtering by command type
db.$CollectionName.createIndex(
	{ "CommandType": 1 },
	{ name: "idx_command_type" }
);
print('[OK] Index idx_command_type created/verified');
"@

# Add TTL index if configured
if ($TTLDays -gt 0) {
	$jsScript += @"

// Index 5: TTL — auto-expire after $TTLDays days
db.$CollectionName.createIndex(
	{ "Timestamp": 1 },
	{ name: "idx_ttl", expireAfterSeconds: $ttlSeconds }
);
print('[OK] TTL index created/verified ($TTLDays days)');
"@
}

$jsScript += @"

// Print collection stats
var stats = db.$CollectionName.stats();
print('Collection size: ' + stats.count + ' documents, ' + stats.storageSize + ' bytes');
print('[OK] V1S10N_DLQ setup complete');
"@

# ── Execute ──────────────────────────────────────────────────────────────
$tempFile = Join-Path $env:TEMP "v1s10n-dlq-setup.js"
Set-Content -Path $tempFile -Value $jsScript -Encoding UTF8

Write-Status "Executing MongoDB setup..."

try {
	$output = & $shellCmd $ConnectionString --quiet --file $tempFile 2>&1
	$output | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }

	if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
		Write-Status "V1S10N_DLQ setup complete." "SUCCESS"
	} else {
		Write-Status "MongoDB script returned exit code $LASTEXITCODE" "ERROR"
		exit 1
	}
} catch {
	Write-Status "Failed to execute MongoDB script: $($_.Exception.Message)" "ERROR"
	Write-Status "Ensure MongoDB is running and accessible at $ConnectionString" "INFO"
	exit 1
} finally {
	Remove-Item $tempFile -ErrorAction SilentlyContinue
}

Write-Host ""
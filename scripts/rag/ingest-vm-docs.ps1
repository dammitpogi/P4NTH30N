# OPS_011: Ingest VM deployment documentation into RAG vector store.
# Requires RAG.McpHost to be running (src/RAG.McpHost).

param(
	[string]$DocsRoot = "C:\P4NTH30N\docs",
	[string]$RagEndpoint = "http://localhost:5302",
	[switch]$DryRun
)

$ErrorActionPreference = "Continue"

Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "OPS_011: Ingest VM Deployment Docs to RAG" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

# Collect all markdown docs for ingestion
$docFiles = @(
	"$DocsRoot\vm-deployment\architecture.md",
	"$DocsRoot\vm-deployment\network-setup.md",
	"$DocsRoot\vm-deployment\chrome-cdp-config.md",
	"$DocsRoot\vm-deployment\troubleshooting.md",
	"$DocsRoot\disaster-recovery\runbook.md",
	"$DocsRoot\jackpot_selectors.md",
	"$DocsRoot\DEPLOYMENT_GUIDE.md",
	"$DocsRoot\DISASTER_RECOVERY.md"
)

$found = 0; $missing = 0
foreach ($file in $docFiles) {
	if (Test-Path $file) {
		$found++
		$name = $file.Replace($DocsRoot, "").TrimStart("\")
		Write-Host "  Found: $name" -ForegroundColor Green
	} else {
		$missing++
		Write-Host "  Missing: $file" -ForegroundColor Yellow
	}
}

Write-Host ""
Write-Host "Files: $found found, $missing missing" -ForegroundColor White

if ($DryRun) {
	Write-Host ""
	Write-Host "[DRY RUN] Would ingest $found files to RAG at $RagEndpoint" -ForegroundColor Yellow
	Write-Host "Run without -DryRun to execute ingestion." -ForegroundColor Yellow
	exit 0
}

# Attempt ingestion via RAG endpoint
Write-Host ""
Write-Host "Ingesting to RAG..." -ForegroundColor Yellow

$ingested = 0; $errors = 0
foreach ($file in $docFiles) {
	if (-not (Test-Path $file)) { continue }

	$name = Split-Path $file -Leaf
	$content = Get-Content $file -Raw
	$payload = @{
		filePath = $file
		content = $content
		metadata = @{
			source = "ops-documentation"
			category = "vm-deployment"
		}
	} | ConvertTo-Json -Depth 5

	try {
		$response = Invoke-RestMethod -Uri "$RagEndpoint/ingest" -Method POST -Body $payload -ContentType "application/json" -TimeoutSec 30
		$ingested++
		Write-Host "  Ingested: $name" -ForegroundColor Green
	} catch {
		$errors++
		Write-Host "  Failed: $name — $_" -ForegroundColor Red
	}
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "Ingestion complete: $ingested succeeded, $errors failed" -ForegroundColor $(if ($errors -eq 0) { "Green" } else { "Yellow" })
Write-Host ("=" * 60) -ForegroundColor Cyan

if ($errors -gt 0) {
	Write-Host ""
	Write-Host "Note: RAG.McpHost may not be running. Start it with:" -ForegroundColor Yellow
	Write-Host "  dotnet run --project src/RAG.McpHost/RAG.McpHost.csproj" -ForegroundColor White
}

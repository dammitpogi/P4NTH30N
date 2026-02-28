<#
.SYNOPSIS
    Automated decision scaffolding tool for P4NTHE0N agents.
.DESCRIPTION
    Creates a new decision file from the standard template with pre-filled metadata.
    Any agent with sub-decision authority can use this tool.
.PARAMETER DecisionId
    Unique decision identifier (e.g., "FORGE-004", "TEST-036").
.PARAMETER Title
    Short title for the decision.
.PARAMETER Author
    Agent creating the decision (e.g., "WindFixer", "Forgewright").
.PARAMETER Priority
    Priority level: Critical, High, Medium, Low.
.PARAMETER Category
    Decision category: INFRA, TEST, FEAT, MIGRATE, FORGE, OPS, ARCH, RAG.
.PARAMETER TokenBudget
    Estimated token budget for implementation.
.PARAMETER Model
    Recommended model for implementation.
.EXAMPLE
    .\Create-Decision.ps1 -DecisionId "FORGE-004" -Title "Fix retry logic" -Author "Forgewright" -Priority "High" -Category "FORGE"
#>
param(
    [Parameter(Mandatory)][string]$DecisionId,
    [Parameter(Mandatory)][string]$Title,
    [Parameter(Mandatory)][string]$Author,
    [ValidateSet("Critical","High","Medium","Low")][string]$Priority = "Medium",
    [ValidateSet("INFRA","TEST","FEAT","MIGRATE","FORGE","OPS","ARCH","RAG")][string]$Category = "FORGE",
    [int]$TokenBudget = 50000,
    [string]$Model = "Claude 3.5 Sonnet"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$templatePath = Join-Path $repoRoot "STR4TEG15T\decisions\_templates\DECISION-TEMPLATE.md"
$outputDir = Join-Path $repoRoot "STR4TEG15T\decisions\active"
$outputPath = Join-Path $outputDir "DECISION_$($DecisionId -replace '-','_').md"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

if (Test-Path $outputPath) {
    Write-Error "Decision file already exists: $outputPath"
    exit 1
}

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

if (Test-Path $templatePath) {
    $content = Get-Content $templatePath -Raw
} else {
    $content = @"
# DECISION: {DECISION_ID} - {TITLE}

**Status**: PROPOSED
**Author**: {AUTHOR}
**Created**: {DATE}
**Priority**: {PRIORITY}
**Category**: {CATEGORY}

---

## Problem Statement

_Describe the problem this decision addresses._

## Proposed Solution

_Describe the solution approach._

## Files to Create

_List new files._

## Files to Modify

_List existing files to change._

## Success Criteria

_Define measurable success metrics._

## Token Budget

- **Estimated**: {TOKEN_BUDGET} tokens
- **Model**: {MODEL}

## Bug-Fix Section

- **On syntax error**: Auto-fix inline
- **On logic error**: Delegate to Forgewright
- **On config error**: Delegate to OpenFixer

## Sub-Decision Authority

- Oracle: Validation sub-decisions
- Designer: Architecture sub-decisions

## Consultation Log

| Date | Agent | Topic | Outcome |
|------|-------|-------|---------|

---

*Created by {AUTHOR} via decision-creator tool at {TIMESTAMP}*
"@
}

$content = $content `
    -replace '\{DECISION_ID\}', $DecisionId `
    -replace '\{TITLE\}', $Title `
    -replace '\{AUTHOR\}', $Author `
    -replace '\{DATE\}', $date `
    -replace '\{PRIORITY\}', $Priority `
    -replace '\{CATEGORY\}', $Category `
    -replace '\{TOKEN_BUDGET\}', $TokenBudget `
    -replace '\{MODEL\}', $Model `
    -replace '\{TIMESTAMP\}', $timestamp

Set-Content -Path $outputPath -Value $content -Encoding UTF8
Write-Host "Decision created: $outputPath" -ForegroundColor Green

# Update the decisions index
$indexPath = Join-Path $repoRoot "STR4TEG15T\.index\decisions.json"
if (Test-Path $indexPath) {
    $index = Get-Content $indexPath -Raw | ConvertFrom-Json
} else {
    $index = @{ decisions = @() }
}

$entry = @{
    id = $DecisionId
    title = $Title
    author = $Author
    priority = $Priority
    category = $Category
    status = "PROPOSED"
    created = $date
    file = "decisions/active/DECISION_$($DecisionId -replace '-','_').md"
}

$index.decisions += $entry
$index | ConvertTo-Json -Depth 10 | Set-Content $indexPath -Encoding UTF8
Write-Host "Index updated: $indexPath" -ForegroundColor Cyan

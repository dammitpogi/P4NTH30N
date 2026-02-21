<#
.SYNOPSIS
    Token usage analytics and budget alerts for P4NTH30N agents.
.DESCRIPTION
    Tracks token consumption per decision, agent, and model.
    Alerts at 80% budget, halts at 100%.
.PARAMETER Action
    Action to perform: Record, Report, Alert, Reset.
.PARAMETER DecisionId
    Decision being worked on.
.PARAMETER Agent
    Agent consuming tokens.
.PARAMETER Model
    Model used (e.g., "Claude 3.5 Sonnet", "GPT-4o Mini").
.PARAMETER TokensUsed
    Number of tokens consumed in this operation.
.PARAMETER Budget
    Total token budget for the decision (used with Record action).
.EXAMPLE
    .\Track-Tokens.ps1 -Action Record -DecisionId "TEST-035" -Agent "WindFixer" -Model "Claude 3.5 Sonnet" -TokensUsed 15000 -Budget 200000
.EXAMPLE
    .\Track-Tokens.ps1 -Action Report
#>
param(
    [Parameter(Mandatory)][ValidateSet("Record","Report","Alert","Reset")][string]$Action,
    [string]$DecisionId = "",
    [string]$Agent = "",
    [string]$Model = "",
    [int]$TokensUsed = 0,
    [int]$Budget = 0
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$dataDir = Join-Path $repoRoot "STR4TEG15T\tools\token-tracker\data"
if (-not (Test-Path $dataDir)) { New-Item -ItemType Directory -Path $dataDir -Force | Out-Null }

$ledgerPath = Join-Path $dataDir "token-ledger.json"
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

function Get-Ledger {
    if (Test-Path $ledgerPath) {
        return Get-Content $ledgerPath -Raw | ConvertFrom-Json
    }
    return @{
        entries = @()
        budgets = @{}
        totalTokens = 0
        lastUpdated = $timestamp
    }
}

function Save-Ledger($ledger) {
    $ledger.lastUpdated = $timestamp
    $ledger | ConvertTo-Json -Depth 10 | Set-Content $ledgerPath -Encoding UTF8
}

switch ($Action) {
    "Record" {
        if (-not $DecisionId -or -not $Agent -or $TokensUsed -le 0) {
            Write-Error "Record requires: DecisionId, Agent, TokensUsed (>0)"
            exit 1
        }

        $ledger = Get-Ledger
        $entry = @{
            timestamp = $timestamp
            decisionId = $DecisionId
            agent = $Agent
            model = $Model
            tokensUsed = $TokensUsed
        }
        $ledger.entries += $entry
        $ledger.totalTokens = ($ledger.totalTokens -as [int]) + $TokensUsed

        if ($Budget -gt 0) {
            if (-not $ledger.budgets) { $ledger.budgets = @{} }
            $ledger.budgets[$DecisionId] = $Budget
        }

        Save-Ledger $ledger

        # Check budget alerts
        if ($ledger.budgets -and $ledger.budgets[$DecisionId]) {
            $decisionBudget = $ledger.budgets[$DecisionId] -as [int]
            $decisionUsed = ($ledger.entries | Where-Object { $_.decisionId -eq $DecisionId } | Measure-Object -Property tokensUsed -Sum).Sum
            $pct = [math]::Round(($decisionUsed / $decisionBudget) * 100, 1)

            if ($pct -ge 100) {
                Write-Host "HALT: $DecisionId budget EXCEEDED ($pct%): $decisionUsed / $decisionBudget tokens" -ForegroundColor Red
            } elseif ($pct -ge 80) {
                Write-Host "ALERT: $DecisionId at $pct% budget: $decisionUsed / $decisionBudget tokens" -ForegroundColor Yellow
            } else {
                Write-Host "OK: $DecisionId at $pct% budget: $decisionUsed / $decisionBudget tokens" -ForegroundColor Green
            }
        }

        Write-Host "Recorded: $TokensUsed tokens for $Agent on $DecisionId ($Model)" -ForegroundColor Cyan
    }

    "Report" {
        $ledger = Get-Ledger
        if (-not $ledger.entries -or $ledger.entries.Count -eq 0) {
            Write-Host "No token usage recorded yet." -ForegroundColor Yellow
            return
        }

        Write-Host "`n=== Token Usage Report ===" -ForegroundColor Cyan
        Write-Host "Total tokens: $($ledger.totalTokens)" -ForegroundColor White
        Write-Host "Total entries: $($ledger.entries.Count)" -ForegroundColor White
        Write-Host ""

        # By decision
        Write-Host "--- By Decision ---" -ForegroundColor Cyan
        $ledger.entries | Group-Object -Property decisionId | ForEach-Object {
            $sum = ($_.Group | Measure-Object -Property tokensUsed -Sum).Sum
            $budget = if ($ledger.budgets -and $ledger.budgets[$_.Name]) { $ledger.budgets[$_.Name] } else { "N/A" }
            Write-Host "  $($_.Name): $sum tokens (budget: $budget)"
        }

        # By agent
        Write-Host "`n--- By Agent ---" -ForegroundColor Cyan
        $ledger.entries | Group-Object -Property agent | ForEach-Object {
            $sum = ($_.Group | Measure-Object -Property tokensUsed -Sum).Sum
            Write-Host "  $($_.Name): $sum tokens"
        }

        # By model
        Write-Host "`n--- By Model ---" -ForegroundColor Cyan
        $ledger.entries | Where-Object { $_.model } | Group-Object -Property model | ForEach-Object {
            $sum = ($_.Group | Measure-Object -Property tokensUsed -Sum).Sum
            Write-Host "  $($_.Name): $sum tokens"
        }
    }

    "Alert" {
        $ledger = Get-Ledger
        $alerts = @()

        if ($ledger.budgets) {
            $ledger.budgets.PSObject.Properties | ForEach-Object {
                $did = $_.Name
                $budget = $_.Value -as [int]
                $used = ($ledger.entries | Where-Object { $_.decisionId -eq $did } | Measure-Object -Property tokensUsed -Sum).Sum
                $pct = if ($budget -gt 0) { [math]::Round(($used / $budget) * 100, 1) } else { 0 }

                if ($pct -ge 80) {
                    $alerts += @{ decision = $did; used = $used; budget = $budget; pct = $pct }
                }
            }
        }

        if ($alerts.Count -eq 0) {
            Write-Host "No budget alerts." -ForegroundColor Green
        } else {
            foreach ($a in $alerts) {
                $color = if ($a.pct -ge 100) { "Red" } else { "Yellow" }
                $label = if ($a.pct -ge 100) { "EXCEEDED" } else { "WARNING" }
                Write-Host "${label}: $($a.decision) at $($a.pct)% ($($a.used)/$($a.budget) tokens)" -ForegroundColor $color
            }
        }
    }

    "Reset" {
        if ($DecisionId) {
            $ledger = Get-Ledger
            $ledger.entries = @($ledger.entries | Where-Object { $_.decisionId -ne $DecisionId })
            $ledger.totalTokens = ($ledger.entries | Measure-Object -Property tokensUsed -Sum).Sum
            Save-Ledger $ledger
            Write-Host "Reset token tracking for $DecisionId" -ForegroundColor Yellow
        } else {
            @{ entries = @(); budgets = @{}; totalTokens = 0; lastUpdated = $timestamp } | ConvertTo-Json -Depth 10 | Set-Content $ledgerPath -Encoding UTF8
            Write-Host "All token tracking reset." -ForegroundColor Yellow
        }
    }
}

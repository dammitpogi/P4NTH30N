# Update-Manifest.ps1
# WindFixer Manifest Update Script
# Updates STR4TEG15T/memory/manifest/manifest.json with new round entry

param(
    [Parameter(Mandatory=$true)]
    [string]$DecisionId,
    
    [Parameter(Mandatory=$true)]
    [string]$SessionContext,
    
    [Parameter(Mandatory=$true)]
    [string]$Summary,
    
    [Parameter(Mandatory=$false)]
    [int]$FilesModified = 0,
    
    [Parameter(Mandatory=$false)]
    [int]$LinesAdded = 0,
    
    [Parameter(Mandatory=$false)]
    [int]$OracleApproval = 0,
    
    [Parameter(Mandatory=$false)]
    [int]$DesignerApproval = 0,
    
    [Parameter(Mandatory=$false)]
    [string]$Tone = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Theme = "",
    
    [Parameter(Mandatory=$false)]
    [string]$KeyMoment = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Emotion = ""
)

# Paths
$ManifestPath = "c:\P4NTH30N\STR4TEG15T\memory\manifest\manifest.json"

# Function to get next round ID
function Get-NextRoundId {
    param([string]$ManifestContent)
    
    # Extract existing round IDs
    $pattern = '"roundId":\s*"R(\d+)"'
    $roundMatches = [regex]::Matches($ManifestContent, $pattern)
    
    $maxId = 0
    foreach ($match in $roundMatches) {
        $id = [int]$match.Groups[1].Value
        if ($id -gt $maxId) {
            $maxId = $id
        }
    }
    
    return "R{0:D3}" -f ($maxId + 1)
}

# Function to create round entry
function New-RoundEntry {
    param(
        [string]$RoundId,
        [string]$DecisionId,
        [string]$SessionContext,
        [string]$Summary,
        [int]$FilesModified,
        [int]$LinesAdded,
        [int]$OracleApproval,
        [int]$DesignerApproval,
        [string]$Tone,
        [string]$Theme,
        [string]$KeyMoment,
        [string]$Emotion
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    
    $roundEntry = @{
        roundId = $RoundId
        timestamp = $timestamp
        sessionContext = "$DecisionId - $SessionContext"
        agent = "WindFixer"
        summary = $Summary
        decisions = @{
            completed = @(
                @{
                    id = $DecisionId
                    title = "WindFixer Implementation: $DecisionId"
                    status = "Completed"
                    validation = "Implementation completed with audit and manifest update"
                }
            )
        }
        metrics = @{
            filesModified = $FilesModified
            linesAdded = $LinesAdded
            oracleApproval = $OracleApproval
            designerApproval = $DesignerApproval
        }
        narrative = @{
            tone = $Tone
            theme = $Theme
            keyMoment = $KeyMoment
            emotion = $Emotion
        }
        synthesized = $false
    }
    
    return $roundEntry
}

# Main execution
try {
    # Read existing manifest
    if (Test-Path $ManifestPath) {
        $manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
    } else {
        throw "Manifest file not found: $ManifestPath"
    }
    
    # Get next round ID
    $roundId = Get-NextRoundId -ManifestContent (Get-Content $ManifestPath -Raw)
    
    # Create new round entry
    $newRound = New-RoundEntry -RoundId $roundId -DecisionId $DecisionId -SessionContext $SessionContext -Summary $Summary -FilesModified $FilesModified -LinesAdded $LinesAdded -OracleApproval $OracleApproval -DesignerApproval $DesignerApproval -Tone $Tone -Theme $Theme -KeyMoment $KeyMoment -Emotion $Emotion
    
    # Add new round to manifest
    $manifest.rounds = @($newRound) + $manifest.rounds
    
    # Update timestamps
    $manifest.lastUpdated = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $manifest.lastReconciled = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    
    # Save updated manifest
    $manifestJson = $manifest | ConvertTo-Json -Depth 10
    $manifestJson | Set-Content $ManifestPath
    
    Write-Host "Manifest updated successfully!" -ForegroundColor Green
    Write-Host "Round ID: $roundId" -ForegroundColor Cyan
    Write-Host "Decision: $DecisionId" -ForegroundColor Cyan
    Write-Host "Session: $SessionContext" -ForegroundColor Cyan
    
} catch {
    Write-Error "Error updating manifest: $($_.Exception.Message)"
    exit 1
}

# Usage example:
# .\Update-Manifest.ps1 -DecisionId "DECISION_XXX" -SessionContext "Implementation completed" -Summary "WindFixer implemented governance patterns" -FilesModified 5 -LinesAdded 200 -OracleApproval 95 -DesignerApproval 90 -Tone "methodical" -Theme "governance" -KeyMoment "First manifest update" -Emotion "satisfaction"
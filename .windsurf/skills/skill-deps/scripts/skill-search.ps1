# Search ClawHub registry for skills (Windows PowerShell version)

param(
    [Parameter(Mandatory=$true)]
    [string]$Query
)

# Colors
$colors = @{
    Green = "Green"
    Yellow = "Yellow"
    Cyan = "Cyan"
    NC = "White"
}

# Mock ClawHub search API (replace with real API when available)
function Search-Registry {
    param([string]$query)
    
    # This would normally call the real ClawHub search API
    # For now, return mock results
    $allSkills = @(
        @{
            name = "weather"
            description = "Weather information and forecasts"
            tags = @("weather", "api", "forecast")
            downloads = 1250
            rating = 4.8
        },
        @{
            name = "http-client"
            description = "HTTP client for making web requests"
            tags = @("http", "api", "web")
            downloads = 3400
            rating = 4.9
        },
        @{
            name = "calendar"
            description = "Calendar integration and scheduling"
            tags = @("calendar", "schedule", "events")
            downloads = 890
            rating = 4.6
        },
        @{
            name = "coding-agent"
            description = "AI-powered coding assistant"
            tags = @("coding", "ai", "development")
            downloads = 2100
            rating = 4.7
        },
        @{
            name = "browser"
            description = "Web browser automation"
            tags = @("browser", "automation", "web")
            downloads = 1560
            rating = 4.5
        }
    )
    
    # Simple search filter
    $results = $allSkills | Where-Object { 
        $_.name -like "*$Query*" -or 
        $_.description -like "*$Query*" -or
        ($_.tags | Where-Object { $_ -like "*$Query*" })
    }
    
    return $results
}

# Main
Write-Host "`n🔍 Searching ClawHub for: $Query`n" -ForegroundColor $colors.Green

$results = Search-Registry $Query

if ($results.Count -eq 0) {
    Write-Host "❌ No skills found matching '$Query'" -ForegroundColor $colors.Red
    Write-Host "💡 Try different keywords or browse all skills" -ForegroundColor $colors.Yellow
    exit 0
}

Write-Host "Found $($results.Count) skills:`n" -ForegroundColor $colors.Cyan

foreach ($skill in $results) {
    $tags = $skill.tags -join ", "
    Write-Host "📦 $($skill.name)" -ForegroundColor $colors.Green
    Write-Host "   $($skill.description)" -ForegroundColor $colors.White
    Write-Host "   Tags: $tags" -ForegroundColor $colors.Cyan
    Write-Host "   ⭐ $($skill.rating)/5.0 (📥 $($skill.downloads) downloads)"
    Write-Host ""
}

Write-Host "💡 Install with: skill-install.ps1 <skill-name>" -ForegroundColor $colors.Yellow

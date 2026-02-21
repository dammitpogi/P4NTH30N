# Register FourEyes MCP server in WindSurf's MCP configuration
# Run this script to add foureyes-mcp to WindSurf's MCP config

$configPath = "$env:USERPROFILE\.codeium\windsurf\mcp_config.json"

if (-not (Test-Path $configPath)) {
    Write-Host "[ERROR] WindSurf MCP config not found at: $configPath"
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json

# Add foureyes-mcp entry
$fourEyesConfig = @{
    command = "node"
    args = @("C:/P4NTH30N/tools/mcp-foureyes/server.js", "stdio")
    env = @{
        CDP_HOST = "192.168.56.1"
        CDP_PORT = "9222"
        LMSTUDIO_URL = "http://localhost:1234"
    }
}

if (-not $config.mcpServers) {
    $config | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue @{}
}

$config.mcpServers | Add-Member -NotePropertyName "foureyes-mcp" -NotePropertyValue $fourEyesConfig -Force

$config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
Write-Host "[OK] FourEyes MCP registered in WindSurf at: $configPath"
Write-Host "[INFO] Reload WindSurf to activate the new MCP server"

# P4NTHE0N Automated Build Script with MCP Integration
# Builds all projects and ensures MCP configuration is up to date

param(
    [string]$Configuration = "Release",
    [switch]$SkipTests,
    [switch]$DeployAfterBuild,
    [switch]$BackgroundBuild
)

$ErrorActionPreference = "Stop"

Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "P4NTHE0N Automated Build Pipeline" -ForegroundColor Cyan
Write-Host "Configuration: $Configuration | SkipTests: $SkipTests" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan

# Define all projects to build
$projects = @(
    @{
        Name = "C0MMON"
        Path = "C:\P4NTH30N\C0MMON\C0MMON.csproj"
        Order = 1
    },
    @{
        Name = "H0UND"
        Path = "C:\P4NTH30N\H0UND\H0UND.csproj"
        Order = 2
    },
    @{
        Name = "H4ND"
        Path = "C:\P4NTH30N\H4ND\H4ND.csproj"
        Order = 3
    },
    @{
        Name = "W4TCHD0G"
        Path = "C:\P4NTH30N\W4TCHD0G\W4TCHD0G.csproj"
        Order = 4
    },
    @{
        Name = "T00L5ET"
        Path = "C:\P4NTH30N\T00L5ET\T00L5ET.csproj"
        Order = 5
    },
    @{
        Name = "RAG.McpHost"
        Path = "C:\P4NTH30N\src\RAG.McpHost\RAG.McpHost.csproj"
        Order = 6
    }
)

# Step 1: Clean previous builds
Write-Host "`n[1/5] Cleaning previous builds..." -ForegroundColor Yellow

foreach ($project in $projects) {
    $projectDir = Split-Path $project.Path -Parent
    $binDir = Join-Path $projectDir "bin"
    $objDir = Join-Path $projectDir "obj"
    
    if (Test-Path $binDir) {
        Remove-Item $binDir -Recurse -Force
        Write-Host "  Cleaned $($project.Name) bin" -ForegroundColor Gray
    }
    
    if (Test-Path $objDir) {
        Remove-Item $objDir -Recurse -Force
        Write-Host "  Cleaned $($project.Name) obj" -ForegroundColor Gray
    }
}

# Step 2: Build all projects in order
Write-Host "`n[2/5] Building all projects..." -ForegroundColor Yellow

$projects = $projects | Sort-Object Order

foreach ($project in $projects) {
    Write-Host "  Building $($project.Name)..." -ForegroundColor Gray
    
    if ($BackgroundBuild) {
        $job = Start-Job -ScriptBlock {
            param($ProjectPath, $Config)
            dotnet build $ProjectPath -c $Config --no-incremental
            return $LASTEXITCODE
        } -ArgumentList $project.Path, $Configuration
        
        $result = Receive-Job -Job $job -Wait
        Remove-Job -Job $job
        
        if ($result -ne 0) { 
            throw "Build failed for $($project.Name)" 
        }
    } else {
        dotnet build $project.Path -c $Configuration --no-incremental
        if ($LASTEXITCODE -ne 0) { 
            throw "Build failed for $($project.Name)" 
        }
    }
    
    Write-Host "    $($project.Name) built successfully" -ForegroundColor Green
}

# Step 3: Run tests
if (-not $SkipTests) {
    Write-Host "`n[3/5] Running tests..." -ForegroundColor Yellow
    
    try {
        dotnet run --project C:\P4NTH30N\UNI7T35T\UNI7T35T.csproj
        Write-Host "  All tests passed" -ForegroundColor Green
    } catch {
        Write-Host "  Tests failed: $_" -ForegroundColor Red
        throw
    }
} else {
    Write-Host "`n[3/5] Tests skipped" -ForegroundColor DarkGray
}

# Step 4: Update MCP configurations
Write-Host "`n[4/5] Updating MCP configurations..." -ForegroundColor Yellow

# Ensure MCP config directories exist
$mcpDir = "C:\P4NTH30N\.mcp"
$windsurfDir = "C:\P4NTH30N\.windsurf"

if (-not (Test-Path $mcpDir)) { New-Item -ItemType Directory -Path $mcpDir -Force | Out-Null }
if (-not (Test-Path $windsurfDir)) { New-Item -ItemType Directory -Path $windsurfDir -Force | Out-Null }

# Update Visual Studio MCP config
$vsMcpConfig = @{
    version = "1.0"
    inputs = @{
        solution_path = "C:\P4NTH30N\P4NTHE0N.slnx"
        rag_enabled = "true"
        chrome_cdp_port = "9222"
    }
    servers = @{
        "p4ntheon-rag" = @{
            type = "stdio"
            command = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
            args = @("--port", "5100", "--index", "p4ntheon", "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx", "--mongo", "localhost:27017", "--workspace", "C:\P4NTH30N")
            env = @{
                RAG_ENABLED = "${input:rag_enabled}"
                CHROME_CDP_PORT = "${input:chrome_cdp_port}"
            }
            disabled = $false
        }
        "chrome-devtools" = @{
            type = "http"
            url = "http://localhost:5301/mcp"
            disabled = $false
        }
        "p4ntheon-tools" = @{
            type = "stdio"
            command = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
            args = @("--mcp", "--workspace", "C:\P4NTH30N")
            disabled = $false
        }
    }
}

$vsMcpConfig | ConvertTo-Json -Depth 10 | Out-File "$mcpDir\mcp.json" -Encoding UTF8 -Force
Write-Host "  Updated Visual Studio MCP config" -ForegroundColor Green

# Update WindSurf MCP config
$wsMcpConfig = @{
    mcpServers = @{
        "p4ntheon-rag" = @{
            command = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
            args = @("--port", "5100", "--index", "p4ntheon", "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx", "--mongo", "localhost:27017", "--workspace", "C:\P4NTH30N")
            env = @{
                RAG_ENABLED = "true"
                CHROME_CDP_PORT = "9222"
            }
        }
        "chrome-devtools" = @{
            command = "node"
            args = @("c:\P4NTH30N\chrome-devtools-mcp\server.js")
        }
        "p4ntheon-tools" = @{
            command = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
            args = @("--mcp", "--workspace", "C:\P4NTH30N")
        }
    }
}

$wsMcpConfig | ConvertTo-Json -Depth 10 | Out-File "$windsurfDir\mcp_config.json" -Encoding UTF8 -Force
Write-Host "  Updated WindSurf MCP config" -ForegroundColor Green

# Step 5: Create T00L5ET deploy manifest
Write-Host "  Creating T00L5ET deploy manifest..." -ForegroundColor Gray

$t00l5etManifest = @{
    agents = @(
        @{
            name = "P4NTHE0N Tools"
            source = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\P4NTHE0N.Tools.dll"
            destination = "C:\Users\paulc\.config\opencode\agents\P4NTHE0N-Tools.json"
        }
    )
    mcp = @(
        @{
            name = "P4NTHE0N Tools MCP"
            source = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
            args = @("--mcp", "--workspace", "C:\P4NTH30N")
            destination = "C:\Users\paulc\.config\opencode\mcp\P4NTHE0N-Tools.json"
        }
    )
    binaries = @(
        @{
            name = "T00L5ET.exe"
            source = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
            destination = "C:\ProgramData\P4NTH30N\bin\T00L5ET.exe"
        }
    )
}

$t00l5etManifest | ConvertTo-Json -Depth 10 | Out-File "C:\P4NTH30N\T00L5ET\deploy-manifest.json" -Encoding UTF8 -Force
Write-Host "  Created T00L5ET deploy manifest" -ForegroundColor Green

# Copy manifest to publish location
$toolsPublishDir = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish"
if (Test-Path $toolsPublishDir) {
    Copy-Item "C:\P4NTH30N\T00L5ET\deploy-manifest.json" "$toolsPublishDir\deploy-manifest.json" -Force
    Write-Host "  Copied manifest to publish directory" -ForegroundColor Gray
}

# Step 6: Deploy after build (if requested)
if ($DeployAfterBuild) {
    Write-Host "`n[5/5] Deploying MCP services..." -ForegroundColor Yellow
    
    try {
        & "C:\P4NTH30N\scripts\deploy-mcp-services.ps1" -Configuration $Configuration -DeployLocal -SkipBuild -SkipTests
        Write-Host "  MCP services deployed successfully" -ForegroundColor Green
    } catch {
        Write-Host "  MCP deployment failed: $_" -ForegroundColor Red
        throw
    }
} else {
    Write-Host "`n[5/5] Build complete" -ForegroundColor Green
}

# Final summary
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "Build Pipeline Complete!" -ForegroundColor Green
Write-Host ("=" * 70) -ForegroundColor Cyan

Write-Host "`nBuilt Projects:" -ForegroundColor White
foreach ($project in $projects) {
    $projectPath = Split-Path $project.Path -Parent
    $buildPath = Join-Path $projectPath "bin\$Configuration\net8.0"
    if (Test-Path $buildPath) {
        Write-Host "  $($project.Name): $buildPath" -ForegroundColor Gray
    }
}

Write-Host "`nMCP Configurations Updated:" -ForegroundColor White
Write-Host "  Visual Studio: $mcpDir\mcp.json" -ForegroundColor Gray
Write-Host "  WindSurf: $windsurfDir\mcp_config.json" -ForegroundColor Gray
Write-Host "  T00L5ET Manifest: C:\P4NTH30N\T00L5ET\deploy-manifest.json" -ForegroundColor Gray

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "1. Start MCP services: .\Start-All-MCP-Servers.ps1" -ForegroundColor Gray
Write-Host "2. Verify setup: .\Verify-MCP-Setup.ps1" -ForegroundColor Gray
Write-Host "3. Open Visual Studio Community with P4NTHE0N.slnx" -ForegroundColor Gray
Write-Host "4. Test with Ctrl+I in Visual Studio" -ForegroundColor Gray

if ($DeployAfterBuild) {
    Write-Host "`nDeployment completed. Services should be starting..." -ForegroundColor Green
}

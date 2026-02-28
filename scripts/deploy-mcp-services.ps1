# P4NTHE0N MCP Services Deployment Script
# Automatically builds and deploys all MCP services with proper configuration

param(
    [string]$Configuration = "Release",
    [string]$PublishRoot = "C:\P4NTH30N\publish",
    [switch]$SkipBuild,
    [switch]$SkipTests,
    [switch]$DeployLocal,
    [switch]$DeployVM,
    [string]$VmName = "H4NDv2-Production"
)

$ErrorActionPreference = "Stop"

Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "P4NTHE0N MCP Services Deployment Pipeline" -ForegroundColor Cyan
Write-Host "Config: $Configuration | DeployLocal: $DeployLocal | DeployVM: $DeployVM" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan

# Define projects and their publish configurations
$projects = @(
    @{
        Name = "RAG.McpHost"
        ProjectPath = "C:\P4NTH30N\src\RAG.McpHost\RAG.McpHost.csproj"
        PublishDir = "$PublishRoot\rag-mcp-host"
        BinaryName = "RAG.McpHost.exe"
        ServiceType = "BackgroundJob"
        Port = 5100
        Args = @("--port", "5100", "--index", "p4ntheon", "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx", "--mongo", "localhost:27017", "--workspace", "C:\P4NTH30N", "--transport", "http")
    },
    @{
        Name = "T00L5ET"
        ProjectPath = "C:\P4NTH30N\T00L5ET\T00L5ET.csproj"
        PublishDir = "$PublishRoot\p4ntheon-tools"
        BinaryName = "T00L5ET.exe"
        ServiceType = "Foreground"
        Port = $null
        Args = @("--mcp", "--workspace", "C:\P4NTH30N")
    }
)

# Step 1: Build and Test
if (-not $SkipBuild) {
    Write-Host "`n[1/6] Building all projects..." -ForegroundColor Yellow
    
    foreach ($project in $projects) {
        Write-Host "  Building $($project.Name)..." -ForegroundColor Gray
        dotnet build $project.ProjectPath -c $Configuration --no-incremental
        if ($LASTEXITCODE -ne 0) { throw "Build failed for $($project.Name)" }
    }
    
    Write-Host "  All builds succeeded" -ForegroundColor Green
} else {
    Write-Host "`n[1/6] Build skipped" -ForegroundColor DarkGray
}

if (-not $SkipTests) {
    Write-Host "`n[2/6] Running tests..." -ForegroundColor Yellow
    dotnet run --project C:\P4NTH30N\UNI7T35T\UNI7T35T.csproj
    if ($LASTEXITCODE -ne 0) { throw "Tests failed" }
    Write-Host "  Tests passed" -ForegroundColor Green
} else {
    Write-Host "`n[2/6] Tests skipped" -ForegroundColor DarkGray
}

# Step 2: Publish all projects
Write-Host "`n[3/6] Publishing all projects..." -ForegroundColor Yellow

foreach ($project in $projects) {
    Write-Host "  Publishing $($project.Name)..." -ForegroundColor Gray
    if (Test-Path $project.PublishDir) { Remove-Item $project.PublishDir -Recurse -Force }
    dotnet publish $project.ProjectPath -c $Configuration -r win-x64 -o $project.PublishDir
    if ($LASTEXITCODE -ne 0) { throw "Publish failed for $($project.Name)" }
    
    # Verify binary exists
    $binaryPath = Join-Path $project.PublishDir $project.BinaryName
    if (-not (Test-Path $binaryPath)) {
        throw "Binary not found: $binaryPath"
    }
    
    Write-Host "    Published to $($project.PublishDir)" -ForegroundColor Green
}

# Step 3: Create deployment manifests
Write-Host "`n[4/6] Creating deployment manifests..." -ForegroundColor Yellow

# Create T00L5ET deploy manifest
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

$t00l5etManifest | ConvertTo-Json -Depth 10 | Out-File "$($projects[1].PublishDir)\deploy-manifest.json" -Encoding UTF8 -Force
Write-Host "  Created T00L5ET deploy manifest" -ForegroundColor Green

# Step 4: Create MCP configuration files
Write-Host "`n[5/6] Creating MCP configuration files..." -ForegroundColor Yellow

# Visual Studio MCP config
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
            command = "$($projects[0].PublishDir)\$($projects[0].BinaryName)"
            args = $projects[0].Args
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
            command = "$($projects[1].PublishDir)\$($projects[1].BinaryName)"
            args = $projects[1].Args
            disabled = $false
        }
    }
}

$vsMcpConfig | ConvertTo-Json -Depth 10 | Out-File "$PublishRoot\.mcp\mcp.json" -Encoding UTF8 -Force
Write-Host "  Created Visual Studio MCP config" -ForegroundColor Green

# WindSurf MCP config
$wsMcpConfig = @{
    mcpServers = @{
        "p4ntheon-rag" = @{
            command = "$($projects[0].PublishDir)\$($projects[0].BinaryName)"
            args = $projects[0].Args
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
            command = "$($projects[1].PublishDir)\$($projects[1].BinaryName)"
            args = $projects[1].Args
        }
    }
}

$wsMcpConfig | ConvertTo-Json -Depth 10 | Out-File "$PublishRoot\.windsurf\mcp_config.json" -Encoding UTF8 -Force
Write-Host "  Created WindSurf MCP config" -ForegroundColor Green

# Step 5: Create startup scripts
Write-Host "`n[6/6] Creating startup scripts..." -ForegroundColor Yellow

# Copy management scripts to publish directory
$scriptsToCopy = @(
    "Start-All-MCP-Servers.ps1",
    "Manage-RAG-Background.ps1",
    "Verify-MCP-Setup.ps1",
    "Fix-MCP-Services.ps1"
)

foreach ($script in $scriptsToCopy) {
    $sourcePath = "C:\P4NTH30N\$script"
    $destPath = "$PublishRoot\$script"
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath $destPath -Force
        Write-Host "  Copied $script" -ForegroundColor Gray
    }
}

# Create deployment summary
$deploymentSummary = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    configuration = $Configuration
    projects = $projects | ForEach-Object {
        @{
            name = $_.Name
            publishDir = $_.PublishDir
            binary = $_.BinaryName
            serviceType = $_.ServiceType
            port = $_.Port
        }
    }
    mcpConfigurations = @{
        visualStudio = "$PublishRoot\.mcp\mcp.json"
        windSurf = "$PublishRoot\.windsurf\mcp_config.json"
    }
    startupScripts = $scriptsToCopy | ForEach-Object { "$PublishRoot\$_" }
}

$deploymentSummary | ConvertTo-Json -Depth 10 | Out-File "$PublishRoot\deployment-summary.json" -Encoding UTF8 -Force
Write-Host "  Created deployment summary" -ForegroundColor Green

# Step 6: Local deployment (if requested)
if ($DeployLocal) {
    Write-Host "`n[DEPLOY] Deploying to local machine..." -ForegroundColor Yellow
    
    # Stop existing services
    Write-Host "  Stopping existing MCP services..." -ForegroundColor Gray
    & "C:\P4NTH30N\Start-All-MCP-Servers.ps1" -Stop
    
    # Copy binaries to local locations
    Write-Host "  Copying binaries to local locations..." -ForegroundColor Gray
    
    # Copy RAG binary
    $ragDest = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
    Copy-Item "$($projects[0].PublishDir)\$($projects[0].BinaryName)" $ragDest -Force
    
    # Copy T00L5ET binary
    $toolsDest = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
    Copy-Item "$($projects[1].PublishDir)\$($projects[1].BinaryName)" $toolsDest -Force
    
    # Copy T00L5ET manifest
    Copy-Item "$($projects[1].PublishDir)\deploy-manifest.json" "C:\P4NTH30N\T00L5ET\bin\deploy-manifest.json" -Force
    
    # Update MCP configs
    Copy-Item "$PublishRoot\.mcp\mcp.json" "C:\P4NTH30N\.mcp\mcp.json" -Force
    Copy-Item "$PublishRoot\.windsurf\mcp_config.json" "C:\P4NTH30N\.windsurf\mcp_config.json" -Force
    
    # Start services
    Write-Host "  Starting MCP services..." -ForegroundColor Gray
    & "C:\P4NTH30N\Start-All-MCP-Servers.ps1"
    
    Write-Host "  Local deployment complete" -ForegroundColor Green
}

# Step 7: VM deployment (if requested)
if ($DeployVM) {
    Write-Host "`n[DEPLOY] Deploying to VM '$VmName'..." -ForegroundColor Yellow
    
    $vm = Get-VM -Name $VmName -ErrorAction SilentlyContinue
    if ($null -eq $vm -or $vm.State -ne "Running") {
        Write-Host "  Starting VM..." -ForegroundColor Gray
        Start-VM $VmName -ErrorAction Stop
        Start-Sleep -Seconds 30
    }
    
    try {
        # Stop existing services on VM
        Invoke-Command -VMName $VmName -ScriptBlock {
            Stop-Process -Name "RAG.McpHost" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "T00L5ET" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "node" -Force -ErrorAction SilentlyContinue
        } -ErrorAction Stop
        
        # Copy files to VM
        $session = New-PSSession -VMName $VmName -ErrorAction Stop
        try {
            # Create directories
            Invoke-Command -Session $session -ScriptBlock {
                New-Item -ItemType Directory -Path "C:\P4NTH30N\publish" -Force | Out-Null
                New-Item -ItemType Directory -Path "C:\P4NTH30N\.mcp" -Force | Out-Null
                New-Item -ItemType Directory -Path "C:\P4NTH30N\.windsurf" -Force | Out-Null
            }
            
            # Copy all published files
            Copy-Item -ToSession $session -Path "$PublishRoot\*" -Destination "C:\P4NTH30N\publish" -Recurse -Force
            
            # Copy MCP configs
            Copy-Item -ToSession $session -Path "$PublishRoot\.mcp\*" -Destination "C:\P4NTH30N\.mcp" -Force
            Copy-Item -ToSession $session -Path "$PublishRoot\.windsurf\*" -Destination "C:\P4NTH30N\.windsurf" -Force
            
            Write-Host "  Files deployed to VM" -ForegroundColor Green
        } finally {
            Remove-PSSession $session
        }
        
        # Start services on VM
        Invoke-Command -VMName $VmName -ScriptBlock {
            Set-Location "C:\P4NTH30N"
            & "C:\P4NTH30N\Start-All-MCP-Servers.ps1"
        } -ErrorAction Stop
        
        Write-Host "  VM deployment complete" -ForegroundColor Green
    } catch {
        Write-Host "  VM deployment failed: $_" -ForegroundColor Red
    }
}

# Final summary
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "MCP Services Deployment Complete!" -ForegroundColor Green
Write-Host ("=" * 70) -ForegroundColor Cyan

Write-Host "`nDeployment Summary:" -ForegroundColor White
foreach ($project in $projects) {
    Write-Host "  $($project.Name): $($project.PublishDir)" -ForegroundColor Gray
}

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "1. Run: .\Start-All-MCP-Servers.ps1" -ForegroundColor Gray
Write-Host "2. Open Visual Studio Community with P4NTHE0N.slnx" -ForegroundColor Gray
Write-Host "3. Use Ctrl+I to test MCP functionality" -ForegroundColor Gray
Write-Host "4. Verify with: .\Verify-MCP-Setup.ps1" -ForegroundColor Gray

if ($DeployLocal) {
    Write-Host "`nLocal deployment completed. Services are starting..." -ForegroundColor Green
}

if ($DeployVM) {
    Write-Host "`nVM deployment completed. Services are starting on $VmName..." -ForegroundColor Green
}

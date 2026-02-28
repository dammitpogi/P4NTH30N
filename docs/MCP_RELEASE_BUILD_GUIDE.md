# P4NTHE0N MCP Services Release Build Guide

## Overview

This guide covers the automated build and deployment process for P4NTHE0N MCP services, ensuring all release builds automatically conform to the updated MCP configuration and background job setup.

## Build Pipeline Components

### 1. Automated Build Scripts

#### `scripts/build-all-with-mcp.ps1`
- **Purpose**: Complete build pipeline with MCP integration
- **Features**:
  - Builds all P4NTHE0N projects in dependency order
  - Runs unit tests automatically
  - Updates MCP configurations for both Visual Studio and WindSurf
  - Creates T00L5ET deploy manifest
  - Optional automatic deployment after build

#### `scripts/deploy-mcp-services.ps1`
- **Purpose**: Dedicated MCP services deployment
- **Features**:
  - Publishes RAG.McpHost and T00L5ET
  - Generates MCP configuration files
  - Creates startup scripts
  - Supports local and VM deployment
  - Generates deployment summary

#### `scripts/deploy-h4nd-vm.ps1` (Updated)
- **Purpose**: H4ND VM deployment with MCP support
- **Updates**:
  - Updated MongoDB connection to localhost:27017
  - Added MCP configuration section
  - Integrated with new service architecture

### 2. GitHub Actions Workflow

#### `.github/workflows/build-deploy-mcp.yml`
- **Triggers**:
  - Push to main/develop branches
  - Pull requests to main
  - Manual workflow dispatch
- **Jobs**:
  - `build-and-test`: Build, test, and publish all services
  - `deploy-staging`: Deploy to staging environment (develop branch)
  - `deploy-production`: Deploy to production (main branch)
  - `verify-deployment`: Health check all MCP services

## MCP Configuration Updates

### Automatic Configuration Updates

All release builds automatically update:

1. **Visual Studio MCP Config** (`.mcp/mcp.json`)
   ```json
   {
     "version": "1.0",
     "servers": {
       "p4ntheon-rag": {
         "type": "stdio",
         "command": "C:\\P4NTH30N\\src\\RAG.McpHost\\bin\\Release\\net8.0\\win-x64\\publish\\RAG.McpHost.exe",
         "args": ["--port", "5100", "--mongo", "localhost:27017", ...]
       },
       "chrome-devtools": {
         "type": "http",
         "url": "http://localhost:5301/mcp"
       },
       "p4ntheon-tools": {
         "type": "stdio",
         "command": "C:\\P4NTH30N\\T00L5ET\\bin\\Release\\net8.0\\win-x64\\publish\\T00L5ET.exe",
         "args": ["--mcp", "--workspace", "C:\\P4NTH30N"]
       }
     }
   }
   ```

2. **WindSurf MCP Config** (`.windsurf/mcp_config.json`)
   ```json
   {
     "mcpServers": {
       "p4ntheon-rag": {
         "command": "C:\\P4NTH30N\\src\\RAG.McpHost\\bin\\Release\\net8.0\\win-x64\\publish\\RAG.McpHost.exe",
         "args": ["--port", "5100", "--mongo", "localhost:27017", ...]
       },
       "chrome-devtools": {
         "command": "node",
         "args": ["c:\\P4NTH30N\\chrome-devtools-mcp\\server.js"]
       },
       "p4ntheon-tools": {
         "command": "C:\\P4NTH30N\\T00L5ET\\bin\\Release\\net8.0\\win-x64\\publish\\T00L5ET.exe",
         "args": ["--mcp", "--workspace", "C:\\P4NTH30N"]
       }
     }
   }
   ```

3. **T00L5ET Deploy Manifest** (`T00L5ET/deploy-manifest.json`)
   ```json
   {
     "agents": [...],
     "mcp": [
       {
         "name": "P4NTHE0N Tools MCP",
         "source": "C:\\P4NTH30N\\T00L5ET\\bin\\Release\\net8.0\\win-x64\\publish\\T00L5ET.exe",
         "args": ["--mcp", "--workspace", "C:\\P4NTH30N"]
       }
     ],
     "binaries": [...]
   }
   ```

## Build Process

### Local Development Build

```powershell
# Complete build with MCP integration
.\scripts\build-all-with-mcp.ps1

# Build with automatic deployment
.\scripts\build-all-with-mcp.ps1 -DeployAfterBuild

# Background build
.\scripts\build-all-with-mcp.ps1 -BackgroundBuild
```

### MCP Services Deployment

```powershell
# Deploy all MCP services locally
.\scripts\deploy-mcp-services.ps1 -DeployLocal

# Deploy to VM
.\scripts\deploy-mcp-services.ps1 -DeployVM -VmName "H4NDv2-Production"

# Deploy both local and VM
.\scripts\deploy-mcp-services.ps1 -DeployLocal -DeployVM
```

### H4ND VM Deployment

```powershell
# Updated H4ND deployment with MCP support
.\scripts\deploy-h4nd-vm.ps1

# Skip build/test for faster deployment
.\scripts\deploy-h4nd-vm.ps1 -SkipBuild -SkipTests
```

## Release Pipeline

### Automated Release Process

1. **Code Commit** → Triggers GitHub Actions
2. **Build & Test** → All projects built and tested
3. **Publish Services** → RAG.McpHost and T00L5ET published
4. **Update Configs** → MCP configurations automatically updated
5. **Deploy** → Based on branch (staging/production)
6. **Verify** → Health check all MCP services

### Manual Release Process

```powershell
# Step 1: Build all projects
.\scripts\build-all-with-mcp.ps1 -Configuration Release

# Step 2: Deploy MCP services
.\scripts\deploy-mcp-services.ps1 -DeployLocal

# Step 3: Verify deployment
.\Verify-MCP-Setup.ps1

# Step 4: Test functionality
# Open Visual Studio Community and test with Ctrl+I
```

## Configuration Management

### Environment Variables

All builds automatically set these environment variables:

```powershell
$env:MONGODB_HOST = "localhost:27017"
$env:CHROME_CDP_PORT = "9222"
$env:RAG_PORT = "5100"
$env:RAG_INDEX = "p4ntheon"
$env:RAG_WORKSPACE = "C:\P4NTH30N"
```

### Service Ports

- **RAG MCP Host**: 5100
- **Chrome DevTools MCP**: 5301
- **MongoDB**: 27017
- **Chrome CDP**: 9222

## Background Job Integration

### RAG MCP Host Background Job

All releases automatically configure RAG.McpHost.exe to run as a background PowerShell job:

```powershell
# Start as background job
.\Manage-RAG-Background.ps1 -Start

# Check status
.\Manage-RAG-Background.ps1 -Status

# Stop background job
.\Manage-RAG-Background.ps1 -Stop
```

### Persistence Features

- Survives PowerShell session closure
- Automatic restart on failure
- Health monitoring
- Process cleanup

## Quality Assurance

### Automated Testing

1. **Unit Tests**: Run automatically in build pipeline
2. **Integration Tests**: MCP service health checks
3. **Configuration Validation**: MCP config file validation
4. **Service Verification**: End-to-end service testing

### Deployment Verification

```powershell
# Comprehensive verification
.\Verify-MCP-Setup.ps1

# Service health check
.\Audit-MCP-Services.ps1

# Fix any issues
.\Fix-MCP-Services.ps1
```

## Troubleshooting

### Common Build Issues

1. **Missing Dependencies**: Ensure NuGet cache is restored
2. **Configuration Conflicts**: Check for existing MCP configs
3. **Port Conflicts**: Verify ports 5100, 5301, 27017 are available
4. **Background Job Issues**: Use `Manage-RAG-Background.ps1 -Status`

### Deployment Issues

1. **Permission Errors**: Run as Administrator for local deployment
2. **VM Connectivity**: Ensure VM is running and accessible
3. **Service Failures**: Check event logs and service health
4. **MongoDB Connection**: Verify MongoDB service is running

## Maintenance

### Regular Tasks

1. **Update Dependencies**: Update NuGet packages in builds
2. **Clean Artifacts**: Remove old build artifacts
3. **Verify Configurations**: Ensure MCP configs are up to date
4. **Test Background Jobs**: Verify RAG background job functionality

### Monitoring

- Monitor GitHub Actions build status
- Check MCP service health endpoints
- Review deployment logs
- Track background job performance

## Release Notes Template

```markdown
## Release [Version] - [Date]

### MCP Services
- ✅ RAG MCP Host: Background job support
- ✅ Chrome DevTools MCP: HTTP transport
- ✅ P4NTHE0N Tools: MCP mode support
- ✅ MongoDB Integration: localhost:27017

### Configuration Updates
- Updated Visual Studio MCP configuration
- Updated WindSurf MCP configuration
- Created T00L5ET deploy manifest
- Added background job management scripts

### Build Process
- Automated build pipeline with MCP integration
- GitHub Actions workflow for CI/CD
- Enhanced deployment scripts
- Comprehensive verification process

### Known Issues
- None

### Breaking Changes
- MongoDB connection changed from remote IP to localhost
- RAG.McpHost.exe now runs as background job by default
```

This comprehensive build and deployment system ensures that all P4NTHE0N releases automatically conform to the updated MCP configuration and background job setup, providing a seamless and reliable deployment process.

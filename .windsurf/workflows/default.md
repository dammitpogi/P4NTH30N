# Default Workflow - Full Shell Access

name: default

description: Default workflow with full shell command access for general development tasks.

---

## Default Workflow Configuration

This workflow provides unrestricted access to shell commands for development, debugging, and system administration tasks within the P4NTH30N project scope.

## Capabilities

### Full Shell Command Access
- **PowerShell**: All cmdlets and scripts
- **CMD**: Legacy command prompt commands  
- **Git**: Version control operations
- **DotNET**: Build, test, publish, run commands
- **Node.js/npm**: Package management and scripts
- **File Operations**: Create, read, write, delete files
- **Process Management**: Start, stop, monitor processes
- **Network Operations**: HTTP requests, port checks, network diagnostics
- **Database Operations**: MongoDB queries, backups, restores

## Allowed Command Categories

### Development Commands
```powershell
# Build and test
dotnet build
dotnet test
dotnet run
dotnet publish

# Git operations
git add .
git commit -m "message"
git push
git pull
git status
git log

# Package management
npm install
npm run build
npm test
```

### System Commands
```powershell
# File operations
Get-ChildItem
Set-Content
Get-Content
Remove-Item
Copy-Item
Move-Item

# Process management
Get-Process
Start-Process
Stop-Process

# Network diagnostics
Test-NetConnection
Invoke-WebRequest
Test-Connection
```

### Database Commands
```powershell
# MongoDB operations
mongosh --eval "db.getCollectionNames()"
mongosh --eval "db.CRED3N7IAL.countDocuments()"
```

## Safety Constraints

While this workflow allows all shell commands, the following safety measures are in place:

### Prohibited Dangerous Operations
- `rm -rf /` - Recursive root deletion
- `format` - Disk formatting
- `diskpart` - Disk partitioning  
- `fdisk` - Disk manipulation
- `dd` - Low-level disk operations

### Project Scope Boundary
- Primary working directory: `C:\P4NTH30N`
- External access allowed for: `~/.config/`, MCP configs, system tools
- System-wide operations require explicit user confirmation

## Usage Examples

### Build and Test
```powershell
dotnet build C:\P4NTH30N\P4NTH30N.slnx --verbosity quiet
dotnet test C:\P4NTH30N\UNI7T35T --logger "console;verbosity=normal"
```

### Environment Setup
```powershell
# Start Chrome with CDP
Start-Process "chrome.exe" --args "--remote-debugging-port=9222 --incognito"

# Check MongoDB connection
Test-NetConnection -ComputerName 192.168.56.1 -Port 27017
```

### File Operations
```powershell
# Create backup
Copy-Item -Path "C:\P4NTH30N\appsettings.json" -Destination "C:\P4NTH30N\appsettings.backup.json"

# Clean build artifacts
Remove-Item -Path "C:\P4NTH30N\**\bin" -Recurse -Force
Remove-Item -Path "C:\P4NTH30N\**\obj" -Recurse -Force
```

## Integration with Workflows

This default workflow serves as the foundation for specialized workflows:
- **windfixer.md**: P4NTH30N implementation with additional constraints
- **deploy.md**: Deployment-specific operations
- **run-tests.md**: Test execution and validation

## Configuration

The workflow is controlled by WindSurf settings:
```json
{
  "windsurf.cascadeCommandsAllowList": ["*"],
  "windsurf.cascadeCommandsDenyList": [
    "rm -rf /",
    "format", 
    "diskpart",
    "fdisk",
    "dd"
  ]
}
```

## Execution

This workflow is automatically active when no specific workflow is specified. Commands can be executed directly:

```
> dotnet build
> git status  
> npm install
> Get-Process chrome
```

---

**Default workflow with full shell access enabled**

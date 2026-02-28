# P4NTHE0N System Requirements

## Minimum Requirements

- **Operating System**: Windows 10/11, macOS 12+, or Linux (Ubuntu 20.04+)
- **RAM**: 8GB minimum, 16GB recommended
- **Disk Space**: 10GB free space
- **Network**: Internet connection for package downloads

## Required Software

### .NET SDK 8.0+
**Purpose**: Build and run H0UND and H4ND agents
**Download**: https://dotnet.microsoft.com/download
**Verify**: `dotnet --version`

### MongoDB 6.0+
**Purpose**: Data persistence layer
**Download**: https://www.mongodb.com/try/download/community
**Verify**: `mongod --version`
**Default Port**: 27017

### Google Chrome
**Purpose**: Browser automation via H4ND
**Download**: https://www.google.com/chrome/
**Verify**: Chrome launches successfully

### PowerShell 5.1+ (Windows) or PowerShell 7+ (cross-platform)
**Purpose**: Script execution
**Verify**: `$PSVersionTable.PSVersion`

### Git
**Purpose**: Source code management
**Download**: https://git-scm.com/downloads
**Verify**: `git --version`

## Optional but Recommended

### ChromeDriver
**Purpose**: Selenium WebDriver for Chrome
**Note**: Will be auto-installed by setup scripts if not present
**Verify**: `chromedriver --version`

### Visual Studio Code
**Purpose**: Development environment
**Download**: https://code.visualstudio.com/

## Environment Variables

Create a `.env` file in the project root with:

```
P4NTHE0N_MONGODB_URI=mongodb://localhost:27017/P4NTHE0N
P4NTHE0N_ENVIRONMENT=Development
```

## Quick Start

1. Run prerequisites check:
   ```powershell
   ./scripts/setup/check-prerequisites.ps1
   ```

2. Install missing components:
   ```powershell
   ./scripts/setup/check-prerequisites.ps1 -Fix
   ```

3. Validate environment:
   ```powershell
   ./scripts/validate-environment.ps1
   ```

## Troubleshooting

### MongoDB Connection Failed
- Ensure MongoDB service is running
- Check firewall settings for port 27017
- Verify connection string format

### ChromeDriver Version Mismatch
- ChromeDriver version must match Chrome version
- Run setup script to auto-update: `./scripts/setup/setup-chromedriver.ps1`

### .NET Build Errors
- Ensure SDK 8.0+ is installed (not just runtime)
- Run `dotnet --list-sdks` to verify

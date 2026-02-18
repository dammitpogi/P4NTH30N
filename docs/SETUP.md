# P4NTH30N Environment Setup Guide (INFRA-001)

## Prerequisites

| Dependency | Minimum Version | Check Command |
|------------|----------------|---------------|
| **.NET SDK** | 10.0+ | `dotnet --version` |
| **MongoDB** | 7.0+ | `mongod --version` |
| **Google Chrome** | Latest stable | Check `chrome://version` |
| **ChromeDriver** | Matches Chrome major | `chromedriver --version` |
| **PowerShell** | 5.1+ | `$PSVersionTable.PSVersion` |
| **Git** | 2.30+ | `git --version` |
| **Python** | 3.8+ (for RAG) | `python --version` |

## Quick Start (< 30 minutes)

```powershell
# 1. Clone the repository
git clone https://github.com/your-org/P4NTH30N.git
cd P4NTH30N

# 2. Check prerequisites
.\scripts\setup\check-prerequisites.ps1

# 3. Setup MongoDB (requires Administrator)
.\scripts\setup\setup-mongodb.ps1 -StartService

# 4. Setup ChromeDriver (auto-matches Chrome version)
.\scripts\setup\setup-chromedriver.ps1 -AddToPath

# 5. Build the solution
dotnet build P4NTH30N.slnx

# 6. Run tests
dotnet run --project UNI7T35T\UNI7T35T.csproj

# 7. Validate entire environment
.\scripts\setup\validate-environment.ps1
```

## Detailed Setup

### Step 1: .NET SDK

Download from [dot.net](https://dot.net/download). Install the **SDK** (not just runtime).

```powershell
# Verify installation
dotnet --version
# Expected: 10.0.x or higher
```

### Step 2: MongoDB

**Option A: Automated (recommended)**
```powershell
# Requires Administrator privileges
.\scripts\setup\setup-mongodb.ps1 -StartService
```

**Option B: Manual**
1. Download from [mongodb.com/try/download](https://www.mongodb.com/try/download/community)
2. Install as Windows Service
3. Verify: `mongosh --eval "db.version()"`

### Step 3: ChromeDriver

```powershell
# Auto-detects Chrome version and downloads matching driver
.\scripts\setup\setup-chromedriver.ps1 -AddToPath

# Or manual: download from https://googlechromelabs.github.io/chrome-for-testing/
```

### Step 4: Build & Verify

```powershell
# Restore packages
dotnet restore P4NTH30N.slnx

# Build (Debug mode)
dotnet build P4NTH30N.slnx

# Run all tests (11 tests: 2 forecasting + 9 encryption)
dotnet run --project UNI7T35T\UNI7T35T.csproj
```

### Step 5: Master Encryption Key (Optional for Development)

```powershell
# Generate master key for credential encryption (INFRA-009)
.\scripts\security\generate-master-key.ps1

# Or custom path for development
.\scripts\security\generate-master-key.ps1 -KeyPath "C:\Dev\P4NTH30N\test.key"
```

### Step 6: Python Dependencies (Optional, for RAG)

```powershell
# Only needed if using the RAG/LLM pipeline (INFRA-010)
pip install faiss-cpu numpy sentence-transformers torch
```

## Configuration

Configuration uses a layered hierarchy (see INFRA-002):

```
appsettings.json                  # Base defaults (committed)
appsettings.Development.json      # Dev overrides (committed)
appsettings.Staging.json          # Staging overrides (gitignored)
appsettings.Production.json       # Production overrides (gitignored)
Environment variables             # Highest priority overrides
```

### Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `P4NTH30N_ENVIRONMENT` | Active environment | `Development` |
| `P4NTH30N_MONGODB_URI` | MongoDB connection string | `mongodb://localhost:27017/P4NTH30N` |
| `P4NTH30N_MONGODB_DB` | Database name | `P4NTH30N` |
| `P4NTH30N__Security__MasterKeyPath` | Encryption key path | `C:\ProgramData\P4NTH30N\master.key` |
| `P4NTH30N__Safety__DailyLossLimit` | Daily loss cap (USD) | `100` |

## Environment Validation

Run the validation script to confirm everything is operational:

```powershell
# Development (default)
.\scripts\setup\validate-environment.ps1

# Production (stricter checks)
.\scripts\setup\validate-environment.ps1 -Environment Production -Strict
```

The validator checks:
- .NET SDK version and build capability
- MongoDB connectivity and database existence
- Chrome/ChromeDriver version matching
- Configuration file presence and validity
- Master encryption key (required for Production)
- Environment variables

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `scripts/setup/check-prerequisites.ps1` | Verify all dependencies installed |
| `scripts/setup/setup-mongodb.ps1` | Install and initialize MongoDB |
| `scripts/setup/setup-chromedriver.ps1` | Auto-download matching ChromeDriver |
| `scripts/setup/validate-environment.ps1` | End-to-end environment validation |
| `scripts/security/generate-master-key.ps1` | Generate AES-256 master key |

## Troubleshooting

### MongoDB won't start
```powershell
# Check if port 27017 is in use
netstat -an | findstr 27017

# Start manually
mongod --dbpath C:\data\db
```

### ChromeDriver version mismatch
```powershell
# Force re-download matching version
.\scripts\setup\setup-chromedriver.ps1 -Force
```

### Build fails with package errors
```powershell
dotnet restore P4NTH30N.slnx
dotnet build P4NTH30N.slnx --no-incremental
```

### Master key permission denied
```powershell
# Run as Administrator, or use a dev-friendly path
.\scripts\security\generate-master-key.ps1 -KeyPath "$env:USERPROFILE\.p4nth30n\master.key"
```

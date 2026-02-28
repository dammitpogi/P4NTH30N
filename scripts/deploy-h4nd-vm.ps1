# OPS_014: Automated H4ND VM Deployment Pipeline
# Single-command deployment of H4ND to the VM.
# Run from host machine as Administrator.

param(
	[string]$VmName = "H4NDv2-Production",
	[string]$H4ndProject = "C:\P4NTHE0N\H4ND\H4ND.csproj",
	[string]$PublishDir = "C:\P4NTHE0N\publish\h4nd-vm-full",
	[string]$VmDeployDir = "C:\H4ND",
	[string]$Configuration = "Release",
	[switch]$SkipBuild,
	[switch]$SkipTests
)

$ErrorActionPreference = "Stop"

Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "OPS_014: H4ND VM Deployment Pipeline" -ForegroundColor Cyan
Write-Host "VM: $VmName | Config: $Configuration" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

# --- Step 1: Build & Test ---
if (-not $SkipBuild) {
	Write-Host "[1/5] Building H4ND..." -ForegroundColor Yellow
	dotnet build $H4ndProject -c $Configuration --no-incremental
	if ($LASTEXITCODE -ne 0) { throw "Build failed" }
	Write-Host "  Build succeeded" -ForegroundColor Green
} else {
	Write-Host "[1/5] Build skipped" -ForegroundColor DarkGray
}

if (-not $SkipTests) {
	Write-Host "[2/5] Running tests..." -ForegroundColor Yellow
	dotnet run --project C:\P4NTHE0N\UNI7T35T\UNI7T35T.csproj
	if ($LASTEXITCODE -ne 0) { throw "Tests failed" }
	Write-Host "  Tests passed" -ForegroundColor Green
} else {
	Write-Host "[2/5] Tests skipped" -ForegroundColor DarkGray
}

# --- Step 2: Publish ---
Write-Host "[3/5] Publishing H4ND..." -ForegroundColor Yellow
if (Test-Path $PublishDir) { Remove-Item $PublishDir -Recurse -Force }
dotnet publish $H4ndProject -c $Configuration -r win-x64 -o $PublishDir
if ($LASTEXITCODE -ne 0) { throw "Publish failed" }

# Copy VM-specific appsettings with updated MCP configuration
$vmAppSettings = @{
	P4NTHHE0N = @{
		Database = @{
			ConnectionString = "mongodb://localhost:27017/P4NTH30N?directConnection=true"
			DatabaseName = "P4NTHE0N"
		}
		H4ND = @{
			Cdp = @{
				HostIp = "localhost"
				Port = 9222
			}
			MCP = @{
				RAG = @{
					Enabled = $true
					Host = "localhost"
					Port = 5100
				}
				ChromeDevTools = @{
					Enabled = $true
					Host = "localhost"
					Port = 5301
				}
				Tools = @{
					Enabled = $true
					Workspace = "C:\P4NTH30N"
				}
			}
		}
	}
} | ConvertTo-Json -Depth 10
$vmAppSettings | Out-File "$PublishDir\appsettings.json" -Encoding UTF8 -Force
Write-Host "  Published to $PublishDir" -ForegroundColor Green

# --- Step 3: Stop H4ND on VM ---
Write-Host "[4/5] Deploying to VM..." -ForegroundColor Yellow
$vm = Get-VM -Name $VmName -ErrorAction SilentlyContinue
if ($null -eq $vm -or $vm.State -ne "Running") {
	Write-Host "  VM '$VmName' is not running. Starting..." -ForegroundColor Yellow
	Start-VM $VmName -ErrorAction Stop
	Start-Sleep -Seconds 30
}

try {
	Invoke-Command -VMName $VmName -ScriptBlock {
		Stop-Process -Name H4ND -Force -ErrorAction SilentlyContinue
		Start-Sleep -Seconds 2
	} -ErrorAction Stop
	Write-Host "  H4ND process stopped on VM" -ForegroundColor Green
} catch {
	Write-Host "  Could not stop H4ND (may not be running): $_" -ForegroundColor Yellow
}

# --- Step 4: Copy files ---
$session = New-PSSession -VMName $VmName -ErrorAction Stop
try {
	Invoke-Command -Session $session -ScriptBlock {
		if (-not (Test-Path $using:VmDeployDir)) {
			New-Item -ItemType Directory -Path $using:VmDeployDir -Force | Out-Null
		}
	}

	Copy-Item -ToSession $session -Path "$PublishDir\*" -Destination $VmDeployDir -Recurse -Force
	Write-Host "  Files deployed to ${VmName}:${VmDeployDir}" -ForegroundColor Green
} finally {
	Remove-PSSession $session
}

# --- Step 5: Start H4ND ---
Write-Host "[5/5] Starting H4ND on VM..." -ForegroundColor Yellow
try {
	Invoke-Command -VMName $VmName -ScriptBlock {
		Set-Location $using:VmDeployDir
		Start-Process -FilePath ".\H4ND.exe" -ArgumentList "H4ND" -NoNewWindow
	} -ErrorAction Stop
	Write-Host "  H4ND started on VM" -ForegroundColor Green
} catch {
	Write-Host "  Failed to start H4ND: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host ("=" * 60) -ForegroundColor Cyan

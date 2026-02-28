# Check for log files and burnin output
$logPaths = @(
    "C:\P4NTHE0N\H4ND\bin\Release\net10.0-windows7.0\win-x64\burnin_output.log",
    "C:\P4NTHE0N\H4ND\bin\Release\net10.0-windows7.0\win-x64\logs\*.log",
    "C:\P4NTHE0N\H4ND\bin\Release\net10.0-windows7.0\logs\*.log"
)

foreach ($path in $logPaths) {
    $files = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
    if ($files) {
        Write-Host "`n=== Found log files: $path ==="
        $files | ForEach-Object {
            Write-Host "`n--- $($_.Name) ---"
            Get-Content $_.FullName -Tail 50 -ErrorAction SilentlyContinue
        }
    }
}

# Also check temp directories for any burnin output
$tempLogs = Get-ChildItem -Path $env:TEMP -Filter "*burnin*" -ErrorAction SilentlyContinue
if ($tempLogs) {
    Write-Host "`n=== Temp burnin files ==="
    $tempLogs | ForEach-Object {
        Write-Host "`n--- $($_.Name) ---"
        Get-Content $_.FullName -Tail 30 -ErrorAction SilentlyContinue
    }
}

# Check for any stdout/stderr capture
Write-Host "`n=== Checking stdout redirect ==="
$redirectedLog = "C:\P4NTHE0N\H4ND\bin\Release\net10.0-windows7.0\win-x64\stdout.log"
if (Test-Path $redirectedLog) {
    Get-Content $redirectedLog -Tail 50
} else {
    Write-Host "No stdout.log found"
}

# Check MongoDB connectivity from the H4ND perspective
Write-Host "`n=== MongoDB Connectivity Test ==="
$mongolog = "C:\P4NTHE0N\H4ND\bin\Release\net10.0-windows7.0\win-x64\mongo_test.log"
if (Test-Path $mongolog) {
    Get-Content $mongolog -Tail 20
} else {
    Write-Host "No mongo_test.log found"
}

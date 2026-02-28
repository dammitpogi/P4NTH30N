# Wait and check for VB-Cable
Start-Sleep -Seconds 3

# Export audio devices
& 'C:\P4NTHE0N\SoundVolumeView\SoundVolumeView.exe' /scomma 'C:\P4NTHE0N\after_vbcable.csv'
Start-Sleep -Seconds 1

# Look for CABLE devices
$lines = Get-Content 'C:\P4NTHE0N\after_vbcable.csv'
Write-Host 'Audio devices after VB-Cable installation:'
Write-Host '==========================================='

$cableFound = $false
foreach ($line in $lines) {
    if ($line -like '*CABLE*') {
        $parts = $line -split ','
        Write-Host "Found: $($parts[0]) - Type: $($parts[1]) - Direction: $($parts[2])"
        $cableFound = $true
    }
}

if (-not $cableFound) {
    Write-Host 'No CABLE devices found yet. Checking all recording devices...'
    foreach ($line in $lines[1..15]) {
        $parts = $line -split ','
        if ($parts[2] -eq 'Capture') {
            Write-Host "  Recording: $($parts[0])"
        }
    }
}

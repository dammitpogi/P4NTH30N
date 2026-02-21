# Check for Stereo Mix
& 'C:\P4NTH30N\SoundVolumeView\SoundVolumeView.exe' /scomma 'C:\P4NTH30N\check_stereomix.csv'
Start-Sleep -Seconds 1

# Read the CSV
$lines = Get-Content 'C:\P4NTH30N\check_stereomix.csv'
$header = $lines[0]
Write-Host "Audio Devices:"
Write-Host "=============="

foreach ($line in $lines[1..10]) {
    $parts = $line -split ','
    if ($parts[2] -eq 'Capture') {
        Write-Host "Recording: $($parts[0]) - $($parts[3])"
    }
}

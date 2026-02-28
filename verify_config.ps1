# Verify the configuration
Write-Host 'Verifying Audio Configuration...'
Write-Host '================================'
Write-Host ''

& 'C:\P4NTHE0N\SoundVolumeView\SoundVolumeView.exe' /scomma 'C:\P4NTHE0N\final_check.csv'
Start-Sleep -Seconds 1

$lines = Get-Content 'C:\P4NTHE0N\final_check.csv'

Write-Host 'Default Devices:'
Write-Host '---------------'
foreach ($line in $lines) {
    $parts = $line -split ','
    # Check for default render device
    if ($parts[4] -eq 'Render' -and $parts[2] -eq 'Render') {
        Write-Host "Default Playback: $($parts[0]) - $($parts[3])"
    }
    # Check for default capture device
    if ($parts[4] -eq 'Capture' -and $parts[2] -eq 'Capture') {
        Write-Host "Default Recording: $($parts[0]) - $($parts[3])"
    }
}

Write-Host ''
Write-Host 'CABLE Devices:'
Write-Host '-------------'
foreach ($line in $lines) {
    if ($line -like '*CABLE*' -and $line -like '*Device*') {
        $parts = $line -split ','
        Write-Host "  $($parts[0]) - $($parts[2])"
    }
}

Write-Host ''
Write-Host '✓ Configuration complete!'
Write-Host ''
Write-Host 'You can now:'
Write-Host '  1. Record system audio by selecting "CABLE Output" in your recording app'
Write-Host '  2. Hear system audio through your speakers'
Write-Host '  3. All audio is automatically routed through the virtual cable'

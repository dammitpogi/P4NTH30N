# Enable microphone monitoring script
$micGuid = '9977d10f-7978-4f47-814a-c8cd14418d9e'
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture\{$micGuid}\Properties"

Write-Host "Checking microphone registry settings..."

if (Test-Path $regPath) {
    $props = Get-ItemProperty -Path $regPath
    Write-Host 'Microphone registry properties found'
    
    # Look for listen-related properties
    $listenProps = $props.PSObject.Properties | Where-Object { 
        $_.Name -like '*listen*' -or $_.Name -like '*playback*' 
    }
    
    if ($listenProps) {
        $listenProps | ForEach-Object {
            Write-Host "  $($_.Name) = $($_.Value)"
        }
    } else {
        Write-Host "  No listen/playback properties found in registry"
    }
} else {
    Write-Host "Registry path not found: $regPath"
}

# Use SoundVolumeView to enable monitoring
Write-Host ''
Write-Host 'Enabling microphone monitoring...'

# Enable Listen to this device
& 'C:\P4NTH30N\SoundVolumeView\SoundVolumeView.exe' /SetListenToThisDevice 'Beats Pill\Device\Headset Microphone\Capture' 1

Start-Sleep -Seconds 1

# Set playback device
& 'C:\P4NTH30N\SoundVolumeView\SoundVolumeView.exe' /SetPlaybackThroughDevice 'Beats Pill\Device\Headset Microphone\Capture' 'Beats Pill\Device\Speakers\Render'

Write-Host ''
Write-Host 'Microphone monitoring should now be enabled!'
Write-Host 'Try speaking into your microphone - you should hear yourself through the speakers.'

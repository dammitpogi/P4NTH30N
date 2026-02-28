# Configure Windows Audio for Recording
Write-Host 'Configuring Windows Audio for Recording...'
Write-Host '============================================'
Write-Host ''

# Step 1: Set CABLE Input as default playback device
Write-Host 'Step 1: Setting CABLE Input as default playback device...'
& 'C:\P4NTHE0N\SoundVolumeView\SoundVolumeView.exe' /SetDefault 'CABLE Input\Device\CABLE Input\Render' all
Start-Sleep -Seconds 1

# Step 2: Enable listening on CABLE Output so you can hear it
Write-Host 'Step 2: Enabling monitoring on CABLE Output...'
& 'C:\P4NTHE0N\SoundVolumeView\SoundVolumeView.exe' /SetListenToThisDevice 'CABLE Output\Device\CABLE Output\Capture' 1
Start-Sleep -Seconds 1

# Step 3: Route CABLE Output monitoring to your speakers
Write-Host 'Step 3: Routing to your speakers...'
& 'C:\P4NTHE0N\SoundVolumeView\SoundVolumeView.exe' /SetPlaybackThroughDevice 'CABLE Output\Device\CABLE Output\Capture' 'Beats Pill\Device\Speakers\Render'
Start-Sleep -Seconds 1

Write-Host ''
Write-Host 'Configuration Complete!'
Write-Host '======================='
Write-Host ''
Write-Host 'Your system is now configured:'
Write-Host '- All system audio plays through CABLE Input'
Write-Host '- CABLE Output is available as a recording device'
Write-Host '- You can hear the audio through your speakers'
Write-Host ''
Write-Host 'To record system audio, select "CABLE Output" as your recording device.'

# Script to enable microphone monitoring
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture'

if (Test-Path $regPath) {
    $devices = Get-ChildItem $regPath
    Write-Host 'Found recording devices:'
    
    foreach ($device in $devices) {
        $deviceId = $device.PSChildName
        $propertiesPath = Join-Path $device.PSPath 'Properties'
        
        if (Test-Path $propertiesPath) {
            try {
                $props = Get-ItemProperty -Path $propertiesPath -ErrorAction SilentlyContinue
                Write-Host "  Device ID: $deviceId"
            } catch {
                Write-Host "  Could not read device: $deviceId"
            }
        }
    }
} else {
    Write-Host 'Registry path not found'
}

# Alternative: Use SoundVolumeView utility approach
Write-Host ''
Write-Host 'To enable microphone monitoring manually:'
Write-Host '1. Sound Control Panel is already open'
Write-Host '2. Go to Recording tab'
Write-Host '3. Right-click microphone -> Properties'
Write-Host '4. Listen tab -> Check Listen to this device'
Write-Host '5. Select output device -> Apply -> OK'

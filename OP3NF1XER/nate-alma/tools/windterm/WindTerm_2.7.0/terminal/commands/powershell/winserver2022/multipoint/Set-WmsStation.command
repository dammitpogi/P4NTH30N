description: Modifies station information
synopses:
- Set-WmsStation [-StationId] <UInt32[]> -FriendlyName <String> [-Server <String>]
  [<CommonParameters>]
- Set-WmsStation [-StationId] <UInt32[]> -AutoLogonCredential <PSCredential> [-OverrideAdminWarning]
  [-Server <String>] [<CommonParameters>]
- Set-WmsStation [-StationId] <UInt32[]> [-DisableAutoLogon] [-Server <String>] [<CommonParameters>]
- Set-WmsStation [-StationId] <UInt32[]> -SessionHost <String> [-Server <String>]
  [<CommonParameters>]
- Set-WmsStation [-StationId] <UInt32[]> -VmName <String> [-Server <String>] [<CommonParameters>]
- Set-WmsStation [-StationId] <UInt32[]> [-LocalSessionHost] [-Server <String>] [<CommonParameters>]
- Set-WmsStation [-StationId] <UInt32[]> -DisplayOrientation <EDisplayOrientationPS>
  [-Server <String>] [<CommonParameters>]
options:
  -AutoLogonCredential PSCredential:
    required: true
  -DisableAutoLogon Switch:
    required: true
  -DisplayOrientation EDisplayOrientationPS:
    required: true
    values:
    - Portrait
    - Landscape
    - PortraitFlipped
    - LandscapeFlipped
  -FriendlyName String:
    required: true
  -LocalSessionHost Switch:
    required: true
  -OverrideAdminWarning Switch: ~
  -Server,-ComputerName String: ~
  -SessionHost String:
    required: true
  -StationId UInt32[]:
    required: true
  -VmName String:
    required: true
  -Debug,-db Switch: ~
  -ErrorAction,-ea ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -ErrorVariable,-ev String: ~
  -InformationAction,-ia ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -InformationVariable,-iv String: ~
  -OutVariable,-ov String: ~
  -OutBuffer,-ob Int32: ~
  -PipelineVariable,-pv String: ~
  -Verbose,-vb Switch: ~
  -WarningAction,-wa ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -WarningVariable,-wv String: ~

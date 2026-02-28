description: Displays the currently shared desktop to the specified sessions
synopses:
- Show-WmsDesktop [-SessionId] <UInt32[]> -Desktop <WmsDesktop> [-Server <String>]
  [<CommonParameters>]
- Show-WmsDesktop [-All] -Desktop <WmsDesktop> [-Server <String>] [<CommonParameters>]
- Show-WmsDesktop -Desktop <WmsDesktop> [-Title <String>] [-Server <String>] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Desktop WmsDesktop:
    required: true
  -Server,-ComputerName String: ~
  -SessionId UInt32[]:
    required: true
  -Title String: ~
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

description: Gets VLANs for a network switch
synopses:
- Get-NetworkSwitchVlan -CimSession <CimSession> [-Name <String>] [<CommonParameters>]
- Get-NetworkSwitchVlan -CimSession <CimSession> -VlanId <Int32> [<CommonParameters>]
- Get-NetworkSwitchVlan -CimSession <CimSession> -InstanceId <String> [<CommonParameters>]
- Get-NetworkSwitchVlan -CimSession <CimSession> -Caption <String> [<CommonParameters>]
- Get-NetworkSwitchVlan -CimSession <CimSession> -Description <String> [<CommonParameters>]
options:
  -Caption String:
    required: true
  -CimSession CimSession:
    required: true
  -Description String:
    required: true
  -InstanceId String:
    required: true
  -Name String: ~
  -VlanId Int32:
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

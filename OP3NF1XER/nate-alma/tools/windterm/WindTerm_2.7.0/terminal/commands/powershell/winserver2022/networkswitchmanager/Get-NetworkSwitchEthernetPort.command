description: Gets port information for a network switch
synopses:
- Get-NetworkSwitchEthernetPort -CimSession <CimSession> [-DeviceId <String>] [<CommonParameters>]
- Get-NetworkSwitchEthernetPort -CimSession <CimSession> [-FullDuplexEnabled] [<CommonParameters>]
- Get-NetworkSwitchEthernetPort -CimSession <CimSession> [-FullDuplexDisabled] [<CommonParameters>]
- Get-NetworkSwitchEthernetPort -CimSession <CimSession> -PortNumber <Int32> [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -DeviceId String: ~
  -FullDuplexDisabled Switch:
    required: true
  -FullDuplexEnabled Switch:
    required: true
  -PortNumber Int32:
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

description: Gets features of a network switch
synopses:
- Get-NetworkSwitchFeature -CimSession <CimSession> [-Name <String>] [<CommonParameters>]
- Get-NetworkSwitchFeature -CimSession <CimSession> [-Enabled] [<CommonParameters>]
- Get-NetworkSwitchFeature -CimSession <CimSession> [-Disabled] [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -Disabled Switch:
    required: true
  -Enabled Switch:
    required: true
  -Name String: ~
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

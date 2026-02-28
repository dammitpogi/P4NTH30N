description: Creates a VLAN for a network switch
synopses:
- New-NetworkSwitchVlan [-CimSession] <CimSession> [[-Caption] <String>] [[-Description]
  <String>] [-VlanID] <Int32> [-Name] <String> [<CommonParameters>]
options:
  -Caption String: ~
  -CimSession CimSession:
    required: true
  -Description String: ~
  -Name String:
    required: true
  -VlanID Int32:
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

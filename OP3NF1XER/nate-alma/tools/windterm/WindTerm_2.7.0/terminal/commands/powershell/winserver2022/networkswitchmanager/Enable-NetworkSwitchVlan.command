description: Enables a VLAN for a network switch
synopses:
- Enable-NetworkSwitchVlan -CimSession <CimSession> -InstanceId <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Enable-NetworkSwitchVlan -CimSession <CimSession> -Name <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Enable-NetworkSwitchVlan -CimSession <CimSession> -VlanID <Int32> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -Confirm,-cf Switch: ~
  -InstanceId String:
    required: true
  -Name String:
    required: true
  -VlanID Int32:
    required: true
  -WhatIf,-wi Switch: ~
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

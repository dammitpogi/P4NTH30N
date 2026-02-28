description: Enables an Ethernet port on a network switch
synopses:
- Enable-NetworkSwitchEthernetPort -CimSession <CimSession> -DeviceID <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Enable-NetworkSwitchEthernetPort -CimSession <CimSession> -PortNumber <Int32> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Enable-NetworkSwitchEthernetPort -CimSession <CimSession> -InputObject <CimInstance[]>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -Confirm,-cf Switch: ~
  -DeviceID String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -PortNumber Int32:
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

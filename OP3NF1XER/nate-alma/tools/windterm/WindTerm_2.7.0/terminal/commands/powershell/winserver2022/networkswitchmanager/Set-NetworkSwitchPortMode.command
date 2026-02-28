description: Sets the port mode on a network switch
synopses:
- Set-NetworkSwitchPortMode -CimSession <CimSession> [-AccessMode] -VlanID <Int32>
  -InputObject <CimInstance[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetworkSwitchPortMode -CimSession <CimSession> [-RouteMode] -IpAddress <String>
  -SubnetAddress <String> -InputObject <CimInstance[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetworkSwitchPortMode -CimSession <CimSession> [-TrunkMode] -VlanIDs <UInt16[]>
  -InputObject <CimInstance[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessMode Switch:
    required: true
  -CimSession CimSession:
    required: true
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -IpAddress String:
    required: true
  -RouteMode Switch:
    required: true
  -SubnetAddress String:
    required: true
  -TrunkMode Switch:
    required: true
  -VlanID Int32:
    required: true
  -VlanIDs UInt16[]:
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

description: Modifies properties on a VLAN on a network switch
synopses:
- Set-NetworkSwitchVlanProperty -CimSession <CimSession> [-Property <Hashtable>] -VlanId
  <Int32[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetworkSwitchVlanProperty -CimSession <CimSession> [-Property <Hashtable>] -InputObject
  <CimInstance[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -Property Hashtable: ~
  -VlanId Int32[]:
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

description: Sets the IP address on a port on a network switch
synopses:
- Set-NetworkSwitchEthernetPortIPAddress -CimSession <CimSession> -IpAddress <String>
  -SubnetAddress <String> -PortNumber <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetworkSwitchEthernetPortIPAddress -CimSession <CimSession> -IpAddress <String>
  -SubnetAddress <String> -InputObject <CimInstance[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -IpAddress String:
    required: true
  -PortNumber Int32:
    required: true
  -SubnetAddress String:
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

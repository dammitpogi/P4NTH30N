description: Creates a new virtual storage area network (SAN) on a Hyper-V host
synopses:
- New-VMSan [-CimSession <CimSession>] [-ComputerName <String>] [-Credential <PSCredential>]
  [-Name] <String> [-Note <String>] [-HostBusAdapter <CimInstance[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-VMSan [-CimSession <CimSession>] [-ComputerName <String>] [-Credential <PSCredential>]
  [-Name] <String> [-Note <String>] -WorldWideNodeName <String[]> -WorldWidePortName
  <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession: ~
  -ComputerName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -HostBusAdapter CimInstance[]: ~
  -Name,-SanName String:
    required: true
  -Note String: ~
  -WhatIf,-wi Switch: ~
  -WorldWideNodeName,-Wwnn,-NodeName,-Wwnns,-NodeNames,-WorldWideNodeNames,-NodeAddress String[]:
    required: true
  -WorldWidePortName,-Wwpn,-PortName,-Wwpns,-PortNames,-WorldWidePortNames,-PortAddress String[]:
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

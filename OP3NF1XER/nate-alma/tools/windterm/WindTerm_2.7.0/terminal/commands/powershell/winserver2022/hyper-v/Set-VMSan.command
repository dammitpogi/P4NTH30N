description: Configures a virtual storage area network (SAN) on one or more Hyper-V
  hosts
synopses:
- Set-VMSan [-Name] <String> [-HostBusAdapter <CimInstance[]>] [-Note <String>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSan [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Name] <String> -WorldWideNodeName <String[]> -WorldWidePortName <String[]> [-Note
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -HostBusAdapter CimInstance[]: ~
  -Name,-SanName String:
    required: true
  -Note String: ~
  -Passthru Switch: ~
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

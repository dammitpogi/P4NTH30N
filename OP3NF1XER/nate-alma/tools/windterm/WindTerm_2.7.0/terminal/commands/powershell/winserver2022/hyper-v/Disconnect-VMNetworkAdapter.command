description: Disconnects a virtual network adapter from a virtual switch or Ethernet
  resource pool
synopses:
- Disconnect-VMNetworkAdapter [-VMName] <String[]> [[-Name] <String[]>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Disconnect-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapter[]> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name,-VMNetworkAdapterName String[]: ~
  -Passthru Switch: ~
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapter[]:
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

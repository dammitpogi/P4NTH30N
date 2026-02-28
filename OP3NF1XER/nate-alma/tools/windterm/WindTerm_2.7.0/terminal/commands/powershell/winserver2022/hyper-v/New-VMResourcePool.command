description: Creates a resource pool
synopses:
- New-VMResourcePool [-Name] <String> [-ResourcePoolType] <VMResourcePoolType[]> [[-ParentName]
  <String[]>] [[-Paths] <String[]>] [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name String:
    required: true
  -ParentName String[]: ~
  -Paths String[]: ~
  -ResourcePoolType VMResourcePoolType[]:
    required: true
    values:
    - Memory
    - Processor
    - Ethernet
    - VHD
    - ISO
    - VFD
    - FibreChannelPort
    - FibreChannelConnection
    - PciExpress
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

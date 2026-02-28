description: Renames a resource pool on one or more Hyper-V hosts
synopses:
- Rename-VMResourcePool [-CimSession <CimSession[]>] [-Name] <String> [-ResourcePoolType]
  <VMResourcePoolType> [-NewName] <String> [-Passthru] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name String:
    required: true
  -NewName String:
    required: true
  -Passthru Switch: ~
  -ResourcePoolType VMResourcePoolType:
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

description: Deletes a resource pool from one or more virtual machine hosts
synopses:
- Remove-VMResourcePool [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Name] <String> [-ResourcePoolType] <VMResourcePoolType[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-VMResourcePool [-CimSession <CimSession[]>] [-Name] <String> [-ResourcePoolType]
  <VMResourcePoolType[]> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name String:
    required: true
  -Passthru Switch: ~
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

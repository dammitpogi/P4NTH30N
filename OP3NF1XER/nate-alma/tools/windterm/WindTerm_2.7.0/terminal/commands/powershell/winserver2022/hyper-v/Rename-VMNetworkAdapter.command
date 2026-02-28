description: Renames a virtual network adapter on a virtual machine or on the management
  operating system
synopses:
- Rename-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String[]> [[-Name] <String>] [-NewName]
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [-NewName]
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-VMNetworkAdapter [-ManagementOS] [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [[-Name] <String>] [-NewName] <String>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-VMNetworkAdapter [-VM] <VirtualMachine[]> [[-Name] <String>] [-NewName] <String>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -ManagementOS Switch:
    required: true
  -Name,-VMNetworkAdapterName String: ~
  -NewName String:
    required: true
  -Passthru Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase[]:
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

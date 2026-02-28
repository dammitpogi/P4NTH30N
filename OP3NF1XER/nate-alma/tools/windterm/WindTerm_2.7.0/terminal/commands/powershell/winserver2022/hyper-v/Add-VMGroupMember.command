description: Adds group members to a virtual machine group
synopses:
- Add-VMGroupMember [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-VM] <VirtualMachine[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMGroupMember [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-VMGroupMember] <VMGroup[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMGroupMember [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Id] <Guid> [-VM] <VirtualMachine[]> [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-VMGroupMember [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Id] <Guid> [-VMGroupMember] <VMGroup[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMGroupMember [-VMGroup] <VMGroup> [-VMGroupMember] <VMGroup[]> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMGroupMember [-VMGroup] <VMGroup> [-VM] <VirtualMachine[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Id Guid:
    required: true
  -Name String:
    required: true
  -Passthru Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMGroup VMGroup:
    required: true
  -VMGroupMember VMGroup[]:
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

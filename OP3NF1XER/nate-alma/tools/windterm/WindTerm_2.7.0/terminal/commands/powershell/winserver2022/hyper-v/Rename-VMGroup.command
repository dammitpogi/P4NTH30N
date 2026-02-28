description: Renames virtual machine groups
synopses:
- Rename-VMGroup [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-NewName] <String> [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Rename-VMGroup [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Id] <Guid> [-NewName] <String> [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Rename-VMGroup [-VMGroup] <VMGroup[]> [-NewName] <String> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Id Guid:
    required: true
  -Name String[]:
    required: true
  -NewName String:
    required: true
  -Passthru Switch: ~
  -VMGroup VMGroup[]:
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

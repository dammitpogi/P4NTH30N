description: Renames a virtual machine checkpoint
synopses:
- Rename-VMSnapshot [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-VMName] <String> [-NewName] <String> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-VMSnapshot [-VMSnapshot] <VMSnapshot> [-NewName] <String> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Rename-VMSnapshot [-VM] <VirtualMachine> [-Name] <String> [-NewName] <String> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMSnapshot,-VMCheckpoint VMSnapshot:
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

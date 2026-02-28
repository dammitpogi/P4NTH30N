description: Deletes a virtual machine checkpoint
synopses:
- Remove-VMSnapshot [-VMName] <String[]> [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [[-Name] <String[]>] [-IncludeAllChildSnapshots]
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMSnapshot [-VM] <VirtualMachine[]> [[-Name] <String[]>] [-IncludeAllChildSnapshots]
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMSnapshot [-VMSnapshot] <VMSnapshot[]> [-IncludeAllChildSnapshots] [-AsJob]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -IncludeAllChildSnapshots,-IncludeAllChildCheckpoints Switch: ~
  -Name String[]: ~
  -Passthru Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMSnapshot,-VMCheckpoint VMSnapshot[]:
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

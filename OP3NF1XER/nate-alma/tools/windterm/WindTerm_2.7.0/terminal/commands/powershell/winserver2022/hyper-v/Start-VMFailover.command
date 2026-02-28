description: Starts failover on a virtual machine
synopses:
- Start-VMFailover [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-Prepare] [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Start-VMFailover [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-AsTest] [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Start-VMFailover [-VM] <VirtualMachine[]> [-Prepare] [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Start-VMFailover [-VM] <VirtualMachine[]> [-AsTest] [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Start-VMFailover [-VMRecoverySnapshot] <VMSnapshot> [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Start-VMFailover [-VMRecoverySnapshot] <VMSnapshot> [-AsTest] [-AsJob] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AsTest Switch:
    required: true
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -Prepare Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMRecoverySnapshot,-VMRecoveryCheckpoint VMSnapshot:
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

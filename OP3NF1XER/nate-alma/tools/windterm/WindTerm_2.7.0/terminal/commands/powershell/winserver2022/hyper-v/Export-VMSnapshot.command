description: Exports a virtual machine checkpoint to disk
synopses:
- Export-VMSnapshot [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-Path] <String> -VMName <String[]> [-AsJob]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Export-VMSnapshot [-VM] <VirtualMachine[]> [-Name] <String[]> [-Path] <String> [-AsJob]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Export-VMSnapshot [-VMSnapshot] <VMSnapshot[]> [-Path] <String> [-AsJob] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name String[]:
    required: true
  -Passthru Switch: ~
  -Path String:
    required: true
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

description: Imports initial replication files for a Replica virtual machine to complete
  the initial replication when using external media as the source
synopses:
- Import-VMInitialReplication [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String[]> [-Path] <String> [-AsJob] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-VMInitialReplication [-VM] <VirtualMachine[]> [-Path] <String> [-AsJob] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-VMInitialReplication [-VMReplication] <VMReplication[]> [-Path] <String>
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -Path,-IRLoc String:
    required: true
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMReplication VMReplication[]:
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

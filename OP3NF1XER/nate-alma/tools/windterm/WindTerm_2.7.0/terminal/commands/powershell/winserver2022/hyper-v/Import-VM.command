description: Imports a virtual machine from a file
synopses:
- Import-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Path] <String> [-Register] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Path] <String> [[-VhdDestinationPath] <String>] [-Copy] [-VirtualMachinePath <String>]
  [-SnapshotFilePath <String>] [-SmartPagingFilePath <String>] [-VhdSourcePath <String>]
  [-GenerateNewId] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-VM [-CompatibilityReport] <VMCompatibilityReport> [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -CompatibilityReport VMCompatibilityReport:
    required: true
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Copy Switch:
    required: true
  -Credential PSCredential[]: ~
  -GenerateNewId Switch: ~
  -Path String:
    required: true
  -Register Switch: ~
  -SmartPagingFilePath String: ~
  -SnapshotFilePath,-CheckpointFileLocation,-SnapshotFileLocation String: ~
  -VhdDestinationPath String: ~
  -VhdSourcePath String: ~
  -VirtualMachinePath String: ~
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

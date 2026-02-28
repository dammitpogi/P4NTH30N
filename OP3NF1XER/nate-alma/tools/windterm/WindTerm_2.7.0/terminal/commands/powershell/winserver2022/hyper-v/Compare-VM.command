description: Compares a virtual machine and a virtual machine host for compatibility,
  returning a compatibility report
synopses:
- Compare-VM [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-AsJob] [-Name]
  <String> [-DestinationHost] <String> [-DestinationCredential <PSCredential>] [-IncludeStorage]
  [-DestinationStoragePath <String>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM [-CimSession <CimSession[]>] [-AsJob] [-Name] <String> [-DestinationCimSession]
  <CimSession> [-IncludeStorage] [-DestinationStoragePath <String>] [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM [-CimSession <CimSession[]>] -VirtualMachinePath <String> [-SnapshotFilePath
  <String>] [-SmartPagingFilePath <String>] [-AsJob] [-Name] <String> [-DestinationCimSession]
  <CimSession> [-Vhds <Hashtable[]>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-AsJob] [-Path] <String> [-Register] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VirtualMachinePath <String>] [-SnapshotFilePath <String>] [-SmartPagingFilePath
  <String>] [-AsJob] [-Path] <String> [[-VhdDestinationPath] <String>] [-Copy] [-VhdSourcePath
  <String>] [-GenerateNewId] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VirtualMachinePath
  <String>] [-SnapshotFilePath <String>] [-SmartPagingFilePath <String>] [-AsJob]
  [-Name] <String> [-DestinationHost] <String> [-DestinationCredential <PSCredential>]
  [-Vhds <Hashtable[]>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Compare-VM [-VirtualMachinePath <String>] [-SnapshotFilePath <String>] [-SmartPagingFilePath
  <String>] [-AsJob] [-VM] <VirtualMachine> [-DestinationHost] <String> [-DestinationCredential
  <PSCredential>] [-Vhds <Hashtable[]>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM -VirtualMachinePath <String> [-SnapshotFilePath <String>] [-SmartPagingFilePath
  <String>] [-AsJob] [-VM] <VirtualMachine> [-DestinationCimSession] <CimSession>
  [-Vhds <Hashtable[]>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Compare-VM [-CompatibilityReport] <VMCompatibilityReport> [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Compare-VM [-AsJob] [-VM] <VirtualMachine> [-DestinationCimSession] <CimSession>
  [-IncludeStorage] [-DestinationStoragePath <String>] [-ResourcePoolName <String>]
  [-RetainVhdCopiesOnSource] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compare-VM [-AsJob] [-VM] <VirtualMachine> [-DestinationHost] <String> [-DestinationCredential
  <PSCredential>] [-IncludeStorage] [-DestinationStoragePath <String>] [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -DestinationCimSession CimSession:
    required: true
  -DestinationCredential PSCredential: ~
  -DestinationHost String:
    required: true
  -DestinationStoragePath String: ~
  -GenerateNewId Switch: ~
  -IncludeStorage Switch: ~
  -Name String:
    required: true
  -Path String:
    required: true
  -Register Switch: ~
  -ResourcePoolName String: ~
  -RetainVhdCopiesOnSource Switch: ~
  -SmartPagingFilePath String: ~
  -SnapshotFilePath,-CheckpointFileLocation,-SnapshotFileLocation String: ~
  -VM VirtualMachine:
    required: true
  -VhdDestinationPath String: ~
  -VhdSourcePath String: ~
  -Vhds Hashtable[]: ~
  -VirtualMachinePath String:
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

description: Moves a virtual machine to a new Hyper-V host
synopses:
- Move-VM [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-Name] <String>
  [-DestinationHost] <String> [-DestinationCredential <PSCredential>] [-IncludeStorage]
  [-DestinationStoragePath <String>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-RemoveSourceUnmanagedVhds] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VM [-CimSession <CimSession[]>] [-Name] <String> [-DestinationCimSession] <CimSession>
  [-IncludeStorage] [-DestinationStoragePath <String>] [-ResourcePoolName <String>]
  [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds] [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Move-VM [-CimSession <CimSession[]>] [-Name] <String> [-DestinationCimSession] <CimSession>
  -VirtualMachinePath <String> [-SnapshotFilePath <String>] [-SmartPagingFilePath
  <String>] [-Vhds <Hashtable[]>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-RemoveSourceUnmanagedVhds] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VM [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-Name] <String>
  [-DestinationHost] <String> [-DestinationCredential <PSCredential>] [-VirtualMachinePath
  <String>] [-SnapshotFilePath <String>] [-SmartPagingFilePath <String>] [-Vhds <Hashtable[]>]
  [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds]
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VM [-CompatibilityReport] <VMCompatibilityReport> [-AsJob] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Move-VM [-VM] <VirtualMachine> [-DestinationCimSession] <CimSession> [-IncludeStorage]
  [-DestinationStoragePath <String>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-RemoveSourceUnmanagedVhds] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VM [-VM] <VirtualMachine> [-DestinationHost] <String> [-DestinationCredential
  <PSCredential>] [-IncludeStorage] [-DestinationStoragePath <String>] [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds] [-AsJob] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VM [-VM] <VirtualMachine> [-DestinationHost] <String> [-DestinationCredential
  <PSCredential>] [-VirtualMachinePath <String>] [-SnapshotFilePath <String>] [-SmartPagingFilePath
  <String>] [-Vhds <Hashtable[]>] [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource]
  [-RemoveSourceUnmanagedVhds] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VM [-VM] <VirtualMachine> [-DestinationCimSession] <CimSession> -VirtualMachinePath
  <String> [-SnapshotFilePath <String>] [-SmartPagingFilePath <String>] [-Vhds <Hashtable[]>]
  [-ResourcePoolName <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds]
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -CompatibilityReport VMCompatibilityReport:
    required: true
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DestinationCimSession CimSession:
    required: true
  -DestinationCredential PSCredential: ~
  -DestinationHost String:
    required: true
  -DestinationStoragePath String: ~
  -IncludeStorage Switch: ~
  -Name String:
    required: true
  -Passthru Switch: ~
  -RemoveSourceUnmanagedVhds Switch: ~
  -ResourcePoolName String: ~
  -RetainVhdCopiesOnSource Switch: ~
  -SmartPagingFilePath String: ~
  -SnapshotFilePath,-CheckpointFileLocation,-SnapshotFileLocation String: ~
  -VM VirtualMachine:
    required: true
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

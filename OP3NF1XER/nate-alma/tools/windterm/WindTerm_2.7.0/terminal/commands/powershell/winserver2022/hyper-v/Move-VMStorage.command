description: Moves the storage of a virtual machine
synopses:
- Move-VMStorage [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-DestinationStoragePath] <String> [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds] [-AllowUnverifiedPaths]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VMStorage [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-VirtualMachinePath <String>] [-SnapshotFilePath
  <String>] [-SmartPagingFilePath <String>] [-Vhds <Hashtable[]>] [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds] [-AllowUnverifiedPaths]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VMStorage [-VM] <VirtualMachine> [-DestinationStoragePath] <String> [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds] [-AllowUnverifiedPaths]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-VMStorage [-VM] <VirtualMachine> [-VirtualMachinePath <String>] [-SnapshotFilePath
  <String>] [-SmartPagingFilePath <String>] [-Vhds <Hashtable[]>] [-ResourcePoolName
  <String>] [-RetainVhdCopiesOnSource] [-RemoveSourceUnmanagedVhds] [-AllowUnverifiedPaths]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowUnverifiedPaths Switch: ~
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DestinationStoragePath String:
    required: true
  -Name,-VMName String:
    required: true
  -RemoveSourceUnmanagedVhds Switch: ~
  -ResourcePoolName String: ~
  -RetainVhdCopiesOnSource Switch: ~
  -SmartPagingFilePath String: ~
  -SnapshotFilePath,-CheckpointFileLocation,-SnapshotFileLocation String: ~
  -VM VirtualMachine:
    required: true
  -Vhds Hashtable[]: ~
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

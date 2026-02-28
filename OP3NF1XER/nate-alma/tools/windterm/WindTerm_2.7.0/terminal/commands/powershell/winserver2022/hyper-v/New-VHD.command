description: Creates one or more new virtual hard disks
synopses:
- New-VHD [-Path] <String[]> [-SizeBytes] <UInt64> [-Dynamic] [-BlockSizeBytes <UInt32>]
  [-LogicalSectorSizeBytes <UInt32>] [-PhysicalSectorSizeBytes <UInt32>] [-AsJob]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-VHD [-Path] <String[]> [-ParentPath] <String> [[-SizeBytes] <UInt64>] [-Differencing]
  [-BlockSizeBytes <UInt32>] [-PhysicalSectorSizeBytes <UInt32>] [-AsJob] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-VHD [-Path] <String[]> [-SizeBytes] <UInt64> [-Fixed] [-BlockSizeBytes <UInt32>]
  [-LogicalSectorSizeBytes <UInt32>] [-PhysicalSectorSizeBytes <UInt32>] [-AsJob]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-VHD [-Path] <String[]> -SourceDisk <UInt32> [-Fixed] [-BlockSizeBytes <UInt32>]
  [-AsJob] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-VHD [-Path] <String[]> -SourceDisk <UInt32> [-Dynamic] [-BlockSizeBytes <UInt32>]
  [-AsJob] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BlockSizeBytes UInt32: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Differencing Switch: ~
  -Dynamic Switch: ~
  -Fixed Switch:
    required: true
  -LogicalSectorSizeBytes UInt32:
    values:
    - '512'
    - '4096'
  -ParentPath String:
    required: true
  -Path String[]:
    required: true
  -PhysicalSectorSizeBytes UInt32:
    values:
    - '512'
    - '4096'
  -SizeBytes UInt64:
    required: true
  -SourceDisk,-Number UInt32:
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

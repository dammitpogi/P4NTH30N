description: Formats one or more existing volumes or a new volume on an existing partition
synopses:
- Format-Volume [-DriveLetter] <Char[]> [-FileSystem <String>] [-NewFileSystemLabel
  <String>] [-AllocationUnitSize <UInt32>] [-Full] [-Force] [-Compress] [-ShortFileNameSupport
  <Boolean>] [-SetIntegrityStreams <Boolean>] [-UseLargeFRS] [-DisableHeatGathering]
  [-IsDAX <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Format-Volume -ObjectId <String[]> [-FileSystem <String>] [-NewFileSystemLabel <String>]
  [-AllocationUnitSize <UInt32>] [-Full] [-Force] [-Compress] [-ShortFileNameSupport
  <Boolean>] [-SetIntegrityStreams <Boolean>] [-UseLargeFRS] [-DisableHeatGathering]
  [-IsDAX <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Format-Volume -Path <String[]> [-FileSystem <String>] [-NewFileSystemLabel <String>]
  [-AllocationUnitSize <UInt32>] [-Full] [-Force] [-Compress] [-ShortFileNameSupport
  <Boolean>] [-SetIntegrityStreams <Boolean>] [-UseLargeFRS] [-DisableHeatGathering]
  [-IsDAX <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Format-Volume -FileSystemLabel <String[]> [-FileSystem <String>] [-NewFileSystemLabel
  <String>] [-AllocationUnitSize <UInt32>] [-Full] [-Force] [-Compress] [-ShortFileNameSupport
  <Boolean>] [-SetIntegrityStreams <Boolean>] [-UseLargeFRS] [-DisableHeatGathering]
  [-IsDAX <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Format-Volume [-Partition <CimInstance>] [-FileSystem <String>] [-NewFileSystemLabel
  <String>] [-AllocationUnitSize <UInt32>] [-Full] [-Force] [-Compress] [-ShortFileNameSupport
  <Boolean>] [-SetIntegrityStreams <Boolean>] [-UseLargeFRS] [-DisableHeatGathering]
  [-IsDAX <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Format-Volume -InputObject <CimInstance[]> [-FileSystem <String>] [-NewFileSystemLabel
  <String>] [-AllocationUnitSize <UInt32>] [-Full] [-Force] [-Compress] [-ShortFileNameSupport
  <Boolean>] [-SetIntegrityStreams <Boolean>] [-UseLargeFRS] [-DisableHeatGathering]
  [-IsDAX <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllocationUnitSize,-ClusterSize UInt32: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Compress Switch: ~
  -Confirm,-cf Switch: ~
  -DisableHeatGathering Switch: ~
  -DriveLetter Char[]:
    required: true
  -FileSystem String:
    values:
    - FAT
    - FAT32
    - exFAT
    - NTFS
    - ReFS
  -FileSystemLabel String[]:
    required: true
  -Force Switch: ~
  -Full Switch: ~
  -InputObject CimInstance[]:
    required: true
  -IsDAX Boolean: ~
  -NewFileSystemLabel String: ~
  -ObjectId,-Id String[]:
    required: true
  -Partition CimInstance: ~
  -Path String[]:
    required: true
  -SetIntegrityStreams Boolean: ~
  -ShortFileNameSupport Boolean: ~
  -ThrottleLimit Int32: ~
  -UseLargeFRS Switch: ~
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

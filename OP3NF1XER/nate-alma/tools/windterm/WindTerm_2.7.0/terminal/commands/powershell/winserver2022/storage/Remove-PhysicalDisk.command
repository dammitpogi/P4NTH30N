description: Removes a physical disk from a specified storage pool
synopses:
- Remove-PhysicalDisk [-StoragePool] <CimInstance> -PhysicalDisks <CimInstance[]>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> -VirtualDiskUniqueId <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> -VirtualDiskName <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> -VirtualDiskFriendlyName <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> [-VirtualDisk] <CimInstance>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> -StoragePoolUniqueId <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> -StoragePoolName <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-PhysicalDisk -PhysicalDisks <CimInstance[]> -StoragePoolFriendlyName <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -PhysicalDisks CimInstance[]:
    required: true
  -StoragePool CimInstance:
    required: true
  -StoragePoolFriendlyName String:
    required: true
  -StoragePoolName String:
    required: true
  -StoragePoolUniqueId String:
    required: true
  -ThrottleLimit Int32: ~
  -VirtualDisk CimInstance:
    required: true
  -VirtualDiskFriendlyName String:
    required: true
  -VirtualDiskName String:
    required: true
  -VirtualDiskUniqueId String:
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
